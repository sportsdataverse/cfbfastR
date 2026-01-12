# **Get win probability chart data from API**

**Get win probability chart data from API**

## Usage

``` r
cfbd_metrics_wp(game_id)
```

## Arguments

- game_id:

  (*Integer* required): Game ID filter for querying a single game Can be
  found using the
  [`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md)
  function

## Value

`cfbd_metrics_wp()` - A data frame with 16 variables:

- `play_id`: character.:

  Play referencing id.

- `play_text`: character.:

  A text description of the play.

- `home_id`: integer.:

  Home team referencing id.

- `home`: character.:

  Home team name.

- `away_id`: integer.:

  Away team referencing id.

- `away`: character.:

  Away team name.

- `spread`: character.:

  Betting lines provider spread.

- `home_ball`: logical.:

  Home team has the ball.

- `home_score`: integer.:

  Home team score.

- `away_score`: integer.:

  Away team score.

- `down`: integer.:

  Down of the play.

- `distance`: integer.:

  Distance to the sticks (to 1st down marker of goal-line in goal-to-go
  situations).

- `home_win_prob`: character.:

  Home team win probability.

- `away_win_prob`: double.:

  Away team win probability.

- `play_number`: integer.:

  Game play number.

- `yard_line`: integer.:

  Yard line of the play (0-100 yards).

## See also

Other CFBD Metrics:
[`cfbd_metrics_fg_ep()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_fg_ep.md),
[`cfbd_metrics_ppa_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_games.md),
[`cfbd_metrics_ppa_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_games.md),
[`cfbd_metrics_ppa_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_season.md),
[`cfbd_metrics_ppa_predicted()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_predicted.md),
[`cfbd_metrics_ppa_teams()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_teams.md),
[`cfbd_metrics_wepa_players_kicking()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_kicking.md),
[`cfbd_metrics_wepa_players_passing()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_passing.md),
[`cfbd_metrics_wepa_players_rushing()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_rushing.md),
[`cfbd_metrics_wepa_team_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_team_season.md),
[`cfbd_metrics_wp_pregame()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp_pregame.md)

## Examples

``` r
# \donttest{
  try(cfbd_metrics_wp(game_id = 401012356))
#> ── WP data from CollegeFootballData.com ────────────────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:33:09 UTC
#> # A tibble: 224 × 16
#>    play_id     play_text home_id home  away_id away  spread home_ball home_score
#>    <chr>       <chr>       <int> <chr>   <int> <chr>  <int> <lgl>          <int>
#>  1 4010123561… Joe Burr…     245 Texa…      99 LSU       -3 FALSE              0
#>  2 4010123561… Nick Bro…     245 Texa…      99 LSU       -3 FALSE              0
#>  3 4010123561… Joe Burr…     245 Texa…      99 LSU       -3 FALSE              0
#>  4 4010123561… Zach Von…     245 Texa…      99 LSU       -3 FALSE              0
#>  5 4010123561… Trayveon…     245 Texa…      99 LSU       -3 TRUE               0
#>  6 4010123561… Kellen M…     245 Texa…      99 LSU       -3 TRUE               0
#>  7 4010123561… Kellen M…     245 Texa…      99 LSU       -3 TRUE               0
#>  8 4010123561… Braden M…     245 Texa…      99 LSU       -3 TRUE               0
#>  9 4010123561… Joe Burr…     245 Texa…      99 LSU       -3 FALSE              0
#> 10 4010123561… Nick Bro…     245 Texa…      99 LSU       -3 FALSE              0
#> # ℹ 214 more rows
#> # ℹ 7 more variables: away_score <int>, down <int>, distance <int>,
#> #   home_win_prob <dbl>, away_win_prob <dbl>, play_number <int>,
#> #   yard_line <int>
# }
```
