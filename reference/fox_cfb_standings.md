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
#> ── Standings data from Fox Sports (Bifrost) ────────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-06-12 22:28:00 UTC
#> # A tibble: 17 × 12
#>    team_id section    atlantic_coast v2      conf  w_l   home  away  pf    pa   
#>    <chr>   <chr>      <chr>          <chr>   <chr> <chr> <chr> <chr> <chr> <chr>
#>  1 11      CONFERENCE 1              Virgin… 7-1   11-3  6-1   4-1   431   274  
#>  2 11      CONFERENCE 2              Miami … 6-2   13-3  7-1   4-1   495   237  
#>  3 11      CONFERENCE 3              Georgi… 6-2   9-4   5-1   4-1   418   325  
#>  4 11      CONFERENCE 4              SMU     6-2   9-4   5-1   3-3   419   267  
#>  5 11      CONFERENCE 5              Duke    6-2   9-5   3-3   4-2   484   412  
#>  6 11      CONFERENCE 6              Pittsb… 6-2   8-5   4-3   4-1   438   322  
#>  7 11      CONFERENCE 7              Louisv… 4-4   9-4   5-3   3-1   389   275  
#>  8 11      CONFERENCE 8              Wake F… 4-4   9-4   5-2   3-2   365   287  
#>  9 11      CONFERENCE 9              North … 4-4   8-5   6-1   1-4   393   353  
#> 10 11      CONFERENCE 10             Clemson 4-4   7-6   3-4   4-1   354   267  
#> 11 11      CONFERENCE 11             Califo… 4-4   7-6   4-2   3-4   329   353  
#> 12 11      CONFERENCE 12             Stanfo… 3-5   4-8   4-2   0-6   226   350  
#> 13 11      CONFERENCE 13             Florid… 2-6   5-7   5-2   0-5   396   264  
#> 14 11      CONFERENCE 14             North … 2-6   4-8   2-4   2-4   231   294  
#> 15 11      CONFERENCE 15             Virgin… 2-6   3-9   2-5   1-3   257   362  
#> 16 11      CONFERENCE 16             Syracu… 1-7   3-9   2-4   1-4   242   419  
#> 17 11      CONFERENCE 17             Boston… 1-7   2-10  1-6   1-4   305   393  
#> # ℹ 2 more variables: strk <chr>, entity_id <chr>
# }
```
