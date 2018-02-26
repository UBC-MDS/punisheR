context("aic.R")

test_that("output is a float", {
    output <- aic(model, 1)
    expect_is(output, "numeric")
})

test_that("error message occurs when input is not correct format", {
    expect_error(aic(2,1), "Wrong format for model input")
    expect_error(aic(model,"lambda"), "Wrong format for lambda input")
    expect_error(aic(), "Need to pass in model and lambda as arguments")
})

test_that("aic is correct", {
    expect_equal(aic(model_1, 1), value_1)
    expect_equal(aic(model_2, 1), value_2)
})

test_that("lambda value is an optional argument", {
    expect_equal(aic(model), value)
})