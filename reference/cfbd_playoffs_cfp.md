# **Get College Football Playoff bracket information**

**Get College Football Playoff bracket information** Returns the College
Football Playoff bracket for a season.

## Usage

``` r
cfbd_playoffs_cfp(year, proxy = NULL)
```

## Arguments

- year:

  (*Integer* required): Season, 4 digits (YYYY).  
  Minimum value accepted: 2014

- proxy:

  (*List* optional): Per-call proxy override passed to `get_req()`.
  `NULL` (default) falls back to `getOption("cfbfastR.proxy")` and then
  the `http(s)_proxy` environment variables, so a caller can override
  the shared setting for one endpoint.

## Value

`cfbd_playoffs_cfp()` - A tibble with 46 columns:

|  |  |  |
|----|----|----|
| col_name | types | description |
| round_code | character | Playoff round code (`first_round`, `quarterfinal`, `semifinal`, `championship`). |
| round_name | character | Human-readable playoff round name. |
| round_order | integer | Ordinal position of the round in the bracket. |
| id | integer | Record identifier. |
| bracket_slot | character | Bracket position code for the matchup (e.g. `FR1`, `QF2`). |
| round | character | Playoff round code. |
| round_name_2 | character | Round name 2. |
| round_order_2 | integer | Round order 2. |
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
| season | integer | Four-digit season year. |
| competition | character | Competition identifier (e.g. `cfp`). |
| format | character | Bracket format descriptor. |
| team_count | integer | Number of teams in the field. |
| status | character | Status of the competition. |
| champion_id | integer | Referencing team id of the champion. |
| champion_school | character | School name of the champion. |
| champion_conference | character | Conference of the champion. |
| advances_to | logical | Advances to. |

## See also

Other CFBD Playoff Functions:
[`cfbd_playoffs_cfp_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_playoffs_cfp_games.md),
[`cfbd_playoffs_cfp_participants()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_playoffs_cfp_participants.md)

## Examples

``` r
# \donttest{
  try(cfbd_playoffs_cfp(year = 2024))
#> ── Get College Football Playoff bracket information from CollegeFootballData.com
#> ℹ Data updated: 2026-08-24 13:29:35 UTC
#> # A tibble: 11 × 46
#>    round_code   round_name     round_order    id bracket_slot round round_name_2
#>    <chr>        <chr>                <int> <int> <chr>        <chr> <chr>       
#>  1 first_round  First Round              1    31 FR1          firs… First Round 
#>  2 first_round  First Round              1    32 FR2          firs… First Round 
#>  3 first_round  First Round              1    33 FR3          firs… First Round 
#>  4 first_round  First Round              1    34 FR4          firs… First Round 
#>  5 quarterfinal Quarterfinal             2    35 QF1          quar… Quarterfinal
#>  6 quarterfinal Quarterfinal             2    36 QF2          quar… Quarterfinal
#>  7 quarterfinal Quarterfinal             2    37 QF3          quar… Quarterfinal
#>  8 quarterfinal Quarterfinal             2    38 QF4          quar… Quarterfinal
#>  9 semifinal    Semifinal                3    39 SF1          semi… Semifinal   
#> 10 semifinal    Semifinal                3    40 SF2          semi… Semifinal   
#> 11 championship National Cham…           4    41 CH           cham… National Ch…
#> # ℹ 39 more variables: round_order_2 <int>, matchup_order <int>,
#> #   start_date <chr>, bowl_name <chr>, game_id <int>, game_start_date <chr>,
#> #   game_completed <lgl>, game_home_points <int>, game_away_points <int>,
#> #   game_venue_id <int>, game_venue <chr>, game_home_team_id <int>,
#> #   game_home_team_school <chr>, game_home_team_conference <chr>,
#> #   game_away_team_id <int>, game_away_team_school <chr>,
#> #   game_away_team_conference <chr>, advances_to_matchup_id <int>, …
# }
```
