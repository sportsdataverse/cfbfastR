#' Canonical output column order for the modular PBP/EPA/WPA pipeline
#'
#' Replaces the 15 hand-kept column-ordering vectors in the legacy
#' `cfbd_pbp_data()`. The constant is the verbatim concatenation of those
#' vectors in their existing order (with duplicates removed, keeping first
#' occurrence), so new-path output ordering matches legacy exactly.
#' Unknown columns are kept and trailed.
#'
#' @keywords internal
#' @noRd
.pbp_output_order <- c(
  # play_columns
  "season", "wk", "id_play", "game_id", "game_play_number", "half_play_number",
  "drive_play_number",
  "pos_team", "def_pos_team", "pos_team_score", "def_pos_team_score",
  "half", "period", "clock_minutes", "clock_seconds",
  "play_type", "play_text",
  "down", "distance", "yards_to_goal", "yards_gained",
  # model_columns
  "EPA", "ep_before", "ep_after",
  "wpa", "wp_before", "wp_after",
  "def_wp_before", "def_wp_after",
  "penalty_detail", "yds_penalty", "penalty_1st_conv",
  # series_columns
  "new_series", "firstD_by_kickoff", "firstD_by_poss",
  "firstD_by_penalty", "firstD_by_yards",
  # epa_flag_columns
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
  "middle_8", "stuffed_run",
  # team_columns
  "change_of_pos_team", "downs_turnover", "turnover",
  "pos_score_diff_start", "pos_score_pts", "log_ydstogo",
  "ExpScoreDiff", "ExpScoreDiff_Time_Ratio", "half_clock_minutes",
  "TimeSecsRem", "adj_TimeSecsRem", "Goal_To_Go", "Under_two",
  "home", "away",
  "home_wp_before", "away_wp_before", "home_wp_after", "away_wp_after",
  "end_of_half", "pos_team_receives_2H_kickoff",
  "lead_pos_team", "lead_play_type", "lag_pos_team", "lag_play_type",
  "orig_play_type", "Under_three",
  # model_end_columns
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
  "off_timeouts_rem_before", "def_timeouts_rem_before",
  # player_name_columns
  "rusher_player_name", "yds_rushed",
  "passer_player_name", "receiver_player_name", "yds_receiving",
  "yds_sacked", "sack_players", "sack_player_name", "sack_player_name2",
  "pass_breakup_player_name", "interception_player_name", "yds_int_return",
  "fumble_player_name", "fumble_forced_player_name",
  "fumble_recovered_player_name", "yds_fumble_return",
  "punter_player_name", "yds_punted",
  "punt_returner_player_name", "yds_punt_return", "yds_punt_gained",
  "punt_block_player_name", "punt_block_return_player_name",
  "fg_kicker_player_name", "yds_fg",
  "fg_block_player_name", "fg_return_player_name",
  "kickoff_player_name", "yds_kickoff",
  "kickoff_returner_player_name", "yds_kickoff_return",
  "new_id",
  # drive_columns
  "orig_drive_number", "drive_number",
  "drive_result_detailed", "new_drive_pts", "drive_id", "drive_result",
  "drive_start_yards_to_goal", "drive_end_yards_to_goal", "drive_yards",
  "drive_scoring", "drive_pts",
  "drive_start_period", "drive_end_period",
  "drive_time_minutes_start", "drive_time_seconds_start",
  "drive_time_minutes_end", "drive_time_seconds_end",
  "drive_time_minutes_elapsed", "drive_time_seconds_elapsed",
  "drive_numbers", "number_of_drives", "pts_scored",
  "drive_result_detailed_flag", "drive_result2",
  "drive_num", "lag_drive_result_detailed", "lead_drive_result_detailed",
  "lag_new_drive_pts", "id_drive",
  # play_flag_columns
  "rush", "rush_td", "pass", "pass_td",
  "completion", "pass_attempt", "target",
  "sack_vec", "sack", "int", "int_td",
  "turnover_vec", "turnover_vec_lag", "turnover_indicator",
  "kickoff_play", "receives_2H_kickoff", "missing_yard_flag",
  "scoring_play", "td_play", "touchdown", "safety", "fumble_vec",
  "kickoff_tb", "kickoff_onside", "kickoff_oob",
  "kickoff_fair_catch", "kickoff_downed",
  "kickoff_safety", "kick_play",
  "punt", "punt_play", "punt_tb", "punt_oob",
  "punt_fair_catch", "punt_downed",
  "punt_safety", "punt_blocked", "penalty_safety",
  "fg_inds", "fg_made", "fg_make_prob",
  # model_prob_columns
  "No_Score_before", "FG_before", "Opp_FG_before", "Opp_Safety_before",
  "Opp_TD_before", "Safety_before", "TD_before",
  "No_Score_after", "FG_after", "Opp_FG_after", "Opp_Safety_after",
  "Opp_TD_after", "Safety_after", "TD_after",
  # penalty_columns
  "penalty_flag", "penalty_declined", "penalty_no_play", "penalty_offset",
  "penalty_text", "penalty_play_text",
  # wpa_extra_columns
  "lead_wp_before2", "wpa_half_end",
  "wpa_base", "wpa_base_nxt", "wpa_change", "wpa_change_nxt",
  "wpa_base_ind", "wpa_base_nxt_ind", "wpa_change_ind", "wpa_change_nxt_ind",
  "lead_wp_before", "lead_pos_team2",
  # lag_series_columns (note: lead_play_type and lag_play_type already in team_columns)
  "row", "drive_event_number",
  "lag_play_type2", "lag_play_type3",
  "lag_play_text", "lag_play_text2", "lead_play_text",
  "lag_first_by_penalty", "lag_first_by_penalty2",
  "lag_first_by_yards", "lag_first_by_yards2",
  "first_by_penalty", "first_by_yards", "play_after_turnover",
  "lag_change_of_poss", "lag_change_of_pos_team", "lag_change_of_pos_team2",
  "lag_kickoff_play", "lag_punt", "lag_punt2",
  "lag_scoring_play", "lag_turnover_vec",
  "lag_downs_turnover", "lag_defense_score_play",
  # lag_lead_columns
  "lag_score_diff", "lag_offense_play",
  "lead_offense_play", "lead_offense_play2",
  "lag_pos_score_diff", "lag_off_timeouts",
  "lag_def_timeouts",
  "lag_TimeSecsRem2", "lag_TimeSecsRem",
  "lead_TimeSecsRem", "lead_TimeSecsRem2",
  "lag_yards_to_goal2", "lag_yards_to_goal",
  "lead_yards_to_goal", "lead_yards_to_goal2",
  "lag_down2", "lag_down",
  "lead_down", "lead_down2",
  "lead_distance", "lead_distance2",
  "lead_play_type2", "lead_play_type3",
  "lag_ep_before3", "lag_ep_before2", "lag_ep_before",
  "lead_ep_before", "lead_ep_before2",
  "lag_ep_after", "lag_ep_after2", "lag_ep_after3",
  "lead_ep_after", "lead_ep_after2"
)

#' Player-name alias columns dropped on output (legacy quirks)
#' @keywords internal
#' @noRd
.pbp_drop_player_aliases <- c(
  "punt_return_player",
  "kickoff_return_player",
  "rush_player_name",
  "punt_return_player_name",
  "kickoff_return_player_name"
)

#' Apply the canonical PBP output column ordering
#'
#' Known columns appear in `.pbp_output_order` order; unknown columns are
#' kept and trailed (drift-safe). Documented player-name aliases are dropped.
#' Does not error on missing columns.
#'
#' @param df A data frame.
#' @return `df` with columns reordered and player-name aliases dropped.
#' @keywords internal
#' @noRd
#' @importFrom magrittr %>%
.pbp_apply_output_schema <- function(df) {
  df <- df %>% dplyr::select(-dplyr::any_of(.pbp_drop_player_aliases))
  known <- intersect(.pbp_output_order, colnames(df))
  unknown <- setdiff(colnames(df), known)
  df[, c(known, unknown), drop = FALSE]
}
