context("criterion.R")

# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------

model <- lm(formula = Petal.Length ~ Sepal.Length, data = iris)

# -----------------------------------------------------------------------------
# `model` Param
# -----------------------------------------------------------------------------

test_that("test_metric_model_parm", {
    # Test that the `model` params in `aic()` and `bic()`
    # will raise an error when passed something other
    # than a Base R model.
    expect_error(aic(2), "`model` not a Base-R Model.")
    expect_error(aic("invalid input here"), "`model` not a Base-R Model.")
})

# Note: `aic` and `bic` are not expected to have `data` parameters
# (unlike in Python).

# -----------------------------------------------------------------------------
# Metric output
# -----------------------------------------------------------------------------


test_that("test_metric_output", {
    # Test that both metrics (`aic()` and `bic()`)
    # return numerics
    for (metric in c(aic, bic)) {
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

# -----------------------------------------------------------------------------
# Output Value
# -----------------------------------------------------------------------------

# Note: we have replicated code here, which is not D.R.Y.
# However, we have done so to show, in detail, the manual
# calculations of AIC and BIC occuring explictly.

test_that("test aic() against manual calculation.", {
    # Test *very* simple case of `y = x`:
    N <- 100
    values <- 1:N
    data <- data.frame(x = values, y = values)
    rank <- 2
    model <- lm(formula = y ~ x, data = data)

    # Manual Calculation ----------------------------------------------
    n <- N
    k <- rank + 1
    # Compute RSS ----------------
    extract_residuals <- residuals(model)
    rss <- sum(extract_residuals ^ 2)
    llf <- -1 * (n / 2) * log(2 * pi) - (n / 2) * log(rss / n) - n / 2
    manually_calculated_aic <- -2 * llf + 2 * k

    # `aic()` Calculation --------------------------------------
    function_aic_value <- aic(model)
    expect_equal(function_aic_value, manually_calculated_aic)
})


test_that("test bic() against manual calculation.", {
    # Test *very* simple case of `y = x`:
    N <- 100
    values <- 1:N
    data <- data.frame(x = values, y = values)
    rank <- 2
    model <- lm(formula = y ~ x, data = data)

    # Manual Calculation -------------------------------
    n <- N
    k <- rank + 1
    # Compute RSS ---------
    extract_residuals <- residuals(model)
    rss <- sum(extract_residuals ^ 2)
    llf <- -1 * (n / 2) * log(2 * pi) - (n / 2) * log(rss / n) - n / 2
    manually_calculated_bic <- -2 * llf + log(n) * k

    # `bic()` Calculation ------------------------------------
    function_bic_value <- bic(model)
    expect_equal(function_bic_value, manually_calculated_bic)
})
