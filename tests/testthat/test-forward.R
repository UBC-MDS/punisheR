context("forward.R")

X_train <- data.frame(x1=rnorm(10), x2=rep(0,10), x3=rnorm(10), x4=rep(0, 10))
y_train <- rnorm(10)
X_val <- data.frame(x1=rnorm(10), x2=rep(0,10), x3=rnorm(10), x4=rep(0, 10))
y_val <- rnorm(10)

test_that("output is vector", {
    output <- forward(X_train, y_train, X_val, y_val)
    expect_is(output, "numeric")
    expect_true(is.vector(output))
})

test_that("error message occurs when input is not correct format", {
    expect_error(forward(1,2,3,4), "wrong format for input")
    expect_error(forward(), "need to pass in X_train, y_train, X_val, y_val")
})
