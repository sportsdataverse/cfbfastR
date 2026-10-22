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
#> ℹ Data updated: 2026-10-22 17:19:42 UTC
#> # A tibble: 45,533 × 14
#>    espn_team_id fox_team_id person_key       espn_athlete_id fox_athlete_id
#>           <int> <chr>       <chr>                      <int> <chr>         
#>  1         2117 72          jaden allen              4876695 191173        
#>  2         2117 72          zander barth             5316895 250038        
#>  3         2117 72          marcus beamon            5295480 233756        
#>  4         2117 72          vaughn blue              5122147 210405        
#>  5         2117 72          jacob booth              5120452 210574        
#>  6         2117 72          jayden clerveaux         5157391 213011        
#>  7         2117 72          nic disanto              5153454 218497        
#>  8         2117 72          da shon febres           5327593 250048        
#>  9         2117 72          angel flores             5084769 198457        
#> 10         2117 72          shawn foster ii          5221139 231524        
#> # ℹ 45,523 more rows
#> # ℹ 9 more variables: yahoo_athlete_id <chr>, name <chr>, espn_jersey <chr>,
#> #   fox_jersey <chr>, espn_position <chr>, fox_position <chr>,
#> #   yahoo_position <chr>, match_method <chr>, matched_sources <chr>
# }
```
