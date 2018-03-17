#' Generating test data with mtcars.
#'
#' @description generates test data using base R's mtcars dataset
#'
#' @param seed random seed to use. Defaults to 99.
#'
#' @return X_train, y_train, X_val, y_val (as a list of dataframes)
#'
#' @export
mtcars_data <- function(seed=99) {
    y <- mtcars$hp
    X <- mtcars
    X$hp <- NULL
    set.seed(seed)
    training <- sample(rep(c(TRUE, TRUE, TRUE, FALSE), nrow(mtcars) / 4))
    # Training Data ---
    X_train <- X[training,]
    y_train <- y[training]

    # Validation Data ---
    X_val <- X[!training,]
    y_val <- y[!training]
    return(list(X_train, y_train, X_val, y_val))
}