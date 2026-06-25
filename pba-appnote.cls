%% =============================================================================
%% pba-appnote.cls  —  PBA Systems Application Note Document Class
%% Version  : 1.0
%% Date     : 2025-06-01
%% Standard : IEC/IEEE 82079-1:2019 | FAIR Data Principles | ANSI Z535.6
%%
%% AUTHORS: PBA Systems R&D / University of Moratuwa Collaboration
%%
%% USAGE:
%%   \documentclass{pba-appnote}
%%   Set metadata in main.tex using the \AN... commands (see below).
%% =============================================================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{pba-appnote}[2025/06/01 v1.0 PBA Systems Application Note]

%% ─── BASE CLASS ──────────────────────────────────────────────────────────────
\LoadClass[11pt, a4paper]{article}

%% ─── CORE PACKAGES ───────────────────────────────────────────────────────────
\RequirePackage[
  a4paper,
  top=28mm, bottom=25mm,
  left=22mm, right=22mm,
  headheight=15pt
]{geometry}

\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{lmodern}
\RequirePackage{microtype}

%% Graphics & Color
\RequirePackage{xcolor}
\RequirePackage{graphicx}
\RequirePackage[most, breakable]{tcolorbox}

%% Layout & Headers
\RequirePackage{fancyhdr}
\RequirePackage[explicit]{titlesec}
\RequirePackage{titletoc}
\RequirePackage{etoolbox}

%% Math & Units
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage[per-mode=symbol]{siunitx}

%% Tables
\RequirePackage{booktabs}
\RequirePackage{longtable}
\RequirePackage{tabularx}
\RequirePackage{array}
\RequirePackage{multirow}
\RequirePackage{colortbl}

%% Code Listings
\RequirePackage{listings}

%% Lists & Enumerations
\RequirePackage{enumitem}

%% Figures
\RequirePackage[font=small, labelfont=bf]{caption}
\RequirePackage{subcaption}
\RequirePackage{float}
\RequirePackage{placeins}

%% References & Links
\RequirePackage[
  colorlinks=true,
  linkcolor=PBABlue,
  citecolor=PBABlue,
  urlcolor=PBAAccent,
  bookmarks=true,
  pdfusetitle
]{hyperref}
\RequirePackage{fontawesome5}
\RequirePackage[capitalise, noabbrev]{cleveref}
\RequirePackage[backend=biber, style=ieee, sorting=none]{biblatex}

%% Date
\RequirePackage{datetime2}
\RequirePackage{ifthen}


%% =============================================================================
%%  COLOR PALETTE
%%  TODO: Replace these hex values with your actual PBA Systems brand colors.
%%  The Accent color is used for headings and callout borders.
%% =============================================================================
\definecolor{PBABlue}{HTML}{1A3A6B}        %% Primary navy blue
\definecolor{PBAAccent}{HTML}{E8500A}      %% Orange accent
\definecolor{PBADark}{HTML}{1A1A2E}        %% Near-black for title text
\definecolor{PBAGray}{HTML}{4A4A4A}        %% Body text
\definecolor{PBALightGray}{HTML}{F5F5F5}   %% Surface background
\definecolor{PBABorderGray}{HTML}{D0D0D0}  %% Rule / border lines
\definecolor{PBATableHeader}{HTML}{1A3A6B} %% Table header fill

%% ANSI Z535.6 Signal Word Colors
\definecolor{DangerRed}{HTML}{CC0000}
\definecolor{DangerBg}{HTML}{FFEBEB}
\definecolor{WarningOrange}{HTML}{BF4600}
\definecolor{WarningBg}{HTML}{FFF3E0}
\definecolor{CautionAmber}{HTML}{8C6D00}
\definecolor{CautionBg}{HTML}{FFFDE7}
\definecolor{NoteBlue}{HTML}{0055AA}
\definecolor{NoteBg}{HTML}{E8F0FB}
\definecolor{TipGreen}{HTML}{2E7D32}
\definecolor{TipBg}{HTML}{E8F5E9}

%% Code Highlight Colors
\definecolor{CodeBg}{HTML}{F8F8F8}
\definecolor{CodeBorder}{HTML}{DEDEDE}
\definecolor{PyKeyword}{HTML}{0000CD}
\definecolor{PyBuiltin}{HTML}{6600AA}
\definecolor{PyString}{HTML}{B22222}
\definecolor{PyComment}{HTML}{228B22}
\definecolor{PyNumber}{HTML}{B05A00}
\definecolor{ACSKeyword}{HTML}{8B0000}
\definecolor{ACSFunc}{HTML}{00008B}
\definecolor{ACSComment}{HTML}{3A6B00}
\definecolor{ACSString}{HTML}{8B4513}
\definecolor{ACSNumber}{HTML}{4B0082}


%% =============================================================================
%%  DOCUMENT METADATA COMMANDS
%%  Call these in main.tex BEFORE \begin{document}
%% =============================================================================
\newcommand{\ANnumber}[1]{\gdef\@ANnumber{#1}}
\newcommand{\ANtitle}[1]{\gdef\@ANtitle{#1}}
\newcommand{\ANversion}[1]{\gdef\@ANversion{#1}}
\newcommand{\ANdate}[1]{\gdef\@ANdate{#1}}
\newcommand{\ANauthor}[1]{\gdef\@ANauthor{#1}}
\newcommand{\ANreviewer}[1]{\gdef\@ANreviewer{#1}}
\newcommand{\ANclassification}[1]{\gdef\@ANclassification{#1}}
\newcommand{\ANsystem}[1]{\gdef\@ANsystem{#1}}
\newcommand{\ANkeywords}[1]{\gdef\@ANkeywords{#1}}
\newcommand{\ANrelated}[1]{\gdef\@ANrelated{#1}}
\newcommand{\ANlicense}[1]{\gdef\@ANlicense{#1}}

%% Safe defaults (shown if user forgets to set a field)
\ANnumber{PBA-AN-XXX-YYYY}
\ANtitle{[Application Note Title]}
\ANversion{1.0}
\ANdate{\today}
\ANauthor{[Author]}
\ANreviewer{[Reviewer]}
\ANclassification{Internal}
\ANsystem{[System / Machine Model]}
\ANkeywords{[keyword1, keyword2, keyword3]}
\ANrelated{---}
\ANlicense{PBA Systems Proprietary — see Section~\ref{sec:metadata}}


%% =============================================================================
%%  PAGE STYLE (HEADER / FOOTER)
%% =============================================================================
\pagestyle{fancy}
\fancyhf{}

%% Header
\fancyhead[L]{%
  \textcolor{PBABlue}{\footnotesize\textbf{\@ANnumber}}%
}
\fancyhead[C]{%
  \textcolor{PBAGray}{\footnotesize\@ANtitle}%
}
\fancyhead[R]{%
  \textcolor{PBAGray}{\footnotesize Rev~\@ANversion}%
}

%% Footer
\fancyfoot[L]{%
  \textcolor{PBAGray}{\footnotesize\textit{PBA Systems Pty Ltd}}%
}
\fancyfoot[C]{%
  \textcolor{PBAGray}{\footnotesize\thepage}%
}
\fancyfoot[R]{%
  \textcolor{PBAGray}{\footnotesize\@ANclassification}%
}

\renewcommand{\headrulewidth}{0.5pt}
\renewcommand{\headrule}{\hbox to\headwidth{\color{PBABlue}\leaders\hrule height \headrulewidth\hfill}}
\renewcommand{\footrulewidth}{0.3pt}
\renewcommand{\footrule}{\hbox to\headwidth{\color{PBABorderGray}\leaders\hrule height \footrulewidth\hfill}}

%% Suppress header/footer on the cover page
\fancypagestyle{coverpage}{%
  \fancyhf{}
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}
}


%% =============================================================================
%%  SECTION TITLE FORMATTING
%% =============================================================================
\titleformat{\section}
  {\color{PBABlue}\large\bfseries}
  {\thesection}
  {0.8em}
  {#1}
  [\vspace{-4pt}\color{PBAAccent}\rule{\linewidth}{1.5pt}]

\titleformat{\subsection}
  {\color{PBABlue}\normalsize\bfseries}
  {\thesubsection}
  {0.7em}
  {#1}

\titleformat{\subsubsection}
  {\color{PBAGray}\normalsize\bfseries\itshape}
  {\thesubsubsection}
  {0.7em}
  {#1}

\titlespacing*{\section}{0pt}{18pt}{8pt}
\titlespacing*{\subsection}{0pt}{12pt}{4pt}
\titlespacing*{\subsubsection}{0pt}{8pt}{3pt}


%% =============================================================================
%%  COVER PAGE COMMAND
%%  Call \makecover immediately after \begin{document}
%% =============================================================================
\newcommand{\makecover}{%
  \thispagestyle{coverpage}
  \begin{titlepage}

    %% Top bar
    \noindent\textcolor{PBABlue}{\rule{\textwidth}{4pt}}
    \vspace{4pt}
    \noindent\textcolor{PBAAccent}{\rule{\textwidth}{1.5pt}}

    \vspace{12mm}

    %% Logo row
    \noindent
    \begin{minipage}[t]{0.55\textwidth}
      \ifthenelse{\equal{\@ANclassification}{Internal}}{%
        \colorbox{PBABlue}{\textcolor{white}{\small\bfseries\quad INTERNAL USE ONLY\quad}}%
      }{%
        \ifthenelse{\equal{\@ANclassification}{Customer-Facing}}{%
          \colorbox{PBAAccent}{\textcolor{white}{\small\bfseries\quad CUSTOMER-FACING\quad}}%
        }{%
          \colorbox{PBAGray}{\textcolor{white}{\small\bfseries\quad \@ANclassification\quad}}%
        }%
      }
    \end{minipage}%
    \begin{minipage}[t]{0.44\textwidth}
      \raggedleft
      %% Replace pba-logo.png with your actual logo file
      \IfFileExists{pba-logo.png}{%
        \includegraphics[height=14mm]{pba-logo.png}%
      }{%
        \textcolor{PBABlue}{\Large\bfseries PBA Systems}%
      }%
    \end{minipage}

    \vspace{18mm}

    %% Application Note label
    \noindent{\textcolor{PBAGray}{\large APPLICATION NOTE \quad \textcolor{PBABlue}{\@ANnumber}}}

    \vspace{6mm}

    %% Document title
    \noindent{\textcolor{PBADark}{\fontsize{22}{28}\selectfont\bfseries \@ANtitle}}

    \vspace{8mm}

    %% System / scope
    \noindent{\textcolor{PBAGray}{\normalsize\itshape System: \@ANsystem}}

    \vspace{12mm}

    %% Metadata table
    \noindent
    \begin{tabularx}{\textwidth}{@{} >{\bfseries\color{PBABlue}}l X @{}}
      \toprule
      \rowcolor{PBALightGray}
      Version       & \@ANversion \\
      Date          & \@ANdate \\
      \rowcolor{PBALightGray}
      Author        & \@ANauthor \\
      Reviewed by   & \@ANreviewer \\
      \rowcolor{PBALightGray}
      Classification & \@ANclassification \\
      Related ANs   & \@ANrelated \\
      \rowcolor{PBALightGray}
      License       & \@ANlicense \\
      \bottomrule
    \end{tabularx}

    \vspace{12mm}

    %% Keywords (FAIR: Findable)
    \noindent\textcolor{PBAGray}{\small\textbf{Keywords:} \textit{\@ANkeywords}}

    \vfill

    %% Bottom bar
    \noindent\textcolor{PBAAccent}{\rule{\textwidth}{1.5pt}}
    \vspace{4pt}
    \noindent\textcolor{PBABlue}{\rule{\textwidth}{4pt}}

  \end{titlepage}
  \clearpage
}


%% =============================================================================
%%  DOCUMENT CONTROL BLOCK
%%  \ANreventry{version}{date}{author}{description}  — add one per revision
%%  \makedoccontrol  — renders the full table
%% =============================================================================
\newcounter{revcount}
\setcounter{revcount}{0}
\def\@revtable{}

\newcommand{\ANreventry}[4]{%
  \stepcounter{revcount}%
  \g@addto@macro\@revtable{%
    #1 & #2 & #3 & #4 \\
    \rowcolor{PBALightGray}%
  }%
}

\newcommand{\makedoccontrol}{%
  \noindent
  \begin{tabularx}{\textwidth}{@{} l l l X @{}}
    \rowcolor{PBATableHeader}
    \textcolor{white}{\bfseries Version} &
    \textcolor{white}{\bfseries Date} &
    \textcolor{white}{\bfseries Author} &
    \textcolor{white}{\bfseries Summary of Changes} \\
    \@revtable
    \bottomrule
  \end{tabularx}
}


%% =============================================================================
%%  CALLOUT BOX ENVIRONMENTS  (IEC/IEEE 82079-1 §7 / ANSI Z535.6)
%%
%%  Usage:
%%    \begin{dangerbox}   ... \end{dangerbox}
%%    \begin{warningbox}  ... \end{warningbox}
%%    \begin{cautionbox}  ... \end{cautionbox}
%%    \begin{notebox}     ... \end{notebox}
%%    \begin{tipbox}      ... \end{tipbox}
%% =============================================================================
\tcbuselibrary{skins, breakable}

%% Internal helper: builds a signal box
\newcommand{\@makesignalbox}[5]{%
  %% #1 = color, #2 = bg, #3 = icon, #4 = label, #5 = env name
  \newenvironment{#5}{%
    \begin{tcolorbox}[
      breakable,
      enhanced,
      colback=#2,
      colframe=#1,
      leftrule=4pt,
      rightrule=0.4pt,
      toprule=0.4pt,
      bottomrule=0.4pt,
      arc=2pt,
      fontupper=\small,
      before upper={%
        \textcolor{#1}{\textbf{#3\quad #4}}\par\smallskip
      },
      left=8pt, right=8pt, top=6pt, bottom=6pt,
    ]
  }{%
    \end{tcolorbox}
  }
}

%% DANGER — imminently hazardous (death / serious injury)
\@makesignalbox{DangerRed}{DangerBg}{\faDizzy}{DANGER}{dangerbox}

%% WARNING — possibly imminent hazard
\@makesignalbox{WarningOrange}{WarningBg}{\faExclamationTriangle}{WARNING}{warningbox}

%% CAUTION — potentially hazardous / property damage
\@makesignalbox{CautionAmber}{CautionBg}{\faExclamationCircle}{CAUTION}{cautionbox}

%% NOTE — important information
\@makesignalbox{NoteBlue}{NoteBg}{\faInfoCircle}{NOTE}{notebox}

%% TIP — best practice / helpful suggestion
\@makesignalbox{TipGreen}{TipBg}{\faLightbulb}{TIP}{tipbox}


%% =============================================================================
%%  CODE LISTING ENVIRONMENTS
%%  Requires: listings package (built in, no shell-escape needed)
%%
%%  Environments:
%%    \begin{pythoncode}[optional caption] ... \end{pythoncode}
%%    \begin{acscode}[optional caption]    ... \end{acscode}
%%    \begin{configcode}[optional caption] ... \end{configcode}
%% =============================================================================

%% Python language definition
\lstdefinelanguage{Python3}{
  keywords={
    and, as, assert, async, await, break, class, continue, def, del,
    elif, else, except, False, finally, for, from, global, if, import,
    in, is, lambda, None, nonlocal, not, or, pass, raise, return, True,
    try, while, with, yield
  },
  morekeywords=[2]{print, range, len, type, int, float, str, list, dict,
    tuple, set, bool, open, input, enumerate, zip, map, filter, sorted,
    sum, min, max, abs, round},
  sensitive=true,
  morecomment=[l]{\#},
  morestring=[b]',
  morestring=[b]",
  morestring=[b]{"""},
}

%% ACS ACSPL+ language definition
\lstdefinelanguage{ACSPL}{
  keywords={
    IF, THEN, ELSE, ELSEIF, END, WHILE, DO, LOOP, FOR, TO, STEP,
    NEXT, GOTO, GOSUB, RETURN, STOP, HALT, WAIT, SLEEP, KILL,
    INT, REAL, STRING, GLOBAL, LOCAL, ARRAY, DIM,
    AND, OR, NOT, XOR
  },
  morekeywords=[2]{
    SERVOSON, SERVOSOFF, ENABLE, DISABLE, FAULT, CLEAR,
    MOVE, PTP, PTPABS, PTPREL, JOG, JOGA, HOME, STOPM,
    VEL, ACC, JERK, DCURR, PCURR, ECURR, APOS, FPOS, RPOS,
    FAULTS, MFLAGS, RFLAGS, IN, OUT, AIN, AOUT,
    START, STARTM, BLOCK, ENDBLOCK,
    PRINT, WRITE, READ, OPEN, CLOSE
  },
  sensitive=false,
  morecomment=[l]{;},
  morestring=[b]{'},
}

%% Base listing style
\lstdefinestyle{pbabase}{
  basicstyle=\ttfamily\small,
  numbers=left,
  numberstyle=\tiny\color{PBAGray},
  numbersep=8pt,
  breaklines=true,
  breakatwhitespace=false,
  showspaces=false,
  showstringspaces=false,
  showtabs=false,
  tabsize=4,
  frame=none,
  backgroundcolor=\color{CodeBg},
  xleftmargin=12pt,
  xrightmargin=6pt,
  aboveskip=4pt,
  belowskip=4pt,
}

%% Python style
\lstdefinestyle{python}{
  style=pbabase,
  language=Python3,
  keywordstyle=\color{PyKeyword}\bfseries,
  keywordstyle=[2]\color{PyBuiltin},
  stringstyle=\color{PyString},
  commentstyle=\color{PyComment}\itshape,
  literate=*{0}{{\textcolor{PyNumber}{0}}}{1}
            {1}{{\textcolor{PyNumber}{1}}}{1}
            {2}{{\textcolor{PyNumber}{2}}}{1}
            {3}{{\textcolor{PyNumber}{3}}}{1}
            {4}{{\textcolor{PyNumber}{4}}}{1}
            {5}{{\textcolor{PyNumber}{5}}}{1}
            {6}{{\textcolor{PyNumber}{6}}}{1}
            {7}{{\textcolor{PyNumber}{7}}}{1}
            {8}{{\textcolor{PyNumber}{8}}}{1}
            {9}{{\textcolor{PyNumber}{9}}}{1},
}

%% ACS ACSPL+ style
\lstdefinestyle{acs}{
  style=pbabase,
  language=ACSPL,
  keywordstyle=\color{ACSKeyword}\bfseries,
  keywordstyle=[2]\color{ACSFunc}\bfseries,
  stringstyle=\color{ACSString},
  commentstyle=\color{ACSComment}\itshape,
}

%% Config / INI / plain text style
\lstdefinestyle{config}{
  style=pbabase,
  basicstyle=\ttfamily\footnotesize,
  numbers=none,
}

%% tcolorbox-wrapped code environments with title bar
\newenvironment{pythoncode}[1][Python Script]{%
  \begin{tcolorbox}[
    breakable,
    enhanced,
    colback=CodeBg,
    colframe=PBABlue,
    toprule=0pt,
    leftrule=0pt,
    rightrule=0pt,
    bottomrule=0pt,
    arc=0pt,
    title={\textcolor{white}{\faCode\quad\textbf{#1}}},
    attach boxed title to top left={yshift=-2mm, xshift=4mm},
    boxed title style={colback=PBABlue, arc=3pt, boxrule=0pt},
    left=0pt, right=0pt, top=6pt, bottom=4pt,
    boxrule=0.5pt,
  ]
  \lstset{style=python}
  \vspace{-2pt}
}{%
  \end{tcolorbox}
}

\newenvironment{acscode}[1][ACS ACSPL+ Script]{%
  \begin{tcolorbox}[
    breakable,
    enhanced,
    colback=CodeBg,
    colframe=ACSKeyword,
    toprule=0pt,
    leftrule=0pt,
    rightrule=0pt,
    bottomrule=0pt,
    arc=0pt,
    title={\textcolor{white}{\faTerminal\quad\textbf{#1}}},
    attach boxed title to top left={yshift=-2mm, xshift=4mm},
    boxed title style={colback=ACSKeyword, arc=3pt, boxrule=0pt},
    left=0pt, right=0pt, top=6pt, bottom=4pt,
    boxrule=0.5pt,
  ]
  \lstset{style=acs}
  \vspace{-2pt}
}{%
  \end{tcolorbox}
}

\newenvironment{configcode}[1][Configuration]{%
  \begin{tcolorbox}[
    breakable, enhanced,
    colback=CodeBg, colframe=PBABorderGray,
    boxrule=0.5pt, arc=2pt,
    title={\textcolor{PBAGray}{\faFileAlt\quad\textbf{#1}}},
    attach boxed title to top left={yshift=-2mm, xshift=4mm},
    boxed title style={colback=PBALightGray, colframe=PBABorderGray, arc=3pt},
    left=0pt, right=0pt, top=6pt, bottom=4pt,
  ]
  \lstset{style=config}
  \vspace{-2pt}
}{%
  \end{tcolorbox}
}


%% =============================================================================
%%  STEP LIST ENVIRONMENT  (for numbered procedures)
%%
%%  Usage:
%%    \begin{steplist}
%%      \step Loosen the four M6 bolts on the sensor mount.
%%      \step Apply \SI{5}{\newton} pre-load using the manual actuator.
%%    \end{steplist}
%%    \outcome{The display shows ``READY'' and the LED turns green.}
%% =============================================================================
\newlist{steplist}{enumerate}{1}
\setlist[steplist]{
  label=\textcolor{PBABlue}{\textbf{Step \arabic*.}},
  leftmargin=*,
  labelsep=0.8em,
  itemsep=8pt,
  topsep=4pt,
}
\newcommand{\step}{\item}

%% Expected outcome box (placed after a step or after the full list)
\newcommand{\outcome}[1]{%
  \par\smallskip
  \noindent
  \textcolor{TipGreen}{\faCheckCircle\quad\textbf{Expected outcome:}}\enspace
  \textit{#1}%
  \par\smallskip
}


%% =============================================================================
%%  VIDEO LINK COMMAND
%%
%%  Usage:
%%    \videolink{https://youtu.be/xxx}{Force ramp sensor feedback — 45 s}
%% =============================================================================
\newcommand{\videolink}[2]{%
  \noindent
  \begin{tcolorbox}[
    enhanced, colback=NoteBg, colframe=NoteBlue,
    leftrule=4pt, rightrule=0.4pt, toprule=0.4pt, bottomrule=0.4pt,
    arc=2pt, left=8pt, right=8pt, top=4pt, bottom=4pt,
  ]
  \textcolor{NoteBlue}{\faPlayCircle\enspace\textbf{Video reference:}}\enspace
  \href{#1}{\textcolor{PBAAccent}{\underline{#2}}}
  \end{tcolorbox}
}


%% =============================================================================
%%  TROUBLESHOOTING TABLE ENVIRONMENT
%%
%%  Usage:
%%    \begin{troubletable}
%%      \troubrow{Axis does not move}{Servo not enabled}{Run SERVOSON(0)}
%%      \troubrow{Force reading drifts}{Zero offset}{Run \texttt{ZERO\_SENSOR}}
%%    \end{troubletable}
%% =============================================================================
\newenvironment{troubletable}{%
  \noindent
  \begin{longtable}{%
    >{\bfseries\color{DangerRed}}p{0.28\textwidth}
    p{0.32\textwidth}
    p{0.32\textwidth}
  }
  \rowcolor{PBATableHeader}
  \textcolor{white}{\bfseries\normalfont Problem / Symptom} &
  \textcolor{white}{\bfseries Probable Cause} &
  \textcolor{white}{\bfseries Corrective Action} \\
  \endfirsthead
  \rowcolor{PBATableHeader}
  \textcolor{white}{\bfseries\normalfont Problem / Symptom} &
  \textcolor{white}{\bfseries Probable Cause} &
  \textcolor{white}{\bfseries Corrective Action} \\
  \endhead
  \multicolumn{3}{r}{\small\itshape Continued on next page\ldots}\\
  \endfoot
  \bottomrule
  \endlastfoot
}{%
  \end{longtable}
}

\newcommand{\troubrow}[3]{#1 & #2 & #3 \\ \rowcolor{PBALightGray}}


%% =============================================================================
%%  PARAMETER TABLE ENVIRONMENT
%%
%%  Usage:
%%    \begin{paramtable}
%%      \paramrow{VEL}{Velocity limit}{ACS motion axis}{0.1--1000}{\si{\mm\per\s}}{100}
%%    \end{paramtable}
%% =============================================================================
\newenvironment{paramtable}{%
  \noindent
  \begin{longtable}{%
    >{\ttfamily\color{ACSKeyword}}l
    p{0.22\textwidth}
    p{0.15\textwidth}
    p{0.14\textwidth}
    l
    >{\ttfamily}l
  }
  \rowcolor{PBATableHeader}
  \textcolor{white}{\bfseries\rmfamily Parameter} &
  \textcolor{white}{\bfseries Description} &
  \textcolor{white}{\bfseries Location} &
  \textcolor{white}{\bfseries Valid Range} &
  \textcolor{white}{\bfseries Unit} &
  \textcolor{white}{\bfseries Default} \\
  \endfirsthead
  \rowcolor{PBATableHeader}
  \textcolor{white}{\bfseries\rmfamily Parameter} &
  \textcolor{white}{\bfseries Description} &
  \textcolor{white}{\bfseries Location} &
  \textcolor{white}{\bfseries Valid Range} &
  \textcolor{white}{\bfseries Unit} &
  \textcolor{white}{\bfseries Default} \\
  \endhead
  \bottomrule
  \endlastfoot
}{%
  \end{longtable}
}

\newcommand{\paramrow}[6]{%
  #1 & #2 & #3 & #4 & #5 & #6 \\ \rowcolor{PBALightGray}%
}


%% =============================================================================
%%  MISC HELPERS
%% =============================================================================

%% Inline code snippet
\newcommand{\code}[1]{\texttt{\textcolor{PBABlue}{#1}}}

%% Inline ACS parameter reference
\newcommand{\acsparam}[1]{\texttt{\textcolor{ACSKeyword}{\bfseries#1}}}

%% Inline file path
\newcommand{\filepath}[1]{\texttt{\textcolor{PBAGray}{#1}}}

%% Inline menu path  e.g. \menu{File > Open > Project}
\newcommand{\menu}[1]{\textit{\textcolor{PBAGray}{#1}}}

%% Section rule (cosmetic)
\newcommand{\sectionrule}{\noindent\textcolor{PBABorderGray}{\rule{\linewidth}{0.4pt}}\vspace{2pt}}

%% Figure note (below a figure, before the caption)
\newcommand{\fignote}[1]{\par\vspace{-4pt}\textcolor{PBAGray}{\footnotesize\textit{Note: #1}}\par}

%% Hyperref PDF metadata (call in main.tex after all \AN... commands)
\newcommand{\setpdfmeta}{%
  \hypersetup{
    pdftitle={\@ANtitle},
    pdfauthor={\@ANauthor},
    pdfsubject={PBA Systems Application Note \@ANnumber},
    pdfkeywords={\@ANkeywords},
  }
}

%% =============================================================================
%%  BIBLIOGRAPHY
%% =============================================================================
\addbibresource{references.bib}

%% END OF CLASS
