context("aic.R")

test_that("check if output is a float", {
    model <- lm(formula = dist~speed, data = cars)
    output <- aic(object = model)
    expect_is(output, "numeric")
})

test_that("error message is thrown when input is not in correct format", {
    expect_error(aic(2), "Unexpected type for argument model")
    expect_error(aic(), "No arguments passed into the function")
})

test_that("check if aic value returned is correct", {
    
    model_1 <- lm(formula = Petal.Length~Sepal.Length, data = iris)
    expected_value1 <- AIC(object = model_1)
    expect_equal(aic(model_1), expected_value1)

    model_2 <- lm(formula = dist~speed, data = cars)
    expected_value2 <- AIC(object = model_2)
    expect_equal(aic(model_2), expected_value2)
})
