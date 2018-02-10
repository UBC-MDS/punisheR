# PunisheR

## How the packages fit into the existing R and Python ecosystems ?

In Python ecosystem, forward selection has been implemented in scikit learn by the 
[f_regression](http://scikit-learn.org/stable/modules/generated/sklearn.feature_selection.f_regression.html) function. The function uses Linear model for testing the individual effect of each of many regressors. It has been implemented as a scoring function to be used in feature seletion procedure. The backward selection has also been implemented in scikit learn by the [RFE](http://scikit-learn.org/stable/modules/generated/sklearn.feature_selection.RFE.html) function. RFE uses an external estimator that assigns weights to features and it prunes the number of features by recursively considering smaller and smaller sets of features until the desired number of features to select is eventually reached. Whereas, in R ecosystem, forward and backward selection are implemented by [olsrr package](https://cran.r-project.org/web/packages/olsrr/)
and in [MASS package](https://cran.r-project.org/web/packages/MASS/MASS.pdf) by function 
[StepAIC](https://stat.ethz.ch/R-manual/R-devel/library/MASS/html/stepAIC.html). StepAIC performs stepwise selection (forward, backward, both) by exact AIC.

