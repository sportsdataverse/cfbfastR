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
#> ℹ Data updated: 2026-10-30 00:16:33 UTC
#> # A tibble: 45,534 × 14
#>    espn_team_id fox_team_id person_key       espn_athlete_id fox_athlete_id
#>           <int> <chr>       <chr>                      <int> <chr>         
#>  1         2403 286         anthony aiono            2555921 NA            
#>  2         2403 286         deontay campbell         5278395 NA            
#>  3         2403 286         scott clipp              2555922 NA            
#>  4         2403 286         dusty bratzler           2555923 NA            
#>  5         2403 286         michael thompson              NA 157828        
#>  6         2148 340         vladimir adamcy          5440279 259716        
#>  7         2148 340         khafre ashenafi          5440236 NA            
#>  8         2148 340         marley ashley            5428399 259773        
#>  9         2148 340         donovan barber           5440233 NA            
#> 10         2148 340         riley bell               5440284 NA            
#> # ℹ 45,524 more rows
#> # ℹ 9 more variables: yahoo_athlete_id <chr>, name <chr>, espn_jersey <chr>,
#> #   fox_jersey <chr>, espn_position <chr>, fox_position <chr>,
#> #   yahoo_position <chr>, match_method <chr>, matched_sources <chr>
# }
```
