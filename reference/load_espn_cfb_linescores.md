# **Load ESPN college football linescores from the SportsDataverse data repo**

Loads season-level period linescores – one row per team-period with
points scored. Published to the `espn_cfb_linescores` release tag on the
sportsdataverse-data repo.

## Usage

``` r
load_espn_cfb_linescores(
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

|          |           |             |
|----------|-----------|-------------|
| col_name | types     | description |
| team_id  | integer   |             |
| period   | integer   |             |
| value    | character |             |
| game_id  | integer   |             |
| season   | integer   |             |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_espn_cfb_linescores(2004))
#> ── ESPN college football linescores from the SportsDataverse data repo ─────────
#> ℹ Data updated: 2026-08-27 15:31:04 UTC
#> # A tibble: 5,720 × 5
#>    team_id period value   game_id season
#>      <int>  <int> <chr>     <int>  <int>
#>  1     259      1 3     242410259   2004
#>  2     259      2 7     242410259   2004
#>  3     259      3 0     242410259   2004
#>  4     259      4 3     242410259   2004
#>  5      30      1 7     242410259   2004
#>  6      30      2 0     242410259   2004
#>  7      30      3 7     242410259   2004
#>  8      30      4 10    242410259   2004
#>  9     193      1 14    242410193   2004
#> 10     193      2 28    242410193   2004
#> # ℹ 5,710 more rows
# }
```
