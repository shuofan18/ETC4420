
**********  Task A **********  Data **********

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

**********  Task A **********  Questions **********

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
graph export histogram.png, replace
//From the tabulation and the four histogram, 
//we can see the relationship between log(income) and GP visits is not linear. 
//The visits increase with the first three income level, 
//and then start to decrease from the third income level.
//We will reproduce the tables in our slides first and then discuss the impact 
//of this nonlinearity afterwards.

//Estimate a linear regression model (Task A Question 1)

reg gpvisit age3039 age4049 age5059 age6069 age70up male logincome/*
*/ mcity poor fair good verygood
outreg2 using linear.xls, replace title(Linear regression model)/*
*/ sideway stats(coef se tstat pval ci) bdec(3) 

//Estimate poisson regression model (Task A Question 1)

poisson gpvisit age3039 age4049 age5059 age6069 age70up male logincome/*
*/ mcity poor fair good verygood
outreg2 using poisson.xls, replace title(poisson regression) sideway/*
*/ stats(coef se tstat pval) bdec(3)

//Estimate marginal effect of Poisson model (Task A Question 1)

margins, dydx(*)
outreg2 using poisson.xls, append sideway stats(coef se tstat)

//Predict number of visits using Poisson model (Task A question 2 table 1 part 1)

predict p_gpvisit, n
sum gpvisit p_gpvisit

//Predicted probability of counts using Poisson model 
//(Task A question 2 table 1 part 3)
//(need to install st0002.pkg here)

prcounts p_visits, max(3)
sum p_visitspr0 p_visitspr1 p_visitspr2 p_visitspr3

//Estimate Negative Binomial model (Task A Question 1)

nbreg gpvisit age3039 age4049 age5059 age6069 age70up male logincome mcity poor/*
*/ fair good verygood
outreg2 using ngbinom.xls, replace title(negative binomial model) sideway/*
*/ stats(coef se tstat pval) bdec(3)

//Estimate marginal effect of Negative Binomial model (Task A Question 1)

margins, dydx(*)
outreg2 using ngbinom.xls, append sideway stats(coef se tstat)

//Predict number of visits using Negative Binomial model
//(Task A question 2 table 2 part 1)

predict nb_gpvisit, n
sum gpvisit nb_gpvisit

//Predicted probability of counts (Task A question 2 table 2 part 3)
//(need to install st0002.pkg here)

prcounts nb_visits, max(3)
sum nb_visitspr0 nb_visitspr1 nb_visitspr2 nb_visitspr3

//Task A Question 3
//Compare my results to those in lecture slides.

//First for the regression results.
//Variables named 'age3039, age4049, age5059, logincome, verygood' are all
//insignificant at 10% significance level in my results for all three models, 
//while only 'age3039' and 'age4049' are insignificant in lecture notes.
//I think this is mainly due to two reasons. The first one is the randomness 
//caused by the sampling. We use a subset of the whole dataset, so it is 
//reasonable to have slightly different results. 
//The second one, which is more important, is related to the fact that the
//'logincome' is not linearly correlated with 'GP visits'. To reproduce the
//output, we put the 'logincome' into all models without adjustment. However, 
//the main information of the impact of 'logincome' was all left in the
//residuals of the regressions, which also caused the superficial insignificance
//of the 'logincome' itself. What's more, people aged from 30 to 59 are often
//the people who have the highest houldhold income, and people aged above or 
//below often earn less, therefore these variables are obviously correlated with  
//residuals. Hence, it is likely that our estimation of age variables are 
//biased and inconsistent. Also, since lecture slides omitted the lowest income
//level as discussed above, although its estimates are also biased and 
//inconsistent, they are slightly different bias as mine.
//Same reasoning applies to the difference between the sign and magnitude of my 
//results and the ones in slides. So while all my regressions estimate a 
//positive effect of log(income) on GP visits, all models in lecture notes 
//estimate them as nagetive. 
//As for estimated coefficients of 'gender', 'living in cities or not' and 
//'self-reported health' are all similar between my results and slides for all
//three models. This is probably because these factors are not as strongly 
//correlated with income as age. Their estimated marginal effects for Poisson 
//and Negative Binomial from my results are very similar to slides too.

//To deal with the non-linearity of log(income), I think we can use dummy 
//variables for different income level instead of treating it as continous.

**********  Task B **********  Data ********** 

cd /Users/stanza/documents/github/etc4420
use "SS hilda.dta", replace

//Introduction and data cleaning.
//We are insterested in the factors determining the weekly wage for the whole 
//Australian population, using the wage data of those who are currently working.
//First, we check the data by looking at the summary statistics. 
sum
///In this dataset, we have variables relating personal earnings, age, gender,
//current employment status, eduction level, number of dependent children,
//having concenssion card or not, self-reported health, and marital status.

//All variables are discrete or dummy variables except income related variables.

//There are a lot of missing values in logincome, which is caused by the zero
//in disposable income. There are also missing values in 'lfp' because many
//people did not respond to the employment status question in the survey. Same 
//with 'esempst' which is a more detailed employment status variable, 'scage'
//which indicating age group,  'male', 'edhigh' which is the highest education 
//level, 'concession' and 'married'.
 
//Since we want to study the weekly wage, we will use 'wscei' as our dependent 
//variable. Also we want to keep as many observations as we could, 
//so we will not use any employment status related variables in this dataset 
//directly. Instead, we will generate a new dummy variable called 'working' 
//indicating if a person is working or not given the value of his/her 'wscei'
//as our selection variable.
//We will also use 'male', detailed 'age' band variables (the youngest group is
//the reference level), and four 'education' levels (less than year 12 will be 
//the reference) as the determinants for the outcome equation. Because age and
//education are obviously have strong correlation with one's wage. And 
//unfortunately, gender is assumed to still have some impact as well.
//'Marital status' and 'dependent children' will be included in the selection 
//equation as extra IVs. Because these two factors will definitely have impact
//on one person's employment status but assumed to be irrelevant to one's wage.

gen working=1 if wscei>0
replace working=0 if wscei<=0
lab var working "=1 for working people, =0 otherwise"

//Check the new variable by looking at its summary statistics.
tab working
//In general, there are 8216 working people in this dataset, while 8216
//non-working people. This 'working' variable may not be necessarily accurate
//given the way we generated it. So we check the cross tabulation of it with 
//other employment status variables.
tab esbrd working
//We can see there are some mismatch between the two, since some 'employee' 
//indicated by 'esbrd' are grouped as 0 in 'working'. This may because some 
//employees did not report the weekly wage. As far as our assignment concerned,
//we will assume the working status are mostly correct specified and use it in 
//our further analysis.

**********  Task B **********  Questions ********** 

set seed 27886913
sample 12000, count

//Check data again after sampling.
sum
//Random sampling works fine.

//Estimate a Heckman sample selection model using Two-step Heckit Estimator
//Task B question 1

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






























