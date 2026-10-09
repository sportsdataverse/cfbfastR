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
#> ℹ Data updated: 2026-10-09 05:37:45 UTC
#> # A tibble: 75 × 7
#>    players v2             comp  gp    entity_id patt  att_g
#>    <chr>   <chr>          <chr> <chr> <chr>     <chr> <chr>
#>  1 1       B. Atkinson    137   5     236148    NA    NA   
#>  2 2       M. Alejado     132   5     222163    NA    NA   
#>  3 3       J. Maiava      131   6     196106    NA    NA   
#>  4 4       E. Grunkemeyer 131   5     223282    NA    NA   
#>  5 5       C. Veltkamp    128   5     195564    NA    NA   
#>  6 6       N. Kim         127   6     177780    NA    NA   
#>  7 7       N. Fifita      124   5     197318    NA    NA   
#>  8 8       M. Washington  124   5     234856    NA    NA   
#>  9 9       M. Johnson     122   5     179185    NA    NA   
#> 10 10      T. Jackson     119   5     196773    NA    NA   
#> # ℹ 65 more rows
# }
```
