*===============================================================*
* panelline — example / tutorial do-file
* Uses the bundled practice data (fictional; no real-world source):
* average hours per week on a hobby, by age band, 2014-2024.
*===============================================================*
clear all
set more off

* load practice data from the repo (no install needed)
use "https://raw.githubusercontent.com/ganma0517/stata_panelline/main/panelline_demo.dta", clear

* 1) FT-style small multiples with end-point dots
panelline hours, over(band) time(time) xlabel(2014 2024)

* 2) With overall titles
panelline hours, over(band) time(time) xlabel(2014 2024) ///
    title("Hobby time rose through the 2010s, then plateaued") ///
    subtitle("Average hours per week, by age band")

* 3) No end dot, custom color and width
panelline hours, over(band) time(time) noenddot lcolor(cranberry) lwidth(thin)

* 4) Each panel on its own y-axis
panelline hours, over(band) time(time) noycommon

* 5) Export to PNG
panelline hours, over(band) time(time) xlabel(2014 2024) ///
    saving("panelline_demo.png")

display as result "panelline tutorial finished — see help panelline."
