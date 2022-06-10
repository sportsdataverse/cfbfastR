#' @name create_wpa
#' @aliases create_wpa_naive wpa_calcs_naive
#' @title **Create WPA**
#' @description  Add Win Probability Added (WPA) calculations to Play-by-Play DataFrame
#' This is only for D1 football
#' @param df (*data.frame* required): Clean Play-by-Play data.frame with Expected Points Added (EPA) calculations
#' @param wp_model (*model* default cfbfastR:wp_model): Win Probability (WP) Model
#' @details Requires the following columns to be present in the input data frame.
#' @return The original `df` with the following columns appended to it:
#' \describe{
#' \item{wp_before}{.}
#' \item{def_wp_before}{.}
#' \item{home_wp_before}{.}
#' \item{away_wp_before}{.}
#' \item{lead_wp_before}{.}
#' \item{lead_wp_before2}{.}
#' \item{wpa_base}{.}
#' \item{wpa_base_nxt}{.}
#' \item{wpa_base_ind}{.}
#' \item{wpa_base_nxt_ind}{.}
#' \item{wpa_change}{.}
#' \item{wpa_change_nxt}{.}
#' \item{wpa_change_ind}{.}
#' \item{wpa_change_nxt_ind}{.}
#' \item{wpa}{.}
#' \item{wp_after}{.}
#' \item{def_wp_after}{.}
#' \item{home_wp_after}{.}
#' \item{away_wp_after}{.}
#' }
#' @keywords internal
#' @importFrom dplyr mutate lag lead filter case_when arrange
#' @importFrom tidyr fill
#' @importFrom mgcv bam
#' @importFrom purrr map_dfr
#' @export
#'

create_wpa_naive <- function(df, wp_model) {
  col_nec <- c(
    "ExpScoreDiff",
    "TimeSecsRem",
    "half",
    "Under_two",
    "pos_team_timeouts_rem_before",
    "def_pos_team_timeouts_rem_before",
    "pos_score_diff_start"
  )
  if (!all(col_nec %in% colnames(df))) {
    df <- df %>%
      dplyr::mutate(
        adj_TimeSecsRem = ifelse(.data$half == 1, 1800 + .data$TimeSecsRem, .data$TimeSecsRem),
        turnover_vec_lag = dplyr::lag(.data$turnover_vec, 1),
        lag_defense_score_play = dplyr::lag(.data$defense_score_play, 1),
        play_after_turnover = ifelse(.data$turnover_vec_lag == 1 & .data$lag_defense_score_play != 1, 1, 0),
        receives_2H_kickoff = ifelse(.data$game_play_number == 1 & .data$kickoff_play == 1 &
          .data$def_pos_team == .data$home, 1,
        ifelse(.data$game_play_number == 1 & .data$kickoff_play == 1 &
          .data$def_pos_team == .data$away, 0, NA_real_)
        ),
        pos_team = ifelse(.data$offense_play == .data$home & .data$kickoff_play == 1, .data$away,
          ifelse(.data$offense_play == .data$away & .data$kickoff_play == 1, .data$home, .data$offense_play)
        ),
        def_pos_team = ifelse(.data$pos_team == .data$home, .data$away, .data$home),
        pos_team_score = ifelse(.data$kickoff_play == 1, .data$defense_score, .data$offense_score),
        def_pos_team_score = ifelse(.data$kickoff_play == 1, .data$offense_score, .data$defense_score),
        lag_pos_team = dplyr::lag(.data$pos_team, 1),
        lag_pos_team = ifelse(.data$game_play_number == 1, .data$pos_team, .data$lag_pos_team),
        lead_pos_team = dplyr::lead(.data$pos_team, 1),
        lead_pos_team2 = dplyr::lead(.data$pos_team, 2),
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
        ),
        lag_offense_play = dplyr::lag(.data$offense_play, 1),
        lag_offense_play = ifelse(.data$game_play_number == 1, .data$offense_play, .data$offense_play_lag),
        lead_offense_play = dplyr::lead(.data$offense_play, 1),
        lead_offense_play2 = dplyr::lead(.data$offense_play, 2),
        lead_kickoff_play = dplyr::lead(.data$kickoff_play, 1),
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
      ) %>%
      tidyr::fill(.data$receives_2H_kickoff) %>%
      dplyr::mutate(
        offense_receives_2H_kickoff = case_when(
          .data$offense_play == .data$home & .data$receives_2H_kickoff == 1 ~ 1,
          .data$offense_play == .data$away & .data$receives_2H_kickoff == 0 ~ 1,
          TRUE ~ 0
        ),
        EPA = .data$ep_after - .data$ep_before,
        def_EPA = -1 * .data$EPA,
        home_EPA = ifelse(.data$offense_play == .data$home, .data$EPA, -1 * .data$EPA),
        away_EPA = -1 * .data$home_EPA,
        ExpScoreDiff = .data$pos_score_diff_start + .data$ep_before,
        half = as.factor(.data$half),
        ExpScoreDiff_Time_Ratio = .data$ExpScoreDiff / (.data$adj_TimeSecsRem + 1)
      )
  }

  df <- df %>%
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
  df2 <- purrr::map_dfr(
    g_ids,
    function(x) {
      df %>%
        dplyr::filter(.data$game_id == x) %>%
        wpa_calcs_naive()
    }
  )
  return(df2)
}


#' @rdname create_wpa
#' @param df (*data.frame* required): Clean Play-by-Play data.frame with Expected Points Added (EPA) calculations
#' @keywords internal
#' @importFrom dplyr mutate lead if_else
#' @export
#'
wpa_calcs_naive <- function(df) {
  df2 <- df %>%
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
    ) %>%
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
