% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/checks.R
\name{input_checks}
\alias{input_checks}
\title{Check parameter input}
\usage{
input_checks(n_features, min_change, criterion)
}
\arguments{
\item{n_features}{the number of features to select. Floats will be regarded as proportions
of the total that must lie on (0,1). min_change must be None for `n_features` to
operate.}

\item{min_change}{The smallest change to be considered significant.
\code{n_features} must be None for \code{min_change} to operate.}

\item{criterion}{A string representing the model selection criterion to be used.
Can be one of 'r-squared', aic', 'bic'}
}
\description{
Checks that:
\itemize{
  \item only one of the the two inputs, \code{n_features} and \code{min_change}, are non-None
  \item the remaining element is numeric and is strictly greater than zero
}
}
\keyword{internal}
