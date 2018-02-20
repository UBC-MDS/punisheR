context("aic.R")

test_that("output is a float", {
    output <- aic(X_train, y_train)
    expect_is(output, "numeric")
})

test_that("error message occurs when input is not correct format", {
    expect_error(aic("string"), "wrong format for input")
    expect_error(aic(), "need to pass in X_train and y_train as arguments")
})
