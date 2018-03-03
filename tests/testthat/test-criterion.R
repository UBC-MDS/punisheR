context("criterion.R")

# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------

model <- lm(formula = Petal.Length~Sepal.Length, data = iris)

# -----------------------------------------------------------------------------
# `model` Param
# -----------------------------------------------------------------------------

test_that("test_metric_model_parm", {
    expect_error(aic(2), "`model` not a Base-R Model.")
    expect_error(aic("invalid input here"), "`model` not a Base-R Model.")
})

# Note: `aic` and `bic` are not expected to have `data` parameters
# (unlike in Python).

# -----------------------------------------------------------------------------
# Metric output
# -----------------------------------------------------------------------------


test_that("test_metric_output", {
    for (metric in c(aic, bic)){
        expect_is(metric(model), "numeric")
    }
})

# -----------------------------------------------------------------------------
# Output Value (Compare against Base-R).
# -----------------------------------------------------------------------------

test_that("test_metric_output_value", {
    expect_equal(aic(model), AIC(model))
    expect_equal(bic(model), BIC(model))
})
