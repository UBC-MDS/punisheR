context("bic.R")

test_that("output is a float", {
    model <- lm(formula = dist~speed, data = cars)
    output <- bic(object = model)
    expect_is(output, "numeric")
})

test_that("error message occurs when input is not correct format", {
    expect_error(bic(2), "Unexpected type for argument model")
    expect_error(bic(), "No arguments passed into the function")
})

test_that("check if the bic value returned is correct", {

    model_1 <- lm(formula = Petal.Length~Sepal.Length, data = iris)
    expected_value1 <- BIC(object = model_1)
    expect_equal(bic(model_1), expected_value1)

    model_2 <- lm(formula = dist~speed, data = cars)
    expected_value2 <- BIC(object = model_2)
    expect_equal(bic(model_2), expected_value2)

})

