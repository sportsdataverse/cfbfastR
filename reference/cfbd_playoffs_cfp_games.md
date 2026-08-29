# **Get College Football Playoff games**

**Get College Football Playoff games** Returns the games played in the
College Football Playoff for a season.

## Usage

``` r
cfbd_playoffs_cfp_games(year, round = NULL, proxy = NULL)
```

## Arguments

- year:

  (*Integer* required): Season, 4 digits (YYYY).  
  Minimum value accepted: 2014

- round:

  (*String* optional): `first_round`, `quarterfinal`, `semifinal` or
  `championship`.

- proxy:

  (*List* optional): Per-call proxy override passed to `get_req()`.
  `NULL` (default) falls back to `getOption("cfbfastR.proxy")` and then
  the `http(s)_proxy` environment variables, so a caller can override
  the shared setting for one endpoint.

## Value

`cfbd_playoffs_cfp_games()` - A tibble with 34 columns:

|  |  |  |
|----|----|----|
| col_name | types | description |
| id | integer | Record identifier. |
| bracket_slot | character | Bracket position code for the matchup (e.g. `FR1`, `QF2`). |
| round | character | Playoff round code. |
| round_name | character | Human-readable playoff round name. |
| round_order | integer | Ordinal position of the round in the bracket. |
| matchup_order | integer | Ordinal position of the matchup within its round. |
| start_date | character | Scheduled start date and time (ISO 8601). |
| bowl_name | character | Bowl or site name hosting the matchup. |
| game_id | integer | Referencing game id. |
| game_start_date | character | Game scheduled start date and time (ISO 8601). |
| game_completed | logical | Game completion flag. |
| game_home_points | integer | Game home points. |
| game_away_points | integer | Game away points. |
| game_venue_id | integer | Game referencing venue id. |
| game_venue | character | Game venue name. |
| game_home_team_id | integer | Home team identifier. |
| game_home_team_school | character | Home team school name. |
| game_home_team_conference | character | Home team conference. |
| game_away_team_id | integer | Away team identifier. |
| game_away_team_school | character | Away team school name. |
| game_away_team_conference | character | Away team conference. |
| advances_to_matchup_id | integer | Next-matchup matchup id. |
| advances_to_bracket_slot | character | Next-matchup bracket position code for the matchup (e.g. `FR1`, `QF2`). |
| advances_to_position | integer | Next-matchup bracket position. |
| slot1_position | integer | First bracket slot bracket position. |
| slot1_seed | integer | First bracket slot seed. |
| slot1_team_id | integer | First bracket slot referencing team id. |
| slot1_school | character | First bracket slot school name. |
| slot1_conference | character | First bracket slot conference. |
| slot2_position | integer | Second bracket slot bracket position. |
| slot2_seed | integer | Second bracket slot seed. |
| slot2_team_id | integer | Second bracket slot referencing team id. |
| slot2_school | character | Second bracket slot school name. |
| slot2_conference | character | Second bracket slot conference. |

## See also

Other CFBD Playoff Functions:
[`cfbd_playoffs_cfp()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_playoffs_cfp.md),
[`cfbd_playoffs_cfp_participants()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_playoffs_cfp_participants.md)

## Examples

``` r
# \donttest{
  try(cfbd_playoffs_cfp_games(year = 2024))
#> ── Get College Football Playoff games from CollegeFootballData.com ─────────────
#> ℹ Data updated: 2026-08-29 13:12:05 UTC
#> # A tibble: 11 × 34
#>       id bracket_slot round      round_name round_order matchup_order start_date
#>    <int> <chr>        <chr>      <chr>            <int>         <int> <chr>     
#>  1    31 FR1          first_rou… First Rou…           1             1 2024-12-2…
#>  2    32 FR2          first_rou… First Rou…           1             2 2024-12-2…
#>  3    33 FR3          first_rou… First Rou…           1             3 2024-12-2…
#>  4    34 FR4          first_rou… First Rou…           1             4 2024-12-2…
#>  5    35 QF1          quarterfi… Quarterfi…           2             1 2025-01-0…
#>  6    36 QF2          quarterfi… Quarterfi…           2             2 2025-01-0…
#>  7    37 QF3          quarterfi… Quarterfi…           2             3 2025-01-0…
#>  8    38 QF4          quarterfi… Quarterfi…           2             4 2025-01-0…
#>  9    39 SF1          semifinal  Semifinal            3             1 2025-01-1…
#> 10    40 SF2          semifinal  Semifinal            3             2 2025-01-1…
#> 11    41 CH           champions… National …           4             1 2025-01-2…
#> # ℹ 27 more variables: bowl_name <chr>, game_id <int>, game_start_date <chr>,
#> #   game_completed <lgl>, game_home_points <int>, game_away_points <int>,
#> #   game_venue_id <int>, game_venue <chr>, game_home_team_id <int>,
#> #   game_home_team_school <chr>, game_home_team_conference <chr>,
#> #   game_away_team_id <int>, game_away_team_school <chr>,
#> #   game_away_team_conference <chr>, advances_to_matchup_id <int>,
#> #   advances_to_bracket_slot <chr>, advances_to_position <int>, …
# }
```
