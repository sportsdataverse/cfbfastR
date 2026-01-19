# **ESPN Metrics**

**ESPN Metrics**

Get win probability chart data from ESPN Graciously contributed by
MrCaseB:

## Usage

``` r
espn_metrics_wp(game_id)
```

## Arguments

- game_id:

  (*Integer* required): Game ID filter for querying a single game Can be
  found using the
  [`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md)
  function

## Value

`espn_metrics_wp()` - A data frame with 5 variables:

- `game_id`: character.:

  Referencing game ID (should be same as `game_id` from other
  functions).

- `play_id`: character.:

  Referencing play ID.

- `seconds_left`: integer.:

  DEPRECATED. Seconds left in the game.

- `home_win_percentage`: double.:

  The probability of the home team winning the game.

- `away_win_percentage`: double.:

  The probability of the away team winning the game (calculated as 1 -
  `home_win_percentage` - `tie_percentage`).

- `tie_percentage`: double.:

  The probability of the game ending the final period in a tie.

## Examples

``` r
# \donttest{
  try(espn_metrics_wp(game_id = 401628369))
#> ── Win probability chart data from ESPN ────────────────────── cfbfastR 2.2.1 ──
#> ℹ Data updated: 2026-01-19 16:23:19 UTC
#> # A tibble: 196 × 6
#>    game_id   play_id        seconds_left home_win_percentage away_win_percentage
#>    <chr>     <chr>          <lgl>                      <dbl>               <dbl>
#>  1 401628369 4016283691018… NA                         0.291               0.709
#>  2 401628369 4016283691018… NA                         0.305               0.695
#>  3 401628369 4016283691018… NA                         0.276               0.724
#>  4 401628369 4016283691018… NA                         0.278               0.722
#>  5 401628369 4016283691018… NA                         0.297               0.703
#>  6 401628369 4016283691018… NA                         0.327               0.673
#>  7 401628369 4016283691018… NA                         0.309               0.691
#>  8 401628369 4016283691018… NA                         0.303               0.697
#>  9 401628369 4016283691018… NA                         0.293               0.707
#> 10 401628369 4016283691018… NA                         0.261               0.739
#> # ℹ 186 more rows
#> # ℹ 1 more variable: tie_percentage <dbl>
# }
```
