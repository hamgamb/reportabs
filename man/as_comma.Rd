% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/str_format.R
\name{as_comma}
\alias{as_comma}
\title{Format a value as a pretty string, with comma separation}
\usage{
as_comma(string, group = NULL, value = NULL, suffix = NULL, digits = 0)
}
\arguments{
\item{string}{Value to print}

\item{group}{A group over which to apply as_comma()}

\item{value}{The values to apply as_comma() to. Is NULL if group is NULL}

\item{suffix}{A string to print after the number}

\item{digits}{Number of digits to print. Defaults to 0}
}
\value{
A comma formatted string of \code{string}
}
\description{
Format a value as a pretty string, with comma separation
}
\examples{
as_comma(1000)


}
