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
#> ℹ Data updated: 2026-09-19 04:13:22 UTC
#> # A tibble: 17 × 12
#>    team_id section    atlantic_coast v2      conf  w_l   home  away  pf    pa   
#>    <chr>   <chr>      <chr>          <chr>   <chr> <chr> <chr> <chr> <chr> <chr>
#>  1 11      CONFERENCE 1              Miami … 2-0   3-0   1-0   2-0   155   33   
#>  2 11      CONFERENCE 2              Pittsb… 1-0   3-0   3-0   0-0   98    34   
#>  3 11      CONFERENCE 3              Virgin… 1-0   2-0   2-0   0-0   93    11   
#>  4 11      CONFERENCE 4              SMU     1-0   2-0   1-0   1-0   83    34   
#>  5 11      CONFERENCE 5              Califo… 1-0   1-1   0-1   1-0   45    63   
#>  6 11      CONFERENCE 6              Duke    0-0   2-0   1-0   1-0   48    30   
#>  7 11      CONFERENCE 7              North … 0-0   2-0   1-0   0-0   50    13   
#>  8 11      CONFERENCE 8              Virgin… 0-0   2-0   2-0   0-0   117   24   
#>  9 11      CONFERENCE 9              Clemson 0-0   1-1   1-0   0-1   32    58   
#> 10 11      CONFERENCE 10             Boston… 0-0   1-1   1-0   0-1   43    55   
#> 11 11      CONFERENCE 11             Louisv… 0-0   1-1   1-0   0-0   97    54   
#> 12 11      CONFERENCE 12             Georgi… 0-0   0-2   0-2   0-0   37    59   
#> 13 11      CONFERENCE 13             Wake F… 0-1   2-1   1-1   1-0   96    85   
#> 14 11      CONFERENCE 14             Florid… 0-1   1-1   1-1   0-0   58    44   
#> 15 11      CONFERENCE 15             NC Sta… 0-1   1-1   1-0   0-1   81    34   
#> 16 11      CONFERENCE 16             Stanfo… 0-1   1-1   1-1   0-0   43    72   
#> 17 11      CONFERENCE 17             Syracu… 0-2   1-2   1-1   0-1   97    51   
#> # ℹ 2 more variables: strk <chr>, entity_id <chr>
# }
```
