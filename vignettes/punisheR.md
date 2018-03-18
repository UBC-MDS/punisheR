A complete guide to punisheR
================
Jill Cates, Tariq Hassan, Avinash Prabhakaran

Introduction
------------

[punisheR](https://github.com/UBC-MDS/punisheR) is a package for feature and model selection in R. Specifically, this package implements tools for forward and backward model selection. In order to measure model quality during the selection procedures, we have also implemented the Akaike Information Criterion (AIC) and Bayesian Information Criterion (BIC).

Functions included
------------------

The package contains two stepwise feature selection techniques:

-   `forward()`: [Forward selection](https://en.wikipedia.org/wiki/Stepwise_regression#Main_approaches) starts with one feature and iteratively adds the features with the best scores using a model fit criterion. The process of adding features is repeated until either the maximum number of features (`n_features`) is reached or the change in score is less than the `min_change` threshold.

-   `backward()`: [Backward selection/elimination](https://en.wikipedia.org/wiki/Stepwise_regression#Main_approaches) starts with all features and iteratively deletes features with the worst scores using model fit criterion. The process of deleting features is repeated until either the maximum number of features (`n_features`) is reached or the change in score is less than the `min_change` threshold.

Sources: <https://en.wikipedia.org/wiki/Stepwise_regression>

The package contains three metrics that evaluate model performance:

-   `aic()`: The [Akaike information criterion](https://en.wikipedia.org/wiki/Akaike_information_criterion) (AIC) adds a penalty term which penalizes more complex models. Its formal definition is: $-2(L)+2\*k $ where *k* is the number of features and *L* is the maximized value of the likelihood function.

-   `bic()`: The [Bayesian information criterion](https://en.wikipedia.org/wiki/Bayesian_information_criterion) adds a penality term which penalizes complex models to a greater extent than AIC. Its formal definition is: −2 \* ln(*L*)+ln(*n*)\**k* where *k* is the number of features, *n* is the number of observations, and *L* is the maximized value of the likelihood function.

-   `r_squared()`: The [coefficient of determination](https://en.wikipedia.org/wiki/Coefficient_of_determination) is the proportion of the variance in the response variable that can be predicted from the explanatory variable.

These three criteria measure the relative quality of models within `forward()` and `backward()` and can be configured using the `criterion` parameter. In general, having more parameters in your model increases prediction accuracy but is highly susceptible to overfitting. AIC and BIC add a penalty for the number of features in a model. The lower the AIC and BIC score, the better the model.

How does punisheR fit into the existing R ecosystem?
----------------------------------------------------

In the R ecosystem, forward and backward selection are implemented in both the [olsrr](https://cran.r-project.org/web/packages/olsrr/) and [MASS](https://cran.r-project.org/web/packages/MASS/MASS.pdf) packages. The former provides [`ols_step_forward()`](https://www.rdocumentation.org/packages/olsrr/versions/0.4.0/topics/ols_step_forward) and [`ols_step_backward()`](https://www.rdocumentation.org/packages/olsrr/versions/0.4.0/topics/ols_step_backward) for forward and backward stepwise selection, respectively. Both of these use p-value as a metric for feature selection. The latter, MASS, contains [`StepAIC()`](https://stat.ethz.ch/R-manual/R-devel/library/MASS/html/stepAIC.html), which is complete with three modes: forward, backward or both. Other packages that provide subset selection for regression models are [leaps](https://cran.r-project.org/web/packages/leaps/leaps.pdf) and [bestglm](https://cran.r-project.org/web/packages/bestglm/bestglm.pdf).

Loading the demo data
---------------------

To demonstrate how punisheR's feature selection and criterion functions work, we will use our demo data `mtcars_data()` which arranges `[mtcars](https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/mtcars.html)` into the correct format for our use cases.

`mtcars_data()` returns a list of 4 dataframes in the following order: X\_train, y\_train, X\_val, and y\_val. Horsepower (`hp`) is the response variable (`y`), while the remaining variables of `mtcars` are the predictive features (`X`). The data is split into training data, which is used to *train* the model, and validation data which *validates* (scores) it.

``` r
# Loading the demo mtcars data
data <- mtcars_data()
X_train <- data[[1]]
y_train <- data[[2]]
X_val <- data[[3]]
y_val <- data[[4]]
```

Forward Selection
-----------------

There are two parameters that determine how features are selected in forward selection:

1.  `n_features` specifies the number of features. If you set `n_features` to 3, the forward selection function will select the 3 best features for your model.
2.  `min_change` specifies the minimum change in score in order to proceed to the next iteration. The function stops when there are no features left that cause a change larger than the threshold `min_change`.

In order for forward selection to work, only one of `n_features` and `min_change` can be active. The other must be set to NULL.

Let's look at how `n_features` works within forward selection:

###### a) Usage example with `aic` as criterion

``` r
forward(X_train, y_train, X_val, y_val, min_change=NULL,
                    n_features=2, criterion='aic', verbose=FALSE)
#> [1] 9 4
```

When implementing forward selection on the mtcars dataset with `hp` as the response variable , it returns a list of features that form the best model. In the above example, the desired number of features has been specified as 2 and the criterion being used is `aic`. The function returns a list of 2 features.

###### b) Usage example with `bic` as criterion

``` r
forward(X_train, y_train, X_val, y_val, min_change=NULL,
                    n_features=3, criterion='bic', verbose=FALSE)
#> [1] 9 4 8
```

In the above example, the desired number of features has been specified as 3 and the criterion being used is `bic`. The function returns a list of 3 features.

###### c) Usage example with `r-squared` as criterion

``` r
forward(X_train, y_train, X_val, y_val, min_change=NULL,
                    n_features=4, criterion='r-squared', verbose=FALSE)
#> [1] 2 1 6 3
```

In the above example, the desired number of features has been specified as 4 and the criterion being used is `r-squared`. The function returns a list of 4 features.

Forward selection also works by specifying the smallest change in criterion, `min_change`:

``` r
forward(X_train, y_train, X_val, y_val, min_change=0.5,
                    n_features=NULL, criterion='r-squared', verbose=FALSE)
#> [1] 2 1 6 3 7 5
```

In the example above, `forward` selction returns a list of 6 features when a minimum change of 0.5 is required in `r-squared`'s score for an additional feature to be selected.

**Note**: When using the criterion as `aic` or `bic`, the value for `min_change` should be carefully selected as `aic` and `bic` tend to have much larger values than `r-squared`.

Backward Selection
------------------

Backward selection works in the same way as forward selection such that you must configure `n_features` or `min_change`, as well as the `criterion` to score the model.

###### a) Usage example with `aic` as criterion

``` r
backward(X_train, y_train, X_val, y_val,
                     n_features=7, min_change=NULL, criterion='aic',
                     verbose=FALSE)
#> [1]  1  4  5  7  8  9 10
```

###### b) Usage example with `bic` as criterion

``` r
backward(X_train, y_train, X_val, y_val,
                     n_features=7, min_change=NULL, criterion='bic',
                     verbose=FALSE)
#> [1]  1  4  5  7  8  9 10
```

###### c) Usage example with `r-squared` as criterion

``` r
backward(X_train, y_train, X_val, y_val,
                     n_features=7, min_change=NULL, criterion='r-squared',
                     verbose=FALSE)
#> [1] 1 2 3 5 6 7 9
```

With `n_features` configured to 7, each example above returns the 7 best features based on model score. You can see above that changing the criterion can result in a different output of "best" features.

In the example below, `backward` selection returns a list of 10 features when the `min_change` in the `r-squared` criterion is specified as 0.5.

``` r
backward(X_train, y_train, X_val, y_val,
                     n_features=NULL, min_change=0.5, criterion='r-squared',
                     verbose=FALSE)
#>  [1]  1  2  3  4  5  6  7  8  9 10
```

AIC, BIC & *R*<sup>2</sup>
--------------------------

punisheR also provides three standalone functions to compute AIC, BIC, and *R*<sup>2</sup>. For `aic()` and `bic()` you simply need to pass in the model (e.g., a `lm()` object). You can also pass in the validation data and response variable (`X_val`, `y_val`). By default, `X` and `y` are extracted from the model.

``` r
model <- lm(y_train ~ mpg + cyl + disp, data = X_train)
```

``` r
aic(model, X_val, y_val)
#> [1] 217.1279

bic(model, X_val, y_val)
#> [1] 223.0182
```

When scoring the model using AIC and BIC, we can see that the penalty when using `bic` is greater than the penalty obtained using `aic`.

``` r
r_squared(model, X_val, y_val)
#> [1] 0.7838625
```

The value returned by the function `r_squared()` will be between 0 and 1.
