context("forward.R")

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
# Test that the input data parameters (X,y) are in the correct format
# -----------------------------------------------------------------------------

test_that("X_train is a 2D numeric matrix", {
    expect_error(forward(X_train=1234, y_train, X_val, y_val,
                         min_change=0.5, criterion='r-squared',
                         verbose=TRUE), "X must be a 2D numeric matrix")
    expect_error(forward(X_train=matrix(c('a', 'b', 'c', 'd', 'e', 'f'), nrow=2),
                         y_train, X_val, y_val,
                         min_change=0.5, criterion='r-squared',
                         verbose=TRUE), "X must be a 2D numeric matrix")
})

test_that("y_train is a 1D numeric vector", {
    expect_error(forward(X_train, y_train='1234', X_val, y_val,
                         min_change=0.5, criterion='r-squared',
                         verbose=TRUE), "y must be a 1D numeric vector")
    expect_error(forward(X_train,
                         y_train=matrix(c(1,2,3,4,5,6), nrow=2),
                         X_val, y_val,
                         min_change=0.5, criterion='r-squared',
                         verbose=TRUE), "y must be a 1D numeric vector")
})

test_that("X_train and y_train have appropriate dimensions", {
  expect_error(forward(X_train, y_train=1234, X_val, y_val,
                       min_change=0.5, criterion='r-squared',
                       verbose=TRUE), "X and y must have the same number of observations")
})

test_that("X_val is a 2D numeric matrix", {
    expect_error(forward(X_train, y_train, X_val=1234, y_val,
                         min_change=0.5, criterion='r-squared',
                         verbose=TRUE), "X must be a 2D numeric matrix")
    expect_error(forward(X_train, y_train,
                         X_val=matrix(c('a', 'b', 'c', 'd', 'e', 'f'), nrow=2),
                         y_val, min_change=0.5, criterion='r-squared',
                         verbose=TRUE), "X must be a 2D numeric matrix")
})

test_that("y_val is a 1D numeric matrix", {
    expect_error(forward(X_train, y_train, X_val, y_val='1234',
                         min_change=0.5, criterion='r-squared',
                         verbose=TRUE), "y must be a 1D numeric vector")
    expect_error(forward(X_train, y_train, X_val, y_val=matrix(c(1,2,3,4,5,6), nrow=2),
                         min_change=0.5, criterion='r-squared',
                         verbose=TRUE), "y must be a 1D numeric vector")
})

test_that("X_train and y_train have appropriate dimensions", {
    expect_error(forward(X_train, y_train, X_val, y_val=1234,
                         min_change=0.5, criterion='r-squared',
                         verbose=TRUE), "X and y must have the same number of observations")
})


# ------------------------------------------------------------------------------------
# Test that n_feature, min_change, and criterion parameters are in the correct format
# ------------------------------------------------------------------------------------

test_that("n_features must be a positive numeric", {
  # Test that the data params in `forward()`
  # will raise a TypeError when passed something other
  # than a 2D matrix (data) or 1D vector (response variable)
  expect_error(forward(X_train, y_train, X_val, y_val,
                        n_features="abc", criterion='r-squared',
                        verbose=TRUE), "`n_features` must be numeric")
  expect_error(forward(X_train, y_train, X_val, y_val,
                        n_features=-2, criterion='r-squared',
                        verbose=TRUE), "`n_features` must be greater than zero.")
})

test_that("n_features and min_change cannot be active at the same time", {
    expect_error(forward(X_train, y_train, X_val, y_val,
                          n_features=0.5, min_change=0.2, criterion='r-squared',
                          verbose=TRUE), "At least one of `n_features` and `min_change` must be NULL")
})


# -----------------------------------------------------------------------------
# Output format and value
# -----------------------------------------------------------------------------

test_that("forward() selects the best features", {
  # Test that `forward()` will output a vector with the 'best' features
  output <- forward(X_train, y_train, X_val, y_val, min_change=0.5,
                    n_features=NULL, criterion='r-squared', verbose=TRUE)
  expect_length(output, 1)
})

