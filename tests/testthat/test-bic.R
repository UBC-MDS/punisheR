context("bic.R")

test_that("output is a float", {
    output <- bic(X_train, y_train)
    expect_is(output, "numeric")
})

test_that("error message occurs when input is not correct format", {
    expect_error(bic("string"), "wrong format for input")
    expect_error(bic(), "need to pass in X_train and y_train as arguments")
})

test_that("bic is correct", {
    expect_equal(bic(model_1, 1), value_1)
    expect_equal(bic(model_2, 1), value_2)
})

