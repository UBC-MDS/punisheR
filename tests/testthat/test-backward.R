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


test_that("smoke test", {
    output <- backward(X_train, y_train, X_val, y_val,
                       n_features=0.5, min_change=NULL, criterion='r-squared',
                       verbose=TRUE)
    expect_true(length(output) > 0)
})


# -----------------------------------------------------------------------------
# Data Params
# -----------------------------------------------------------------------------


test_that("model data is in the correct format", {
    # Test that the data params in `backward()` will raise
    # a TypeError when passed something other than a
    # 2D matrix (features) or 1D vector (response variable) where
    # X is 'features' and Y is the response variable
    expect_error(backward(X_train=1234, y_train, X_val, y_val,
                          criterion='r-squared',
                          verbose=TRUE), "X_train must be a 2D matrix")
    expect_error(backward(X_train, y_train=1234, X_val, y_val,
                          n_features=0.5, criterion='r-squared',
                          verbose=TRUE), "y_train must be a 1D vector")
    expect_error(backward(X_train, y_train, X_val=1234, y_val,
                          n_features=0.5, criterion='r-squared',
                          verbose=TRUE), "X_val must be a 2D matrix")
    expect_error(backward(X_train, y_train, X_val, y_val=1234,
                          n_features=0.5, criterion='r-squared',
                          verbose=TRUE), "y_val must be a 1D vector")
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
                     n_features=0.5, criterion='r-squared',
                     verbose=TRUE)
    expect_output(output, list(1,4))
    expect_length(output, 2)
})

# Rough way to test backwards()'s output.
# This will have to be turned into a
# formal `testthat` test.
#
# source("R/backward.R")
# source("tests/testthat/data_for_tests.R")
# backward_result <- backward(
#     X_train=X_train, y_train=y_train,
#     X_val=X_val, y_val=y_val, n_features=1,
#     min_change=NULL, verbose=FALSE)
# TRUE_BEST_FEATURE %in% backward_result

