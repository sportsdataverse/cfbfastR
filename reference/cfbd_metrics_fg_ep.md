# **Get FG expected points from CFBD API**

**Get FG expected points from CFBD API**

## Usage

``` r
cfbd_metrics_fg_ep()
```

## Value

`cfbd_metrics_fg_ep()` - A data frame with 3 variables:

- `yards_to_goal`: integer.:

  Yards to the goal line (0-100).

- `distance`: integer.:

  Distance to goal posts from kicking location (17 yds further than
  yards to goal).

- `expected_points`: double.:

  Expected points given yards to goal / distance.

## See also

Other CFBD Metrics:
[`cfbd_metrics_ppa_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_games.md),
[`cfbd_metrics_ppa_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_games.md),
[`cfbd_metrics_ppa_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_season.md),
[`cfbd_metrics_ppa_predicted()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_predicted.md),
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
  try(cfbd_metrics_fg_ep())
#> ── FG expected points data from CollegeFootballData.com ────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:33:01 UTC
#> # A tibble: 100 × 3
#>    yards_to_goal distance expected_points
#>            <int>    <int>           <dbl>
#>  1             0       17            2.85
#>  2             1       18            2.84
#>  3             2       19            2.82
#>  4             3       20            2.81
#>  5             4       21            2.79
#>  6             5       22            2.78
#>  7             6       23            2.75
#>  8             7       24            2.73
#>  9             8       25            2.71
#> 10             9       26            2.68
#> # ℹ 90 more rows
# }
```
