# **Load ESPN college football betting lines from the SportsDataverse data repo**

Loads season-level betting lines – long format, one row per book per
selection per market type (spread, moneyline, total), with open/close
prices. Published to the `espn_cfb_betting` release tag on the
sportsdataverse-data repo.

## Usage

``` r
load_espn_cfb_betting(
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

|                       |           |             |
|-----------------------|-----------|-------------|
| col_name              | types     | description |
| game_id               | integer   |             |
| season                | integer   |             |
| week                  | integer   |             |
| game_spread           | double    |             |
| over_under            | double    |             |
| home_favorite         | logical   |             |
| home_team_spread      | double    |             |
| game_spread_available | logical   |             |
| odds_source           | character |             |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_espn_cfb_betting(2004))
#> Warning: cannot open URL 'https://github.com/sportsdataverse/sportsdataverse-data/releases/download/espn_cfb_betting/betting_2004.rds': HTTP status was '404 Not Found'
#> Warning: Failed to readRDS from
#> <https://github.com/sportsdataverse/sportsdataverse-data/releases/download/espn_cfb_betting/betting_2004.rds>
#> ── ESPN college football betting lines from the SportsDataverse data repo ──────
#> ℹ Data updated: 2026-08-27 16:44:38 UTC
#> # A tibble: 0 × 0
# }
```
