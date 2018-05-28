clear
cd /Users/stanza/Downloads
use "PHI.dta", replace
//check data summary statistics
sum
tab age
//18 age bands will be used as continuous variable

//generate dummy variable for language spoken at home
gen English=0
gen Australia=0
gen nonEng=0
replace English=1, if cobcodcb==2
replace Australia=0, if cobcodcb==1
replace nonEng=0, if cobcodcb==3
//generate dummy variable for income group
tab incdecpn
gen income3=0
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







**** question 2 code
*biprobit (Y = X1 X2 T) (T = Z1 Z2)
*margins, dydx(T) predict(pmarg1)

gen age4less=0
gen age59=0
gen age1014=0
gen age1519=0
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
gen age8084=0
gen age85=0
replace age4less=1 if agecb==1
replace age59=1 if agecb==2
replace age1014=1 if agecb==3
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
replace age8084=1 if agecb==17
replace age85=1 if agecb==18





