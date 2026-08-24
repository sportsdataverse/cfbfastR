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
#> ── Team game log from Fox Sports (Bifrost) ─────────────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-24 12:12:53 UTC
#> # A tibble: 340 × 8
#>    team_id season_type category game_id game_date opponent stat     value
#>    <chr>   <chr>       <chr>    <chr>   <chr>     <chr>    <chr>    <chr>
#>  1 11      POSTSEASON  passing  42792   1/19      IND      comp     19   
#>  2 11      POSTSEASON  passing  42792   1/19      IND      att      32   
#>  3 11      POSTSEASON  passing  42792   1/19      IND      pct      59.4 
#>  4 11      POSTSEASON  passing  42792   1/19      IND      yds      232  
#>  5 11      POSTSEASON  passing  42792   1/19      IND      pyds_att 10.7 
#>  6 11      POSTSEASON  passing  42792   1/19      IND      td       1    
#>  7 11      POSTSEASON  passing  42792   1/19      IND      int      1    
#>  8 11      POSTSEASON  passing  42792   1/19      IND      sck      1    
#>  9 11      POSTSEASON  passing  42792   1/19      IND      yds_2    7    
#> 10 11      POSTSEASON  passing  42792   1/19      IND      qbr      124.3
#> # ℹ 330 more rows
# }
```
