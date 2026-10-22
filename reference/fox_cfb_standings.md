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
#> ℹ Data updated: 2026-10-22 17:19:26 UTC
#> # A tibble: 17 × 12
#>    team_id section    atlantic_coast v2      conf  w_l   home  away  pf    pa   
#>    <chr>   <chr>      <chr>          <chr>   <chr> <chr> <chr> <chr> <chr> <chr>
#>  1 11      CONFERENCE 1              Miami … 4-0   6-0   3-0   3-0   291   84   
#>  2 11      CONFERENCE 2              Wake F… 4-1   6-1   2-1   4-0   262   136  
#>  3 11      CONFERENCE 3              SMU     3-1   5-1   4-0   1-1   196   128  
#>  4 11      CONFERENCE 4              Clemson 2-1   4-2   3-1   1-1   134   129  
#>  5 11      CONFERENCE 5              North … 2-1   4-2   1-1   2-1   141   115  
#>  6 11      CONFERENCE 6              Louisv… 3-2   4-3   3-1   1-1   271   192  
#>  7 11      CONFERENCE 7              Virgin… 2-2   5-2   3-1   2-1   260   148  
#>  8 11      CONFERENCE 8              Pittsb… 2-2   5-2   4-1   1-1   230   115  
#>  9 11      CONFERENCE 9              Virgin… 2-2   4-3   4-0   0-2   210   138  
#> 10 11      CONFERENCE 10             Califo… 2-2   3-4   2-3   1-1   167   194  
#> 11 11      CONFERENCE 11             Duke    1-2   4-2   3-1   1-1   190   96   
#> 12 11      CONFERENCE 12             Boston… 1-2   3-3   3-1   0-2   122   138  
#> 13 11      CONFERENCE 13             NC Sta… 1-2   3-3   3-1   0-2   198   166  
#> 14 11      CONFERENCE 14             Georgi… 1-2   2-4   2-2   0-2   160   163  
#> 15 11      CONFERENCE 15             Florid… 1-3   3-4   3-1   0-3   221   195  
#> 16 11      CONFERENCE 16             Stanfo… 1-3   3-4   3-1   0-3   128   256  
#> 17 11      CONFERENCE 17             Syracu… 0-4   2-4   1-2   1-2   190   154  
#> # ℹ 2 more variables: strk <chr>, entity_id <chr>
# }
```
