context("forward.R")

X_train <- data.frame(x1=rnorm(10), x2=rep(0,10), x3=rnorm(10), x4=rep(0, 10))
y_train <- rnorm(10)
X_val <- data.frame(x1=rnorm(10), x2=rep(0,10), x3=rnorm(10), x4=rep(0, 10))
y_val <- rnorm(10)

test_that("output is a vector", {
    output <- forward(X_train, y_train, X_val, y_val)
    expect_is(output, "list")
    expect_true(is.list(output))
})

test_that("error message occurs when input is not correct format", {
    expect_error(forward(1234, X_train, y_train, X_val, y_val,
                    min_change=0.5, max_features=2, criterion='aic',
                    verbose=TRUE), "`model` not a Base-R Model.")
    expect_error(forward(model, 1234, y_train, X_val, y_val,
                    min_change=0.5, max_features=2, criterion='aic',
                    verbose=TRUE), "`X_train` matrix is not a 2D matrix.")
    expect_error(forward(model, X_train, 1234, X_val, y_val,
                    min_change=0.5, max_features=2, criterion='aic',
                    verbose=TRUE), "`y_train` is not a 1D vector.")
    expect_error(forward(model, X_train, y_train, 1234, y_val,
                    min_change=0.5, max_features=2, criterion='aic',
                    verbose=TRUE), "`X_val` is not a 2D matrix.")
    expect_error(forward(model, X_train, y_train, X_val, 1234,
                    min_change=0.5, max_features=2, criterion='aic',
                    verbose=TRUE), "`y_val` is not a 1D vector.")
    expect_error(forward(model, X_train, y_train, X_val, y_val,
                    min_change=0.5, "abc", criterion='aic',
                    verbose=TRUE), "`max_features` is not of type `int`")
    expect_error(forward(model, X_train, y_train, X_val, y_val,
                    min_change=0.5, max_features=-2, criterion='aic',
                    verbose=TRUE), "`max_features` should be a positive `int`")
    expect_error(forward(model, X_train, y_train, X_val, y_val,
                    min_change=0.5, max_features=2, "abc",
                    verbose=TRUE), "unexpected `criterion`")
    expect_error(forward(), "No defaults specified for model, `X_train`, `y_train`, `X_val`, `y_val`, `max_features`")
})

test_that("forward() selects the best features", {
    output <- forward(model, X_train, y_train, X_val, y_val,
                     n_features=0.5, min_change, criterion='aic',
                     verbose=TRUE)
    expect_output(output, list(1,4))
    expect_length(output, 2)
})



