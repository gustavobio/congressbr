% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cham_bill_info_id.R
\name{cham_bill_info_id}
\alias{cham_bill_info_id}
\title{Downloads details of a specific bill by providing id of a bill}
\usage{
cham_bill_info_id(bill_id, ascii = T)
}
\arguments{
\item{bill_id}{\code{integer}. The id number of the bill.}

\item{ascii}{\code{logical}. If TRUE, certain strings are converted to ascii
format.}
}
\value{
A tibble, of classes \code{tbl_df}, \code{tbl} and \code{data.frame}.
}
\description{
Downloads details of a specific bill by providing id of a bill
}
\note{
Requesting data from a long period of time with \code{details = TRUE} will
return a large object in terms of memory. It will also be rather unwieldy, with
many columns.
}
\examples{
\dontrun{
cham_bill_info_id(14784)
}
}
\author{
Robert Myles McDonnell, Guilherme Jardim Duarte & Danilo Freire.
}
