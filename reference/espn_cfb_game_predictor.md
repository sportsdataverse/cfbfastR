# **ESPN College Football Game Predictor (BPI Matchup Predictor)**

Get ESPN's pre-game matchup predictor (Football Power Index game
projection) for a single college football game.

## Usage

``` r
espn_cfb_game_predictor(game_id = NULL, team_detail = TRUE)
```

## Arguments

- game_id:

  (*Integer* required): ESPN game identifier for a completed game.

- team_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN team catalog once
  and join friendly team fields next to the `team_id` column (see
  *Details*). Set `FALSE` to skip the catalog fetch and the join.

## Value

A data frame with one row per team-predictor metric:

|  |  |  |
|----|----|----|
| col_name | types | description |
| game_id | character | ESPN game identifier. |
| matchup_name | character | Predictor matchup name (e.g. `TNTC at Georgia`). |
| matchup_short_name | character | Short predictor matchup name (e.g. `TNTC @ UGA`). |
| last_modified | character | ISO timestamp the predictor was last run. |
| team_side | character | `home` or `away`. |
| team_id | character | ESPN team id (parsed from `team_ref`). |
| team_name | character | Team nickname; `team_detail = TRUE` only. |
| team_abbreviation | character | Team abbreviation; `team_detail = TRUE` only. |
| team_location | character | Team location / school name; `team_detail = TRUE` only. |
| team_display_name | character | Full team display name; `team_detail = TRUE` only. |
| team_short_display_name | character | Short team display name; `team_detail = TRUE` only. |
| team_nickname | character | Team nickname label; `team_detail = TRUE` only. |
| team_color | character | Primary team color; `team_detail = TRUE` only. |
| team_alternate_color | character | Alternate team color; `team_detail = TRUE` only. |
| team_logo_href | character | Default team logo URL; `team_detail = TRUE` only. |
| team_logo_dark_href | character | Dark-variant team logo URL; `team_detail = TRUE` only. |
| stat_name | character | Predictor metric key (e.g. `gameProjection`). |
| abbreviation | character | Metric abbreviation. |
| display_name | character | Human-readable metric name. |
| short_display_name | character | Short human-readable metric name. |
| value | numeric | Metric value. |
| display_value | character | Display-formatted metric value as shown on ESPN. |
| description | character | ESPN's description of the metric. |
| team_ref | character | `$ref` URL to the team-in-season resource. |

## Details

Wraps the ESPN core-v2 endpoint
`events/{game_id}/competitions/{game_id}/predictor`. ESPN's predictor
resource carries one statistics block per team (home and away); this
wrapper flattens both into one long frame – one row per (team x
predictor metric). Metrics include each team's projected win probability
(`gameProjection`), predicted point total, and matchup-quality scores.

This endpoint responds `HTTP 400` for future / not-yet-scheduled games
and is only reliably populated for **completed** games. The `@examples`
use a finished game; pass `game_id` values for completed games.

When `team_detail = TRUE` (the default) the ESPN team catalog
([`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md))
is fetched once and friendly team fields are joined in next to the
`team_id` column – `team_name`, `team_abbreviation`, `team_location`,
`team_display_name`, `team_short_display_name`, `team_nickname`,
`team_color`, `team_alternate_color`, `team_logo_href`, and
`team_logo_dark_href`. A catalog failure degrades to `NA` rather than
erroring the wrapper. Set `team_detail = FALSE` to skip the catalog
fetch and the join.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_game_predictor(game_id = 401628339))
#> ── Game predictor data from ESPN ───────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:12:23 UTC
#> # A tibble: 34 × 24
#>    game_id   matchup_name     matchup_short_name last_modified team_side team_id
#>    <chr>     <chr>            <chr>              <chr>         <chr>     <chr>  
#>  1 401628339 Tennessee Tech … TNTC @ UGA         2025-01-21T1… home      61     
#>  2 401628339 Tennessee Tech … TNTC @ UGA         2025-01-21T1… home      61     
#>  3 401628339 Tennessee Tech … TNTC @ UGA         2025-01-21T1… home      61     
#>  4 401628339 Tennessee Tech … TNTC @ UGA         2025-01-21T1… home      61     
#>  5 401628339 Tennessee Tech … TNTC @ UGA         2025-01-21T1… home      61     
#>  6 401628339 Tennessee Tech … TNTC @ UGA         2025-01-21T1… home      61     
#>  7 401628339 Tennessee Tech … TNTC @ UGA         2025-01-21T1… home      61     
#>  8 401628339 Tennessee Tech … TNTC @ UGA         2025-01-21T1… home      61     
#>  9 401628339 Tennessee Tech … TNTC @ UGA         2025-01-21T1… home      61     
#> 10 401628339 Tennessee Tech … TNTC @ UGA         2025-01-21T1… home      61     
#> # ℹ 24 more rows
#> # ℹ 18 more variables: team_name <chr>, team_abbreviation <chr>,
#> #   team_location <chr>, team_display_name <chr>,
#> #   team_short_display_name <chr>, team_nickname <chr>, team_color <chr>,
#> #   team_alternate_color <chr>, team_logo_href <chr>,
#> #   team_logo_dark_href <chr>, stat_name <chr>, abbreviation <chr>,
#> #   display_name <chr>, short_display_name <chr>, value <dbl>, …
  try(espn_cfb_game_predictor(game_id = 401628339, team_detail = FALSE))
#> ── Game predictor data from ESPN ───────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:12:23 UTC
#> # A tibble: 34 × 14
#>    game_id   matchup_name     matchup_short_name last_modified team_side team_id
#>    <chr>     <chr>            <chr>              <chr>         <chr>     <chr>  
#>  1 401628339 Tennessee Tech … TNTC @ UGA         2025-01-21T1… home      61     
#>  2 401628339 Tennessee Tech … TNTC @ UGA         2025-01-21T1… home      61     
#>  3 401628339 Tennessee Tech … TNTC @ UGA         2025-01-21T1… home      61     
#>  4 401628339 Tennessee Tech … TNTC @ UGA         2025-01-21T1… home      61     
#>  5 401628339 Tennessee Tech … TNTC @ UGA         2025-01-21T1… home      61     
#>  6 401628339 Tennessee Tech … TNTC @ UGA         2025-01-21T1… home      61     
#>  7 401628339 Tennessee Tech … TNTC @ UGA         2025-01-21T1… home      61     
#>  8 401628339 Tennessee Tech … TNTC @ UGA         2025-01-21T1… home      61     
#>  9 401628339 Tennessee Tech … TNTC @ UGA         2025-01-21T1… home      61     
#> 10 401628339 Tennessee Tech … TNTC @ UGA         2025-01-21T1… home      61     
#> # ℹ 24 more rows
#> # ℹ 8 more variables: stat_name <chr>, abbreviation <chr>, display_name <chr>,
#> #   short_display_name <chr>, value <dbl>, display_value <chr>,
#> #   description <chr>, team_ref <chr>
# }
```
