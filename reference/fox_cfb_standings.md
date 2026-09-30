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
#> ℹ Data updated: 2026-09-30 15:18:04 UTC
#> # A tibble: 17 × 12
#>    team_id section    atlantic_coast v2      conf  w_l   home  away  pf    pa   
#>    <chr>   <chr>      <chr>          <chr>   <chr> <chr> <chr> <chr> <chr> <chr>
#>  1 11      CONFERENCE 1              Miami … 2-0   4-0   2-0   2-0   207   36   
#>  2 11      CONFERENCE 2              Clemson 2-0   3-1   2-0   1-1   84    88   
#>  3 11      CONFERENCE 3              Duke    1-0   4-0   3-0   1-0   145   44   
#>  4 11      CONFERENCE 4              Pittsb… 1-0   4-0   4-0   0-0   157   34   
#>  5 11      CONFERENCE 5              Virgin… 1-0   4-0   2-0   2-0   173   64   
#>  6 11      CONFERENCE 6              Virgin… 1-0   3-1   3-0   0-0   162   52   
#>  7 11      CONFERENCE 7              SMU     1-1   3-1   2-0   1-1   148   99   
#>  8 11      CONFERENCE 8              Wake F… 1-1   3-1   1-1   2-0   126   112  
#>  9 11      CONFERENCE 9              Louisv… 1-1   2-2   2-1   0-0   165   115  
#> 10 11      CONFERENCE 10             Califo… 1-1   2-2   1-2   1-0   104   94   
#> 11 11      CONFERENCE 11             Stanfo… 1-2   2-2   2-1   0-1   84    134  
#> 12 11      CONFERENCE 12             North … 0-1   2-1   1-0   0-1   70    41   
#> 13 11      CONFERENCE 13             Florid… 0-1   2-2   2-1   0-1   128   101  
#> 14 11      CONFERENCE 14             Boston… 0-1   2-2   2-1   0-1   79    92   
#> 15 11      CONFERENCE 15             NC Sta… 0-1   2-2   2-0   0-2   153   100  
#> 16 11      CONFERENCE 16             Georgi… 0-1   1-3   1-2   0-1   108   104  
#> 17 11      CONFERENCE 17             Syracu… 0-2   1-2   1-1   0-1   97    51   
#> # ℹ 2 more variables: strk <chr>, entity_id <chr>
# }
```
