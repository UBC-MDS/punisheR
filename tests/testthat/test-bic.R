context("bic.R")

test_that("output is a float", {
    output <- bic(model, 1)
    expect_is(output, "numeric")
})

test_that("error message occurs when input is not correct format", {
    expect_error(bic(2,1), "wrong format for model input")
    expect_error(bic(model,"lambda"), "wrong format for lambda input")
    expect_error(bic(), "need to pass in model and lambda as arguments")
})

test_that("bic is correct", {
    expect_equal(bic(model_1, 1), value_1)
    expect_equal(bic(model_2, 1), value_2)
})

