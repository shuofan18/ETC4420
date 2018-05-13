
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
//variable. So we check its histogram.
histogram wscei
//From this histogram we can see 'wscei' is not normally distributed, actually 
//its distribution looks like exponential distribution, where it may be better 
//to do log transformation to it and then analyse. 
gen logwscei=log(wscei)
histogram logwscei
//Hence, we generated a new variable named logwscei which is the log(wscei).
//And we can see its histogram looks much more like normal than wscei.
//But now we have much less observations since a lot of missing values are 
//generated by this log-transformation. This could be a problem for Tobit model.
//Therefore, we will follow the instruction in our exercise first and talk
//about this issue later on.
//Also we want to keep as many observations as we could, 
//so we will not use any employment status related variables in this dataset 
//directly. Instead, we will generate a new dummy variable called 'working' 
//indicating if a person is working or not given the value of his/her 'wscei'
//as our selection variable.
//We will also use 'male', detailed 'age' band variables (the youngest group is
//the reference level), and four 'education' levels (less than year 12 will be 
//the reference) as the determinants for the outcome equation. Because age and
//education are obviously have strong correlation with one's wage. To confirm,
//we do cross tabulation for age and wage.
tab scage, summarize(wscei)
//From this cross tabulation, we can see strong relationship between 'age' and 
//'wscei'. Wage is increasing with age before 45-54, and dreasing with it after.
//Unfortunately, gender is assumed to still have some impact as well.
//'Marital status' and 'dependent children' will be included in the selection 
//equation as extra IVs. Because these two factors will definitely have impact
//on one person's employment status but assumed to be irrelevant to one's wage.

gen working = wscei != 0
lab var working "=1 for working people, =0 otherwise"

//Check the new variable by looking at its summary statistics.
tab working
//In this subset, there are 8216 working people indicated by 'working', while 
//8216 non-working people. This 'working' variable maybe not necessarily accurate
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
//Task B Question 1

heckman wscei age1819 age2021 age2224 age2534 age3544 age4554 age5564 age6574 /*
*/age75above male bachabv dipcert year12, select(working =age1819 age2021 /*
*/age2224 age2534 age3544 age4554 age5564 age6574  age75above male bachabv /*
*/dipcert year12 married depkid) twostep
estimate store heckman_2step

//Estimate a Heckman sample selection model using MLE
//Task B Question 1

heckman wscei age1819 age2021 age2224 age2534 age3544 age4554 age5564 age6574 /*
*/age75above male bachabv dipcert year12, select(working =age1819 age2021 /*
*/age2224 age2534 age3544 age4554 age5564 age6574  age75above male bachabv /*
*/dipcert year12 married depkid)

estimate store heckman_mle
estimate table heckman_2step heckman_mle
//As we can see, the estimated coefficients are very different for these two
//methods in the outcome equation. I think the reason for that is what we 
//mentioned above, the normal assumption is clearly violated in this case, 
//so the estimated standard deviations are very large. Hence the estimates are
//very sensitive to the change in estimating methods.

//What's more, we can see the estimated rho is negative. Intuitively, it is more
//reasonable to be positive. The residuals in the outcome equation and the 
//selection equation maybe positively correlted. Because the unobserved factors
//that make people working are more likely to also make people earn more.
//I think this may due to the lack of good IVs. Or it could be x variables take
//too much information in residuals which over-compensated the issue. Or maybe
//our dataset is not a good one.

//Estimate the marginal effects for E('wscei') and E('wscei'|working=1) based on 
//the MLE model above.
//Task B Question 2

//marginal effects at means for E('wscei'), unconditional ME
quietly heckman wscei age1819 age2021 age2224 age2534 age3544 age4554 age5564 age6574 /*
*/age75above male bachabv dipcert year12, select(working =age1819 age2021 /*
*/age2224 age2534 age3544 age4554 age5564 age6574  age75above male bachabv /*
*/dipcert year12 married depkid)
margins, dydx(*) atmean

//marginal effects at means for E('wscei'|working=1), conditional ME
margins, dydx(*) predict(ycond) atmean
//Continued from our previous discussion about the negative rho, we can see 
//some weird results from these two marginal effects. For instance, the marginal 
//effect of achieving bachelor degree is larger on the working group which is 
//582.4258 while 558.4575 on the whole population. In reality, we think
//education should have bigger marginal effect on the whole population than 
//the working people since employees are often have higher education level than
//unemployees. This result is caused by the fact that our estimated rho is
//negative.

//Estimate a Tobit model for 'wscei' with a left censoring point of wscei=0.
//Task B Question 3

tobit wscei age1819 age2021 age2224 age2534 age3544 age4554/*
*/ age5564 age6574 age75above male bachabv dipcert year12, ll

//Unconditional marginal effects at means for E('wscei')
margins, dydx(*) atmean
//The β coefficients themselves measure how the unobserved variable y* changes 
//with respect to changes in the regressors. That's why these marginal effects
//are the same with our coefficient estimates in Tobit model.


//conditional marginal effects at means for E('wscei'|working=1)
margins, dydx(*) predict(ystar(0,.)) atmean
/


























