# **Gets player info associated by play**

**Gets player info associated by play**

## Usage

``` r
cfbd_play_stats_player(
  year = NULL,
  week = NULL,
  team = NULL,
  game_id = NULL,
  athlete_id = NULL,
  stat_type_id = NULL,
  season_type = "both"
)
```

## Arguments

- year:

  (*Integer* optional): Year, 4 digit format (*YYYY*)

- week:

  (*Integer* optional): Week - values from 1-15, 1-14 for seasons
  pre-playoff, i.e. 2013 or earlier

- team:

  (*String* optional): D-I Team

- game_id:

  (*Integer* optional): Game ID filter for querying a single game Can be
  found using the
  [`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md)
  function

- athlete_id:

  (*Integer* optional): Athlete ID filter for querying a single athlete
  Can be found using the
  [`cfbd_player_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_info.md)
  function.

- stat_type_id:

  (*Integer* optional): Stat Type ID filter for querying a single stat
  type Can be found using the
  [`cfbd_play_stats_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_types.md)
  function

- season_type:

  (*String* default both): Season type - regular, postseason, both,
  allstar, spring_regular, spring_postseason

## Value

`cfbd_play_stats_player()` - A data frame with 66 variables:

|  |  |  |
|----|----|----|
| col_name | types | description |
| play_id | character | CFBD play identifier the stat is attributed to. |
| game_id | integer | CFBD game identifier the play belongs to. |
| season | integer | Four-digit season year (e.g. 2024). |
| week | integer | Season week number (1-15 regular season; 1 = postseason/bowl week). |
| opponent | character | Full name of the opponent on the play. |
| team_score | integer | Offense team score at the time of the play. |
| opponent_score | integer | Defense / opponent team score at the time of the play. |
| drive_id | character | CFBD drive identifier the play belongs to. |
| period | integer | Game period / quarter of the play (1-4 regulation, 5+ overtime). |
| yards_to_goal | integer | Distance in yards from the offense's spot to the opponent's goal line (0-100). |
| down | integer | Down of the play (1-4). |
| distance | integer | Yards to gain for a first down (or to the goal line in goal-to-go situations). |
| reception_player_id | character | CFBD athlete_id of the receiver credited with a reception. |
| reception_player | character | Name of the receiver credited with a reception. |
| reception_yds | integer | Reception yards gained on the play. |
| completion_player_id | character | CFBD athlete_id of the passer credited with a completion. |
| completion_player | character | Name of the passer credited with a completion. |
| completion_yds | integer | Passing yards gained on the completion. |
| rush_player_id | character | CFBD athlete_id of the player credited with a rush attempt. |
| rush_player | character | Name of the player credited with a rush attempt. |
| rush_yds | integer | Rushing yards gained on the play. |
| interception_player_id | character | CFBD athlete_id of the defender credited with an interception. |
| interception_player | character | Name of the defender credited with an interception. |
| interception_stat | integer | Interception stat value reported by CFBD (typically 1 per INT). |
| interception_thrown_player_id | character | CFBD athlete_id of the passer charged with the interception. |
| interception_thrown_player | character | Name of the passer charged with the interception. |
| interception_thrown_stat | integer | Interception-thrown stat value reported by CFBD (typically 1 per INT thrown). |
| touchdown_player_id | character | CFBD athlete_id of the player credited with the touchdown. |
| touchdown_player | character | Name of the player credited with the touchdown. |
| touchdown_stat | integer | Touchdown stat value reported by CFBD (typically 1 per TD scored). |
| incompletion_player_id | character | CFBD athlete_id of the targeted receiver on an incompletion. |
| incompletion_player | character | Name of the targeted receiver on an incompletion. |
| incompletion_stat | integer | Incompletion stat value reported by CFBD (typically 1 per incompletion). |
| target_player_id | character | CFBD athlete_id of the targeted receiver on a pass. |
| target_player | character | Name of the targeted receiver on a pass. |
| target_stat | integer | Target stat value reported by CFBD (typically 1 per target). |
| fumble_recovered_player_id | logical | CFBD athlete_id of the player recovering the fumble. |
| fumble_recovered_player | logical | Name of the player recovering the fumble. |
| fumble_recovered_stat | logical | Fumble-recovered stat value reported by CFBD (typically 1 per recovery). |
| fumble_forced_player_id | logical | CFBD athlete_id of the defender credited with forcing the fumble. |
| fumble_forced_player | logical | Name of the defender credited with forcing the fumble. |
| fumble_forced_stat | logical | Fumble-forced stat value reported by CFBD (typically 1 per forced fumble). |
| fumble_player_id | logical | CFBD athlete_id of the player who fumbled. |
| fumble_player | logical | Name of the player who fumbled. |
| fumble_stat | logical | Fumble stat value reported by CFBD (typically 1 per fumble). |
| sack_player_id | character | Comma-separated CFBD athlete_id(s) of the sacking defender(s). |
| sack_player | character | Comma-separated name(s) of the sacking defender(s). |
| sack_stat | integer | Sack stat value reported by CFBD (sack credit can be split between defenders). |
| sack_taken_player_id | character | CFBD athlete_id of the QB charged with taking the sack. |
| sack_taken_player | character | Name of the QB charged with taking the sack. |
| sack_taken_stat | integer | Sack-taken stat value reported by CFBD (typically 1 per sack taken). |
| pass_breakup_player_id | logical | CFBD athlete_id of the defender credited with the pass breakup (PBU). |
| pass_breakup_player | logical | Name of the defender credited with the pass breakup (PBU). |
| pass_breakup_stat | logical | Pass breakup (PBU) stat value reported by CFBD (typically 1 per PBU). |
| field_goal_attempt_player_id | character | CFBD athlete_id of the kicker attempting the field goal. |
| field_goal_attempt_player | character | Name of the kicker attempting the field goal. |
| field_goal_attempt_stat | integer | Field goal attempt distance in yards reported by CFBD. |
| field_goal_made_player_id | character | CFBD athlete_id of the kicker on a made field goal. |
| field_goal_made_player | character | Name of the kicker on a made field goal. |
| field_goal_made_stat | integer | Made-field-goal distance in yards reported by CFBD. |
| field_goal_missed_player_id | character | CFBD athlete_id of the kicker on a missed field goal. |
| field_goal_missed_player | character | Name of the kicker on a missed field goal. |
| field_goal_missed_stat | integer | Missed-field-goal distance in yards reported by CFBD. |
| field_goal_blocked_player_id | character | CFBD athlete_id of the defender credited with blocking the field goal. |
| field_goal_blocked_player | character | Name of the defender credited with blocking the field goal. |
| field_goal_blocked_stat | integer | Blocked-field-goal distance in yards reported by CFBD. |

## See also

Other CFBD PBP:
[`cfbd_live_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_plays.md),
[`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.md),
[`cfbd_pbp_data_v2()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data_v2.md),
[`cfbd_play_stats_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_types.md),
[`cfbd_play_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_types.md),
[`cfbd_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_plays.md)

## Examples

``` r
# \donttest{
  try(cfbd_play_stats_player(game_id = 401628414))
#> ── Play-level player data from CollegeFootballData.com ─────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-06-09 18:15:42 UTC
#> # A tibble: 132 × 70
#>      game_id season  week team     conference opponent team_score opponent_score
#>        <int>  <int> <int> <chr>    <chr>      <chr>         <int>          <int>
#>  1 401628414   2024    11 Ole Miss SEC        Georgia           0              0
#>  2 401628414   2024    11 Georgia  SEC        Ole Miss          0              0
#>  3 401628414   2024    11 Georgia  SEC        Ole Miss          0              0
#>  4 401628414   2024    11 Georgia  SEC        Ole Miss          0              0
#>  5 401628414   2024    11 Georgia  SEC        Ole Miss          0              0
#>  6 401628414   2024    11 Georgia  SEC        Ole Miss          0              0
#>  7 401628414   2024    11 Georgia  SEC        Ole Miss          0              0
#>  8 401628414   2024    11 Georgia  SEC        Ole Miss          0              0
#>  9 401628414   2024    11 Georgia  SEC        Ole Miss          0              0
#> 10 401628414   2024    11 Georgia  SEC        Ole Miss          7              0
#> # ℹ 122 more rows
#> # ℹ 62 more variables: drive_id <chr>, play_id <chr>, period <int>,
#> #   clock_minutes <int>, clock_seconds <int>, yards_to_goal <int>, down <int>,
#> #   distance <int>, reception_player_id <chr>, reception_player <chr>,
#> #   reception_yds <int>, completion_player_id <chr>, completion_player <chr>,
#> #   completion_yds <int>, rush_player_id <chr>, rush_player <chr>,
#> #   rush_yds <int>, interception_player_id <chr>, interception_player <chr>, …
  try(cfbd_play_stats_player(year = 2025, week = 1))
#> ── Play-level player data from CollegeFootballData.com ─────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-06-09 18:15:50 UTC
#> # A tibble: 1,306 × 70
#>      game_id season  week team    conference opponent  team_score opponent_score
#>        <int>  <int> <int> <chr>   <chr>      <chr>          <int>          <int>
#>  1 401752665   2025     1 Alabama SEC        Florida …          0              0
#>  2 401752665   2025     1 Alabama SEC        Florida …          0              0
#>  3 401752665   2025     1 Alabama SEC        Florida …          0              0
#>  4 401752665   2025     1 Alabama SEC        Florida …          0              0
#>  5 401752665   2025     1 Alabama SEC        Florida …          0              0
#>  6 401752665   2025     1 Alabama SEC        Florida …          0              0
#>  7 401752665   2025     1 Alabama SEC        Florida …          0              0
#>  8 401752665   2025     1 Alabama SEC        Florida …          0              0
#>  9 401752665   2025     1 Alabama SEC        Florida …          0              0
#> 10 401752665   2025     1 Alabama SEC        Florida …          0              0
#> # ℹ 1,296 more rows
#> # ℹ 62 more variables: drive_id <chr>, play_id <chr>, period <int>,
#> #   clock_minutes <int>, clock_seconds <int>, yards_to_goal <int>, down <int>,
#> #   distance <int>, reception_player_id <chr>, reception_player <chr>,
#> #   reception_yds <int>, completion_player_id <chr>, completion_player <chr>,
#> #   completion_yds <int>, rush_player_id <chr>, rush_player <chr>,
#> #   rush_yds <int>, interception_player_id <chr>, interception_player <chr>, …
# }
```
