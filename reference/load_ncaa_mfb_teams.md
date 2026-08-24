# **Load NCAA men's football teams (stats.ncaa.org) from the SportsDataverse data repo**

Loads season-level NCAA men's football team directories from
stats.ncaa.org, with division/conference alignment; one row per team-
season. Published to the `ncaa_mfb_teams` release tag on the
sportsdataverse-data repo.

## Usage

``` r
load_ncaa_mfb_teams(
  seasons = most_recent_cfb_season(),
  ...,
  dbConnection = NULL,
  tablename = NULL
)
```

## Arguments

- seasons:

  A vector of 4-digit years associated with given college football
  seasons. Published coverage runs 2013 through the most recent season.
  Pass `seasons = TRUE` for every published season. (Min: 2013)

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

|               |           |             |
|---------------|-----------|-------------|
| col_name      | types     | description |
| team_id       | character |             |
| team_name     | character |             |
| academic_year | integer   |             |
| division      | integer   |             |
| season        | integer   |             |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_ncaa_mfb_teams(2013))
#> ── NCAA men's football teams (stats.ncaa.org) from the SportsDataverse data repo
#> ℹ Data updated: 2026-08-24 12:13:55 UTC
#> # A tibble: 252 × 5
#>    team_id team_name       academic_year division season
#>    <chr>   <chr>                   <int>    <int>  <int>
#>  1 62793   Air Force                2014       11   2013
#>  2 62681   Akron                    2014       11   2013
#>  3 62682   Alabama                  2014       11   2013
#>  4 62684   App State                2014       11   2013
#>  5 62686   Arizona                  2014       11   2013
#>  6 62685   Arizona St.              2014       11   2013
#>  7 62688   Arkansas                 2014       11   2013
#>  8 62687   Arkansas St.             2014       11   2013
#>  9 62794   Army West Point          2014       11   2013
#> 10 62689   Auburn                   2014       11   2013
#> # ℹ 242 more rows
# }
```
