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
#> ℹ Data updated: 2026-09-03 22:40:42 UTC
#> # A tibble: 9 × 6
#>   team_id category   stat                 stat_abbreviation player value
#>   <chr>   <chr>      <chr>                <chr>             <chr>  <chr>
#> 1 11      TEAM STATS Passing Yards / Game PYDS/G            NA     -    
#> 2 11      TEAM STATS Rushing Yards / Game RYDS/G            NA     -    
#> 3 11      TEAM STATS Kicking Points       PTS               NA     0    
#> 4 11      TEAM STATS Kick Return Avg      KR AVG            NA     -    
#> 5 11      TEAM STATS Punt Return Avg      PR AVG            NA     -    
#> 6 11      TEAM STATS Sacks                SCK               NA     0.0  
#> 7 11      TEAM STATS Third Down Pct       3RD %             NA     -    
#> 8 11      TEAM STATS Yards / Game         YDS/G             NA     -    
#> 9 11      TEAM STATS Turnover Plus/Minus  +/-               NA     0    
# }
```
