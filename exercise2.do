cd /Users/stanza/documents/github/etc4420
use "gpvisits.dta", replace
//set seed 27886913
// sample 10000, count
// 76.8%...........................
tab gpvisit
proportion gpvisit
//Task A, estimate a linear regression model
reg gpvisit age3039 age4049 age5059 age6069 age70up male lnincome mcity poor fair good verygood
outreg2 using linear, title("Linear regression model") 
//Task A, estimate poisson regression model
poisson gpvisit age3039 age4049 age5059 age6069 age70up male lnincome mcity poor fair good verygood
//estimate marginal effect of poisson model
margins, dydx(*)
//Task A, estimate negative binomial model
nbreg gpvisit age3039 age4049 age5059 age6069 age70up male lnincome mcity poor fair good verygood
//estimate marginal effect of negative binomial model
margins, dydx(*)
