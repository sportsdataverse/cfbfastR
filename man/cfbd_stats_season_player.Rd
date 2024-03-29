% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cfbd_stats.R
\name{cfbd_stats_season_player}
\alias{cfbd_stats_season_player}
\title{\strong{Get season statistics by player}}
\usage{
cfbd_stats_season_player(
  year,
  season_type = "regular",
  team = NULL,
  conference = NULL,
  start_week = NULL,
  end_week = NULL,
  category = NULL
)
}
\arguments{
\item{year}{(\emph{Integer} required): Year, 4 digit format (\emph{YYYY})}

\item{season_type}{(\emph{String} default: regular): Select Season Type - regular, postseason, or both}

\item{team}{(\emph{String} optional): D-I Team}

\item{conference}{(\emph{String} optional): Conference abbreviation - Select a valid FBS conference
Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC}

\item{start_week}{(\emph{Integer} optional): Starting Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier}

\item{end_week}{(\emph{Integer} optional): Ending Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier}

\item{category}{(\emph{String} optional): Category filter (e.g defensive)
Offense: passing, receiving, rushing
Defense: defensive, fumbles, interceptions
Special Teams: punting, puntReturns, kicking, kickReturns}
}
\value{
\code{\link[=cfbd_stats_season_player]{cfbd_stats_season_player()}} - A data frame with 59 variables:
\describe{
\item{\code{team}: character.}{Team name.}
\item{\code{conference}: character.}{Conference of the team.}
\item{\code{athlete_id}: character.}{Athlete referencing id.}
\item{\code{player}: character.}{Player name.}
\item{\code{category}: character.}{Statistic category.}
\item{\code{passing_completions}: double.}{Passing completions.}
\item{\code{passing_att}: double.}{Passing attempts.}
\item{\code{passing_pct}: double.}{Passing completion percentage.}
\item{\code{passing_yds}: double.}{Passing yardage.}
\item{\code{passing_td}: double.}{Passing touchdowns.}
\item{\code{passing_int}: double.}{Passing interceptions.}
\item{\code{passing_ypa}: double.}{Passing yards per attempt.}
\item{\code{rushing_car}: double.}{Rushing yards per carry.}
\item{\code{rushing_yds}: double.}{Rushing yards total.}
\item{\code{rushing_td}: double.}{Rushing touchdowns.}
\item{\code{rushing_ypc}: double.}{Rushing yards per carry.}
\item{\code{rushing_long}: double.}{Rushing longest yardage attempt.}
\item{\code{receiving_rec}: double.}{Receiving - pass receptions.}
\item{\code{receiving_yds}: double.}{Receiving - pass reception yards.}
\item{\code{receiving_td}: double.}{Receiving - passing reception touchdowns.}
\item{\code{receiving_ypr}: double.}{Receiving - passing yards per reception.}
\item{\code{receiving_long}: double.}{Receiving - longest pass reception yardage.}
\item{\code{fumbles_fum}: double.}{Fumbles.}
\item{\code{fumbles_rec}: double.}{Fumbles recovered.}
\item{\code{fumbles_lost}: double.}{Fumbles lost.}
\item{\code{defensive_solo}: double.}{Defensive solo tackles.}
\item{\code{defensive_tot}: double.}{Defensive total tackles.}
\item{\code{defensive_tfl}: double.}{Defensive tackles for loss.}
\item{\code{defensive_sacks}: double.}{Defensive sacks.}
\item{\code{defensive_qb_hur}: double.}{Defensive quarterback hurries.}
\item{\code{interceptions_int}: double.}{Interceptions total.}
\item{\code{interceptions_yds}: double.}{Interception return yards.}
\item{\code{interceptions_avg}: double.}{Interception return yards average.}
\item{\code{interceptions_td}: double.}{Interception return touchdowns.}
\item{\code{defensive_pd}: double.}{Defense - passes defensed.}
\item{\code{defensive_td}: double.}{Defense - defensive touchdowns.}
\item{\code{kicking_fgm}: double.}{Kicking - field goals made.}
\item{\code{kicking_fga}: double.}{Kicking - field goals attempted.}
\item{\code{kicking_pct}: double.}{Kicking - field goal percentage.}
\item{\code{kicking_xpa}: double.}{Kicking - extra points attempted.}
\item{\code{kicking_xpm}: double.}{Kicking - extra points made.}
\item{\code{kicking_pts}: double.}{Kicking - total points.}
\item{\code{kicking_long}: double.}{Kicking - longest successful field goal attempt.}
\item{\code{kick_returns_no}: double.}{Kick Returns - number of kick returns.}
\item{\code{kick_returns_yds}: double.}{Kick Returns - kick return yards.}
\item{\code{kick_returns_avg}: double.}{Kick Returns - kick return average yards per return.}
\item{\code{kick_returns_td}: double.}{Kick Returns - kick return touchdowns.}
\item{\code{kick_returns_long}: double.}{Kick Returns - longest kick return yardage.}
\item{\code{punting_no}: double.}{Punting - number of punts.}
\item{\code{punting_yds}: double.}{Punting - punting yardage.}
\item{\code{punting_ypp}: double.}{Punting - yards per punt.}
\item{\code{punting_long}: double.}{Punting - longest punt yardage.}
\item{\code{punting_in_20}: double.}{Punting - punt downed inside the 20 yard line.}
\item{\code{punting_tb}: double.}{Punting - punt caused a touchback.}
\item{\code{punt_returns_no}: double.}{Punt Returns - number of punt returns.}
\item{\code{punt_returns_yds}: double.}{Punt Returns - punt return yardage total.}
\item{\code{punt_returns_avg}: double.}{Punt Returns - punt return average yards per return.}
\item{\code{punt_returns_td}: double.}{Punt Returns - punt return touchdowns.}
\item{\code{punt_returns_long}: double.}{Punt Returns - longest punt return yardage.}
}
}
\description{
\strong{Get season statistics by player}
}
\examples{
\donttest{
   try(cfbd_stats_season_player(year = 2018, conference = "B12", start_week = 1, end_week = 7))

   try(cfbd_stats_season_player(2019, team = "LSU", category = "passing"))

   try(cfbd_stats_season_player(2013, team = "Florida State", category = "passing"))
}
}
\keyword{Player}
\keyword{Season}
\keyword{Stats}
