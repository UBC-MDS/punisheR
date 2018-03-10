#' Backward Selection Algorithm.
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
#' bakcward(model, X_train, y_train, min_change=0.3, criterion='aic')
#' 
#' @export
backward <- function(model, X_train, y_train, X_val, y_val,
                     n_features=0.5, min_change, criterion,
                     verbose=TRUE){
    # Backward Selection Algorithm.
    #
    # Args:
    #     model : model
    #         Base R Model.
    #     X_train ndarray:
    #         a 2D matrix of (observations, features).
    #     y_train : ndarray
    #         a 1D array of target classes for X_train.
    #     X_val : ndarray
    #         a 2D matrix of (observations, features).
    #     y_val : ndarray
    #         a 1D array of target classes for X_validate.
    #     criterion : char
    #         model selection criterion.
    #         * 'aic': use Akaike Information Criterion.
    #         * 'bic': use Bayesian Information Criterion.
    #     n_features : int or float
    #         The number of features to select.
    #         Floats will be regarded as proportions of the total
    #         that must lie on (0, 1).
    #         `min_change` must be None for `n_features` to operate.
    #     min_change : int or float, optional
    #         The smallest change to be considered significant.
    #         `n_features` must be None for `min_change` to operate.
    #     verbose : bool
    #         if True, print additional information as selection occurs.
    #         Defaults to True.
    #
    # Returns:
    #     S : list
    #       The column indices of `X_train` (and `X_val`)
    #       that denote the chosen features.
    return(NULL)
}
