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
# `model` Param
# -----------------------------------------------------------------------------

test_that("model input is a Base-R model", {
  # Test that the `model` param in `forward()`
  # will raise a TypeError when passed something other
  # than a Base R model.
  expect_error(forward(1234, X_train, y_train, X_val, y_val,
                        min_change=0.5, n_features, criterion='aic',
                        verbose=TRUE), "`model` not a Base-R Model.")
})

# -----------------------------------------------------------------------------
# Data Params
# -----------------------------------------------------------------------------

test_that("model data is in the correct format", {
  # Test that the data params in `forward()` will raise
  # a TypeError when passed something other than a
  # 2D matrix (features) or 1D vector (response variable) where
  # X is 'features' and Y is the response variable
  expect_error(forward(1234, y_train, X_val, y_val,
                        min_change=0.5, n_features, criterion='aic',
                        verbose=TRUE), "`X_train` matrix is not a 2D matrix.")
  expect_error(forward(X_train, 1234, X_val, y_val,
                        min_change=0.5, n_features=2, criterion='aic',
                        verbose=TRUE), "`y_train` is not a 1D vector.")
  expect_error(forward(X_train, y_train, 1234, y_val,
                        min_change=0.5, n_features=2, criterion='aic',
                        verbose=TRUE), "`X_val` is not a 2D matrix.")
  expect_error(forward(X_train, y_train, X_val, 1234,
                        min_change=0.5, n_features=2, criterion='aic',
                        verbose=TRUE), "`y_val` is not a 1D vector.")
})


test_that("n_features must be a positive integer", {
  # Test that the data params in `forward()`
  # will raise a TypeError when passed something other
  # than a 2D matrix (data) or 1D vector (response variable)
  expect_error(forward(X_train, y_train, X_val, y_val,
                        min_change=0.5, n_features="abc", criterion='aic',
                        verbose=TRUE), "`n_features` is not of type `int`")
  expect_error(forward(X_train, y_train, X_val, y_val,
                        min_change=0.5, n_features=-2, criterion='aic',
                        verbose=TRUE), "`n_features` should be a positive `int`")
})


# -----------------------------------------------------------------------------
# Output format and value
# -----------------------------------------------------------------------------

test_that("forward() selects the best features", {
  # Test that `forward()` will output a vector with the 'best' features
  output <- forward(X_train, y_train, X_val, y_val,
                     n_features=2, min_change=0.5, criterion='aic',
                     verbose=TRUE)
  expect_output(output, list(1,4))
  expect_length(output, 2)
})



# Rough way to test forward()'s output.
# This will have to be turned into a
# formal `testthat` test.
#
# Note: I don't think you can import
# the data with source during testing
# (perhaps you can?).
#
# source("R/forward.R")
# source("tests/testthat/data_for_tests.R")
# forward_result <- forward(
#     X_train=X_train, y_train=y_train,
#     X_val=X_val, y_val=y_val, verbose=FALSE)
# TRUE_BEST_FEATURE %in% forward_result

