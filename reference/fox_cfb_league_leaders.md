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
#> ℹ Data updated: 2026-09-03 22:40:37 UTC
#> # A tibble: 57 × 7
#>    players v2         comp  gp    entity_id patt  att_g
#>    <chr>   <chr>      <chr> <chr> <chr>     <chr> <chr>
#>  1 1       M. Alejado 31    1     222163    NA    NA   
#>  2 2       N. Kim     27    1     177780    NA    NA   
#>  3 3       T. Hedden  26    1     224744    NA    NA   
#>  4 4       J. Maiava  25    1     196106    NA    NA   
#>  5 5       J. Arnold  25    1     212936    NA    NA   
#>  6 6       C. Conklin 25    1     213761    NA    NA   
#>  7 7       D. Warren  22    1     190846    NA    NA   
#>  8 8       L. Weaver  21    1     234098    NA    NA   
#>  9 9       J. Craig   20    1     203006    NA    NA   
#> 10 10      A. Daniels 17    1     197201    NA    NA   
#> # ℹ 47 more rows
# }
```
