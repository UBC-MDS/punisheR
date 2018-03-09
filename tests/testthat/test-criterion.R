context("criterion.R")

# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------

model <- lm(formula = Petal.Length~Sepal.Length, data = iris)

# -----------------------------------------------------------------------------
# `model` Param
# -----------------------------------------------------------------------------

test_that("test_metric_model_parm", {
    # Test that the `model` params in `aic()` and `bic()`
    # will raise a TypeError when passed something other
    # than a Base R model.
    for (metric in c(aic, bic)){
    expect_error(metric(2), "`model` not a Base-R Model.")
    expect_error(metric("invalid input here"), "`model` not a Base-R Model.")
    }
})

# Note: `aic` and `bic` are not expected to have `data` parameters
# (unlike in Python).

# -----------------------------------------------------------------------------
# Metric output
# -----------------------------------------------------------------------------


test_that("test_metric_output", {
    # Test that both metrics (`aic()` and `bic()`)
    # return numerics
    for (metric in c(aic, bic)){
        expect_is(metric(model), "numeric")
    }
})

# -----------------------------------------------------------------------------
# Output Value (Compare against Base-R).
# -----------------------------------------------------------------------------

test_that("test_metric_output_value", {
    # Test that the actual AIC and BIC values computed by
    # our functions match that computed by Base R.
    expect_equal(aic(model), AIC(model))
    expect_equal(bic(model), BIC(model))
})
