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
#> ℹ Data updated: 2026-09-26 06:51:36 UTC
#> # A tibble: 17 × 12
#>    team_id section    atlantic_coast v2      conf  w_l   home  away  pf    pa   
#>    <chr>   <chr>      <chr>          <chr>   <chr> <chr> <chr> <chr> <chr> <chr>
#>  1 11      CONFERENCE 1              Miami … 2-0   3-0   1-0   2-0   155   33   
#>  2 11      CONFERENCE 2              Clemson 2-0   2-1   2-0   1-1   84    88   
#>  3 11      CONFERENCE 3              Duke    1-0   3-0   2-0   1-0   83    37   
#>  4 11      CONFERENCE 4              Pittsb… 1-0   3-0   3-0   0-0   98    34   
#>  5 11      CONFERENCE 5              Louisv… 1-0   2-1   2-0   0-0   138   85   
#>  6 11      CONFERENCE 6              Virgin… 1-0   2-1   2-0   0-0   120   49   
#>  7 11      CONFERENCE 7              SMU     1-1   2-1   1-0   1-1   114   75   
#>  8 11      CONFERENCE 8              Califo… 1-1   2-1   1-2   1-0   104   94   
#>  9 11      CONFERENCE 9              Virgin… 0-0   3-0   2-0   1-0   152   50   
#> 10 11      CONFERENCE 10             Boston… 0-0   2-1   2-0   0-1   65    71   
#> 11 11      CONFERENCE 11             Georgi… 0-0   1-2   1-2   0-0   81    70   
#> 12 11      CONFERENCE 12             North … 0-1   2-1   1-0   0-1   70    41   
#> 13 11      CONFERENCE 13             Wake F… 0-1   2-1   1-1   1-0   96    85   
#> 14 11      CONFERENCE 14             Florid… 0-1   1-2   1-1   0-1   94    94   
#> 15 11      CONFERENCE 15             NC Sta… 0-1   1-2   1-0   0-2   112   69   
#> 16 11      CONFERENCE 16             Syracu… 0-2   1-2   1-1   0-1   97    51   
#> 17 11      CONFERENCE 17             Stanfo… 0-2   1-2   1-1   0-1   50    107  
#> # ℹ 2 more variables: strk <chr>, entity_id <chr>
# }
```
