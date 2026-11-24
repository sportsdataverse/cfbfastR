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
#> ℹ Data updated: 2026-11-24 10:01:05 UTC
#> # A tibble: 17 × 12
#>    team_id section    atlantic_coast v2      conf  w_l   home  away  pf    pa   
#>    <chr>   <chr>      <chr>          <chr>   <chr> <chr> <chr> <chr> <chr> <chr>
#>  1 11      CONFERENCE 1              Miami … 8-0   10-1  6-0   4-1   469   218  
#>  2 11      CONFERENCE 2              Wake F… 7-1   10-1  4-1   6-0   489   179  
#>  3 11      CONFERENCE 3              Louisv… 7-2   8-3   5-1   3-1   425   257  
#>  4 11      CONFERENCE 4              SMU     5-3   7-4   6-1   1-3   343   279  
#>  5 11      CONFERENCE 5              Clemson 5-3   7-4   3-3   4-1   230   216  
#>  6 11      CONFERENCE 6              Duke    4-4   7-4   4-2   3-2   332   173  
#>  7 11      CONFERENCE 7              Stanfo… 4-4   6-5   4-1   2-4   267   386  
#>  8 11      CONFERENCE 8              Virgin… 4-4   6-5   6-1   0-3   310   239  
#>  9 11      CONFERENCE 9              Boston… 3-4   5-6   4-2   1-4   231   299  
#> 10 11      CONFERENCE 10             Virgin… 3-5   6-5   3-2   3-3   350   283  
#> 11 11      CONFERENCE 11             Pittsb… 3-5   6-5   5-2   1-3   307   236  
#> 12 11      CONFERENCE 12             Florid… 3-5   5-6   3-3   2-3   302   293  
#> 13 11      CONFERENCE 13             NC Sta… 3-5   5-6   4-3   1-3   319   292  
#> 14 11      CONFERENCE 14             Syracu… 3-6   5-6   2-3   3-3   313   287  
#> 15 11      CONFERENCE 15             North … 2-5   5-6   1-4   3-2   282   262  
#> 16 11      CONFERENCE 16             Georgi… 2-6   3-8   2-5   1-3   264   346  
#> 17 11      CONFERENCE 17             Califo… 2-6   3-8   2-4   1-4   232   364  
#> # ℹ 2 more variables: strk <chr>, entity_id <chr>
# }
```
