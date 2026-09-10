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
#> ℹ Data updated: 2026-09-10 05:49:05 UTC
#> # A tibble: 75 × 7
#>    players v2          comp  gp    entity_id patt  att_g
#>    <chr>   <chr>       <chr> <chr> <chr>     <chr> <chr>
#>  1 1       N. Kim      51    2     177780    NA    NA   
#>  2 2       J. Maiava   48    2     196106    NA    NA   
#>  3 3       M. Alejado  48    2     222163    NA    NA   
#>  4 4       L. Weaver   44    2     234098    NA    NA   
#>  5 5       D. Warren   43    2     190846    NA    NA   
#>  6 6       T. Hedden   37    2     224744    NA    NA   
#>  7 7       C. Veltkamp 34    1     195564    NA    NA   
#>  8 8       J. Arnold   33    2     212936    NA    NA   
#>  9 9       C. Creel    33    2     216004    NA    NA   
#> 10 10      N. Hayes    32    2     197934    NA    NA   
#> # ℹ 65 more rows
# }
```
