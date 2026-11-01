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
#> ── Statistical leaders from Fox Sports (Bifrost) ───────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-01 23:01:04 UTC
#> # A tibble: 75 × 7
#>    players v2             comp  gp    entity_id patt  att_g
#>    <chr>   <chr>          <chr> <chr> <chr>     <chr> <chr>
#>  1 1       C. Veltkamp    227   8     195564    NA    NA   
#>  2 2       B. Atkinson    222   8     236148    NA    NA   
#>  3 3       M. Alejado     202   8     222163    NA    NA   
#>  4 4       N. Fifita      200   8     197318    NA    NA   
#>  5 5       J. Maiava      198   9     196106    NA    NA   
#>  6 6       T. Jackson     193   8     196773    NA    NA   
#>  7 7       M. Johnson     190   8     179185    NA    NA   
#>  8 8       T. Chambliss   189   8     238651    NA    NA   
#>  9 9       D. Mensah      188   8     210786    NA    NA   
#> 10 10      E. Grunkemeyer 187   8     223282    NA    NA   
#> # ℹ 65 more rows
# }
```
