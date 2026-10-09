# **Get Fox Sports college football conference standings**

Flattens the Bifrost `team/{id}/standings` conference table (the
standings of the given team's conference). Note: the league-wide
`league/standings` endpoint returns header-only tables, so this is keyed
by team.

## Usage

``` r
fox_cfb_standings(team_id)
```

## Arguments

- team_id:

  (character/numeric, required): Fox Bifrost team id (e.g. `"11"`).

## Value

A `cfbfastR`-tagged tibble with one row per team in the conference;
columns are the standings headers (rank, team, `conf`, `w_l`, `home`,
`away`, `pf`, `pa`, ...) plus `team_id`, `section` (conference), and
`entity_id` (Fox team id). Column set varies with the standings
template.

## Examples

``` r
# \donttest{
  try(fox_cfb_standings(team_id = "11"))
#> ── Standings data from Fox Sports (Bifrost) ───────────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-10-09 05:37:47 UTC
#> # A tibble: 17 × 12
#>    team_id section    atlantic_coast v2      conf  w_l   home  away  pf    pa   
#>    <chr>   <chr>      <chr>          <chr>   <chr> <chr> <chr> <chr> <chr> <chr>
#>  1 11      CONFERENCE 1              Miami … 3-0   5-0   2-0   3-0   248   49   
#>  2 11      CONFERENCE 2              Pittsb… 2-0   5-0   4-0   1-0   192   67   
#>  3 11      CONFERENCE 3              Duke    1-0   4-0   3-0   1-0   145   44   
#>  4 11      CONFERENCE 4              Wake F… 2-1   4-1   2-1   2-0   183   115  
#>  5 11      CONFERENCE 5              SMU     2-1   4-1   3-0   1-1   173   115  
#>  6 11      CONFERENCE 6              Clemson 2-1   3-2   2-1   1-1   97    129  
#>  7 11      CONFERENCE 7              Virgin… 1-1   4-1   2-1   2-0   206   99   
#>  8 11      CONFERENCE 8              Florid… 1-1   3-2   3-1   0-1   166   108  
#>  9 11      CONFERENCE 9              Virgin… 1-1   3-2   3-0   0-1   169   90   
#> 10 11      CONFERENCE 10             NC Sta… 1-1   3-2   3-0   0-2   184   128  
#> 11 11      CONFERENCE 11             Califo… 1-1   2-3   1-2   1-1   135   133  
#> 12 11      CONFERENCE 12             Louisv… 1-2   2-3   2-1   0-1   193   146  
#> 13 11      CONFERENCE 13             Stanfo… 1-3   2-3   2-1   0-2   87    191  
#> 14 11      CONFERENCE 14             North … 0-1   2-2   1-1   0-1   96    78   
#> 15 11      CONFERENCE 15             Georgi… 0-1   1-3   1-2   0-1   108   104  
#> 16 11      CONFERENCE 16             Syracu… 0-2   2-2   1-1   1-1   139   92   
#> 17 11      CONFERENCE 17             Boston… 0-2   2-3   2-1   0-2   95    117  
#> # ℹ 2 more variables: strk <chr>, entity_id <chr>
# }
```
