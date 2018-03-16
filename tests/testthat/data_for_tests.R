#' Test Data
#'
#' @description generates test data that can be used with `forward()` and
#' `backward()` functions. Generates y = x + e, where e ~ Uniform(0, 50) and
#' `x` is embedded as the middle column in a zero matrix. Only ONE column is
#' predictive of y, the rest are trivial column vectors.
#'
#' @param seed_value seed value to randomize runif value generation
#'
#' @return X_train, y_train, X_val, y_val (as a list of matrices/vectors)
#'
#' @keywords internal
test_data <- function(seed_value) {
    set.seed(seed_value)
    features <- 20
    obs <- 500
    middle_feature <- features / 2

    X <- matrix(0L, nrow = obs, ncol = features)
    y <- 1:obs
    X[, middle_feature] <- y + runif(n = obs, min = 0, max = 50)

    # 75% Training, 25% test (i.e., obs / 4).
    training <- sample(rep(c(TRUE, TRUE, TRUE, FALSE), obs / 4))

    # Training Data ---
    X_train <- X[training,]
    y_train <- y[training]

    # Validation Data ---
    X_val <- X[!training,]
    y_val <- y[!training]

    TRUE_BEST_FEATURE <- middle_feature

    return(list(X_train, y_train, X_val, y_val))
}

#' Generating test data with mtcars
#'
#' @description generates test data using base R's mtcars dataset
#'
#' @return X_train, y_train, X_val, y_val (as a list of dataframes)
#'
#' @keywords internal
mtcars_data <- function() {
    y <- mtcars$hp
    X <- mtcars
    X$hp <- NULL
    training <-
        sample(rep(c(TRUE, TRUE, TRUE, FALSE), nrow(mtcars) / 4))
    # Training Data ---
    X_train <- X[training,]
    y_train <- y[training]

    # Validation Data ---
    X_val <- X[!training,]
    y_val <- y[!training]
    return(list(X_train, y_train, X_val, y_val))
}
