punisheR
================
Jill Cates, Tariq Hassan, Avinash Prabhakaran
2018-03-15

Introduction
============

PunisheR is a package for feature and model selection in R. Specifically, this package will implement tools for forward and backward model selection. In order to measure model quality during the selection procedures, we have also implemented the Akaike Information Criterion(AIC) and Bayesian Information Criterion(BIC).

Functions included
------------------

The package contains two stepwise feature selection techniques:

-   `forward()`: [Forward selection](https://en.wikipedia.org/wiki/Stepwise_regression#Main_approaches) is starting with one variable and scoring each additional variable using a model fit criterion. The process of adding variables are repeated untill there is no statistically significant improvement in the model.

-   `backward()`: [Backward selection/elimination](https://en.wikipedia.org/wiki/Stepwise_regression#Main_approaches) is starting with all the variables and scoring deletion of each variable using a model fit criterion. The process of deleting variables are repeated untill there is no statistically significant improvement in the model.

Sources: <https://en.wikipedia.org/wiki/Stepwise_regression>

The package contains two metrics that evaluate model performance:

-   `aic()`: The [Akaike information criterion](https://en.wikipedia.org/wiki/Akaike_information_criterion) (AIC) is an estimator of the relative quality of statistical models.

-   `bic()`: The [Bayesian information criterion](https://en.wikipedia.org/wiki/Bayesian_information_criterion) (BIC) is a criterion for model and the penalties associated with BIC is larger than AIC.

These two criteria will be used to measure the relative quality of models within `forward()` and `backward()`. In general, having more parameters in your model increases prediction accuracy but is highly susceptible to overfitting. AIC and BIC add a penalty for the number of features in a model. The lower the AIC and BIC score, the better the model.

How does punisheR fit into the existing R ecosystem?
----------------------------------------------------

In the R ecosystem, forward and backward selection are implemented in both the [olsrr](https://cran.r-project.org/web/packages/olsrr/) and [MASS](https://cran.r-project.org/web/packages/MASS/MASS.pdf) packages. The former provides [`ols_step_forward()`](https://www.rdocumentation.org/packages/olsrr/versions/0.4.0/topics/ols_step_forward) and [`ols_step_backward()`](https://www.rdocumentation.org/packages/olsrr/versions/0.4.0/topics/ols_step_backward) for forward and backward stepwise selection, respectively. Both of these are p-value-based methods of feature selection. The latter, MASS, contains [`StepAIC()`](https://stat.ethz.ch/R-manual/R-devel/library/MASS/html/stepAIC.html), which is complete with three modes: forward, backward or both. The selection procedure it uses is based on an information criterion (AIC), as we intend ours to be.

``` r
library(knitr)
library(punisheR)
```

``` r
#Loading the demo data
data <- test_data(99)
X_train <- data[[1]]
y_train <- data[[2]]
X_val <- data[[3]]
y_val <- data[[4]]

#Training data set
kable(as.data.frame(X_train[1:5,])) 
```

|   V1|   V2|   V3|   V4|   V5|   V6|   V7|   V8|   V9|        V10|  V11|  V12|  V13|  V14|  V15|  V16|  V17|  V18|  V19|  V20|
|----:|----:|----:|----:|----:|----:|----:|----:|----:|----------:|----:|----:|----:|----:|----:|----:|----:|----:|----:|----:|
|    0|    0|    0|    0|    0|    0|    0|    0|    0|  30.235593|    0|    0|    0|    0|    0|    0|    0|    0|    0|    0|
|    0|    0|    0|    0|    0|    0|    0|    0|    0|   7.689084|    0|    0|    0|    0|    0|    0|    0|    0|    0|    0|
|    0|    0|    0|    0|    0|    0|    0|    0|    0|  37.213237|    0|    0|    0|    0|    0|    0|    0|    0|    0|    0|
|    0|    0|    0|    0|    0|    0|    0|    0|    0|  53.625439|    0|    0|    0|    0|    0|    0|    0|    0|    0|    0|
|    0|    0|    0|    0|    0|    0|    0|    0|    0|  31.749679|    0|    0|    0|    0|    0|    0|    0|    0|    0|    0|

#### Forward Selection

``` r

forward(X_train, y_train, X_val, y_val, min_change=0.5,
                    n_features=NULL, criterion='r-squared', verbose=FALSE)
#> [1] 10
```

When implementing forward selection on the demo data, it returns a list of features for the best model. Here it can be seen that the function correctly returns only 1 feature.

#### Backward Selection

``` r

backward(X_train, y_train, X_val, y_val,
                     n_features=1, min_change=NULL, criterion='r-squared',
                     verbose=FALSE)
#> [1] 10
```

When implementing backward selection on the demo data, it returns a list of features for the best model. Here it can be seen that the function correctly returns only 1 feature.

#### AIC & BIC

``` r

model <- lm(y_train~X_train)

aic(model)
#> [1] 3076.406

bic(model)
#> [1] 3088.187
```

When scoring the two the model using AIC and BIC, we can see that the penalty when using `bic` is greater than the penalty obtained using `aic`.
