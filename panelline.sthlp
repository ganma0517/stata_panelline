{smcl}
{* *! version 1.0  2jun2026}{...}
{vieweralsosee "twoway line" "help twoway line"}{...}
{vieweralsosee "graph combine" "help graph combine"}{...}
{viewerjumpto "Syntax" "panelline##syntax"}{...}
{viewerjumpto "Description" "panelline##description"}{...}
{viewerjumpto "Options" "panelline##options"}{...}
{viewerjumpto "Examples" "panelline##examples"}{...}
{viewerjumpto "Author" "panelline##author"}{...}
{title:Title}

{phang}
{bf:panelline} {hline 2} Small-multiples line plot (FT-style) with end-point dots


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:panelline}
{it:yvar}
{ifin}
{cmd:,}
{opth over(varname)}
{opth time(varname)}
[{it:options}]

{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{p2coldent:* {opth over(varname)}}panel/group variable (one sub-plot per level){p_end}
{p2coldent:* {opth time(varname)}}x-axis (time) variable{p_end}
{synopt:{opt cols(#)}}number of columns (default: auto){p_end}

{syntab:Lines and dots}
{synopt:{opt l:color(string)}}line color for all panels; default {cmd:"31 119 180"}{p_end}
{synopt:{opt byc:olors(string)}}explicit colour per panel as {it:value=colour} pairs, e.g. {cmd:bycolors(North=navy South=forest_green)} ({opt colors()} alias){p_end}
{synopt:{opt lw:idth(string)}}line width; default {cmd:medium}{p_end}
{synopt:{opt noend:dot}}do not draw the end-point dot{p_end}
{synopt:{opt dotc:olor(string)}}end-dot color; default = line color{p_end}
{synopt:{opt dots:ize(string)}}end-dot size; default {cmd:medium}{p_end}

{syntab:Axes and titles}
{synopt:{opt noyc:ommon}}let each panel scale its own y-axis (default: shared){p_end}
{synopt:{opt ylab:el(string)}}y-axis label rule applied to every panel{p_end}
{synopt:{opt xlab:el(string)}}x-axis label rule applied to every panel{p_end}
{synopt:{opt title(string)}}overall title{p_end}
{synopt:{opt sub:title(string)}}overall subtitle{p_end}
{synopt:{opt ytit:le(string)}}y-axis title; default = {it:yvar} label{p_end}

{syntab:Saving}
{synopt:{opt saving(string)}}export the graph to this path{p_end}
{synopt:{opt name(string)}}graph window name; default {cmd:panelline}{p_end}
{synoptline}
{p 4 6 2}* {opt over()} and {opt time()} are required.{p_end}


{marker description}{...}
{title:Description}

{pstd}
{cmd:panelline} draws a {bf:small-multiples} (faceted) line plot in the style of
Financial Times time-series graphics: one time-series sub-plot per level of
{opt over()}, all on a {bf:shared y-axis} so trends are directly comparable, with
an {bf:end-point dot} marking the most recent value of each line. Input is in
long format: one observation per panel-time.


{marker options}{...}
{title:Options}

{phang}{opth over(varname)} is the panel variable; one sub-plot per level
(string or numeric; value labels are used as panel titles).

{phang}{opth time(varname)} is the x-axis (time) variable.

{phang}{opt cols(#)} sets the number of columns (default: auto).

{phang}{opt lcolor()}, {opt lwidth()} style the line; {opt noenddot},
{opt dotcolor()}, {opt dotsize()} control the end-point dot.

{phang}{opt bycolors(string)} gives specific panels their own colour as ({opt colors()} still works) 
{it:value=colour} pairs, e.g.
{cmd:bycolors(North=navy South=forest_green East=orange West=gs7)}. The key may be the
panel's value label or its raw value (use the raw value when the label contains
spaces); panels not listed keep {opt lcolor()}. The line, the end-dot, and the
panel title all take the mapped colour.

{phang}{opt noycommon} lets each panel use its own y-axis (default: shared).
{opt ylabel()} / {opt xlabel()} apply the same axis rules to all panels.

{phang}{opt title()}, {opt subtitle()}, {opt ytitle()} set the overall titles.
{opt saving()} exports the graph; {opt name()} names the graph window.


{marker examples}{...}
{title:Examples}

{pstd}Load the bundled practice data (fictional; no real source){p_end}
{phang2}{cmd:. use "https://raw.githubusercontent.com/ganma0517/stata_panelline/main/panelline_demo.dta", clear}{p_end}

{pstd}FT-style small multiples with end-point dots{p_end}
{phang2}{cmd:. panelline hours, over(band) time(time) xlabel(2014 2024)}{p_end}

{pstd}With titles{p_end}
{phang2}{cmd:. panelline hours, over(band) time(time) title("Hours rose, then plateaued") subtitle("Average hours per week")}{p_end}

{pstd}No end dot, custom color{p_end}
{phang2}{cmd:. panelline hours, over(band) time(time) noenddot lcolor(cranberry)}{p_end}


{marker author}{...}
{title:Author}

{pstd}{bf:Wen-Cheng Lin (林文正)}{break}
PhD, Department of Political Science, National Chengchi University{break}
Postdoctoral research fellow, Institute of Sociology, Academia Sinica{break}
Email: beck740517@gmail.com{break}
{browse "https://github.com/ganma0517/stata_panelline":github.com/ganma0517/stata_panelline}{p_end}

{pstd}This package was developed with Claude. It is still at an experimental
stage and is intended mainly for empirical and survey-experiment research.
Questions and feedback are very welcome.{p_end}

{pstd}本套件由作者使用 Claude 開發，目前仍屬實驗性階段，主要用於實證與調查實驗研究的
資訊呈現。若有任何問題，歡迎來信交流。{p_end}
