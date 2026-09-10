# **Get individual rushing plays with direction and attribution detail**

**Get individual rushing plays with direction and attribution detail**

## Usage

``` r
cfbd_rushing_plays(
  year = NULL,
  week = NULL,
  game_id = NULL,
  season_type = NULL,
  team = NULL,
  offense = NULL,
  defense = NULL,
  conference = NULL,
  rusher_id = NULL,
  rush_direction = NULL,
  direction_analysis_eligible = NULL,
  attribution_status = NULL,
  is_rushing_touchdown = NULL,
  is_sack = NULL,
  is_kneel = NULL,
  is_team_rush = NULL,
  classification = NULL
)
```

## Arguments

- year:

  (*Integer* optional): Year, 4 digit format (*YYYY*)  
  Minimum value accepted: 2025

- week:

  (*Integer* optional): Week - values range from 1-15, 1-14 for seasons
  pre-playoff (i.e. 2013 or earlier)

- game_id:

  (*Integer* optional): Game ID filter for querying a single game

- season_type:

  (*String* optional): Season type - regular, postseason, both, allstar,
  spring_regular, spring_postseason

- team:

  (*String* optional): D-I Team

- offense:

  (*String* optional): Offensive team filter

- defense:

  (*String* optional): Defensive team filter

- conference:

  (*String* optional): Conference abbreviation - Select a valid FBS
  conference

- rusher_id:

  (*String* optional): CFBD athlete id of the ball carrier to filter on.

- rush_direction:

  (*String* optional): Run direction - left, middle, right

- direction_analysis_eligible:

  (*Logical* optional): Filter to plays eligible for the direction
  split.

- attribution_status:

  (*String* optional): How the carrier was resolved - individual, team,
  multi_carrier, unmatched, ambiguous, conflict, unlinked

- is_rushing_touchdown:

  (*Logical* optional): Filter to plays that scored a rushing touchdown.

- is_sack:

  (*Logical* optional): Filter to plays recorded as sacks.

- is_kneel:

  (*Logical* optional): Filter to quarterback kneel-downs.

- is_team_rush:

  (*Logical* optional): Filter to plays recorded as a team rush.

- classification:

  (*String* optional): Division classification - fbs, fcs, ii, ii/iii,
  iii

## Value

`cfbd_rushing_plays()` - A data frame with 34 variables:

|  |  |  |
|----|----|----|
| col_name | types | description |
| game_id | integer | Unique game identifier - `game_id`. |
| play_id | character | Unique play identifier - `play_id`. |
| drive_id | character | Unique drive identifier - `drive_id`. |
| season | integer | Four-digit season year (e.g. 2025). |
| week | integer | Week of the season. |
| season_type | character | Season type (regular, postseason, ...). |
| offense_id | integer | Offensive team id. |
| offense | character | Offensive team name. |
| offense_conference | character | Offensive team conference name. |
| defense_id | integer | Defensive team id. |
| defense | character | Defensive team name. |
| defense_conference | character | Defensive team conference name. |
| period | integer | Quarter of the play. |
| clock_minutes | integer | Minutes remaining on the game clock at the snap. |
| clock_seconds | integer | Seconds remaining on the game clock at the snap. |
| down | integer | Down of the play (1-4). |
| distance | integer | Yards to gain for a first down. |
| play_text | character | Play description text as published by the source. |
| start_yardline | integer | Yard line the play started from, in the offense's frame of reference. |
| start_yards_to_goal | integer | Yards from the opponent's end zone at the snap. |
| rusher_id | character | CFBD athlete id of the ball carrier (`NA` when unattributed). |
| rusher | character | Ball carrier full name (`NA` when unattributed). |
| rush_direction | character | Run direction - left, middle or right (`NA` when unparsed). |
| rushing_yards | integer | Yards gained on the play. |
| rusher_yards | integer | Yards credited to the identified carrier. |
| is_rushing_touchdown | logical | TRUE when the play scored a rushing touchdown. |
| is_sack | logical | TRUE when the play was recorded as a sack. |
| is_kneel | logical | TRUE when the play was a quarterback kneel-down. |
| is_team_rush | logical | TRUE when the play was recorded as a team rush rather than an individual. |
| attribution_status | character | How the carrier was resolved - individual, team, multi_carrier, unmatched, ... |
| direction_analysis_eligible | logical | TRUE when the play is eligible to be counted in a direction split. |
| parse_status | character | How completely CFBD parsed the play text for this row. |
| ppa | numeric | Predicted points added on the play. |
| success | logical | TRUE when the play met the success threshold for its down and distance. |

`rush_direction` comes back all-`NA` for any request whose plays were
not direction-parsed, in which case R types the column `logical`. Filter
on `direction_analysis_eligible` (or `parse_status`) rather than
assuming it is populated, and use `attribution_status` before trusting
`rusher_id`.

## See also

Other CFBD Rushing:
[`cfbd_rushing_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_players_games.md),
[`cfbd_rushing_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_players_season.md),
[`cfbd_rushing_teams_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_teams_games.md),
[`cfbd_rushing_teams_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_teams_season.md)

## Examples

``` r
# \donttest{
  try(cfbd_rushing_plays(year = 2025, week = 5, team = "Texas"))
#> data frame with 0 columns and 0 rows
# }
```
