context("backward.R")

test_that("output is vector", {
    output <- backward(X_train, y_train, X_val, y_val)
    expect_is(output, "numeric")
    expect_true(is.vector(output))
})

test_that("error message occurs when input is not correct format", {
    expect_error(backward(1,2,3,4), "wrong format for input")
    expect_error(backward(), "need to pass in training and test data")
})
