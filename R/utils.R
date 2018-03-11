# Utils
source("R/criterion.R")


parse_n_features <- function(n_features, total){
    # Parse either the `n_features` for forward
    # and backward selection. Namely
    # (a) if `n_features` is an int, ensure it lies on (0, `total`),
    # (a) if `n_features` is a float, ensure it lies on (0, 1).
    #
    # Args:
    #   n_features : numeric
    #       An `n_features` parameter passed to forward or backward selection.
    #   total : numeric
    #       The total features in the data
    #
    # Returns:
    #   numeric
    #       * number of features to select.
    #       If `n_features` and it lies on (0, `total`),
    #       it will be returned 'as is'.
    #
    # Whole numbers must lie of [0, total].
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


fitter <- function(X, y){
    # Fit a linear regression model.
    #
    # Args:
    #   X : matrix
    #       A matrix of features
    #   y : vector
    #       A response vector
    #
    # Returns:
    #   A fitted `lm()` model.
    #
    df <- cbind(as.data.frame(X),as.data.frame(y))
    # Define formula
    preds <- colnames(df)[1:length(colnames(df)) - 1]
    rhs <- paste(preds, collapse = " + ")
    formula <- paste0(deparse(substitute(y)), " ~ ", rhs)

    # Fit and return model
    m <- lm(as.formula(formula), data=df)
    return(m)
}


fit_and_score <- function(S, feature, algorithm, X_train,
                          y_train, X_val, y_val, criterion){
    # Fit and score the model.
    #
    # Args:
    #   S : list
    #       The list of features as found in `forward`
    #       and `backward()`
    #   feature : int
    #       The feature to add or drop.
    #   algorithm : char
    #       One of: 'forward', 'backward'.
    #     X_train matrix
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
    #
    # Returns : float
    #   The score of the model.
    #
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

    fit <- fitter(X=X_train_to_use, y=y_train)
    if (criterion == 'r-squared'){
        score <- r_squared(fit_model=fit, X=X_val_to_use, y=y_val)
    } else if (criterion == 'aic'){
        score <- aic(model=fit)
    } else if (criterion == 'bic'){
        score <- bic(model=fit)
    }
    return(score)
}
