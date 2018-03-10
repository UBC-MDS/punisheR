#' Forward Selection Algorithm.
#' 
#' @description
#' This is an implementation of the forward selection algorithm
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
#'  A 1D array of target classes for X_train 
#'  
#' @param X_val Validation data
#'
#'  A 2D matrix of (observations, features)
#'  
#' @param y_val Target class for validation data
#' 
#'  A 1D array of target classes for X_val
#' 
#' @param criterion Model selection criterion
#'  A criterion to measure relative model quality. 
#'  'aic': use Akaike Information Criterion
#'  'bic': use Bayesian Information Criterion
#' @param min_change Smallest change in criterion score to be considered significant.
#'   
#' @param max_features Maximum number of features to allow.
#' 
#' @param verbose 
#'  if True, print additional information as selection occurs  
#' @return A vector
#' @export
#' @examples 
#' model = lm(Sepal.Length~Sepal.Width+Petal.Length+Petal.Width, data=iris)
#' forward(model, X_train, y_train, min_change=0.3, criterion='aic')
#' 
#' @export
 

forward <- function(model, X_train, y_train, X_val, y_val,
                    min_change=0.5, max_features, criterion,
                    verbose=TRUE){
    return(NULL)
}
