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
#> ℹ Data updated: 2026-11-26 22:49:17 UTC
#> # A tibble: 47,829 × 14
#>    espn_team_id fox_team_id person_key        espn_athlete_id fox_athlete_id
#>           <int> <chr>       <chr>                       <int> <chr>         
#>  1         2247 740         aidan andrews             5217870 240700        
#>  2         2247 740         tayo ashadele             5295774 240720        
#>  3         2247 740         derrick avery jr          5216495 240374        
#>  4         2247 740         kadorian benjamin         5291708 251051        
#>  5         2247 740         jamal bing jr             5155355 219130        
#>  6         2247 740         hunter britt              5295789 240702        
#>  7         2247 740         cameran brown             5193926 223638        
#>  8         2247 740         jordan brown              4879662 193088        
#>  9         2247 740         matt buron                5086204 197728        
#> 10         2247 740         xavier butler             5292031 251042        
#> # ℹ 47,819 more rows
#> # ℹ 9 more variables: yahoo_athlete_id <chr>, name <chr>, espn_jersey <chr>,
#> #   fox_jersey <chr>, espn_position <chr>, fox_position <chr>,
#> #   yahoo_position <chr>, match_method <chr>, matched_sources <chr>
# }
```
