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
#> ℹ Data updated: 2026-10-09 05:37:47 UTC
#> # A tibble: 340 × 8
#>    team_id season_type    category game_id game_date opponent stat     value
#>    <chr>   <chr>          <chr>    <chr>   <chr>     <chr>    <chr>    <chr>
#>  1 11      REGULAR SEASON passing  43479   10/3      @CLEM    comp     18   
#>  2 11      REGULAR SEASON passing  43479   10/3      @CLEM    att      27   
#>  3 11      REGULAR SEASON passing  43479   10/3      @CLEM    pct      66.7 
#>  4 11      REGULAR SEASON passing  43479   10/3      @CLEM    yds      227  
#>  5 11      REGULAR SEASON passing  43479   10/3      @CLEM    pyds_att 15.5 
#>  6 11      REGULAR SEASON passing  43479   10/3      @CLEM    td       1    
#>  7 11      REGULAR SEASON passing  43479   10/3      @CLEM    int      0    
#>  8 11      REGULAR SEASON passing  43479   10/3      @CLEM    sck      2    
#>  9 11      REGULAR SEASON passing  43479   10/3      @CLEM    yds_2    7    
#> 10 11      REGULAR SEASON passing  43479   10/3      @CLEM    qbr      149.5
#> # ℹ 330 more rows
# }
```
