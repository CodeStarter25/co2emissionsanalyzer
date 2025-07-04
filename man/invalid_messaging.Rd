% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{invalid_messaging}
\alias{invalid_messaging}
\title{Print messaging for user feedback}
\usage{
invalid_messaging(input_text, default_val)
}
\arguments{
\item{input_text}{A character string inserted to identify which value is 
being defaulted.}

\item{default_val}{A character string or numeric value used as default.}
}
\value{
No return value. Function prints a message.
}
\description{
Simple method to message the user when input is blank or incorrect, and 
program defaults are being used.
}
\examples{
# invalid_messaging("start year", 1960)
}
\keyword{internal}
