context("backward.R")

test_that("output is vector", {
    output <- forward()
    expect_is(output, "numeric")
    expect_true(is.vector(output))
})
