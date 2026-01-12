# **Get pre-game win probability data from API**

**Get pre-game win probability data from API**

## Usage

``` r
cfbd_metrics_wp_pregame(
  year = NULL,
  week = NULL,
  team = NULL,
  season_type = "both"
)
```

## Arguments

- year:

  (*Integer* optional): Year, 4 digit format (*YYYY*)

- week:

  (*Integer* optional): Week - values from 1-15, 1-14 for seasons
  pre-playoff, i.e. 2013 or earlier

- team:

  (*String* optional): D-I Team

- season_type:

  (*String* default both): Season type - regular, postseason, both,
  allstar, spring_regular, spring_postseason

## Value

`cfbd_metrics_wp_pregame()` - A data frame with 9 variables:

- `season`: integer.:

  Season of game.

- `season_type`: character.:

  Season type of game.

- `week`: integer.:

  Game week of the season.

- `game_id`: integer.:

  Referencing game id.

- `home_team`: character.:

  Home team name.

- `away_team`: character.:

  Away team name.

- `spread`: integer.:

  Betting line provider spread.

- `home_win_prob`: double.:

  Home win probability - pre-game prediction.

- `away_win_prob`: double.:

  Away win probability - pre-game prediction.

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
[`cfbd_metrics_wp()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp.md)

## Examples

``` r
# \donttest{
  try(cfbd_metrics_wp_pregame(year = 2019, week = 9, team = "Texas A&M"))
#> ── pre-game WP data from CollegeFootballData.com ───────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:33:10 UTC
#> # A tibble: 1 × 9
#>   season season_type  week   game_id home_team away_team    spread home_win_prob
#>    <int> <chr>       <int>     <int> <chr>     <chr>         <int>         <dbl>
#> 1   2019 regular         9 401110835 Texas A&M Mississippi…    -11         0.776
#> # ℹ 1 more variable: away_win_prob <dbl>
# }
```
