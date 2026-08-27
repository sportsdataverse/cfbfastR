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
  # .wp_predict() handles either model generation and derives `is_home`, the
  # one bundle feature the frame does not already carry.
  df$wp_before <- .wp_predict(wp_model, df)
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
    df[kickoff_ind, "wp_before"] <- .wp_predict(wp_model, new_kick)
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

#' Modular PBP -- WPA overlays for an arbitrary win-probability column
#'
#' The differencing is not a plain `lead(wp) - wp`: possession changes flip the
#' perspective (`1 - lead_wp`), and half/period ends read the lead-2 play
#' because the intervening row is a timeout or an end-of-period marker. That
#' logic is identical whichever WP column is being differenced, so it lives
#' here once and is driven by `wp` -- the naive `wp_before` and the
#' spread-aware `vegas_wp` both route through it.
#'
#' MUST be called on ONE GAME at a time, already ordered: `dplyr::lead()` here
#' would otherwise reach across the game boundary and difference the last play
#' of one game against the first play of the next.
#'
#' @param df One game's plays, ordered.
#' @param wp Numeric win-probability vector to difference.
#' @return Numeric WPA vector, `nrow(df)` long.
#' @keywords internal
#' @noRd
.wpa_overlay <- function(df, wp) {
  lead_wp <- dplyr::lead(wp, 1)
  lead_wp2 <- dplyr::lead(wp, 2)

  wpa_base <- lead_wp - wp
  wpa_base_nxt <- lead_wp2 - wp
  wpa_base_nxt_ind <- ifelse(df$pos_team == df$lead_pos_team2, 1, 0)
  # possession changed hands: the next team's win probability is this team's loss
  wpa_change <- (1 - lead_wp) - wp
  wpa_change_nxt <- (1 - lead_wp2) - wp
  wpa_change_ind <- ifelse(df$pos_team != df$lead_pos_team, 1, 0)
  wpa_change_nxt_ind <- ifelse(df$pos_team != df$lead_pos_team2, 1, 0)

  wpa_half_end <- ifelse(df$end_of_half == 1 & wpa_base_nxt_ind == 1 &
    df$play_type != "Timeout", wpa_base_nxt,
  ifelse(df$end_of_half == 1 & wpa_change_nxt_ind == 1 &
    df$play_type != "Timeout", wpa_change_nxt,
  ifelse(df$end_of_half == 1 & df$pos_team_receives_2H_kickoff == 0 &
    df$play_type == "Timeout", wpa_base,
  ifelse(wpa_change_ind == 1, wpa_change, wpa_base))))

  ifelse(df$end_of_half == 1 & df$play_type != "Timeout",
    wpa_half_end,
    ifelse((df$lead_play_type %in% c("End Period", "End of Half")) & df$change_of_pos_team == 0,
      wpa_base_nxt,
      ifelse((df$lead_play_type %in% c("End Period", "End of Half")) & df$change_of_pos_team == 1,
        wpa_change_nxt,
        ifelse(wpa_change_ind == 1, wpa_change, wpa_base)
      )
    )
  )
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

  # Spread-aware WPA, derived with the same overlays via .wpa_overlay(). It is
  # computed HERE rather than in its own pipeline stage so it inherits this
  # function's per-game split and ordering -- a lead() spanning a game boundary
  # would difference the last play of one game against the first of the next.
  # The naive block above is left inline and untouched: it produces published
  # values, and test-wpa_overlay asserts the helper reproduces it exactly.
  if ("vegas_wp" %in% names(df2)) {
    df2$vegas_wpa <- round(.wpa_overlay(df2, df2$vegas_wp), 7)
    df2$vegas_wp_after <- round(df2$vegas_wp + df2$vegas_wpa, 7)
  }
  return(df2)
}
