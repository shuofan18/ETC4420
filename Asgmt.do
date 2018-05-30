clear
//cd /Users/stanza/Downloads
set more off
capture log close
log using Assignment.log,replace
cd \\ad.monash.edu\home\User079\szha0076\Desktop\ETC4420
use "PHI.dta", replace
set seed 27886913
sample 22000, count

*********************************************************
******************First question*************************
*********************************************************

//check data summary statistics
sum
tab hicvrtyp //tabulation of the dependent variable for 1st question
gen phi=0 if hicvrtyp==5 //without phi
replace phi=1 if hicvrtyp==1 //Hospital cover only 
replace phi=2 if hicvrtyp==2 //Ancillary cover only
replace phi=3 if hicvrtyp==3  //Both hospital and ancillary cover
tab agecb oralq4cb, row
//We can see clear correlation between age and dental visits.
tab agecb
//generate dummy for age groups
gen age14=0 //(not applicable 1st question)
gen age1519=0  //(ref.level 1st question)
gen age2024=0
gen age2529=0
gen age3034=0
gen age3539=0
gen age4044=0
gen age4549=0
gen age5054=0
gen age5559=0
gen age6064=0
gen age6569=0
gen age7074=0
gen age7579=0
gen age80=0
replace age14=1 if agecb==1
replace age14=1 if agecb==2
replace age14=1 if agecb==3
replace age1519=1 if agecb==4
replace age2024=1 if agecb==5
replace age2529=1 if agecb==6
replace age3034=1 if agecb==7
replace age3539=1 if agecb==8
replace age4044=1 if agecb==9
replace age4549=1 if agecb==10
replace age5054=1 if agecb==11
replace age5559=1 if agecb==12
replace age6064=1 if agecb==13
replace age6569=1 if agecb==14
replace age7074=1 if agecb==15
replace age7579=1 if agecb==16
replace age80=1 if agecb==17
replace age80=1 if agecb==18
//cross tab indicates age group below 14 is not applicable
tab agecb hicvrtyp
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
gen workpt=0
gen unemp=0
gen nlf=0  //(ref.level)
replace workft=1 if empstabc==1 //work full time
replace workpt=1 if empstabc==2 //work part time
replace unemp=1 if empstabc==3  //unemployed
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
replace Australia=1 if cobcodcb==1
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
mlogit phi age2024 age2529 age3034 age3539 age4044 age4549 age5054 /*
*/age5559 age6064 age6569 age7074 age7579 age80 Australia /*
*/English male married condno excelh verygood good fair degree dipcert /*
*/income4 income5 income6 income7 income8 income9 income10 workft workpt unemp

quietly mlogit phi age2024 age2529 age3034 age3539 age4044 age4549 age5054 /*
*/age5559 age6064 age6569 age7074 age7579 age80 Australia /*
*/English male married condno excelh verygood good fair degree dipcert /*
*/income4 income5 income6 income7 income8 income9 income10 workft workpt unemp
predict pp0, outcome(0)
predict pp1, outcome(1)
predict pp2, outcome(2)
predict pp3, outcome(3)
sum pp0 pp1 pp2 pp3 //estimated probabilities

//hit and loss
gen hatphi0=pp0>=pp1 & pp0>=pp2 & pp0>=pp3
gen hatphi1=pp1>=pp0 & pp1>=pp2 & pp1>=pp3
gen hatphi2=pp2>=pp0 & pp2>=pp1 & pp2>=pp3
gen hatphi3=pp3>=pp0 & pp3>=pp1 & pp3>=pp2
gen hatphi=0 
replace hatphi=1 if hatphi1==1
replace hatphi=2 if hatphi2==1
replace hatphi=3 if hatphi3==1
tab phi hatphi

//AME of MNL
quietly mlogit phi age2024 age2529 age3034 age3539 age4044 age4549 age5054 /*
*/age5559 age6064 age6569 age7074 age7579 age80 Australia /*
*/English male married condno excelh verygood good fair degree dipcert /*
*/income4 income5 income6 income7 income8 income9 income10 workft workpt unemp
margins, dydx(*) predict(outcome(0)) post
quietly mlogit phi age2024 age2529 age3034 age3539 age4044 age4549 age5054 /*
*/age5559 age6064 age6569 age7074 age7579 age80 Australia /*
*/English male married condno excelh verygood good fair degree dipcert /*
*/income4 income5 income6 income7 income8 income9 income10 workft workpt unemp
margins, dydx(*) predict(outcome(1)) post
quietly mlogit phi age2024 age2529 age3034 age3539 age4044 age4549 age5054 /*
*/age5559 age6064 age6569 age7074 age7579 age80 Australia /*
*/English male married condno excelh verygood good fair degree dipcert /*
*/income4 income5 income6 income7 income8 income9 income10 workft workpt unemp
margins, dydx(*) predict(outcome(2)) post
quietly mlogit phi age2024 age2529 age3034 age3539 age4044 age4549 age5054 /*
*/age5559 age6064 age6569 age7074 age7579 age80 Australia /*
*/English male married condno excelh verygood good fair degree dipcert /*
*/income4 income5 income6 income7 income8 income9 income10 workft workpt unemp
margins, dydx(*) predict(outcome(3)) post



*********************************************************
******************Second question*************************
*********************************************************


tab oralq4cb //check the dependent variable for second question
//create dummy variable as dependent variable
gen dvisit=0
replace dvisit=1 if oralq4cb==1
replace dvisit=1 if oralq4cb==2
tab healinq1 //check the treatment variable 
//create dummy variable for treatment 
gen treat=0 if  healinq1==2
replace treat=1 if  healinq1==1

//create dummy for smoking
tab smkreglr
gen nonsmoke=0  //(ref.level)
gen exsmoke=0
gen currentsmk=0
gen regularsmk=0
replace nonsmoke=1 if smkreglr==4
replace exsmoke=1 if smkreglr==3
replace currentsmk=1 if smkreglr==2
replace regularsmk=1 if smkreglr==1
//create dummy for drinking 
tab al2k7day
gen low=0 //(ref.level)
gen medium=0
gen high=0
replace low=1 if al2k7day==1
replace low=1 if al2k7day==5
replace low=1 if al2k7day==6
replace medium=1 if al2k7day==2
replace high=1 if al2k7day==4
//create "times visited GP" variable
tab docq2cb
gen gpvisit=docq2cb

/////estimate EBVP model 

biprobit (dvisit = age2024 age2529 age3034 age3539 age4044 age4549 age5054 /*
*/age5559 age6064 age6569 age7074 age7579 age80 Australia /*
*/English male married condno excelh verygood good fair degree dipcert /*
*/income4 income5 income6 income7 income8 income9 income10 workft workpt unemp/*
*/ exsmoke currentsmk regularsmk medium low treat) (treat = age2024 age2529/*
*/ age3034 age3539 age4044 age4549 age5054 /*
*/age5559 age6064 age6569 age7074 age7579 age80 Australia gpvisit /*
*/English male married condno excelh verygood good fair degree dipcert /*
*/income4 income5 income6 income7 income8 income9 income10 workft workpt unemp)
///margins, dydx(treat) predict(pmarg1)

log close















