# **ESPN College Football Team Schedule**

Get a single college football team's full-season schedule – one row per
game with opponent, venue, broadcast, score, and result.

## Usage

``` r
espn_cfb_team_schedule(team_id = NULL, year = NULL, team_detail = TRUE)
```

## Arguments

- team_id:

  (*Integer* required): ESPN team id.

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 1999

- team_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN team catalog once
  and join friendly team fields next to every team-id column (`team_id`,
  `opponent_id`) in the output (see *Details*). Set `FALSE` to skip the
  catalog fetch and the join.

## Value

A data frame with one row per scheduled game:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Season (4-digit year). |
| team_id | character | ESPN team id queried. |
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
| game_id | character | ESPN event id. |
| game_date | character | Kickoff date-time (ISO 8601, UTC). |
| game_name | character | Full event name. |
| game_short_name | character | Short event name (e.g. `UTM @ UGA`). |
| season_type | integer | ESPN season type (2 = regular, 3 = postseason). |
| week | integer | Week number. |
| home_away | character | Whether the queried team is `home` or `away`. |
| team_score | numeric | Points scored by the queried team. |
| team_winner | logical | Whether the queried team won. |
| opponent_id | character | ESPN team id of the opponent. |
| opponent_team_name | character | Opponent team nickname; `team_detail = TRUE` only. |
| opponent_team_abbreviation | character | Opponent team abbreviation; `team_detail = TRUE` only. |
| opponent_team_location | character | Opponent team location / school; `team_detail = TRUE` only. |
| opponent_team_display_name | character | Opponent team full display name; `team_detail = TRUE` only. |
| opponent_team_short_display_name | character | Opponent team short display name; `team_detail = TRUE` only. |
| opponent_team_nickname | character | Opponent team nickname label; `team_detail = TRUE` only. |
| opponent_team_color | character | Opponent team primary color; `team_detail = TRUE` only. |
| opponent_team_alternate_color | character | Opponent team alternate color; `team_detail = TRUE` only. |
| opponent_team_logo_href | character | Opponent team default logo URL; `team_detail = TRUE` only. |
| opponent_team_logo_dark_href | character | Opponent team dark logo URL; `team_detail = TRUE` only. |
| opponent_name | character | Opponent display name. |
| opponent_abbr | character | Opponent abbreviation. |
| opponent_score | numeric | Points scored by the opponent. |
| neutral_site | logical | Whether the game is at a neutral site. |
| venue_name | character | Venue name. |
| venue_city | character | Venue city. |
| venue_state | character | Venue state. |
| attendance | integer | Reported attendance. |
| broadcast | character | Broadcast network short name. |
| status | character | Game status detail (e.g. `Final`). |
| completed | logical | Whether the game is completed. |

## Details

Wraps the ESPN site-v2 team schedule endpoint
`site.api.espn.com/apis/site/v2/sports/football/college-football/teams/{team_id}/schedule`.
Each row is one scheduled game from the requested team's perspective:
the `opponent_*` columns describe the other team, and `team_score` /
`opponent_score` / `team_winner` describe the outcome (scores are `NA`
for games that have not been played). Team ids are ESPN team identifiers
– enumerate them with
[`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md).

When `team_detail = TRUE` (the default) the ESPN team catalog
([`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md))
is fetched once and friendly team fields are joined onto every team-id
column the output carries – `team_id` and `opponent_id`. For each id
column `X_id` the friendly siblings `X_name`, `X_abbreviation`,
`X_location`, `X_display_name`, `X_short_display_name`, `X_nickname`,
`X_color`, `X_alternate_color`, `X_logo_href`, and `X_logo_dark_href`
are inserted immediately after it. A catalog failure degrades to `NA`
rather than erroring the wrapper. Set `team_detail = FALSE` to skip the
catalog fetch and the join.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_team_schedule(team_id = 61, year = 2024))
#> ── Team schedule from ESPN ─────────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 17:04:12 UTC
#> # A tibble: 13 × 43
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
#> # ℹ 37 more variables: team_short_display_name <chr>, team_nickname <chr>,
#> #   team_color <chr>, team_alternate_color <chr>, team_logo_href <chr>,
#> #   team_logo_dark_href <chr>, game_id <chr>, game_date <chr>, game_name <chr>,
#> #   game_short_name <chr>, season_type <int>, week <int>, home_away <chr>,
#> #   team_score <dbl>, team_winner <lgl>, opponent_id <chr>,
#> #   opponent_team_name <chr>, opponent_team_abbreviation <chr>,
#> #   opponent_team_location <chr>, opponent_team_display_name <chr>, …
  try(espn_cfb_team_schedule(team_id = 61, year = 2024,
                             team_detail = FALSE))
#> ── Team schedule from ESPN ─────────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 17:04:12 UTC
#> # A tibble: 13 × 23
#>    season team_id game_id  game_date game_name game_short_name season_type  week
#>     <int> <chr>   <chr>    <chr>     <chr>     <chr>                 <int> <int>
#>  1   2024 61      4016283… 2024-08-… Clemson … CLEM VS UGA               2     1
#>  2   2024 61      4016283… 2024-09-… Tennesse… TNTC @ UGA                2     2
#>  3   2024 61      4016283… 2024-09-… Georgia … UGA @ UK                  2     3
#>  4   2024 61      4016283… 2024-09-… Georgia … UGA @ ALA                 2     5
#>  5   2024 61      4016283… 2024-10-… Auburn T… AUB @ UGA                 2     6
#>  6   2024 61      4016283… 2024-10-… Mississi… MSST @ UGA                2     7
#>  7   2024 61      4016283… 2024-10-… Georgia … UGA @ TEX                 2     8
#>  8   2024 61      4016284… 2024-11-… Florida … FLA VS UGA                2    10
#>  9   2024 61      4016284… 2024-11-… Georgia … UGA @ MISS                2    11
#> 10   2024 61      4016284… 2024-11-… Tennesse… TENN @ UGA                2    12
#> 11   2024 61      4016284… 2024-11-… Massachu… MASS @ UGA                2    13
#> 12   2024 61      4016284… 2024-11-… Georgia … GT @ UGA                  2    14
#> 13   2024 61      4016734… 2024-12-… Georgia … UGA VS TEX                2    15
#> # ℹ 15 more variables: home_away <chr>, team_score <dbl>, team_winner <lgl>,
#> #   opponent_id <chr>, opponent_name <chr>, opponent_abbr <chr>,
#> #   opponent_score <dbl>, neutral_site <lgl>, venue_name <chr>,
#> #   venue_city <chr>, venue_state <chr>, attendance <int>, broadcast <chr>,
#> #   status <chr>, completed <lgl>
# }
```
