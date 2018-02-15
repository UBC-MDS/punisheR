# Forward Selection

#' @export
forward <- function(model){
    # Perform forward selection on a R model.
    #
    #    Args:
    #       model: an R model
    #       X_train: a 2D matrix of (observations, features).
    #       y_train: a 1D matrix of target classes for X_train.
    #       X_val: a 2D matrix of (observations, features).
    #       y_val: a 1D matrix of target classes for X_validate.
    #       verbose: if TRUE, print additional information as selection occurs.
    #                Defaults to TRUE
    #       epsilon: smallest average change in the model's score to be considered meaningful
    #                over the past `epsilon_history` iterations of the algorithm.
    #       epsilon_history: number of past values to consider when comparing `epsilon`.
    #       max_features: the max. number of features to allow.
    #       criterion: model selection criterion.
    #           * 'aic': use Akaike Information Criterion.
    #           * 'bic': use Bayesian Information Criterion.
    #           * NULL: use a default.
    #
    # Returns:
    #   S (vector): column indices of `X_train` (and `X_val`) that denote the chosen features.
    #
    return(NULL)
}
