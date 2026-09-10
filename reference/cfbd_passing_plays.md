# **Get individual passing plays with air yards, YAC and location detail**

**Get individual passing plays with air yards, YAC and location detail**

## Usage

``` r
cfbd_passing_plays(
  year = NULL,
  team = NULL,
  week = NULL,
  game_id = NULL,
  season_type = NULL,
  offense = NULL,
  defense = NULL,
  conference = NULL,
  passer_id = NULL,
  target_id = NULL,
  outcome = NULL,
  classification = NULL
)
```

## Arguments

- year:

  (*Integer* required): Year, 4 digit format (*YYYY*)  
  Minimum value accepted: 2025

- team:

  (*String* optional): D-I Team

- week:

  (*Integer* optional): Week - values range from 1-15, 1-14 for seasons
  pre-playoff (i.e. 2013 or earlier)

- game_id:

  (*Integer* optional): Game ID filter for querying a single game

- season_type:

  (*String* optional): Season type - regular, postseason, both, allstar,
  spring_regular, spring_postseason

- offense:

  (*String* optional): Offensive team filter

- defense:

  (*String* optional): Defensive team filter

- conference:

  (*String* optional): Conference abbreviation - Select a valid FBS
  conference

- passer_id:

  (*String* optional): CFBD athlete id of the passer to filter on.

- target_id:

  (*String* optional): CFBD athlete id of the targeted receiver to
  filter on.

- outcome:

  (*String* optional): Pass outcome - completion, incompletion,
  interception

- classification:

  (*String* optional): Division classification - fbs, fcs, ii, ii/iii,
  iii

## Value

`cfbd_passing_plays()` - A data frame with 39 variables:

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
| passer_id | character | CFBD athlete id of the passer. |
| passer | character | Passer full name. |
| target_id | character | CFBD athlete id of the targeted receiver (`NA` when unparsed). |
| target | character | Targeted receiver full name (`NA` when unparsed). |
| outcome | character | Pass outcome - completion, incompletion or interception. |
| air_yards | integer | Yards the ball travelled past the line of scrimmage. |
| pass_depth | character | Depth bucket - short or deep (`NA` when unparsed). |
| pass_direction | character | Direction bucket - left, middle or right (`NA` when unparsed). |
| pass_location | character | Combined depth + direction bucket, matching the `locations_*` split (`NA` when unparsed). |
| total_yards | integer | Total yards gained on the play. |
| yards_after_catch | integer | Yards gained after the catch (`NA` when unparsed or incomplete). |
| start_yardline | integer | Yard line the play started from, in the offense's frame of reference. |
| start_yards_to_goal | integer | Yards from the opponent's end zone at the snap. |
| target_yards_to_goal | integer | Yards from the opponent's end zone at the target point. |
| is_spike | logical | TRUE when the pass was a clock-stopping spike. |
| is_throwaway | logical | TRUE when the pass was a deliberate throwaway. |
| is_intentional_grounding | logical | TRUE when the play was flagged intentional grounding. |
| parse_status | character | How completely CFBD parsed the play text for this row. |
| ppa | numeric | Predicted points added on the play. |
| success | logical | TRUE when the play met the success threshold for its down and distance. |
| location_analysis_eligible | logical | TRUE when the play is eligible to be counted in a location split. |

Check a column before building on it. As of this writing CFBD has
**not** populated play-level `air_yards`, `yards_after_catch`,
`pass_depth`, `pass_direction` or `pass_location` at all – every value
is `NA`, so R types those columns `logical` – while `target` is
populated (1,976 of 2,003 week-5 2025 completions) and the SEASON
aggregates in
[`cfbd_passing_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_players_season.md)
do carry air yards. Filter on `location_analysis_eligible` or
`parse_status` rather than assuming a column holds values.

## See also

Other CFBD Passing:
[`cfbd_passing_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_players_games.md),
[`cfbd_passing_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_players_season.md),
[`cfbd_passing_teams_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_teams_games.md),
[`cfbd_passing_teams_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_teams_season.md)

## Examples

``` r
# \donttest{
  try(cfbd_passing_plays(year = 2025, week = 5, team = "Texas"))
#> data frame with 0 columns and 0 rows
# }
```
