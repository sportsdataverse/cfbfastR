# **Get Fox Sports college football team stat leaders**

Flattens the Bifrost `team/{id}/stats` leaders sections.

## Usage

``` r
fox_cfb_team_stats(team_id)
```

## Arguments

- team_id:

  (character/numeric, required): Fox Bifrost team id (e.g. `"11"`).

## Value

A `cfbfastR`-tagged tibble with one row per (category, leader):

- `team_id`: character.: Fox team id echoed back.

- `category`: character.: Leader section title.

- `stat`: character.: Stat name (e.g. "Passing Yards").

- `stat_abbreviation`: character.: Stat abbreviation (e.g. "PYDS").

- `player`: character.: Leading player name.

- `value`: character.: Stat value as displayed.

## Examples

``` r
# \donttest{
  try(fox_cfb_team_stats(team_id = "11"))
#> ── Team stat leaders from Fox Sports (Bifrost) ────────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-09-07 06:38:05 UTC
#> # A tibble: 23 × 6
#>    team_id category     stat                    stat_abbreviation player   value
#>    <chr>   <chr>        <chr>                   <chr>             <chr>    <chr>
#>  1 11      PLAYER STATS Passing Yards           PYDS              Darian … 401  
#>  2 11      PLAYER STATS Passing Touchdowns      PTD               Darian … 5    
#>  3 11      PLAYER STATS Rushing Yards           RYDS              Mark Fl… 40   
#>  4 11      PLAYER STATS Rushing Touchdowns      RTD               CharMar… 1    
#>  5 11      PLAYER STATS Receiving Yards         RECYDS            Malachi… 234  
#>  6 11      PLAYER STATS Receiving Touchdowns    RECTD             Malachi… 3    
#>  7 11      PLAYER STATS Kicking Points          PTS               Jake We… 9    
#>  8 11      PLAYER STATS Kick Return Yards       KR YDS            Javian … 23   
#>  9 11      PLAYER STATS Punt Return Yards       PR YDS            Cooper … 0    
#> 10 11      PLAYER STATS Defensive Interceptions DEF INT           Kamal B… 0    
#> # ℹ 13 more rows
# }
```
