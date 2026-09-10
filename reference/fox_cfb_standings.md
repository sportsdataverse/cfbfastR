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
#> ℹ Data updated: 2026-09-10 05:49:09 UTC
#> # A tibble: 17 × 12
#>    team_id section    atlantic_coast v2      conf  w_l   home  away  pf    pa   
#>    <chr>   <chr>      <chr>          <chr>   <chr> <chr> <chr> <chr> <chr> <chr>
#>  1 11      CONFERENCE 1              Miami … 1-0   1-0   0-0   1-0   45    6    
#>  2 11      CONFERENCE 2              Virgin… 1-0   1-0   1-0   0-0   34    8    
#>  3 11      CONFERENCE 3              SMU     1-0   1-0   0-0   1-0   27    24   
#>  4 11      CONFERENCE 4              Duke    0-0   1-0   1-0   0-0   17    3    
#>  5 11      CONFERENCE 5              North … 0-0   1-0   0-0   0-0   15    10   
#>  6 11      CONFERENCE 6              Wake F… 0-0   1-0   1-0   0-0   38    16   
#>  7 11      CONFERENCE 7              Pittsb… 0-0   1-0   1-0   0-0   59    14   
#>  8 11      CONFERENCE 8              Syracu… 0-0   1-0   1-0   0-0   66    3    
#>  9 11      CONFERENCE 9              Virgin… 0-0   1-0   1-0   0-0   73    3    
#> 10 11      CONFERENCE 10             Clemson 0-0   0-1   0-0   0-1   10    51   
#> 11 11      CONFERENCE 11             Georgi… 0-0   0-1   0-1   0-0   13    14   
#> 12 11      CONFERENCE 12             Boston… 0-0   0-1   0-0   0-1   15    34   
#> 13 11      CONFERENCE 13             Louisv… 0-0   0-1   0-0   0-0   38    41   
#> 14 11      CONFERENCE 14             Califo… 0-0   0-1   0-1   0-0   24    45   
#> 15 11      CONFERENCE 15             Florid… 0-1   1-1   1-1   0-0   58    44   
#> 16 11      CONFERENCE 16             Stanfo… 0-1   1-1   1-1   0-0   43    72   
#> 17 11      CONFERENCE 17             NC Sta… 0-1   0-1   0-0   0-1   8     34   
#> # ℹ 2 more variables: strk <chr>, entity_id <chr>
# }
```
