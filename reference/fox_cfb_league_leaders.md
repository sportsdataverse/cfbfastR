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
#> ℹ Data updated: 2026-11-01 03:16:57 UTC
#> # A tibble: 75 × 7
#>    players v2             comp  gp    entity_id patt  att_g
#>    <chr>   <chr>          <chr> <chr> <chr>     <chr> <chr>
#>  1 1       C. Veltkamp    227   8     195564    NA    NA   
#>  2 2       M. Alejado     202   8     222163    NA    NA   
#>  3 3       T. Jackson     193   8     196773    NA    NA   
#>  4 4       B. Atkinson    189   7     236148    NA    NA   
#>  5 5       E. Grunkemeyer 187   8     223282    NA    NA   
#>  6 6       J. Maiava      183   8     196106    NA    NA   
#>  7 7       S. Leavitt     180   8     212300    NA    NA   
#>  8 8       J. Richter     173   8     195796    NA    NA   
#>  9 9       N. Kim         169   8     177780    NA    NA   
#> 10 10      O. McCown      169   8     197171    NA    NA   
#> # ℹ 65 more rows
# }
```
