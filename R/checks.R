#' Input Checks
#'
#' @description checks that:
#' (a) the only one of the the two inputs, `n_features` and `min_change`, are non-None
#' (b) the remaining element is numeric and is strictly greater than zero
#'
#' @param n_features the number of features to select. Floats will be regarded as proportions
#' of the total that must lie on (0,1). `min_change` must be None for `n_features` to
#' operate.
#'
#' @param min_change The smallest change to be considered significant.
#' `n_features` must be None for `min_change` to operate.
#'
#' @param criterion model selection criterion:
#' * 'r-squared': use R-squared as the criterion
#' * 'aic': use Akaike Information Criterion
#' * 'bic': use Bayesian Information Criterion
#' @keywords internal
.input_checks <- function(n_features, min_change, criterion){
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

#' Input Data Checks
#'
#' @description checks that input data for `forward()` and `backward()`
#' functions are the correct format. Specifically looks for:
#' - X and y are appropriate dimensions (both same number of observations)
#' - X is a 2D numeric vector and y is a 1D numeric vector
#'
#' @param X input for either X_train or X_val (expected to be a 2D numeric matrix)
#'
#' @param y input for either y_train or y_val (expected to be a 1D numeric matrix)
#'
#' @keywords internal
.input_data_checks <- function(X, y) {

    stop_msg <- "X must be a 2D matrix"
    if(!is.matrix(X)) {
        stop(stop_msg)
    } else if(!(is.vector(y) & is.numeric(y))) {
        stop_msg <- "y must be a 1D vector"
        stop(stop_msg)
    } else if(length(y)!=dim(X)[1]) {
        shape_msg <- "X and y must have the same number of observations"
        stop(shape_msg)
    }

}
