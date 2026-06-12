# **Get Fox Sports college football boxscore**

Flattens the per-team stat tables embedded in Bifrost `event/{id}/data`
(`boxscore`) into one tidy, long player-stat tibble.

## Usage

``` r
fox_cfb_boxscore(game_id)
```

## Arguments

- game_id:

  (character/numeric, required): Fox Bifrost event id (e.g. `"41616"`).

## Value

A `cfbfastR`-tagged tibble with one row per (player, stat):

- `game_id`: character.: Fox event id echoed back.

- `team`: character.: Team name (boxscore section title).

- `stat_group`: character.: Stat category ("PASSING", "RUSHING", ...).

- `player`: character.: Player name (or "TOTALS").

- `athlete_id`: character.: Fox athlete id (from the player's
  contentUri).

- `stat`: character.: Stat column name (e.g. "yds", "td").

- `value`: character.: Stat value as displayed.

## Examples

``` r
# \donttest{
  try(fox_cfb_boxscore(game_id = "41616"))
#> ── Boxscore data from Fox Sports (Bifrost) ─────────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-06-12 14:22:15 UTC
#> # A tibble: 843 × 7
#>    game_id team       stat_group player       athlete_id stat  value
#>    <chr>   <chr>      <chr>      <chr>        <chr>      <chr> <chr>
#>  1 41616   KENT STATE PASSING    D. DeShields 210621     com   9/18 
#>  2 41616   KENT STATE PASSING    D. DeShields 210621     pct   50.0 
#>  3 41616   KENT STATE PASSING    D. DeShields 210621     yds   129  
#>  4 41616   KENT STATE PASSING    D. DeShields 210621     avg   7.2  
#>  5 41616   KENT STATE PASSING    D. DeShields 210621     td    1    
#>  6 41616   KENT STATE PASSING    D. DeShields 210621     int   1    
#>  7 41616   KENT STATE PASSING    D. DeShields 210621     qbr   117.4
#>  8 41616   KENT STATE PASSING    N. Good      239440     com   4/9  
#>  9 41616   KENT STATE PASSING    N. Good      239440     pct   44.4 
#> 10 41616   KENT STATE PASSING    N. Good      239440     yds   34   
#> # ℹ 833 more rows
# }
```
