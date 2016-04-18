%%
%% This is file `nnw.cls',
%%
%% Copyright (c) 2013,2014,2015 CVUT FTS
%%
%% Authors: Eva Martincikova
%%          Jan Prikryl
%%
%% Changes:
%%   2015/02/21 v2.0 beta 2:
%%     * ignore \par command and hence all empty lines between
%%       \begin{abstract} and \end{abstract}
%%     * use `cite` package to provide visualy more appealing numeric
%%       citations
%%     * automatically capitalize the title
%%     * corrected a bug that caused incorrect baselineskip in title when
%%       using manual line breaks (\\), inspired by
%%       http://tex.stackexchange.com/questions/77909/space-between-lines
%% --------------------------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{nnw}
              [2015/02/21 v2.0 beta 2 Neural Network World article class]
%% --------------------------------------------------------------------------
%% Load defaults from 'article.cls'
\LoadClassWithOptions{article}
%% --------------------------------------------------------------------------
%% Preload packages that are important to our authors
\RequirePackage{amsmath}
\RequirePackage{amsthm}
\RequirePackage{amssymb}
\RequirePackage{amsfonts}
\RequirePackage{mathtools} % This is a patch to some errors in AMS
\RequirePackage[dvips]{graphicx}
%%\RequirePackage{cite}
%% --------------------------------------------------------------------------
%%                                                                   Headings
%% --------------------------------------------------------------------------
%%
%% This is defined in 'article.cls' but we need different
%% headings style.
%% TODO: Use standard packages for headings?
\def\ps@myheadings{%
%% Original:
%%    \let\@oddfoot\@empty\let\@evenfoot\@empty
%%    \def\@evenhead{\thepage\hfil\slshape\leftmark}%
%%    \def\@oddhead{{\slshape\rightmark}\hfil\thepage}%
%%    \let\@mkboth\@gobbletwo
%%    \let\sectionmark\@gobble
%%    \let\subsectionmark\@gobble
  \def\@oddhead{\centerline{\footnotesize\bfseries\rightmark}}
  \def\@oddfoot{\rightline{\bfseries\thepage}}
  \def\@evenhead{\centerline{\footnotesize\bfseries\leftmark}}
  \def\@evenfoot{\leftline{\bfseries\thepage}}
  \def\sectionmark##1{}
  \def\subsectionmark##1{}
}
\def\ps@plain{%
  \let\@mkboth\@gobbletwo
  \def\@oddfoot{\rightline{\bfseries\thepage}}
  \def\@evenfoot{\leftline{\bfseries\thepage}}
  \def\@oddhead{}
  \def\@evenhead{}%
}
\def\ps@firstheadings{%
  \def\@oddhead{\hfill\leavevmode\includegraphics[width=2cm]{nnw_logo}\hfill}
  \def\@evenhead{}
  \def\@oddfoot{{\bfseries\copyright CTU FTS 2015 \hfill\thepage}}
  \def\@evenfoot{}%
}

%% --------------------------------------------------------------------------
%%                                                                 Title page
%% --------------------------------------------------------------------------
%%
\renewcommand\maketitle{%
  \par
  \begingroup
    \def\thefootnote{\fnsymbol{footnote}}
    \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
    \long\def\@makefntext##1{%
      \parindent 1em
      \noindent
      \hb@xt@1.8em{%
        \hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
    \if@twocolumn
      \twocolumn[\@maketitle]
    \else
      \newpage
      \global\@topnum\z@
      \@maketitle
    \fi
    \thispagestyle{firstheadings}
    \@thanks
 \endgroup
 %
 \setcounter{footnote}{0}
 \let\maketitle\relax
 \let\@maketitle\relax
 \gdef\@thanks{}
 \gdef\@author{}
 \gdef\@title{}
 \let\thanks\relax%
}
\def\@maketitle{%
  \newpage
  \null
  \hrule height 0.5 pt depth 0.5 pt
  \smallskip
  \begin{center}
    \Large \bfseries \uppercase\expandafter{\@title}
  \end{center}
  {%
    \parfillskip 0pt
    \parindent 0pt
    \begin{center}
      {\itshape \@author}
    \end{center}
  }%

  \smallskip
  \hrule height 0.5 pt depth 0.5 pt
  \vspace{0.8cm}%
}

%% NNW uses MS-Word-like formatting of section numbers: Every section number
%% ends with a dot, every lower levels are without the dot. This is one
%% possible implementation, insipred by http://tex.stackexchange.com/questions/29631/
%% which was in turn inspired by UK TUG FAQ:
%% We will patch the \@seccntformat and introduce our own counter formatting
%% commands for every level
\renewcommand{\@seccntformat}[1]{\csname nnw@#1\endcsname\quad}
\newcommand{\nnw@section}{{\thesection.}}
\newcommand{\nnw@subsection}{{\thesubsection}}
\newcommand{\nnw@subsubsection}{{\thesubsubsection}}

\def\titlepage{\@restonecolfalse\if@twocolumn\@restonecoltrue\onecolumn
 \else \newpage \fi \thispagestyle{firstheadings}\c@page\z@}
\def\endtitlepage{\if@restonecol\twocolumn \else \newpage \fi}

%% NNW style requires tables to be numbered in Roman numerals
\renewcommand\thetable{\@Roman\c@table}

%% Caption code is again copy-and-pasted from 'article.cls'. NNW captions
%% use boldface font for item designator and counter, and the caption itself
%% is typeset in italics. This requires replacing original references to
%% parameters #1 and #2 with \textbf{#1} and \textit{#2}.
%% TODO: Check the 'caption' package.
\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{\textbf{#1} \textit{#2}}%
  \ifdim \wd\@tempboxa >\hsize
    \textbf{#1} \textit{#2}\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}

%% Make the part counter heading wider (from 2 to 2.25 em)
%% Again, there are packages that do this automatically (tocloft)
%% and it is questionable where we actually use the \part command.
%% TODO: Check if this code can be omitted, replaced with \patchcmd
%% from etoolbox or with tocloft package.
\renewcommand*\l@part[2]{%
  \ifnum \c@tocdepth >-2\relax
    \addpenalty\@secpenalty
    \addvspace{2.25em \@plus\p@}%
    \begingroup
      \parindent \z@ \rightskip \@pnumwidth
      \parfillskip -\@pnumwidth
      {\leavevmode
       \large \bfseries #1\hfil \hb@xt@\@pnumwidth{\hss #2}}\par
       \nobreak
       \if@compatibility
         \global\@nobreaktrue
         \everypar{\global\@nobreakfalse\everypar{}}%
      \fi
    \endgroup
  \fi}

%% Bibliography environment with smaller font.
%% This is a copy-and-paste from 'article.cls' with \footnotesize
%% and \normalsize inserted in.
\renewenvironment{thebibliography}[1]
     {\section*{\refname}%
        \@mkboth{\MakeUppercase\refname}{\MakeUppercase\refname}%
      \footnotesize%
      \list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\@biblabel{#1}}%
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
            \@openbib@code
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
      \sloppy
      \clubpenalty4000
      \@clubpenalty \clubpenalty
      \widowpenalty4000%
      \sfcode`\.\@m}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist\normalsize}

%% Abstract
%% We ignore paragraph breaks inside the abstract environment. This is
%% not considered to be a very good practice though.
\renewenvironment{abstract}%
  {\noindent{\bfseries\abstractname:}\begingroup\let\par\relax}
  {\endgroup\medskip}

%% This contains both text and formatting. The formatting part should be
%% part of \maketitle command.
%% TODO: Change it.
\newcommand{\key}[1]{%
  \par%
  \medskip%
  \noindent{%
  \newsavebox{\kwbox}%
  \sbox{\kwbox}{Key words: }%
  \newlength{\kwlen}%
  \settowidth{\kwlen}{\usebox{\kwbox}}%
  \hangindent \kwlen
  \hangafter 1
  \usebox{\kwbox}\textit{#1}\par}}
\newcommand{\rec}[1]{\medskip\par\noindent \textit{Received: #1}}
\newcommand{\rev}[1]{\par\noindent \textit{Revised and accepted: #1}\bigskip}

\newcommand{\obr}[2]{\begin{center}\leavevmode\epsfxsize=#2cm\epsffile{#1}\end{center}}
\newcommand{\zvets}{\refstepcounter{footnote}}

%% Acknowledgement
\newcommand\ackn{\subsection*{Acknowledgement}}

%% Define our own \figurename and \tablename
%% A simple redefinition does not suffice as in the case of using babel or
%% polygossia the names are being redefined by the package. We will therefore
%% first create a private command that redefines both names ...
\newcommand\nnwflo@tabrv{%
  \renewcommand{\figurename}{Fig.}%
  \renewcommand{\tablename}{Tab.}%
}
%% ... and then use the command in a form that is applicable to environment
%% where babel is used and to environment without babel.
\newcommand\nnwflo@thook{%
  \@ifpackageloaded{babel}{%
    \addto\captionsenglish{\nnwflo@tabrv}%
  }{%
    \nnwflo@tabrv%
  }%
}
%% Finally, we have to defer the babel-aware patching of \figurename and
%% \tablename to the beginning of document as at this moment we do not know
%% if the author is going to use babel or not.
%% TODO: As soon as some package redefines the \figurename and \tablename
%% using the \AtBeginDocument hook, the package will take a precedence.
\AtBeginDocument{%
  \nnwflo@thook
}

%% Page dimensions.
%% TODO: What about geometry package?
\textwidth 126mm
\textheight 200mm
\oddsidemargin 18mm
\evensidemargin 18mm

%% Theorem and lemma definitions
\theoremstyle{plain}
\newtheorem{thm}{Theorem}
\newtheorem{lem}[thm]{Lemma}
\newtheorem{prop}[thm]{Proposition}
\newtheorem*{cor}{Corollary}

\theoremstyle{definition}
\newtheorem{defn}{Definition}
\newtheorem{conj}{Conjecture}
\newtheorem{example}{Example}

\theoremstyle{remark}
\newtheorem*{rem}{Remark}
\newtheorem*{note}{Note}
\newtheorem{case}{Case}

\endinput
%%
%% End of file 'nnw.cls'.
