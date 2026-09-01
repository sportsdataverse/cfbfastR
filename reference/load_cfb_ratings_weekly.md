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
#> ℹ Data updated: 2026-09-01 11:28:24 UTC
#> # A tibble: 1,579 × 16
#>    season team_id adj_off_epa adj_def_epa adj_st_epa  adj_net fei_off fei_def
#>     <int> <chr>         <dbl>       <dbl>      <dbl>    <dbl>   <dbl>   <dbl>
#>  1   2004 197        0.0461       0.0132      0.800   0.0329  -0.334   -0.585
#>  2   2004 259       -0.0673       0.00420     1.83   -0.0715  -0.754   -0.387
#>  3   2004 2633       0.182        0.273      -0.247  -0.0904   0.0565  -0.314
#>  4   2004 30         0.00420     -0.0673     -0.560   0.0715  -0.387   -0.754
#>  5   2004 103       -0.0177      -0.0207      2.99    0.00296 -0.613   -0.613
#>  6   2004 213       -0.102        0.0903     -0.843  -0.192    0.694   -0.491
#>  7   2004 2132      -0.117        0.0596      0.723  -0.177   -1.08    -0.813
#>  8   2004 135        0.000582     0.0860      0.0530 -0.0854   0.290   -0.310
#>  9   2004 328       -0.122        0.235       1.78   -0.357   -0.614   -0.173
#> 10   2004 201        0.0267      -0.0146      0.764   0.0413  -0.320   -0.713
#> # ℹ 1,569 more rows
#> # ℹ 8 more variables: fei_net <dbl>, games <int>, off_pace <dbl>,
#> #   off_rank <int>, def_rank <int>, net_rank <int>, net_z <dbl>,
#> #   through_week <int>
# }
```
