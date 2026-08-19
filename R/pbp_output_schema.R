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
  # Enforcement resolution ported from sdv-py (helper_pbp_penalty_enforcement.R).
  # These sit in "default" deliberately: penalty_negated_play answers "did this
  # play count", which every EPA consumer needs, and the counts are what make
  # multi-penalty plays representable at all.
  "penalty_count", "penalty_declined_count", "penalty_all_declined",
  "penalty_enforcement", "penalty_negated_play",
  # Roster-resolved athlete ids (helper_pbp_attach_player_ids.R). "default" tier:
  # cfbfastR emitted player NAMES only, so every downstream join was string-keyed
  # and collided on duplicate names -- the id is the fix, not an extra.
  "rusher_player_id", "passer_player_id", "receiver_player_id", "fumble_player_id", "sack_player_id", "sack_player_id2", "interception_player_id", "pass_breakup_player_id", "fumble_forced_player_id", "fumble_recovered_player_id", "fg_kicker_player_id", "punter_player_id", "kickoff_player_id", "kickoff_return_player_id", "punt_return_player_id", "fg_block_player_id", "punt_block_player_id", "fg_return_player_id", "punt_block_return_player_id",
  # Team attribution + the turnover model (helper_pbp_attribution.R). "default"
  # tier: "which team lost the ball" is the question every turnover-rate,
  # takeaway and special-teams metric starts from, and cfbfastR could not answer
  # it at all before these landed. The per-side flags are kept alongside the
  # single-flag `is_turnover` view because one play can lose the ball twice, and
  # a single boolean cannot say that both teams turned it over.
  "pos_team_id", "def_pos_team_id",
  "kicking_team", "return_team", "punt_return_team", "kick_return_team",
  "fg_team", "punt_team", "sack_team", "interception_team",
  "pass_breakup_team", "forced_fumble_team", "fumble_recovery_team",
  "fumble_or_muff", "fumbling_team", "recovery_team", "recovery_team_2",
  "int_turnover", "pos_fumble_lost", "def_fumble_lost",
  "is_pos_team_turnover", "is_def_pos_team_turnover",
  "is_turnover", "espn_is_turnover", "turnover_team", "is_st_turnover",
  "is_blocked_punt_turnover", "is_blocked_fg_turnover",
  "penalized_team", "penalty_team_id", "penalty_yards_signed",
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
#'
#' `punt_return_player` / `kickoff_return_player` are the raw regex
#' intermediates and `rush_player_name` duplicates `rusher_player_name`, so all
#' three are genuine aliases.
#'
#' The two `*_return_player_name` columns were dropped here historically but are
#' NOT aliases: the released pbp ships `punt_return_player_id` /
#' `kickoff_return_player_id`, so withholding the name twin made returners the
#' only credited role in the dataset identifiable by id alone. They are retained
#' as of this change so every role ships id *and* name.
#' @keywords internal
#' @noRd
.pbp_drop_player_aliases <- c(
  "punt_return_player",
  "kickoff_return_player",
  "rush_player_name"
)

#' Lag/lead intermediates produced for the pipeline's internal use
#'
#' Drive-boundary detection, turnover detection, EP/WP series shifts. Not
#' needed for descriptive analysis -- useful only when doing sequential
#' modeling that wants pre-computed shifts. Dropped in both `"default"` and
#' `"lean"` output tiers; kept in `"full"`.
#'
#' @keywords internal
#' @noRd
.pbp_drop_lag_lead <- c(
  # play-type / play-text shifts
  "lag_play_type", "lag_play_type2", "lag_play_type3",
  "lead_play_type", "lead_play_type2", "lead_play_type3",
  "lag_play_text", "lag_play_text2", "lag_play_text3",
  "lead_play_text", "lead_play_text2", "lead_play_text3",
  # down/distance/yardline shifts
  "lag_down", "lag_down2", "lead_down", "lead_down2",
  "lag_distance", "lag_distance2", "lag_distance3",
  "lead_distance", "lead_distance2",
  "lag_yards_to_goal", "lag_yards_to_goal2",
  "lead_yards_to_goal", "lead_yards_to_goal2",
  "lag_yards_gained", "lag_yards_gained2", "lag_yards_gained3",
  "lead_yards_gained", "lead_yards_gained2",
  # time shifts
  "lag_TimeSecsRem", "lag_TimeSecsRem2",
  "lead_TimeSecsRem", "lead_TimeSecsRem2",
  # team / possession shifts
  "lag_pos_team", "lead_pos_team",
  "lag_offense_play", "lead_offense_play", "lead_offense_play2",
  # timeout shifts
  "lag_off_timeouts", "lag_def_timeouts",
  # change-of-possession shifts (3 horizons each)
  "lag_change_of_poss", "lag_change_of_poss2", "lag_change_of_poss3",
  "lag_change_of_pos_team", "lag_change_of_pos_team2", "lag_change_of_pos_team3",
  # event-flag shifts (3 horizons each)
  "lag_kickoff_play", "lag_kickoff_play2", "lag_kickoff_play3",
  "lag_punt", "lag_punt2", "lag_punt3",
  "lag_scoring_play", "lag_scoring_play2", "lag_scoring_play3",
  "lag_turnover_vec", "lag_turnover_vec2", "lag_turnover_vec3",
  "lag_downs_turnover", "lag_downs_turnover2", "lag_downs_turnover3",
  "lag_first_by_penalty", "lag_first_by_penalty2", "lag_first_by_penalty3",
  "lag_first_by_yards", "lag_first_by_yards2", "lag_first_by_yards3",
  # EP/WP shifts
  "lag_ep_before", "lag_ep_before2", "lag_ep_before3",
  "lead_ep_before", "lead_ep_before2",
  "lag_ep_after", "lag_ep_after2", "lag_ep_after3",
  "lead_ep_after", "lead_ep_after2",
  # one-off lags
  "lag_defense_score_play", "lag_score_diff", "lag_pos_score_diff",
  "turnover_vec_lag"
)

#' Redundant alternates -- each has a canonical column downstream should prefer
#'
#' `orig_play_type` is intentionally **kept** even though it duplicates
#' `play_type` on most rows -- it preserves the original label when
#' `clean_pbp_dat()` rewrites `play_type` mid-pipeline (e.g. for fumble
#' recoveries that get reclassified). Useful for auditing the reclassification.
#'
#' Dropped in both `"default"` and `"lean"` output tiers; kept in `"full"`.
#'
#' @keywords internal
#' @noRd
.pbp_drop_redundant <- c(
  "sack_vec",            # use `sack`
  "turnover_indicator",  # use `turnover_vec`
  "kick_play",           # = kickoff_play | punt
  "missing_yard_flag"    # internal debug flag
)

#' Drive-result aliases and per-drive intermediates
#'
#' `drive_result_detailed` is the canonical drive-result label. `pts_scored`
#' is intentionally **kept** because it carries per-play scoring points
#' (e.g. -7, -2, +3, +7) which is distinct from `drive_pts` (per-drive).
#'
#' Dropped in both `"default"` and `"lean"` output tiers; kept in `"full"`.
#'
#' @keywords internal
#' @noRd
.pbp_drop_drive_aliases <- c(
  "drive_result_detailed_flag",   # raw form before backfill (redundant)
  "drive_result2",                # UPPERCASE shorthand of drive_result_detailed
  "lag_drive_result_detailed",
  "lead_drive_result_detailed",
  "lag_new_drive_pts"
)

#' WPA computation scratchpad written by `.pbp_wpa_calcs_naive()`
#'
#' Internal accounting for the two WPA branches (base / change) and their
#' indicators. Useful when debugging WHY a given `wpa` value came out the
#' way it did; not needed by the modeled `wpa` / `wp_before` / `wp_after`
#' consumers. Dropped only in `"lean"`; kept in `"default"` and `"full"`.
#'
#' @keywords internal
#' @noRd
.pbp_drop_wpa_scratch <- c(
  "wpa_base", "wpa_base_nxt",
  "wpa_base_ind", "wpa_base_nxt_ind",
  "wpa_change", "wpa_change_nxt",
  "wpa_change_ind", "wpa_change_nxt_ind",
  "wpa_half_end",
  "lead_wp_before", "lead_wp_before2",
  "lead_pos_team2"
)

#' Apply the canonical PBP output column ordering and tiered drops
#'
#' Drops player-name aliases (always), and applies tier-specific drops:
#'   * `"default"` -- drops lag/lead intermediates, redundant alternates, and
#'     drive-result aliases. Keeps `orig_play_type`, `pts_scored`, the
#'     `*_end` post-play state family, and the WPA computation scratchpad.
#'     A meaningful slim-down (~75 columns lighter than `"full"`) with no
#'     loss of information that isn't trivially rebuildable.
#'   * `"lean"` -- everything `"default"` drops, plus the WPA scratchpad.
#'     For dashboards / leaderboards / game logs.
#'   * `"full"` -- legacy behavior: no drops beyond the player-name aliases.
#'     For sequential modeling that consumes pre-computed lag/lead shifts
#'     or the per-branch WPA decomposition.
#'
#' Known columns appear in `.pbp_output_order` order; unknown columns are
#' kept and trailed (drift-safe). Does not error on missing columns.
#'
#' @param df A data frame.
#' @param output One of `"default"` (recommended), `"lean"`, or `"full"`.
#' @return `df` with columns dropped per `output` and reordered to the
#'   canonical schema.
#' @keywords internal
#' @noRd
.pbp_apply_output_schema <- function(df, output = "default") {
  if (!is.character(output) || length(output) != 1L ||
      !output %in% c("default", "lean", "full")) {
    cli::cli_abort(c(
      "{.arg output} must be one of {.val default}, {.val lean}, or {.val full}.",
      x = "You supplied {.val {output}}."
    ))
  }

  df <- df |> dplyr::select(-dplyr::any_of(.pbp_drop_player_aliases))

  if (output != "full") {
    df <- df |>
      dplyr::select(-dplyr::any_of(c(
        .pbp_drop_lag_lead,
        .pbp_drop_redundant,
        .pbp_drop_drive_aliases
      )))
  }

  if (output == "lean") {
    df <- df |> dplyr::select(-dplyr::any_of(.pbp_drop_wpa_scratch))
  }

  known   <- intersect(.pbp_output_order, colnames(df))
  unknown <- setdiff(colnames(df), known)
  df[, c(known, unknown), drop = FALSE]
}
