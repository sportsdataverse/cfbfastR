% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cfbd_games.R
\name{cfbd_games}
\alias{cfbd_games}
\title{\strong{CFBD Games Endpoint Overview}}
\description{
Get results, statistics and information for games
\describe{
\item{\code{cfbd_game_box_advanced()}:}{ Get game advanced box score information.}
\item{\code{cfbd_game_player_stats()}:}{ Get results information from games.}
\item{\code{cfbd_game_team_stats()}:}{ Get team statistics by game.}
\item{\code{cfbd_game_info()}:}{ Get results information from games.}
\item{\code{cfbd_game_weather()}:}{ Get weather from games.}
\item{\code{cfbd_game_records()}:}{ Get team records by year.}
\item{\code{cfbd_calendar()}:}{ Get calendar of weeks by season.}
\item{\code{cfbd_game_media()}:}{ Get game media information (TV, radio, etc).}
}
}
\details{
\subsection{\strong{Get game advanced box score information.}}{

\if{html}{\out{<div class="sourceCode r">}}\preformatted{cfbd_game_box_advanced(game_id = 401114233)
}\if{html}{\out{</div>}}
}

\subsection{\strong{Get player statistics by game}}{

\if{html}{\out{<div class="sourceCode r">}}\preformatted{cfbd_game_player_stats(2018, week = 15, conference = "Ind")

cfbd_game_player_stats(2013, week = 1, team = "Florida State", category = "passing")
}\if{html}{\out{</div>}}
}

\subsection{\strong{Get team records by year}}{

\if{html}{\out{<div class="sourceCode r">}}\preformatted{cfbd_game_records(2018, team = "Notre Dame")

cfbd_game_records(2013, team = "Florida State")
}\if{html}{\out{</div>}}
}

\subsection{\strong{Get team statistics by game}}{

\if{html}{\out{<div class="sourceCode r">}}\preformatted{cfbd_game_team_stats(2019, team = "LSU")

cfbd_game_team_stats(2013, team = "Florida State")
}\if{html}{\out{</div>}}
}

\subsection{\strong{Get results information from games.}}{

\if{html}{\out{<div class="sourceCode r">}}\preformatted{cfbd_game_info(2018, week = 1)

cfbd_game_info(2018, week = 7, conference = "Ind")

# 7 OTs LSU @ TAMU
cfbd_game_info(2018, week = 13, team = "Texas A&M", quarter_scores = TRUE)
}\if{html}{\out{</div>}}

\if{html}{\out{<div class="sourceCode">}}\preformatted{### **Get weather from games.**
```r
cfbd_game_weather(2018, week = 1)

cfbd_game_info(2018, week = 7, conference = "Ind")
}\if{html}{\out{</div>}}
}

\subsection{\strong{Get calendar of weeks by season.}}{

\if{html}{\out{<div class="sourceCode r">}}\preformatted{cfbd_calendar(2019)
}\if{html}{\out{</div>}}
}

\subsection{\strong{Get game media information (TV, radio, etc).}}{

\if{html}{\out{<div class="sourceCode r">}}\preformatted{cfbd_game_media(2019, week = 4, conference = "ACC")
}\if{html}{\out{</div>}}
}
}
