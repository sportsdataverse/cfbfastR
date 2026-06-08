#' Modular PBP -- WP model -> wp_before/after + wpa
#'
#' Refactor of `create_wpa_naive()` for the modular `.run_epa_wpa()` engine.
#' Differences from legacy:
#'   * the dead `if (!all(col_nec %in% colnames(df)))` fallback branch
#'     (legacy:40-114) is removed -- it references `.data$offense_play_lag`,
#'     a column that does not exist anywhere in the codebase, so the branch
#'     errors the moment it runs. `.run_epa_wpa()` always supplies the
#'     `col_nec` columns from `.pbp_create_epa()`, so the branch is
#'     unreachable in the modular path.
#'   * `purrr::map_dfr` (superseded in purrr 1.0) is replaced with
#'     `purrr::list_rbind(purrr::map(...))`.
#'
#' @keywords internal
#' @noRd
#' @importFrom dplyr arrange filter
#' @importFrom purrr map list_rbind
#' @importFrom stats predict
#' @importFrom rlang .data
.pbp_create_wpa_naive <- function(df, wp_model) {
  df <- df |>
    dplyr::arrange(.data$game_id, .data$new_id)
  Off_Win_Prob <- as.vector(predict(wp_model, newdata = df, type = "response"))
  df$wp_before <- Off_Win_Prob
  # Kickoff plays
  # Calculate EP before at kickoff as what happens if it was a touchback
  # 25 yard line in 2012 and onwards
  kickoff_ind <- (df$kickoff_play == 1)
  if (any(kickoff_ind)) {
    new_kick <- df[kickoff_ind, ]
    new_kick["down"] <- as.factor(1)
    new_kick["distance"] <- 10
    new_kick["yards_to_goal"] <- 75
    new_kick["log_ydstogo"] <- log(10)
    new_kick["ExpScoreDiff"] <- new_kick["pos_score_diff_start"] + new_kick["ep_before"]
    new_kick["ExpScoreDiff_Time_Ratio"] <- new_kick["ExpScoreDiff"] / (new_kick["adj_TimeSecsRem"] + 1)
    df[kickoff_ind, "wp_before"] <- as.vector(predict(wp_model, new_kick, type = "response"))
  }
  g_ids <- sort(unique(df$game_id))
  df2 <- purrr::list_rbind(purrr::map(
    g_ids,
    function(x) {
      df |>
        dplyr::filter(.data$game_id == x) |>
        .pbp_wpa_calcs_naive()
    }
  ))
  return(df2)
}

#' Modular PBP -- per-game WPA calculations
#'
#' Verbatim refactor of `wpa_calcs_naive()` for `.pbp_create_wpa_naive()`.
#'
#' @keywords internal
#' @noRd
#' @importFrom dplyr mutate lead if_else
#' @importFrom rlang .data
.pbp_wpa_calcs_naive <- function(df) {
  df2 <- df |>
    dplyr::mutate(
      def_wp_before = 1 - .data$wp_before,
      home_wp_before = dplyr::if_else(.data$pos_team == .data$home,
        .data$wp_before,
        .data$def_wp_before
      ),
      away_wp_before = dplyr::if_else(.data$pos_team != .data$home,
        .data$wp_before,
        .data$def_wp_before
      )
    ) |>
    dplyr::mutate(
      lead_wp_before = dplyr::lead(.data$wp_before, 1),
      lead_wp_before2 = dplyr::lead(.data$wp_before, 2),
      # base wpa
      wpa_base = .data$lead_wp_before - .data$wp_before,
      wpa_base_nxt = .data$lead_wp_before2 - .data$wp_before,
      wpa_base_ind = ifelse(.data$pos_team == .data$lead_pos_team, 1, 0),
      wpa_base_nxt_ind = ifelse(.data$pos_team == .data$lead_pos_team2, 1, 0),
      # account for turnover
      wpa_change = (1 - .data$lead_wp_before) - .data$wp_before,
      wpa_change_nxt = (1 - .data$lead_wp_before2) - .data$wp_before,
      wpa_change_ind = ifelse((.data$pos_team != .data$lead_pos_team), 1, 0),
      wpa_change_nxt_ind = ifelse(.data$pos_team != .data$lead_pos_team2, 1, 0),
      wpa_half_end = ifelse(.data$end_of_half == 1 & .data$wpa_base_nxt_ind == 1 &
        .data$play_type != "Timeout", .data$wpa_base_nxt,
      ifelse(.data$end_of_half == 1 & .data$wpa_change_nxt_ind == 1 &
        .data$play_type != "Timeout", .data$wpa_change_nxt,
      ifelse(.data$end_of_half == 1 & .data$pos_team_receives_2H_kickoff == 0 &
        .data$play_type == "Timeout", .data$wpa_base,
      ifelse(.data$wpa_change_ind == 1,
        .data$wpa_change,
        .data$wpa_base
      )
      )
      )
      ),
      wpa = ifelse(.data$end_of_half == 1 & .data$play_type != "Timeout",
        .data$wpa_half_end,
        ifelse((.data$lead_play_type %in% c("End Period", "End of Half")) & .data$change_of_pos_team == 0,
          .data$wpa_base_nxt,
          ifelse((.data$lead_play_type %in% c("End Period", "End of Half")) & .data$change_of_pos_team == 1,
            .data$wpa_change_nxt,
            ifelse(.data$wpa_change_ind == 1, .data$wpa_change, .data$wpa_base)
          )
        )
      ),
      wp_after = .data$wp_before + .data$wpa,
      def_wp_after = 1 - .data$wp_after,
      home_wp_after = ifelse(.data$pos_team == .data$home,
        .data$home_wp_before + .data$wpa,
        .data$home_wp_before - .data$wpa
      ),
      away_wp_after = ifelse(.data$pos_team != .data$home,
        .data$away_wp_before + .data$wpa,
        .data$away_wp_before - .data$wpa
      ),
      wp_before = round(.data$wp_before, 7),
      def_wp_before = round(.data$def_wp_before, 7),
      home_wp_before = round(.data$home_wp_before, 7),
      away_wp_before = round(.data$away_wp_before, 7),
      lead_wp_before = round(.data$lead_wp_before, 7),
      lead_wp_before2 = round(.data$lead_wp_before2, 7),
      wpa_base = round(.data$wpa_base, 7),
      wpa_base_nxt = round(.data$wpa_base_nxt, 7),
      wpa_change = round(.data$wpa_change, 7),
      wpa_change_nxt = round(.data$wpa_change_nxt, 7),
      wpa = round(.data$wpa, 7),
      wp_after = round(.data$wp_after, 7),
      def_wp_after = round(.data$def_wp_after, 7),
      home_wp_after = round(.data$home_wp_after, 7),
      away_wp_after = round(.data$away_wp_after, 7)
    )
  return(df2)
}
