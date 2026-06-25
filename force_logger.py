"""
force_logger.py
PBA Systems — Force Control Data Logger
Application Note: PBA-AN-001-2025

Connects to an ACS SPiiPlus controller via Ethernet and logs
analogue input (AIN) force sensor data to a CSV file.

Requirements:
    pip install acspy numpy pandas

Usage:
    python force_logger.py --ip 10.0.0.100 --duration 30 --output force_log.csv
"""

import argparse
import csv
import time
import sys
from datetime import datetime

import numpy as np

# ── CONFIGURATION ──────────────────────────────────────────────────────────────
ACS_IP          = "10.0.0.100"   # ACS controller IP
ACS_PORT        = 701            # Default ACS Ethernet port
SAMPLE_RATE     = 100            # [Hz]
DURATION        = 30             # [s] — default logging duration
OUTPUT_FILE     = "force_log.csv"
AIN_CHANNEL     = 0              # 0-indexed (AIN 1 = index 0)
SENSOR_SCALE    = 100.0          # [N/V] — must match ACSPL+ SENSOR_SCALE
FORCE_OFFSET    = 0.0            # [V]   — updated from ACS global at runtime
# ───────────────────────────────────────────────────────────────────────────────


def connect_acs(ip: str, port: int = 701):
    """
    Connect to ACS SPiiPlus controller via Ethernet.
    Returns the ACS communication object.
    Raises RuntimeError if connection fails.
    """
    try:
        import acspy.acsc as acsc
        handle = acsc.openCommEthernetTCP(ip, port)
        if handle == acsc.INVALID:
            raise RuntimeError(f"ACS connection failed: {ip}:{port}")
        print(f"[OK] Connected to ACS controller at {ip}:{port}")
        return acsc, handle
    except ImportError:
        print("[ERROR] 'acspy' not installed. Run: pip install acspy")
        sys.exit(1)


def read_force_offset(acsc, handle) -> float:
    """
    Read the force_offset global variable from the ACS controller
    (set during sensor zeroing in the ACSPL+ procedure).
    """
    try:
        offset = acsc.readReal(handle, acsc.NONE, "force_offset", 0, 0)
        print(f"[OK] Force offset read from ACS: {offset:.4f} V")
        return float(offset)
    except Exception as exc:
        print(f"[WARN] Could not read force_offset from ACS ({exc}). Using 0.0 V.")
        return 0.0


def read_ain(acsc, handle, channel: int) -> float:
    """Read AIN voltage from the specified channel (0-indexed)."""
    return float(acsc.getAnalogInput(handle, 0, channel))


def read_axis_state(acsc, handle, axis: int = 0) -> str:
    """Return a human-readable axis state string."""
    try:
        mflags = acsc.getMflags(handle, axis)
        enabled = bool(mflags & 0x1)
        return "ENABLED" if enabled else "DISABLED"
    except Exception:
        return "UNKNOWN"


def log_force(
    ip: str,
    duration: float,
    output_file: str,
    sample_rate: float,
    ain_channel: int,
    sensor_scale: float,
) -> None:
    """
    Main logging loop.

    Connects to the ACS controller, reads the force offset,
    then samples AIN at the requested rate for `duration` seconds.
    Writes results to a UTF-8 CSV file.
    """
    acsc, handle = connect_acs(ip)

    # Read zero-offset from ACS global variable set during zeroing step
    force_offset = read_force_offset(acsc, handle)

    # Derive sample interval
    sample_interval = 1.0 / sample_rate

    # Try to read current force setpoint from ACS global
    try:
        force_setpoint = float(
            acsc.readReal(handle, acsc.NONE, "force_setpoint", 0, 0)
        )
    except Exception:
        force_setpoint = 0.0

    print(f"[INFO] Logging {duration:.0f}s at {sample_rate:.0f} Hz → {output_file}")
    print(f"       AIN channel : {ain_channel}  (AIN {ain_channel + 1})")
    print(f"       Sensor scale: {sensor_scale} N/V")
    print(f"       Force offset: {force_offset:.4f} V")
    print(f"       Force setpt : {force_setpoint:.2f} N")
    print("Press Ctrl+C to stop early.\n")

    rows = []
    t_start = time.perf_counter()
    sample_count = 0

    try:
        while True:
            t_now = time.perf_counter()
            elapsed = t_now - t_start

            if elapsed >= duration:
                break

            # Read sensor
            ain_v = read_ain(acsc, handle, ain_channel)
            force_n = (ain_v - force_offset) * sensor_scale
            axis_state = read_axis_state(acsc, handle)

            rows.append({
                "timestamp_ms": round(elapsed * 1000),
                "time_s": round(elapsed, 4),
                "ain_voltage_V": round(ain_v, 6),
                "force_N": round(force_n, 4),
                "force_setpoint_N": round(force_setpoint, 4),
                "axis_state": axis_state,
            })

            sample_count += 1

            # Progress print every second
            if sample_count % int(sample_rate) == 0:
                print(f"  t={elapsed:6.1f}s  AIN={ain_v:+.4f}V  "
                      f"F={force_n:+7.3f}N  [{axis_state}]")

            # Refresh setpoint each second
            if sample_count % int(sample_rate) == 0:
                try:
                    force_setpoint = float(
                        acsc.readReal(handle, acsc.NONE, "force_setpoint", 0, 0)
                    )
                except Exception:
                    pass

            # Sleep for remainder of interval
            t_next = t_start + sample_count * sample_interval
            sleep_time = t_next - time.perf_counter()
            if sleep_time > 0:
                time.sleep(sleep_time)

    except KeyboardInterrupt:
        print("\n[INFO] Logging stopped by user.")

    finally:
        acsc.closeComm(handle)
        print(f"[OK] ACS connection closed. {len(rows)} samples recorded.")

    # Write CSV
    if rows:
        fieldnames = list(rows[0].keys())
        with open(output_file, "w", newline="", encoding="utf-8") as f:
            writer = csv.DictWriter(f, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(rows)
        print(f"[OK] Data saved to: {output_file}")

        # Quick statistics
        forces = np.array([r["force_N"] for r in rows])
        print(f"\n── Force Summary ──────────────────────────")
        print(f"   Samples  : {len(forces)}")
        print(f"   Mean     : {forces.mean():+.3f} N")
        print(f"   Std dev  : {forces.std():.4f} N  (RMS noise)")
        print(f"   Min / Max: {forces.min():+.3f} / {forces.max():+.3f} N")
    else:
        print("[WARN] No data recorded.")


# ── ENTRY POINT ────────────────────────────────────────────────────────────────
if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="PBA Systems — ACS Force Logger (PBA-AN-001-2025)"
    )
    parser.add_argument("--ip",       default=ACS_IP,      help="ACS controller IP")
    parser.add_argument("--duration", default=DURATION,    type=float, help="Log duration [s]")
    parser.add_argument("--output",   default=OUTPUT_FILE, help="Output CSV file path")
    parser.add_argument("--rate",     default=SAMPLE_RATE, type=float, help="Sample rate [Hz]")
    parser.add_argument("--channel",  default=AIN_CHANNEL, type=int,   help="AIN channel (0-indexed)")
    parser.add_argument("--scale",    default=SENSOR_SCALE,type=float, help="Sensor scale [N/V]")
    args = parser.parse_args()

    log_force(
        ip=args.ip,
        duration=args.duration,
        output_file=args.output,
        sample_rate=args.rate,
        ain_channel=args.channel,
        sensor_scale=args.scale,
    )
