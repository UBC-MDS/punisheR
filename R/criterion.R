#' RSS Calculator
#' @description Compute the Residual Sum of Squares (RSS)
#'
#' @param fit_model A fitted model
#'
#' @param X Validation data as a 2D matrix of (observations, features)
#'
#' @param y True labels as a 1D vector
#'
#' @keywords internal
.rss_calc <- function(model, X, y) {
    df <- as.data.frame(X)
    y_pred <- suppressWarnings(stats::predict(model, df))
    rss <- sum((y - y_pred) ^ 2)
    return(rss)
}


#' R-squared
#' @description Calculates the coefficient of determination.
#'
#' @param fit_model A fitted model
#'
#' @param X Validation data as a 2D matrix of (observations, features)
#'
#' @param y True labels as a 1D vector
#'
#' @references http://scikit-learn.org/stable/modules/model_evaluation.html#r2-score-the-coefficient-of-determination
#' @export
r_squared <- function(fit_model, X, y) {
    y_true_mean <- mean(y)
    num <- .rss_calc(fit_model, X = X, y = y)
    denom <- sum((y - y_true_mean) ^ 2)
    return(1 - (num / denom))
}


#' Get coefficients
#' @description A helper function that gets the coefficients required for
#' AIC and BIC calculations.
#'
#' @param model Base R model object
#'
#' @return A vector of \code{n} (number of samples), \code{k} (number of features),
#' \code{llf} (maximized value of log-likelihood function)
#'
#' @keywords internal
.get_coeffs <- function(model, X, y) {
    if (!is.object(model)) {
        stop("`model` not a Base-R Model.")
    }

    n <- length(model$residuals)
    k <- model$rank + 1
    if (is.null(X) & is.null(y)) {
        rss <- sum(model$residuals ^ 2)
    } else {
        rss <- .rss_calc(model, X = X, y = y)
    }
    llf <-
        -1 * (n / 2) * log(2 * pi) - (n / 2) * log(rss / n) - n / 2
    return(c(n, k, llf))
}


#' Akaike Information Criterion (AIC)
#' @description The Akaike Information Criterion's objective is to prevent model
#'  overfitting by adding a penalty term which penalizes more complex models.
#'  Its formal definition is:
#'  \deqn{-2*ln(L)+2*k}
#'  where L is the maximized value of the likelihood function.
#'  A smaller AIC value suggests that the model is a better fit for the data.
#'
#' @param model A base R model object (e.g., \code{lm()})
#'
#' @param X Validation data as a 2D matrix of (observations, features).
#' If \code{NULL}, extract \code{X} from \code{model}.
#'
#' @param y True labels as a 1D vector.
#'          If \code{NULL}, extract \code{y} from \code{model}.
#'
#' @return  AIC value gets returned as a float.
#'
#' @examples
#' model <- lm(hp~., data=mtcars)
#' aic(model)
#'
#' @references https://en.wikipedia.org/wiki/Akaike_information_criterion
#' @export
aic <- function(model, X = NULL, y = NULL) {
    # Calculate AIC
    coeff <- .get_coeffs(model, X = X, y = y)
    k <- coeff[2]
    llf <- coeff[3]
    aic <- -2 * llf + 2 * k
    return(aic)
}


#' Bayesian Information Criterion
#'
#' @description The Bayesian Information Criterion's objective is to prevent model
#'  overfitting by adding a penalty term which penalizes more complex models.
#'  Its formal definition is:
#'  \deqn{ -2*ln(L)+ln(n)*k}
#'  where L is the maximized value of the likelihood function.
#'  A smaller BIC value suggests that the model is a better fit for the data.
#'
#' @param  model A base R model object (e.g., \code{lm()})
#'
#' @param X Validation data as a 2D matrix of (observations, features).
#' If \code{NULL}, extract \code{X} from \code{model}.
#'
#' @param y True labels as a 1D vector.
#'          If \code{NULL}, extract \code{y} from \code{model}.
#'
#' @return BIC value gets returned as a float.
#'
#' @examples
#' model <- lm(Sepal.Length~., data=iris)
#' bic(model)
#'
#' @references https://en.wikipedia.org/wiki/Bayesian_information_criterion
#' @export
bic <- function(model, X = NULL, y = NULL) {
    # Calcualte BIC
    coeff <- .get_coeffs(model, X = X, y = y)
    n <- coeff[1]
    k <- coeff[2]
    llf <- coeff[3]
    bic <- -2 * llf + log(n) * k
    return(bic)
}
