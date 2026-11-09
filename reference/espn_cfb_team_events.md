# **ESPN College Football Team Season Event Log**

Get a college football team's full season event log – every game
(regular season and postseason) ESPN lists for the team-season.

## Usage

``` r
espn_cfb_team_events(team_id = NULL, year = NULL, team_detail = TRUE)
```

## Arguments

- team_id:

  (*Integer* required): ESPN team id.

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 1999

- team_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN team catalog once
  and join friendly team fields next to the `team_id` column (see
  *Details*). Set `FALSE` to skip the catalog fetch and the join.

## Value

A data frame with one row per game:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Season (4-digit year). |
| team_id | character | ESPN team id. |
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
| event_order | integer | Order of the game within the team's season event log. |
| game_id | character | ESPN game (event) id, parsed from `event_ref`. |
| event_ref | character | `$ref` URL to the core-v2 event resource. |

## Details

Wraps the ESPN core-v2 team events endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/teams/{team_id}/events`.
ESPN returns a `$ref` list – one reference per game – in core-v2's id
space, complementing the site-v2
[`espn_cfb_team_schedule()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_schedule.md).
This wrapper returns one row per game with `game_id` parsed from each
`$ref`; it does **not** dereference each game (feed the `game_id` values
to
[`espn_cfb_game_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_teams.md),
[`espn_cfb_game_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_pbp.md),
or the other `espn_cfb_game_*()` wrappers for hydrated game detail). The
`event_order` column preserves the order ESPN returns the games.

When `team_detail = TRUE` (the default) the ESPN team catalog
([`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md))
is fetched once and friendly team fields are joined in next to the
`team_id` column – `team_name`, `team_abbreviation`, `team_location`,
`team_display_name`, `team_short_display_name`, `team_nickname`,
`team_color`, `team_alternate_color`, `team_logo_href`, and
`team_logo_dark_href`, inserted immediately after `team_id`. A catalog
failure degrades to `NA` rather than erroring the wrapper. Set
`team_detail = FALSE` to skip the catalog fetch and the join.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_team_events(team_id = 61, year = 2024))
#> ── Team season event log from ESPN ─────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:13:19 UTC
#> # A tibble: 14 × 15
#>    season team_id team_name team_abbreviation team_location team_display_name
#>     <int> <chr>   <chr>     <chr>             <chr>         <chr>            
#>  1   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  2   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  3   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  4   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  5   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  6   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  7   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  8   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  9   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#> 10   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#> 11   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#> 12   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#> 13   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#> 14   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#> # ℹ 9 more variables: team_short_display_name <chr>, team_nickname <chr>,
#> #   team_color <chr>, team_alternate_color <chr>, team_logo_href <chr>,
#> #   team_logo_dark_href <chr>, event_order <int>, game_id <chr>,
#> #   event_ref <chr>
  try(espn_cfb_team_events(team_id = 61, year = 2024,
                           team_detail = FALSE))
#> ── Team season event log from ESPN ─────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:13:19 UTC
#> # A tibble: 14 × 5
#>    season team_id event_order game_id   event_ref                               
#>     <int> <chr>         <int> <chr>     <chr>                                   
#>  1   2024 61                1 401628323 http://sports.core.api.espn.com/v2/spor…
#>  2   2024 61                2 401628339 http://sports.core.api.espn.com/v2/spor…
#>  3   2024 61                3 401628354 http://sports.core.api.espn.com/v2/spor…
#>  4   2024 61                4 401628374 http://sports.core.api.espn.com/v2/spor…
#>  5   2024 61                5 401628381 http://sports.core.api.espn.com/v2/spor…
#>  6   2024 61                6 401628386 http://sports.core.api.espn.com/v2/spor…
#>  7   2024 61                7 401628398 http://sports.core.api.espn.com/v2/spor…
#>  8   2024 61                8 401628408 http://sports.core.api.espn.com/v2/spor…
#>  9   2024 61                9 401628414 http://sports.core.api.espn.com/v2/spor…
#> 10   2024 61               10 401628421 http://sports.core.api.espn.com/v2/spor…
#> 11   2024 61               11 401628430 http://sports.core.api.espn.com/v2/spor…
#> 12   2024 61               12 401628439 http://sports.core.api.espn.com/v2/spor…
#> 13   2024 61               13 401673469 http://sports.core.api.espn.com/v2/spor…
#> 14   2024 61               14 401677184 http://sports.core.api.espn.com/v2/spor…
# }
```
