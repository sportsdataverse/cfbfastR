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
#> ℹ Data updated: 2026-09-30 09:46:40 UTC
#> # A tibble: 1,585 × 16
#>    season team_id adj_off_epa adj_def_epa adj_st_epa  adj_net  fei_off  fei_def
#>     <int> <chr>         <dbl>       <dbl>      <dbl>    <dbl>    <dbl>    <dbl>
#>  1   2004 259         -0.0833     -0.0363     1.16   -0.0469  -0.181   -0.181  
#>  2   2004 30           0.0425     -0.162     -1.23    0.205   -0.00764 -0.355  
#>  3   2004 164         -0.0607     -0.0934    -0.555   0.0327  -0.801   -0.673  
#>  4   2004 249          0.172       0.109     -0.104   0.0637  -0.675    0.643  
#>  5   2004 277          0.197       0.192     -0.455   0.00440  0.0507  -0.456  
#>  6   2004 2641         0.103       0.0857    -1.63    0.0174  -0.0334  -0.668  
#>  7   2004 135          0.0198      0.111      0.0554 -0.0910   0.647    0.00930
#>  8   2004 2459         0.0332      0.0376     0.672  -0.00440 -0.563   -0.569  
#>  9   2004 2433        -0.0238     -0.0172    -2.27   -0.00661 -0.918   -0.0343 
#> 10   2004 2628         0.157       0.162     -1.16   -0.00516  0.0853   0.374  
#> # ℹ 1,575 more rows
#> # ℹ 8 more variables: fei_net <dbl>, games <int>, off_pace <dbl>,
#> #   off_rank <int>, def_rank <int>, net_rank <int>, net_z <dbl>,
#> #   through_week <int>
# }
```
