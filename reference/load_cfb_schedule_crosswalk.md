# **Load college football schedule id crosswalk from the SportsDataverse data repo**

Loads the game-level id crosswalk linking CFBD game ids to ESPN event
ids – one row per game-season. Published to the `cfb_crosswalk` release
tag on the sportsdataverse-data repo.

## Usage

``` r
load_cfb_schedule_crosswalk(
  seasons = most_recent_cfb_season(),
  ...,
  dbConnection = NULL,
  tablename = NULL
)
```

## Arguments

- seasons:

  A vector of 4-digit years associated with given college football
  seasons. Published coverage runs 2014 through the most recent season.
  Pass `seasons = TRUE` for every published season. (Min: 2014)

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
| matchup_key | character | Order-independent key for the game: the two normalized team names sorted alphabetically and joined with a pipe. |
| espn_game_id | integer | ESPN game id for the crosswalk row. |
| fox_game_id | character | Fox Sports game id for the same game. |
| yahoo_game_id | character | Yahoo Sports game id for the same game. |
| yahoo_global_game_id | character | Yahoo's cross-season global game key in `ncaaf.g.NNNN` form, distinct from the date-encoded yahoo_game_id. |
| home_team | character |  |
| away_team | character |  |
| espn_date | character | Kickoff date as YYYY-MM-DD taken from ESPN's schedule, null on games that matched no ESPN row. |
| fox_date | character | Kickoff date as YYYY-MM-DD taken from the Fox Sports schedule, null on games that matched no Fox row. |
| yahoo_date | character | Kickoff date as YYYY-MM-DD, parsed from Yahoo's RFC-2822 start_time string. |
| matched_sources | character | Plus-joined provenance tag naming which of espn, fox, and yahoo actually supplied a row for this game. |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_cfb_schedule_crosswalk(2014))
#> ── college football schedule id crosswalk from the SportsDataverse data repo ───
#> ℹ Data updated: 2026-08-27 15:30:43 UTC
#> # A tibble: 1,629 × 11
#>    matchup_key       espn_game_id fox_game_id yahoo_game_id yahoo_global_game_id
#>    <chr>                    <int> <chr>       <chr>         <chr>               
#>  1 arizona wildcats…    400548018 NA          NA            NA                  
#>  2 boston college e…    400547729 NA          ncaaf.g.2014… ncaaf.g.1404427     
#>  3 nevada wolf pack…    400548184 NA          ncaaf.g.2014… ncaaf.g.1399633     
#>  4 florida state se…    400547763 NA          ncaaf.g.2014… ncaaf.g.1404521     
#>  5 alabama crimson …    400548013 NA          ncaaf.g.2014… ncaaf.g.1404270     
#>  6 michigan state s…    400547953 NA          ncaaf.g.2014… ncaaf.g.1399554     
#>  7 oklahoma sooners…    400547657 NA          ncaaf.g.2014… ncaaf.g.1404988     
#>  8 auburn tigers|sa…    400548186 NA          ncaaf.g.2014… ncaaf.g.1404293     
#>  9 ohio state bucke…    400547826 NA          ncaaf.g.2014… ncaaf.g.1404764     
#> 10 lamar cardinals|…    400548397 NA          ncaaf.g.2014… ncaaf.g.1404385     
#> # ℹ 1,619 more rows
#> # ℹ 6 more variables: home_team <chr>, away_team <chr>, espn_date <chr>,
#> #   fox_date <chr>, yahoo_date <chr>, matched_sources <chr>
# }
```
