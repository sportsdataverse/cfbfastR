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
#> ℹ Data updated: 2026-10-22 17:19:24 UTC
#> # A tibble: 75 × 7
#>    players v2             comp  gp    entity_id patt  att_g
#>    <chr>   <chr>          <chr> <chr> <chr>     <chr> <chr>
#>  1 1       B. Atkinson    189   7     236148    NA    NA   
#>  2 2       M. Alejado     180   7     222163    NA    NA   
#>  3 3       N. Kim         169   8     177780    NA    NA   
#>  4 4       E. Grunkemeyer 167   7     223282    NA    NA   
#>  5 5       C. Veltkamp    161   6     195564    NA    NA   
#>  6 6       M. Washington  155   7     234856    NA    NA   
#>  7 7       M. Johnson     154   7     179185    NA    NA   
#>  8 8       O. McCown      153   7     197171    NA    NA   
#>  9 9       J. Maiava      152   7     196106    NA    NA   
#> 10 10      S. Leavitt     148   7     212300    NA    NA   
#> # ℹ 65 more rows
# }
```
