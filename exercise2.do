cd \\ad.monash.edu\home\User079\szha0076\desktop
use "gpvisits.dta", replace
//set seed 27886913
//sample 10000, count
// 76.8%...........................(different with slides even before random selection)
//Task A Question 2, (table 1 & 2 part 2), observed probability of count
tab gpvisit
proportion gpvisit
//Task A Question 1, estimate a linear regression model 

reg gpvisit age3039 age4049 age5059 age6069 age70up male lnincome mcity poor fair good verygood
outreg2 using linear.xls, replace title(Linear regression model) sideway stats(coef se tstat pval ci) bdec(3) 

//Task A question 1, estimate poisson regression model 

poisson gpvisit age3039 age4049 age5059 age6069 age70up male lnincome mcity poor fair good verygood
outreg2 using poisson.xls, replace title(poisson regression) sideway stats(coef se tstat pval) bdec(3)
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

//Task A, estimate negative binomial model
nbreg gpvisit age3039 age4049 age5059 age6069 age70up male lnincome mcity poor fair good verygood
outreg2 using ngbinom.xls, replace title(negative binomial regression) sideway stats(coef se tstat pval) bdec(3)
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
