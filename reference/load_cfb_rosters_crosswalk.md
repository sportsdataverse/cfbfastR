# **Load college football roster id crosswalk from the SportsDataverse data repo**

Loads the roster-level id crosswalk linking CFBD athlete ids to ESPN
athlete ids across seasons. Single cumulative file (not season-
partitioned). Published to the `cfb_crosswalk` release tag on the
sportsdataverse-data repo.

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
#> ℹ Data updated: 2026-08-27 04:22:24 UTC
#> # A tibble: 37,740 × 14
#>    espn_team_id fox_team_id person_key       espn_athlete_id fox_athlete_id
#>           <int> <chr>       <chr>                      <int> <chr>         
#>  1         2400 231         bernatski boone          5160679 219173        
#>  2         2400 231         ahmari borden            4870620 212439        
#>  3         2400 231         josh brown               5233879 243883        
#>  4         2400 231         landon brown             5304074 243842        
#>  5         2400 231         caleb brownlow           5304085 243856        
#>  6         2400 231         diego camboia            5225242 227518        
#>  7         2400 231         miguel camboia           5168613 220503        
#>  8         2400 231         joey davis               5304086 243875        
#>  9         2400 231         tristen davis            5311016 249108        
#> 10         2400 231         d cameron demoss         5304048 243884        
#> # ℹ 37,730 more rows
#> # ℹ 9 more variables: yahoo_athlete_id <chr>, name <chr>, espn_jersey <chr>,
#> #   fox_jersey <chr>, espn_position <chr>, fox_position <chr>,
#> #   yahoo_position <chr>, match_method <chr>, matched_sources <chr>
# }
```
