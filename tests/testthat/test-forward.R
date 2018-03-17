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
# Data Params
# -----------------------------------------------------------------------------

test_that("X_train is a 2D numeric matrix", {
    # Test that `forward()` raises an error when
    # X_train is numeric but is not a 2D matrix
    expect_error(
        forward(
            X_train = 1234,
            y_train,
            X_val,
            y_val,
            min_change = 0.5,
            criterion = 'r-squared',
            verbose = FALSE
        ),
        "X must be a 2D numeric matrix"
    )
    # Test that `forward()` raises an error when
    # X_train is a 2D matrix but is not numeric
    expect_error(
        forward(
            X_train = matrix(c('a', 'b', 'c', 'd', 'e', 'f'), nrow = 2),
            y_train,
            X_val,
            y_val,
            min_change = 0.5,
            criterion = 'r-squared',
            verbose = FALSE
        ),
        "X must be a 2D numeric matrix"
    )
})

test_that("y_train is a 1D numeric vector", {
    # Test that `forward()` raises an error when
    # y_train is a 1D vector but is not numeric
    expect_error(
        forward(
            X_train,
            y_train = '1234',
            X_val,
            y_val,
            min_change = 0.5,
            criterion = 'r-squared',
            verbose = FALSE
        ),
        "y must be a 1D numeric vector"
    )
    # Test that `forward()` raises an error when
    # y_train is numeric but is not a 1D vector
    expect_error(
        forward(
            X_train,
            y_train = matrix(c(1, 2, 3, 4, 5, 6), nrow = 2),
            X_val,
            y_val,
            min_change = 0.5,
            criterion = 'r-squared',
            verbose = FALSE
        ),
        "y must be a 1D numeric vector"
    )
})

test_that("X_train and y_train have appropriate dimensions", {
    # Test that `forward()` raises an error when
    # X_train and y_train do not have the same number of rows
    expect_error(
        forward(
            X_train,
            y_train = 1234,
            X_val,
            y_val,
            min_change = 0.5,
            criterion = 'r-squared',
            verbose = FALSE
        ),
        "X and y must have the same number of observations"
    )
})

test_that("X_val is a 2D numeric matrix", {
    # Test that `forward()` raises an error when
    # X_val is numeric but is not a 2D matrix
    expect_error(
        forward(
            X_train,
            y_train,
            X_val = 1234,
            y_val,
            min_change = 0.5,
            criterion = 'r-squared',
            verbose = FALSE
        ),
        "X must be a 2D numeric matrix"
    )
    # Test that `forward()` raises an error when
    # X_val is a 2D matrix but is not numeric
    expect_error(
        forward(
            X_train,
            y_train,
            X_val = matrix(c('a', 'b', 'c', 'd', 'e', 'f'), nrow =
                               2),
            y_val,
            min_change = 0.5,
            criterion = 'r-squared',
            verbose = FALSE
        ),
        "X must be a 2D numeric matrix"
    )
})

test_that("y_val is a 1D numeric matrix", {
    # Test that `forward()` raises an error when
    # y_val is a 1D vector but is not numeric
    expect_error(
        forward(
            X_train,
            y_train,
            X_val,
            y_val = '1234',
            min_change = 0.5,
            criterion = 'r-squared',
            verbose = FALSE
        ),
        "y must be a 1D numeric vector"
    )
    # Test that `forward()` raises an error when
    # y_val is numeric but is not a 1D vector
    expect_error(
        forward(
            X_train,
            y_train,
            X_val,
            y_val = matrix(c(1, 2, 3, 4, 5, 6), nrow = 2),
            min_change = 0.5,
            criterion = 'r-squared',
            verbose = FALSE
        ),
        "y must be a 1D numeric vector"
    )
})

test_that("X_train and y_train have appropriate dimensions", {
    # Test that `forward()` raises an error when
    # X_val and y_val do not have the same number of rows
    expect_error(
        forward(
            X_train,
            y_train,
            X_val,
            y_val = 1234,
            min_change = 0.5,
            criterion = 'r-squared',
            verbose = FALSE
        ),
        "X and y must have the same number of observations"
    )
})

# -----------------------------------------------------------------------------
# Testing when `n_features`, `criterion`, `min_change` are invalid arguments
# -----------------------------------------------------------------------------

test_that("n_features must be a positive integer", {
    # Test that `forward()` will raise an error
    # if `n_features` arg is invalid
    expect_error(
        forward(
            X_train,
            y_train,
            X_val,
            y_val,
            n_features = "abc",
            criterion = 'r-squared',
            verbose = FALSE
        ),
        "`n_features` must be numeric"
    )
    expect_error(
        forward(
            X_train,
            y_train,
            X_val,
            y_val,
            min_change = NULL,
            n_features = -2,
            criterion = 'r-squared',
            verbose = FALSE
        ),
        "n_features` must be number and greater than zero."
    )
})

test_that("n_features and min_change cannot be active at the same time", {
    expect_error(
        forward(
            X_train,
            y_train,
            X_val,
            y_val,
            n_features = 0.5,
            min_change = 0.2,
            criterion = 'r-squared',
            verbose = FALSE
        ),
        "At least one of `n_features` and `min_change` must be NULL"
    )
})

test_that("error gets raise when `criterion` arg is invalid",
          {
              for (metric in c('bik', 'aiccc', NULL)){  # invalid
                  expect_error(forward(
                      X_train,
                      y_train,
                      X_val,
                      y_val,
                      n_features = 0.5,
                      min_change = NULL,
                      criterion = metric,
                      verbose = FALSE
                  ), "`criterion` must be on of: 'r-squared', 'aic', 'bic'")
              }
          })


test_that("error gets raised when `min_change` arg is invalid",
          {
              for (m in c('NULL', -10)){  # invalid, should throw.
                  expect_error(forward(
                      X_train,
                      y_train,
                      X_val,
                      y_val,
                      n_features = NULL,
                      min_change = m,
                      criterion = 'r-squared',
                      verbose = FALSE
                  ), "`min_change` must be numeric and greater than 0.")
              }
          })



# -----------------------------------------------------------------------------
# Output format and value
# -----------------------------------------------------------------------------

test_that("forward() selects the best features
          when data are passed in as dataframes",
          {
              X_train_df <- data.frame(X_train)
              X_train_df$y_train <- y_train
              X_val_df <- as.data.frame(X_val)
              X_val_df$y_val <- y_val

              output <-
                  forward(
                      X_train = X_train_df,
                      y_train = 'y_train',
                      X_val = X_val_df,
                      y_val = 'y_val',
                      n_features = 1,
                      min_change = NULL,
                      criterion = 'r-squared',
                      verbose = FALSE
                  )
              expect_length(output, 1)
          })


test_that("forward() selects the best features when
          data are passed in as matrices",
          {
              # Test that `forward()` will output a
              # vector with the 'best' features
              output <- forward(
                  X_train,
                  y_train,
                  X_val,
                  y_val,
                  n_features = 1,
                  criterion = 'r-squared',
                  verbose = FALSE
              )
              expect_length(output, 1)
          })


test_that("forward() selects the best features
          when data are passed in as matrices
          using `min_change`",
          {
              for (mc in c(0.001, 10)){
                  # Test that `backward()` will output a
                  # vector with the 'best' features
                  output <- forward(
                      X_train,
                      y_train,
                      X_val,
                      y_val,
                      n_features = NULL,
                      min_change = mc,
                      criterion = 'r-squared',
                      verbose = FALSE
                  )
                  expect_equal(length(output) > 0, TRUE)
              }
          })


test_that("forward() selects the best features
          when data are passed in as matrices
          using different metrics",
          {
            for (metric in c('aic', 'bic')){
                  # Test that `backward()` will output a
                  # vector with the 'best' features
                output <- forward(
                      X_train,
                      y_train,
                      X_val,
                      y_val,
                      n_features = 0.5,
                      min_change = NULL,
                      criterion = metric,
                      verbose = FALSE
                  )
                expect_equal(length(output) > 0, TRUE)
              }
          })


# -----------------------------------------------------------------------------
# Testing forward() with mtcars dataset
# -----------------------------------------------------------------------------

data <- mtcars_data()
X_train <- data[[1]]
y_train <- data[[2]]
X_val <- data[[3]]
y_val <- data[[4]]

test_that("forward() selects the best features when
          data are passed in as matrices and verbose
          is set to TRUE",
          {
              # Test that verbose=TRUE does not break
              # functionality
              verbose_false <- forward(
                  X_train,
                  y_train,
                  X_val,
                  y_val,
                  n_features = 0.5,
                  criterion = 'r-squared',
                  verbose = FALSE
              )
              verbose_true <- forward(
                  X_train,
                  y_train,
                  X_val,
                  y_val,
                  n_features = 0.5,
                  criterion = 'r-squared',
                  verbose = TRUE
              )
              expect_equal(length(verbose_true), length(verbose_false))
              expect_gte(length(verbose_true), 1)
          })

test_that("forward() selects the best features
          from mtcars dataset using `n_features`", {
    # Test that `n_features` will result in the
    # length of output being greater than or equal to 1
    output <- forward(
        X_train,
        y_train,
        X_val,
        y_val,
        n_features = 0.5,
        criterion = 'r-squared',
        verbose = FALSE
    )
    expect_gt(length(output), 1)
})

test_that("forward() selects the best features
          from mtcars dataset using `min_change`", {
    # Test that a small `min_change` will result in the
    # length of output being greater than or equal to 1
    output <- forward(
        X_train,
        y_train,
        X_val,
        y_val,
        min_change = 0.0001,
        criterion = 'r-squared',
        verbose = FALSE
    )
    expect_gt(length(output), 1)
})
