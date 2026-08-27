# Get ESPN college football PBP data

Get ESPN college football PBP data

## Usage

``` r
espn_cfb_pbp(game_id, epa_wpa = FALSE, engine = NULL, output = "default")
```

## Arguments

- game_id:

  Game ID

- epa_wpa:

  Logical parameter (TRUE/FALSE) to return the Expected Points Added/Win
  Probability Added variables

- engine:

  (*Character* optional): which play-by-play engine to run. One of
  `"v2"`, `"legacy"` or `"auto"`; `NULL` (default) resolves from
  `getOption("cfbfastR.pbp_engine")`, which itself defaults to `"v2"` as
  of this release. `"legacy"` is the escape hatch that reproduces the
  pre-2.3.0 frame; `"auto"` means whatever this version of the package
  considers current, so it is carried forward by future default flips.

- output:

  (*Character*): modeled-output column set, one of `"default"`, `"lean"`
  or `"full"`. Only meaningful when the call reaches the v2 engine; it
  is accepted here so a delegating caller can reach the tier selector
  without switching to the
  [`espn_cfb_pbp_v2()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp_v2.md)
  name.

## Value

A data frame with college football play-by-play data

## Author

Saiem Gilani

## Examples

``` r
 # \donttest{
   try(espn_cfb_pbp(game_id = 401282614, epa_wpa = TRUE))
#> ── Play-by-play data from ESPN (core-v2) ───────────────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-27 10:59:24 UTC
#> # A tibble: 196 × 510
#>    season id_play    game_id game_play_number half_play_number drive_play_number
#>     <int> <chr>      <chr>              <dbl>            <dbl>             <dbl>
#>  1   2021 401282614… 401282…                1                1                 1
#>  2   2021 401282614… 401282…                2                2                 2
#>  3   2021 401282614… 401282…                2                2                 2
#>  4   2021 401282614… 401282…                3                3                 3
#>  5   2021 401282614… 401282…                4                4                 4
#>  6   2021 401282614… 401282…                5                5                 5
#>  7   2021 401282614… 401282…                6                7                 2
#>  8   2021 401282614… 401282…                7                6                 1
#>  9   2021 401282614… 401282…                8                8                 3
#> 10   2021 401282614… 401282…                8                8                 3
#> # ℹ 186 more rows
#> # ℹ 504 more variables: pos_team <chr>, def_pos_team <chr>,
#> #   pos_team_score <int>, def_pos_team_score <int>, half <fct>, period <int>,
#> #   clock_minutes <dbl>, clock_seconds <dbl>, play_type <chr>, play_text <chr>,
#> #   down <dbl>, distance <dbl>, yards_to_goal <dbl>, yards_gained <dbl>,
#> #   EPA <dbl>, ep_before <dbl>, ep_after <dbl>, wpa <dbl>, wp_before <dbl>,
#> #   wp_after <dbl>, def_wp_before <dbl>, def_wp_after <dbl>, …
 # }
```
