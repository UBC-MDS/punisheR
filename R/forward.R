source("R/checks.R")
source("R/utils.R")

#' Forward Break Criteria
#'
#' @description Checks if \code{forward()} should break.
#'
#' @param S A vector of selected features in \code{forward()} and \code{backward()}.
#'
#' @param current_best_j A vector representing the best feature currently in \code{forward()}.
#'
#' @param j_score_dict A dictionary of scores in step 1 of \code{forward()}.
#'
#' @param n_features A numeric \code{n_features} object as developed inside \code{forward()}.
#'
#' @param min_change The smallest change in criterion score to be considered significant.
#'
#' @param total_number_of_features The total number of features in \code{X_train}/\code{X_train}.
#'
#' @return A logical that represents whether or not \code{forward()} should halt.
#'
#' @keywords internal
.forward_break_criteria <-
    function(S,
             current_best_j,
             n_features,
             min_change,
             total_number_of_features) {
        # a. Check if the algorithm should halt b/c of features themselves
        test_a <- is.null(current_best_j)
        # b. Check that the score is, at least, > `min_change`.
        test_b <- ifelse(is.numeric(min_change),
                         current_best_j[2] < min_change, FALSE)
        # c. Check if the total number of features has been reached.
        test_c <- length(S) == total_number_of_features
        # d. Break if the number of features in S > n_features.
        d_cond <- !is.null(n_features) & missing(min_change)
        test_d <- ifelse(d_cond, n_features - 1 > length(S), FALSE)
        # e. Check absolute length
        test_e <- n_features == length(S)
        # Compose Bool
        do_halt <- any(c(test_a, test_b, test_c, test_d, test_e))
        return(do_halt)
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
#'  If \code{TRUE}, print additional information as selection occurs
#'
#' @examples
#' X_train <- matrix(runif(50, 0, 50), ncol=5)
#' y_train <- runif(10, 0, 50)
#' X_val <- matrix(runif(50, 0, 20), ncol=5)
#' y_val <- runif(10, 0, 20)
#' forward(X_train, y_train, X_val, y_train, min_change=0.1, criterion="r-squared")
#' forward(X_train, y_train, X_val, y_train, n_features=0.1, criterion="aic")
#'
#' @return A vector of indices that represent the best features of the model.
#'
#' @export
forward <- function(X_train,
                    y_train,
                    X_val,
                    y_val,
                    min_change = 0.5,
                    n_features = NULL,
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

    # Set min_change to NULL if n_features arg is passed into function
    if (!is.null(n_features) & missing(min_change)) {
        min_change <- NULL
    }
    input_checks(n_features, min_change = min_change, criterion = criterion)
    total_number_of_features <- ncol(X_train)
    S <- c()
    best_score <- -Inf
    itera <- 1:total_number_of_features

    if (!is.null(n_features)) {
        n_features <- parse_n_features(n_features = n_features,
                                       total = total_number_of_features)
        min_change <- NULL
    }

    for (i in 1:total_number_of_features) {
        if (verbose) {
            print(paste0(c("Iteration ", i), collapse = ""))
        }

        # 1. Find best feature, j, to add.
        current_best_j <- NULL
        for (j in itera) {
            score <- fit_and_score(
                S = S,
                feature = j,
                algorithm = "forward",
                X_train = X_train,
                y_train = y_train,
                X_val = X_val,
                y_val = y_val,
                criterion = criterion
            )
            if (score > best_score | !is.null(n_features)) {
                if (is.null(current_best_j)) {
                    current_best_j <- c(j, score)
                } else if (score > current_best_j[2]) {
                    current_best_j <- c(j, score)
                }
            }
        }
        # 2. Save the best j to S, if possible.
        if (!is.null(current_best_j)) {
            best_j <- current_best_j[1]
            best_j_score <- current_best_j[2]
            # Update S, the best score and score history ---
            best_score <- best_j_score   # update the score to beat
            S <- c(S, best_j)   # add feature
            # no longer search over feature
            itera <- itera[itera != best_j]
        }
        # 3. Check if the algorithm should halt.
        do_halt <- .forward_break_criteria(
            S = S,
            current_best_j = current_best_j,
            n_features = n_features,
            min_change = min_change,
            total_number_of_features = total_number_of_features
        )
        if (do_halt) {
            break
        }
    }
    return(S)
}
