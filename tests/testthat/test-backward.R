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
    # Test that `backward()` raises an error when
    # X_train is numeric but is not a 2D matrix
    expect_error(
        backward(
            X_train = 1234,
            y_train,
            X_val,
            y_val,
            criterion = 'r-squared',
            verbose = FALSE
        ),
        "X must be a 2D numeric matrix"
    )
    # Test that `backward()` raises an error when
    # X_train is a 2D matrix but is not numeric
    expect_error(
        backward(
            X_train = matrix(c('a', 'b', 'c', 'd', 'e', 'f'), nrow = 2),
            y_train,
            X_val,
            y_val,
            criterion = 'r-squared',
            verbose = FALSE
        ),
        "X must be a 2D numeric matrix"
    )
})


test_that("y_train is a 1D numeric vector", {
    # Test that `backward()` will raise an error when
    # y_train is a 1D vector but is not numeric
    expect_error(
        backward(
            X_train,
            y_train = '1234',
            X_val,
            y_val,
            n_features = 0.5,
            criterion = 'r-squared',
            verbose = FALSE
        ),
        "y must be a 1D numeric vector"
    )
    # Test that `backward()` raises an error when
    # y_train is numeric but is not a 1D vector
    expect_error(
        backward(
            X_train,
            y_train = matrix(c(1, 2, 3, 4, 5, 6), nrow = 2),
            X_val,
            y_val,
            n_features = 0.5,
            criterion = 'r-squared',
            verbose = FALSE
        ),
        "y must be a 1D numeric vector"
    )
})

test_that("X_train and y_train have appropriate dimensions", {
    # Test that `backward()` raises an error when
    # X_train and y_train do not have the same number of observations
    expect_error(
        backward(
            X_train,
            y_train = 1234,
            X_val,
            y_val,
            n_features = 0.5,
            criterion = 'r-squared',
            verbose = FALSE
        ),
        "X and y must have the same number of observations"
    )
})

test_that("X_val is a 2D numeric matrix", {
    # Test that `backward()` raises an error when
    # X_val is numeric but is not a 2D matrix
    expect_error(
        backward(
            X_train,
            y_train,
            X_val = 1234,
            y_val,
            n_features = 0.5,
            criterion = 'r-squared',
            verbose = FALSE
        ),
        "X must be a 2D numeric matrix"
    )
    # Test that `backward()` raises an error when
    # X_val is a 2D matrix but is not numeric
    expect_error(
        backward(
            X_train,
            y_train,
            X_val = matrix(c('a', 'b', 'c', 'd', 'e', 'f'), nrow = 2),
            y_val,
            n_features = 0.5,
            criterion = 'r-squared',
            verbose = FALSE
        ),
        "X must be a 2D numeric matrix"
    )
})

test_that("y_val is a 1D numeric matrix", {
    # Test that `backward()` raises an error when
    # y_val is numeric but is not a 1D vector
    expect_error(
        backward(
            X_train,
            y_train,
            X_val,
            y_val = matrix(c(2, 4, 3, 1, 5, 7), nrow = 2),
            n_features = 0.5,
            criterion = 'r-squared',
            verbose = FALSE
        ),
        "y must be a 1D numeric vector"
    )
    # Test that `backward()` raises an error when
    # y_val is a 1D vector but is not numeric
    expect_error(
        backward(
            X_train,
            y_train,
            X_val,
            y_val = 'xyz',
            n_features = 0.5,
            criterion = 'r-squared',
            verbose = FALSE
        ),
        "y must be a 1D numeric vector"
    )
})

test_that("X_train and y_train have appropriate dimensions", {
    # Test that `backward()` raises an error when
    # X_val and y_val do not have the same number of observations
    expect_error(
        backward(
            X_train,
            y_train,
            X_val,
            y_val = 1234,
            n_features = 0.5,
            criterion = 'r-squared',
            verbose = FALSE
        ),
        "X and y must have the same number of observations"
    )
})



test_that("n_features must be a positive integer
          less than the total number of feature.", {
    # Test that `backward()` will raise error when
    # `n_features` is an invalid arg
    expect_error(
        backward(
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
        backward(
            X_train,
            y_train,
            X_val,
            y_val,
            n_features = -2,
            criterion = 'r-squared',
            verbose = FALSE
        ),
        "`n_features` must be number and greater than zero."
    )
    expect_error(
        backward(
            X_train,
            y_train,
            X_val,
            y_val,
            n_features = 25,  # FYI, X_train/_val has 20 features.
            criterion = 'r-squared',
            verbose = FALSE
        ),
        "If a whole number, `n_features` must be on.*"
    )
})


test_that("n_features and min_change cannot be active at the same time", {
    # Test that `backward()` will raise an error when
    # `n_features` and `min_change` are both passed in as args
    expect_error(
        backward(
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


test_that("criterion param must be either aic, bic, or r-squared", {
    # Test that the `criterion` param will raise an error
    # when passed something other than 'aic', 'bic', or 'r-squared'
    for (c in c('abc', NULL)){
        expect_error(
            backward(
                X_train,
                y_train,
                X_val,
                y_val,
                n_features = 0.5,
                criterion = "abc",
                verbose = FALSE
            ),
            "`criterion` must be on of: 'r-squared', 'aic', 'bic'"
        )
    }
})


# -----------------------------------------------------------------------------
# Output format and value
# -----------------------------------------------------------------------------


test_that("backward() selects the best features
          when data are passed in as dataframes",
          {
              X_train_df <- data.frame(X_train)
              X_train_df$y_train <- y_train
              X_val_df <- as.data.frame(X_val)
              X_val_df$y_val <- y_val

              output <-
                  backward(
                      X_train = X_train_df,
                      y_train = 'y_train',
                      X_val = X_val_df,
                      y_val = 'y_val',
                      n_features = 1,
                      criterion = 'r-squared',
                      verbose = FALSE
                  )
              expect_length(output, 1)
          })


test_that("backward() selects the best features
          when data are passed in as matrices",
          {
              output <- backward(
                  X_train,
                  y_train,
                  X_val,
                  y_val,
                  n_features = 1,
                  criterion = 'r-squared',
                  verbose = FALSE
              )
              expect_equal(output, c(10))
              expect_length(output, 1)
          })


test_that("backward() selects the best features
          when data are passed in as matrices
          using different criterion",
          {
              # Test that function works when we use
              # aic and bic as criterion
              for (metric in c('aic', 'bic')){
                  output <- forward(
                      X_train,
                      y_train,
                      X_val,
                      y_val,
                      n_features = 1,
                      min_change = NULL,
                      criterion = metric,
                      verbose = FALSE
                  )
                  # Test that length of output is equal
                  # to 1 (since the dataset has 1 sig feature)
                  expect_equal(length(output), 1)
              }
          })


test_that("backward() test behavior with only one feature",
          {
              # Test that `backward()` will output a
              # vector with the 'best' features
              output <- backward(
                  as.matrix(X_train[, 1]),
                  y_train,
                  as.matrix(X_val[, 1]),
                  y_val,
                  n_features = 1,
                  min_change = NULL,
                  criterion = 'r-squared',
                  verbose = FALSE
              )
              expect_length(output, 1)
          })

# -----------------------------------------------------------------------------
# Verbose
# -----------------------------------------------------------------------------


test_that("backward() selects the best features when
            data are passed in as matrices and `verbose`
            is set to TRUE.",
          {
              # Test that verbose=TRUE does not break
              # functionality
              verbose_true <- backward(
                  X_train,
                  y_train,
                  X_val,
                  y_val,
                  n_features = 1,
                  criterion = 'r-squared',
                  verbose = TRUE
              )
              verbose_false <- backward(
                  X_train,
                  y_train,
                  X_val,
                  y_val,
                  n_features = 1,
                  criterion = 'r-squared',
                  verbose = FALSE
              )
              expect_equal(length(verbose_true), length(verbose_false))
              expect_gte(length(verbose_true), 1)
          })

# -----------------------------------------------------------------------------
# Testing backward() with mtcars dataset
# -----------------------------------------------------------------------------

data <- mtcars_data()
X_train <- data[[1]]
y_train <- data[[2]]
X_val <- data[[3]]
y_val <- data[[4]]

test_that("backward() selects the best features
          from mtcars dataset using `n_features`", {
    # Testing `n_features`
    n_features <- 1
    output <- backward(
        X_train,
        y_train,
        X_val,
        y_val,
        n_features = n_features,
        criterion = 'r-squared',
        verbose = FALSE
    )
    expect_length(output, 1)
})


test_that("backward() selects at least
          some features with `min_change` (small)", {
    # Testing `min_change`
    output <- backward(
        X_train,
        y_train,
        X_val,
        y_val,
        n_features = NULL,
        min_change = 0.0000001,
        criterion = 'r-squared',
        verbose = FALSE
    )
    # Test for output greater than or equal to 1 (i.e., some features)
    expect_gte(length(output), 1)
})


test_that("backward() selects more best features when
            `min_change` is large (vs small)", {
              # Output with small min change
              small_min_change <- backward(
                  X_train,
                  y_train,
                  X_val,
                  y_val,
                  n_features = NULL,
                  min_change = 0.0000001,
                  criterion = 'r-squared',
                  verbose = FALSE
              )
             # Output with large min change
              large_min_change <- backward(
                  X_train,
                  y_train,
                  X_val,
                  y_val,
                  n_features = NULL,
                  min_change = 0.1,
                  criterion = 'r-squared',
                  verbose = FALSE
              )
              # Test that large_min_change output is greater than
              # or equal to small_min_change output
              expect_gte(length(large_min_change), length(small_min_change))
          })

