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
#> ── Team game log from Fox Sports (Bifrost) ─────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-03 10:13:12 UTC
#> # A tibble: 340 × 8
#>    team_id season_type    category game_id game_date opponent stat     value
#>    <chr>   <chr>          <chr>    <chr>   <chr>     <chr>    <chr>    <chr>
#>  1 11      REGULAR SEASON passing  43922   10/31     @UNC     comp     22   
#>  2 11      REGULAR SEASON passing  43922   10/31     @UNC     att      29   
#>  3 11      REGULAR SEASON passing  43922   10/31     @UNC     pct      75.9 
#>  4 11      REGULAR SEASON passing  43922   10/31     @UNC     yds      274  
#>  5 11      REGULAR SEASON passing  43922   10/31     @UNC     pyds_att 14.3 
#>  6 11      REGULAR SEASON passing  43922   10/31     @UNC     td       3    
#>  7 11      REGULAR SEASON passing  43922   10/31     @UNC     int      0    
#>  8 11      REGULAR SEASON passing  43922   10/31     @UNC     sck      1    
#>  9 11      REGULAR SEASON passing  43922   10/31     @UNC     yds_2    1    
#> 10 11      REGULAR SEASON passing  43922   10/31     @UNC     qbr      189.4
#> # ℹ 330 more rows
# }
```
