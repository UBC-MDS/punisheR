#' R-squared
#' @description Coefficient of Determination 
#' 
#' @param fit_model A fitted model
#' 
#' @param X Feature data
#' 
#' @param y True labels (response)
#'
#' @references http://scikit-learn.org/stable/modules/model_evaluation.html#r2-score-the-coefficient-of-determination
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
#' 
#' @description The Akaike Information Criterion's objective is to prevent model
#'  overfitting by adding a penalty term which penalizes more compelx models. 
#'  Its formal definition is:
#'  \deqn{-2*ln(L)+2*k}
#'  where L is the maximized value of the likelihood function. 
#'  A smaller AIC value suggests that the model is a better fit for the data.
#'  
#' @param model R model object
#' 
#' @return  AIC value gets returned as float if sample size is sufficient. 
#' If n/k < 40 where n is the number of observations and k is the number of features, 
#' AICc gets returned to adjust for small sample size.
#' 
#' @references
#' https://en.wikipedia.org/wiki/Akaike_information_criterion
#' @export
aic <- function(model){

    return(NULL)
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
#' @param  model Base R model  
#'
#' @return BIC value gets returned as a flaot.
#' 
#' @references https://en.wikipedia.org/wiki/Bayesian_information_criterion
#' @export
bic <- function(model){
    return(NULL)
}
