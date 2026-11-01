# **Load college football model-enriched play-by-play from the SportsDataverse data repo**

Loads season-level model-enriched play-by-play – the modeling-grade pbp
frame with the engineered features the cfbfastR EP/WP model suite trains
on. Published to the `espn_cfb_model_pbp` release tag on the
sportsdataverse-data repo.

## Usage

``` r
load_espn_cfb_model_pbp(
  seasons = most_recent_cfb_season(),
  ...,
  dbConnection = NULL,
  tablename = NULL
)
```

## Arguments

- seasons:

  A vector of 4-digit years associated with given college football
  seasons. Published coverage runs 2004 through 2025; the current season
  has no file until it is built, so the default (the current season)
  returns an empty table with a warning. Pass `seasons = TRUE` for every
  season from 2004. (Min: 2004)

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
| game_id | integer |  |
| id | character |  |
| sequenceNumber | character |  |
| game_play_number | integer |  |
| drive.id | character | ESPN's drive identifier, formed as the game id followed by the drive's sequence number within that game. |
| season | integer |  |
| week | integer |  |
| period | integer |  |
| pos_team | integer |  |
| def_pos_team | integer |  |
| start.pos_team.name | character | School name of the team with possession at the snap, taken from ESPN's team location field so it carries no mascot. |
| homeTeamId | integer | ESPN team id of the home team, read off the game header and stamped on every play. |
| awayTeamId | integer | ESPN team id of the away team, read off the game header and stamped on every play. |
| homeTeamName | character | Home team's school name from ESPN's team location field, without the mascot. |
| awayTeamName | character | Away team's school name from ESPN's team location field, without the mascot. |
| type.text | character | ESPN's play-type label, for example Rush, Pass Reception, Sack, Punt, Penalty, or Timeout. |
| text | character |  |
| start.down | integer | Down at the snap as ESPN reports it; 0 marks the small share of rows ESPN leaves without a down, overwhelmingly timeouts and penalty administrations. |
| start.distance | integer | Yards the offense needs for a first down at the snap, carried through from ESPN without correction. |
| start.yardsToEndzone | integer | Distance in yards from the offense's spot at the snap to the opponent's end zone, ranging 0 to 100. |
| pos_score_diff_start | integer |  |
| start.TimeSecsRem | integer | Seconds remaining in the half from ESPN's clock stamp for this play – the end-of-play time in 2005 and 2007+, the snap time in 2004 and most of 2006; tops out at 1800. |
| start.is_home | logical | True when the team holding possession at the snap is the home team. |
| passing_down | logical | True on second and eight or longer, third and five or longer, or fourth and five or longer, the standard obvious-passing-situation flag. |
| pass | logical |  |
| rush | logical |  |
| completion | logical |  |
| scoring_play | logical |  |
| statYardage | integer | Yards gained on the play as ESPN reports it, negative on plays that lost yardage. |
| passer_player_name | character | Display name of the passer – the FIRST participant in that role on the play. |
| ep_before | double |  |
| ep_after | double |  |
| epa | double |  |
| wp_before | double |  |
| wp_after | double |  |
| wpa | double |  |
| completion_prob | double | Modelled probability the pass is completed. |
| cpoe | double |  |
| model_pbp_version | character | Version of the model-scored play-by-play build. |
| cp_model_version | character | Version of the completion-probability model that scored the play. |
| ep_model_version | character | Version of the expected-points model that scored the play. |
| wp_model_version | character | Version of the win-probability model that scored the play. |
| scored_date | character | Date on which the play was scored by the models. |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_espn_cfb_model_pbp(2004))
#> ── college football model-enriched play-by-play from the SportsDataverse data re
#> ℹ Data updated: 2026-11-01 20:35:46 UTC
#> # A tibble: 83,182 × 43
#>      game_id id     sequenceNumber game_play_number drive.id season  week period
#>        <int> <chr>  <chr>                     <int> <chr>     <int> <int>  <int>
#>  1 242410259 24241… 1                             1 2424102…   2004     1      1
#>  2 242410259 24241… 2                             2 2424102…   2004     1      1
#>  3 242410259 24241… 3                             3 2424102…   2004     1      1
#>  4 242410259 24241… 4                             4 2424102…   2004     1      1
#>  5 242410259 24241… 5                             5 2424102…   2004     1      1
#>  6 242410259 24241… 6                             6 2424102…   2004     1      1
#>  7 242410259 24241… 7                             7 2424102…   2004     1      1
#>  8 242410259 24241… 8                             8 2424102…   2004     1      1
#>  9 242410259 24241… 9                             9 2424102…   2004     1      1
#> 10 242410259 24241… 1                            10 2424102…   2004     1      1
#> # ℹ 83,172 more rows
#> # ℹ 35 more variables: pos_team <int>, def_pos_team <int>,
#> #   start.pos_team.name <chr>, homeTeamId <int>, awayTeamId <int>,
#> #   homeTeamName <chr>, awayTeamName <chr>, type.text <chr>, text <chr>,
#> #   start.down <int>, start.distance <int>, start.yardsToEndzone <int>,
#> #   pos_score_diff_start <int>, start.TimeSecsRem <int>, start.is_home <lgl>,
#> #   passing_down <lgl>, pass <lgl>, rush <lgl>, completion <lgl>, …
# }
```
