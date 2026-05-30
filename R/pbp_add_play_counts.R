#' Modular PBP -- adds play counts, pos_team, score diffs, lag/lead frames
#'
#' Refactor of `add_play_counts()` for the modular `.run_epa_wpa()` engine.
#' Behavior-equivalent except for: (a) reads play-type vectors from
#' `.pbp_play_types()` instead of local declarations; (b) qualifies all
#' column refs as `.data$col` where the legacy already did.
#'
#' @param play_df Single-game play data frame (post-`penalty_detection()`).
#' @return `play_df` with play-count / pos_team / score-diff / lag-lead columns.
#' @keywords internal
#' @noRd
#' @importFrom rlang .data
#' @importFrom dplyr group_by mutate ungroup lead lag arrange n case_when
#' @importFrom tidyr fill
.pbp_add_play_counts <- function(play_df) {
  tt                <- .pbp_play_types()
  penalty           <- tt$penalty
  scores_vec        <- tt$scores
  turnover_vec      <- tt$turnover
  offense_score_vec <- tt$offense_score
  defense_score_vec <- tt$defense_score
  kickoff_vec       <- tt$kickoff
  punt_vec          <- tt$punt
  int_vec           <- tt$int

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
