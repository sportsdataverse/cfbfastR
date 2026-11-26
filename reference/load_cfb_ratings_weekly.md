# **Load college football weekly power ratings from the SportsDataverse data repo**

Loads weekly team power ratings – one row per team-week, the as-of- week
snapshots behind the season-end ratings. Published to the
`cfb_ratings_weekly` release tag on the sportsdataverse-data repo.

## Usage

``` r
load_cfb_ratings_weekly(
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

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer |  |
| team_id | integer |  |
| adj_off_epa | double | Opponent-adjusted offensive EPA per play as of the snapshot week: raw per-game EPA on pass and rush plays net of each opponent's ridge-fitted defensive strength. |
| adj_def_epa | double | Opponent-adjusted EPA per play allowed as of the snapshot week, netted the same way as the offensive rating, so lower is better. |
| adj_st_epa | double | Special-teams composite in EPA units as of the snapshot week, summing the league-centered per-play EPA of the field goal, punt, and kick-return units. |
| adj_net | double | adj_off_epa minus adj_def_epa at the snapshot week, the team's overall efficiency rating in EPA per play with special teams excluded. |
| fei_off | double | Drive-level offensive rating at the snapshot week, from a ridge fit on per-drive EPA. |
| fei_def | double | Drive-level defensive rating at the snapshot week, from the same per-drive ridge fit and on the same scale as fei_off. |
| fei_net | double | fei_off minus fei_def at the snapshot week, the team's overall drive-efficiency rating. |
| games | integer |  |
| off_pace | double | Scrimmage plays per game through the snapshot week, the tempo input consumed by the totals model. |
| off_rank | integer | Dense rank of adj_off_epa in descending order within the snapshot week, so rank 1 is the most efficient offense at that point. |
| def_rank | integer | Dense rank of adj_def_epa in ascending order within the snapshot week, so rank 1 is the stingiest defense at that point. |
| net_rank | integer | Dense rank of adj_net in descending order within the snapshot week, so rank 1 is the strongest overall team at that point. |
| net_z | double | adj_net restated as a z-score against the mean and standard deviation of adj_net across the teams rated in that snapshot week. |
| through_week | integer | Regular-season week the snapshot runs through; the ratings were refit using only games kicking off on or before that week's final kickoff date. |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_cfb_ratings_weekly(2004))
#> ── college football weekly power ratings from the SportsDataverse data repo ────
#> ℹ Data updated: 2026-11-26 22:49:11 UTC
#> # A tibble: 1,585 × 19
#>    season team_id adj_off_epa adj_def_epa adj_st_epa adj_net fei_off fei_def
#>     <int> <chr>         <dbl>       <dbl>      <dbl>   <dbl>   <dbl>   <dbl>
#>  1   2004 259         -0.105       0.105       1.11   -0.210 -0.0832 -0.0832
#>  2   2004 30           0.105      -0.105      -1.16    0.210  0.131  -0.298 
#>  3   2004 2032         0.0635      0.400       0.850  -0.336  0.0167  0.543 
#>  4   2004 2116        -0.195       0.157       1.97   -0.353 -0.684  -0.0462
#>  5   2004 97           0.0643     -0.336      -0.553   0.400 -0.259  -0.892 
#>  6   2004 239         -0.223       0.250       0.820  -0.473 -0.375  -0.0267
#>  7   2004 2633         0.264       0.0536     -0.513   0.210  0.474   0.153 
#>  8   2004 2132        -0.200       0.0276      0.646  -0.228 -0.590  -0.268 
#>  9   2004 50          -0.123       0.402       0.452  -0.525 -0.158   0.562 
#> 10   2004 2117        -0.301       0.277       0.223  -0.578 -0.575   0.283 
#> # ℹ 1,575 more rows
#> # ℹ 11 more variables: fei_net <dbl>, games <int>, off_pace <dbl>,
#> #   off_rank <int>, def_rank <int>, net_rank <int>, net_z <dbl>,
#> #   fei_off_rank <int>, fei_def_rank <int>, fei_net_rank <int>,
#> #   through_week <int>
# }
```
