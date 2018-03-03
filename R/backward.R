# Backward Selection

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
