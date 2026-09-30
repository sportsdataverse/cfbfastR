# **Get Fox Sports college football statistical leaders**

Flattens a Bifrost `league/stats-con/{who}/{category}/{page}`
leaderboard table.

## Usage

``` r
fox_cfb_league_leaders(
  category = "passing",
  who = "player",
  page = 0,
  group_id = "2"
)
```

## Arguments

- category:

  (character): Stat category. One of `passing`, `rushing`, `receiving`,
  `defense`, `kicking`, `returning`, `scoring`, `yardage` (team adds
  `downs`, `turnovers`). Defaults to `"passing"`.

- who:

  (character): `"player"` or `"team"`. Defaults to `"player"`.

- page:

  (integer): 0-based page index. Defaults to `0`.

- group_id:

  (character): Conference/group filter id. Defaults to `"2"` (FBS).

## Value

A `cfbfastR`-tagged tibble with one row per player/team; columns are the
leaderboard headers plus `entity_id`.

## Examples

``` r
# \donttest{
  try(fox_cfb_league_leaders(category = "passing"))
#> ── Statistical leaders from Fox Sports (Bifrost) ──────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-09-30 19:44:23 UTC
#> # A tibble: 75 × 7
#>    players v2             comp  gp    entity_id patt  att_g
#>    <chr>   <chr>          <chr> <chr> <chr>     <chr> <chr>
#>  1 1       C. Veltkamp    114   4     195564    NA    NA   
#>  2 2       J. Maiava      110   5     196106    NA    NA   
#>  3 3       M. Alejado     109   4     222163    NA    NA   
#>  4 4       N. Kim         106   5     177780    NA    NA   
#>  5 5       B. Atkinson    106   4     236148    NA    NA   
#>  6 6       M. Johnson     104   4     179185    NA    NA   
#>  7 7       T. Chambliss   102   4     238651    NA    NA   
#>  8 8       E. Grunkemeyer 101   4     223282    NA    NA   
#>  9 9       M. Washington  101   4     234856    NA    NA   
#> 10 10      N. Fifita      99    4     197318    NA    NA   
#> # ℹ 65 more rows
# }
```
