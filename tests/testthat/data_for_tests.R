# Test Data
#
# Generate: y = x + e, where e ~ Uniform(0, 50) and
# `x` is embedded as the middle column in a zero matrix.
# That is, only ONE column is predictive of y, the rest are
# trivial column vectors.

test_data <- function(seed_value) {
  set.seed(seed_value)
  features = 20
  obs = 500
  middle_feature = features / 2
  
  X <- matrix(0L, nrow=obs, ncol=features)
  y <- 1:obs
  X[, middle_feature] <- y + runif(n=obs, min=0, max=50)
  
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
