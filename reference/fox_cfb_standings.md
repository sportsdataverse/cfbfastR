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
#> ℹ Data updated: 2026-10-12 01:30:34 UTC
#> # A tibble: 17 × 12
#>    team_id section    atlantic_coast v2      conf  w_l   home  away  pf    pa   
#>    <chr>   <chr>      <chr>          <chr>   <chr> <chr> <chr> <chr> <chr> <chr>
#>  1 11      CONFERENCE 1              Miami … 3-0   5-0   2-0   3-0   248   49   
#>  2 11      CONFERENCE 2              Wake F… 3-1   5-1   2-1   3-0   221   129  
#>  3 11      CONFERENCE 3              Pittsb… 2-1   5-1   4-1   1-0   209   88   
#>  4 11      CONFERENCE 4              SMU     2-1   4-1   3-0   1-1   173   115  
#>  5 11      CONFERENCE 5              Virgin… 2-1   4-2   4-0   0-1   197   115  
#>  6 11      CONFERENCE 6              Clemson 2-1   3-2   2-1   1-1   97    129  
#>  7 11      CONFERENCE 7              Califo… 2-1   3-3   2-2   1-1   160   153  
#>  8 11      CONFERENCE 8              Louisv… 2-2   3-3   3-1   0-1   237   166  
#>  9 11      CONFERENCE 9              Duke    1-1   4-1   3-0   1-1   170   72   
#> 10 11      CONFERENCE 10             North … 1-1   3-2   1-1   1-1   117   95   
#> 11 11      CONFERENCE 11             Georgi… 1-1   2-3   2-2   0-1   136   129  
#> 12 11      CONFERENCE 12             Virgin… 1-2   4-2   2-1   2-1   226   124  
#> 13 11      CONFERENCE 13             Florid… 1-2   3-3   3-1   0-2   186   152  
#> 14 11      CONFERENCE 14             NC Sta… 1-2   3-3   3-1   0-2   198   166  
#> 15 11      CONFERENCE 15             Stanfo… 1-3   2-4   2-1   0-3   94    249  
#> 16 11      CONFERENCE 16             Boston… 0-2   2-3   2-1   0-2   95    117  
#> 17 11      CONFERENCE 17             Syracu… 0-3   2-3   1-1   1-2   164   120  
#> # ℹ 2 more variables: strk <chr>, entity_id <chr>
# }
```
