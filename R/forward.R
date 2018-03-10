# Forward Selection
source("R/checks.R")
source("R/utils.R")


forward_break_criteria <- function(S, current_best_j, n_features,
                                   total_number_of_features){
    # Check if `forward()` should break.
    #
    # Args:
    #   S : vector
    #       The 'list' of features as found in `forward`
    #       and `backward()`
    #   current_best_j : vector
    #       The best feature currently in `forward()`.
    #   j_score_dict : dict
    #       A dictionary of scores in step 1. of `forward()`.
    #   n_features : numeric
    #       The `n_features` object as developed inide `forward()`.
    #   total_number_of_features : numeric
    #       The total number of features in `X_train`/`X_val`.
    #
    # Returns:
    #   logical
    #       Whether or not `forward()` should halt.
    #
    # a. Check if the algorithm should halt b/c of features themselves
    if (is.null(current_best_j)){
        return(TRUE)
    }
    if (length(S) == total_number_of_features){
        return(TRUE)
    # b. Break if the number of features in S > n_features.
    } else if (!is.null(n_features)){
        if (n_features > length(S)){
            return(TRUE)
        }
    } else {
        return(FALSE)
    }
}


#' @export
forward <- function(X_train, y_train, X_val, y_val,
                    min_change=0.5, n_features=NULL,
                    criterion='r-squared', verbose=TRUE){
    # Forward Selection Algorithm for Base R's `lm()` function
    # (linear regression).
    #
    # Args:
    #     X_train : matrix
    #         a 2D matrix of (observations, features).
    #     y_train : matrix
    #         a 1D array of target classes for X_train.
    #     X_val : matrix
    #         a 2D matrix of (observations, features).
    #     y_val : matrix
    #         a 1D array of target classes for X_validate.
    #     criterion : char
    #         model selection criterion.
    #         * 'r-squared': use R-Squared as the criterion.
    #         * 'aic': use Akaike Information Criterion.
    #         * 'bic': use Bayesian Information Criterion.
    #     min_change : numeric, optional
    #         The smallest change to be considered significant.
    #         `n_features` must be None for `min_change` to operate.
    #     n_features : numeric
    #         the max. number of features to allow.
    #     verbose : bool
    #         if True, print additional information as selection occurs.
    #         Defaults to True.
    #
    # Returns:
    #     S : vector
    #       The column indices of `X_train` (and `X_val`)
    #       that denote the chosen features.
    #
    input_checks(n_features, min_change=min_change, criterion=criterion)
    total_number_of_features <- ncol(X_train)
    S <- c()
    best_score <- -Inf
    itera = 1:total_number_of_features

    if (!is.null(n_features)){
        n_features <- parse_n_features(
            n_features=n_features, total=length(S)
        )
    }

    for (i in 1:total_number_of_features){  # assume worst case
        if (verbose){
            print(paste0(c("Iteration ", i), collapse=""))
        }

        # 1. Find best feature, j, to add.
        current_best_j = NULL
        for (j in itera){
            score = fit_and_score(
                S=S, feature=j, algorithm='forward', X_train=X_train,
                y_train=y_train, X_val=X_val, y_val=y_val, criterion=criterion
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
            itera <- itera[itera != best_j]  # no longer search over this feature.
        }
        # 3. Check if the algorithm should halt.
        do_halt <- forward_break_criteria(
            S=S, current_best_j=current_best_j, n_features=n_features,
            total_number_of_features=total_number_of_features
        )
        if (do_halt){
            break
        }
    }
    return(S)
}
