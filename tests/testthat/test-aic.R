context("aic.R")

test_that("check if output is a float", {
    output <- aic(model)
    expect_is(output, "numeric")
})

test_that("error message is thrown when input is not in correct format", {
    expect_error(aic(2), "Wrong format for model input")
    expect_error(aic(), "Need to pass in model and lambda as arguments")
})

test_that("check if aic value returned is correct", {
    expect_equal(aic(model_1), value_1)
    expect_equal(aic(model_2), value_2)
})
