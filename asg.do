clear
//cd /Users/stanza/Downloads
cd \\ad.monash.edu\home\User079\szha0076\Desktop\ETC4420
use "PHI.dta", replace
******************First question**************************
//check data summary statistics
sum
tab hicvrtyp //tabulation of the dependent variable for 1st question
gen phi=0 if hicvrtyp==5 //without phi
replace phi=1 if hicvrtyp==1 //Hospital cover only 
replace phi=2 if hicvrtyp==2 //Ancillary cover only
replace phi=3 if hicvrtyp==3  //Both hospital and ancillary cover
//We can see clear correlation between age and dental visits.
tab agecb
//too many band, age group with simlar distribution will be grouped into broader
//age band. common sense of relationship between age and dental condition is 
//also consistent with this re-group
tab agecb oralq4cb, row
gen age4=0 //(ref.level)
gen age59=0
gen age1014=0
gen age1519=0
gen age2039=0
gen age4064=0
gen age6579=0
gen age80=0
replace age4=1 if agecb==1
replace age59=1 if agecb==2
replace age1014=1 if agecb==3
replace age1519=1 if agecb==4
replace age2039=1 if agecb==5
replace age2039=1 if agecb==6
replace age2039=1 if agecb==7
replace age2039=1 if agecb==8
replace age4064=1 if agecb==9
replace age4064=1 if agecb==10
replace age4064=1 if agecb==11
replace age4064=1 if agecb==12
replace age4064=1 if agecb==13
replace age6579=1 if agecb==14
replace age6579=1 if agecb==15
replace age6579=1 if agecb==16
replace age80=1 if agecb==17
replace age80=1 if agecb==18
//dummy for gender
tab sex
gen male=0
replace male=1 if sex==1
//dummy for marital status
tab sms
gen married=1 if sms==1 //married registered
replace married=1 if sms==2 //married de facto
replace married=0 if sms==3 //not married (ref.level)
//dummy for work status
tab empstabc 
gen workft=0 
replace workft=1 if empstabc==1 //work full time
gen workpt=0
replace workpt=1 if empstabc==2 //work part time
gen unemp=0
replace unemp=1 if empstabc==3  //unemployed
gen nlf=0 
replace nlf=1 if empstabc==4 //not in labour force
//dummy for long-term condition
tab ltcond
gen longtc=0
replace longtc=1 if ltcond==1 //has long-term condition
//dummy for general health assessment
tab sf12q2
gen excelh=0 
gen verygood=0
gen good=0
gen fair=0
gen poor=0 //(ref.level)
replace excelh=1 if sf12q2==1
replace verygood=1 if sf12q2==2
replace good=1 if sf12q2==3
replace fair=1 if sf12q2==4
replace poor=1 if sf12q2==5  
//dummy for educational attainment 
tab edattqcb
gen degree=0
gen dipcert=0
gen less12yr=0 //(ref.level)
replace degree=1 if edattqcb==1
replace degree=1 if edattqcb==2
replace dipcert=1 if edattqcb==3
replace dipcert=1 if edattqcb==4
replace less12yr=1 if edattqcb==5
//generate dummy variable for language spoken at home
gen English=0
gen Australia=0
gen nonEng=0 //(ref.level)
replace English=1 if cobcodcb==2
replace Australia=0 if cobcodcb==1
replace nonEng=0 if cobcodcb==3
//generate dummy variable for income group
tab incdecpn
gen income3=0  //(ref.level)
gen income4=0
gen income5=0
gen income6=0
gen income7=0
gen income8=0
gen income9=0
gen income10=0
replace income3=1 if incdecpn==3
replace income4=1 if incdecpn==4
replace income5=1 if incdecpn==5
replace income6=1 if incdecpn==6
replace income7=1 if incdecpn==7
replace income8=1 if incdecpn==8
replace income9=1 if incdecpn==9
replace income10=1 if incdecpn==10
//MNL model regression
mlogit phi age59 age1014 age1519 age2039 age4064 age6579 age80 Australia /*
*/English 






**** question 2 code**************
*biprobit (Y = X1 X2 T) (T = Z1 Z2)
*margins, dydx(T) predict(pmarg1)
tab oralq4cb
gen dvisit=0
replace dvisit=1 if oralq4cb==1
replace dvisit=1 if oralq4cb==2






