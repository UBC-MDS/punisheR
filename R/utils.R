# Utils
source("R/criterion.R")

#' Parsing features
#' @description Parse `n_features` for forward and backward selection.
#' Handles two cases: (a) if `n_features` is an int, ensure it lies on (0, `total`),
#' and (b) if `n_features` is a float, ensure it lies on (0, 1).
#'
#' @param n_features numeric value passed to forward or backward selection
#'
#' @param total total features in the data
#'
#' @return number of features to select. If `n_features` and it lies on (0, `total`),
#' it will be returned 'as is'. Whole numbers must lie of [0, total].
#' @keywords internal
parse_n_features <- function(n_features, total){
    if (n_features <= 0){
        stop("`n_features` must be greater than zero.")
    }
    if (n_features > 0 & n_features < 1){  # interpret `n_features` as a proportion.
        return(round(n_features * total))
    } else if (n_features > total){  # interpret `n_features` as a count.
        stop(paste0("If a whole number, `n_features` must be on (0, ", total, ")."))
    } else {
        return(n_features)
    }
}

#' Fitter
#' @description Fits data to a linear regression model.
#'
#' @param X0 a matrix of features
#'
#' @param y0 a response vector
#'
#' @return a fitted lm() model
#' @keywords internal
.fitter <- function(X_input, y_input){
    X<-X_input
    y<-y_input
    df <- cbind(as.data.frame(X),as.data.frame(y))

    # Fit and return model
    m <- stats::lm(y ~., data=df)
    return(m)
}

#' Fit and Score
#' @description fit and scores the linear regression model
#'
#' @param S list of features as found in `forward()` and `backward()`
#'
#' @param feature feature to add or drop (int)
#'
#' @param algorithm direction of feature selection. One of: 'forward', 'backward'
#'
#' @param X_train a 2D matrix of (observations, features).
#'
#' @param y_train a 1D array of target classes for X_train.
#'
#' @param X_val a 2D matrix of (observations, features).
#'
#' @param y_val a 1D array of target classes for X_validate
#'
#' @param criterion model selection criterion (string). One of:
#' 'r-squared', 'aic', 'bic'
#'
#' @return score of the model as a float
#' @keywords internal

fit_and_score <- function(S, feature, algorithm, X_train,
                          y_train, X_val, y_val, criterion){
    if (algorithm == "forward"){
        features <- c(S, feature)
    } else {  # backward
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

    fit <- .fitter(X_input=X_train_to_use, y_input=y_train)
    if (criterion == 'r-squared'){
        score <- r_squared(fit_model=fit, X=X_val_to_use, y=y_val)
    } else if (criterion == 'aic'){
        score <- aic(model=fit)
    } else if (criterion == 'bic'){
        score <- bic(model=fit)
    }
    return(score)
}
