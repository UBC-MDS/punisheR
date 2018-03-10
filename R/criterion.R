#' R-squared
#' @description Computes R-squared value for a fitted model. 
#' @param fit_model A fitted model
#' @param X Feature data
#' @param y True labels (response)
#'
#' @references    http://scikit-learn.org/stable/modules/model_evaluation.html#r2-score-the-coefficient-of-determination
#' @export
r_squared <- function(fit_model, X, y){
    df <- as.data.frame(X)
    y_pred <- predict(fit_model, df)
    y_true_mean <- mean(y)
    num <- sum((y - y_pred)^2)
    denom <- sum((y - y_true_mean)^2)
    return(1 - (num / denom))
}

#' Akaike Information Criterion (AIC)
#' @param model R model object
#' @return aic value 
#' @references
#' https://en.wikipedia.org/wiki/Akaike_information_criterion
#' @export
aic <- function(model){

    return(NULL)
}


#' Bayesian Information Criterion
#' 
#' @description
#' This is an implementation of the backward selection algorithm
#' that can be used to select best features in model. 
#' 
#' @param  model Base R model  
#'
#' @param X_train Training data
#' 
#'  A 2D matrix of (observations, features)
#'  
#' @param y_train Target class for training data
#' 
#' @return bic value (float)
#' 
#' @references https://en.wikipedia.org/wiki/Bayesian_information_criterion
#' @export
bic <- function(model){
    return(NULL)
}
