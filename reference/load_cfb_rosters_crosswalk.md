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
#> ℹ Data updated: 2026-11-02 06:19:46 UTC
#> # A tibble: 45,543 × 14
#>    espn_team_id fox_team_id person_key         espn_athlete_id fox_athlete_id
#>           <int> <chr>       <chr>                        <int> <chr>         
#>  1         2676 246         corie addo                 5087283 231455        
#>  2         2676 246         curtis allen               5232350 NA            
#>  3         2676 246         roberto alverez jr         5232342 231419        
#>  4         2676 246         mykey anderson             4586377 231404        
#>  5         2676 246         devonte boyd               5232400 200091        
#>  6         2676 246         isaiah butcher             5232399 231454        
#>  7         2676 246         jada byers                 5232345 200127        
#>  8         2676 246         trai von callis            5232404 231423        
#>  9         2676 246         kalen carver               4885317 200092        
#> 10         2676 246         juelz cooper               5232408 231461        
#> # ℹ 45,533 more rows
#> # ℹ 9 more variables: yahoo_athlete_id <chr>, name <chr>, espn_jersey <chr>,
#> #   fox_jersey <chr>, espn_position <chr>, fox_position <chr>,
#> #   yahoo_position <chr>, match_method <chr>, matched_sources <chr>
# }
```
