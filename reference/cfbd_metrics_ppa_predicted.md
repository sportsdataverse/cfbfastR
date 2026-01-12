# **Calculate predicted points using down and distance**

**Calculate predicted points using down and distance**

## Usage

``` r
cfbd_metrics_ppa_predicted(down, distance)
```

## Arguments

- down:

  (*Integer* required): Down filter

- distance:

  (*Integer* required): Distance filter

## Value

`cfbd_metrics_ppa_predicted()` - A data frame with 2 variables:

- `yard_line`: integer.:

  Yards to goal

- `predicted_points`: character.:

  Predicted points at in that down-distance-yardline scenario

## See also

Other CFBD Metrics:
[`cfbd_metrics_fg_ep()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_fg_ep.md),
[`cfbd_metrics_ppa_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_games.md),
[`cfbd_metrics_ppa_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_games.md),
[`cfbd_metrics_ppa_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_season.md),
[`cfbd_metrics_ppa_teams()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_teams.md),
[`cfbd_metrics_wepa_players_kicking()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_kicking.md),
[`cfbd_metrics_wepa_players_passing()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_passing.md),
[`cfbd_metrics_wepa_players_rushing()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_rushing.md),
[`cfbd_metrics_wepa_team_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_team_season.md),
[`cfbd_metrics_wp()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp.md),
[`cfbd_metrics_wp_pregame()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp_pregame.md)

## Examples

``` r
# \donttest{
  try(cfbd_metrics_ppa_predicted(down = 1, distance = 10))
#> ── PPA data from CollegeFootballData.com ───────────────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 12:20:43 UTC
#> # A tibble: 90 × 2
#>    yard_line predicted_points
#>        <int>            <dbl>
#>  1        90             4.49
#>  2        89             4.48
#>  3        88             4.47
#>  4        87             4.46
#>  5        86             4.45
#>  6        85             4.44
#>  7        84             4.43
#>  8        83             4.42
#>  9        82             4.41
#> 10        81             4.4 
#> # ℹ 80 more rows

  try(cfbd_metrics_ppa_predicted(down = 3, distance = 10))
#> ── PPA data from CollegeFootballData.com ───────────────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 12:20:43 UTC
#> # A tibble: 90 × 2
#>    yard_line predicted_points
#>        <int>            <dbl>
#>  1        90             3.92
#>  2        89             3.89
#>  3        88             3.86
#>  4        87             3.83
#>  5        86             3.8 
#>  6        85             3.76
#>  7        84             3.72
#>  8        83             3.68
#>  9        82             3.63
#> 10        81             3.59
#> # ℹ 80 more rows
# }
```
