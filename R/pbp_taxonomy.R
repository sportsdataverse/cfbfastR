#' Canonical play-type taxonomy for the PBP/EPA/WPA pipeline
#'
#' Single source of truth for the play-type vectors used by the modular
#' EPA/WPA helpers (`.pbp_*`). Replaces the four drifted copies in the legacy
#' helpers (`add_play_counts`, `clean_pbp_dat`, `prep_epa_df_after`,
#' `create_epa`). Resolutions noted inline.
#'
#' @return A named list of character vectors.
#' @keywords internal
#' @noRd
.pbp_play_types <- function() {
  list(
    kickoff = c(
      "Kickoff", "Kickoff Return (Offense)", "Kickoff Return Touchdown",
      "Kickoff Touchdown", "Kickoff Team Fumble Recovery",
      "Kickoff Team Fumble Recovery Touchdown", "Kickoff (Safety)",
      "Penalty (Kickoff)"
    ),
    turnover = c(
      "Blocked Field Goal", "Blocked Field Goal Touchdown",
      "Blocked Punt", "Blocked Punt Touchdown",
      "Field Goal Missed", "Missed Field Goal Return",
      "Missed Field Goal Return Touchdown",
      "Fumble Recovery (Opponent)", "Fumble Recovery (Opponent) Touchdown",
      "Fumble Return Touchdown", "Defensive 2pt Conversion",
      "Interception", "Interception Return", "Interception Return Touchdown",
      "Pass Interception", "Pass Interception Return",
      "Pass Interception Return Touchdown",
      "Kickoff Team Fumble Recovery", "Kickoff Team Fumble Recovery Touchdown",
      "Punt Touchdown", "Punt Return Touchdown",
      "Sack Touchdown", "Uncategorized Touchdown"
    ),
    scores = c(
      "Blocked Punt Touchdown", "Blocked Punt (Safety)", "Punt (Safety)",
      "Blocked Field Goal Touchdown", "Missed Field Goal Return Touchdown",
      "Fumble Recovery (Opponent) Touchdown", "Fumble Return Touchdown",
      "Interception Return Touchdown", "Pass Interception Return Touchdown",
      "Punt Touchdown", "Punt Return Touchdown",
      "Penalty (Safety)", "Punt Team Fumble Recovery Touchdown",
      "Sack Touchdown", "Uncategorized Touchdown",
      "Defensive 2pt Conversion", "Safety",
      "Kickoff Team Fumble Recovery Touchdown", "Kickoff (Safety)",
      "Passing Touchdown", "Rushing Touchdown", "Field Goal Good",
      "Pass Reception Touchdown", "Fumble Recovery (Own) Touchdown"
    ),
    # offense_score: union of clean_pbp_dat / add_play_counts / create_epa
    # off_TD -- includes "Kickoff Return Touchdown" (create_epa) and the punt
    # team's fumble recovery TD (clean_pbp_dat). The kickoff team's recovery
    # touchdown and "Kickoff Touchdown" are the defence's (the kickoff's possession
    # team is the receiver), as in sdv-py; listed on both sides they set
    # offense_score_play too.
    offense_score = c(
      "Passing Touchdown", "Rushing Touchdown", "Field Goal Good",
      "Pass Reception Touchdown", "Fumble Recovery (Own) Touchdown",
      "Punt Touchdown", "Punt Team Fumble Recovery Touchdown",
      "Kickoff Return Touchdown"
    ),
    # not "Kickoff Return Touchdown": the receiving team (the kickoff's possession team)
    # scores it, and listed on both sides the defence's -7 overwrote the offence's 7
    # (every return touchdown booked EPA about -7.7; sdv-py's defense_score_vec has it not)
    defense_score = c(
      "Blocked Punt Touchdown", "Blocked Field Goal Touchdown",
      "Missed Field Goal Return Touchdown", "Punt Return Touchdown",
      "Fumble Recovery (Opponent) Touchdown", "Fumble Return Touchdown",
      "Defensive 2pt Conversion",
      "Safety", "Kickoff (Safety)",
      "Blocked Punt (Safety)", "Punt (Safety)", "Penalty (Safety)",
      "Sack Touchdown",
      "Interception Return Touchdown", "Pass Interception Return Touchdown",
      "Uncategorized Touchdown",
      "Kickoff Touchdown", "Kickoff Team Fumble Recovery Touchdown"
    ),
    # normalplay: union resolution -- the create_epa() variant includes
    # "Fumble Recovery (Own)"; prep_epa_df_after() does not. Canonical = union.
    normalplay = c(
      "Rush", "Pass", "Pass Reception", "Pass Incompletion",
      "Pass Completion", "Sack", "Fumble Recovery (Own)"
    ),
    penalty = c("Penalty", "Penalty (Kickoff)", "Penalty (Safety)"),
    int = c(
      "Interception", "Interception Return", "Interception Return Touchdown",
      "Pass Interception", "Pass Interception Return",
      "Pass Interception Return Touchdown"
    ),
    punt = c(
      "Blocked Punt", "Blocked Punt Touchdown", "Blocked Punt (Safety)",
      "Punt (Safety)", "Punt", "Punt Touchdown",
      "Punt Team Fumble Recovery", "Punt Team Fumble Recovery Touchdown",
      "Punt Return Touchdown"
    ),
    field_goal = c(
      "Field Goal Good", "Blocked Field Goal", "Field Goal Missed",
      "Missed Field Goal Return", "Blocked Field Goal Touchdown",
      "Missed Field Goal Return Touchdown"
    ),
    turnover_play_type = c(
      "Blocked Field Goal", "Blocked Field Goal Touchdown",
      "Blocked Punt", "Blocked Punt Touchdown",
      "Punt", "Punt Touchdown", "Punt Return Touchdown",
      "Sack Touchdown",
      "Field Goal Missed", "Missed Field Goal Return",
      "Missed Field Goal Return Touchdown",
      "Fumble Recovery (Opponent)", "Fumble Recovery (Opponent) Touchdown",
      "Interception", "Interception Return", "Interception Return Touchdown",
      "Pass Interception Return", "Pass Interception Return Touchdown",
      "Uncategorized Touchdown"
    )
  )
}
