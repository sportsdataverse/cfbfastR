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
#> ℹ Data updated: 2026-10-18 11:40:57 UTC
#> # A tibble: 45,533 × 14
#>    espn_team_id fox_team_id person_key          espn_athlete_id fox_athlete_id
#>           <int> <chr>       <chr>                         <int> <chr>         
#>  1         2834 575         christen barnwell           5297312 243759        
#>  2         2834 575         elton caldwell              5297316 243764        
#>  3         2834 575         kye callicoatte             5297317 243771        
#>  4         2834 575         diego coleman               5297308 243781        
#>  5         2834 575         landen drake                5297285 243761        
#>  6         2834 575         omarion dumas               5297319 243784        
#>  7         2834 575         malik francis               5297320 243749        
#>  8         2834 575         gunner hammond              5297284 243755        
#>  9         2834 575         kendrick jefferson          5297280 243753        
#> 10         2834 575         marcus jefferson jr         5297302 243776        
#> # ℹ 45,523 more rows
#> # ℹ 9 more variables: yahoo_athlete_id <chr>, name <chr>, espn_jersey <chr>,
#> #   fox_jersey <chr>, espn_position <chr>, fox_position <chr>,
#> #   yahoo_position <chr>, match_method <chr>, matched_sources <chr>
# }
```
