#' R-squared
#' @description Calculates the coefficient of determination.
#'
#' @param fit_model A fitted model
#'
#' @param X Feature data
#'
#' @param y True labels of the response variable
#'
#' @references http://scikit-learn.org/stable/modules/model_evaluation.html#r2-score-the-coefficient-of-determination
#' @export
r_squared <- function(fit_model, X, y){
    df <- as.data.frame(X)
    y_pred <- suppressWarnings(predict(fit_model, df))
    y_true_mean <- mean(y)
    num <- sum( (y - y_pred) ^ 2)
    denom <- sum( (y - y_true_mean) ^ 2)
    return(1 - (num / denom))
}

#' Get coefficients
#' @description A helper function that gets the coefficients required for
#' AIC and BIC calculations.
#'
#' @param model base R model object
#'
#' @return A vector of \code{n} (number of samples), \code{k} (number of features),
#' \code{llf} (maximized value of log-likelihood function)
#'
#' @keywords internal
.get_coeffs <- function(model){
    n <- length(model$residuals)
    k <- model$rank + 1
    rss <- sum(model$residuals ^ 2)
    llf <- -1 * (n / 2) * log(2 * pi) - (n / 2) * log(rss / n) - n / 2
    return(c(n, k, llf))
}




#' Akaike Information Criterion (AIC)
#' @description The Akaike Information Criterion's objective is to prevent model
#'  overfitting by adding a penalty term which penalizes more compelx models.
#'  Its formal definition is:
#'  \deqn{-2*ln(L)+2*k}
#'  where L is the maximized value of the likelihood function.
#'  A smaller AIC value suggests that the model is a better fit for the data.
#'
#' @param model A base R model object (e.g., \code{lm()})
#'
#' @return  AIC value gets returned as a float.
#'
#' @references https://en.wikipedia.org/wiki/Akaike_information_criterion
#' @export
aic <- function(model){

    if (!is.object(model)) {
        stop("`model` not a Base-R Model.")
    }
    # Calculate AIC
    coeff <- .get_coeffs(model)
    k <- coeff[2]
    llf <- coeff[3]
    aic <- -2 * llf + 2 * k

    return(aic)
}


#' Bayesian Information Criterion
#'
#' @description The Bayesian Information Criterion's objective is to prevent model
#'  overfitting by adding a penalty term which penalizes more compelx models.
#'  Its formal definition is:
#'  \deqn{ -2*ln(L)+ln(n)*k}
#'  where L is the maximized value of the likelihood function.
#'  A smaller BIC value suggests that the model is a better fit for the data.
#'
#' @param  model A base R model object (e.g., \code{lm()})
#'
#' @return BIC value gets returned as a flaot.
#'
#' @references https://en.wikipedia.org/wiki/Bayesian_information_criterion
#' @export
bic <- function(model){
    if (!is.object(model)) {
        stop("`model` not a Base-R Model.")
    }
    # Calcualte BIC
    coeff <- .get_coeffs(model)
    n <- coeff[1]
    k <- coeff[2]
    llf <- coeff[3]
    bic <- -2 * llf + log(n) * k

    return(bic)
}
