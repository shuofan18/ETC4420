cd \\ad.monash.edu\home\User079\szha0076\desktop
use "gpvisits.dta", replace
//set seed 27886913
// sample 10000, count
// 76.8%...........................(different with slides even before random selection)
tab gpvisit
proportion gpvisit
//Task A, estimate a linear regression model 
////////////////////////////////////////////(how to change columns name?????????????????)

reg gpvisit age3039 age4049 age5059 age6069 age70up male lnincome mcity poor fair good verygood
outreg2 using linear, replace title(Linear regression model) sideway stats(coef se tstat pval ci) bdec(3) 

//Task A, estimate poisson regression model 
///////////////////////////////////////////(how to put all files into one?????????????????)

poisson gpvisit age3039 age4049 age5059 age6069 age70up male lnincome mcity poor fair good verygood
outreg2 using poisson, replace title(poisson regression) sideway stats(coef se tstat pval) bdec(3)
//estimate marginal effect of poisson model
margins, dydx(*)
outreg2 using poisson, append sideway stats(coef se tstat)

//Task A, estimate negative binomial model
nbreg gpvisit age3039 age4049 age5059 age6069 age70up male lnincome mcity poor fair good verygood
outreg2 using ngbinom, replace title(negative binomial regression) sideway stats(coef se tstat pval) bdec(3)
//estimate marginal effect of negative binomial model
margins, dydx(*)
outreg2 using ngbinom, append sideway stats(coef se tstat)

//panelout, save(panelstuff.txt) use(myfile1.txt myfile2.txt) excel replace
