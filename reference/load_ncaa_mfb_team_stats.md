# **Load NCAA men's football team stats (stats.ncaa.org) from the SportsDataverse data repo**

Loads season-level NCAA men's football team box statistics parsed from
stats.ncaa.org; one row per team-game-category. Published to the
`ncaa_mfb_team_stats` release tag on the sportsdataverse-data repo.

## Usage

``` r
load_ncaa_mfb_team_stats(
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
| category     | character |             |
| stat         | character |             |
| period       | character |             |
| away_team    | character |             |
| away_value   | character |             |
| home_team    | character |             |
| home_value   | character |             |
| espn_game_id | character |             |
| season       | integer   |             |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_ncaa_mfb_team_stats(2013))
#> ── NCAA men's football team stats (stats.ncaa.org) from the SportsDataverse data
#> ℹ Data updated: 2026-08-27 15:31:35 UTC
#> # A tibble: 207,164 × 10
#>    contest_id category stat     period away_team away_value home_team home_value
#>    <chr>      <chr>    <chr>    <chr>  <chr>     <chr>      <chr>     <chr>     
#>  1 688871     NA       ""       total  NA        Akron      NA        UCF       
#>  2 688871     NA       "Plays"  total  NA        60         NA        66        
#>  3 688871     NA       "YDS"    total  NA        250        NA        476       
#>  4 688871     NA       "FRetLo… total  NA        0          NA        0         
#>  5 688871     NA       "IntR"   total  NA        0          NA        1         
#>  6 688871     NA       "IntYds" total  NA        0          NA        6         
#>  7 688871     NA       "Saf"    total  NA        0          NA        0         
#>  8 688871     NA       "QBH"    total  NA        4          NA        3         
#>  9 688871     NA       "SackUA" total  NA        0          NA        0         
#> 10 688871     NA       "Rush 2… total  NA        0          NA        0         
#> # ℹ 207,154 more rows
#> # ℹ 2 more variables: espn_game_id <chr>, season <int>
# }
```
