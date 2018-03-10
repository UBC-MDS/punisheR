# Criterion

.get_coeffs <- function(model){

    # Args:
    #   model : model object
    #          A Base-R Model
    #
    # Returns:
    #   n : double
    #       Number of samples
    #   k : double
    #       Number of features
    #   llf : double
    #       Maximized value of log likelihood function

    n <- length(model$residuals)
    k <- model$rank + 1
    rss = sum(model$residuals^2)
    llf = -(n/2)*log(2*pi) - (n/2)*log(rss/n) - n/2
    return(c(n, k, llf))
}


#' @export
aic <- function(model){

    # Compute the Akaike Information Criterion (AIC)
    #
    # AIC's objective is to prevent model overfitting by adding a penalty
    # term which penalizes more compelx models. Its formal definition is:
    #     -2ln(L)+2*k
    # where L is the maximized value of the likelihood function.
    # A smaller AIC value suggests that the model is a better fit for the data.
    #
    # Args:
    #    model : model object
    #           A Base-R Model
    #
    # Returns:
    #   aic : double
    #         AIC value if sample size is sufficient.
    #         If n/k < 40 where n is the number of observations and k is the number of features,
    #         AIC gets reduced to adjust for small sample size.
    #
    # References:
    #   * https://en.wikipedia.org/wiki/Akaike_information_criterion
    #

    if(!is.object(model)){
        stop("`model` not a Base-R Model.")
    }

    coeff <- .get_coeffs(model)
    n <- coeff[1]
    k <- coeff[2]
    llf <- coeff[3]
    aic <- -2*llf + 2*k

    if (n/k < 40){
        return(aic + 2*k*(k+1)/(n-k-1))
    } else
    {
        return(aic)
    }
}


bic <- function(model){

    # Compute the Bayesian Information Criterion (BIC)
    # BIC's objective is to prevent model over-fitting by adding a penalty
    # term which penalizes more complex models. Its formal definition is:
    # -2ln(L)+ln(n)k
    # where L is the maximized value of the likelihood function.
    # A smaller BIC value suggests that the model is a better fit for the data.
    #
    # Args:
    #   model : model object
    #         A Base-R Model
    #
    # Returns:
    #   bic : double
    #         Bayesian Information Criterion value.
    #
    # References:
    #   * https://en.wikipedia.org/wiki/Bayesian_information_criterion
    #
    if(!is.object(model)){
        stop("`model` not a Base-R Model.")
    }

    coeff <- .get_coeffs(model)
    n <- coeff[1]
    k <- coeff[2]
    llf <- coeff[3]
    bic <- -2*llf + log(n)*k

    return(bic)
}
