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

`cfbd_play_stats_player()` - A data frame with 54 variables:

- `play_id`: character.:

  Referencing play id.

- `game_id`: integer.:

  Referencing game id.

- `season`: integer.:

  Season of the play.

- `week`: integer.:

  Week of the play.

- `opponent`: character.:

  Opponent of the offense on the play.

- `team_score`: integer.:

  Offense team score.

- `opponent_score`: integer.:

  Defense team score.

- `drive_id`: character.:

  Referencing drive id.

- `period`: integer.:

  Game period (quarter) of the play.

- `yards_to_goal`: integer.:

  Yards to the goal line (~0-100).

- `down`: integer.:

  Down of the play.

- `distance`: integer.:

  Distance to the sticks, i.e. 1st down or goal-line in goal-to-go
  situations.

- `reception_player_id`: character.:

  Pass receiver player reference id.

- `reception_player`: character.:

  Pass receiver player name.

- `reception_yds`: integer.:

  Reception yards.

- `completion_player_id`: character.:

  Passing player reference id.

- `completion_player`: character.:

  Passing player name.

- `completion_yds`: integer.:

  Passing yards.

- `rush_player_id`: character.:

  Rushing player reference id.

- `rush_player`: character.:

  Rushing player name.

- `rush_yds`: integer.:

  Rushing yards.

- `interception_player_id`: character.:

  Intercepting player reference id.

- `interception_player`: character.:

  Intercepting player name.

- `interception_stat`: integer.:

  Intercepting stat.

- `interception_thrown_player_id`: character.:

  Interception passing player reference id.

- `interception_thrown_player`: character.:

  Interception passing player name.

- `interception_thrown_stat`: integer.:

  Interception thrown stat.

- `touchdown_player_id`: character.:

  Touchdown scoring player reference id.

- `touchdown_player`: character.:

  Touchdown scoring player name.

- `touchdown_stat`: integer.:

  Touchdown scoring stat.

- `incompletion_player_id`: character.:

  Incomplete receiver player reference id.

- `incompletion_player`: character.:

  Incomplete receiver player name.

- `incompletion_stat`: integer.:

  Incomplete stat.

- `target_player_id`: character.:

  Targeted receiver player reference id.

- `target_player`: character.:

  Targeted receiver player name.

- `target_stat`: integer.:

  Target stat.

- `fumble_recovered_player_id`: logical.:

  Fumble recovering player reference id.

- `fumble_recovered_player`: logical.:

  Fumble recovering player name.

- `fumble_recovered_stat`: logical.:

  Fumble recovered stat.

- `fumble_forced_player_id`: logical.:

  Fumble forcing player reference id.

- `fumble_forced_player`: logical.:

  Fumble forcing player name.

- `fumble_forced_stat`: logical.:

  Fumble forced stat.

- `fumble_player_id`: logical.:

  Fumbling player reference id.

- `fumble_player`: logical.:

  Fumbling player name.

- `fumble_stat`: logical.:

  Fumble stat.

- `sack_player_id`: character.:

  Sacking player(s) reference id.

- `sack_player`: character.:

  Sacking player(s) name.

- `sack_stat`: integer.:

  Sack stat.

- `sack_taken_player_id`: character.:

  Sack taking player reference id.

- `sack_taken_player`: character.:

  Sack taking player name.

- `sack_taken_stat`: integer.:

  Sack taken stat.

- `pass_breakup_player_id`: logical.:

  Pass breakup player reference id.

- `pass_breakup_player`: logical.:

  Pass breakup player name.

- `pass_breakup_stat`: logical.:

  Pass breakup (PBU) stat.

- `field_goal_attempt_player_id`: character.:

  Field goal attempting player reference id.

- `field_goal_attempt_player`: character.:

  Field goal attempting player name.

- `field_goal_attempt_stat`: integer.:

  Field goal attempt stat.

- `field_goal_made_player_id`: character.:

  Field goal making player reference id.

- `field_goal_made_player`: character.:

  Field goal making player name.

- `field_goal_made_stat`: integer.:

  Field goal made stat.

- `field_goal_missed_player_id`: character.:

  Field goal missing player reference id.

- `field_goal_missed_player`: character.:

  Field goal missing player name.

- `field_goal_missed_stat`: integer.:

  Field goal missed stat.

- `field_goal_blocked_player_id`: character.:

  Field goal blocked player reference id.

- `field_goal_blocked_player`: character.:

  Field goal blocked player name.

- `field_goal_blocked_stat`: integer.:

  Field goal blocked stat.

## See also

Other CFBD PBP:
[`cfbd_live_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_plays.md),
[`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.md),
[`cfbd_play_stats_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_types.md),
[`cfbd_play_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_types.md),
[`cfbd_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_plays.md)

## Examples

``` r
# \donttest{
  try(cfbd_play_stats_player(game_id = 401628414))
#> ── Play-level player data from CollegeFootballData.com ─────── cfbfastR 2.2.1 ──
#> ℹ Data updated: 2026-01-19 16:22:10 UTC
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
#> ── Play-level player data from CollegeFootballData.com ─────── cfbfastR 2.2.1 ──
#> ℹ Data updated: 2026-01-19 16:22:32 UTC
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
