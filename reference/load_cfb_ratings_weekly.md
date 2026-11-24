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
#> ℹ Data updated: 2026-11-24 10:01:30 UTC
#> # A tibble: 1,585 × 19
#>    season team_id adj_off_epa adj_def_epa adj_st_epa  adj_net fei_off fei_def
#>     <int> <chr>         <dbl>       <dbl>      <dbl>    <dbl>   <dbl>   <dbl>
#>  1   2004 259         -0.0760    -0.0310       1.11  -0.0451  -0.0832 -0.0832
#>  2   2004 30           0.0516    -0.159       -1.16   0.210    0.131  -0.298 
#>  3   2004 265         -0.0788    -0.00169      0.342 -0.0771  -0.289  -0.464 
#>  4   2004 2641         0.0385     0.0970      -1.58  -0.0585  -0.0934 -0.521 
#>  5   2004 151          0.213      0.127        0.213  0.0863  -0.378   0.102 
#>  6   2004 36           0.0880     0.0170       0.647  0.0710   0.127   0.0760
#>  7   2004 275          0.0887    -0.0780       1.05   0.167   -0.0462 -0.684 
#>  8   2004 24           0.113     -0.0438      -0.887  0.156    0.267  -0.428 
#>  9   2004 2294        -0.149     -0.440       -0.539  0.291   -0.663  -0.955 
#> 10   2004 99          -0.0910    -0.0828      -3.65  -0.00815 -1.04   -0.710 
#> # ℹ 1,575 more rows
#> # ℹ 11 more variables: fei_net <dbl>, games <int>, off_pace <dbl>,
#> #   off_rank <int>, def_rank <int>, net_rank <int>, net_z <dbl>,
#> #   fei_off_rank <int>, fei_def_rank <int>, fei_net_rank <int>,
#> #   through_week <int>
# }
```
