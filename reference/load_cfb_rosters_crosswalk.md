# **Load college football roster id crosswalk from the SportsDataverse data repo**

Loads the roster-level id crosswalk linking ESPN, Fox Sports, and Yahoo
Sports athlete ids. A single snapshot of current rosters, not a
per-season series: the providers' roster endpoints only expose the
current roster. It carries no CFBD athlete id. Published to the
`cfb_crosswalk` release tag on the sportsdataverse-data repo.

## Usage

``` r
load_cfb_rosters_crosswalk(..., dbConnection = NULL, tablename = NULL)
```

## Arguments

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

|                  |           |             |
|------------------|-----------|-------------|
| col_name         | types     | description |
| espn_team_id     | integer   |             |
| fox_team_id      | character |             |
| person_key       | character |             |
| espn_athlete_id  | integer   |             |
| fox_athlete_id   | character |             |
| yahoo_athlete_id | character |             |
| name             | character |             |
| espn_jersey      | character |             |
| fox_jersey       | character |             |
| espn_position    | character |             |
| fox_position     | character |             |
| yahoo_position   | character |             |
| match_method     | character |             |
| matched_sources  | character |             |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_cfb_rosters_crosswalk())
#> ── college football roster id crosswalk from the SportsDataverse data repo ─────
#> ℹ Data updated: 2026-11-01 11:21:23 UTC
#> # A tibble: 45,540 × 14
#>    espn_team_id fox_team_id person_key       espn_athlete_id fox_athlete_id
#>           <int> <chr>       <chr>                      <int> <chr>         
#>  1          153 6           cristian alvarez         5291781 256819        
#>  2          153 6           aidan banfield           5079308 221059        
#>  3          153 6           trey blue                5172032 233535        
#>  4          153 6           eidan buchanan           5156381 238426        
#>  5          153 6           travis burgess           5199937 249557        
#>  6          153 6           rowan byrne              5141401 233555        
#>  7          153 6           keeyun chapman           5212608 256814        
#>  8          153 6           will conroy              5209394 249542        
#>  9          153 6           crew davis               5265173 249551        
#> 10          153 6           dujuan davis             5161953 256815        
#> # ℹ 45,530 more rows
#> # ℹ 9 more variables: yahoo_athlete_id <chr>, name <chr>, espn_jersey <chr>,
#> #   fox_jersey <chr>, espn_position <chr>, fox_position <chr>,
#> #   yahoo_position <chr>, match_method <chr>, matched_sources <chr>
# }
```
