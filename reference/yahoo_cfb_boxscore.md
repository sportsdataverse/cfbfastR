# **Get Yahoo Sports college football boxscore (raw JSON)**

Returns the raw editorial `boxscore/{game_id}` JSON (as a nested list).
The boxscore uses a normalized decoder-dictionary schema
(`player_stats[playerId][variation][stat_type]` joined against
`stat_types` / `stat_categories`), returned as-is rather than flattened
to tibbles.

## Usage

``` r
yahoo_cfb_boxscore(game_id)
```

## Arguments

- game_id:

  (character, required): Dotted game id (e.g. `"ncaaf.g.202509200023"`).

## Value

The full parsed JSON response as a nested list; the boxscore is under
`service$boxscore`. `NULL` when the request fails.

## See also

Other Yahoo CFB Functions:
[`yahoo_cfb_player_season_stats()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_player_season_stats.md),
[`yahoo_cfb_player_season_stats_legacy()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_player_season_stats_legacy.md),
[`yahoo_cfb_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_scoreboard.md),
[`yahoo_cfb_team_season_stats()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_team_season_stats.md),
[`yahoo_cfb_team_season_stats_legacy()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_team_season_stats_legacy.md)

## Examples

``` r
# \donttest{
  try(yahoo_cfb_boxscore(game_id = "ncaaf.g.202509200023"))
#> 2026-11-24 14:33:51.222685: invalid game_id or no Yahoo boxscore available! HTTP 404 Not Found.
#> NULL
# }
```
