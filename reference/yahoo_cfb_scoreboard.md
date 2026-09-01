# **Get Yahoo Sports college football scoreboard**

Flattens the editorial `scoreboard` games map into one tibble (one row
per game). The full payload also embeds teams/leagues/odds maps.

## Usage

``` r
yahoo_cfb_scoreboard(season = most_recent_cfb_season(), week = 1, count = 500)
```

## Arguments

- season:

  (integer): Season year. Defaults to `most_recent_cfb_season()`.

- week:

  (integer): Schedule week. Defaults to `1`.

- count:

  (integer): Max games. Defaults to `500`.

## Value

A `cfbfastR`-tagged tibble with one row per game; columns are the Yahoo
game fields (`gameid`, `home_team_id`, `away_team_id`,
`total_home_points`, `total_away_points`, `status_type`, ...) plus
`season` and `week`. Column set varies with game state.

## See also

Other Yahoo CFB Functions:
[`yahoo_cfb_boxscore()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_boxscore.md),
[`yahoo_cfb_player_season_stats()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_player_season_stats.md),
[`yahoo_cfb_player_season_stats_legacy()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_player_season_stats_legacy.md),
[`yahoo_cfb_team_season_stats()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_team_season_stats.md),
[`yahoo_cfb_team_season_stats_legacy()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_team_season_stats_legacy.md)

## Examples

``` r
# \donttest{
  try(yahoo_cfb_scoreboard(season = 2024, week = 1))
#> 2026-09-01 11:30:20.370859: invalid arguments or no Yahoo scoreboard available!
#> [1] season week  
#> <0 rows> (or 0-length row.names)
# }
```
