context("backward.R")

# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------

source('data_for_tests.R')
data <- test_data(99)
X_train <- data[[1]]
y_train <- data[[2]]
X_val <- data[[3]]
y_val <- data[[4]]


# -----------------------------------------------------------------------------
# Data Params
# -----------------------------------------------------------------------------

test_that("X_train is a 2D numeric matrix", {
    expect_error(backward(X_train=1234, y_train, X_val, y_val,
                          criterion='r-squared',
                          verbose=TRUE), "X must be a 2D numeric matrix")
    expect_error(backward(X_train=matrix(c('a', 'b', 'c', 'd', 'e', 'f'), nrow=2),
                          y_train, X_val, y_val,
                          criterion='r-squared',
                          verbose=TRUE), "X must be a 2D numeric matrix")
})

test_that("y_train is a 1D numeric vector", {
    expect_error(backward(X_train, y_train='1234', X_val, y_val,
                          n_features=0.5, criterion='r-squared',
                          verbose=TRUE), "y must be a 1D numeric vector")
    expect_error(backward(X_train, y_train=matrix(c(1,2,3,4,5,6), nrow=2),
                          X_val, y_val,
                          n_features=0.5, criterion='r-squared',
                          verbose=TRUE), "y must be a 1D numeric vector")
})

test_that("X_train and y_train have appropriate dimensions", {
    expect_error(backward(X_train, y_train=1234, X_val, y_val,
                          n_features=0.5, criterion='r-squared',
                          verbose=TRUE), "X and y must have the same number of observations")
})

test_that("X_val is a 2D numeric matrix", {
    expect_error(backward(X_train, y_train, X_val=1234, y_val,
                          n_features=0.5, criterion='r-squared',
                          verbose=TRUE), "X must be a 2D numeric matrix")
    expect_error(backward(X_train, y_train,
                          X_val=matrix(c('a', 'b', 'c', 'd', 'e', 'f'), nrow=2), y_val,
                          n_features=0.5, criterion='r-squared',
                          verbose=TRUE), "X must be a 2D numeric matrix")
})

test_that("y_val is a 1D numeric matrix", {
    expect_error(backward(X_train, y_train, X_val,
                          y_val=matrix(c(2, 4, 3, 1, 5, 7), nrow=2),
                          n_features=0.5, criterion='r-squared',
                          verbose=TRUE), "y must be a 1D numeric vector")
    expect_error(backward(X_train, y_train, X_val,
                          y_val='xyz',
                          n_features=0.5, criterion='r-squared',
                          verbose=TRUE), "y must be a 1D numeric vector")
})

test_that("X_train and y_train have appropriate dimensions", {
    expect_error(backward(X_train, y_train, X_val, y_val=1234,
                          n_features=0.5, criterion='r-squared',
                          verbose=TRUE), "X and y must have the same number of observations")
})



test_that("n_features must be a positive integer", {
    # Test that the data params in `backward()`
    # will raise a TypeError when passed something other
    # than a 2D matrix (data) or 1D vector (response variable)
    expect_error(backward(X_train, y_train, X_val, y_val,
                          n_features="abc", criterion='r-squared',
                          verbose=TRUE), "`n_features` must be numeric")
    expect_error(backward(X_train, y_train, X_val, y_val,
                          n_features=-2, criterion='r-squared',
                          verbose=TRUE), "`n_features` must be greater than zero")
})

test_that("n_features and min_change cannot be active at the same time", {
    expect_error(backward(X_train, y_train, X_val, y_val,
                          n_features=0.5, min_change=0.2,criterion='r-squared',
                          verbose=TRUE), "At least one of `n_features` and `min_change` must be NULL")
})


test_that("criterion param must be either aic or bic", {
    # Test that the `criterion` param will raise a TypeError
    # when passed something other than 'aic' or 'bic'
    expect_error(backward(X_train, y_train, X_val, y_val,
                    n_features=0.5, criterion="abc",
                    verbose=TRUE), "`criterion` must be on of: 'r-squared', 'aic', 'bic'")
})

# -----------------------------------------------------------------------------
# Output format and value
# -----------------------------------------------------------------------------

test_that("backward() selects the best features", {
    # Test that `backward()` will output a vector with the 'best' features
    output <- backward(X_train, y_train, X_val, y_val,
                     n_features=1, criterion='r-squared',
                     verbose=TRUE)
    expect_equal(output, c(10))
    expect_length(output, 1)
})

test_that("backward() selects the best features", {
    # Test that `backward()` will output a vector with the 'best' features
    output <- backward(X_train, y_train, X_val, y_val,
                       min_change=NULL, n_features=1,
                       criterion='r-squared', verbose=TRUE)
    expect_equal(output, c(10))
    expect_length(output, 1)
})

