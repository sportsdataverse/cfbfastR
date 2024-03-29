% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create_wpa_naive.R
\name{create_wpa}
\alias{create_wpa}
\alias{create_wpa_naive}
\alias{wpa_calcs_naive}
\title{\strong{Create WPA}}
\usage{
create_wpa_naive(df, wp_model)

wpa_calcs_naive(df)
}
\arguments{
\item{df}{(\emph{data.frame} required): Clean Play-by-Play data.frame with Expected Points Added (EPA) calculations}

\item{wp_model}{(\emph{model} default cfbfastR:wp_model): Win Probability (WP) Model}
}
\value{
The original \code{df} with the following columns appended to it:
\describe{
\item{wp_before}{.}
\item{def_wp_before}{.}
\item{home_wp_before}{.}
\item{away_wp_before}{.}
\item{lead_wp_before}{.}
\item{lead_wp_before2}{.}
\item{wpa_base}{.}
\item{wpa_base_nxt}{.}
\item{wpa_base_ind}{.}
\item{wpa_base_nxt_ind}{.}
\item{wpa_change}{.}
\item{wpa_change_nxt}{.}
\item{wpa_change_ind}{.}
\item{wpa_change_nxt_ind}{.}
\item{wpa}{.}
\item{wp_after}{.}
\item{def_wp_after}{.}
\item{home_wp_after}{.}
\item{away_wp_after}{.}
}
}
\description{
Add Win Probability Added (WPA) calculations to Play-by-Play DataFrame
This is only for D1 football
}
\details{
Requires the following columns to be present in the input data frame.
}
\keyword{internal}
