# **ESPN College Football Game Power Index (Matchup FPI)**

Get ESPN's Football Power Index (FPI) matchup projections for both teams
in a single college football game, in long format.

## Usage

``` r
espn_cfb_game_powerindex(game_id = NULL, team_detail = TRUE)
```

## Arguments

- game_id:

  (*Integer* required): ESPN game identifier.

- team_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN team catalog once
  and join friendly team fields next to the `team_id` column (see
  *Details*). Set `FALSE` to skip the catalog fetch and the join.

## Value

A data frame with one row per team-metric:

|  |  |  |
|----|----|----|
| col_name | types | description |
| game_id | character | ESPN game identifier. |
| season | integer | Season (4-digit year) of the game. |
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
| stat_name | character | FPI metric key (e.g. `teampredptdiff`). |
| abbreviation | character | Metric abbreviation. |
| display_name | character | Human-readable metric name. |
| short_display_name | character | Short human-readable metric name. |
| value | numeric | Metric value. |
| display_value | character | Display-formatted metric value as shown on ESPN. |
| description | character | ESPN's description of the metric. |
| powerindex_ref | character | `$ref` URL to the per-team power-index resource. |
| team_ref | character | `$ref` URL to the team-in-season resource. |

## Details

Wraps the ESPN core-v2 endpoint
`events/{game_id}/competitions/{game_id}/powerindex`. The endpoint
returns one `$ref` per team; this wrapper dereferences each and flattens
the per-team `stats` array into one long frame – one row per (team x FPI
metric). Metrics include the predicted point differential, matchup
quality, and game-projection components ESPN derives from FPI for that
specific game. The long shape absorbs ESPN's habit of adding and
retiring metrics across seasons.

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
  try(espn_cfb_game_powerindex(game_id = 401628339))
#> ── Game power index data from ESPN ─────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 19:54:49 UTC
#> # A tibble: 8 × 22
#>   game_id   season team_id team_name     team_abbreviation team_location 
#>   <chr>      <int> <chr>   <chr>         <chr>             <chr>         
#> 1 401628339   2024 61      Bulldogs      UGA               Georgia       
#> 2 401628339   2024 61      Bulldogs      UGA               Georgia       
#> 3 401628339   2024 61      Bulldogs      UGA               Georgia       
#> 4 401628339   2024 61      Bulldogs      UGA               Georgia       
#> 5 401628339   2024 2635    Golden Eagles TNTC              Tennessee Tech
#> 6 401628339   2024 2635    Golden Eagles TNTC              Tennessee Tech
#> 7 401628339   2024 2635    Golden Eagles TNTC              Tennessee Tech
#> 8 401628339   2024 2635    Golden Eagles TNTC              Tennessee Tech
#> # ℹ 16 more variables: team_display_name <chr>, team_short_display_name <chr>,
#> #   team_nickname <chr>, team_color <chr>, team_alternate_color <chr>,
#> #   team_logo_href <chr>, team_logo_dark_href <chr>, stat_name <chr>,
#> #   abbreviation <chr>, display_name <chr>, short_display_name <chr>,
#> #   value <dbl>, display_value <chr>, description <chr>, powerindex_ref <chr>,
#> #   team_ref <chr>
  try(espn_cfb_game_powerindex(game_id = 401628339, team_detail = FALSE))
#> ── Game power index data from ESPN ─────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 19:54:49 UTC
#> # A tibble: 8 × 12
#>   game_id  season team_id stat_name abbreviation display_name short_display_name
#>   <chr>     <int> <chr>   <chr>     <chr>        <chr>        <chr>             
#> 1 4016283…   2024 61      teampred… PRED PT DIFF PRED PT DIFF NA                
#> 2 4016283…   2024 61      gameproj… GAME PROJ    WIN PROB     NA                
#> 3 4016283…   2024 61      matchupq… MATCHUP QUA… MATCHUP QUA… NA                
#> 4 4016283…   2024 61      teamadjg… TEAM ADJ GA… GAME SCORE   NA                
#> 5 4016283…   2024 2635    teampred… PRED PT DIFF PRED PT DIFF NA                
#> 6 4016283…   2024 2635    gameproj… GAME PROJ    WIN PROB     NA                
#> 7 4016283…   2024 2635    matchupq… MATCHUP QUA… MATCHUP QUA… NA                
#> 8 4016283…   2024 2635    teamadjg… TEAM ADJ GA… GAME SCORE   NA                
#> # ℹ 5 more variables: value <dbl>, display_value <chr>, description <chr>,
#> #   powerindex_ref <chr>, team_ref <chr>
# }
```
