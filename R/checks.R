#' Check parameter input
#'
#' @description Checks that:
#' \itemize{
#'   \item only one of the the two inputs, \code{n_features} and \code{min_change}, are non-None
#'   \item the remaining element is numeric and is strictly greater than zero
#' }
#'
#' @param n_features the number of features to select. Floats will be regarded as proportions
#' of the total that must lie on (0,1). min_change must be None for `n_features` to
#' operate.
#'
#' @param min_change The smallest change to be considered significant.
#' \code{n_features} must be None for \code{min_change} to operate.
#'
#' @param criterion A string representing the model selection criterion to be used.
#' Can be one of 'r-squared', aic', 'bic'
#'
#' @keywords internal
input_checks <- function(n_features, min_change, criterion) {
    criterion_stop_msg <-
        "`criterion` must be on of: 'r-squared', 'aic', 'bic'"
    criterion_test_a <- is.null(criterion)
    criterion_test_b <- !(criterion %in% c("r-squared", "aic", "bic"))
    if (any(c(criterion_test_a, criterion_test_b))) {
        stop(criterion_stop_msg)
    }
    if (!is.numeric(n_features) & !is.null(n_features)) {
        stop("`n_features` must be numeric")
    }
    if (!is.null(n_features) & !is.null(min_change)) {
        stop("At least one of `n_features` and `min_change` must be NULL")
    }
    # `min_change` must be 'on'.
    min_change_test_a <- !is.numeric(min_change)
    min_change_test_b <- min_change <= 0
    if (is.null(n_features)) {
        min_change_test_a <- !is.numeric(min_change)
        min_change_test_b <- min_change <= 0
        if (any(c(min_change_test_a, min_change_test_b))){
            stop("`min_change` must be numeric and greater than 0.")
        }
    }
    # `n_features` must be 'on'.
    if (is.null(min_change)) {
        n_features_test_a <- !is.numeric(n_features)
        n_features_test_b <- n_features <= 0
        if (any(c(n_features_test_a, n_features_test_b))) {
            stop("`n_features` must be number and greater than zero.")
        }
    }
}


#' Check Data Input
#'
#' @description Checks that input data for `forward()` and `backward()`
#' functions are the correct format. Specifically looks for:
#' \itemize{
#'   \item \code{X} and \code{y} are appropriate dimensions (both same number of observations)
#'   \item \code{X} is a 2D numeric vector and \code{y} is a 1D numeric vector
#' }
#' @param X input for either \code{X_train} or \code{X_val}. Expected to be a 2D numeric matrix.
#'
#' @param y input for either \code{y_train} or \code{y_val}. Expected to be a 1D numeric matrix.
#'          If `y` is a character string AND X is a dataframe, it will be extracted from X.
#'
#' @return list X matrix (If X is a dataframe when input, it will be converted into a matrix.
#'                        Otherwise, if all of the checks pass, it will be returned 'as is'.)
#'              y 'as is' or extracted from X (if y was a character string on input.
#'
#' @keywords internal
input_data_checks <- function(X, y) {
    if (is.data.frame(X)) {
        if (is.character(y)) {
            y_extract <- X[[y]]
            X <- X[, colnames(X) != y]  # drop y
            y <- as.numeric(y_extract)
        }
        X <- as.matrix(X)
        colnames(X) <- NULL
    }

    if (!is.matrix(X) | length(dim(X)) != 2) {
        stop_msg <- "X must be a 2D numeric matrix"
        stop(stop_msg)
    } else if (!is.numeric(X)) {
        stop_msg <- "X must be a 2D numeric matrix"
        stop(stop_msg)
    }
    y_state_test_a <- !(is.vector(y) & is.numeric(y))
    y_state_test_b <- (is.vector(y) & !is.numeric(y))
    if (any(c(y_state_test_a, y_state_test_b))) {
        stop_msg <- "y must be a 1D numeric vector"
        stop(stop_msg)
    }
    if (length(y) != dim(X)[1]) {
        stop <- "X and y must have the same number of observations"
        stop(stop)
    }
    return(list(X, y))
}
