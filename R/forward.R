# Forward Selection

#' @export
forward <- function(model, X_train, y_train, X_val, y_val,
                    min_change=0.5, max_features, criterion,
                    verbose=TRUE){
    # Forward Selection Algorithm.
    #
    # Args:
    #     model : model
    #         Base R Model.
    #     X_train matrix
    #         a 2D matrix of (observations, features).
    #     y_train : matrix
    #         a 1D array of target classes for X_train.
    #     X_val : matrix
    #         a 2D matrix of (observations, features).
    #     y_val : matrix
    #         a 1D array of target classes for X_validate.
    #     criterion : char
    #         model selection criterion.
    #         * 'aic': use Akaike Information Criterion.
    #         * 'bic': use Bayesian Information Criterion.
    #     min_change : int or float, optional
    #         The smallest change to be considered significant.
    #         `n_features` must be None for `min_change` to operate.
    #     max_features : int
    #         the max. number of features to allow.
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
