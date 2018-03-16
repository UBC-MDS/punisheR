# Utils
source("R/criterion.R")

#' Parsing features
#' @description Parse \code{n_features} for forward and backward selection.
#' Handles two cases:
#' \itemize{
#' \item if \code{n_features} is an integer, ensure it lies on (0, total).
#' \item if \code{n_features} is a float, ensure it lies on (0, 1).
#' }
#' @param n_features Numeric value passed to forward or backward selection.
#'
#' @param total Total features in the data
#'
#' @return Number of features to select. If initial \code{n_features} lies on (0, total_features),
#' it will be returned 'as is'. If \code{n_feature} is passed in as a proportion with range (0,1), it will
#' be converted to an integer representing proportion with respect to the total number of features.
#'
#' @keywords internal
parse_n_features <- function(n_features, total) {
    if (n_features <= 0){
        stop("`n_features` must be greater than zero.")
    }
    if (n_features > 0 & n_features < 1) {
        return(round(n_features * total))
    } else if (n_features > total) {
        stop(paste0(
            "If a whole number, `n_features` must be on (0, ", total, ")."
            ))
    } else {
        return(n_features)
    }
}

#' Fitter
#' @description Fits data to a linear regression model.
#'
#' @param X_input A 2D matrix of features
#'
#' @param y_input A 1D vector representing the response variable
#'
#' @return A fitted \code{lm()} model
#' @keywords internal
fitter <- function(X_input, y_input){
    X <- X_input
    y <- y_input
    df <- cbind(as.data.frame(X), as.data.frame(y))

    # Fit and return model
    m <- stats::lm(y ~., data = df)
    return(m)
}

#' Fit and Score
#' @description Fits a linear regression model to the data and
#' scores the relative quality of the model using r-squared, aic, or bic.
#'
#' @param S A vector representing the list of selected features in `forward()` and `backward()`
#'
#' @param feature Feature to add or drop, expressed as an integer.
#'
#' @param algorithm Direction of feature selection. One of: 'forward', 'backward'.
#'
#' @param X_train Training data. Represented as a 2D matrix of (observations, features).
#'
#' @param y_train Target class for training data. Represented as a 1D vector of target classes for \code{X_train}.
#'
#' @param X_val Validation data. Represented as a 2D matrix of (observations, features).
#'
#' @param y_val Target class for validation data. Represented as a 1D vector of target classes for \code{X_val}.
#'
#' @param criterion Model selection criterion to measure relative model quality. Can be one of:
#' \itemize{
#'  \item 'aic': use Akaike Information Criterion
#'  \item 'bic': use Akaike Information Criterion
#'  \item 'r-squared': use coefficient of determination
#' }
#'
#' @return Score of the model as a float.
#' @keywords internal

fit_and_score <- function(S, feature, algorithm, X_train,
                          y_train, X_val, y_val, criterion){
    if (algorithm == "forward"){
        features <- c(S, feature)
    } else {
        if (is.null(feature)){
            features <- S
        } else {
            features <- S[S != feature]
        }
    }
    features_to_use <- (1:ncol(X_train)) %in% features
    X_train_to_use <- X_train[, features_to_use]
    X_val_to_use <- X_val[, features_to_use]

    # Correct for delightful R behavior that results
    # in matrices degenerating to to vectors when
    # only a single column is extracted.
    if (length(features) == 1){
        X_train_to_use <- as.matrix(X_train_to_use)
        X_val_to_use <- as.matrix(X_val_to_use)
    }

    fit <- fitter(X_input = X_train_to_use, y_input = y_train)
    if (criterion == "r-squared") {
        score <- r_squared(fit_model = fit, X = X_val_to_use, y = y_val)
    } else if (criterion == "aic") {
        score <- aic(model = fit)
    } else if (criterion == "bic") {
        score <- bic(model = fit)
    }
    return(score)
}
