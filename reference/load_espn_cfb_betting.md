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
#> ── ESPN college football betting lines from the SportsDataverse data repo ──────
#> ℹ Data updated: 2026-09-01 11:28:51 UTC
#> # A tibble: 712 × 9
#>      game_id season  week game_spread over_under home_favorite home_team_spread
#>        <int>  <int> <int>       <dbl>      <dbl> <lgl>                    <dbl>
#>  1 242410259   2004     1         2.5       55.5 TRUE                      -2.5
#>  2 242410193   2004     1         2.5       55.5 TRUE                      -2.5
#>  3 242460254   2004     2         2.5       55.5 TRUE                      -2.5
#>  4 242462199   2004     2         2.5       55.5 TRUE                      -2.5
#>  5 242462050   2004     2         2.5       55.5 TRUE                      -2.5
#>  6 242462711   2004     2         2.5       55.5 TRUE                      -2.5
#>  7 242462628   2004     2         2.5       55.5 TRUE                      -2.5
#>  8 242460009   2004     2         2.5       55.5 TRUE                      -2.5
#>  9 242470167   2004     2         2.5       55.5 TRUE                      -2.5
#> 10 242480201   2004     2         2.5       55.5 TRUE                      -2.5
#> # ℹ 702 more rows
#> # ℹ 2 more variables: game_spread_available <lgl>, odds_source <chr>
# }
```
