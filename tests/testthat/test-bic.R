context("bic.R")

test_that("output is float", {
    output <- bic()
    expect_is(output, "numeric")
})
