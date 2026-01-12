# **Get college football play by play data with cfbfastR expected points/win probability added**

Extract college football (D-I) play by play Data - for plays

## Usage

``` r
cfbd_pbp_data(
  year,
  season_type = "regular",
  week = 1,
  team = NULL,
  play_type = NULL,
  epa_wpa = FALSE,
  ...
)
```

## Arguments

- year:

  Select year, (example: 2018)

- season_type:

  (*String* default regular): Season type - regular, postseason, both,
  allstar, spring_regular, spring_postseason

- week:

  Select week, this is optional (also numeric)

- team:

  Select team name (example: Texas, Texas A&M, Clemson)

- play_type:

  Select play type (example: see the
  [cfbd_play_type_df](https://cfbfastR.sportsdataverse.org/reference/data.md))

- epa_wpa:

  Logical parameter (TRUE/FALSE) to return the Expected Points Added/Win
  Probability Added variables

- ...:

  Additional arguments passed to an underlying function.

## Value

A data frame with 368 variables:

|                                  |           |
|----------------------------------|-----------|
| col_name                         | types     |
| season                           | numeric   |
| wk                               | numeric   |
| id_play                          | character |
| game_id                          | integer   |
| game_play_number                 | numeric   |
| half_play_number                 | numeric   |
| drive_play_number                | numeric   |
| pos_team                         | character |
| def_pos_team                     | character |
| pos_team_score                   | integer   |
| def_pos_team_score               | integer   |
| half                             | factor    |
| period                           | integer   |
| clock_minutes                    | integer   |
| clock_seconds                    | integer   |
| play_type                        | character |
| play_text                        | character |
| down                             | numeric   |
| distance                         | numeric   |
| yards_to_goal                    | numeric   |
| yards_gained                     | numeric   |
| EPA                              | numeric   |
| ep_before                        | numeric   |
| ep_after                         | numeric   |
| wpa                              | numeric   |
| wp_before                        | numeric   |
| wp_after                         | numeric   |
| def_wp_before                    | numeric   |
| def_wp_after                     | numeric   |
| penalty_detail                   | character |
| yds_penalty                      | numeric   |
| penalty_1st_conv                 | logical   |
| new_series                       | numeric   |
| firstD_by_kickoff                | numeric   |
| firstD_by_poss                   | numeric   |
| firstD_by_penalty                | numeric   |
| firstD_by_yards                  | numeric   |
| def_EPA                          | numeric   |
| home_EPA                         | numeric   |
| away_EPA                         | numeric   |
| home_EPA_rush                    | numeric   |
| away_EPA_rush                    | numeric   |
| home_EPA_pass                    | numeric   |
| away_EPA_pass                    | numeric   |
| total_home_EPA                   | numeric   |
| total_away_EPA                   | numeric   |
| total_home_EPA_rush              | numeric   |
| total_away_EPA_rush              | numeric   |
| total_home_EPA_pass              | numeric   |
| total_away_EPA_pass              | numeric   |
| net_home_EPA                     | numeric   |
| net_away_EPA                     | numeric   |
| net_home_EPA_rush                | numeric   |
| net_away_EPA_rush                | numeric   |
| net_home_EPA_pass                | numeric   |
| net_away_EPA_pass                | numeric   |
| success                          | numeric   |
| epa_success                      | numeric   |
| rz_play                          | numeric   |
| scoring_opp                      | numeric   |
| middle_8                         | logical   |
| stuffed_run                      | numeric   |
| change_of_pos_team               | numeric   |
| downs_turnover                   | numeric   |
| turnover                         | numeric   |
| pos_score_diff_start             | numeric   |
| pos_score_pts                    | numeric   |
| log_ydstogo                      | numeric   |
| ExpScoreDiff                     | numeric   |
| ExpScoreDiff_Time_Ratio          | numeric   |
| half_clock_minutes               | numeric   |
| TimeSecsRem                      | numeric   |
| adj_TimeSecsRem                  | numeric   |
| Goal_To_Go                       | logical   |
| Under_two                        | logical   |
| home                             | character |
| away                             | character |
| home_wp_before                   | numeric   |
| away_wp_before                   | numeric   |
| home_wp_after                    | numeric   |
| away_wp_after                    | numeric   |
| end_of_half                      | numeric   |
| pos_team_receives_2H_kickoff     | numeric   |
| lead_pos_team                    | character |
| lead_play_type                   | character |
| lag_pos_team                     | character |
| lag_play_type                    | character |
| orig_play_type                   | character |
| Under_three                      | logical   |
| down_end                         | factor    |
| distance_end                     | numeric   |
| log_ydstogo_end                  | numeric   |
| yards_to_goal_end                | numeric   |
| TimeSecsRem_end                  | numeric   |
| Goal_To_Go_end                   | logical   |
| Under_two_end                    | logical   |
| offense_score_play               | numeric   |
| defense_score_play               | numeric   |
| ppa                              | numeric   |
| yard_line                        | integer   |
| scoring                          | logical   |
| pos_team_timeouts_rem_before     | numeric   |
| def_pos_team_timeouts_rem_before | numeric   |
| pos_team_timeouts                | integer   |
| def_pos_team_timeouts            | integer   |
| pos_score_diff                   | integer   |
| pos_score_diff_start_end         | numeric   |
| offense_play                     | character |
| defense_play                     | character |
| offense_receives_2H_kickoff      | numeric   |
| change_of_poss                   | numeric   |
| score_pts                        | numeric   |
| score_diff_start                 | numeric   |
| score_diff                       | integer   |
| offense_score                    | integer   |
| defense_score                    | integer   |
| offense_conference               | character |
| defense_conference               | character |
| off_timeout_called               | numeric   |
| def_timeout_called               | numeric   |
| offense_timeouts                 | integer   |
| defense_timeouts                 | integer   |
| off_timeouts_rem_before          | numeric   |
| def_timeouts_rem_before          | numeric   |
| rusher_player_name               | character |
| yds_rushed                       | numeric   |
| passer_player_name               | character |
| receiver_player_name             | character |
| yds_receiving                    | numeric   |
| yds_sacked                       | numeric   |
| sack_players                     | character |
| sack_player_name                 | character |
| sack_player_name2                | character |
| pass_breakup_player_name         | character |
| interception_player_name         | character |
| yds_int_return                   | numeric   |
| fumble_player_name               | character |
| fumble_forced_player_name        | character |
| fumble_recovered_player_name     | character |
| yds_fumble_return                | numeric   |
| punter_player_name               | character |
| yds_punted                       | numeric   |
| punt_returner_player_name        | character |
| yds_punt_return                  | numeric   |
| yds_punt_gained                  | numeric   |
| punt_block_player_name           | character |
| punt_block_return_player_name    | character |
| fg_kicker_player_name            | character |
| yds_fg                           | numeric   |
| fg_block_player_name             | character |
| fg_return_player_name            | character |
| kickoff_player_name              | character |
| yds_kickoff                      | numeric   |
| kickoff_returner_player_name     | character |
| yds_kickoff_return               | numeric   |
| new_id                           | numeric   |
| orig_drive_number                | integer   |
| drive_number                     | integer   |
| drive_result_detailed            | character |
| new_drive_pts                    | numeric   |
| drive_id                         | numeric   |
| drive_result                     | character |
| drive_start_yards_to_goal        | numeric   |
| drive_end_yards_to_goal          | integer   |
| drive_yards                      | integer   |
| drive_scoring                    | numeric   |
| drive_pts                        | numeric   |
| drive_start_period               | integer   |
| drive_end_period                 | integer   |
| drive_time_minutes_start         | integer   |
| drive_time_seconds_start         | integer   |
| drive_time_minutes_end           | integer   |
| drive_time_seconds_end           | integer   |
| drive_time_minutes_elapsed       | logical   |
| drive_time_seconds_elapsed       | logical   |
| drive_numbers                    | numeric   |
| number_of_drives                 | numeric   |
| pts_scored                       | numeric   |
| drive_result_detailed_flag       | character |
| drive_result2                    | character |
| drive_num                        | numeric   |
| lag_drive_result_detailed        | character |
| lead_drive_result_detailed       | character |
| lag_new_drive_pts                | numeric   |
| id_drive                         | character |
| rush                             | numeric   |
| rush_td                          | numeric   |
| pass                             | numeric   |
| pass_td                          | numeric   |
| completion                       | numeric   |
| pass_attempt                     | numeric   |
| target                           | numeric   |
| sack_vec                         | numeric   |
| sack                             | numeric   |
| int                              | numeric   |
| int_td                           | numeric   |
| turnover_vec                     | numeric   |
| turnover_vec_lag                 | numeric   |
| turnover_indicator               | numeric   |
| kickoff_play                     | numeric   |
| receives_2H_kickoff              | numeric   |
| missing_yard_flag                | logical   |
| scoring_play                     | numeric   |
| td_play                          | numeric   |
| touchdown                        | numeric   |
| safety                           | numeric   |
| fumble_vec                       | numeric   |
| kickoff_tb                       | numeric   |
| kickoff_onside                   | numeric   |
| kickoff_oob                      | numeric   |
| kickoff_fair_catch               | numeric   |
| kickoff_downed                   | numeric   |
| kickoff_safety                   | numeric   |
| kick_play                        | numeric   |
| punt                             | numeric   |
| punt_play                        | numeric   |
| punt_tb                          | numeric   |
| punt_oob                         | numeric   |
| punt_fair_catch                  | numeric   |
| punt_downed                      | numeric   |
| punt_safety                      | numeric   |
| punt_blocked                     | numeric   |
| penalty_safety                   | numeric   |
| fg_inds                          | numeric   |
| fg_made                          | logical   |
| fg_make_prob                     | numeric   |
| No_Score_before                  | numeric   |
| FG_before                        | numeric   |
| Opp_FG_before                    | numeric   |
| Opp_Safety_before                | numeric   |
| Opp_TD_before                    | numeric   |
| Safety_before                    | numeric   |
| TD_before                        | numeric   |
| No_Score_after                   | numeric   |
| FG_after                         | numeric   |
| Opp_FG_after                     | numeric   |
| Opp_Safety_after                 | numeric   |
| Opp_TD_after                     | numeric   |
| Safety_after                     | numeric   |
| TD_after                         | numeric   |
| penalty_flag                     | logical   |
| penalty_declined                 | logical   |
| penalty_no_play                  | logical   |
| penalty_offset                   | logical   |
| penalty_text                     | logical   |
| penalty_play_text                | character |
| lead_wp_before2                  | numeric   |
| wpa_half_end                     | numeric   |
| wpa_base                         | numeric   |
| wpa_base_nxt                     | numeric   |
| wpa_change                       | numeric   |
| wpa_change_nxt                   | numeric   |
| wpa_base_ind                     | numeric   |
| wpa_base_nxt_ind                 | numeric   |
| wpa_change_ind                   | numeric   |
| wpa_change_nxt_ind               | numeric   |
| lead_wp_before                   | numeric   |
| lead_pos_team2                   | character |
| row                              | integer   |
| drive_event_number               | numeric   |
| lag_play_type2                   | character |
| lag_play_type3                   | character |
| lag_play_text                    | character |
| lag_play_text2                   | character |
| lead_play_text                   | character |
| lag_first_by_penalty             | numeric   |
| lag_first_by_penalty2            | numeric   |
| lag_first_by_yards               | numeric   |
| lag_first_by_yards2              | numeric   |
| first_by_penalty                 | numeric   |
| first_by_yards                   | numeric   |
| play_after_turnover              | numeric   |
| lag_change_of_poss               | numeric   |
| lag_change_of_pos_team           | numeric   |
| lag_change_of_pos_team2          | numeric   |
| lag_kickoff_play                 | numeric   |
| lag_punt                         | numeric   |
| lag_punt2                        | numeric   |
| lag_scoring_play                 | numeric   |
| lag_turnover_vec                 | numeric   |
| lag_downs_turnover               | numeric   |
| lag_defense_score_play           | numeric   |
| lag_score_diff                   | numeric   |
| lag_offense_play                 | character |
| lead_offense_play                | character |
| lead_offense_play2               | character |
| lag_pos_score_diff               | numeric   |
| lag_off_timeouts                 | numeric   |
| lag_def_timeouts                 | numeric   |
| lag_TimeSecsRem2                 | numeric   |
| lag_TimeSecsRem                  | numeric   |
| lead_TimeSecsRem                 | numeric   |
| lead_TimeSecsRem2                | numeric   |
| lag_yards_to_goal2               | integer   |
| lag_yards_to_goal                | integer   |
| lead_yards_to_goal               | numeric   |
| lead_yards_to_goal2              | integer   |
| lag_down2                        | integer   |
| lag_down                         | integer   |
| lead_down                        | numeric   |
| lead_down2                       | numeric   |
| lead_distance                    | numeric   |
| lead_distance2                   | integer   |
| lead_play_type2                  | character |
| lead_play_type3                  | character |
| lag_ep_before3                   | numeric   |
| lag_ep_before2                   | numeric   |
| lag_ep_before                    | numeric   |
| lead_ep_before                   | numeric   |
| lead_ep_before2                  | numeric   |
| lag_ep_after                     | numeric   |
| lag_ep_after2                    | numeric   |
| lag_ep_after3                    | numeric   |
| lead_ep_after                    | numeric   |
| lead_ep_after2                   | numeric   |
| play_number                      | integer   |
| wallclock                        | character |
| provider                         | character |
| spread                           | numeric   |
| formatted_spread                 | character |
| over_under                       | numeric   |
| drive_is_home_offense            | logical   |
| drive_start_offense_score        | integer   |
| drive_start_defense_score        | integer   |
| drive_end_offense_score          | integer   |
| drive_end_defense_score          | integer   |
| play                             | numeric   |
| event                            | numeric   |
| game_event_number                | numeric   |
| game_row_number                  | integer   |
| half_play                        | numeric   |
| half_event                       | numeric   |
| half_event_number                | numeric   |
| half_row_number                  | integer   |
| lag_distance3                    | integer   |
| lag_distance2                    | integer   |
| lag_distance                     | integer   |
| lag_yards_gained3                | integer   |
| lag_yards_gained2                | integer   |
| lag_yards_gained                 | integer   |
| lead_yards_gained                | integer   |
| lead_yards_gained2               | integer   |
| lag_play_text3                   | character |
| lead_play_text2                  | character |
| lead_play_text3                  | character |
| pos_unit                         | character |
| def_pos_unit                     | character |
| lag_change_of_poss2              | numeric   |
| lag_change_of_poss3              | numeric   |
| lag_change_of_pos_team3          | numeric   |
| lag_kickoff_play2                | numeric   |
| lag_kickoff_play3                | numeric   |
| lag_punt3                        | numeric   |
| lag_scoring_play2                | numeric   |
| lag_scoring_play3                | numeric   |
| lag_turnover_vec2                | numeric   |
| lag_turnover_vec3                | numeric   |
| lag_downs_turnover2              | numeric   |
| lag_downs_turnover3              | numeric   |
| drive_play                       | numeric   |
| drive_event                      | numeric   |
| lag_first_by_penalty3            | numeric   |
| lag_first_by_yards3              | numeric   |

## Details

     # Get play by play data for 2025 regular season week 1
     cfbd_pbp_data(year = 2025, week = 1, season_type = 'regular', epa_wpa = TRUE)

## See also

Other CFBD PBP:
[`cfbd_live_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_plays.md),
[`cfbd_play_stats_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_player.md),
[`cfbd_play_stats_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_types.md),
[`cfbd_play_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_types.md),
[`cfbd_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_plays.md)
