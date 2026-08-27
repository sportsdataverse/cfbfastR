# **Load ESPN college football schedules from the SportsDataverse data repo**

Loads season-level college football schedules built from the ESPN events
API by the cfbfastR-cfb-data pipeline. One row per game with
date/venue/broadcast metadata, team ids and names, scores, and status
fields. Published to the `espn_cfb_schedules` release tag on the
sportsdataverse-data repo.

## Usage

``` r
load_espn_cfb_schedules(
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

|                        |           |             |
|------------------------|-----------|-------------|
| col_name               | types     | description |
| game_id                | integer   |             |
| season                 | integer   |             |
| week                   | integer   |             |
| season_type            | integer   |             |
| game_date              | character |             |
| neutral_site           | logical   |             |
| conference_competition | logical   |             |
| home_id                | integer   |             |
| away_id                | integer   |             |
| home_team              | character |             |
| away_team              | character |             |
| home_abbreviation      | character |             |
| away_abbreviation      | character |             |
| home_score             | character |             |
| away_score             | character |             |
| home_winner            | logical   |             |
| away_winner            | logical   |             |
| venue                  | character |             |
| attendance             | character |             |
| status                 | character |             |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_espn_cfb_schedules(2004))
#> Warning: cannot open URL 'https://github.com/sportsdataverse/sportsdataverse-data/releases/download/espn_cfb_schedules/cfb_schedule_2004.rds': HTTP status was '404 Not Found'
#> Warning: Failed to readRDS from
#> <https://github.com/sportsdataverse/sportsdataverse-data/releases/download/espn_cfb_schedules/cfb_schedule_2004.rds>
#> ── ESPN college football schedules from the SportsDataverse data repo ──────────
#> ℹ Data updated: 2026-08-27 11:02:19 UTC
#> # A tibble: 0 × 0
# }
```
