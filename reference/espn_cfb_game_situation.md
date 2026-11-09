# **ESPN College Football Game Situation**

Get the current (or final) game situation for a single college football
game – down, distance, yard line, red-zone flag, timeouts, and a `$ref`
to the last play.

## Usage

``` r
espn_cfb_game_situation(game_id = NULL)
```

## Arguments

- game_id:

  (*Integer* required): ESPN game identifier.

## Value

A data frame with one row describing the game situation:

|  |  |  |
|----|----|----|
| col_name | types | description |
| game_id | character | ESPN game identifier. |
| down | integer | Current down. |
| distance | integer | Yards to go for a first down. |
| yard_line | integer | Current yard line. |
| is_red_zone | logical | `TRUE` if the offense is in the red zone. |
| home_timeouts | integer | Home-team timeouts remaining. |
| away_timeouts | integer | Away-team timeouts remaining. |
| last_play_id | character | ESPN play id of the last play (parsed from `last_play_ref`). |
| situation_ref | character | `$ref` URL to the situation resource itself. |
| last_play_ref | character | `$ref` URL to the last-play resource. |

## Details

Wraps the ESPN core-v2 endpoint
`events/{game_id}/competitions/{game_id}/situation`. The competition id
always equals the game id. Returns a single-row data frame describing
the live game situation. For an in-progress game this is the current
state; for a completed game it is static – the final play state. The
`last_play_ref` column is the `$ref` URL to the last play; parse its id
and pass it to
[`espn_cfb_game_play()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_pbp.md)
for the full play detail.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_game_situation(game_id = 401628339))
#> ── Game situation data from ESPN ───────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:12:25 UTC
#> # A tibble: 1 × 10
#>   game_id    down distance yard_line is_red_zone home_timeouts away_timeouts
#>   <chr>     <int>    <int>     <int> <lgl>               <int>         <int>
#> 1 401628339     0        0        65 FALSE                   3             3
#> # ℹ 3 more variables: last_play_id <chr>, situation_ref <chr>,
#> #   last_play_ref <chr>
# }
```
