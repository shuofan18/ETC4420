cd /Users/stanza/documents/github/etc4420
use "gpvisits.dta", replace
//Introduction and data cleaning.
//We are interested in the impact of individual characteristics on GP visits.
//First, we check the data by looking at the summary statistics. 
sum
//In this dataset, we have information relating household income, age, gender,
//living in cities or not, self-reported health, and number of times consulted 
//GP in the last few weeks.
//All variables are discrete or dummy variables except 'income' and 'lnincome'.
//All variables have 19501 observations except 'lnincome'(which has only 16828)
//So check if 'income' looks normal. 
tab income
sum income
//All values associated with income are positive, no zero values are detected.
//Generate a new variable named logincome and label it as log(income).
gen logincome=log(income)
lab var logincome "log(income)"
//Check if the new log(income) has any missing values.
tab logincome
sum logincome
//There is no missing values in the new log(income). 
//And logincome is ranging from 4.5951 to 7.3132.
//By comparing logincome with lnincome (which is ranging from 5.2983 to 7.3132), 
//the lowest income (99) was found missing in lnincome. Given this, we will not
//use lnincome in our following regressions, instead, we will use logincome.
//Then we check the dependent variable gpvisit.
tab gpvisit
proportion gpvisit
//In 2004-05, 76.8% of individuals did not visit a GP, 19.22% visited once, 
//3.2% visited twice and 0.9% visted 3 or more times.
//With the data all clean, we are now ready to do the analysis.

**********  Task A **********

set seed 27886913
sample 10000, count
//Check if the sampling works as expected.
sum
//After sampling, we have 10000 observations, the data looks clean.
//Check the dependent variable again after sampling.
//Observed probability of count (Task A Question 2 table 1 & 2 part 2)
tab gpvisit
proportion gpvisit
//In this subset, in 2004-05, 76.3% of individuals did not visit a GP, 
//19.52% visited once, 3.16% visited twice and 0.98% visted 3 or more times.
//All numbers are similar to what we got from the whole sample.

//We will use gpvisit as our dependent variable; age, gender, income, living in 
//cities or not, self-reported health as our independent variables.
//First check relationship between income and GP visits by cross tabulation and 
//histgram since we want to treat log(income) as continuous.
bysort gpvisit: tab logincome
histogram logincome, percent by (gpvisit)
graph export histogram.png
//From the tabulation and the four histogram, 
//we can see the relationship between log(income) and GP visits is not linear. 
//The visits increase with the first three income level, 
//and then start to decrease from the third income level.
//We will reproduce the tables in our slides first and then discuss the impact 
//of this nonlinearity afterwards.

//Task A Question 1, estimate a linear regression model 
reg gpvisit age3039 age4049 age5059 age6069 age70up male logincome/*
*/ mcity poor fair good verygood
outreg2 using linear.xls, replace title(Linear regression model)/*
*/ sideway stats(coef se tstat pval ci) bdec(3) 

//Task A question 1, estimate poisson regression model 

poisson gpvisit age3039 age4049 age5059 age6069 age70up male logincome/*
*/ mcity poor fair good verygood
outreg2 using poisson.xls, replace title(poisson regression) sideway/*
*/ stats(coef se tstat pval) bdec(3)
//Task A question 1, estimate marginal effect of poisson model
margins, dydx(*)
outreg2 using poisson.xls, append sideway stats(coef se tstat)
//Task A question 2, (table 1 part 1), predict number of visits
predict p_gpvisit, n
sum gpvisit p_gpvisit
//Task A question 2, (table 1 part 3), predicted probability of counts
//(need to install st0002.pkg here)
prcounts p_visits, max(3)
sum p_visitspr0 p_visitspr1 p_visitspr2 p_visitspr3

//Task A, estimate negative binomial model ******** weird alpha***********
nbreg gpvisit age3039 age4049 age5059 age6069 age70up male logincome mcity poor/*
*/ fair good verygood
outreg2 using ngbinom.xls, replace title(negative binomial regression) sideway/*
*/ stats(coef se tstat pval) bdec(3)
//estimate marginal effect of negative binomial model
margins, dydx(*)
outreg2 using ngbinom.xls, append sideway stats(coef se tstat)
//Task A question 2, (table 2 part 1), predict number of visits
predict nb_gpvisit, n
sum gpvisit nb_gpvisit
//Task A question 2, (table 2 part 3), predicted probability of counts
//(need to install st0002.pkg here)
prcounts nb_visits, max(3)
sum nb_visitspr0 nb_visitspr1 nb_visitspr2 nb_visitspr3

*********************************Task B************************************** 
cd /Users/stanza/documents/github/etc4420
use "SS hilda.dta", replace
set seed 27886913
sample 12000, count
//Task B question 1, generate a binary variable "working"
gen working=1 if wscei>0
replace working=0 if wscei<=0
//Task B question 1,
//Estimate a Heckman sample selection model using Two-step Heckit Estimator
heckman wscei age1517 age1819 age2021 age2224 age2534 age3544 age4554/*
*/ age5564 age6574  male bachabv dipcert year12, select(working = age1517/*
*/ age1819 age2021 age2224 age2534 age3544 age4554 age5564 age6574  male /*
*/bachabv dipcert year12 married depkid) twostep
//Task B question 1, estimate a Heckman sample selection model using MLE
heckman wscei age1517 age1819 age2021 age2224 age2534 age3544 age4554/*
*/ age5564 age6574  male bachabv dipcert year12, select(working = age1517/*
*/ age1819 age2021 age2224 age2534 age3544 age4554 age5564 age6574  male /*
*/bachabv dipcert year12 married depkid)

//Task B question 2, marginal effects of E(y)
margins, dydx(*) atmean
/***** marginal effects of E(y|z=1) ***/
margins, dydx(*) predict(ycond) atmean






























