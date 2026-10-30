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
#> ℹ Data updated: 2026-10-30 00:16:20 UTC
#> # A tibble: 17 × 12
#>    team_id section    atlantic_coast v2      conf  w_l   home  away  pf    pa   
#>    <chr>   <chr>      <chr>          <chr>   <chr> <chr> <chr> <chr> <chr> <chr>
#>  1 11      CONFERENCE 1              Miami … 5-0   7-0   4-0   3-0   343   107  
#>  2 11      CONFERENCE 2              Wake F… 4-1   6-1   2-1   4-0   262   136  
#>  3 11      CONFERENCE 3              SMU     4-1   6-1   5-0   1-1   255   148  
#>  4 11      CONFERENCE 4              Virgin… 3-2   6-2   3-1   3-1   280   164  
#>  5 11      CONFERENCE 5              Louisv… 3-2   4-3   3-1   1-1   271   192  
#>  6 11      CONFERENCE 6              Duke    2-2   5-2   3-1   2-1   209   112  
#>  7 11      CONFERENCE 7              Boston… 2-2   4-3   3-1   1-2   171   165  
#>  8 11      CONFERENCE 8              North … 2-2   4-3   1-2   2-1   171   146  
#>  9 11      CONFERENCE 9              Clemson 2-2   4-3   3-2   1-1   150   149  
#> 10 11      CONFERENCE 10             Pittsb… 2-3   5-3   4-1   1-2   253   167  
#> 11 11      CONFERENCE 11             Virgin… 2-3   4-4   4-1   0-2   226   157  
#> 12 11      CONFERENCE 12             Stanfo… 2-3   4-4   4-1   0-3   159   284  
#> 13 11      CONFERENCE 13             Califo… 2-3   3-5   2-3   1-2   187   253  
#> 14 11      CONFERENCE 14             Florid… 1-3   3-4   3-1   0-3   221   195  
#> 15 11      CONFERENCE 15             NC Sta… 1-3   3-4   3-1   0-3   226   197  
#> 16 11      CONFERENCE 16             Georgi… 1-3   2-5   2-3   0-2   187   212  
#> 17 11      CONFERENCE 17             Syracu… 1-4   3-4   1-2   2-2   221   184  
#> # ℹ 2 more variables: strk <chr>, entity_id <chr>
# }
```
