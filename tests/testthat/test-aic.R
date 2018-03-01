context("aic.R")

test_that("check if output is a float", {
    model <- lm(dist~speed, data = cars)
    output <- aic(model)
    expect_is(output, "numeric")
})

test_that("error message is thrown when input is not in correct format", {
    expect_error(aic(2), "Unexpected type for argument model")
    expect_error(aic(), "No arguments passed into the function")
})

test_that("check if aic value returned is correct", {
    expect_equal(aic(model_1), value_1)
    expect_equal(aic(model_2), value_2)
})
