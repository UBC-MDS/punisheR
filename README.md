# PunisheR

[![Build Status](https://travis-ci.org/UBC-MDS/punisheR.svg?branch=master)](https://travis-ci.org/UBC-MDS/punisheR)

[![Coverage status](https://codecov.io/gh/UBC-MDS/punisheR/branch/master/graph/badge.svg)](https://codecov.io/github/UBC-MDS/punisheR?branch=master)


PunisheR is a package for feature and model selection in R. Specifically, this package will implement tools for
forward and backward model selection (see [here](https://en.wikipedia.org/wiki/Stepwise_regression)).
In order to measure model quality during the selection procedures, we will also be implement
the Akaike and Bayesian Information Criterion (see below), both of which *punish* complex models -- hence this package's
name.

As examined below, we recognize that well-designed versions of these tools already exist in R.
This is acceptable to us because impetus for this project is primarily pedagogical, intended to
improve our understanding of model selection techniques and collaborative software development.

## Installation

```
devtools::install_github("UBC-MDS/punisheR")
```

## Functions included:

We will be implementing two stepwise feature selection techniques:

- `forward()`: a feature selection method in which you start with a null model and iteratively add useful features
- `backward()`: a feature selection method in which you start with a full model and iteratively remove the least useful feature at each step

We will also be implementing metrics that evaluate model performance: 

- `aic()`: computes the [Akaike information criterion](https://en.wikipedia.org/wiki/Akaike_information_criterion)
- `bic()`: computes the [Bayesian information criterion](https://en.wikipedia.org/wiki/Bayesian_information_criterion) 

These two criteria will be used to measure the relative quality of models within `forward()` and `backward()`. In general, having more parameters in your model increases prediction accuracy but is highly susceptible to overfitting. AIC and BIC add a penalty for the number of features in a model. The penalty term is larger in BIC than in AIC. The lower the AIC and BIC score, the better the model.

## How does the package fit into the existing R ecosystem?

In the R ecosystem, forward and backward selection are implemented in both the [olsrr](https://cran.r-project.org/web/packages/olsrr/)
and [MASS](https://cran.r-project.org/web/packages/MASS/MASS.pdf) packages. The former provides
[`ols_step_forward()`](https://www.rdocumentation.org/packages/olsrr/versions/0.4.0/topics/ols_step_forward) and
[`ols_step_backward()`](https://www.rdocumentation.org/packages/olsrr/versions/0.4.0/topics/ols_step_backward) for
forward and backward stepwise selection, respectively. Both of these use p-value as a metric for feature selection. Other packages that provide subset selection for regression models are [leaps](https://cran.r-project.org/web/packages/leaps/leaps.pdf) and [bestglm](https://cran.r-project.org/web/packages/bestglm/bestglm.pdf).


The latter, MASS, contains [`StepAIC()`](https://stat.ethz.ch/R-manual/R-devel/library/MASS/html/stepAIC.html),
which is complete with three modes: forward, backward or both. The selection procedure it uses is based on an
information criterion (AIC), as we intend ours to be.

## Usage examples

### Forward Selection using r-squared

``` r

forward(X_train, y_train, X_val, y_val, min_change=0.5,
    n_features=NULL, criterion='r-squared', verbose=FALSE)
#> [1] 10
```
When implementing forward selection on the demo data, it returns a list of features for the best model. Here it can be seen that the function correctly returns only 1 feature; i.e. the feature at position 10.

### Backward Selection using r-squared

``` r

backward(X_train, y_train, X_val, y_val,
    n_features=1, min_change=NULL, criterion='r-squared',
    verbose=FALSE)
#> [1] 10
```

When implementing backward selection on the demo data, it returns a list of features for the best model. Here it can be seen that the function correctly returns only 1 feature; i.e. the feature at position 10.

## How to run unit tests

We are using `testthat` for unit testing in punisheR. To run all tests in **RStudio**, use `Cmd/Ctrl` + `Shift` + `T` or `devtools::test()` in your console. 

## Contributors: 

- Avinash, [@avinashkz](https://github.com/avinashkz)
- Tariq, [@TariqAHassan](https://github.com/TariqAHassan/)
- Jill, [@topspinj](https://github.com/topspinj/)

Instructions and guidelines on how to contribute can be found [here](CONTRIBUTING.md).
To contribute to this project, you must adhere to the terms outlined in our [Contributor Code of Conduct](CONDUCT.md) 
