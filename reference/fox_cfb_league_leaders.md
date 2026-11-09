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
#> ℹ Data updated: 2026-11-09 21:13:43 UTC
#> # A tibble: 75 × 7
#>    players v2             comp  gp    entity_id patt  att_g
#>    <chr>   <chr>          <chr> <chr> <chr>     <chr> <chr>
#>  1 1       C. Veltkamp    244   9     195564    NA    NA   
#>  2 2       B. Atkinson    242   9     236148    NA    NA   
#>  3 3       M. Alejado     228   9     222163    NA    NA   
#>  4 4       N. Fifita      224   9     197318    NA    NA   
#>  5 5       S. Leavitt     215   9     212300    NA    NA   
#>  6 6       E. Grunkemeyer 215   9     223282    NA    NA   
#>  7 7       D. Mensah      212   9     210786    NA    NA   
#>  8 8       T. Jackson     211   9     196773    NA    NA   
#>  9 9       K. Jennings    209   9     195905    NA    NA   
#> 10 10      M. Johnson     208   9     179185    NA    NA   
#> # ℹ 65 more rows
# }
```
