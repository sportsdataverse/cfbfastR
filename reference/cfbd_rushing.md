# **CFBD Rushing Endpoint Overview**

- [`cfbd_rushing_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_players_season.md):
  Get player season rushing production, split by run direction.

- [`cfbd_rushing_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_players_games.md):
  Get player game rushing production, split by run direction.

- [`cfbd_rushing_teams_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_teams_season.md):
  Get team season rushing production for and against, split by run
  direction.

- [`cfbd_rushing_teams_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_teams_games.md):
  Get team game rushing production for and against, split by run
  direction.

- [`cfbd_rushing_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_plays.md):
  Get individual rushing plays with direction and attribution detail.

## Details

### **Get player season rushing production**

      cfbd_rushing_players_season(year = 2025, team = "Texas")

### **Get player game rushing production**

      cfbd_rushing_players_games(year = 2025, week = 5)

### **Get team season rushing production**

      cfbd_rushing_teams_season(year = 2025, team = "Texas")

### **Get team game rushing production**

      cfbd_rushing_teams_games(year = 2025, week = 5)

### **Get individual rushing plays**

      cfbd_rushing_plays(year = 2025, week = 5, team = "Texas")

## The rushing production block

Every rushing endpoint below shares one production block, documented
once here rather than repeated in each returns table. Player frames
carry 24 of these columns; team frames carry 26, adding
`touchdown_status_available` and `rushing_touchdowns`.

|  |  |  |
|----|----|----|
| col_name | types | description |
| attempts | integer | Rush attempts. |
| rushing_yards_available | integer | Attempts for which rushing yards were parsed (denominator for yardage means). |
| total_rushing_yards | integer | Sum of rushing yards over those attempts. |
| yards_per_carry | numeric | Mean rushing yards per carry. |
| individual_attempts | integer | Attempts attributed to a single identified ball carrier. |
| unattributed_attempts | integer | Attempts with no ball carrier resolved from the play text. |
| sacks | integer | Sacks counted within the rushing play set. |
| kneels | integer | Quarterback kneel-downs. |
| team_rushes | integer | Attempts recorded as a team rush rather than an individual. |
| multi_carrier_attempts | integer | Attempts where more than one carrier was identified. |
| direction_eligible_attempts | integer | Attempts eligible for a direction split. |
| direction_available_attempts | integer | Attempts for which a direction was actually parsed. |
| success_rate | numeric | Proportion of attempts meeting the success threshold (0-1). |
| ppa | numeric | Predicted points added per attempt. |
| total_ppa | numeric | Sum of predicted points added. |
| line_yards | numeric | Line yards per carry (Football Outsiders methodology). |
| line_yards_total | numeric | Sum of line yards. |
| second_level_yards | numeric | Second-level yards per carry (5-10 yards past the line of scrimmage). |
| second_level_yards_total | numeric | Sum of second-level yards. |
| open_field_yards | numeric | Open-field yards per carry (10+ yards past the line of scrimmage). |
| open_field_yards_total | numeric | Sum of open-field yards. |
| stuff_rate | numeric | Proportion of carries stopped at or behind the line of scrimmage (0-1). |
| power_success | numeric | Conversion rate on short-yardage power runs (0-1). |
| explosiveness | numeric | Mean PPA on successful carries. |
| touchdown_status_available | integer | *Team frames only.* Attempts for which touchdown status was parsed. |
| rushing_touchdowns | integer | *Team frames only.* Rushing touchdowns over those attempts. |

As with passing, the `*_available` columns are denominators, not
statistics: CFBD parses these fields out of play text, so an attempt can
be counted while its yardage or direction stays unknown. Dividing by
`attempts` instead of the matching `*_available` column understates
every mean.

## Direction splits

A 15-column subset repeats for each of four run directions, prefixed
`directions_<bucket>_`: `left`, `middle`, `right` and `unknown`
(direction could not be parsed).

Each bucket carries `carries`, `yards`, `yards_per_carry`,
`success_rate`, `ppa`, `total_ppa`, `line_yards`, `line_yards_total`,
`second_level_yards`, `second_level_yards_total`, `open_field_yards`,
`open_field_yards_total`, `stuff_rate`, `power_success` and
`explosiveness`.

So a player frame is 5 identity + 24 production + 4 x 15 direction =
**89 columns**, and a team frame is 3 identity + 2 x (26 + 4 x 15) =
**175**, split across `offense_` and `defense_`.

## Season coverage

These endpoints are **2025 onward**. Earlier seasons answer HTTP 200
with an empty array rather than an error, so a request for 2024 returns
an empty data frame, not a failure.
