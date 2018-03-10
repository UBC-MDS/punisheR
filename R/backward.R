# Backward Selection
source("R/checks.R")
source("R/utils.R")


#' @export
backward <- function(X_train, y_train, X_val, y_val,
                     n_features=0.5, min_change=NULL,
                     criterion='r-squared', verbose=TRUE){
    # Backward Selection Algorithm for Base R's `lm()` function
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
    #         * 'aic': use Akaike Information as the Criterion.
    #         * 'bic': use Bayesian Information as the Criterion.
    #     n_features : numeric
    #         The number of features to select.
    #         Floats will be regarded as proportions of the total
    #         that must lie on (0, 1).
    #         `min_change` must be None for `n_features` to operate.
    #     min_change : numeric
    #         The smallest change to be considered significant.
    #         `n_features` must be None for `min_change` to operate.
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
    S = 1:ncol(X_train)  # start with all features

    if (!is.null(n_features)){
        n_features <- parse_n_features(
            n_features=n_features, total=length(S)
        )
    }

    last_iter_score = fit_and_score(
        S=S, feature=NULL, algorithm='backward', X_train=X_train,
        y_train=y_train, X_val=X_val, y_val=y_val, criterion=criterion
    )
    for (i in 1:ncol(X_train)){  # assume worst case to start.
        if (verbose){
            print(paste0(c("Iteration ", i), collapse=""))
        }

        # 1. Hunt for the least predictive feature.
        best = NULL
        for (j in S){
            score = fit_and_score(
                S=S, feature=j, algorithm='backward', X_train=X_train,
                y_train=y_train, X_val=X_val, y_val=y_val, criterion=criterion
            )
            if (is.null(best)){
                best <- c(j, score, score > last_iter_score)
            } else if (score > best[2]){
                best <- c(j, score, score > last_iter_score)
            }
        }
        to_drop <- best[1]
        best_new_score <- best[2]
        defeated_last_iter_score <- best[3]

        # 2a. Halting Blindly Based on `n_features`.
        if (!is.null(n_features)){
            S <- S[S != to_drop]
            last_iter_score = best_new_score
            if (length(S) == n_features){
                break
            } else {
                next # i.e., ignore criteria below.
            }
        }

        # 2b. Halt if the change is not longer considered significant.
        if (!is.null(min_change)){
            if (defeated_last_iter_score){
                if ((best_new_score - last_iter_score) < min_change){
                    break  # there was a change, but it was not large enough.
                } else {
                    S <- S[S != to_drop]
                    last_iter_score = best_new_score
                }
            } else {
                break
            }
        }

        # 2c. Halt if only one feature remains.
        if (length(S) == 1){
            break
        }
    }
    return(S)
}
