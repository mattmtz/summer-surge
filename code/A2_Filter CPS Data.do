/******************************
*** NAME:    MATT MARTINEZ
*** PROJECT: SUMMER SURGE
*** PURPOSE: FILTER CPS DATA
*** DATE:    06/20/2024
******************************/

cd "$CD"

*******************
*** FILTER DATA ***
*******************

log using "output/CPS_filtering.txt", text replace

** KEEP BA **
tab educ if educ == 111
keep if educ == 111

** KEEP NOT IN SCHOOL **
label list schlcoll_lbl
keep if schlcoll == 5

log close
******************
*** CLEAN DATA ***
******************

** CREATE UNEMPLOYED FLAG
gen cln_empstat = ""
	replace cln_empstat = "employed" if inlist(empstat, 10, 12)
	replace cln_empstat = "unemployed" if inlist(empstat, 20, 21, 22)
	replace cln_empstat = "nilf" if empstat >= 30

** CREATE CLEAN YEAR-MONTH VARIABLE **
gen ym = mofd(mdy(month, 1, year))
	format ym %tm
	
*****************
*** SAVE DATA ***
*****************

keep year month ym wtfinl age sex race wkstat uhrsworkt durunem2 whyunemp cln_emp
order year month ym wtfinl age sex race wkstat uhrsworkt durunem2 whyunemp cln_emp
gsort ym

save "../intermediate/cleaned_cps", replace
