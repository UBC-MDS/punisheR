context("aic.R")

test_that("output is float", {
    output <- aic()
    expect_is(output, "numeric")
})
