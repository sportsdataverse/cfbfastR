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
#> ℹ Data updated: 2026-09-27 07:21:59 UTC
#> # A tibble: 272 × 8
#>    team_id season_type    category game_id game_date opponent stat     value
#>    <chr>   <chr>          <chr>    <chr>   <chr>     <chr>    <chr>    <chr>
#>  1 11      REGULAR SEASON passing  43397   9/26      CMU      comp     27   
#>  2 11      REGULAR SEASON passing  43397   9/26      CMU      att      34   
#>  3 11      REGULAR SEASON passing  43397   9/26      CMU      pct      79.4 
#>  4 11      REGULAR SEASON passing  43397   9/26      CMU      yds      371  
#>  5 11      REGULAR SEASON passing  43397   9/26      CMU      pyds_att 16.8 
#>  6 11      REGULAR SEASON passing  43397   9/26      CMU      td       3    
#>  7 11      REGULAR SEASON passing  43397   9/26      CMU      int      0    
#>  8 11      REGULAR SEASON passing  43397   9/26      CMU      sck      2    
#>  9 11      REGULAR SEASON passing  43397   9/26      CMU      yds_2    18   
#> 10 11      REGULAR SEASON passing  43397   9/26      CMU      qbr      200.2
#> # ℹ 262 more rows
# }
```
