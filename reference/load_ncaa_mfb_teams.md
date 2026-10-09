# **Load NCAA men's football teams (stats.ncaa.org) from the SportsDataverse data repo**

Loads the stats.ncaa.org men's football team list for each season: one
row per team-season with the stats.ncaa.org team id, the team name, and
the NCAA division (FBS or FCS). The table has no conference column; for
conference membership by season use
[`load_cfb_team_group_seasons()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_team_group_seasons.md).
Published to the `ncaa_mfb_teams` release tag on the
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

|  |  |  |
|----|----|----|
| col_name | types | description |
| team_id | character | stats.ncaa.org team id. It is issued per season, so a school's id changes from year to year. |
| team_name | character | School name as stats.ncaa.org lists it, without the mascot. |
| academic_year | integer | Academic year the record covers, the ENDING year (`season + 1`). |
| division | integer | stats.ncaa.org division code: `11` = FBS, `12` = FCS. |
| season | integer | Season (fall year; 2025 = fall 2025). |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_ncaa_mfb_teams(2013))
#> ── NCAA men's football teams (stats.ncaa.org) from the SportsDataverse data repo
#> ℹ Data updated: 2026-10-09 03:22:08 UTC
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
