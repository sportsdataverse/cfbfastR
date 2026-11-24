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
#> ℹ Data updated: 2026-11-24 14:28:48 UTC
#> # A tibble: 75 × 7
#>    players v2             comp  gp    entity_id patt  att_g
#>    <chr>   <chr>          <chr> <chr> <chr>     <chr> <chr>
#>  1 1       C. Veltkamp    306   11    195564    NA    NA   
#>  2 2       N. Fifita      280   11    197318    NA    NA   
#>  3 3       M. Alejado     271   11    222163    NA    NA   
#>  4 4       S. Leavitt     269   11    212300    NA    NA   
#>  5 5       D. Mensah      267   11    210786    NA    NA   
#>  6 6       D. Mestemaker  263   11    228850    NA    NA   
#>  7 7       E. Grunkemeyer 254   11    223282    NA    NA   
#>  8 8       M. Johnson     246   11    179185    NA    NA   
#>  9 9       J. Maiava      245   11    196106    NA    NA   
#> 10 10      B. Atkinson    242   9     236148    NA    NA   
#> # ℹ 65 more rows
# }
```
