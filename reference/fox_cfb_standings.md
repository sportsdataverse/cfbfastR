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
#> ── Standings data from Fox Sports (Bifrost) ────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-03 23:32:12 UTC
#> # A tibble: 17 × 12
#>    team_id section    atlantic_coast v2      conf  w_l   home  away  pf    pa   
#>    <chr>   <chr>      <chr>          <chr>   <chr> <chr> <chr> <chr> <chr> <chr>
#>  1 11      CONFERENCE 1              Miami … 6-0   8-0   4-0   4-0   381   142  
#>  2 11      CONFERENCE 2              Wake F… 5-1   7-1   3-1   4-0   313   143  
#>  3 11      CONFERENCE 3              SMU     4-2   6-2   5-0   1-2   282   178  
#>  4 11      CONFERENCE 4              Louisv… 4-2   5-3   4-1   1-1   323   216  
#>  5 11      CONFERENCE 5              Duke    3-2   6-2   4-1   2-1   256   114  
#>  6 11      CONFERENCE 6              Virgin… 3-2   6-2   3-1   3-1   280   164  
#>  7 11      CONFERENCE 7              Clemson 3-2   5-3   3-2   2-1   186   173  
#>  8 11      CONFERENCE 8              Pittsb… 3-3   6-3   5-1   1-2   287   178  
#>  9 11      CONFERENCE 9              North … 2-3   4-4   1-3   2-1   206   184  
#> 10 11      CONFERENCE 10             NC Sta… 2-3   4-4   4-1   0-3   257   207  
#> 11 11      CONFERENCE 11             Boston… 2-3   4-4   3-1   1-3   173   212  
#> 12 11      CONFERENCE 12             Syracu… 2-4   4-4   2-2   2-2   251   211  
#> 13 11      CONFERENCE 13             Virgin… 2-4   4-5   4-1   0-3   233   208  
#> 14 11      CONFERENCE 14             Stanfo… 2-4   4-5   4-1   0-4   183   336  
#> 15 11      CONFERENCE 15             Califo… 2-4   3-6   2-3   1-3   197   284  
#> 16 11      CONFERENCE 16             Florid… 1-4   3-5   3-2   0-3   245   231  
#> 17 11      CONFERENCE 17             Georgi… 1-4   2-6   2-3   0-3   198   246  
#> # ℹ 2 more variables: strk <chr>, entity_id <chr>
# }
```
