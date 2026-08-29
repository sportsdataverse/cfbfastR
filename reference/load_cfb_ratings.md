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
#> ℹ Data updated: 2026-08-29 13:16:47 UTC
#> # A tibble: 118 × 15
#>    season team_id adj_off_epa adj_def_epa adj_st_epa adj_net fei_off fei_def
#>     <int> <chr>         <dbl>       <dbl>      <dbl>   <dbl>   <dbl>   <dbl>
#>  1   2004 258          0.103     -0.0177      0.0885   0.121  -0.308 -0.775 
#>  2   2004 8            0.108     -0.00109     0.130    0.109  -0.338 -0.462 
#>  3   2004 278         -0.0406    -0.143      -0.826    0.102  -0.893 -1.37  
#>  4   2004 238          0.0173     0.141      -0.966   -0.124  -0.961 -0.358 
#>  5   2004 248         -0.0442     0.128       0.817   -0.172  -0.531  0.302 
#>  6   2004 218         -0.0815     0.172      -1.10    -0.253  -0.968  0.0532
#>  7   2004 2050        -0.269      0.243       1.04    -0.512  -1.07   0.428 
#>  8   2004 23          -0.150      0.134      -1.03    -0.284  -0.248 -0.504 
#>  9   2004 38          -0.0906     0.0514      1.15    -0.142  -0.890 -0.888 
#> 10   2004 2116        -0.152      0.291       1.41    -0.444  -0.863  0.177 
#> # ℹ 108 more rows
#> # ℹ 7 more variables: fei_net <dbl>, games <int>, off_pace <dbl>,
#> #   off_rank <int>, def_rank <int>, net_rank <int>, net_z <dbl>
# }
```
