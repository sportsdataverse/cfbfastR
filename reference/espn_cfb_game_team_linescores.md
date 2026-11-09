# **ESPN College Football Game Team Linescores**

Get the quarter-by-quarter linescores for both teams in a single college
football game.

## Usage

``` r
espn_cfb_game_team_linescores(game_id = NULL, team_detail = TRUE)
```

## Arguments

- game_id:

  (*Integer* required): ESPN game identifier.

- team_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN team catalog once
  and join friendly team fields next to the `team_id` column (see
  *Details*). Set `FALSE` to skip the catalog fetch and the join.

## Value

A data frame with one row per team-period:

|  |  |  |
|----|----|----|
| col_name | types | description |
| game_id | character | ESPN game identifier. |
| team_id | character | ESPN team id for the team. |
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
| home_away | character | `home` or `away`. |
| period | integer | Period number (1-4 quarters; 5+ overtime). |
| value | numeric | Points scored by the team in that period. |
| display_value | character | Display-formatted period score. |
| source_id | character | ESPN data-source id for the linescore. |
| source_state | character | ESPN data-source state (e.g. `full`). |
| source_description | character | ESPN data-source description (e.g. `Basic/Manual`). |
| linescore_ref | character | `$ref` URL to the per-period linescore resource. |

## Details

Wraps the ESPN core-v2 endpoint
`events/{game_id}/competitions/{game_id}/competitors/{team_id}/linescores`.
This wrapper first reads the teams list for the game and then fetches
the linescores resource for **both** teams, stacking the results into
one long frame – one row per (team x period). `home_away` identifies
which team a row belongs to. Periods 1-4 are quarters; periods 5+ are
overtime sessions.

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
  try(espn_cfb_game_team_linescores(game_id = 401628339))
#> ── Game team linescores data from ESPN ─────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:12:27 UTC
#> # A tibble: 8 × 20
#>   game_id   team_id team_name  team_abbreviation team_location team_display_name
#>   <chr>     <chr>   <chr>      <chr>             <chr>         <chr>            
#> 1 401628339 61      Bulldogs   UGA               Georgia       Georgia Bulldogs 
#> 2 401628339 61      Bulldogs   UGA               Georgia       Georgia Bulldogs 
#> 3 401628339 61      Bulldogs   UGA               Georgia       Georgia Bulldogs 
#> 4 401628339 61      Bulldogs   UGA               Georgia       Georgia Bulldogs 
#> 5 401628339 2635    Golden Ea… TNTC              Tennessee Te… Tennessee Tech G…
#> 6 401628339 2635    Golden Ea… TNTC              Tennessee Te… Tennessee Tech G…
#> 7 401628339 2635    Golden Ea… TNTC              Tennessee Te… Tennessee Tech G…
#> 8 401628339 2635    Golden Ea… TNTC              Tennessee Te… Tennessee Tech G…
#> # ℹ 14 more variables: team_short_display_name <chr>, team_nickname <chr>,
#> #   team_color <chr>, team_alternate_color <chr>, team_logo_href <chr>,
#> #   team_logo_dark_href <chr>, home_away <chr>, period <int>, value <dbl>,
#> #   display_value <chr>, source_id <chr>, source_state <chr>,
#> #   source_description <chr>, linescore_ref <chr>
  try(espn_cfb_game_team_linescores(game_id = 401628339,
                                    team_detail = FALSE))
#> ── Game team linescores data from ESPN ─────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:12:27 UTC
#> # A tibble: 8 × 10
#>   game_id   team_id home_away period value display_value source_id source_state
#>   <chr>     <chr>   <chr>      <int> <dbl> <chr>         <chr>     <chr>       
#> 1 401628339 61      home           1    14 14            1         NA          
#> 2 401628339 61      home           2    10 10            1         NA          
#> 3 401628339 61      home           3    21 21            1         NA          
#> 4 401628339 61      home           4     3 3             1         NA          
#> 5 401628339 2635    away           1     0 0             1         NA          
#> 6 401628339 2635    away           2     0 0             1         NA          
#> 7 401628339 2635    away           3     0 0             1         NA          
#> 8 401628339 2635    away           4     3 3             1         NA          
#> # ℹ 2 more variables: source_description <chr>, linescore_ref <chr>
# }
```
