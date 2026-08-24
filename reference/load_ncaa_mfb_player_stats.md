# **Load NCAA men's football player stats (stats.ncaa.org) from the SportsDataverse data repo**

Loads season-level NCAA men's football player box statistics parsed from
stats.ncaa.org; one row per player-game-category. Published to the
`ncaa_mfb_player_stats` release tag on the sportsdataverse-data repo.

## Usage

``` r
load_ncaa_mfb_player_stats(
  seasons = most_recent_cfb_season(),
  ...,
  dbConnection = NULL,
  tablename = NULL
)
```

## Arguments

- seasons:

  A vector of 4-digit years associated with given college football
  seasons. Published coverage runs 2013 through the most recent season.
  Pass `seasons = TRUE` for every published season. (Min: 2013)

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

|                     |           |             |
|---------------------|-----------|-------------|
| col_name            | types     | description |
| contest_id          | character |             |
| team_id             | character |             |
| number              | character |             |
| name                | character |             |
| position            | character |             |
| rush_attempts       | character |             |
| rush_yds_gained     | character |             |
| rush_yds_lost       | character |             |
| yds_rush            | character |             |
| rush_tds            | character |             |
| rush_long           | character |             |
| category            | character |             |
| espn_game_id        | character |             |
| pass_attempts       | character |             |
| completions         | character |             |
| pass_yards          | character |             |
| interceptions       | character |             |
| pass_tds            | character |             |
| pass_eff            | character |             |
| yds_per_completion  | character |             |
| pct                 | character |             |
| long_pass           | character |             |
| rec                 | character |             |
| receiving_yards     | character |             |
| yards_per_reception | character |             |
| rec_td              | character |             |
| long_rec            | character |             |
| yds                 | character |             |
| plays               | character |             |
| pbu                 | character |             |
| int                 | character |             |
| intyds              | character |             |
| int_ret_tds         | character |             |
| pdef                | character |             |
| ko_ret              | character |             |
| ko_ret_yds          | character |             |
| kick_ret_tds        | character |             |
| long_kor            | character |             |
| sacks               | character |             |
| solo_tack           | character |             |
| asst_tack           | character |             |
| tackles             | character |             |
| fgm                 | character |             |
| fga                 | character |             |
| fg_blocks_allowed   | character |             |
| punt_ret            | character |             |
| punt_ret_yds        | character |             |
| punt_ret_tds        | character |             |
| long_pr             | character |             |
| season              | integer   |             |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_ncaa_mfb_player_stats(2013))
#> ── NCAA men's football player stats (stats.ncaa.org) from the SportsDataverse da
#> ℹ Data updated: 2026-08-24 12:13:51 UTC
#> # A tibble: 53,479 × 8
#>    contest_id team_id number name          position category espn_game_id season
#>    <chr>      <chr>   <chr>  <chr>         <chr>    <chr>    <chr>         <int>
#>  1 688871     1326323 7      Jawon Chisho… RB       other    332412116      2013
#>  2 688871     1326323 11     Zach D'Orazio YWR      other    332412116      2013
#>  3 688871     1326323 15     Nick Hirschm… QB       other    332412116      2013
#>  4 688871     1326323 34     Conor Hundley RB       other    332412116      2013
#>  5 688871     1326323 25     Denzel Jones  RB       other    332412116      2013
#>  6 688871     1326323 16     Kyle Pohl     QB       other    332412116      2013
#>  7 688871     1326323 NA     Akron         NA       other    332412116      2013
#>  8 688871     1326324 5      Blake Bortles QB       other    332412116      2013
#>  9 688871     1326324 3      Tyler Gabbert QB       other    332412116      2013
#> 10 688871     1326324 6      Rannell Hall  WR       other    332412116      2013
#> # ℹ 53,469 more rows
# }
```
