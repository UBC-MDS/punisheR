context("bic.R")

test_that("output is a float", {
    output <- bic(X_train, y_train)
    expect_is(output, "numeric")
})

test_that("error message occurs when input is not correct format", {
    expect_error(bic("string"), "wrong format for input")
    expect_error(bic(), "need to pass in X_train and y_train as arguments")
})



