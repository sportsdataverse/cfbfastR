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
#> ℹ Data updated: 2026-09-19 04:13:20 UTC
#> # A tibble: 75 × 7
#>    players v2            comp  gp    entity_id patt  att_g
#>    <chr>   <chr>         <chr> <chr> <chr>     <chr> <chr>
#>  1 1       M. Alejado    81    3     222163    NA    NA   
#>  2 2       N. Kim        67    3     177780    NA    NA   
#>  3 3       J. Maiava     67    3     196106    NA    NA   
#>  4 4       L. Weaver     66    3     234098    NA    NA   
#>  5 5       C. Veltkamp   61    2     195564    NA    NA   
#>  6 6       B. Atkinson   60    2     236148    NA    NA   
#>  7 7       M. Heintschel 59    3     233501    NA    NA   
#>  8 8       S. Angeli     57    3     196426    NA    NA   
#>  9 9       T. Hedden     56    3     224744    NA    NA   
#> 10 10      M. Johnson    55    2     179185    NA    NA   
#> # ℹ 65 more rows
# }
```
