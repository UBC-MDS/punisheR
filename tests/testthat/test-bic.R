context("bic.R")

test_that("output is a float", {
    output <- bic(model)
    expect_is(output, "numeric")
})

test_that("error message occurs when input is not correct format", {
    expect_error(bic(2), "Wrong format for model input")
    expect_error(bic(), "Need to pass in model as arguments")
})

test_that("bic is correct", {
    expect_equal(bic(model_1), value_1)
    expect_equal(bic(model_2), value_2)
})

