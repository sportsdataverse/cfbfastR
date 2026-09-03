# **Load ESPN college football schedules from the SportsDataverse data repo**

Loads season-level college football schedules built from the ESPN events
API by the cfbfastR-cfb-data pipeline. One row per game with
date/venue/broadcast metadata, team ids and names, scores, and status
fields. Published to the `espn_cfb_schedules` release tag on the
sportsdataverse-data repo.

## Usage

``` r
load_espn_cfb_schedules(
  seasons = most_recent_cfb_season(),
  ...,
  dbConnection = NULL,
  tablename = NULL
)
```

## Arguments

- seasons:

  A vector of 4-digit years associated with given college football
  seasons. Published coverage runs 2004 through the most recent season.
  Pass `seasons = TRUE` for every published season. (Min: 2004)

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

|                        |           |             |
|------------------------|-----------|-------------|
| col_name               | types     | description |
| game_id                | integer   |             |
| season                 | integer   |             |
| week                   | integer   |             |
| season_type            | integer   |             |
| game_date              | character |             |
| neutral_site           | logical   |             |
| conference_competition | logical   |             |
| home_id                | integer   |             |
| away_id                | integer   |             |
| home_team              | character |             |
| away_team              | character |             |
| home_abbreviation      | character |             |
| away_abbreviation      | character |             |
| home_score             | character |             |
| away_score             | character |             |
| home_winner            | logical   |             |
| away_winner            | logical   |             |
| venue                  | character |             |
| attendance             | character |             |
| status                 | character |             |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_espn_cfb_schedules(2004))
#> ── ESPN college football schedules from the SportsDataverse data repo ──────────
#> ℹ Data updated: 2026-09-03 22:41:34 UTC
#> # A tibble: 712 × 20
#>      game_id season  week season_type game_date         neutral_site
#>        <int>  <int> <int>       <int> <chr>             <lgl>       
#>  1 242410259   2004     1           2 2004-08-28T23:40Z FALSE       
#>  2 242410193   2004     1           2 2004-08-28T23:00Z FALSE       
#>  3 242460254   2004     2           2 2004-09-02T23:30Z FALSE       
#>  4 242462199   2004     2           2 2004-09-02T23:00Z FALSE       
#>  5 242462050   2004     2           2 2004-09-03T00:00Z FALSE       
#>  6 242462711   2004     2           2 2004-09-03T00:00Z FALSE       
#>  7 242462628   2004     2           2 2004-09-03T01:30Z FALSE       
#>  8 242460009   2004     2           2 2004-09-03T02:00Z FALSE       
#>  9 242470167   2004     2           2 2004-09-04T00:00Z FALSE       
#> 10 242480201   2004     2           2 2004-09-04T16:00Z FALSE       
#> # ℹ 702 more rows
#> # ℹ 14 more variables: conference_competition <lgl>, home_id <int>,
#> #   away_id <int>, home_team <chr>, away_team <chr>, home_abbreviation <chr>,
#> #   away_abbreviation <chr>, home_score <int>, away_score <int>,
#> #   home_winner <lgl>, away_winner <lgl>, venue <chr>, attendance <int>,
#> #   status <chr>
# }
```
