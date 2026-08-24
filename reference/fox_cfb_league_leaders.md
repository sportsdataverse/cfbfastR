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
#> ── Statistical leaders from Fox Sports (Bifrost) ───────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-24 12:12:50 UTC
#> # A tibble: 75 × 7
#>    players v2              comp  gp    entity_id patt  att_g
#>    <chr>   <chr>           <chr> <chr> <chr>     <chr> <chr>
#>  1 1       C. Veltkamp     345   12    195564    NA    NA   
#>  2 2       C. Beck         338   16    179027    NA    NA   
#>  3 3       D. Mensah       334   14    210786    NA    NA   
#>  4 4       J. Raynor       333   13    211545    NA    NA   
#>  5 5       N. Minicucci    322   13    213460    NA    NA   
#>  6 6       D. Mestemaker   319   14    228850    NA    NA   
#>  7 7       J. Sagapolutele 316   13    233429    NA    NA   
#>  8 8       T. Simpson      305   15    196603    NA    NA   
#>  9 9       S. Robertson    304   12    187338    NA    NA   
#> 10 10      J. Sayin        301   14    223080    NA    NA   
#> # ℹ 65 more rows
# }
```
