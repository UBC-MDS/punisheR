# Checks


input_checks <- function(n_features, min_change, criterion){
    # Check that:
    #   (a) the only one of the the two inputs are non-None
    #   (b) that the remaining element is numeric and is strictly greater than zero.
    #
    # Args:
    #     n_features : numeric
    #         The number of features to select.
    #         Floats will be regarded as proportions of the total
    #         that must lie on (0, 1).
    #         `min_change` must be None for `n_features` to operate.
    #     min_change : numeric
    #         The smallest change to be considered significant.
    #         `n_features` must be None for `min_change` to operate.
    #     criterion : char
    #         model selection criterion.
    #         * 'r-squared': use R-Squared as the criterion.
    #         * 'aic': use Akaike Information Criterion.
    #         * 'bic': use Bayesian Information Criterion.
    #
    criterion_stop_msg <- "`criterion` must be on of: 'r-squared', 'aic', 'bic'"
    if (is.null(criterion)){
        stop(criterion_stop_msg)
    } else if (!(criterion %in% c('r-squared', 'aic', 'bic'))){
        stop(criterion_stop_msg)
    }
    if(!is.numeric(n_features) & !is.null(n_features)) {
        stop("`n_features` must be numeric")
    }
    if (!is.null(n_features) & !is.null(min_change)){
        stop("At least one of `n_features` and `min_change` must be NULL")
    }
    if (is.null(n_features)){  # `min_change` must be 'on'.
        if (!is.numeric(min_change)){
            stop("`min_change` must be numeric.")
        } else if (min_change <= 0){
            stop("`min_change` must be greater than zero.")
        }
    }
    if (is.null(min_change)){  # `n_features` must be 'on'.
        if (!is.numeric(n_features)){
            stop("`n_features` must be numeric.")
        } else if (n_features <= 0){
            stop("`n_features` must be greater than zero.")
        }
    }
}

input_data_checks <- function(X, y) {

    X_string <- deparse(substitute(X))
    y_string <- deparse(substitute(y))
    stop_msg <- paste0(X_string, " must be a 2D matrix")
    if(!is.matrix(X)) {
        stop(stop_msg)
    } else if(!(is.vector(y) & is.numeric(y))) {
        stop_msg <- paste0(y_string, " must be a 1D vector")
        stop(stop_msg)
    } else if(length(y)!=dim(X)[1]) {
        shape_msg <- paste0(X_string, " and ", y_string, " must have the same number of observations")
        stop(shape_msg)
    }

}
