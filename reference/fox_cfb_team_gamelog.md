# **Get Fox Sports college football team game log**

Flattens the Bifrost `team/{id}/gamelog` into one tidy, long row per
(game, stat-category, stat). The endpoint groups team per-game stats by
category (passing, rushing, defense, ...) and season-type split.

## Usage

``` r
fox_cfb_team_gamelog(team_id)
```

## Arguments

- team_id:

  (character/numeric, required): Fox Bifrost team id (e.g. `"11"`).

## Value

A `cfbfastR`-tagged tibble with one row per (game, stat):

- `team_id`: character.: Fox team id echoed back.

- `season_type`: character.: Split label ("REGULAR SEASON",
  "POSTSEASON").

- `category`: character.: Stat category ("passing", "rushing",
  "defense", ...).

- `game_id`: character.: Fox event id for the game.

- `game_date`: character.: Game date (M/D).

- `opponent`: character.: Opponent abbreviation ("@PITT").

- `stat`: character.: Stat column name (deduped; e.g. "yds", "yds_2").

- `value`: character.: Stat value as displayed.

## Examples

``` r
# \donttest{
  try(fox_cfb_team_gamelog(team_id = "11"))
#> ── Team game log from Fox Sports (Bifrost) ────────────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-09-01 11:28:18 UTC
#> # A tibble: 0 × 1
#> # ℹ 1 variable: team_id <chr>
# }
```
