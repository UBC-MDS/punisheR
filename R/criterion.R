# Criterion

r_squared <- function(fit_model, X, y){
    # Compute the R-squared value for a fitted model.
    #
    # Args:
    #   X : matrix
    #       Feature Matrix
    #   y : vector
    #       True labels (reponse)
    #
    # References:
    #   * http://scikit-learn.org/stable/modules/model_evaluation.html#
    #                         r2-score-the-coefficient-of-determination
    #
    df <- as.data.frame(X)
    y_pred <- predict(fit_model, df)
    y_true_mean <- mean(y)
    num <- sum((y - y_pred)^2)
    denom <- sum((y - y_true_mean)^2)
    return(1 - (num / denom))
}


#' @export
aic <- function(model){
    # Compute the Akaike Information Criterion (AIC)
    #
    # Args:
    #   model (R model object): ...
    #
    # Returns:
    #   numeric: ...
    #
    # References:
    #   * https://en.wikipedia.org/wiki/Akaike_information_criterion
    #
    return(NULL)
}


#' @export
bic <- function(model){
    # Compute the Bayesian Information Criterion (AIC)
    #
    # Args:
    #   model (R model object): ...
    #
    # Returns:
    #   numeric: ...
    #
    # References:
    #   * https://en.wikipedia.org/wiki/Bayesian_information_criterion
    #
    return(NULL)
}
