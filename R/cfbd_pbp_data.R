#' @name cfbd_pbp
#' @aliases cfbd_pbp play_by_play
#' @title
#' **CFBD Play-by-Play Endpoint Overview**
#' @description
#'
#' * `cfbd_pbp_data()`: Get college football play by play data with cfbfastR expected points/win probability added.
#'
#' @details
#' The modular successor `cfbd_pbp_data_v2()` ships in a sibling file and
#' references the same CFBD upstream.
#'
#' ## **Get college football play by play data with cfbfastR expected points/win probability added**
#'
#' ```r
#'  # Get play by play data for 2025 regular season week 1
#'  cfbd_pbp_data(year = 2025, week = 1, season_type = 'regular', epa_wpa = TRUE)
#' ```
#'
NULL

#' @title
#' **Get college football play by play data with cfbfastR expected points/win probability added**
#' @description
#' Extract college football (D-I) play by play Data - for plays
#' @param season_type (*String* default regular): Season type - regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param year Select year, (example: 2018) \cr
#' Minimum value accepted: `r min_year_map_df[min_year_map_df$function_name == 'cfbd_pbp_data', 'min_year']`
#' @param week Select week, this is optional (also numeric)
#' @param team Select team name (example: Texas, Texas A&M, Clemson)
#' @param play_type Select play type (example: see the [cfbd_play_type_df])
#' @param epa_wpa Logical parameter (TRUE/FALSE) to return the Expected Points Added/Win Probability Added variables
#' @param ... Additional arguments passed to an underlying function.
#' @return A data frame with 368 variables:
#'
#'   |col_name                         |types     |description                                                                                                  |
#'   |:--------------------------------|:---------|:------------------------------------------------------------------------------------------------------------|
#'   |season                           |numeric   |Four-digit season year (e.g. 2024).                                                                          |
#'   |wk                               |numeric   |Season week number (1-15 regular season, 1 for bowl/postseason week).                                        |
#'   |id_play                          |character |Unique CFBD play identifier (concatenates game_id and play index).                                           |
#'   |game_id                          |integer   |CFBD-internal game identifier.                                                                               |
#'   |game_play_number                 |numeric   |Sequential play number within the game (excludes timeouts/end markers).                                      |
#'   |half_play_number                 |numeric   |Sequential play number within the current half.                                                              |
#'   |drive_play_number                |numeric   |Sequential play number within the current drive.                                                             |
#'   |pos_team                         |character |Team name in possession at the start of the play (offense, kickoff-aware).                                   |
#'   |def_pos_team                     |character |Team name on defense at the start of the play.                                                               |
#'   |pos_team_score                   |integer   |Score for the team in possession at the start of the play.                                                   |
#'   |def_pos_team_score               |integer   |Score for the defensive team at the start of the play.                                                       |
#'   |half                             |factor    |Half indicator (1 or 2).                                                                                     |
#'   |period                           |integer   |Quarter number (1-4, 5+ for overtime).                                                                       |
#'   |clock_minutes                    |integer   |Minutes remaining on the period clock at the start of the play.                                              |
#'   |clock_seconds                    |integer   |Seconds remaining on the period clock at the start of the play.                                              |
#'   |play_type                        |character |CFBD play type label (e.g. "Rush", "Pass Reception", "Field Goal Good").                                     |
#'   |play_text                        |character |Free-text description of the play from CFBD.                                                                 |
#'   |down                             |numeric   |Down number at the start of the play (1-4).                                                                  |
#'   |distance                         |numeric   |Yards to gain for a first down at the start of the play.                                                     |
#'   |yards_to_goal                    |numeric   |Yards from the offense to the opponent's end zone at the start of the play.                                  |
#'   |yards_gained                     |numeric   |Yards gained (or lost) by the offense on the play.                                                           |
#'   |EPA                              |numeric   |Expected Points Added on the play (cfbfastR EPA model output).                                               |
#'   |ep_before                        |numeric   |Expected points value before the play (cfbfastR EPA model).                                                  |
#'   |ep_after                         |numeric   |Expected points value after the play (cfbfastR EPA model).                                                   |
#'   |wpa                              |numeric   |Win Probability Added on the play (cfbfastR WP model output).                                                |
#'   |wp_before                        |numeric   |Win probability for the possession team before the play (0-1).                                               |
#'   |wp_after                         |numeric   |Win probability for the possession team after the play (0-1).                                                |
#'   |def_wp_before                    |numeric   |Win probability for the defensive team before the play (0-1).                                                |
#'   |def_wp_after                     |numeric   |Win probability for the defensive team after the play (0-1).                                                 |
#'   |penalty_detail                   |character |Parsed penalty description extracted from play text.                                                         |
#'   |yds_penalty                      |numeric   |Yardage assessed on the penalty.                                                                             |
#'   |penalty_1st_conv                 |logical   |TRUE when the penalty resulted in a first down conversion.                                                   |
#'   |new_series                       |numeric   |Binary flag for the start of a new series of downs.                                                          |
#'   |firstD_by_kickoff                |numeric   |Binary flag for a new first down arising from a kickoff.                                                     |
#'   |firstD_by_poss                   |numeric   |Binary flag for a new first down via change of possession.                                                   |
#'   |firstD_by_penalty                |numeric   |Binary flag for a new first down via penalty.                                                                |
#'   |firstD_by_yards                  |numeric   |Binary flag for a new first down via yards gained.                                                           |
#'   |def_EPA                          |numeric   |EPA for the defensive team on the play (sign-flipped offense EPA).                                           |
#'   |home_EPA                         |numeric   |EPA for the home team on the play.                                                                           |
#'   |away_EPA                         |numeric   |EPA for the away team on the play.                                                                           |
#'   |home_EPA_rush                    |numeric   |Rushing EPA for the home team on the play.                                                                   |
#'   |away_EPA_rush                    |numeric   |Rushing EPA for the away team on the play.                                                                   |
#'   |home_EPA_pass                    |numeric   |Passing EPA for the home team on the play.                                                                   |
#'   |away_EPA_pass                    |numeric   |Passing EPA for the away team on the play.                                                                   |
#'   |total_home_EPA                   |numeric   |Cumulative total EPA for the home team through the play.                                                     |
#'   |total_away_EPA                   |numeric   |Cumulative total EPA for the away team through the play.                                                     |
#'   |total_home_EPA_rush              |numeric   |Cumulative rushing EPA for the home team through the play.                                                   |
#'   |total_away_EPA_rush              |numeric   |Cumulative rushing EPA for the away team through the play.                                                   |
#'   |total_home_EPA_pass              |numeric   |Cumulative passing EPA for the home team through the play.                                                   |
#'   |total_away_EPA_pass              |numeric   |Cumulative passing EPA for the away team through the play.                                                   |
#'   |net_home_EPA                     |numeric   |Net EPA differential (home minus away) through the play.                                                     |
#'   |net_away_EPA                     |numeric   |Net EPA differential (away minus home) through the play.                                                     |
#'   |net_home_EPA_rush                |numeric   |Net rushing EPA differential for the home team through the play.                                             |
#'   |net_away_EPA_rush                |numeric   |Net rushing EPA differential for the away team through the play.                                             |
#'   |net_home_EPA_pass                |numeric   |Net passing EPA differential for the home team through the play.                                             |
#'   |net_away_EPA_pass                |numeric   |Net passing EPA differential for the away team through the play.                                             |
#'   |success                          |numeric   |Binary success-rate flag using the 50/70/100 percent down-state thresholds.                                  |
#'   |epa_success                      |numeric   |Binary flag for plays with positive EPA (EPA > 0).                                                           |
#'   |rz_play                          |numeric   |Binary flag for a red-zone play (yards_to_goal <= 20).                                                       |
#'   |scoring_opp                      |numeric   |Binary flag for a scoring opportunity (yards_to_goal <= 40).                                                 |
#'   |middle_8                         |logical   |TRUE for plays in the middle-8 window (final 4 min of 1H, first 4 min of 2H).                                |
#'   |stuffed_run                      |numeric   |Binary flag for a stuffed run (zero or negative yards gained).                                               |
#'   |change_of_pos_team               |numeric   |Binary flag for change of possession-team on the play.                                                       |
#'   |downs_turnover                   |numeric   |Binary flag for a turnover on downs.                                                                         |
#'   |turnover                         |numeric   |Binary flag for any turnover on the play.                                                                    |
#'   |pos_score_diff_start             |numeric   |Score differential for the possession team at the start of the play.                                         |
#'   |pos_score_pts                    |numeric   |Points scored on the play attributed to the possession team.                                                 |
#'   |log_ydstogo                      |numeric   |Natural log of distance-to-go (model feature).                                                               |
#'   |ExpScoreDiff                     |numeric   |Expected score differential at the start of the play (EPA-adjusted).                                         |
#'   |ExpScoreDiff_Time_Ratio          |numeric   |Expected score differential scaled by share of time remaining.                                               |
#'   |half_clock_minutes               |numeric   |Minutes remaining in the half (15 + clock_minutes when in Q1/Q3).                                            |
#'   |TimeSecsRem                      |numeric   |Seconds remaining in the half at the start of the play.                                                      |
#'   |adj_TimeSecsRem                  |numeric   |Adjusted seconds remaining used by the EPA/WP models.                                                        |
#'   |Goal_To_Go                       |logical   |TRUE when the offense is in a goal-to-go situation.                                                          |
#'   |Under_two                        |logical   |TRUE when under two minutes remain in the half.                                                              |
#'   |home                             |character |Home team name.                                                                                              |
#'   |away                             |character |Away team name.                                                                                              |
#'   |home_wp_before                   |numeric   |Home team win probability before the play (0-1).                                                             |
#'   |away_wp_before                   |numeric   |Away team win probability before the play (0-1).                                                             |
#'   |home_wp_after                    |numeric   |Home team win probability after the play (0-1).                                                              |
#'   |away_wp_after                    |numeric   |Away team win probability after the play (0-1).                                                              |
#'   |end_of_half                      |numeric   |Binary flag for the last play of a half.                                                                     |
#'   |pos_team_receives_2H_kickoff     |numeric   |Binary flag indicating possession team receives the second-half kickoff.                                     |
#'   |lead_pos_team                    |character |Possession team on the next play (lead value).                                                               |
#'   |lead_play_type                   |character |Play type on the next play (lead value).                                                                     |
#'   |lag_pos_team                     |character |Possession team on the previous play (lag value).                                                            |
#'   |lag_play_type                    |character |Play type on the previous play (lag value).                                                                  |
#'   |orig_play_type                   |character |Original CFBD play type label before cfbfastR cleaning.                                                      |
#'   |Under_three                      |logical   |TRUE when under three minutes remain in the half.                                                            |
#'   |down_end                         |factor    |Down number at the end of the play (post-play state).                                                        |
#'   |distance_end                     |numeric   |Distance-to-go at the end of the play (post-play state).                                                     |
#'   |log_ydstogo_end                  |numeric   |Natural log of post-play distance-to-go (model feature).                                                     |
#'   |yards_to_goal_end                |numeric   |Yards to opponent end zone at the end of the play.                                                           |
#'   |TimeSecsRem_end                  |numeric   |Seconds remaining in the half at the end of the play.                                                        |
#'   |Goal_To_Go_end                   |logical   |TRUE when the post-play state is goal-to-go.                                                                 |
#'   |Under_two_end                    |logical   |TRUE when the post-play state is under two minutes.                                                          |
#'   |offense_score_play               |numeric   |Binary flag for an offensive scoring play.                                                                   |
#'   |defense_score_play               |numeric   |Binary flag for a defensive scoring play.                                                                    |
#'   |ppa                              |numeric   |Predicted Points Added from the CFBD ppa endpoint (CFB-EPA analogue).                                        |
#'   |yard_line                        |integer   |Yard line where the play started (raw CFBD yardline field).                                                  |
#'   |scoring                          |logical   |TRUE when the play resulted in a score (CFBD scoring flag).                                                  |
#'   |pos_team_timeouts_rem_before     |numeric   |Possession team timeouts remaining before the play.                                                          |
#'   |def_pos_team_timeouts_rem_before |numeric   |Defensive team timeouts remaining before the play.                                                           |
#'   |pos_team_timeouts                |integer   |Possession team timeouts remaining after the play.                                                           |
#'   |def_pos_team_timeouts            |integer   |Defensive team timeouts remaining after the play.                                                            |
#'   |pos_score_diff                   |integer   |Score differential from the possession team's perspective.                                                   |
#'   |pos_score_diff_start_end         |numeric   |Score differential aggregated from start to end of the play.                                                 |
#'   |offense_play                     |character |Offensive team name as labeled by CFBD on the play.                                                          |
#'   |defense_play                     |character |Defensive team name as labeled by CFBD on the play.                                                          |
#'   |offense_receives_2H_kickoff      |numeric   |Binary flag indicating offense receives the second-half kickoff.                                             |
#'   |change_of_poss                   |numeric   |Binary flag for change of possession on the play (CFBD offense field).                                       |
#'   |score_pts                        |numeric   |Points scored on the play.                                                                                   |
#'   |score_diff_start                 |numeric   |Score differential at the start of the play.                                                                 |
#'   |score_diff                       |integer   |Score differential (offense_score - defense_score) at the start.                                             |
#'   |offense_score                    |integer   |Offense team score at the start of the play.                                                                 |
#'   |defense_score                    |integer   |Defense team score at the start of the play.                                                                 |
#'   |offense_conference               |character |Conference name of the offensive team.                                                                       |
#'   |defense_conference               |character |Conference name of the defensive team.                                                                       |
#'   |off_timeout_called               |numeric   |Binary flag for an offensive timeout called during the play.                                                 |
#'   |def_timeout_called               |numeric   |Binary flag for a defensive timeout called during the play.                                                  |
#'   |offense_timeouts                 |integer   |Offense timeouts remaining after the play (CFBD field).                                                      |
#'   |defense_timeouts                 |integer   |Defense timeouts remaining after the play (CFBD field).                                                      |
#'   |off_timeouts_rem_before          |numeric   |Offense timeouts remaining before the play.                                                                  |
#'   |def_timeouts_rem_before          |numeric   |Defense timeouts remaining before the play.                                                                  |
#'   |rusher_player_name               |character |Name of the rusher on a rushing play.                                                                        |
#'   |yds_rushed                       |numeric   |Rushing yards gained on the play.                                                                            |
#'   |passer_player_name               |character |Name of the passer on a passing play.                                                                        |
#'   |receiver_player_name             |character |Name of the receiver on a passing play.                                                                      |
#'   |yds_receiving                    |numeric   |Receiving yards gained on the play.                                                                          |
#'   |yds_sacked                       |numeric   |Yards lost on the sack.                                                                                      |
#'   |sack_players                     |character |Combined names of all sack participants.                                                                     |
#'   |sack_player_name                 |character |Primary sack player name.                                                                                    |
#'   |sack_player_name2                |character |Secondary sack player name (when split between two defenders).                                               |
#'   |pass_breakup_player_name         |character |Name of the defender credited with the pass breakup.                                                         |
#'   |interception_player_name         |character |Name of the defender credited with the interception.                                                         |
#'   |yds_int_return                   |numeric   |Yards gained on an interception return.                                                                      |
#'   |fumble_player_name               |character |Name of the player who fumbled.                                                                              |
#'   |fumble_forced_player_name        |character |Name of the player who forced the fumble.                                                                    |
#'   |fumble_recovered_player_name     |character |Name of the player who recovered the fumble.                                                                 |
#'   |yds_fumble_return                |numeric   |Yards gained on a fumble return.                                                                             |
#'   |punter_player_name               |character |Name of the punter.                                                                                          |
#'   |yds_punted                       |numeric   |Yards the ball traveled on the punt.                                                                         |
#'   |punt_returner_player_name        |character |Name of the punt returner.                                                                                   |
#'   |yds_punt_return                  |numeric   |Yards gained on the punt return.                                                                             |
#'   |yds_punt_gained                  |numeric   |Net yards gained on the punt (punt distance minus return).                                                   |
#'   |punt_block_player_name           |character |Name of the player credited with blocking the punt.                                                          |
#'   |punt_block_return_player_name    |character |Name of the player returning a blocked punt.                                                                 |
#'   |fg_kicker_player_name            |character |Name of the field goal kicker.                                                                               |
#'   |yds_fg                           |numeric   |Distance of the field goal attempt in yards.                                                                 |
#'   |fg_block_player_name             |character |Name of the player credited with blocking the field goal.                                                    |
#'   |fg_return_player_name            |character |Name of the player returning the blocked/missed field goal.                                                  |
#'   |kickoff_player_name              |character |Name of the kickoff specialist.                                                                              |
#'   |yds_kickoff                      |numeric   |Yards the ball traveled on the kickoff.                                                                      |
#'   |kickoff_returner_player_name     |character |Name of the kickoff returner.                                                                                |
#'   |yds_kickoff_return               |numeric   |Yards gained on the kickoff return.                                                                          |
#'   |new_id                           |numeric   |Numeric play index within the game (id_play with game_id stripped).                                          |
#'   |orig_drive_number                |integer   |Original CFBD drive number for the play.                                                                     |
#'   |drive_number                     |integer   |cfbfastR-cleaned drive number for the play.                                                                  |
#'   |drive_result_detailed            |character |Detailed drive result label (e.g. "Punt", "Passing Touchdown", "Downs Turnover").                            |
#'   |new_drive_pts                    |numeric   |Points scored on the drive (signed for offense/defense).                                                     |
#'   |drive_id                         |numeric   |CFBD drive identifier.                                                                                       |
#'   |drive_result                     |character |CFBD drive result label.                                                                                     |
#'   |drive_start_yards_to_goal        |numeric   |Yards to goal at the start of the drive.                                                                     |
#'   |drive_end_yards_to_goal          |integer   |Yards to goal at the end of the drive.                                                                       |
#'   |drive_yards                      |integer   |Net yards gained on the drive.                                                                               |
#'   |drive_scoring                    |numeric   |Binary flag for a scoring drive.                                                                             |
#'   |drive_pts                        |numeric   |Points scored on the drive (CFBD/cfbfastR reconciled value).                                                 |
#'   |drive_start_period               |integer   |Period (quarter) at the start of the drive.                                                                  |
#'   |drive_end_period                 |integer   |Period (quarter) at the end of the drive.                                                                    |
#'   |drive_time_minutes_start         |integer   |Minutes on the clock at the start of the drive.                                                              |
#'   |drive_time_seconds_start         |integer   |Seconds on the clock at the start of the drive.                                                              |
#'   |drive_time_minutes_end           |integer   |Minutes on the clock at the end of the drive.                                                                |
#'   |drive_time_seconds_end           |integer   |Seconds on the clock at the end of the drive.                                                                |
#'   |drive_time_minutes_elapsed       |logical   |Minutes elapsed during the drive.                                                                            |
#'   |drive_time_seconds_elapsed       |logical   |Seconds elapsed during the drive.                                                                            |
#'   |drive_numbers                    |numeric   |Binary flag marking the first play of a new drive.                                                           |
#'   |number_of_drives                 |numeric   |Cumulative count of drives in the game.                                                                      |
#'   |pts_scored                       |numeric   |Points scored on the play, signed by play_type rule.                                                         |
#'   |drive_result_detailed_flag       |character |Pre-fill copy of drive_result_detailed used during drive reconciliation.                                     |
#'   |drive_result2                    |character |Short-form drive result label (e.g. "TD", "PUNT", "DOWNS").                                                  |
#'   |drive_num                        |numeric   |Game-scoped drive sequence number.                                                                           |
#'   |lag_drive_result_detailed        |character |Drive result detailed on the previous play (lag value).                                                      |
#'   |lead_drive_result_detailed       |character |Drive result detailed on the next play (lead value).                                                         |
#'   |lag_new_drive_pts                |numeric   |Drive points on the previous play (lag value).                                                               |
#'   |id_drive                         |character |Composite drive identifier (game_id concatenated with drive_num).                                            |
#'   |rush                             |numeric   |Binary flag for a rushing play.                                                                              |
#'   |rush_td                          |numeric   |Binary flag for a rushing touchdown.                                                                         |
#'   |pass                             |numeric   |Binary flag for a passing play (includes sacks).                                                             |
#'   |pass_td                          |numeric   |Binary flag for a passing touchdown.                                                                         |
#'   |completion                       |numeric   |Binary flag for a completed pass.                                                                            |
#'   |pass_attempt                     |numeric   |Binary flag for a pass attempt.                                                                              |
#'   |target                           |numeric   |Binary flag for a targeted receiver on the play.                                                             |
#'   |sack_vec                         |numeric   |Binary flag for a sack play.                                                                                 |
#'   |sack                             |numeric   |Binary flag for a sack (duplicate of sack_vec for downstream use).                                           |
#'   |int                              |numeric   |Binary flag for an interception.                                                                             |
#'   |int_td                           |numeric   |Binary flag for an interception returned for a touchdown.                                                    |
#'   |turnover_vec                     |numeric   |Binary flag for any play classified as a turnover.                                                           |
#'   |turnover_vec_lag                 |numeric   |Lag of turnover_vec (previous-play turnover flag).                                                           |
#'   |turnover_indicator               |numeric   |Composite turnover indicator including failed 4th downs.                                                     |
#'   |kickoff_play                     |numeric   |Binary flag for a kickoff play.                                                                              |
#'   |receives_2H_kickoff              |numeric   |Binary flag for the team receiving the second-half kickoff.                                                  |
#'   |missing_yard_flag                |logical   |TRUE when post-play yardage had to be imputed.                                                               |
#'   |scoring_play                     |numeric   |Binary flag for any scoring play.                                                                            |
#'   |td_play                          |numeric   |Binary flag for a touchdown play.                                                                            |
#'   |touchdown                        |numeric   |Binary flag for a touchdown (duplicate of td_play for downstream use).                                       |
#'   |safety                           |numeric   |Binary flag for a safety.                                                                                    |
#'   |fumble_vec                       |numeric   |Binary flag for a play involving a fumble.                                                                   |
#'   |kickoff_tb                       |numeric   |Binary flag for a kickoff touchback.                                                                         |
#'   |kickoff_onside                   |numeric   |Binary flag for an onside kickoff attempt.                                                                   |
#'   |kickoff_oob                      |numeric   |Binary flag for a kickoff out of bounds.                                                                     |
#'   |kickoff_fair_catch               |numeric   |Binary flag for a kickoff fair catch.                                                                        |
#'   |kickoff_downed                   |numeric   |Binary flag for a kickoff downed in the field of play.                                                       |
#'   |kickoff_safety                   |numeric   |Binary flag for a kickoff safety.                                                                            |
#'   |kick_play                        |numeric   |Binary flag for any kicking play (kickoff or field goal).                                                    |
#'   |punt                             |numeric   |Binary flag for a punt play.                                                                                 |
#'   |punt_play                        |numeric   |Binary flag for any punt-related play (includes blocks/returns).                                             |
#'   |punt_tb                          |numeric   |Binary flag for a punt touchback.                                                                            |
#'   |punt_oob                         |numeric   |Binary flag for a punt out of bounds.                                                                        |
#'   |punt_fair_catch                  |numeric   |Binary flag for a punt fair catch.                                                                           |
#'   |punt_downed                      |numeric   |Binary flag for a punt downed in the field of play.                                                          |
#'   |punt_safety                      |numeric   |Binary flag for a punt safety.                                                                               |
#'   |punt_blocked                     |numeric   |Binary flag for a blocked punt.                                                                              |
#'   |penalty_safety                   |numeric   |Binary flag for a safety scored on a penalty.                                                                |
#'   |fg_inds                          |numeric   |Binary flag for a field goal attempt.                                                                        |
#'   |fg_made                          |logical   |TRUE when the field goal attempt was successful.                                                             |
#'   |fg_make_prob                     |numeric   |Predicted probability of making the field goal (cfbfastR FG model, 0-1).                                     |
#'   |No_Score_before                  |numeric   |Pre-play predicted probability of no score before end of half (cfbfastR EP model, 0-1).                      |
#'   |FG_before                        |numeric   |Pre-play predicted probability of a posteam field goal next (0-1).                                           |
#'   |Opp_FG_before                    |numeric   |Pre-play predicted probability of a defteam field goal next (0-1).                                           |
#'   |Opp_Safety_before                |numeric   |Pre-play predicted probability of a defteam safety next (0-1).                                               |
#'   |Opp_TD_before                    |numeric   |Pre-play predicted probability of a defteam touchdown next (0-1).                                            |
#'   |Safety_before                    |numeric   |Pre-play predicted probability of a posteam safety next (0-1).                                               |
#'   |TD_before                        |numeric   |Pre-play predicted probability of a posteam touchdown next (0-1).                                            |
#'   |No_Score_after                   |numeric   |Post-play predicted probability of no score before end of half (0-1).                                        |
#'   |FG_after                         |numeric   |Post-play predicted probability of a posteam field goal next (0-1).                                          |
#'   |Opp_FG_after                     |numeric   |Post-play predicted probability of a defteam field goal next (0-1).                                          |
#'   |Opp_Safety_after                 |numeric   |Post-play predicted probability of a defteam safety next (0-1).                                              |
#'   |Opp_TD_after                     |numeric   |Post-play predicted probability of a defteam touchdown next (0-1).                                           |
#'   |Safety_after                     |numeric   |Post-play predicted probability of a posteam safety next (0-1).                                              |
#'   |TD_after                         |numeric   |Post-play predicted probability of a posteam touchdown next (0-1).                                           |
#'   |penalty_flag                     |logical   |TRUE when a penalty was flagged on the play.                                                                 |
#'   |penalty_declined                 |logical   |TRUE when the penalty was declined.                                                                          |
#'   |penalty_no_play                  |logical   |TRUE when the penalty nullified the play (no play counted).                                                  |
#'   |penalty_offset                   |logical   |TRUE when offsetting penalties were called.                                                                  |
#'   |penalty_text                     |logical   |TRUE when penalty information is detectable in the play text.                                                |
#'   |penalty_play_text                |character |Penalty-related substring extracted from the play text.                                                      |
#'   |lead_wp_before2                  |numeric   |Win probability two plays ahead (lead 2 of wp_before).                                                       |
#'   |wpa_half_end                     |numeric   |WPA contribution from the end-of-half adjustment.                                                            |
#'   |wpa_base                         |numeric   |Base WPA component used to assemble the final wpa value.                                                     |
#'   |wpa_base_nxt                     |numeric   |WPA base component looking ahead one play.                                                                   |
#'   |wpa_change                       |numeric   |WPA change-of-possession component for the current play.                                                     |
#'   |wpa_change_nxt                   |numeric   |WPA change-of-possession component for the next play.                                                        |
#'   |wpa_base_ind                     |numeric   |Indicator selecting the wpa_base path for the current play.                                                  |
#'   |wpa_base_nxt_ind                 |numeric   |Indicator selecting the wpa_base_nxt path for the next play.                                                 |
#'   |wpa_change_ind                   |numeric   |Indicator selecting the wpa_change path for the current play.                                                |
#'   |wpa_change_nxt_ind               |numeric   |Indicator selecting the wpa_change_nxt path for the next play.                                               |
#'   |lead_wp_before                   |numeric   |Win probability on the next play (lead of wp_before).                                                        |
#'   |lead_pos_team2                   |character |Possession team two plays ahead (lead 2 of pos_team).                                                        |
#'   |row                              |integer   |Row index within the game grouping (sequencing helper).                                                      |
#'   |drive_event_number               |numeric   |Sequential event number within the current drive.                                                            |
#'   |lag_play_type2                   |character |Play type two plays prior (lag 2 of play_type).                                                              |
#'   |lag_play_type3                   |character |Play type three plays prior (lag 3 of play_type).                                                            |
#'   |lag_play_text                    |character |Play text from the previous play (lag value).                                                                |
#'   |lag_play_text2                   |character |Play text from two plays prior (lag 2 value).                                                                |
#'   |lead_play_text                   |character |Play text from the next play (lead value).                                                                   |
#'   |lag_first_by_penalty             |numeric   |First-down-by-penalty flag from the previous play (lag value).                                               |
#'   |lag_first_by_penalty2            |numeric   |First-down-by-penalty flag from two plays prior (lag 2 value).                                               |
#'   |lag_first_by_yards               |numeric   |First-down-by-yards flag from the previous play (lag value).                                                 |
#'   |lag_first_by_yards2              |numeric   |First-down-by-yards flag from two plays prior (lag 2 value).                                                 |
#'   |first_by_penalty                 |numeric   |Binary flag for a first down earned by penalty on the play.                                                  |
#'   |first_by_yards                   |numeric   |Binary flag for a first down earned by yards on the play.                                                    |
#'   |play_after_turnover              |numeric   |Binary flag indicating the play immediately following a turnover.                                            |
#'   |lag_change_of_poss               |numeric   |change_of_poss from the previous play (lag value).                                                           |
#'   |lag_change_of_pos_team           |numeric   |change_of_pos_team from the previous play (lag value).                                                       |
#'   |lag_change_of_pos_team2          |numeric   |change_of_pos_team from two plays prior (lag 2 value).                                                       |
#'   |lag_kickoff_play                 |numeric   |kickoff_play flag from the previous play (lag value).                                                        |
#'   |lag_punt                         |numeric   |punt flag from the previous play (lag value).                                                                |
#'   |lag_punt2                        |numeric   |punt flag from two plays prior (lag 2 value).                                                                |
#'   |lag_scoring_play                 |numeric   |scoring_play flag from the previous play (lag value).                                                        |
#'   |lag_turnover_vec                 |numeric   |turnover_vec flag from the previous play (lag value).                                                        |
#'   |lag_downs_turnover               |numeric   |downs_turnover flag from the previous play (lag value).                                                      |
#'   |lag_defense_score_play           |numeric   |defense_score_play flag from the previous play (lag value).                                                  |
#'   |lag_score_diff                   |numeric   |score_diff from the previous play (lag value).                                                               |
#'   |lag_offense_play                 |character |offense_play from the previous play (lag value).                                                             |
#'   |lead_offense_play                |character |offense_play from the next play (lead value).                                                                |
#'   |lead_offense_play2               |character |offense_play from two plays ahead (lead 2 value).                                                            |
#'   |lag_pos_score_diff               |numeric   |pos_score_diff from the previous play (lag value).                                                           |
#'   |lag_off_timeouts                 |numeric   |offense_timeouts from the previous play (lag value).                                                         |
#'   |lag_def_timeouts                 |numeric   |defense_timeouts from the previous play (lag value).                                                         |
#'   |lag_TimeSecsRem2                 |numeric   |TimeSecsRem from two plays prior (lag 2 value).                                                              |
#'   |lag_TimeSecsRem                  |numeric   |TimeSecsRem from the previous play (lag value).                                                              |
#'   |lead_TimeSecsRem                 |numeric   |TimeSecsRem from the next play (lead value).                                                                 |
#'   |lead_TimeSecsRem2                |numeric   |TimeSecsRem from two plays ahead (lead 2 value).                                                             |
#'   |lag_yards_to_goal2               |integer   |yards_to_goal from two plays prior (lag 2 value).                                                            |
#'   |lag_yards_to_goal                |integer   |yards_to_goal from the previous play (lag value).                                                            |
#'   |lead_yards_to_goal               |numeric   |yards_to_goal from the next play (lead value).                                                               |
#'   |lead_yards_to_goal2              |integer   |yards_to_goal from two plays ahead (lead 2 value).                                                           |
#'   |lag_down2                        |integer   |Down number two plays prior (lag 2 value).                                                                   |
#'   |lag_down                         |integer   |Down number from the previous play (lag value).                                                              |
#'   |lead_down                        |numeric   |Down number on the next play (lead value).                                                                   |
#'   |lead_down2                       |numeric   |Down number two plays ahead (lead 2 value).                                                                  |
#'   |lead_distance                    |numeric   |Distance to go on the next play (lead value).                                                                |
#'   |lead_distance2                   |integer   |Distance to go two plays ahead (lead 2 value).                                                               |
#'   |lead_play_type2                  |character |Play type two plays ahead (lead 2 value).                                                                    |
#'   |lead_play_type3                  |character |Play type three plays ahead (lead 3 value).                                                                  |
#'   |lag_ep_before3                   |numeric   |ep_before from three plays prior (lag 3 value).                                                              |
#'   |lag_ep_before2                   |numeric   |ep_before from two plays prior (lag 2 value).                                                                |
#'   |lag_ep_before                    |numeric   |ep_before from the previous play (lag value).                                                                |
#'   |lead_ep_before                   |numeric   |ep_before on the next play (lead value).                                                                     |
#'   |lead_ep_before2                  |numeric   |ep_before two plays ahead (lead 2 value).                                                                    |
#'   |lag_ep_after                     |numeric   |ep_after from the previous play (lag value).                                                                 |
#'   |lag_ep_after2                    |numeric   |ep_after from two plays prior (lag 2 value).                                                                 |
#'   |lag_ep_after3                    |numeric   |ep_after from three plays prior (lag 3 value).                                                               |
#'   |lead_ep_after                    |numeric   |ep_after on the next play (lead value).                                                                      |
#'   |lead_ep_after2                   |numeric   |ep_after two plays ahead (lead 2 value).                                                                     |
#'   |play_number                      |integer   |CFBD-supplied play number within the game.                                                                   |
#'   |wallclock                        |character |ISO 8601 wall-clock timestamp from CFBD for the play.                                                        |
#'   |provider                         |character |Sportsbook provider used for spread/over_under joined onto the play.                                         |
#'   |spread                           |numeric   |Pre-game point spread from the selected provider.                                                            |
#'   |formatted_spread                 |character |Human-readable formatted spread string from the betting provider.                                            |
#'   |over_under                       |numeric   |Pre-game over/under total from the selected provider.                                                        |
#'   |drive_is_home_offense            |logical   |TRUE when the home team is on offense for the drive.                                                         |
#'   |drive_start_offense_score        |integer   |Offense score at the start of the drive.                                                                     |
#'   |drive_start_defense_score        |integer   |Defense score at the start of the drive.                                                                     |
#'   |drive_end_offense_score          |integer   |Offense score at the end of the drive.                                                                       |
#'   |drive_end_defense_score          |integer   |Defense score at the end of the drive.                                                                       |
#'   |play                             |numeric   |Binary flag indicating the row is a counted play (excludes end markers/timeouts/penalties).                  |
#'   |event                            |numeric   |Binary flag indicating the row is a counted game event (excludes end markers).                               |
#'   |game_event_number                |numeric   |Sequential event number within the game.                                                                     |
#'   |game_row_number                  |integer   |Row index within the game grouping.                                                                          |
#'   |half_play                        |numeric   |Binary flag indicating a counted play within the half.                                                       |
#'   |half_event                       |numeric   |Binary flag indicating a counted event within the half.                                                      |
#'   |half_event_number                |numeric   |Sequential event number within the half.                                                                     |
#'   |half_row_number                  |integer   |Row index within the half grouping.                                                                          |
#'   |lag_distance3                    |integer   |distance three plays prior (lag 3 value).                                                                    |
#'   |lag_distance2                    |integer   |distance two plays prior (lag 2 value).                                                                      |
#'   |lag_distance                     |integer   |distance from the previous play (lag value).                                                                 |
#'   |lag_yards_gained3                |integer   |yards_gained three plays prior (lag 3 value).                                                                |
#'   |lag_yards_gained2                |integer   |yards_gained two plays prior (lag 2 value).                                                                  |
#'   |lag_yards_gained                 |integer   |yards_gained from the previous play (lag value).                                                             |
#'   |lead_yards_gained                |integer   |yards_gained on the next play (lead value).                                                                  |
#'   |lead_yards_gained2               |integer   |yards_gained two plays ahead (lead 2 value).                                                                 |
#'   |lag_play_text3                   |character |Play text from three plays prior (lag 3 value).                                                              |
#'   |lead_play_text2                  |character |Play text from two plays ahead (lead 2 value).                                                               |
#'   |lead_play_text3                  |character |Play text from three plays ahead (lead 3 value).                                                             |
#'   |pos_unit                         |character |Possession-team unit label (offense or special teams).                                                       |
#'   |def_pos_unit                     |character |Defensive possession-team unit label (defense or special teams).                                             |
#'   |lag_change_of_poss2              |numeric   |change_of_poss from two plays prior (lag 2 value).                                                           |
#'   |lag_change_of_poss3              |numeric   |change_of_poss from three plays prior (lag 3 value).                                                         |
#'   |lag_change_of_pos_team3          |numeric   |change_of_pos_team from three plays prior (lag 3 value).                                                     |
#'   |lag_kickoff_play2                |numeric   |kickoff_play flag from two plays prior (lag 2 value).                                                        |
#'   |lag_kickoff_play3                |numeric   |kickoff_play flag from three plays prior (lag 3 value).                                                      |
#'   |lag_punt3                        |numeric   |punt flag from three plays prior (lag 3 value).                                                              |
#'   |lag_scoring_play2                |numeric   |scoring_play flag from two plays prior (lag 2 value).                                                        |
#'   |lag_scoring_play3                |numeric   |scoring_play flag from three plays prior (lag 3 value).                                                      |
#'   |lag_turnover_vec2                |numeric   |turnover_vec flag from two plays prior (lag 2 value).                                                        |
#'   |lag_turnover_vec3                |numeric   |turnover_vec flag from three plays prior (lag 3 value).                                                      |
#'   |lag_downs_turnover2              |numeric   |downs_turnover flag from two plays prior (lag 2 value).                                                      |
#'   |lag_downs_turnover3              |numeric   |downs_turnover flag from three plays prior (lag 3 value).                                                    |
#'   |drive_play                       |numeric   |Binary flag indicating a counted play within the drive.                                                      |
#'   |drive_event                      |numeric   |Binary flag indicating a counted event within the drive.                                                     |
#'   |lag_first_by_penalty3            |numeric   |first_by_penalty flag from three plays prior (lag 3 value).                                                  |
#'   |lag_first_by_yards3              |numeric   |first_by_yards flag from three plays prior (lag 3 value).                                                    |
#'
#' @keywords Play-by-Play
#' @import stringr
#' @importFrom rlang .data
#' @importFrom purrr map_dfr
#' @importFrom glue glue
#' @importFrom dplyr mutate left_join select rename filter group_by arrange ungroup setdiff everything
#' @importFrom httr2 resp_body_string url_modify
#' @importFrom jsonlite fromJSON
#' @importFrom utils globalVariables
#' @importFrom cli cli_abort
#' @importFrom stats setNames
#' @family CFBD PBP
#' @details
#' ```r
#'  # Get play by play data for 2025 regular season week 1
#'  cfbd_pbp_data(year = 2025, week = 1, season_type = 'regular', epa_wpa = TRUE)
#' ```
#' @param engine (*Character* optional): which play-by-play engine to run.
#' One of `"v2"`, `"legacy"` or `"auto"`; `NULL` (default) resolves from
#' `getOption("cfbfastR.pbp_engine")`, which itself defaults to `"v2"` as of this
#' release. On `"v2"` this delegates to [cfbd_pbp_data_v2()], which adds penalty
#' enforcement resolution, ESPN-resolved player names, the `*_player_id` columns
#' and team attribution. `"legacy"` reproduces the pre-2.3.0 frame unchanged.
#' @param ... Additional arguments passed to [cfbd_pbp_data_v2()] when the call
#' delegates -- notably `output`, the `"default"` / `"lean"` / `"full"` modeled
#' column-set selector. Ignored on the legacy path.
#' @param defense (*String* optional): Defensive team filter.
#' @param offense_conference (*String* optional): Offensive team conference filter.
#' @param defense_conference (*String* optional): Defensive team conference filter.
#' @param conference (*String* optional): Conference filter (either side of the ball).
#' @param division (*String* optional): Division/classification filter -- `fbs`, `fcs`, `ii`, `ii/iii`, `iii`.
#' @export

cfbd_pbp_data <- function(year,
                          season_type = "regular",
                          week = 1,
                          team = NULL,
                          play_type = NULL,
                          epa_wpa = FALSE,
                          engine = NULL,
                          ...,
                          defense = NULL,
                          offense_conference = NULL,
                          defense_conference = NULL,
                          conference = NULL,
                          division = NULL) {
  # Upgrade path. `engine = "v2"` (or options(cfbfastR.pbp_engine = "v2"))
  # delegates to the modular engine, which is where new parsing work lands.
  # The leading arguments are identical to cfbd_pbp_data_v2()'s by design, so
  # this hands them straight over; `output` flows through `...`.
  if (identical(.pbp_engine(engine), "v2")) {
    dots <- list(...)
    return(do.call(cfbd_pbp_data_v2, c(
      list(year = year, season_type = season_type, week = week, team = team,
           play_type = play_type, epa_wpa = epa_wpa),
      dots[intersect(names(dots), "output")]
    )))
  }
  .pbp_engine_nudge("cfbd_pbp_data", "cfbd_pbp_data_v2")

  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old))

  # Validation Lists ----
  allowable_play_types <- na.omit(
    c(cfbfastR::cfbd_play_type_df$text,
      cfbfastR::cfbd_play_type_df$abbreviation)
  )

  # Validation ----
  validate_api_key()
  validate_division(division)
  validate_year(year)
  validate_week(week)
  validate_season_type(season_type)

  pt_abb_exists <- TRUE
  if (!is.null(play_type)) {
    text <- play_type %in% cfbfastR::cfbd_play_type_df$text
    abbr <- play_type %in% cfbfastR::cfbd_play_type_df$abbreviation
    validate_list(play_type, allowable_play_types)

    if (text) {
      pt_abb <- cfbfastR::cfbd_play_type_df$abbreviation[which(cfbfastR::cfbd_play_type_df$text == play_type)]
      pt_abb_exists <- !is.null(pt_abb)
    } else {
      pt_abb <- play_type
    }
  } else {
    pt_abb <- NULL
  }

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  play_base_url <- "https://api.collegefootballdata.com/plays"
  query_params <- list(
    "seasonType" = season_type,
    "year" = year,
    "week" = week,
    "team" = team,
    "playType" = pt_abb,
    "defense" = defense,
    "offenseConference" = offense_conference,
    "defenseConference" = defense_conference,
    "conference" = conference,
    "classification" = division
  )
  full_url <- httr2::url_modify(play_base_url, query = .compact(query_params))

  # Create the GET request and set response as res
  res <- get_req(full_url)
  check_status(res)

  raw_play_df <- res |>
    httr2::resp_body_string(encoding = "UTF-8") |>
    jsonlite::fromJSON()
  raw_play_df <- do.call(data.frame, raw_play_df)

  if (nrow(raw_play_df) == 0) {
    warning("Most likely a bye week, the data pulled from the API was empty. Returning nothing
              for this one week or team.")
    return(NULL)
  }

  if (year >= 2013) {
    tryCatch(
      expr = {
        # define providers in explicit priority order
        providers_list <- c(
          'consensus', 'DraftKings', 'ESPN Bet', 'Caesars', 'Caesars Sportsbook (Colorado)',
          'Caesars (Pennsylvania)', 'Bovada', 'SugarHouse', 'William Hill (New Jersey)',
          'teamrankings', 'numberfire'
        )
        game_spread <- cfbd_betting_lines(
          year = year,
          week = week,
          season_type = season_type,
          team = team
        )
        game_spread <- game_spread |>
          dplyr::filter(.data$provider %in% providers_list) |>
          dplyr::mutate(
            spread = as.numeric(.data$spread),
            over_under = as.numeric(.data$over_under)
          ) |>
          dplyr::select(
            "game_id", "provider", "spread", "formatted_spread", "over_under"
          )
        # deterministically choose a single provider per game by defined priority
        provider_priority <- setNames(seq_along(providers_list), providers_list)
        game_spread <- game_spread |>
          dplyr::mutate(.prov_rank = provider_priority[.data$provider]) |>
          dplyr::group_by(.data$game_id) |>
          dplyr::slice_min(.data$.prov_rank, with_ties = FALSE) |>
          dplyr::ungroup() |>
          dplyr::select(-dplyr::all_of(".prov_rank"))

        # join to plays dataframe
        raw_play_df <- raw_play_df |>
          dplyr::left_join(game_spread, by = c("gameId" = "game_id"), suffix = c("_x",""))

        if (all(is.na(raw_play_df$spread))) {
          raw_play_df$spread <- NA_real_
          raw_play_df$formatted_spread <- NA_character_
          raw_play_df$over_under <- NA_real_
        }
      },
      error = function(e) {
      },
      finally = {
      }
    )
  }
  ## call/drive information
  drive_info <- cfbd_drives(year = year, season_type = season_type, team = team, week = week)

  clean_drive_df <- clean_drive_info(drive_info)

  colnames(clean_drive_df) <- paste0("drive_", colnames(clean_drive_df))

  play_df <- raw_play_df |>
    janitor::clean_names() |>
    dplyr::rename(
      "yard_line" = "yardline"
    ) |>
    dplyr::mutate(drive_id = as.numeric(.data$drive_id)) |>
    dplyr::left_join(clean_drive_df,
                     by = c(
                       "drive_id" = "drive_drive_id",
                       "game_id" = "drive_game_id"
                     ),
                     suffix = c("_play", "_drive")
    )

  rm_cols <- c(
    "drive_game_id", "drive_id_drive", #' drive_drive_number',
    "drive_plays", "drive_start_yardline", "drive_end_yardline",
    "drive_offense", "drive_offense_conference",
    "drive_defense", "drive_defense_conference",
    "drive_start_time_hours", "drive_start_time_minutes", "drive_start_time_seconds",
    "drive_end_time_hours", "drive_end_time_minutes", "drive_end_time_seconds",
    "drive_elapsed_hours", "drive_elapsed_minutes", "drive_elapsed_seconds"
  )


  play_df <- play_df |>
    dplyr::select(dplyr::setdiff(names(play_df), rm_cols)) |>
    dplyr::rename(
      "drive_pts" = "drive_pts_drive",
      "drive_result" = "drive_drive_result",
      "orig_drive_number" = "drive_drive_number",
      "id_play" = "id",
      "offense_play" = "offense",
      "defense_play" = "defense"
    ) |>
    dplyr::mutate(
      season = year,
      wk = week
    )

  if (!pt_abb_exists){
    play_df <- play_df |>
      dplyr::filter(tolower(play_type) == tolower(!!play_type))
  }

  if (epa_wpa) {
    if (year <= 2005) {
      warning(
        "Data Quality prior to 2005 is not as consistent. This can affect the EPA/WPA values, proceed with caution."
      )
    }

    #---- Purrr Map Function -----
    g_ids <- sort(unique(play_df$game_id))
    game_count <- length(g_ids)
    builder <- TRUE

    if (game_count > 1) {
      user_message(glue::glue("Start processing of {game_count} games..."),"todo")
    } else {
      user_message(glue::glue("Start processing of {game_count} game..."),"todo")
    }

    p <- if (is_installed("progressr")) {
      progressr::progressor(along = g_ids)
    } else {
      function(...) NULL
    }

    play_df <- purrr::map_dfr(
      g_ids,
      function(x){
        # Note: this should be changed to a complete data validation test in the future
        # filter out games with less than 10 plays to avoid issues with EPA/WPA models
        game_plays <- play_df |>
          dplyr::filter(.data$game_id == x)
        if (nrow(game_plays) < 20) {
          cli::cli_alert_danger(glue::glue("Skipping game_id {x} with only {nrow(game_plays)} plays"))
          return(NULL)
        }
        game_plays <- game_plays |>
          clean_play_text() |>
          penalty_detection() |>
          add_play_counts() |>
          clean_pbp_dat() |>
          clean_drive_dat() |>
          add_yardage() |>
          add_player_cols() |>
          prep_epa_df_after() |>
          create_epa(ep_model = ep_model, fg_model = fg_model,
                     season = year) |>
          # create_wpa_betting() |>
          create_wpa_naive(wp_model = wp_model)
        p(sprintf("x=%s", as.integer(x)))
        return(game_plays)
      }, ...)
    # } else{
    #   play_df <- purrr::map_dfr(
    #     g_ids,
    #     function(x) {
    #       play_df <- play_df |>
    #         dplyr::filter(.data$game_id == x) |>
    #         penalty_detection() |>
    #         add_play_counts() |>
    #         clean_pbp_dat() |>
    #         clean_drive_dat() |>
    #         add_yardage() |>
    #         add_player_cols() |>
    #         prep_epa_df_after() |>
    #         create_epa() |>
    #         # create_wpa_betting() |>
    #         create_wpa_naive()
    #       p(sprintf("x=%s", as.integer(x)))
    #       return(play_df)
    #     }
    #   )
    # }



    #---- Select Output Ordering -----

    play_columns <- c(
      "season", "wk", "id_play", "game_id", "game_play_number", "half_play_number", "drive_play_number",
      "pos_team", "def_pos_team", "pos_team_score", "def_pos_team_score",
      "half", "period", "clock_minutes", "clock_seconds",
      "play_type", "play_text",
      "down", "distance", "yards_to_goal", "yards_gained"
    )
    model_columns <- c(
      "EPA", "ep_before", "ep_after",
      "wpa", "wp_before", "wp_after",
      "def_wp_before", "def_wp_after",
      "penalty_detail", "yds_penalty", "penalty_1st_conv"
    )
    series_columns <- c(
      # "srs_new", "srs_1stD_by_kickoff", "srs_1stD_by_poss", "srs_1stD_by_penalty", "srs_1stD_by_yards"
      "new_series", "firstD_by_kickoff", "firstD_by_poss", "firstD_by_penalty", "firstD_by_yards"
    )
    epa_flag_columns <- c(
      "def_EPA", "home_EPA", "away_EPA",
      "home_EPA_rush", "away_EPA_rush",
      "home_EPA_pass", "away_EPA_pass",
      "total_home_EPA", "total_away_EPA",
      "total_home_EPA_rush", "total_away_EPA_rush",
      "total_home_EPA_pass", "total_away_EPA_pass",
      "net_home_EPA", "net_away_EPA",
      "net_home_EPA_rush", "net_away_EPA_rush",
      "net_home_EPA_pass", "net_away_EPA_pass",
      "success", "epa_success",
      "rz_play", "scoring_opp",
      "middle_8", "stuffed_run"
    )
    team_columns <- c(
      "change_of_pos_team", "downs_turnover", "turnover",
      "pos_score_diff_start", "pos_score_pts", "log_ydstogo",
      "ExpScoreDiff", "ExpScoreDiff_Time_Ratio", "half_clock_minutes",
      "TimeSecsRem", "adj_TimeSecsRem", "Goal_To_Go", "Under_two",
      "home", "away", "home_wp_before", "away_wp_before", "home_wp_after", "away_wp_after",
      "end_of_half", "pos_team_receives_2H_kickoff",
      "lead_pos_team", "lead_play_type", "lag_pos_team", "lag_play_type",
      "orig_play_type", "Under_three"
    )
    model_end_columns <- c(
      "down_end", "distance_end", "log_ydstogo_end", "yards_to_goal_end",
      "TimeSecsRem_end", "Goal_To_Go_end", "Under_two_end",
      "offense_score_play", "defense_score_play",
      "ppa", "yard_line", "scoring",
      "pos_team_timeouts_rem_before", "def_pos_team_timeouts_rem_before",
      "pos_team_timeouts", "def_pos_team_timeouts",
      "pos_score_diff", "pos_score_diff_start_end",
      "offense_play", "defense_play",
      "offense_receives_2H_kickoff", "change_of_poss",
      "score_pts", "score_diff_start", "score_diff",
      "offense_score", "defense_score",
      "offense_conference", "defense_conference",
      "off_timeout_called", "def_timeout_called",
      "offense_timeouts", "defense_timeouts",
      "off_timeouts_rem_before", "def_timeouts_rem_before"
    )
    player_name_columns <- c(
      "rusher_player_name", "yds_rushed", "passer_player_name", "receiver_player_name", "yds_receiving",
      "yds_sacked", "sack_players", "sack_player_name", "sack_player_name2",
      "pass_breakup_player_name", "interception_player_name", "yds_int_return",
      "fumble_player_name", "fumble_forced_player_name", "fumble_recovered_player_name", "yds_fumble_return",
      "punter_player_name", "yds_punted", "punt_returner_player_name", "yds_punt_return", "yds_punt_gained",
      "punt_block_player_name", "punt_block_return_player_name",
      "fg_kicker_player_name", "yds_fg", "fg_block_player_name", "fg_return_player_name",
      "kickoff_player_name", "yds_kickoff", "kickoff_returner_player_name", "yds_kickoff_return", "new_id"
    )
    drop_player_name_columns <- c(
      "punt_return_player",
      "kickoff_return_player",
      "rush_player_name",
      "punt_return_player_name",
      "kickoff_return_player_name"
    )
    drive_columns <- c(
      "orig_drive_number", "drive_number",
      "drive_result_detailed", "new_drive_pts", "drive_id", "drive_result",
      "drive_start_yards_to_goal", "drive_end_yards_to_goal", "drive_yards", "drive_scoring", "drive_pts",
      "drive_start_period", "drive_end_period", "drive_time_minutes_start",
      "drive_time_seconds_start", "drive_time_minutes_end", "drive_time_seconds_end",
      "drive_time_minutes_elapsed", "drive_time_seconds_elapsed",
      "drive_numbers", "number_of_drives", "pts_scored", "drive_result_detailed_flag", "drive_result2",
      "drive_num", "lag_drive_result_detailed", "lead_drive_result_detailed",
      "lag_new_drive_pts", "id_drive"
    )
    penalty_columns <- c(
      "penalty_flag", "penalty_declined",
      "penalty_no_play", "penalty_offset",
      "penalty_text", "penalty_play_text"
    )
    play_flag_columns <- c(
      "rush", "rush_td", "pass", "pass_td",
      "completion", "pass_attempt", "target",
      "sack_vec", "sack", "int", "int_td",
      "turnover_vec", "turnover_vec_lag", "turnover_indicator",
      "kickoff_play", "receives_2H_kickoff", "missing_yard_flag",
      "scoring_play", "td_play", "touchdown", "safety", "fumble_vec",
      "kickoff_tb", "kickoff_onside", "kickoff_oob", "kickoff_fair_catch", "kickoff_downed",
      "kickoff_safety", "kick_play",
      "punt", "punt_play", "punt_tb", "punt_oob", "punt_fair_catch", "punt_downed",
      "punt_safety", "punt_blocked", "penalty_safety",
      "fg_inds", "fg_made", "fg_make_prob"
    )
    model_prob_columns <- c(
      "No_Score_before", "FG_before", "Opp_FG_before", "Opp_Safety_before",
      "Opp_TD_before", "Safety_before", "TD_before",
      "No_Score_after", "FG_after", "Opp_FG_after", "Opp_Safety_after",
      "Opp_TD_after", "Safety_after", "TD_after"
    )
    wpa_extra_columns <- c(
      "lead_wp_before2", "wpa_half_end", "wpa_base", "wpa_base_nxt", "wpa_change", "wpa_change_nxt",
      "wpa_base_ind", "wpa_base_nxt_ind", "wpa_change_ind", "wpa_change_nxt_ind", "lead_wp_before",
      "lead_pos_team2"
    )
    lag_series_columns <- c(
      "row", "drive_event_number",
      "orig_play_type", "lead_play_type",
      "lag_play_type", "lag_play_type2", "lag_play_type3",
      "lag_play_text", "lag_play_text2", "lead_play_text",
      "lag_first_by_penalty", "lag_first_by_penalty2",
      "lag_first_by_yards", "lag_first_by_yards2",
      "first_by_penalty", "first_by_yards", "play_after_turnover",
      "lag_change_of_poss", "lag_change_of_pos_team", "lag_change_of_pos_team2",
      "lag_kickoff_play", "lag_punt", "lag_punt2",
      "lag_scoring_play", "lag_turnover_vec",
      "lag_downs_turnover", "lag_defense_score_play"
    )
    lag_lead_columns <- c(
      "lag_score_diff", "lag_offense_play", "lead_offense_play", "lead_offense_play2",
      "lag_pos_score_diff", "lag_off_timeouts",
      "lag_def_timeouts", "lag_TimeSecsRem2", "lag_TimeSecsRem", "lead_TimeSecsRem",
      "lead_TimeSecsRem2", "lag_yards_to_goal2", "lag_yards_to_goal",
      "lead_yards_to_goal", "lead_yards_to_goal2", "lag_down2", "lag_down",
      "lead_down", "lead_down2", "lead_distance", "lead_distance2", "lead_play_type2", "lead_play_type3",
      # "lag_change_of_poss","lag_change_of_pos_team", "lag_kickoff_play", "lag_punt", "lag_scoring_play",
      # "lag_turnover_vec", "lag_downs_turnover", "lag_defense_score_play",
      "lag_ep_before3", "lag_ep_before2", "lag_ep_before", "lead_ep_before", "lead_ep_before2",
      "lag_ep_after", "lag_ep_after2", "lag_ep_after3", "lead_ep_after", "lead_ep_after2"
    )

    play_df <- play_df |>
      dplyr::select(
        dplyr::all_of(play_columns),
        dplyr::all_of(model_columns),
        dplyr::all_of(series_columns),
        dplyr::all_of(epa_flag_columns),
        dplyr::all_of(team_columns),
        dplyr::all_of(model_end_columns),
        dplyr::all_of(player_name_columns),
        dplyr::all_of(drive_columns),
        dplyr::all_of(play_flag_columns),
        dplyr::all_of(model_prob_columns),
        dplyr::all_of(penalty_columns),
        dplyr::all_of(wpa_extra_columns),
        dplyr::all_of(lag_series_columns),
        dplyr::all_of(lag_lead_columns),
        dplyr::everything()) |>
      dplyr::select(-dplyr::any_of(drop_player_name_columns))
  }

  play_df <- play_df |>
    make_cfbfastR_data("Play-by-Play data from CollegeFootballData.com",Sys.time())

  return(play_df)
}

#' **Series of functions to help clean the play-by-play data for analysis**
#' @name helpers_pbp
NULL
#'
#' @title
#' **Series of functions to help clean the play-by-play data for analysis**
#' @rdname helpers_pbp
#' @description
#'
#' * `add_play_counts()`: function: Adds play counts to Play-by-Play data pulled from the API's raw game data.
#' * `add_yardage()`: function: Add yardage extracted from play text.
#' * `add_player_cols()`:  function: Add player columns extracted from play text.
#' * `clean_drive_dat()`: function: Create new Drive results and id data.
#' * `clean_pbp_dat()`: function: Clean Play-by-Play data.
#' * `penalty_detection()`: function: Adds penalty columns to Play-by-Play data pulled from the API.
#' * `prep_epa_df_after()`: function: Creates the post-play inputs for the Expected Points model to predict on for each game.
#' * `clean_drive_info()`: function: Cleans CFB (D-I) Drive-By-Drive Data to create `pts_drive` column.
#'
#' @param play_df (*data.frame* required): Adds play counts to Play-by-Play dataframe, as pulled from `cfbd_pbp_data()`
#' @details Requires the following columns to be present
#'
#' * `game_id`: .
#' * `id_play`: .
#' * `clock_minutes`: .
#' * `clock_seconds`: .
#' * `half`: .
#' * `period`: .
#' * `offense_play`: .
#' * `defense_play`: .
#' * `home`: .
#' * `away`: .
#' * `offense_score`: .
#' * `defense_score`: .
#' * `offense_timeouts`: .
#' * `defense_timeouts`: .
#' * `play_text`: .
#' * `play_type`: .
#'
#' @return The original `play_df` with the following columns appended/redefined:
#'
#' * `game_play_number`: .
#' * `half_clock_minutes`: .
#' * `TimeSecsRem`: .
#' * `Under_two`: .
#' * `half`: .
#' * `kickoff_play`: .
#' * `pos_team`: .
#' * `def_pos_team`: .
#' * `receives_2H_kickoff`: .
#' * `pos_score_diff`: .
#' * `lag_pos_score_diff`: .
#' * `lag_pos_team`: .
#' * `lead_pos_team`: .
#' * `lead_pos_team2`: .
#' * `pos_score_pts`: .
#' * `pos_score_diff_start`: .
#' * `score_diff`: .
#' * `lag_score_diff`: .
#' * `lag_offense_play`: .
#' * `lead_offense_play`: .
#' * `lead_offense_play2`: .
#' * `score_pts`: .
#' * `score_diff_start`: .
#' * `offense_receives_2H_kickoff`: .
#' * `half_play_number`: .
#' * `lag_off_timeouts`: .
#' * `lag_def_timeouts`: .
#' * `off_timeouts_rem_before`: .
#' * `def_timeouts_rem_before`: .
#' * `off_timeout_called`: .
#' * `def_timeout_called`: .
#' * `lead_TimeSecsRem`: .
#' * `lead_TimeSecsRem2`: .
#' * `lead_yards_to_goal`: .
#' * `lead_yards_to_goal2`: .
#' * `lead_down`: .
#' * `lead_down2`: .
#' * `lag_distance3`: .
#' * `lag_distance2`: .
#' * `lag_distance`: .
#' * `lead_distance`: .
#' * `lead_distance2`: .
#' * `end_of_half`: .
#' * `lag_play_type3`: .
#' * `lag_play_type2`: .
#' * `lag_play_type`: .
#' * `lead_play_type`: .
#' * `lead_play_type2`: .
#' * `lead_play_type3`: .
#' * `change_of_poss`: .
#' * `change_of_pos_team`: .
#' * `pos_team_timeouts`: .
#' * `def_pos_team_timeouts`: .
#' * `pos_team_timeouts_rem_before`: .
#' * `def_pos_team_timeouts_rem_before`: .
#'
#' @keywords internal
#' @importFrom rlang .data
#' @importFrom dplyr group_by mutate ungroup lead lag arrange n case_when
#' @importFrom tidyr fill
#' @export

add_play_counts <- function(play_df) {
  ## --Play type vectors------
  penalty <- c(
    "Penalty",
    "Penalty (Kickoff)",
    "Penalty (Safety)"
  )
  scores_vec <- c(
    "Blocked Punt Touchdown",
    "Blocked Punt (Safety)",
    "Punt (Safety)",
    "Blocked Field Goal Touchdown",
    "Missed Field Goal Return Touchdown",
    "Fumble Recovery (Opponent) Touchdown",
    "Fumble Return Touchdown",
    "Interception Return Touchdown",
    "Pass Interception Return Touchdown",
    "Punt Touchdown",
    "Punt Return Touchdown",
    "Penalty (Safety)",
    "Punt Team Fumble Recovery Touchdown",
    "Sack Touchdown",
    "Uncategorized Touchdown",
    "Defensive 2pt Conversion",
    "Safety",
    "Kickoff Team Fumble Recovery Touchdown",
    "Kickoff (Safety)",
    "Passing Touchdown",
    "Rushing Touchdown",
    "Field Goal Good",
    "Pass Reception Touchdown",
    "Fumble Recovery (Own) Touchdown"
  )
  turnover_vec <- c(
    "Blocked Field Goal",
    "Blocked Field Goal Touchdown",
    "Field Goal Missed",
    "Missed Field Goal Return",
    "Missed Field Goal Return Touchdown",
    "Fumble Recovery (Opponent)",
    "Fumble Recovery (Opponent) Touchdown",
    "Fumble Return Touchdown",
    "Defensive 2pt Conversion",
    "Interception",
    "Interception Return",
    "Interception Return Touchdown",
    "Pass Interception",
    "Pass Interception Return",
    "Pass Interception Return Touchdown",
    "Blocked Punt",
    "Blocked Punt Touchdown",
    "Punt Touchdown",
    "Punt Return Touchdown",
    "Sack Touchdown",
    "Uncategorized Touchdown"
  )
  offense_score_vec <- c(
    "Passing Touchdown",
    "Rushing Touchdown",
    "Field Goal Good",
    "Pass Reception Touchdown",
    "Fumble Recovery (Own) Touchdown",
    "Punt Touchdown", #<--- Punting Team recovers the return team fumble and scores
    "Punt Team Fumble Recovery Touchdown",
    "Kickoff Touchdown", #<--- Kickoff Team recovers the return team fumble and scores
    "Kickoff Team Fumble Recovery Touchdown"
  )
  defense_score_vec <- c(
    "Blocked Punt Touchdown",
    "Blocked Punt (Safety)",
    "Blocked Field Goal Touchdown",
    "Missed Field Goal Return Touchdown",
    "Punt Return Touchdown",
    "Fumble Recovery (Opponent) Touchdown",
    "Fumble Return Touchdown",
    "Kickoff Return Touchdown",
    "Defensive 2pt Conversion",
    "Penalty (Safety)",
    "Blocked Punt (Safety)",
    "Kickoff (Safety)",
    "Safety",
    "Sack Touchdown",
    "Interception Return Touchdown",
    "Pass Interception Return Touchdown",
    "Uncategorized Touchdown"
  )
  kickoff_vec <- c(
    "Kickoff",
    "Kickoff Return (Offense)",
    "Kickoff Return Touchdown",
    "Kickoff Touchdown",
    "Kickoff Team Fumble Recovery",
    "Kickoff Team Fumble Recovery Touchdown",
    "Kickoff (Safety)",
    "Penalty (Kickoff)"
  )
  punt_vec <- c(
    "Blocked Punt",
    "Blocked Punt Touchdown",
    "Blocked Punt (Safety)",
    "Punt (Safety)",
    "Punt",
    "Punt Touchdown",
    "Punt Team Fumble Recovery",
    "Punt Team Fumble Recovery Touchdown",
    "Punt Return Touchdown"
  )
  int_vec <- c(
    "Interception",
    "Interception Return",
    "Interception Return Touchdown",
    "Pass Interception",
    "Pass Interception Return",
    "Pass Interception Return Touchdown"
  )
  play_df_timeout_check <- play_df |>
    dplyr::group_by(.data$game_id) |>
    dplyr::summarise(
      off_timeouts_na = all(is.na(.data$offense_timeouts)),
      def_timeouts_na = all(is.na(.data$defense_timeouts)),
      .groups = "drop"
    )
  if (play_df_timeout_check$off_timeouts_na | play_df_timeout_check$def_timeouts_na) {
    play_df <- play_df |>
      dplyr::mutate(
        offense_timeouts = 3,
        defense_timeouts = 3
      )
  }
  play_df <-
    play_df |>
    dplyr::group_by(.data$game_id) |>
    dplyr::arrange(.data$id_play, .by_group = TRUE) |>
    dplyr::mutate(
      play_type = ifelse(.data$play_type != "End of Half" & .data$play_text %in% c("End of 2nd Quarter"),
                         "End of Half", .data$play_type
      ),
      play_type = ifelse(.data$play_type != "End Period" &
                           .data$play_text %in% c("End of 3rd Quarter", "End of 1st Quarter"),
                         "End Period", .data$play_type
      ),
      play = ifelse(!(.data$play_type %in% c(
        "End Period", "End of Half", "End of Game",
        "Penalty", "Penalty (Kickoff)", "Timeout"
      )), 1, 0),
      #---- Game Row/Event/Play numbers and Time Columns -----
      game_play_number = cumsum(.data$play),
      event = ifelse(!(.data$play_type %in% c("End Period", "End of Half", "End of Game")), 1, 0),
      game_event_number = cumsum(.data$event),
      game_row_number = 1:dplyr::n(),
      half_clock_minutes = ifelse(.data$period %in% c(1, 3), 15 +
                                    .data$clock_minutes, .data$clock_minutes),
      TimeSecsRem = .data$half_clock_minutes * 60 + .data$clock_seconds,
      Under_two = .data$TimeSecsRem <= 120,
      Under_three = .data$TimeSecsRem <= 180,
      half = ifelse(.data$period <= 2, 1, 2),
      kickoff_play = ifelse(.data$play_type %in% kickoff_vec, 1, 0),
      #---- Define pos_team/def_pos_team variables -----
      pos_team = ifelse(.data$offense_play == .data$home & .data$kickoff_play == 1, .data$away,
                        ifelse(.data$offense_play == .data$away & .data$kickoff_play == 1,
                               .data$home, .data$offense_play
                        )
      ),
      def_pos_team = ifelse(.data$pos_team == .data$home, .data$away, .data$home),
      pos_team_score = ifelse(.data$kickoff_play == 1, .data$defense_score, .data$offense_score),
      def_pos_team_score = ifelse(.data$kickoff_play == 1, .data$offense_score, .data$defense_score),
      lag_pos_team = dplyr::lag(.data$pos_team, 1),
      lag_pos_team = ifelse(.data$game_play_number == 1, .data$pos_team, .data$lag_pos_team),
      lead_pos_team = dplyr::lead(.data$pos_team, 1),
      lead_pos_team2 = dplyr::lead(.data$pos_team, 2),
      receives_2H_kickoff = ifelse(.data$game_play_number == 1 &
                                     .data$def_pos_team == .data$home, 1,
                                   ifelse(.data$game_play_number == 1 &
                                            .data$def_pos_team == .data$away, 0, NA_real_)
      ),
      score_diff = .data$offense_score - .data$defense_score,
      lag_score_diff = dplyr::lag(.data$score_diff, 1),
      lag_score_diff = ifelse(.data$game_play_number == 1, 0, .data$lag_score_diff),
      lag_offense_play = dplyr::lag(.data$offense_play, 1),
      lag_offense_play = ifelse(.data$game_play_number == 1, .data$offense_play, .data$lag_offense_play),
      lead_offense_play = dplyr::lead(.data$offense_play, 1),
      lead_offense_play2 = dplyr::lead(.data$offense_play, 2),
      score_pts = ifelse(.data$lag_offense_play == .data$offense_play,
                         (.data$score_diff - .data$lag_score_diff),
                         (.data$score_diff + .data$lag_score_diff)
      ),
      score_diff_start = ifelse(.data$lag_offense_play == .data$offense_play &
                                  !(.data$play_type %in% kickoff_vec),
                                .data$lag_score_diff,
                                -1 * .data$lag_score_diff
      ),
      pos_score_diff = .data$pos_team_score - .data$def_pos_team_score,
      lag_pos_score_diff = dplyr::lag(.data$pos_score_diff, 1),
      lag_pos_score_diff = ifelse(.data$game_play_number == 1, 0, .data$lag_pos_score_diff),
      pos_score_pts = ifelse(.data$lag_pos_team == .data$pos_team,
                             (.data$pos_score_diff - .data$lag_pos_score_diff),
                             (.data$pos_score_diff + .data$lag_pos_score_diff)
      ),
      pos_score_diff_start = ifelse(.data$lag_pos_team == .data$pos_team,
                                    .data$lag_pos_score_diff,
                                    -1 * .data$lag_pos_score_diff
      )
      # TO-DO: define a fix for end of period plays on possession changing plays
    ) |>
    tidyr::fill("receives_2H_kickoff") |>
    dplyr::mutate(
      offense_receives_2H_kickoff = dplyr::case_when(
        .data$offense_play == .data$home & .data$receives_2H_kickoff == 1 ~ 1,
        .data$offense_play == .data$away & .data$receives_2H_kickoff == 0 ~ 1,
        TRUE ~ 0
      ),
      pos_team_receives_2H_kickoff = dplyr::case_when(
        .data$pos_team == .data$home & .data$receives_2H_kickoff == 1 ~ 1,
        .data$pos_team == .data$away & .data$receives_2H_kickoff == 0 ~ 1,
        TRUE ~ 0
      )
    ) |>
    dplyr::group_by(.data$game_id, .data$half) |>
    dplyr::arrange(.data$game_id, .data$half, .data$period,
                   -.data$TimeSecsRem, .data$id_play,
                   .by_group = TRUE
    ) |>
    dplyr::mutate(
      #---- Half Row/Event/Play Numbers -----
      half_play = ifelse(!(.data$play_type %in% c(
        "End Period", "End of Half", "End of Game",
        "Penalty", "Penalty (Kickoff)", "Timeout"
      )), 1, 0),
      half_play_number = cumsum(.data$half_play),
      half_event = ifelse(!(.data$play_type %in% c("End Period", "End of Half", "End of Game")), 1, 0),
      half_event_number = cumsum(.data$event),
      half_row_number = 1:dplyr::n(),
      ## TO-DO: need to make sure these timeouts lines up with the teams
      lag_off_timeouts = dplyr::lag(.data$offense_timeouts, 1),
      lag_off_timeouts = ifelse(.data$half_play_number == 1, 3, .data$lag_off_timeouts),
      lag_def_timeouts = dplyr::lag(.data$defense_timeouts, 1),
      lag_def_timeouts = ifelse(.data$half_play_number == 1, 3, .data$lag_def_timeouts),
      off_timeouts_rem_before = ifelse(.data$lag_offense_play == .data$offense_play, .data$lag_off_timeouts, .data$lag_def_timeouts),
      off_timeouts_rem_before = ifelse(.data$half_play_number == 1, 3, .data$off_timeouts_rem_before),
      def_timeouts_rem_before = ifelse(.data$lag_offense_play == .data$offense_play, .data$lag_def_timeouts, .data$lag_off_timeouts),
      def_timeouts_rem_before = ifelse(.data$half_play_number == 1, 3, .data$def_timeouts_rem_before),
      off_timeout_called = ifelse(.data$offense_timeouts != .data$off_timeouts_rem_before, 1, 0),
      def_timeout_called = ifelse(.data$defense_timeouts != .data$def_timeouts_rem_before, 1, 0),
      #--- Lags/Leads down, distance, yards_to_goal, TimeSecsRem ----
      lag_TimeSecsRem2 = dplyr::lag(.data$TimeSecsRem, 2),
      lag_TimeSecsRem = dplyr::lag(.data$TimeSecsRem, 1),
      lead_TimeSecsRem = dplyr::lead(.data$TimeSecsRem, 1),
      lead_TimeSecsRem2 = dplyr::lead(.data$TimeSecsRem, 2),
      end_of_half = ifelse(is.na(.data$lead_TimeSecsRem), 1, 0),
      lag_yards_to_goal2 = dplyr::lag(.data$yards_to_goal, 2),
      lag_yards_to_goal = dplyr::lag(.data$yards_to_goal, 1),
      lead_yards_to_goal = dplyr::lead(.data$yards_to_goal, 1),
      lead_yards_to_goal2 = dplyr::lead(.data$yards_to_goal, 2),
      lead_yards_to_goal = ifelse(.data$play_type %in% c("End of Half", "End of Game") | .data$end_of_half == 1, 100, .data$lead_yards_to_goal),
      lead_yards_to_goal = ifelse(.data$play_type == "End Period", .data$lead_yards_to_goal2, .data$lead_yards_to_goal),
      lag_down2 = dplyr::lag(.data$down, 2),
      lag_down = dplyr::lag(.data$down, 1),
      lead_down = dplyr::lead(.data$down, 1),
      lead_down2 = dplyr::lead(.data$down, 2),
      lead_down = ifelse(.data$play_type %in% c("End of Half", "End of Game") | .data$end_of_half == 1, 0, .data$lead_down),
      lead_down = ifelse(.data$play_type == "End Period", 0, .data$lead_down),
      # TODO add these new lags to documentation
      lag_distance3 = dplyr::lag(.data$distance, 3),
      lag_distance2 = dplyr::lag(.data$distance, 2),
      lag_distance = dplyr::lag(.data$distance, 1),
      lead_distance = dplyr::lead(.data$distance, 1),
      lead_distance2 = dplyr::lead(.data$distance, 2),
      lag_yards_gained3 = dplyr::lag(.data$yards_gained, 3),
      lag_yards_gained2 = dplyr::lag(.data$yards_gained, 2),
      lag_yards_gained = dplyr::lag(.data$yards_gained, 1),
      lead_yards_gained = dplyr::lead(.data$yards_gained, 1),
      lead_yards_gained2 = dplyr::lead(.data$yards_gained, 2),
      #--- Lags/Leads play type and play text ----
      lag_play_type3 = dplyr::lag(.data$play_type, 3),
      lag_play_type2 = dplyr::lag(.data$play_type, 2),
      lag_play_type = dplyr::lag(.data$play_type, 1),
      lead_play_type = dplyr::lead(.data$play_type, 1),
      lead_play_type2 = dplyr::lead(.data$play_type, 2),
      lead_play_type3 = dplyr::lead(.data$play_type, 3),
      lag_play_text = dplyr::lag(.data$play_text, 1),
      lag_play_text2 = dplyr::lag(.data$play_text, 2),
      lag_play_text3 = dplyr::lag(.data$play_text, 3),
      lead_play_text = dplyr::lead(.data$play_text, 1),
      lead_play_text2 = dplyr::lead(.data$play_text, 2),
      lead_play_text3 = dplyr::lead(.data$play_text, 3),
      #-- Change of possession by lead('offense_play', 1)----
      change_of_poss = ifelse(.data$offense_play == .data$lead_offense_play &
                                (!(.data$play_type %in% c("End Period", "End of Half")) | is.na(.data$lead_play_type)), 0,
                              ifelse(.data$offense_play == .data$lead_offense_play2 &
                                       ((.data$play_type %in% c("End Period", "End of Half")) | is.na(.data$lead_play_type)), 0, 1)
      ),
      change_of_poss = ifelse(is.na(.data$change_of_poss), 0, .data$change_of_poss),
      #-- Change of pos_team by lead('pos_team', 1)----
      change_of_pos_team = ifelse(.data$pos_team == .data$lead_pos_team &
                                    (!(.data$lead_play_type %in% c("End Period", "End of Half")) |
                                       is.na(.data$lead_play_type)), 0,
                                  ifelse(.data$pos_team == .data$lead_pos_team2 &
                                           ((.data$lead_play_type %in% c("End Period", "End of Half")) |
                                              is.na(.data$lead_play_type)), 0, 1)
      ),
      change_of_pos_team = ifelse(is.na(.data$change_of_pos_team), 0, .data$change_of_pos_team),
      pos_team_timeouts = ifelse(.data$kickoff_play == 1, .data$defense_timeouts, .data$offense_timeouts),
      def_pos_team_timeouts = ifelse(.data$kickoff_play == 1, .data$offense_timeouts, .data$defense_timeouts),
      pos_team_timeouts_rem_before = ifelse(.data$kickoff_play == 1, .data$def_timeouts_rem_before, .data$off_timeouts_rem_before),
      def_pos_team_timeouts_rem_before = ifelse(.data$kickoff_play == 1, .data$off_timeouts_rem_before, .data$def_timeouts_rem_before),
      pos_score_diff_start = ifelse(is.na(.data$pos_score_diff_start), .data$pos_score_diff, .data$pos_score_diff_start),
    ) |>
    dplyr::ungroup() |>
    dplyr::arrange(
      .data$game_id, .data$half, .data$period,
      -.data$TimeSecsRem, -.data$lead_TimeSecsRem, .data$id_play
    )
  return(play_df)
}


#' @rdname helpers_pbp
#' @title Create new Drive results and id data
#' @description Cleans Play-by-Play data pulled from the API's raw game data
#'
#' @param play_df (*data.frame* required): Performs data cleansing on Play-by-Play DataFrame, as pulled from `cfbd_pbp_data()`
#' @return The original `play_df` with the following columns appended/redefined:
#'
#' * `lag_change_of_poss`: .
#' * `lag_punt`: .
#' * `lag_scoring_play`: .
#' * `lag_turnover_vec`: .
#' * `lag_downs_turnover`: .
#' * `lead_play_type`: .
#' * `lead_play_type2`: .
#' * `lead_play_type3`: .
#' * `drive_numbers`: .
#' * `number_of_drives`: .
#' * `pts_scored`: .
#' * `drive_result_detailed`: .
#' * `drive_result_detailed_flag`: .
#' * `drive_result2`: .
#' * `lag_new_drive_pts`: .
#' * `lag_drive_result_detailed`: .
#' * `lead_drive_result_detailed`: .
#' * `new_drive_pts`: .
#' * `drive_scoring`: .
#' * `drive_play`: .
#' * `drive_play_number`: .
#' * `drive_event`: .
#' * `drive_event_number`: .
#' * `new_id`: .
#' * `log_ydstogo`: .
#' * `down`: .
#' * `distance`: .
#' * `yards_to_goal`: .
#' * `yards_gained`: .
#' * `Goal_To_Go`: .
#'
#' @keywords internal
#' @importFrom rlang .data
#' @importFrom dplyr group_by arrange mutate ungroup case_when select lead lag
#' @importFrom stringr str_detect
#' @importFrom tidyr fill replace_na
#' @export

clean_drive_dat <- function(play_df) {
  play_df <- play_df |>
    dplyr::group_by(.data$game_id, .data$half) |>
    dplyr::arrange(.data$game_id, .data$half, .data$period,
                   -.data$TimeSecsRem, -.data$lead_TimeSecsRem, .data$id_play,
                   .by_group = TRUE
    ) |>
    dplyr::mutate(
      #---- Define Lag Pos Team/Kickoff Play/Punt/Scoring/Turnover/Downs Turnover----
      lag_change_of_poss = dplyr::lag(.data$change_of_poss, 1),
      lag_change_of_poss2 = dplyr::lag(.data$change_of_poss, 2),
      lag_change_of_poss3 = dplyr::lag(.data$change_of_poss, 3),
      lag_change_of_poss = ifelse(.data$half_event_number %in% c(1), 0, .data$lag_change_of_poss),
      lag_change_of_poss2 = ifelse(.data$half_event_number %in% c(1, 2), 0, .data$lag_change_of_poss2),
      lag_change_of_poss3 = ifelse(.data$half_event_number %in% c(1, 2, 3), 0, .data$lag_change_of_poss3),
      lag_change_of_pos_team = dplyr::lag(.data$change_of_pos_team, 1),
      lag_change_of_pos_team2 = dplyr::lag(.data$change_of_pos_team, 2),
      lag_change_of_pos_team3 = dplyr::lag(.data$change_of_pos_team, 3),
      lag_change_of_pos_team = ifelse(.data$half_event_number %in% c(1), 0, .data$lag_change_of_pos_team),
      lag_change_of_pos_team2 = ifelse(.data$half_event_number %in% c(1, 2), 0, .data$lag_change_of_pos_team2),
      lag_change_of_pos_team3 = ifelse(.data$half_event_number %in% c(1, 2, 3), 0, .data$lag_change_of_pos_team3),
      lag_kickoff_play = dplyr::lag(.data$kickoff_play, 1),
      lag_kickoff_play2 = dplyr::lag(.data$kickoff_play, 2),
      lag_kickoff_play3 = dplyr::lag(.data$kickoff_play, 3),
      lag_kickoff_play = ifelse(.data$half_event_number %in% c(1), 0, .data$lag_kickoff_play),
      lag_kickoff_play2 = ifelse(.data$half_event_number %in% c(1, 2), 0, .data$lag_kickoff_play2),
      lag_kickoff_play3 = ifelse(.data$half_event_number %in% c(1, 2, 3), 0, .data$lag_kickoff_play3),
      lag_punt = dplyr::lag(.data$punt, 1),
      lag_punt2 = dplyr::lag(.data$punt, 2),
      lag_punt3 = dplyr::lag(.data$punt, 3),
      lag_punt = ifelse(.data$half_event_number %in% c(1), 0, .data$lag_punt),
      lag_punt2 = ifelse(.data$half_event_number %in% c(1, 2), 0, .data$lag_punt2),
      lag_punt3 = ifelse(.data$half_event_number %in% c(1, 2, 3), 0, .data$lag_punt3),
      lag_scoring_play = dplyr::lag(.data$scoring_play, 1),
      lag_scoring_play2 = dplyr::lag(.data$scoring_play, 2),
      lag_scoring_play3 = dplyr::lag(.data$scoring_play, 3),
      lag_scoring_play = ifelse(.data$half_play_number %in% c(1), 0, .data$lag_scoring_play),
      lag_scoring_play2 = ifelse(.data$half_play_number %in% c(1, 2), 0, .data$lag_scoring_play2),
      lag_scoring_play3 = ifelse(.data$half_play_number %in% c(1, 2, 3), 0, .data$lag_scoring_play3),
      lag_turnover_vec = dplyr::lag(.data$turnover_vec, 1),
      lag_turnover_vec2 = dplyr::lag(.data$turnover_vec, 2),
      lag_turnover_vec3 = dplyr::lag(.data$turnover_vec, 3),
      lag_turnover_vec = ifelse(.data$half_event_number %in% c(1), 0, .data$lag_turnover_vec),
      lag_turnover_vec2 = ifelse(.data$half_event_number %in% c(1, 2), 0, .data$lag_turnover_vec2),
      lag_turnover_vec3 = ifelse(.data$half_event_number %in% c(1, 2, 3), 0, .data$lag_turnover_vec3),
      lag_downs_turnover = dplyr::lag(.data$downs_turnover, 1),
      lag_downs_turnover2 = dplyr::lag(.data$downs_turnover, 2),
      lag_downs_turnover3 = dplyr::lag(.data$downs_turnover, 3),
      lag_downs_turnover = ifelse(.data$half_event_number %in% c(1), 0, .data$lag_downs_turnover),
      lag_downs_turnover2 = ifelse(.data$half_event_number %in% c(1, 2), 0, .data$lag_downs_turnover2),
      lag_downs_turnover3 = ifelse(.data$half_event_number %in% c(1, 2, 3), 0, .data$lag_downs_turnover3),
      # drive_numbers = ifelse(.data$half_play_number == 1 & .data$play_type != "Timeout", 1,
      #                   ifelse((.data$lag_change_of_pos_team == 1 &
      #                             !(.data$lag_play_type %in% c("Timeout","End Period")) &
      #                             (.data$lag_punt == 1 | .data$lag_downs_turnover == 1 | .data$lag_turnover_vec == 1)) |
      #                            (.data$lag_change_of_pos_team2 == 1 & (.data$lag_play_type %in% c("Timeout","End Period")) &
      #                                  !(.data$lag_play_type2 %in% c("Timeout","End Period")) &
      #                                  (.data$lag_punt2 == 1 | .data$lag_downs_turnover2 == 1 | .data$lag_turnover_vec2 == 1))  , 1,
      #                               ifelse((.data$lag_scoring_play == 1 & .data$kickoff_play == 1 &
      #                                        !(.data$lag_play_type %in% c("Timeout","End Period")))|
      #                                      (.data$lag_scoring_play2 == 1 & .data$kickoff_play == 1 &
      #                                        (.data$lag_play_type %in% c("Timeout","End Period")) &
      #                                        !(.data$lag_play_type2 %in% c("Timeout","End Period")) ) , 1, 0))),
      drive_numbers = dplyr::case_when(
        #---- Drive Definition ----
        # 1) start of half plays start drives
        .data$half_event_number == 1 ~ 1,
        # 2-L.I) start by change of pos_team
        !(.data$lag_play_type %in% c("Timeout", "End Period")) & #    condition: has play event 1 row prior
          .data$lag_change_of_pos_team == 1 &
          (.data$lag_punt == 1 | .data$lag_downs_turnover == 1 | .data$lag_turnover_vec == 1) ~ 1,
        # 2-L.II) start by change of pos_team with 1 non-play event in between
        (.data$lag_play_type %in% c("Timeout", "End Period")) & #     condition: has non-play event 1 row prior, looks 2 rows back
          .data$lag_change_of_pos_team2 == 1 &
          !(.data$lag_play_type2 %in% c("Timeout", "End Period")) &
          (.data$lag_punt2 == 1 | .data$lag_downs_turnover2 == 1 | .data$lag_turnover_vec2 == 1) ~ 1,
        # 3-L.I) start by opponent scoring play
        .data$kickoff_play == 1 ~ 1,
        # 3-L.II) start by opponent scoring play
        !(.data$lag_play_type %in% c("Timeout", "End Period")) & #    condition: has play event 1 row prior
          .data$lag_scoring_play == 1 & .data$kickoff_play == 1 ~ 1,
        # 3-L.III) start by opponent scoring play with 1 non-play event in between
        (.data$lag_play_type %in% c("Timeout", "End Period")) & #     condition: has non-play event 1 row prior, looks 2 rows back
          !(.data$lag_play_type2 %in% c("Timeout", "End Period")) &
          .data$lag_scoring_play2 == 1 & .data$kickoff_play == 1 ~ 1,
        TRUE ~ 0
      ),
      number_of_drives = cumsum(.data$drive_numbers),
      pts_scored = dplyr::case_when(
        .data$play_type == "Blocked Field Goal Touchdown" ~ -7,
        .data$play_type == "Blocked Punt (Safety)" & .data$safety == 1 ~ -2,
        .data$play_type == "Punt (Safety)" & .data$safety == 1 ~ -2,
        .data$play_type == "Blocked Punt" & .data$safety == 1 ~ -2,
        .data$play_type == "Blocked Punt Touchdown" ~ -7,
        .data$play_type == "Missed Field Goal Return Touchdown" ~ -7,
        .data$play_type == "Fumble Recovery (Opponent) Touchdown" ~ -7,
        .data$play_type == "Fumble Return Touchdown" ~ -7,
        .data$play_type == "Interception Return Touchdown" ~ -7,
        .data$play_type == "Pass Interception Return Touchdown" ~ -7,
        .data$play_type == "Punt Touchdown" ~ 7,
        .data$play_type == "Punt Team Fumble Recovery Touchdown" ~ 7,
        .data$play_type == "Punt Return Touchdown" ~ -7,
        .data$play_type == "Sack Touchdown" ~ -7,
        .data$play_type == "Uncategorized Touchdown" ~ 7,
        .data$play_type == "Defensive 2pt Conversion" ~ -2,
        .data$play_type == "Safety" ~ -2,
        .data$play_type == "Penalty (Safety)" ~ -2,
        .data$play_type == "Passing Touchdown" ~ 7,
        .data$play_type == "Rushing Touchdown" ~ 7,
        .data$play_type == "Kickoff (Safety)" & .data$kickoff_safety == 1 ~ 2,
        .data$play_type == "Kickoff Return Touchdown" ~ 7,
        .data$play_type == "Kickoff Touchdown" ~ -7,
        .data$play_type == "Kickoff Tean Fumble Recovery Touchdown" ~ -7,
        .data$play_type == "Field Goal Good" ~ 3,
        .data$play_type == "Pass Reception Touchdown" ~ 7,
        .data$play_type == "Fumble Recovery (Own) Touchdown" ~ 7,
        TRUE ~ 0
      ),
      drive_result_detailed = dplyr::case_when(
        .data$downs_turnover == 1 ~ "Downs Turnover",
        .data$play_type == "Punt" ~ "Punt",
        .data$play_type == "Punt (Safety)" & .data$safety == 1 ~ "Safety",
        .data$play_type == "Blocked Punt (Safety)" & .data$safety == 1 ~ "Safety",
        .data$play_type == "Blocked Punt" & .data$safety == 1 ~ "Safety",
        .data$play_type == "Blocked Punt" ~ "Blocked Punt",
        .data$play_type == "Blocked Punt Touchdown" ~ "Blocked Punt Touchdown",
        .data$play_type == "Punt Touchdown" ~ "Punt Touchdown",
        .data$play_type == "Punt Team Fumble Recovery Touchdown" ~ "Punt Team Fumble Recovery Touchdown",
        .data$play_type == "Punt Return Touchdown" ~ "Punt Return Touchdown",
        .data$play_type == "Fumble Recovery (Opponent) Touchdown" ~ "Fumble Recovery (Opponent) Touchdown",
        .data$play_type == "Fumble Return Touchdown" ~ "Fumble Return Touchdown",
        .data$play_type == "Fumble Recovery (Opponent)" ~ "Fumble",
        .data$play_type == "Fumble Recovery (Own) Touchdown" ~ "Fumble Recovery (Own) Touchdown",
        .data$play_type == "Interception Return Touchdown" ~ "Interception Return Touchdown",
        .data$play_type == "Interception Return" ~ "Interception Return",
        .data$play_type == "Sack Touchdown" ~ "Sack Touchdown",
        .data$play_type == "Safety" & .data$kickoff_play == 0 ~ "Safety",
        .data$play_type == "Kickoff (Safety)" & .data$kickoff_safety == 1 ~ "Kickoff Safety",
        .data$play_type == "Kickoff" & .data$kickoff_safety == 1 ~ "Kickoff Safety",
        .data$play_type == "Kickoff Return Touchdown" ~ "Kickoff Return Touchdown",
        .data$play_type == "Kickoff Touchdown" ~ "Kickoff Touchdown",
        .data$play_type == "Kickoff Team Fumble Recovery" ~ "Kickoff Team Fumble Recovery",
        .data$play_type == "Kickoff Team Fumble Recovery Touchdown" ~ "Kickoff Team Fumble Recovery Touchdown",
        .data$play_type == "Penalty (Safety)" ~ "Safety",
        .data$play_type == "Passing Touchdown" ~ "Passing Touchdown",
        .data$play_type == "Pass Reception Touchdown" ~ "Passing Touchdown",
        .data$play_type == "Rushing Touchdown" ~ "Rushing Touchdown",
        .data$play_type == "Field Goal Good" ~ "Field Goal Good",
        .data$play_type == "Field Goal Missed" ~ "Field Goal Missed",
        .data$play_type == "Missed Field Goal Return" ~ "Missed Field Goal Return",
        .data$play_type == "Blocked Field Goal Touchdown" ~ "Blocked Field Goal Touchdown",
        .data$play_type == "Missed Field Goal Return Touchdown" ~ "Missed Field Goal Return Touchdown",
        .data$play_type == "Blocked Field Goal" ~ "Blocked Field Goal",
        .data$play_type == "Uncategorized Touchdown" ~ "Uncategorized Touchdown",
        .data$play_type == "End of Half" ~ "End Half",
        .data$play_type == "End of Game" ~ "End Game",
        .data$scoring_play == 0 & (.data$lead_TimeSecsRem == 0 | is.na(.data$lead_TimeSecsRem)) &
          period %in% c(2, 4) ~ "End Half",
        TRUE ~ NA_character_
      ),
      drive_result_detailed_flag = .data$drive_result_detailed,
      drive_result2 = dplyr::case_when(
        .data$downs_turnover == 1 ~ "DOWNS",
        .data$play_type == "Punt" ~ "PUNT",
        .data$play_type == "Punt (Safety)" ~ "SAFETY",
        .data$play_type == "Blocked Punt (Safety)" & .data$safety == 1 ~ "SAFETY",
        .data$play_type == "Blocked Punt" & .data$safety == 1 ~ "SAFETY",
        .data$play_type == "Blocked Punt" ~ "BLOCKED PUNT",
        .data$play_type == "Blocked Punt Touchdown" ~ "BLOCKED PUNT TD",
        .data$play_type == "Punt Touchdown" ~ "PUNT TEAM FUMBLE RECOVERY TD",
        .data$play_type == "Punt Team Fumble Recovery Touchdown" ~ "PUNT TEAM FUMBLE RECOVERY TD",
        .data$play_type == "Punt Return Touchdown" ~ "PUNT RETURN TD",
        .data$play_type == "Fumble Recovery (Opponent) Touchdown" ~ "FUMBLE RETURN TD",
        .data$play_type == "Fumble Return Touchdown" ~ "FUMBLE RETURN TD",
        .data$play_type == "Fumble Recovery (Opponent)" ~ "FUMBLE",
        .data$play_type == "Fumble Recovery (Own) Touchdown" ~ "FUMBLE OWN TD",
        .data$play_type == "Interception Return Touchdown" ~ "INT TD",
        .data$play_type == "Interception Return" ~ "INT",
        .data$play_type == "Sack Touchdown" ~ "SACK TD",
        .data$play_type == "Safety" & .data$kickoff_play == 0 ~ "SAFETY",
        .data$play_type == "Kickoff (Safety)" & .data$kickoff_safety == 1 ~ "KICKOFF SAFETY",
        .data$play_type == "Kickoff" & .data$kickoff_safety == 1 ~ "KICKOFF SAFETY",
        .data$play_type == "Kickoff Return Touchdown" ~ "KICKOFF RETURN TD",
        .data$play_type == "Kickoff Touchdown" ~ "KICKOFF TEAM FUMBLE RECOVERY TD",
        .data$play_type == "Kickoff Team Fumble Recovery Touchdown" ~ "KICKOFF TEAM FUMBLE RECOVERY TD",
        .data$play_type == "Penalty (Safety)" ~ "SAFETY",
        .data$play_type == "Passing Touchdown" ~ "TD",
        .data$play_type == "Pass Reception Touchdown" ~ "TD",
        .data$play_type == "Rushing Touchdown" ~ "TD",
        .data$play_type == "Field Goal Good" ~ "FG",
        .data$play_type == "Field Goal Missed" ~ "MISSED FG",
        .data$play_type == "Missed Field Goal Return" ~ "MISSED FG",
        .data$play_type == "Blocked Field Goal Touchdown" ~ "BLOCKED FG TD",
        .data$play_type == "Missed Field Goal Return Touchdown" ~ "MISSED FG RETURN TD",
        .data$play_type == "Blocked Field Goal" ~ "BLOCKED FG",
        .data$play_type == "Uncategorized Touchdown" ~ "UNCATEGORIZED TD",
        .data$play_type == "End of Half" ~ "END OF HALF",
        .data$play_type == "End of Game" ~ "END OF GAME",
        .data$scoring_play == 0 & (.data$lead_TimeSecsRem == 0 | is.na(.data$lead_TimeSecsRem)) &
          period %in% c(2, 4) ~ "END OF HALF",
        TRUE ~ NA_character_
      ),
      new_drive_pts = dplyr::case_when(
        .data$downs_turnover == 1 ~ 0,
        .data$play_type == "Punt" ~ 0,
        .data$play_type == "Blocked Punt (Safety)" & .data$safety == 1 ~ -2,
        .data$play_type == "Punt (Safety)" ~ -2,
        .data$play_type == "Blocked Punt" & .data$safety == 1 ~ -2,
        .data$play_type == "Blocked Punt" ~ 0,
        .data$play_type == "Blocked Punt Touchdown" ~ -7,
        .data$play_type == "Punt Touchdown" ~ 7,
        .data$play_type == "Punt Team Fumble Recovery Touchdown" ~ 7,
        .data$play_type == "Punt Return Touchdown" ~ -7,
        .data$play_type == "Fumble Recovery (Opponent) Touchdown" ~ -7,
        .data$play_type == "Fumble Return Touchdown" ~ -7,
        .data$play_type == "Fumble Recovery (Opponent)" ~ 0,
        .data$play_type == "Fumble Recovery (Own) Touchdown" ~ 7,
        .data$play_type == "Interception Return Touchdown" ~ -7,
        .data$play_type == "Interception Return" ~ 0,
        .data$play_type == "Sack Touchdown" ~ -7,
        .data$play_type == "Safety" & .data$kickoff_play == 0 ~ -2,
        .data$play_type == "Kickoff Team Fumble Recovery Touchdown" ~ -7,
        .data$play_type == "Kickoff (Safety)" & .data$kickoff_safety == 1 ~ -2,
        .data$play_type == "Kickoff" & .data$kickoff_safety == 1 ~ -2,
        .data$play_type == "Penalty (Safety)" ~ -2,
        .data$play_type == "Passing Touchdown" ~ 7,
        .data$play_type == "Pass Reception Touchdown" ~ 7,
        .data$play_type == "Rushing Touchdown" ~ 7,
        .data$play_type == "Field Goal Good" ~ 3,
        .data$play_type == "Field Goal Missed" ~ 0,
        .data$play_type == "Missed Field Goal Return" ~ 0,
        .data$play_type == "Blocked Field Goal Touchdown" ~ -7,
        .data$play_type == "Missed Field Goal Return Touchdown" ~ -7,
        .data$play_type == "Blocked Field Goal" ~ 0,
        .data$play_type == "Uncategorized Touchdown" ~ 7,
        .data$play_type == "End of Half" ~ 0,
        .data$play_type == "End of Game" ~ 0,
        .data$scoring_play == 0 & .data$TimeSecsRem == 0 & period %in% c(2, 4) ~ 0,
        TRUE ~ 0
      ),
      new_drive_pts = ifelse(.data$new_drive_pts == 0, NA_integer_, .data$new_drive_pts),
      drive_scoring = ifelse(.data$new_drive_pts != 0, .data$scoring_play, NA_integer_)
    ) |>
    dplyr::ungroup() |>
    dplyr::group_by(.data$game_id) |>
    dplyr::arrange(.data$game_id, .data$half, .data$period,
                   -.data$TimeSecsRem, -.data$lead_TimeSecsRem,
                   .data$id_play,
                   .by_group = TRUE
    ) |>
    dplyr::mutate(drive_num = cumsum(.data$drive_numbers)) |>
    dplyr::group_by(.data$game_id, .data$half, .data$drive_num) |>
    dplyr::arrange(.data$game_id, .data$half, .data$period,
                   -.data$TimeSecsRem, -.data$lead_TimeSecsRem,
                   .data$id_play,
                   .by_group = TRUE
    ) |>
    tidyr::fill("drive_result_detailed", .direction = c("updown")) |>
    tidyr::fill("drive_result2", .direction = c("updown")) |>
    tidyr::fill("drive_scoring", .direction = c("updown")) |>
    tidyr::fill("new_drive_pts", .direction = c("updown")) |>
    dplyr::ungroup() |>
    dplyr::arrange(
      .data$game_id, .data$half, .data$period,
      -.data$TimeSecsRem, -.data$lead_TimeSecsRem,
      .data$id_play
    ) |>
    dplyr::mutate(
      lag_drive_result_detailed = dplyr::lag(.data$drive_result_detailed, 1),
      lead_drive_result_detailed = dplyr::lead(.data$drive_result_detailed, 1),
      drive_result_detailed = ifelse(is.na(.data$drive_result_detailed) &
                                       .data$play_type %in% c("Defensive 2pt Conversion", "Uncategorized", "Two Point Rush"),
                                     .data$lag_drive_result_detailed,
                                     .data$drive_result_detailed
      ),
      drive_result_detailed = ifelse(is.na(.data$drive_result_detailed) & .data$kickoff_play == 1,
                                     .data$lead_drive_result_detailed, .data$drive_result_detailed
      ),
      drive_scoring = ifelse(is.na(.data$drive_scoring), 0, .data$drive_scoring),
      new_drive_pts = ifelse(is.na(.data$new_drive_pts), 0, .data$new_drive_pts),
      lag_new_drive_pts = dplyr::lag(.data$new_drive_pts, 1),
      new_drive_pts = ifelse(is.na(.data$new_drive_pts), .data$lag_new_drive_pts, .data$new_drive_pts),
      id_drive = paste0(.data$game_id, .data$drive_num)
    ) |>
    dplyr::group_by(.data$game_id, .data$id_drive) |>
    dplyr::arrange(.data$game_id, .data$half, .data$period,
                   -.data$TimeSecsRem, -.data$lead_TimeSecsRem, .data$id_play,
                   .by_group = TRUE
    ) |>
    dplyr::mutate(
      drive_play = ifelse(!(.data$play_type %in% c(
        "End Period", "End of Half", "End of Game",
        "Penalty", "Penalty (Kickoff)", "Timeout"
      )), 1, 0),
      drive_play_number = cumsum(.data$drive_play),
      drive_event = ifelse(!(.data$play_type %in% c("End Period", "End of Half", "End of Game")), 1, 0),
      drive_event_number = cumsum(.data$drive_event)
    ) |>
    dplyr::ungroup() |>
    dplyr::select(-"td_check")
  suppressWarnings(
    play_df <- play_df |>
      dplyr::mutate(
        new_id = gsub(pattern = .data$game_id, "", x = .data$id_play),
        new_id = as.numeric(.data$new_id),
        log_ydstogo = ifelse(.data$distance == 0 | is.nan(log(.data$distance)) | is.na(.data$distance), log(1), log(.data$distance)),
        down = ifelse(stringr::str_detect(.data$play_type, "Kickoff"), 1, .data$down),
        distance = ifelse(stringr::str_detect(.data$play_type, "Kickoff"), 10, .data$distance),
        yards_to_goal = as.numeric(.data$yards_to_goal),
        yards_gained = as.numeric(.data$yards_gained),
        Goal_To_Go = ifelse(stringr::str_detect(.data$play_type, "Field Goal"),
                            .data$distance >= (.data$yards_to_goal),
                            .data$distance >= .data$yards_to_goal
        )
      )
  )
  return(play_df)
}

#' @rdname helpers_pbp
#'
#' @param dat (*Data.Frame* required) Clean Play-by-Play DataFrame pulled from `cfbd_pbp_dat()`
#' @details Prep for EPA calculations at the end of the play. Requires the following columns be present:
#'
#' * `game_id`: .
#' * `id_play`: .
#' * `drive_id`: .
#' * `down`: .
#' * `distance`: .
#' * `period`: .
#' * `yards_to_goal`: .
#' * `play_type`: .
#'
#' @return `dat` with the following columns appended/modified:
#'
#'  * `turnover_indicator`: .
#'  * `down`: .
#'  * `new_id`: .
#'  * `new_down`: .
#'  * `distance`: .
#'  * `yards_to_goal`: .
#'  * `yards_gained`: .
#'  * `turnover`: .
#'  * `drive_start_yards_to_goal`: .
#'  * `end_of_half`: .
#'  * `new_yardline`: .
#'  * `new_distance`: .
#'  * `new_log_ydstogo`: .
#'  * `new_Goal_To_Go`: .
#'  * `new_TimeSecsRem`: .
#'  * `new_Under_two`: .
#'  * `first_by_penalty`: .
#'  * `lag_first_by_penalty`: .
#'  * `lag_first_by_penalty2`: .
#'  * `first_by_yards`: .
#'  * `lag_first_by_yards`: .
#'  * `lag_first_by_yards2`: .
#'  * `row`: .
#'  * `new_series`: .
#'  * `firstD_by_kickoff`: .
#'  * `firstD_by_poss`: .
#'  * `firstD_by_yards`: .
#'  * `firstD_by_penalty`: .
#'  * `yds_punted`: .
#'  * `yds_punt_gained`: .
#'  * `missing_yard_flag`: .
#'
#' @keywords internal
#' @importFrom rlang .data
#' @importFrom dplyr mutate arrange group_by case_when mutate_at ungroup n lag lead if_else
#' @export

prep_epa_df_after <- function(dat) {
  ## --Play type vectors------
  turnover_play_type <- c(
    "Blocked Field Goal",
    "Blocked Field Goal Touchdown",
    "Blocked Punt",
    "Blocked Punt Touchdown",
    "Punt",
    "Punt Touchdown",
    "Punt Return Touchdown",
    "Sack Touchdown",
    "Field Goal Missed",
    "Missed Field Goal Return",
    "Missed Field Goal Return Touchdown",
    "Fumble Recovery (Opponent)",
    "Fumble Recovery (Opponent) Touchdown",
    "Interception",
    "Interception Return",
    "Interception Return Touchdown",
    "Pass Interception Return",
    "Pass Interception Return Touchdown",
    "Uncategorized Touchdown"
  )
  turnover_vec <- c(
    "Blocked Field Goal",
    "Blocked Field Goal Touchdown",
    "Blocked Punt",
    "Blocked Punt Touchdown",
    "Field Goal Missed",
    "Missed Field Goal Return",
    "Missed Field Goal Return Touchdown",
    "Fumble Recovery (Opponent)",
    "Fumble Recovery (Opponent) Touchdown",
    "Fumble Return Touchdown",
    "Defensive 2pt Conversion",
    "Interception",
    "Interception Return",
    "Interception Return Touchdown",
    "Pass Interception Return",
    "Pass Interception Return Touchdown",
    "Kickoff Team Fumble Recovery",
    "Kickoff Team Fumble Recovery Touchdown",
    "Punt Touchdown",
    "Punt Return Touchdown",
    "Sack Touchdown",
    "Uncategorized Touchdown"
  )
  normalplay <- c(
    "Rush",
    "Pass",
    "Pass Reception",
    "Pass Incompletion",
    "Pass Completion",
    "Sack"
  )
  penalty <- c(
    "Penalty",
    "Penalty (Kickoff)",
    "Penalty (Safety)"
  )
  offense_score_vec <- c(
    "Passing Touchdown",
    "Rushing Touchdown",
    "Field Goal Good",
    "Pass Reception Touchdown",
    "Fumble Recovery (Own) Touchdown",
    "Kickoff Return Touchdown",
    "Punt Touchdown",
    "Punt Team Fumble Recovery Touchdown"
  )
  defense_score_vec <- c(
    "Blocked Punt Touchdown",
    "Blocked Field Goal Touchdown",
    "Missed Field Goal Return Touchdown",
    "Punt Return Touchdown",
    "Fumble Recovery (Opponent) Touchdown",
    "Fumble Return Touchdown",
    "Defensive 2pt Conversion",
    "Safety",
    "Kickoff (Safety)",
    "Blocked Punt (Safety)",
    "Punt (Safety)",
    "Penalty (Safety)",
    "Sack Touchdown",
    "Interception Return Touchdown",
    "Pass Interception Return Touchdown",
    "Uncategorized Touchdown"
  )
  kickoff <- c(
    "Kickoff",
    "Kickoff Return (Offense)",
    "Kickoff Return Touchdown",
    "Kickoff Touchdown",
    "Kickoff Team Fumble Recovery",
    "Kickoff Team Fumble Recovery Touchdown",
    "Kickoff (Safety)",
    "Penalty (Kickoff)"
  )

  turnover_ind <- dat$play_type %in% turnover_play_type
  dat$turnover <- 0
  # define turnover on downs
  downs_turnover <- (dat$downs_turnover == 1)
  # data is ordered
  new_offense <- (dat$change_of_pos_team == 1)
  scoring_plays <- dat$play_type %in% offense_score_vec
  # end of half check as well
  end_of_half_plays <- !(dat$end_of_half == 0)
  # is specifically defined as a turnover
  turnover_play_check <- dat$play_type %in% turnover_vec
  # turnovers only occur on actual change of offense
  # but not scoring plays
  # and not at the end of half.
  # Turnovers now capture downs, when there is a change of offense after a fourth down normal play.
  t_ind <- (turnover_ind | (new_offense)) &
    !scoring_plays & !end_of_half_plays &
    (turnover_play_check | downs_turnover)

  dat$turnover[t_ind] <- 1

  dat <- dat |>
    dplyr::ungroup() |>
    dplyr::group_by(.data$game_id, .data$half) |>
    dplyr::arrange(.data$id_play, .by_group = TRUE) |>
    dplyr::mutate(
      turnover_indicator =
        ifelse(
          (.data$play_type %in% defense_score_vec) |
            (.data$play_type %in% turnover_vec) |
            ((.data$play_type %in% normalplay | .data$play_type == "Fumble Recovery (Own)") &
               .data$yards_gained < .data$distance &
               .data$down == 4), 1, 0
        ),
      down = as.numeric(.data$down),
      lead_down = as.numeric(.data$lead_down),
      lead_down2 = as.numeric(.data$lead_down2),
      lead_distance = as.numeric(.data$lead_distance),
      yards_gained = as.numeric(.data$yards_gained),
      #--New Down-----
      new_down = as.numeric(dplyr::case_when(
        #--- turnovers ---
        .data$turnover == 1 ~ 1,
        .data$play_type == "Timeout" ~ .data$down,
        ## --Penalty Cases (new_down)-----
        # 8 cases with three T/F penalty flags
        # 4 cases in 1
        .data$play_type %in% penalty & .data$penalty_1st_conv ~ 1,
        # offsetting penalties, no penalties declined, no 1st down by penalty (1 case)
        .data$play_type %in% penalty & !.data$penalty_declined &
          .data$penalty_offset & !.data$penalty_1st_conv ~ .data$down,
        # offsetting penalties, penalty declined true, no 1st down by penalty
        # seems like it would be a regular play at that point (1 case, split in three)
        .data$play_type %in% penalty & .data$penalty_declined &
          .data$penalty_offset & !.data$penalty_1st_conv &
          .data$yards_gained < .data$distance & .data$down <= 3 ~ .data$down + 1,
        .data$play_type %in% penalty & .data$penalty_declined &
          .data$penalty_offset & !.data$penalty_1st_conv &
          .data$yards_gained < .data$distance & .data$down == 4 ~ 1,
        .data$play_type %in% penalty & .data$penalty_declined &
          .data$penalty_offset & !.data$penalty_1st_conv &
          .data$yards_gained >= .data$distance ~ 1,
        # only penalty declined true, same logic as prior (1 case, split in three)
        .data$play_type %in% penalty & .data$penalty_declined &
          !.data$penalty_offset & !.data$penalty_1st_conv &
          .data$yards_gained < .data$distance & .data$down <= 3 ~ .data$down + 1,
        .data$play_type %in% penalty & .data$penalty_declined &
          !.data$penalty_offset & !.data$penalty_1st_conv &
          .data$yards_gained < .data$distance & .data$down == 4 ~ 1,
        .data$play_type %in% penalty & .data$penalty_declined &
          !.data$penalty_offset & !.data$penalty_1st_conv &
          .data$yards_gained >= .data$distance ~ 1,
        # no other penalty flags true, lead on down (1 case)
        .data$play_type %in% penalty & !.data$penalty_declined &
          !.data$penalty_offset & !.data$penalty_1st_conv & .data$lead_down != 0 ~ .data$lead_down,
        # no other penalty flags true, lead on down is 0 (1 case for end of period plays)
        .data$play_type %in% penalty & !.data$penalty_declined &
          !.data$penalty_offset & !.data$penalty_1st_conv & .data$lead_down == 0 ~ .data$lead_down2,
        ## --Scores, kickoffs,  defensive scores----
        .data$play_type %in% offense_score_vec ~ 1,
        .data$play_type %in% kickoff ~ 1,
        .data$play_type %in% defense_score_vec ~ 1,
        ## --Regular Plays----
        # regular play 1st down
        (.data$play_type %in% normalplay | .data$play_type == "Fumble Recovery (Own)") & .data$yards_gained >= .data$distance ~ 1,
        # iterate to next down due to not meeting the yards to gain
        (.data$play_type %in% normalplay | .data$play_type == "Fumble Recovery (Own)") &
          .data$yards_gained < .data$distance & .data$down <= 3 ~ as.integer(.data$down) + 1,
        # turnover on downs
        (.data$play_type %in% normalplay | .data$play_type == "Fumble Recovery (Own)") &
          .data$yards_gained < .data$distance & .data$down == 4 ~ 1,
        .data$play_type %in% c("Uncategorized", "placeholder") & .data$lead_down != 0 ~ .data$lead_down,
        .data$play_type %in% c("Uncategorized", "placeholder") & .data$lead_down == 0 ~ .data$lead_down2,
        .data$play_type %in% c("End Period", "End of Half", "End of Game") & !is.na(.data$lead_down) ~ 0
      )),
      drive_start_yards_to_goal = as.numeric(.data$drive_start_yards_to_goal),
      #--New Distance-----
      new_distance = as.numeric(dplyr::case_when(
        ## --turnovers, defensive scores, scores, kickoffs
        .data$turnover == 1 ~ 10,
        ## --Penalty cases (new_distance)
        #--offsetting penalties, keep same distance
        .data$play_type %in% penalty &
          .data$penalty_offset ~ as.numeric(.data$distance),
        #--penalty first down conversions, 10 or to goal
        .data$play_type %in% penalty &
          .data$penalty_1st_conv ~ as.numeric(ifelse(.data$yards_to_goal - .data$yards_gained <= 10 &
                                                       .data$yards_to_goal - .data$yards_gained >= 0,
                                                     as.numeric(.data$yards_to_goal), 10
          )),
        #--penalty without first down conversion
        .data$play_type %in% penalty & !.data$penalty_declined &
          !.data$penalty_1st_conv &
          !.data$penalty_offset ~ as.numeric(ifelse((.data$yards_gained >= .data$distance) &
                                                      (.data$yards_to_goal - .data$yards_gained <= 10) &
                                                      .data$yards_to_goal - .data$yards_gained >= 0,
                                                    as.numeric(.data$yards_to_goal), 10
          )),
        ## --normal plays
        (.data$play_type %in% normalplay | .data$play_type == "Fumble Recovery (Own)") &
          .data$yards_gained >= .data$distance &
          (.data$yards_to_goal - .data$yards_gained >= 10) ~ 10,
        (.data$play_type %in% normalplay | .data$play_type == "Fumble Recovery (Own)") &
          .data$yards_gained >= .data$distance &
          (.data$yards_to_goal - .data$yards_gained <= 10) ~ as.numeric(.data$yards_to_goal - .data$yards_gained),
        (.data$play_type %in% normalplay | .data$play_type == "Fumble Recovery (Own)") &
          .data$yards_gained < .data$distance & down <= 3 ~ as.numeric(.data$distance - .data$yards_gained),
        (.data$play_type %in% normalplay | .data$play_type == "Fumble Recovery (Own)") &
          .data$yards_gained < .data$distance &
          .data$down == 4 & (100 - (.data$yards_to_goal - .data$yards_gained) >= 10) ~ 10,
        (.data$play_type %in% normalplay | .data$play_type == "Fumble Recovery (Own)") &
          .data$yards_gained < .data$distance & .data$down == 4 &
          (100 - (.data$yards_to_goal - .data$yards_gained) <= 10) ~ as.numeric(100 - .data$yards_to_goal),
        .data$play_type %in% defense_score_vec ~ 10,
        .data$play_type %in% offense_score_vec ~ 10,
        .data$play_type %in% kickoff ~ 10,
        !is.na(.data$lead_distance) & .data$lead_play_type %in% c("Kickoff") ~ 10,
        !is.na(.data$lead_distance) & .data$lead_play_type %in% c("Timeout") &
          !(.data$lead_play_type2 %in% c("Timeout")) ~ as.numeric(.data$lead_distance2),
        !is.na(.data$lead_distance) & !(.data$lead_play_type %in% c(
          "Kickoff", "Timeout",
          "End Period", "End of Half", "End of Game"
        )) ~ as.numeric(.data$lead_distance)
      )),
      #--New Yardline----
      new_yardline = as.numeric(dplyr::case_when(
        .data$downs_turnover == 1 & .data$punt == 0 ~ 100 - .data$yards_to_goal + .data$yards_gained,
        .data$play_type %in% penalty & .data$penalty_offset & .data$kickoff_play == 0 ~ .data$yards_to_goal,
        .data$play_type %in% penalty & !.data$penalty_offset & .data$kickoff_play == 0 ~ .data$yards_to_goal - .data$yards_gained,
        .data$play_type %in% normalplay ~ .data$yards_to_goal - .data$yards_gained,
        .data$play_type %in% offense_score_vec ~ 0,
        .data$play_type %in% defense_score_vec ~ 0,
        .data$play_type %in% kickoff ~ .data$lead_yards_to_goal,
        .data$play_type %in% c(
          "Blocked Punt", "Punt", "Blocked Field Goal", "Fumble Recovery (Opponent)",
          "Field Goal Missed", "Missed Field Goal Return",
          "Fumble Recovery (Own)", "Interception Return", "Kickoff",
          "Punt Team Fumble Recovery"
        ) ~ .data$lead_yards_to_goal,
        .data$play_type %in% turnover_vec ~ 100 - .data$yards_to_goal + .data$yards_gained,
        !is.na(.data$lead_yards_to_goal) ~ .data$lead_yards_to_goal
      )),
      new_TimeSecsRem = ifelse(!is.na(.data$lead_TimeSecsRem), .data$lead_TimeSecsRem, 0),
      new_Goal_To_Go = ifelse(.data$new_yardline <= .data$new_distance, TRUE, FALSE),
      # new under two minute warnings
      new_Under_two = .data$new_TimeSecsRem <= 120,
      #----- Series/down-set variable creation --------
      # TODO - Add these variables to the documentation and select outputs
      row = 1:dplyr::n(),
      first_by_penalty = ifelse(.data$play_type %in% penalty & .data$penalty_1st_conv, 1,
                                ifelse(.data$play_type %in% penalty & .data$penalty_declined &
                                         .data$penalty_offset & !.data$penalty_1st_conv &
                                         .data$yards_gained > .data$distance, 1,
                                       ifelse(.data$play_type %in% penalty & .data$penalty_declined &
                                                !.data$penalty_offset & !.data$penalty_1st_conv &
                                                .data$yards_gained >= .data$distance, 1, 0)
                                )
      ),
      first_by_yards = ifelse((.data$play_type %in% normalplay | .data$play_type == "Fumble Recovery (Own)") &
                                .data$yards_gained >= .data$distance, 1, 0),
      lag_first_by_penalty3 = dplyr::lag(.data$first_by_penalty, 3),
      lag_first_by_penalty2 = dplyr::lag(.data$first_by_penalty, 2),
      lag_first_by_penalty = dplyr::lag(.data$first_by_penalty, 1),
      lag_first_by_penalty = ifelse(is.na(.data$lag_first_by_penalty) & !(.data$lag_play_type %in% penalty) |
                                      .data$row == 1, 0, .data$lag_first_by_penalty),
      lag_first_by_yards3 = dplyr::lag(.data$first_by_yards, 3),
      lag_first_by_yards2 = dplyr::lag(.data$first_by_yards, 2),
      lag_first_by_yards = dplyr::lag(.data$first_by_yards, 1),
      lag_first_by_yards = ifelse(is.na(.data$lag_first_by_yards) & !(.data$lag_play_type %in% normalplay) &
                                    (.data$lag_play_type != "Fumble Recovery (Own)") | .data$row == 1, 0, .data$lag_first_by_yards),
      new_series = dplyr::if_else(
        .data$id_drive != dplyr::lag(.data$id_drive, 1) |
          .data$lag_first_by_yards == 1 | .data$lag_first_by_penalty == 1 |
          .data$row == 1, 1, 0
      )

      # end TODO
    )
  suppressWarnings(
    dat <- dat |>
      dplyr::mutate(
        new_log_ydstogo = dplyr::if_else(.data$new_distance == 0 |
                                           is.nan(log(.data$new_distance)) |
                                           is.na(.data$new_distance),
                                         log(1), log(.data$new_distance)
        )
      )
  )
  dat <- dat |>
    dplyr::mutate_at(c("new_TimeSecsRem"), ~ tidyr::replace_na(., 0)) |>
    dplyr::group_by(.data$game_id, .data$half, .data$drive_id) |>
    dplyr::arrange(.data$id_play, .by_group = TRUE) |>
    dplyr::mutate(
      # TODO - Add these variables to the documentation and select outputs
      firstD_by_kickoff = ifelse(.data$kickoff_play == 1 & .data$down == 1, 1, 0),
      # end TODO
      firstD_by_poss = dplyr::case_when(
        #---- Drive Definition ----
        # 1-L.I) start by play after kickoff
        !(.data$lag_play_type %in% c("Timeout", "End Period")) & #     condition: has play event 1 row prior
          .data$drive_event_number == 2 & .data$lag_kickoff_play == 1 &
          .data$kickoff_play == 0 ~ 1,
        (.data$lag_play_type %in% c("Timeout", "End Period")) & #     condition: has non-play event 1 row prior, looks 2 rows back
          !(.data$lag_play_type2 %in% c("Timeout", "End Period")) &
          .data$drive_event_number == 3 & .data$lag_kickoff_play2 == 1 &
          .data$kickoff_play == 0 ~ 1,
        # 2-L.I) start by change of pos_team
        !(.data$lag_play_type %in% c("Timeout", "End Period")) & #     condition: has play event 1 row prior
          .data$lag_change_of_pos_team == 1 &
          (.data$lag_punt == 1 | .data$lag_downs_turnover == 1 | .data$lag_turnover_vec == 1) ~ 1,
        # 2-L.II) start by change of pos_team with 1 non-play event in between
        (.data$lag_play_type %in% c("Timeout", "End Period")) & #     condition: has non-play event 1 row prior, looks 2 rows back
          .data$lag_change_of_pos_team2 == 1 &
          !(.data$lag_play_type2 %in% c("Timeout", "End Period")) &
          (.data$lag_punt2 == 1 | .data$lag_downs_turnover2 == 1 | .data$lag_turnover_vec2 == 1) ~ 1,
        # 3-L.I) start by opponent scoring play
        !(.data$lag_play_type %in% c("Timeout", "End Period")) & #    condition: has play event 1 row prior
          .data$lag_scoring_play == 1 & .data$kickoff_play != 1 ~ 1,
        # 3-L.II) start by opponent scoring play with 1 non-play event in between
        (.data$lag_play_type %in% c("Timeout", "End Period")) & #     condition: has non-play event 1 row prior, looks 2 rows back
          !(.data$lag_play_type2 %in% c("Timeout", "End Period")) &
          .data$lag_scoring_play2 == 1 & .data$kickoff_play != 1 ~ 1,
        # 4) start of half plays start drives
        (.data$drive_event_number == 1 & .data$kickoff_play != 1) ~ 1,
        TRUE ~ 0
      ),
      firstD_by_penalty = ifelse((.data$lag_first_by_penalty == 1 & .data$lag_change_of_pos_team != 1 &
                                    !(.data$lag_play_type %in% c("Timeout", "End Period"))) |
                                   (.data$lag_first_by_penalty2 == 1 & .data$lag_change_of_pos_team2 != 1 &
                                      (.data$lag_play_type %in% c("Timeout", "End Period"))) |
                                   (.data$lag_first_by_penalty3 == 1 & .data$lag_change_of_pos_team3 != 1 &
                                      (.data$lag_play_type %in% c("Timeout", "End Period") & (.data$lag_play_type2 %in% c("Timeout", "End Period")))), 1, 0),
      firstD_by_penalty = dplyr::case_when(
        (.data$lag_first_by_penalty == 1 & .data$lag_change_of_pos_team != 1 &
           !(.data$lag_play_type %in% c("Timeout", "End Period"))) ~ 1,
        .data$lag_first_by_penalty2 == 1 & .data$lag_change_of_pos_team2 != 1 &
          (.data$lag_play_type %in% c("Timeout", "End Period")) ~ 1,
        .data$lag_first_by_penalty3 == 1 & .data$lag_change_of_pos_team3 != 1 &
          (.data$lag_play_type %in% c("Timeout", "End Period") & (.data$lag_play_type2 %in% c("Timeout", "End Period"))) ~ 1,
        TRUE ~ 0
      ),
      firstD_by_yards = ifelse((.data$lag_first_by_yards == 1 & .data$lag_change_of_pos_team != 1 &
                                  !(.data$lag_play_type %in% c("Timeout", "End Period"))) |
                                 (.data$lag_first_by_yards2 == 1 & .data$lag_change_of_pos_team2 != 1 &
                                    (.data$lag_play_type %in% c("Timeout", "End Period"))) |
                                 (.data$lag_first_by_yards3 == 1 & .data$lag_change_of_pos_team3 != 1 &
                                    (.data$lag_play_type %in% c("Timeout", "End Period") & (.data$lag_play_type2 %in% c("Timeout", "End Period")))), 1, 0),
      new_id = .data$id_play
    ) |>
    dplyr::ungroup() |>
    dplyr::arrange(.data$new_id, .by_group = TRUE) |>
    # dplyr::select(-.data$play, -.data$half_play, -.data$drive_play) |>
    dplyr::mutate(
      new_yardline = ifelse(.data$kickoff_play == 1 & .data$kickoff_tb == 1, 75, .data$new_yardline),
      new_yardline = ifelse(.data$end_of_half == 1, 100, .data$new_yardline),
      new_distance = ifelse(.data$new_yardline <= 0, .data$lead_distance2, .data$new_distance),
      new_yardline = ifelse(.data$new_yardline <= 0, .data$lead_yards_to_goal, .data$new_yardline),
      #--Punt Plays--------------------------
      new_down = ifelse(.data$punt == 1 | .data$kickoff_play == 1, 1, .data$new_down),
      new_distance = ifelse(.data$punt == 1, 10, .data$new_distance),
      new_log_ydstogo = ifelse(.data$punt == 1, log(10), .data$new_log_ydstogo),
      new_Goal_To_Go = ifelse(.data$punt == 1, FALSE, .data$new_Goal_To_Go),
      new_pos_score_diff_start = ifelse(.data$change_of_pos_team == 0, .data$pos_score_diff, -1 * .data$pos_score_diff),
      new_down = ifelse(.data$kickoff_play == 1, 1, .data$new_down)
    )

  #--End of Half Plays--------------------------
  end_of_half_plays <- (dat$new_TimeSecsRem == 0 |
                          (dat$end_of_half == 1 & !(dat$play_type %in% c("End Period", "End of Half", "End of Game"))))

  if (any(end_of_half_plays)) {
    dat$new_yardline[end_of_half_plays] <- 100
    dat$new_down[end_of_half_plays] <- 4
    dat$new_distance[end_of_half_plays] <- 100
    dat$end_of_half[end_of_half_plays] <- 1
    dat$new_log_ydstogo[end_of_half_plays] <- log(100)
    dat$new_Under_two[end_of_half_plays] <- dat$new_TimeSecsRem[end_of_half_plays] <= 120
  }

  # missed field goal needs to be here
  # needs to go before the na check to set to 99
  dat <- dat |>
    dplyr::mutate(
      new_yardline = dplyr::if_else(is.na(.data$new_yardline) &
                                      .data$play_type %in% c("Field Goal Missed", "Blocked Field Goal"),
                                    100 - (.data$yards_to_goal - 9),
                                    .data$new_yardline
      )
    )

  #--General weird plays that don't have an easy fix----
  na_yd_line <- which(is.na(dat$new_yardline) | dat$new_yardline >= 100)
  dat$new_yardline[na_yd_line] <- dat$yard_line[na_yd_line + 1]
  neg_distance <- which(dat$new_distance < 0)
  dat$new_distance[neg_distance] <- dat$distance[neg_distance + 1]
  dat$new_log_ydstogo[neg_distance] <- log(dat$new_distance[neg_distance])

  #--Missing yd_line Plays--------------------------
  missing_yd_line <- dat$new_yardline == 0
  dat$new_yardline[missing_yd_line] <- 100
  dat$new_log_ydstogo[missing_yd_line] <- log(100)
  dat$new_down[missing_yd_line] <- 1
  dat$missing_yard_flag <- FALSE
  dat$missing_yard_flag[missing_yd_line] <- TRUE

  dat <- dat |>
    dplyr::arrange(.data$id_play) |>
    dplyr::mutate(
      new_yardline = ifelse(.data$end_of_half == 1 & is.na(.data$new_yardline), 100, .data$new_yardline),
      new_id = gsub(pattern = unique(.data$game_id), "", x = .data$new_id),
      new_id = as.numeric(.data$new_id)
    )



  return(dat)
}


#' @rdname helpers_pbp
#'
#' @param drive_df (*data.frame* required) Drive dataframe pulled from API via the `cfbd_drives()` function
#' @details Cleans CFB (D-I) Drive-By-Drive Data to create `pts_drive` column. Requires the following columns be present:
#'
#' * `drive_id`: Returned as `drive_id`: .
#' * `drive_result`: End result of the drive: .
#' * `scoring`: Logical flag for if drive was a scoring drive: .
#' * `game_id`: Unique game identifier: .
#'
#' @return The original `drive_df` with the following columns appended to it:
#'
#' * `drive_id`: Returned as `drive_id` from original variable `drive_id`: .
#' * `pts_drive`: End result of the drive: .
#' * `scoring`: Logical flag for if drive was a scoring drive updated: .
#'
#' @keywords internal
#' @importFrom rlang .data
#' @importFrom stringr str_detect
#' @importFrom dplyr mutate arrange case_when
#' @export
#'

clean_drive_info <- function(drive_df) {
  clean_drive <- drive_df |>
    dplyr::mutate(
      drive_pts_rules = dplyr::case_when(
        .data$drive_result == "TD" ~ 7,
        stringr::str_detect(.data$drive_result, "SF") ~ -2,
        .data$drive_result == "FG GOOD" ~ 3,
        .data$drive_result == "FG" ~ 3,
        .data$drive_result == "MISSED FG TD" ~ -7,
        .data$drive_result == "KICKOFF RETURN TD" ~ -7,
        .data$drive_result == "END OF HALF TD" ~ 7,
        .data$drive_result == "END OF GAME TD" ~ 7,
        .data$drive_result == "PUNT RETURN TD" ~ -7,
        .data$drive_result == "PUNT TD" ~ -7,
        .data$drive_result == "INT TD" ~ -7,
        .data$drive_result == "INT RETURN TOUCH" ~ -7,
        .data$drive_result == "FUMBLE RETURN TD" ~ -7,
        .data$drive_result == "FUMBLE TD" ~ -7,
        .data$drive_result == "DOWNS TD" ~ -7,
        stringr::str_detect(.data$drive_result, "TD") ~ 7,
        TRUE ~ 0
      ),
      drive_pts_calculated = as.numeric(.data$end_offense_score - .data$start_offense_score - .data$end_defense_score + .data$start_defense_score),
      pts_drive = dplyr::case_when(
        # If calculated pt change is bigger than possible, data issue, use rule.
        abs(.data$drive_pts_calculated) > 8 ~ .data$drive_pts_rules,
        # If drive result is made fg, use rule to avoid calculation errors from bad data.
        .data$drive_pts_rules == 3 ~ .data$drive_pts_rules,
        # Calculated pts can only be 5 if the offense scores,and then the defense scores a safety on the xp attempt.
        # This does not happen. More likely comes from data issue, use rule.
        .data$drive_pts_calculated == 5 ~ .data$drive_pts_rules,
        # Impossible for change in net score to be 1, data issue, use rule.
        abs(.data$drive_pts_calculated) == 1 ~ .data$drive_pts_rules,
        # If calculation says 0 but rule says there should be points, data issue, use rule.
        .data$drive_pts_calculated == 0 & .data$drive_pts_rules != 0 ~ .data$drive_pts_rules,
        # If rule says 0 but score changed, likely mislabeled, use calculation.
        .data$drive_pts_rules == 0 & .data$drive_pts_calculated != 0 ~ .data$drive_pts_calculated,
        # Default is to use calculated value.
        TRUE ~ .data$drive_pts_calculated),
      scoring = ifelse(.data$pts_drive != 0, TRUE, .data$scoring)
    ) |>
    dplyr::select(-"drive_pts_rules",-"drive_pts_calculated") |>
    dplyr::mutate(drive_id = as.numeric(.data$drive_id)) |>
    dplyr::arrange(.data$game_id, .data$drive_id)

  return(clean_drive)
}


#' @rdname helpers_pbp
#'
#' @param play_df (*data.frame* required) Plays dataframe pulled from API via the `cfbd_play()` or within the `cfbd_pbp_data()` function.
#' @details Cleans CFB play-by-play text to be compliant with existing play-by-play parsing. Generally not recommended for standalone use. This method exists due to ESPN PBP changes midway through the 2025 season.
#'
#' * `play_text`: Returned as `play_text`: .
#'
#' @return The original `play_df` with the following columns appended to it:
#'
#' * `cleaned_text`: `play_text` with miscellanous items removed: pass depth/location, clock timestamps, No Huddle/Shotgun status, etc.: .
#'
#' @keywords internal
#' @importFrom rlang .data
#' @importFrom stringr str_replace
#' @importFrom dplyr mutate
#' @export
#'

clean_play_text <- function(play_df) {
  play_df <- play_df |>
    dplyr::mutate(
      cleaned_text = stringr::str_replace(.data$play_text, "^\\(\\d{1,2}:\\d{2}\\)\\s+", ""),
      cleaned_text = stringr::str_replace(.data$cleaned_text, "\\s(short|deep)\\s", " "),
      cleaned_text = stringr::str_replace(.data$cleaned_text, "\\s(left|middle|right)\\s", " "),
      cleaned_text = stringr::str_replace(.data$cleaned_text, "\\s*No Huddle-Shotgun\\s+", ""),
      cleaned_text = stringr::str_replace(.data$cleaned_text, "No Huddle-?", ""),
      cleaned_text = stringr::str_replace(.data$cleaned_text, "\\s*Shotgun\\s+", ""),
      cleaned_text = stringr::str_replace(.data$cleaned_text, "\\s+", " "),
    )
}
