/***************************************
*** NAME:    MATT MARTINEZ
*** PROJECT: SUMMER SURGE
*** PURPOSE: UNEMP DEVIATIONS BY MONTH 
*** DATE:    06/20/2024
***************************************/

***********************
*** PREPARE DATASET ***
***********************

use "../intermediate/cleaned_cps", clear
	drop if cln_emp == "nilf"
	
** CALCULATE UNEMPLOYMENT BY YEAR/MONTH **
collapse (sum) wtfinl, by(ym year month cln_emp)

reshape wide wtfinl, i(ym year month) j(cln_emp) string
	rename (wtfinle wtfinlu) (empl unemp)
	
gen tot = empl + unemp
	replace unemp = unemp / tot
	drop tot empl
	
** CALCULATE AVG UNEMPLOYMENT (ALL DATES) **
preserve
	collapse (mean) unemp
	qui sum unemp
	local BASELINE `r(mean)'
	di `BASELINE'
restore

** CALCULATE AVG UNEMPLOYMENT (NO 2020) **
preserve
	drop if year == 2020
	collapse (mean) unemp
	qui sum unemp
	local ALT `r(mean)'
	di `ALT'
restore

** CALCULATE AVG UNEMPLOYMENT (NO 2020-2021) **
preserve
	drop if inlist(year, 2020, 2021)
	collapse (mean) unemp
	qui sum unemp
	local NOCOVID `r(mean)'
	di `NOCOVID'
restore

gen baseline = `BASELINE'
gen alt_baseline = `ALT'
gen nocovid_baseline = `NOCOVID'

** MONTHLY UNEMPLOYMENT - 2020 HIGHLIGHT **
sum unemp
local max=`r(max)'
gen c=`max' if ym>m(2020m2)&ym<m(2020m10)
tsset ym, monthly
set scheme s2mono
twoway (area c ym, color(gs13)) (line unemp ym, color(navy) lp(solid)), ///
 legend(off) title("Unemployment Rate of BA Holders") subtitle("Ages 22-26") ///
 xtitle("") xlabel(636(12)772, format(%tmMon-YY) angle(90)) xmtick(636(3)772) ///
 ytitle("Unemployment Rate") ylabel(0 "0%" .05 "5%" 0.1 "10%" .15 "15%") ///
 ymtick(0.01(0.01)0.15) plotr(m(zero)) note("NOTE: Mar. 2020 - Sept. 2020 shaded")

graph export "output/unemployment_by_month.png", width(1500) height(1100) replace

***************************
*** UNEMPLOYMENT GRAPHS ***
***************************

collapse (mean) unemp baseline alt nocovid, by(month)
	
gen diff1 = unemp - baseline
gen diff2 = unemp - alt
gen diff3 = unemp - nocovid

set scheme s2mono
line diff1 diff2 diff3 month, legend(subtitle("Choice of baseline") ///
 order(1 "All data" 2 "No 2020" 3 "No 2020-2021") col(3)) ///
 title("Avg. deviation from annual avg. unemployment rate") ///
 subtitle("BA holders aged 22-26") yline(0, lstyle(foreground) lwidth(medthick)) ///
 ylabel(-.02 "-2%" -.01 "-1%" 0 "0%" .01 "1%" .02 "2%") ytitle("Deviation (Pct-point)",height(4)) ///
 xlabel(1(1)12, valuelabel angle(45)) xtitle("") lpattern(solid solid solid) ///
 lcolor(navy red dkgreen) lwidth(medium medium medium)

graph export "output/deviation_by_month_and_baseline.png", width(1900) height(1100) replace
