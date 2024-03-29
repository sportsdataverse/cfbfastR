% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cfbd_teams.R
\name{cfbd_team_roster}
\alias{cfbd_team_roster}
\title{\strong{Get team rosters}}
\usage{
cfbd_team_roster(year, team = NULL)
}
\arguments{
\item{year}{(\emph{Integer} required): Year,  4 digit format (\emph{YYYY})}

\item{team}{(\emph{String} optional): Team, select a valid team in D-I football}
}
\value{
\code{\link[=cfbd_team_roster]{cfbd_team_roster()}} - A data frame with 12 variables:
\describe{
\item{\code{athlete_id}: character.}{Referencing athlete id.}
\item{\code{first_name}: character.}{Athlete first name.}
\item{\code{last_name}: character.}{Athlete last name.}
\item{\code{team}: character.}{Team name.}
\item{\code{weight}: integer.}{Athlete weight.}
\item{\code{height}: integer.}{Athlete height.}
\item{\code{jersey}: integer.}{Athlete jersey number.}
\item{\code{year}: integer.}{Athlete year.}
\item{\code{position}: character.}{Athlete position.}
\item{\code{home_city}: character.}{Hometown of the athlete.}
\item{\code{home_state}: character.}{Hometown state of the athlete.}
\item{\code{home_country}: character.}{Hometown country of the athlete.}
\item{\code{home_latitude}: numeric.}{Hometown latitude.}
\item{\code{home_longitude}: number.}{Hometown longitude.}
\item{\code{home_county_fips}: integer.}{Hometown FIPS code.}
\item{\code{headshot_url}: character}{Player ESPN headshot url.}
}
}
\description{
Get a teams full roster by year. If team is not selected, API returns rosters for every team from the selected year.
}
\examples{
\donttest{
  try(cfbd_team_roster(year = 2013, team = "Florida State"))
}

}
\keyword{Roster}
\keyword{Team}
