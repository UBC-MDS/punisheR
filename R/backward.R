source("R/checks.R")
source("R/utils.R")


#' Backward Selection Algorithm
#'
#' @description
#' This is an implementation of the backward selection algorithm
#' in which you start with a full model and iteratively remove the
#' least useful feature at each step. This function is built for the specific case
#' of backward selection in linear regression models.
#'
#'
#' @param X_train Training data. Represented as a 2D matrix or dataframe of (observations, features).
#'
#' @param y_train Target class for training data. Represented as a 1D vector of target classes for \code{X_train}.
#'                If \code{y_train} is a character string AND \code{X} is a dataframe, it will be extracted from \code{X}.
#'
#' @param X_val Validation data. Represented as a 2D matrix or dataframe of (observations, features).
#'
#' @param y_val Target class for validation data. Represented as a 1D vector of target classes for \code{X_val}.
#'              If \code{y_val} is a character string AND \code{X} is a dataframe, it will be extracted from \code{X}.
#'
#' @param criterion Model selection criterion to measure relative model quality. Can be one of:
#' \itemize{
#'  \item 'aic': use Akaike Information Criterion
#'  \item 'bic': use Akaike Information Criterion
#'  \item 'r-squared': use coefficient of determination
#' }
#'
#' @param min_change The smallest change in criterion score to be considered significant.
#'                   Note: \code{n_features} must be NULL if this is numeric.
#'
#' @param n_features The number of features to select, expressed either as a proportion (0,1)
#' or whole number with range (0,total_features). Note: \code{min_change} must be NULL if this is numeric.
#'
#' @param verbose
#'  if \code{TRUE}, print additional information as selection occurs
#'
#' @examples
#' X_train <- matrix(runif(50, 0, 50), ncol=5)
#' y_train <- runif(10, 0, 50)
#' X_val <- matrix(runif(50, 0, 20), ncol=5)
#' y_val <- runif(10, 0, 20)
#' backward(X_train, y_train, X_val, y_train, min_change=0.1, n_features=NULL, criterion="r-squared")
#' backward(X_train, y_train, X_val, y_train, n_features=0.1, min_change=NULL, criterion="aic")
#'
#'
#' @return A vector of indices that represent the best features of the model.
#'
#' @export
backward <- function(X_train,
                     y_train,
                     X_val,
                     y_val,
                     n_features = 0.5,
                     min_change = NULL,
                     criterion = "r-squared",
                     verbose = TRUE) {
    # Check data is of the correct form (a matrix)
    # If not, `input_data_checks` will coerce it to be.
    train <- input_data_checks(X_train, y_train)
    X_train <- train[[1]]
    y_train <- train[[2]]
    test <- input_data_checks(X_val, y_val)
    X_val <- test[[1]]
    y_val <- test[[2]]

    input_checks(n_features = n_features,
                 min_change = min_change,
                 criterion = criterion)
    S <- seq(1, ncol(X_train))  # start with all features

    if (!is.null(n_features)) {
        n_features <- parse_n_features(n_features = n_features,
                                       total = length(S))
    }

    last_iter_score <- fit_and_score(
        S = S,
        feature = NULL,
        algorithm = "backward",
        X_train = X_train,
        y_train = y_train,
        X_val = X_val,
        y_val = y_val,
        criterion = criterion
    )

    for (i in seq(1, ncol(X_train))) {
        if (verbose) {
            print(paste0(c("Iteration ", i), collapse = ""))
        }

        # Halt if only one feature present.
        if (length(S) == 1) {
            break
        }

        # 1. Hunt for the least predictive feature.
        best <- NULL
        for (j in S) {
            score <- fit_and_score(
                S = S,
                feature = j,
                algorithm = "backward",
                X_train = X_train,
                y_train = y_train,
                X_val = X_val,
                y_val = y_val,
                criterion = criterion
            )
            if (is.null(best)) {
                best <- c(j, score, score > last_iter_score)
            } else if (score > best[2]) {
                best <- c(j, score, score > last_iter_score)
            }
        }
        to_drop <- best[1]
        best_new_score <- best[2]
        defeated_last_iter_score <- best[3]

        # 2a. Halting Blindly Based on `n_features`.
        if (!is.null(n_features)) {
            S <- S[S != to_drop]
            last_iter_score <- best_new_score
            if (length(S) == n_features) {
                break
            } else {
                next # i.e., ignore criteria below.
            }
        }

        # 2b. Halt if the change is not longer considered significant.
        if (!is.null(min_change)) {
            n_features <- NULL
            if (defeated_last_iter_score) {
                if ((best_new_score - last_iter_score) < min_change) {
                    break  # there was a change, but it was not large enough.
                } else {
                    S <- S[S != to_drop]
                    last_iter_score <- best_new_score
                }
            } else {
                break
            }
        }

    }
    return(S)
}
