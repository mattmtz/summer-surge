/******************************
*** NAME:    MATT MARTINEZ
*** PROJECT: SUMMER SURGE
*** PURPOSE: SETUP 
*** DATE:    06/20/2024
******************************/

clear
capture log close
macro drop _all
set more off, perm
set rmsg on
*ssc install unique

** SET WORKING DIRECTORY GLOBAL **
global CD "C:\Users\mattm\Desktop\Summer_Surge\summer-surge"
cd "$CD"

** SET IPUMS DATA DOWNLOAD NAME **
global IPUMS "cps_00002.dat"

** RUN DATA SETUP CODE **
do "code/A1_CPS Data Download.do"
do "code/A2_Filter CPS Data.do"
