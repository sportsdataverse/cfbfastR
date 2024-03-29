% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cfbd_draft.R
\name{cfbd_draft_picks}
\alias{cfbd_draft_picks}
\title{\strong{Get list of NFL draft picks}}
\usage{
cfbd_draft_picks(
  year = NULL,
  nfl_team = NULL,
  college = NULL,
  conference = NULL,
  position = NULL
)
}
\arguments{
\item{year}{(\emph{Integer} required): NFL draft class, 4 digit format (\emph{YYYY})}

\item{nfl_team}{(\emph{String}): NFL drafting team, see \code{\link[=cfbd_draft_teams]{cfbd_draft_teams()}} for valid selections.}

\item{college}{(\emph{String}): NFL draftee college team, see \code{\link[=cfbd_team_info]{cfbd_team_info()}} for valid selections.}

\item{conference}{(\emph{String}): NFL draftee college team conference, see \code{\link[=cfbd_conferences]{cfbd_conferences()}} for valid selections.}

\item{position}{(\emph{String}): NFL position abbreviation, see \code{\link[=cfbd_draft_positions]{cfbd_draft_positions()}} for valid selections.}
}
\value{
\code{\link[=cfbd_draft_picks]{cfbd_draft_picks()}} - A data frame with 23 variables:
\describe{
\item{\code{college_athlete_id}: integer.}{College athlete referencing id.}
\item{\code{nfl_athlete_id}: integer}{NFL athlete referencing id.}
\item{\code{college_id}: integer}{College team referencing id.}
\item{\code{college_team}: character}{College team name.}
\item{\code{college_conference}: character}{Conference of college team.}
\item{\code{nfl_team}: character}{NFL team name of drafted player.}
\item{\code{year}: integer.}{NFL draft class year.}
\item{\code{overall}: integer.}{Overall draft pick number.}
\item{\code{round}: integer.}{Round of NFL draft the draftee was picked in.}
\item{\code{pick}: integer.}{Pick number of the NFL draftee within the round they were picked in.}
\item{\code{name}: character.}{NFL draftee name.}
\item{\code{position}: character.}{NFL draftee position.}
\item{\code{height}: double.}{NFL draftee height.}
\item{\code{weight}: integer.}{NFL draftee weight.}
\item{\code{pre_draft_ranking}: integer}{Pre-draft ranking (ESPN).}
\item{\code{pre_draft_position_ranking}: integer.}{Pre-draft position ranking (ESPN).}
\item{\code{pre_draft_grade}: double.}{Pre-draft scouts grade (ESPN).}
\item{\code{hometown_info_city}: character.}{Hometown of the NFL draftee.}
\item{\code{hometown_info_state_province}: character.}{Hometown state of the NFL draftee.}
\item{\code{hometown_info_country}: character.}{Hometown country of the NFL draftee.}
\item{\code{hometown_info_latitude}: character.}{Hometown latitude of the NFL draftee.}
\item{\code{hometown_info_longitude}: character.}{Hometown longitude of the NFL draftee.}
\item{\code{hometown_info_county_fips}: character.}{Hometown FIPS code of the NFL draftee.}
}
}
\description{
\strong{Get list of NFL draft picks}
}
\examples{
\donttest{
  try(cfbd_draft_picks(year = 2020))

  try(cfbd_draft_picks(year = 2016, position = "PK"))
}
}
\keyword{Draft}
\keyword{NFL}
\keyword{Picks}
