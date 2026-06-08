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

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | numeric | Four-digit season year (e.g. 2024). |
| wk | numeric | Season week number (1-15 regular season, 1 for bowl/postseason week). |
| id_play | character | Unique CFBD play identifier (concatenates game_id and play index). |
| game_id | integer | CFBD-internal game identifier. |
| game_play_number | numeric | Sequential play number within the game (excludes timeouts/end markers). |
| half_play_number | numeric | Sequential play number within the current half. |
| drive_play_number | numeric | Sequential play number within the current drive. |
| pos_team | character | Team name in possession at the start of the play (offense, kickoff-aware). |
| def_pos_team | character | Team name on defense at the start of the play. |
| pos_team_score | integer | Score for the team in possession at the start of the play. |
| def_pos_team_score | integer | Score for the defensive team at the start of the play. |
| half | factor | Half indicator (1 or 2). |
| period | integer | Quarter number (1-4, 5+ for overtime). |
| clock_minutes | integer | Minutes remaining on the period clock at the start of the play. |
| clock_seconds | integer | Seconds remaining on the period clock at the start of the play. |
| play_type | character | CFBD play type label (e.g. "Rush", "Pass Reception", "Field Goal Good"). |
| play_text | character | Free-text description of the play from CFBD. |
| down | numeric | Down number at the start of the play (1-4). |
| distance | numeric | Yards to gain for a first down at the start of the play. |
| yards_to_goal | numeric | Yards from the offense to the opponent's end zone at the start of the play. |
| yards_gained | numeric | Yards gained (or lost) by the offense on the play. |
| EPA | numeric | Expected Points Added on the play (cfbfastR EPA model output). |
| ep_before | numeric | Expected points value before the play (cfbfastR EPA model). |
| ep_after | numeric | Expected points value after the play (cfbfastR EPA model). |
| wpa | numeric | Win Probability Added on the play (cfbfastR WP model output). |
| wp_before | numeric | Win probability for the possession team before the play (0-1). |
| wp_after | numeric | Win probability for the possession team after the play (0-1). |
| def_wp_before | numeric | Win probability for the defensive team before the play (0-1). |
| def_wp_after | numeric | Win probability for the defensive team after the play (0-1). |
| penalty_detail | character | Parsed penalty description extracted from play text. |
| yds_penalty | numeric | Yardage assessed on the penalty. |
| penalty_1st_conv | logical | TRUE when the penalty resulted in a first down conversion. |
| new_series | numeric | Binary flag for the start of a new series of downs. |
| firstD_by_kickoff | numeric | Binary flag for a new first down arising from a kickoff. |
| firstD_by_poss | numeric | Binary flag for a new first down via change of possession. |
| firstD_by_penalty | numeric | Binary flag for a new first down via penalty. |
| firstD_by_yards | numeric | Binary flag for a new first down via yards gained. |
| def_EPA | numeric | EPA for the defensive team on the play (sign-flipped offense EPA). |
| home_EPA | numeric | EPA for the home team on the play. |
| away_EPA | numeric | EPA for the away team on the play. |
| home_EPA_rush | numeric | Rushing EPA for the home team on the play. |
| away_EPA_rush | numeric | Rushing EPA for the away team on the play. |
| home_EPA_pass | numeric | Passing EPA for the home team on the play. |
| away_EPA_pass | numeric | Passing EPA for the away team on the play. |
| total_home_EPA | numeric | Cumulative total EPA for the home team through the play. |
| total_away_EPA | numeric | Cumulative total EPA for the away team through the play. |
| total_home_EPA_rush | numeric | Cumulative rushing EPA for the home team through the play. |
| total_away_EPA_rush | numeric | Cumulative rushing EPA for the away team through the play. |
| total_home_EPA_pass | numeric | Cumulative passing EPA for the home team through the play. |
| total_away_EPA_pass | numeric | Cumulative passing EPA for the away team through the play. |
| net_home_EPA | numeric | Net EPA differential (home minus away) through the play. |
| net_away_EPA | numeric | Net EPA differential (away minus home) through the play. |
| net_home_EPA_rush | numeric | Net rushing EPA differential for the home team through the play. |
| net_away_EPA_rush | numeric | Net rushing EPA differential for the away team through the play. |
| net_home_EPA_pass | numeric | Net passing EPA differential for the home team through the play. |
| net_away_EPA_pass | numeric | Net passing EPA differential for the away team through the play. |
| success | numeric | Binary success-rate flag using the 50/70/100 percent down-state thresholds. |
| epa_success | numeric | Binary flag for plays with positive EPA (EPA \> 0). |
| rz_play | numeric | Binary flag for a red-zone play (yards_to_goal \<= 20). |
| scoring_opp | numeric | Binary flag for a scoring opportunity (yards_to_goal \<= 40). |
| middle_8 | logical | TRUE for plays in the middle-8 window (final 4 min of 1H, first 4 min of 2H). |
| stuffed_run | numeric | Binary flag for a stuffed run (zero or negative yards gained). |
| change_of_pos_team | numeric | Binary flag for change of possession-team on the play. |
| downs_turnover | numeric | Binary flag for a turnover on downs. |
| turnover | numeric | Binary flag for any turnover on the play. |
| pos_score_diff_start | numeric | Score differential for the possession team at the start of the play. |
| pos_score_pts | numeric | Points scored on the play attributed to the possession team. |
| log_ydstogo | numeric | Natural log of distance-to-go (model feature). |
| ExpScoreDiff | numeric | Expected score differential at the start of the play (EPA-adjusted). |
| ExpScoreDiff_Time_Ratio | numeric | Expected score differential scaled by share of time remaining. |
| half_clock_minutes | numeric | Minutes remaining in the half (15 + clock_minutes when in Q1/Q3). |
| TimeSecsRem | numeric | Seconds remaining in the half at the start of the play. |
| adj_TimeSecsRem | numeric | Adjusted seconds remaining used by the EPA/WP models. |
| Goal_To_Go | logical | TRUE when the offense is in a goal-to-go situation. |
| Under_two | logical | TRUE when under two minutes remain in the half. |
| home | character | Home team name. |
| away | character | Away team name. |
| home_wp_before | numeric | Home team win probability before the play (0-1). |
| away_wp_before | numeric | Away team win probability before the play (0-1). |
| home_wp_after | numeric | Home team win probability after the play (0-1). |
| away_wp_after | numeric | Away team win probability after the play (0-1). |
| end_of_half | numeric | Binary flag for the last play of a half. |
| pos_team_receives_2H_kickoff | numeric | Binary flag indicating possession team receives the second-half kickoff. |
| lead_pos_team | character | Possession team on the next play (lead value). |
| lead_play_type | character | Play type on the next play (lead value). |
| lag_pos_team | character | Possession team on the previous play (lag value). |
| lag_play_type | character | Play type on the previous play (lag value). |
| orig_play_type | character | Original CFBD play type label before cfbfastR cleaning. |
| Under_three | logical | TRUE when under three minutes remain in the half. |
| down_end | factor | Down number at the end of the play (post-play state). |
| distance_end | numeric | Distance-to-go at the end of the play (post-play state). |
| log_ydstogo_end | numeric | Natural log of post-play distance-to-go (model feature). |
| yards_to_goal_end | numeric | Yards to opponent end zone at the end of the play. |
| TimeSecsRem_end | numeric | Seconds remaining in the half at the end of the play. |
| Goal_To_Go_end | logical | TRUE when the post-play state is goal-to-go. |
| Under_two_end | logical | TRUE when the post-play state is under two minutes. |
| offense_score_play | numeric | Binary flag for an offensive scoring play. |
| defense_score_play | numeric | Binary flag for a defensive scoring play. |
| ppa | numeric | Predicted Points Added from the CFBD ppa endpoint (CFB-EPA analogue). |
| yard_line | integer | Yard line where the play started (raw CFBD yardline field). |
| scoring | logical | TRUE when the play resulted in a score (CFBD scoring flag). |
| pos_team_timeouts_rem_before | numeric | Possession team timeouts remaining before the play. |
| def_pos_team_timeouts_rem_before | numeric | Defensive team timeouts remaining before the play. |
| pos_team_timeouts | integer | Possession team timeouts remaining after the play. |
| def_pos_team_timeouts | integer | Defensive team timeouts remaining after the play. |
| pos_score_diff | integer | Score differential from the possession team's perspective. |
| pos_score_diff_start_end | numeric | Score differential aggregated from start to end of the play. |
| offense_play | character | Offensive team name as labeled by CFBD on the play. |
| defense_play | character | Defensive team name as labeled by CFBD on the play. |
| offense_receives_2H_kickoff | numeric | Binary flag indicating offense receives the second-half kickoff. |
| change_of_poss | numeric | Binary flag for change of possession on the play (CFBD offense field). |
| score_pts | numeric | Points scored on the play. |
| score_diff_start | numeric | Score differential at the start of the play. |
| score_diff | integer | Score differential (offense_score - defense_score) at the start. |
| offense_score | integer | Offense team score at the start of the play. |
| defense_score | integer | Defense team score at the start of the play. |
| offense_conference | character | Conference name of the offensive team. |
| defense_conference | character | Conference name of the defensive team. |
| off_timeout_called | numeric | Binary flag for an offensive timeout called during the play. |
| def_timeout_called | numeric | Binary flag for a defensive timeout called during the play. |
| offense_timeouts | integer | Offense timeouts remaining after the play (CFBD field). |
| defense_timeouts | integer | Defense timeouts remaining after the play (CFBD field). |
| off_timeouts_rem_before | numeric | Offense timeouts remaining before the play. |
| def_timeouts_rem_before | numeric | Defense timeouts remaining before the play. |
| rusher_player_name | character | Name of the rusher on a rushing play. |
| yds_rushed | numeric | Rushing yards gained on the play. |
| passer_player_name | character | Name of the passer on a passing play. |
| receiver_player_name | character | Name of the receiver on a passing play. |
| yds_receiving | numeric | Receiving yards gained on the play. |
| yds_sacked | numeric | Yards lost on the sack. |
| sack_players | character | Combined names of all sack participants. |
| sack_player_name | character | Primary sack player name. |
| sack_player_name2 | character | Secondary sack player name (when split between two defenders). |
| pass_breakup_player_name | character | Name of the defender credited with the pass breakup. |
| interception_player_name | character | Name of the defender credited with the interception. |
| yds_int_return | numeric | Yards gained on an interception return. |
| fumble_player_name | character | Name of the player who fumbled. |
| fumble_forced_player_name | character | Name of the player who forced the fumble. |
| fumble_recovered_player_name | character | Name of the player who recovered the fumble. |
| yds_fumble_return | numeric | Yards gained on a fumble return. |
| punter_player_name | character | Name of the punter. |
| yds_punted | numeric | Yards the ball traveled on the punt. |
| punt_returner_player_name | character | Name of the punt returner. |
| yds_punt_return | numeric | Yards gained on the punt return. |
| yds_punt_gained | numeric | Net yards gained on the punt (punt distance minus return). |
| punt_block_player_name | character | Name of the player credited with blocking the punt. |
| punt_block_return_player_name | character | Name of the player returning a blocked punt. |
| fg_kicker_player_name | character | Name of the field goal kicker. |
| yds_fg | numeric | Distance of the field goal attempt in yards. |
| fg_block_player_name | character | Name of the player credited with blocking the field goal. |
| fg_return_player_name | character | Name of the player returning the blocked/missed field goal. |
| kickoff_player_name | character | Name of the kickoff specialist. |
| yds_kickoff | numeric | Yards the ball traveled on the kickoff. |
| kickoff_returner_player_name | character | Name of the kickoff returner. |
| yds_kickoff_return | numeric | Yards gained on the kickoff return. |
| new_id | numeric | Numeric play index within the game (id_play with game_id stripped). |
| orig_drive_number | integer | Original CFBD drive number for the play. |
| drive_number | integer | cfbfastR-cleaned drive number for the play. |
| drive_result_detailed | character | Detailed drive result label (e.g. "Punt", "Passing Touchdown", "Downs Turnover"). |
| new_drive_pts | numeric | Points scored on the drive (signed for offense/defense). |
| drive_id | numeric | CFBD drive identifier. |
| drive_result | character | CFBD drive result label. |
| drive_start_yards_to_goal | numeric | Yards to goal at the start of the drive. |
| drive_end_yards_to_goal | integer | Yards to goal at the end of the drive. |
| drive_yards | integer | Net yards gained on the drive. |
| drive_scoring | numeric | Binary flag for a scoring drive. |
| drive_pts | numeric | Points scored on the drive (CFBD/cfbfastR reconciled value). |
| drive_start_period | integer | Period (quarter) at the start of the drive. |
| drive_end_period | integer | Period (quarter) at the end of the drive. |
| drive_time_minutes_start | integer | Minutes on the clock at the start of the drive. |
| drive_time_seconds_start | integer | Seconds on the clock at the start of the drive. |
| drive_time_minutes_end | integer | Minutes on the clock at the end of the drive. |
| drive_time_seconds_end | integer | Seconds on the clock at the end of the drive. |
| drive_time_minutes_elapsed | logical | Minutes elapsed during the drive. |
| drive_time_seconds_elapsed | logical | Seconds elapsed during the drive. |
| drive_numbers | numeric | Binary flag marking the first play of a new drive. |
| number_of_drives | numeric | Cumulative count of drives in the game. |
| pts_scored | numeric | Points scored on the play, signed by play_type rule. |
| drive_result_detailed_flag | character | Pre-fill copy of drive_result_detailed used during drive reconciliation. |
| drive_result2 | character | Short-form drive result label (e.g. "TD", "PUNT", "DOWNS"). |
| drive_num | numeric | Game-scoped drive sequence number. |
| lag_drive_result_detailed | character | Drive result detailed on the previous play (lag value). |
| lead_drive_result_detailed | character | Drive result detailed on the next play (lead value). |
| lag_new_drive_pts | numeric | Drive points on the previous play (lag value). |
| id_drive | character | Composite drive identifier (game_id concatenated with drive_num). |
| rush | numeric | Binary flag for a rushing play. |
| rush_td | numeric | Binary flag for a rushing touchdown. |
| pass | numeric | Binary flag for a passing play (includes sacks). |
| pass_td | numeric | Binary flag for a passing touchdown. |
| completion | numeric | Binary flag for a completed pass. |
| pass_attempt | numeric | Binary flag for a pass attempt. |
| target | numeric | Binary flag for a targeted receiver on the play. |
| sack_vec | numeric | Binary flag for a sack play. |
| sack | numeric | Binary flag for a sack (duplicate of sack_vec for downstream use). |
| int | numeric | Binary flag for an interception. |
| int_td | numeric | Binary flag for an interception returned for a touchdown. |
| turnover_vec | numeric | Binary flag for any play classified as a turnover. |
| turnover_vec_lag | numeric | Lag of turnover_vec (previous-play turnover flag). |
| turnover_indicator | numeric | Composite turnover indicator including failed 4th downs. |
| kickoff_play | numeric | Binary flag for a kickoff play. |
| receives_2H_kickoff | numeric | Binary flag for the team receiving the second-half kickoff. |
| missing_yard_flag | logical | TRUE when post-play yardage had to be imputed. |
| scoring_play | numeric | Binary flag for any scoring play. |
| td_play | numeric | Binary flag for a touchdown play. |
| touchdown | numeric | Binary flag for a touchdown (duplicate of td_play for downstream use). |
| safety | numeric | Binary flag for a safety. |
| fumble_vec | numeric | Binary flag for a play involving a fumble. |
| kickoff_tb | numeric | Binary flag for a kickoff touchback. |
| kickoff_onside | numeric | Binary flag for an onside kickoff attempt. |
| kickoff_oob | numeric | Binary flag for a kickoff out of bounds. |
| kickoff_fair_catch | numeric | Binary flag for a kickoff fair catch. |
| kickoff_downed | numeric | Binary flag for a kickoff downed in the field of play. |
| kickoff_safety | numeric | Binary flag for a kickoff safety. |
| kick_play | numeric | Binary flag for any kicking play (kickoff or field goal). |
| punt | numeric | Binary flag for a punt play. |
| punt_play | numeric | Binary flag for any punt-related play (includes blocks/returns). |
| punt_tb | numeric | Binary flag for a punt touchback. |
| punt_oob | numeric | Binary flag for a punt out of bounds. |
| punt_fair_catch | numeric | Binary flag for a punt fair catch. |
| punt_downed | numeric | Binary flag for a punt downed in the field of play. |
| punt_safety | numeric | Binary flag for a punt safety. |
| punt_blocked | numeric | Binary flag for a blocked punt. |
| penalty_safety | numeric | Binary flag for a safety scored on a penalty. |
| fg_inds | numeric | Binary flag for a field goal attempt. |
| fg_made | logical | TRUE when the field goal attempt was successful. |
| fg_make_prob | numeric | Predicted probability of making the field goal (cfbfastR FG model, 0-1). |
| No_Score_before | numeric | Pre-play predicted probability of no score before end of half (cfbfastR EP model, 0-1). |
| FG_before | numeric | Pre-play predicted probability of a posteam field goal next (0-1). |
| Opp_FG_before | numeric | Pre-play predicted probability of a defteam field goal next (0-1). |
| Opp_Safety_before | numeric | Pre-play predicted probability of a defteam safety next (0-1). |
| Opp_TD_before | numeric | Pre-play predicted probability of a defteam touchdown next (0-1). |
| Safety_before | numeric | Pre-play predicted probability of a posteam safety next (0-1). |
| TD_before | numeric | Pre-play predicted probability of a posteam touchdown next (0-1). |
| No_Score_after | numeric | Post-play predicted probability of no score before end of half (0-1). |
| FG_after | numeric | Post-play predicted probability of a posteam field goal next (0-1). |
| Opp_FG_after | numeric | Post-play predicted probability of a defteam field goal next (0-1). |
| Opp_Safety_after | numeric | Post-play predicted probability of a defteam safety next (0-1). |
| Opp_TD_after | numeric | Post-play predicted probability of a defteam touchdown next (0-1). |
| Safety_after | numeric | Post-play predicted probability of a posteam safety next (0-1). |
| TD_after | numeric | Post-play predicted probability of a posteam touchdown next (0-1). |
| penalty_flag | logical | TRUE when a penalty was flagged on the play. |
| penalty_declined | logical | TRUE when the penalty was declined. |
| penalty_no_play | logical | TRUE when the penalty nullified the play (no play counted). |
| penalty_offset | logical | TRUE when offsetting penalties were called. |
| penalty_text | logical | TRUE when penalty information is detectable in the play text. |
| penalty_play_text | character | Penalty-related substring extracted from the play text. |
| lead_wp_before2 | numeric | Win probability two plays ahead (lead 2 of wp_before). |
| wpa_half_end | numeric | WPA contribution from the end-of-half adjustment. |
| wpa_base | numeric | Base WPA component used to assemble the final wpa value. |
| wpa_base_nxt | numeric | WPA base component looking ahead one play. |
| wpa_change | numeric | WPA change-of-possession component for the current play. |
| wpa_change_nxt | numeric | WPA change-of-possession component for the next play. |
| wpa_base_ind | numeric | Indicator selecting the wpa_base path for the current play. |
| wpa_base_nxt_ind | numeric | Indicator selecting the wpa_base_nxt path for the next play. |
| wpa_change_ind | numeric | Indicator selecting the wpa_change path for the current play. |
| wpa_change_nxt_ind | numeric | Indicator selecting the wpa_change_nxt path for the next play. |
| lead_wp_before | numeric | Win probability on the next play (lead of wp_before). |
| lead_pos_team2 | character | Possession team two plays ahead (lead 2 of pos_team). |
| row | integer | Row index within the game grouping (sequencing helper). |
| drive_event_number | numeric | Sequential event number within the current drive. |
| lag_play_type2 | character | Play type two plays prior (lag 2 of play_type). |
| lag_play_type3 | character | Play type three plays prior (lag 3 of play_type). |
| lag_play_text | character | Play text from the previous play (lag value). |
| lag_play_text2 | character | Play text from two plays prior (lag 2 value). |
| lead_play_text | character | Play text from the next play (lead value). |
| lag_first_by_penalty | numeric | First-down-by-penalty flag from the previous play (lag value). |
| lag_first_by_penalty2 | numeric | First-down-by-penalty flag from two plays prior (lag 2 value). |
| lag_first_by_yards | numeric | First-down-by-yards flag from the previous play (lag value). |
| lag_first_by_yards2 | numeric | First-down-by-yards flag from two plays prior (lag 2 value). |
| first_by_penalty | numeric | Binary flag for a first down earned by penalty on the play. |
| first_by_yards | numeric | Binary flag for a first down earned by yards on the play. |
| play_after_turnover | numeric | Binary flag indicating the play immediately following a turnover. |
| lag_change_of_poss | numeric | change_of_poss from the previous play (lag value). |
| lag_change_of_pos_team | numeric | change_of_pos_team from the previous play (lag value). |
| lag_change_of_pos_team2 | numeric | change_of_pos_team from two plays prior (lag 2 value). |
| lag_kickoff_play | numeric | kickoff_play flag from the previous play (lag value). |
| lag_punt | numeric | punt flag from the previous play (lag value). |
| lag_punt2 | numeric | punt flag from two plays prior (lag 2 value). |
| lag_scoring_play | numeric | scoring_play flag from the previous play (lag value). |
| lag_turnover_vec | numeric | turnover_vec flag from the previous play (lag value). |
| lag_downs_turnover | numeric | downs_turnover flag from the previous play (lag value). |
| lag_defense_score_play | numeric | defense_score_play flag from the previous play (lag value). |
| lag_score_diff | numeric | score_diff from the previous play (lag value). |
| lag_offense_play | character | offense_play from the previous play (lag value). |
| lead_offense_play | character | offense_play from the next play (lead value). |
| lead_offense_play2 | character | offense_play from two plays ahead (lead 2 value). |
| lag_pos_score_diff | numeric | pos_score_diff from the previous play (lag value). |
| lag_off_timeouts | numeric | offense_timeouts from the previous play (lag value). |
| lag_def_timeouts | numeric | defense_timeouts from the previous play (lag value). |
| lag_TimeSecsRem2 | numeric | TimeSecsRem from two plays prior (lag 2 value). |
| lag_TimeSecsRem | numeric | TimeSecsRem from the previous play (lag value). |
| lead_TimeSecsRem | numeric | TimeSecsRem from the next play (lead value). |
| lead_TimeSecsRem2 | numeric | TimeSecsRem from two plays ahead (lead 2 value). |
| lag_yards_to_goal2 | integer | yards_to_goal from two plays prior (lag 2 value). |
| lag_yards_to_goal | integer | yards_to_goal from the previous play (lag value). |
| lead_yards_to_goal | numeric | yards_to_goal from the next play (lead value). |
| lead_yards_to_goal2 | integer | yards_to_goal from two plays ahead (lead 2 value). |
| lag_down2 | integer | Down number two plays prior (lag 2 value). |
| lag_down | integer | Down number from the previous play (lag value). |
| lead_down | numeric | Down number on the next play (lead value). |
| lead_down2 | numeric | Down number two plays ahead (lead 2 value). |
| lead_distance | numeric | Distance to go on the next play (lead value). |
| lead_distance2 | integer | Distance to go two plays ahead (lead 2 value). |
| lead_play_type2 | character | Play type two plays ahead (lead 2 value). |
| lead_play_type3 | character | Play type three plays ahead (lead 3 value). |
| lag_ep_before3 | numeric | ep_before from three plays prior (lag 3 value). |
| lag_ep_before2 | numeric | ep_before from two plays prior (lag 2 value). |
| lag_ep_before | numeric | ep_before from the previous play (lag value). |
| lead_ep_before | numeric | ep_before on the next play (lead value). |
| lead_ep_before2 | numeric | ep_before two plays ahead (lead 2 value). |
| lag_ep_after | numeric | ep_after from the previous play (lag value). |
| lag_ep_after2 | numeric | ep_after from two plays prior (lag 2 value). |
| lag_ep_after3 | numeric | ep_after from three plays prior (lag 3 value). |
| lead_ep_after | numeric | ep_after on the next play (lead value). |
| lead_ep_after2 | numeric | ep_after two plays ahead (lead 2 value). |
| play_number | integer | CFBD-supplied play number within the game. |
| wallclock | character | ISO 8601 wall-clock timestamp from CFBD for the play. |
| provider | character | Sportsbook provider used for spread/over_under joined onto the play. |
| spread | numeric | Pre-game point spread from the selected provider. |
| formatted_spread | character | Human-readable formatted spread string from the betting provider. |
| over_under | numeric | Pre-game over/under total from the selected provider. |
| drive_is_home_offense | logical | TRUE when the home team is on offense for the drive. |
| drive_start_offense_score | integer | Offense score at the start of the drive. |
| drive_start_defense_score | integer | Defense score at the start of the drive. |
| drive_end_offense_score | integer | Offense score at the end of the drive. |
| drive_end_defense_score | integer | Defense score at the end of the drive. |
| play | numeric | Binary flag indicating the row is a counted play (excludes end markers/timeouts/penalties). |
| event | numeric | Binary flag indicating the row is a counted game event (excludes end markers). |
| game_event_number | numeric | Sequential event number within the game. |
| game_row_number | integer | Row index within the game grouping. |
| half_play | numeric | Binary flag indicating a counted play within the half. |
| half_event | numeric | Binary flag indicating a counted event within the half. |
| half_event_number | numeric | Sequential event number within the half. |
| half_row_number | integer | Row index within the half grouping. |
| lag_distance3 | integer | distance three plays prior (lag 3 value). |
| lag_distance2 | integer | distance two plays prior (lag 2 value). |
| lag_distance | integer | distance from the previous play (lag value). |
| lag_yards_gained3 | integer | yards_gained three plays prior (lag 3 value). |
| lag_yards_gained2 | integer | yards_gained two plays prior (lag 2 value). |
| lag_yards_gained | integer | yards_gained from the previous play (lag value). |
| lead_yards_gained | integer | yards_gained on the next play (lead value). |
| lead_yards_gained2 | integer | yards_gained two plays ahead (lead 2 value). |
| lag_play_text3 | character | Play text from three plays prior (lag 3 value). |
| lead_play_text2 | character | Play text from two plays ahead (lead 2 value). |
| lead_play_text3 | character | Play text from three plays ahead (lead 3 value). |
| pos_unit | character | Possession-team unit label (offense or special teams). |
| def_pos_unit | character | Defensive possession-team unit label (defense or special teams). |
| lag_change_of_poss2 | numeric | change_of_poss from two plays prior (lag 2 value). |
| lag_change_of_poss3 | numeric | change_of_poss from three plays prior (lag 3 value). |
| lag_change_of_pos_team3 | numeric | change_of_pos_team from three plays prior (lag 3 value). |
| lag_kickoff_play2 | numeric | kickoff_play flag from two plays prior (lag 2 value). |
| lag_kickoff_play3 | numeric | kickoff_play flag from three plays prior (lag 3 value). |
| lag_punt3 | numeric | punt flag from three plays prior (lag 3 value). |
| lag_scoring_play2 | numeric | scoring_play flag from two plays prior (lag 2 value). |
| lag_scoring_play3 | numeric | scoring_play flag from three plays prior (lag 3 value). |
| lag_turnover_vec2 | numeric | turnover_vec flag from two plays prior (lag 2 value). |
| lag_turnover_vec3 | numeric | turnover_vec flag from three plays prior (lag 3 value). |
| lag_downs_turnover2 | numeric | downs_turnover flag from two plays prior (lag 2 value). |
| lag_downs_turnover3 | numeric | downs_turnover flag from three plays prior (lag 3 value). |
| drive_play | numeric | Binary flag indicating a counted play within the drive. |
| drive_event | numeric | Binary flag indicating a counted event within the drive. |
| lag_first_by_penalty3 | numeric | first_by_penalty flag from three plays prior (lag 3 value). |
| lag_first_by_yards3 | numeric | first_by_yards flag from three plays prior (lag 3 value). |

## Details

     # Get play by play data for 2025 regular season week 1
     cfbd_pbp_data(year = 2025, week = 1, season_type = 'regular', epa_wpa = TRUE)

## See also

Other CFBD PBP:
[`cfbd_live_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_plays.md),
[`cfbd_pbp_data_v2()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data_v2.md),
[`cfbd_play_stats_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_player.md),
[`cfbd_play_stats_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_types.md),
[`cfbd_play_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_types.md),
[`cfbd_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_plays.md)
