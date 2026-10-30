# **Load college football schedule id crosswalk from the SportsDataverse data repo**

Loads the game-level id crosswalk linking ESPN, Fox Sports, and Yahoo
Sports game ids – one row per game in each season's file. The files
carry no `season` column and no CFBD game id. Published to the
`cfb_crosswalk` release tag on the sportsdataverse-data repo.

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
#> ℹ Data updated: 2026-10-30 00:16:34 UTC
#> # A tibble: 1,633 × 11
#>    matchup_key       espn_game_id fox_game_id yahoo_game_id yahoo_global_game_id
#>    <chr>                    <int> <chr>       <chr>         <chr>               
#>  1 abilene christia…    400548403 NA          ncaaf.g.2014… ncaaf.g.1414806     
#>  2 south carolina g…    400548402 NA          ncaaf.g.2014… ncaaf.g.1404372     
#>  3 boise state bron…    400548169 NA          ncaaf.g.2014… ncaaf.g.1404343     
#>  4 arizona state su…    400548255 NA          ncaaf.g.2014… ncaaf.g.1399532     
#>  5 louisiana monroe…    400547829 NA          ncaaf.g.2014… ncaaf.g.1404770     
#>  6 eastern illinois…    400547960 NA          ncaaf.g.2014… ncaaf.g.1405237     
#>  7 akron zips|howar…    400548090 NA          ncaaf.g.2014… ncaaf.g.1405278     
#>  8 northern illinoi…    400548091 NA          NA            NA                  
#>  9 central michigan…    400548092 NA          ncaaf.g.2014… ncaaf.g.1414717     
#> 10 idaho state beng…    400548256 NA          ncaaf.g.2014… ncaaf.g.1399594     
#> # ℹ 1,623 more rows
#> # ℹ 6 more variables: home_team <chr>, away_team <chr>, espn_date <chr>,
#> #   fox_date <chr>, yahoo_date <chr>, matched_sources <chr>
# }
```
