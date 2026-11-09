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
#> ℹ Data updated: 2026-11-09 19:56:19 UTC
#> # A tibble: 17 × 12
#>    team_id section    atlantic_coast v2      conf  w_l   home  away  pf    pa   
#>    <chr>   <chr>      <chr>          <chr>   <chr> <chr> <chr> <chr> <chr> <chr>
#>  1 11      CONFERENCE 1              Miami … 6-0   8-1   4-0   4-1   405   173  
#>  2 11      CONFERENCE 2              Wake F… 5-1   8-1   4-1   4-0   390   143  
#>  3 11      CONFERENCE 3              SMU     5-2   7-2   6-0   1-2   333   206  
#>  4 11      CONFERENCE 4              Louisv… 5-2   6-3   4-1   2-1   367   233  
#>  5 11      CONFERENCE 5              Duke    4-2   7-2   4-1   3-1   297   117  
#>  6 11      CONFERENCE 6              Clemson 4-2   6-3   3-2   3-1   204   186  
#>  7 11      CONFERENCE 7              Pittsb… 3-3   6-3   5-1   1-2   287   178  
#>  8 11      CONFERENCE 8              Virgin… 3-3   6-3   3-1   3-2   308   215  
#>  9 11      CONFERENCE 9              North … 2-3   5-4   1-3   3-1   244   205  
#> 10 11      CONFERENCE 10             Florid… 2-4   4-5   3-2   1-3   276   255  
#> 11 11      CONFERENCE 11             Boston… 2-4   4-5   3-2   1-3   197   243  
#> 12 11      CONFERENCE 12             NC Sta… 2-4   4-5   4-2   0-3   260   248  
#> 13 11      CONFERENCE 13             Virgin… 2-4   4-5   4-1   0-3   233   208  
#> 14 11      CONFERENCE 14             Stanfo… 2-4   4-5   4-1   0-4   183   336  
#> 15 11      CONFERENCE 15             Califo… 2-4   3-6   2-3   1-3   197   284  
#> 16 11      CONFERENCE 16             Syracu… 2-5   4-5   2-3   2-2   264   229  
#> 17 11      CONFERENCE 17             Georgi… 1-5   2-7   2-4   0-3   215   290  
#> # ℹ 2 more variables: strk <chr>, entity_id <chr>
# }
```
