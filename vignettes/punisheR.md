punisheR
================
Jill Cates, Tariq Hassan, Avinash Prabhakaran
2018-03-16

Introduction
============

PunisheR is a package for feature and model selection in R. Specifically, this package will implement tools for forward and backward model selection. In order to measure model quality during the selection procedures, we have also implemented the Akaike Information Criterion(AIC) and Bayesian Information Criterion(BIC).

Functions included
------------------

The package contains two stepwise feature selection techniques:

-   `forward()`: [Forward selection](https://en.wikipedia.org/wiki/Stepwise_regression#Main_approaches) is starting with one variable and scoring each additional variable using a model fit criterion. The process of adding variables are repeated untill there is no statistically significant improvement in the model.

-   `backward()`: [Backward selection/elimination](https://en.wikipedia.org/wiki/Stepwise_regression#Main_approaches) is starting with all the variables and scoring deletion of each variable using a model fit criterion. The process of deleting variables are repeated untill there is no statistically significant improvement in the model.

Sources: <https://en.wikipedia.org/wiki/Stepwise_regression>

The package contains three metrics that evaluate model performance:

-   `aic()`: The [Akaike information criterion](https://en.wikipedia.org/wiki/Akaike_information_criterion) (AIC) is an estimator of the relative quality of statistical models.

-   `bic()`: The [Bayesian information criterion](https://en.wikipedia.org/wiki/Bayesian_information_criterion) (BIC) is a criterion for model and the penalties associated with BIC is larger than AIC.

-   `r_squared()`: The [Coefficient of determination](https://en.wikipedia.org/wiki/Coefficient_of_determination) is the proportion of the variance in the response variable that can be predicted from the explanatory variable.

These three criteria will be used to measure the relative quality of models within `forward()` and `backward()`. In general, having more parameters in your model increases prediction accuracy but is highly susceptible to overfitting. AIC and BIC add a penalty for the number of features in a model. The lower the AIC and BIC score, the better the model.

How does punisheR fit into the existing R ecosystem?
----------------------------------------------------

In the R ecosystem, forward and backward selection are implemented in both the [olsrr](https://cran.r-project.org/web/packages/olsrr/) and [MASS](https://cran.r-project.org/web/packages/MASS/MASS.pdf) packages. The former provides [`ols_step_forward()`](https://www.rdocumentation.org/packages/olsrr/versions/0.4.0/topics/ols_step_forward) and [`ols_step_backward()`](https://www.rdocumentation.org/packages/olsrr/versions/0.4.0/topics/ols_step_backward) for forward and backward stepwise selection, respectively. Both of these use p-value as a metric for feature selection. The latter, MASS, contains [`StepAIC()`](https://stat.ethz.ch/R-manual/R-devel/library/MASS/html/stepAIC.html), which is complete with three modes: forward, backward or both. The selection procedure it uses is based on aninformation criterion (AIC), as we intend ours to be. Other packages that provide subset selection for regression models are [leaps](https://cran.r-project.org/web/packages/leaps/leaps.pdf) and [bestglm](https://cran.r-project.org/web/packages/bestglm/bestglm.pdf).


``` r
library(knitr)
library(punisheR)
```

``` r
#Loading the demo mtcars data
data <- mtcars_data(99)
X_train <- data[[1]]
y_train <- data[[2]]
X_val <- data[[3]]
y_val <- data[[4]]
```

#### Forward Selection by specifying the number of features

###### Usage example with `aic` as criterion

``` r
forward(X_train, y_train, X_val, y_val, min_change=NULL,
                    n_features=2, criterion='aic', verbose=FALSE)
#> [1] 9 4
```

When implementing forward selection on the mtcars dataset with `hp` as the explanatory variable , it returns a list of features that form the best model. In the above example, the desired number of features has been specified as 2 and the criterion being used is `aic`. The function returns a list of 2 features.

###### Usage example with `bic` as criterion

``` r
forward(X_train, y_train, X_val, y_val, min_change=NULL,
                    n_features=3, criterion='bic', verbose=FALSE)
#> [1] 9 4 8
```

In the above example, the desired number of features has been specified as 3 and the criterion being used is `bic`. The function returns a list of 3 features.

###### Usage example with `r-squared` as criterion

``` r
forward(X_train, y_train, X_val, y_val, min_change=NULL,
                    n_features=4, criterion='r-squared', verbose=FALSE)
#> [1] 2 1 6 3
```

In the above example, the desired number of features has been specified as 4 and the criterion being used is `r-squared`. The function returns a list of 4 features.

#### Forward Selection by specifying the smallest change in criterion

``` r
forward(X_train, y_train, X_val, y_val, min_change=0.5,
                    n_features=NULL, criterion='r-squared', verbose=FALSE)
#> [1] 2 1 6 3 7 5
```

In the example above, `forward` selction returns a list of 6 features when a minimum change of 0.5 is required in `r-squared` score for an additional feature to be selected.

**Note**: When using the criterion as `aic` or `bic`, the value for `min_change` should be carefully selected as `aic` and `bic` tends to have much larger values.

#### Backward Selection by specifying the number of features

``` r
backward(X_train, y_train, X_val, y_val,
                     n_features=7, min_change=NULL, criterion='aic',
                     verbose=FALSE)
#> [1]  1  4  5  7  8  9 10
```

``` r
backward(X_train, y_train, X_val, y_val,
                     n_features=7, min_change=NULL, criterion='bic',
                     verbose=FALSE)
#> [1]  1  4  5  7  8  9 10
```

``` r
backward(X_train, y_train, X_val, y_val,
                     n_features=7, min_change=NULL, criterion='r-squared',
                     verbose=FALSE)
#> [1] 1 2 3 5 6 7 9
```

Similarly, for backward selection, the number of features are specified as 7 and the examples using all the three criterion are provided above.

#### Backward Selection by specifying the smallest change in criterion

``` r
backward(X_train, y_train, X_val, y_val,
                     n_features=NULL, min_change=0.5, criterion='r-squared',
                     verbose=FALSE)
#>  [1]  1  2  3  4  5  6  7  8  9 10
```

In the example above, `backward` selection returns a list of 10 features when the minimum change in the `r-squared` criterion is specified as 0.5.

#### AIC, BIC & *R*<sup>2</sup>

``` r
model <- lm(y_train ~ mpg + cyl + disp, data = X_train)

aic(model)
#> [1] 252.6288
```

``` r
bic(model)
#> [1] 258.5191
```

When scoring the two the model using AIC and BIC, we can see that the penalty when using `bic` is greater than the penalty obtained using `aic`.

``` r
r_squared(model, X_val, y_val)
#> [1] 0.7838625
```

The value returned by the function `r_squared()` will be between 0 and 1.
