# **Load ESPN college football team box scores from the SportsDataverse data repo**

Loads season-level team box scores – one row per team-game with scoring,
team statistics, and opponent context. Published to the
`espn_cfb_team_box` release tag on the sportsdataverse-data repo.

## Usage

``` r
load_espn_cfb_team_box(
  seasons = most_recent_cfb_season(),
  ...,
  dbConnection = NULL,
  tablename = NULL
)
```

## Arguments

- seasons:

  A vector of 4-digit years associated with given college football
  seasons. Published coverage runs 2004 through the most recent season.
  Pass `seasons = TRUE` for every published season. (Min: 2004)

- ...:

  Additional arguments passed to an underlying function that writes the
  season data into a database.

- dbConnection:

  A `DBIConnection` object, as returned by
  [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html)

- tablename:

  The name of the data table within the database

## Value

Returns a `cfbfastR_data` tibble.

|  |  |  |
|----|----|----|
| col_name | types | description |
| firstDowns | character | Total first downs ESPN credits the team, carried verbatim from the box score as a string. |
| thirdDownEff | character | Third-down efficiency as ESPN's conversions-attempts string, for example 5-15. |
| fourthDownEff | character | Fourth-down efficiency as a conversions-attempts string, for example 3-4. |
| totalYards | character | Total offensive yards for the team, matching rushingYards plus netPassingYards in about 99.8 percent of games. |
| netPassingYards | character | Passing yards after yardage lost to sacks is deducted, the numerator behind yardsPerPass. |
| completionAttempts | character | Completions and pass attempts as a slash-separated string, for example 23/41. |
| yardsPerPass | character | Net passing yards per pass attempt, netPassingYards divided by the attempt count in completionAttempts and rounded to one decimal. |
| rushingYards | character | Net rushing yards gained. |
| rushingAttempts | character | Rushing attempts. |
| yardsPerRushAttempt | character | Yards gained per rushing attempt. |
| totalPenaltiesYards | character | Penalties and penalty yards as a hyphen-separated string, for example 7-64. |
| turnovers | character |  |
| fumblesLost | character | Number of fumbles the team lost to the opponent, carried as a string. |
| interceptions | character |  |
| possessionTime | character | Time of possession as mm:ss; the two teams' values add up to 60 minutes in a regulation game. |
| team_id | integer |  |
| team_abbreviation | character |  |
| team_name | character |  |
| home_away | character |  |
| game_id | integer |  |
| season | integer |  |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_espn_cfb_team_box(2004))
#> Warning: cannot open URL 'https://github.com/sportsdataverse/sportsdataverse-data/releases/download/espn_cfb_team_box/team_box_2004.rds': HTTP status was '404 Not Found'
#> Warning: Failed to readRDS from
#> <https://github.com/sportsdataverse/sportsdataverse-data/releases/download/espn_cfb_team_box/team_box_2004.rds>
#> ── ESPN college football team box scores from the SportsDataverse data repo ────
#> ℹ Data updated: 2026-08-27 16:44:55 UTC
#> # A tibble: 0 × 0
# }
```
