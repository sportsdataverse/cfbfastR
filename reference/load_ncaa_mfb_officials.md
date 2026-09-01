# **Load NCAA men's football officials (stats.ncaa.org) from the SportsDataverse data repo**

Loads season-level NCAA men's football game officials parsed from
stats.ncaa.org; one row per game-official. Published to the
`ncaa_mfb_officials` release tag on the sportsdataverse-data repo.

## Usage

``` r
load_ncaa_mfb_officials(
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

|              |           |             |
|--------------|-----------|-------------|
| col_name     | types     | description |
| contest_id   | character |             |
| role         | character |             |
| official     | character |             |
| espn_game_id | character |             |
| season       | integer   |             |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_ncaa_mfb_officials(2013))
#> ── NCAA men's football officials (stats.ncaa.org) from the SportsDataverse data 
#> ℹ Data updated: 2026-09-01 11:29:15 UTC
#> # A tibble: 11,334 × 5
#>    contest_id role  official        espn_game_id season
#>    <chr>      <chr> <chr>           <chr>         <int>
#>  1 688871     sj    George Plesac   332412116      2013
#>  2 688871     ump   Bob Holcomb     332412116      2013
#>  3 688871     line  John Wiercinski 332412116      2013
#>  4 688871     fj    DominiquePender 332412116      2013
#>  5 688871     ref   Tony Cannella   332412116      2013
#>  6 688871     lj    GaryJagodzinski 332412116      2013
#>  7 688871     bj    Todd Boyd       332412116      2013
#>  8 688872     sj    Lo Van Pham     332410023      2013
#>  9 688872     ump   Tim Martin      332410023      2013
#> 10 688872     line  Andy Warner     332410023      2013
#> # ℹ 11,324 more rows
# }
```
