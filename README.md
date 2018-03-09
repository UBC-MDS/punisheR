# PunisheR

[![Build Status](https://travis-ci.org/UBC-MDS/punisheR.svg?branch=master)](https://travis-ci.org/UBC-MDS/punisheR)


PunisheR is a package for feature and model selection in R. Specifically, this package will implement tools for
forward and backward model selection (see [here](https://en.wikipedia.org/wiki/Stepwise_regression)).
In order to measure model quality during the selection procedures, we will also be implement
the Akaike and Bayesian Information Criterion (see below), both of which *punish* complex models -- hence this package's
name.

As examined below, we recognize that well-designed versions of these tools already exist in R.
This is acceptable to us because impetus for this project is primarily pedagogical, intended to
improve our understanding of model selection techniques and collaborative software development.

## Contributors: 

Avinash, Tariq, Jill


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
forward and backward stepwise selection, respectively. Both of these are p-value-based methods of feature selection.
The latter, MASS, contains [`StepAIC()`](https://stat.ethz.ch/R-manual/R-devel/library/MASS/html/stepAIC.html),
which is complete with three modes: forward, backward or both. The selection procedure it uses is based on an
information criterion (AIC), as we intend ours to be.

## How to run unit tests

We are using `testthat` for unit testing in punishR. To run all tests in **RStudiio**, press `Cmd/Ctrl` + `Shift` + `T` . 
