# **Load college football season power ratings from the SportsDataverse data repo**

Loads season-end team power ratings from the cfbfastR modeling suite –
one row per team with overall/offense/defense/special-teams ratings on
the points scale. Published to the `cfb_ratings` release tag on the
sportsdataverse-data repo.

## Usage

``` r
load_cfb_ratings(
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
| adj_off_epa | double | Opponent-adjusted offensive EPA per play: the team's raw per-game EPA on pass and rush plays net of each opponent's ridge-fitted defensive strength, averaged over its games. |
| adj_def_epa | double | Opponent-adjusted EPA per play allowed, netted the same way as the offensive rating, so lower is better because it measures EPA surrendered. |
| adj_st_epa | double | Special-teams composite in EPA units: per-play mean EPA on field goals, punts, and kick returns, each centered on that unit's league mean and summed across the three units. |
| adj_net | double | adj_off_epa minus adj_def_epa, the team's overall efficiency rating in EPA per play; special teams is deliberately excluded. |
| fei_off | double | Drive-level offensive rating from a ridge fit on per-drive EPA, the Fremeau-style drive-efficiency counterpart to adj_off_epa. |
| fei_def | double | Drive-level defensive rating from the same per-drive ridge fit, on the same scale as fei_off. |
| fei_net | double | fei_off minus fei_def, the team's overall drive-efficiency rating, with the ridge's dropped reference team pinned at zero. |
| games | integer |  |
| off_pace | double | Tempo measure: scrimmage plays (pass plus rush) per game, centering near 65 and used as the pace input to the totals model. |
| off_rank | integer | Dense rank of adj_off_epa in descending order, so rank 1 is the season's most efficient offense. |
| def_rank | integer | Dense rank of adj_def_epa in ascending order, so rank 1 is the season's stingiest defense. |
| net_rank | integer | Dense rank of adj_net in descending order, so rank 1 is the season's strongest overall team. |
| net_z | double | adj_net restated as a z-score against the mean and standard deviation of adj_net across the rated teams that season. |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_cfb_ratings(2004))
#> ── college football season power ratings from the SportsDataverse data repo ────
#> ℹ Data updated: 2026-09-30 20:39:04 UTC
#> # A tibble: 118 × 18
#>    season team_id adj_off_epa adj_def_epa adj_st_epa adj_net fei_off  fei_def
#>     <int> <chr>         <dbl>       <dbl>      <dbl>   <dbl>   <dbl>    <dbl>
#>  1   2004 2117       -0.310        0.185      -0.907 -0.495  -1.05    0.00384
#>  2   2004 197         0.127        0.0903      0.245  0.0365  0.0924 -0.281  
#>  3   2004 2116       -0.138        0.302       1.41  -0.440  -0.650   0.471  
#>  4   2004 36          0.0130       0.138       1.89  -0.125  -0.271   0.544  
#>  5   2004 2294       -0.104       -0.115       0.156  0.0115 -0.722  -1.11   
#>  6   2004 87          0.0418       0.0206      0.184  0.0212 -0.164  -0.246  
#>  7   2004 245         0.151       -0.0495      0.557  0.201   0.0698 -0.485  
#>  8   2004 154        -0.00112      0.132      -0.559 -0.134  -0.575  -0.305  
#>  9   2004 9           0.0629      -0.112      -0.523  0.175  -0.290  -0.534  
#> 10   2004 2459        0.0106       0.0646     -0.387 -0.0541 -0.0893 -0.377  
#> # ℹ 108 more rows
#> # ℹ 10 more variables: fei_net <dbl>, games <int>, off_pace <dbl>,
#> #   off_rank <int>, def_rank <int>, net_rank <int>, net_z <dbl>,
#> #   fei_off_rank <int>, fei_def_rank <int>, fei_net_rank <int>
# }
```
