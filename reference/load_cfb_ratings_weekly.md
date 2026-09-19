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
#> ℹ Data updated: 2026-09-19 03:01:29 UTC
#> # A tibble: 1,579 × 16
#>    season team_id adj_off_epa adj_def_epa adj_st_epa adj_net fei_off fei_def
#>     <int> <chr>         <dbl>       <dbl>      <dbl>   <dbl>   <dbl>   <dbl>
#>  1   2004 2117         0.205      0.153        0.265  0.0521  -0.877 -0.0165
#>  2   2004 2579         0.0946    -0.0545      -2.34   0.149   -0.202 -1.05  
#>  3   2004 167         -0.0752     0.00656     -1.49  -0.0818  -1.17  -0.507 
#>  4   2004 2459         0.0275    -0.0225       0.670  0.0501  -0.829 -1.04  
#>  5   2004 333          0.234     -0.123        1.08   0.357   -0.169 -0.612 
#>  6   2004 249          0.172      0.0215      -0.106  0.150   -0.864  0.0784
#>  7   2004 238         -0.0545     0.0946      -0.287 -0.149   -1.05  -0.202 
#>  8   2004 2426         0.227     -0.0342      -0.531  0.262   -0.477 -0.700 
#>  9   2004 2638        -0.203     -0.0155       1.91  -0.188   -1.18  -0.745 
#> 10   2004 2294        -0.125     -0.422       -0.704  0.297   -0.969 -1.36  
#> # ℹ 1,569 more rows
#> # ℹ 8 more variables: fei_net <dbl>, games <int>, off_pace <dbl>,
#> #   off_rank <int>, def_rank <int>, net_rank <int>, net_z <dbl>,
#> #   through_week <int>
# }
```
