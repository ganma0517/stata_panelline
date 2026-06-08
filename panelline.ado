*! panelline v1.1  8Jun2026
*! Small-multiples line plot (FT-style): one time-series sub-plot per group,
*! drawn on a shared y-axis, with an optional end-point dot on each line.
*!
*! Syntax:
*!   panelline yvar , over(panelvar) time(timevar) [ options ]
*!
*! ---- required ----
*!   over(varname)      panel/group variable (one sub-plot per level)
*!   time(varname)      x-axis (time) variable
*!
*! ---- layout ----
*!   cols(#)            number of columns (default: auto)
*!   noycommon          let each panel scale its own y-axis (default: shared)
*!
*! ---- line & end-dot ----
*!   lcolor(string)     line colour for all panels (default "31 119 180")
*!   bycolors(string)   explicit colour per panel, as value=colour pairs, e.g.
*!                      bycolors(North=navy South=forest_green West=gs7)
*!                      (colors() is kept as a backward-compatible alias)
*!   lwidth(string)     line width (default medium)
*!   noenddot           do not draw the end-point dot
*!   dotcolor(string)   end-dot colour (default = line colour)
*!   dotsize(string)    end-dot size (default medium)
*!
*! ---- axes & titles ----
*!   ylabel(string)     y-axis label rule applied to every panel
*!   xlabel(string)     x-axis label rule applied to every panel
*!   ytitle(string)     y-axis title (default = yvar label)
*!   title(string)      overall graph title
*!   subtitle(string)   overall subtitle
*!
*! ---- output ----
*!   saving(string)     export path
*!   name(string)       graph window name (default panelline)

program define panelline
    version 16.0
    syntax varname(numeric) [if] [in], Over(varname) Time(varname)       ///
        [                                                                ///
          COLs(integer 0) NOYCommon                                      /// layout
          LColor(string) BYColors(string asis) COLORS(string asis)       /// line colour
          LWidth(string) NOENDdot DOTColor(string) DOTSize(string)       /// width & end-dot
          YLABel(string asis) XLABel(string asis) YTITle(string asis)    /// axes
          title(string asis) SUBtitle(string asis)                       /// titles
          saving(string) name(string) ]

    marksample touse
    markout `touse' `over' `time'
    local y `varlist'

    * bycolors() is the documented name; colors() kept as backward-compatible alias
    if `"`bycolors'"'=="" local bycolors `"`colors'"'
    local colors `"`bycolors'"'

    if "`lcolor'"   == "" local lcolor "31 119 180"
    if "`lwidth'"   == "" local lwidth "medium"
    local dotset = ("`dotcolor'"!="")
    if "`dotcolor'" == "" local dotcolor "`lcolor'"
    if "`dotsize'"  == "" local dotsize "medium"
    if "`name'"     == "" local name "panelline"
    if `"`ytitle'"' == "" {
        local ytl : variable label `y'
        if `"`ytl'"'=="" local ytl "`y'"
        local ytitle `"`ytl'"'
    }
    * strip a single layer of surrounding double quotes the user may have typed
    foreach t in title subtitle ytitle {
        local tv `"``t''"'
        if substr(`"`tv'"',1,1)==`"""' & substr(`"`tv'"',-1,1)==`"""' {
            local `t' = substr(`"`tv'"',2,length(`"`tv'"')-2)
        }
    }

    preserve
    quietly keep if `touse'

    * ---- shared y-axis range across all panels ----
    if "`noycommon'"=="" & `"`ylabel'"'=="" {
        quietly summarize `y', meanonly
        local gymin = r(min)
        local gymax = r(max)
        * round to tidy bounds
        local pad = (`gymax'-`gymin')*0.05
        local ylo = `gymin' - `pad'
        local yhi = `gymax' + `pad'
    }

    * ---- panel levels ----
    quietly levelsof `over', local(plevs)
    local npan : word count `plevs'
    if `cols'==0 {
        if `npan'<=3 local cols = `npan'
        else if `npan'<=6 local cols = `npan'
        else local cols = 4
    }

    local subnames ""
    local j = 0
    foreach pl of local plevs {
        local ++j
        * panel label
        local plab : label (`over') `pl'
        if `"`plab'"'=="" local plab "`pl'"

        * resolve this panel's colour: default = lcolor; an explicit
        * colors("group=colour") mapping overrides it (key = label or value).
        local pcol "`lcolor'"
        if `"`colors'"'!="" {
            foreach kv of local colors {
                local eq = strpos(`"`kv'"',"=")
                if `eq' {
                    local kk = substr(`"`kv'"',1,`eq'-1)
                    local cc = substr(`"`kv'"',`eq'+1,.)
                    if `"`kk'"'==`"`plab'"' | `"`kk'"'=="`pl'" local pcol `"`cc'"'
                }
            }
        }
        * end-dot follows the panel colour unless dotcolor() was set explicitly
        if `dotset' local pdot "`dotcolor'"
        else        local pdot "`pcol'"

        * end point (last non-missing time within panel)
        quietly summarize `time' if `over'==`pl' & !missing(`y'), meanonly
        local tend = r(max)
        quietly summarize `y' if `over'==`pl' & `time'==`tend', meanonly
        local yend = r(mean)

        local sub`j' "_pl_panel`j'"

        local dotlayer ""
        if "`noenddot'"=="" {
            local dotlayer `"(scatteri `yend' `tend', mcolor("`pdot'") msize(`dotsize') msymbol(O))"'
        }

        * force the SAME y range on every panel so the line heights align
        local yopt ""
        if "`noycommon'"=="" local yopt `"yscale(range(`ylo' `yhi'))"'

        if `"`ylabel'"'!="" local yrule `"`ylabel'"'
        else                local yrule ""
        * y labels only on the first panel; others keep the same scale but hide
        if "`noycommon'"=="" {
            if `j'==1 local ypanlab `"ylabel(`yrule', angle(0) nogrid labels)"'
            else      local ypanlab `"ylabel(`yrule', angle(0) nogrid nolabels noticks) yscale(off)"'
        }
        else local ypanlab `"ylabel(`yrule', angle(0) nogrid)"'

        * x-axis: integer-formatted years
        if `"`xlabel'"'!="" local xpanlab `"xlabel(`xlabel', format(%4.0f))"'
        else                local xpanlab `"xlabel(, format(%4.0f))"'

        twoway (line `y' `time' if `over'==`pl', lcolor("`pcol'") lwidth(`lwidth')) ///
               `dotlayer' ///
               , `yopt' ///
                 `ypanlab' ///
                 `xpanlab' ///
                 ytitle("") xtitle("") ///
                 title(`"`plab'"', color("`pcol'") size(medsmall)) ///
                 legend(off) graphregion(color(white)) ///
                 name(`sub`j'', replace) nodraw
        local subnames `subnames' `sub`j''
    }

    local yc = cond("`noycommon'"=="","ycommon","")
    graph combine `subnames', cols(`cols') `yc' imargin(small) ///
        `=cond(`"`title'"'=="","",`"title(`"`title'"')"')' ///
        `=cond(`"`subtitle'"'=="","",`"subtitle(`"`subtitle'"')"')' ///
        l1title(`"`ytitle'"') ///
        graphregion(color(white)) name(`name', replace)

    if `"`saving'"' != "" {
        quietly graph export `"`saving'"', replace width(2800)
        di as result "saved: `saving'"
    }
    restore
end
