source("R/checks.R")
source("R/utils.R")

#' Forward Break Criteria
#'
#' @description Checks if \code{forward()} should break.
#'
#' @param S A vector of selected features in \code{forward()} and \code{backward()}
#'
#' @param current_best_j A vector representing the best feature currently in \code{forward()}
#'
#' @param j_score_dict A dictionary of scores in step 1 of \code{forward()}
#'
#' @param n_features A numeric `n_features` object as developed inside \code{forward()}
#'
#' @param min_change The smallest change in criterion score to be considered significant.
#'
#' @param total_number_of_features The total number of features in \code{X_train}/\code{X_train}
#'
#' @return A logical that represents whether or not \code{forward()} should halt
#'
#' @keywords internal
.forward_break_criteria <- function(S, current_best_j, n_features, min_change,
                                    total_number_of_features){

    # a. Check if the algorithm should halt b/c of features themselves
    if (is.null(current_best_j)){
        return(TRUE)
    }
    # b. Check that the score is, at least, > `min_change`.
    if (is.numeric(min_change)){
        if (current_best_j[2] < min_change){
            return(TRUE)  # if not, break
        }
    }
    # c. Check if the total number of features has been reached.
    if (length(S) == total_number_of_features){
        return(TRUE)
    # d. Break if the number of features in S > n_features.
    } else if (!is.null(n_features)){
        if (n_features > length(S)){
            return(TRUE)
        }
    } else {
        return(FALSE)
    }
}


#' Forward Selection Algorithm.
#'
#' @description
#' This is an implementation of the forward selection algorithm in which you
#' start with a null model and iteratively add the most useful features.
#' This function is built for the specific case of forward selection in
#' linear regression.
#'
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
#' @param min_change The smallest change in criterion score to be considered significant.
#'
#' @param n_features The number of features to select, expressed either as a proportion (0,1)
#' or whole number with range (0,total_features)
#'
#' @param verbose
#'  if \code{TRUE}, print additional information as selection occurs
#'
#' @return A vector of indices that represent the best features of the model.
#'
#' @export
forward <- function(X_train, y_train, X_val, y_val,
                    min_change = 0.5, n_features = NULL,
                    criterion = "r-squared", verbose = TRUE){
    input_data_checks(X_train, y_train)
    input_data_checks(X_val, y_val)
    input_checks(n_features, min_change = min_change, criterion = criterion)
    total_number_of_features <- ncol(X_train)
    S <- c()
    best_score <- -Inf
    itera <- 1:total_number_of_features

    if (!is.null(n_features)){
        n_features <- parse_n_features(
            n_features = n_features, total = length(S)
        )
        min_change <- NULL
    }

    for (i in 1:total_number_of_features) {
        if (verbose){
            print(paste0(c("Iteration ", i), collapse = ""))
        }

        # 1. Find best feature, j, to add.
        current_best_j <- NULL
        for (j in itera){
            score <- fit_and_score(
                S = S, feature = j, algorithm = "forward",
                X_train = X_train, y_train = y_train,
                X_val = X_val, y_val = y_val, criterion = criterion
            )
            if (score > best_score){
                if (is.null(current_best_j)){
                    current_best_j <- c(j, score)
                } else if (score > current_best_j[2]){
                    current_best_j <- c(j, score)
                }
            }
        }
        # 2. Save the best j to S, if possible.
        if (!is.null(current_best_j)){
            best_j <- current_best_j[1]
            best_j_score <- current_best_j[2]
            # Update S, the best score and score history ---
            best_score <- best_j_score   # update the score to beat
            S <- c(S, best_j)   # add feature
            itera <- itera[itera != best_j]  # no longer search over feature
        }
        # 3. Check if the algorithm should halt.
        do_halt <- .forward_break_criteria(
            S = S, current_best_j = current_best_j,
            n_features = n_features, min_change = min_change,
            total_number_of_features = total_number_of_features
        )
        if (do_halt){
            break
        }
    }
    return(S)
}
