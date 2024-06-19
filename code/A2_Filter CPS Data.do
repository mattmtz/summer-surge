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

** KEEP THOSE IN LABOR FORCE **
codebook empstat
drop if inlist(empstat, 32, 34, 36)

log close
******************
*** CLEAN DATA ***
******************

** CREATE UNEMPLOYED FLAG
gen unemp_dum = (empstat > 12)

** CREATE CLEAN YEAR-MONTH VARIABLE **
gen ym = mdy(month, 1, year)
	format ym %d
	
*****************
*** SAVE DATA ***
*****************

keep year ym wtfinl age sex race wkstat uhrsworkt durunem2 whyunemp unemp_dum
order year ym wtfinl age sex race wkstat uhrsworkt durunem2 whyunemp unemp_dum
gsort ym

save "../intermediate/cleaned_cps", replace
