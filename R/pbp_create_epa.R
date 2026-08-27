#' Modular PBP -- EP model + FG model -> ep_before/after + EPA
#'
#' Refactor of `create_epa()` for the modular `.run_epa_wpa()` engine.
#' Differences from legacy:
#'   * play-type vectors sourced from `.pbp_play_types()`
#'   * fixed positional rename: `colnames(pred_df_after)[6:13] <- gsub(...)`
#'     replaced with name-based `dplyr::rename_with(starts_with("new_"))`.
#'   * one `mgcv::predict.bam()` call instead of two in `.pbp_epa_fg_probs()`.
#'
#' @keywords internal
#' @noRd
#' @importFrom stats na.omit predict
#' @importFrom nnet multinom
#' @importFrom rlang .data
#' @importFrom dplyr mutate left_join select rename filter group_by arrange ungroup lead lag rename_with all_of starts_with everything
#' @importFrom stringr str_detect regex
#' @import tidyr
.pbp_create_epa <- function(play_df, ep_model, fg_model, season = NULL) {
  #----------------- Code Description--------
  ## 1) pred_df: Use select before play model variables -> Make predictions
  ## 2) .pbp_epa_fg_probs: Update expected points predictions from before variables with FG make/miss probability weighted adjustment
  ## 3) pred_df_after: Use select after play model variables -> Make predictions
  ## 4) Join ep_before calcs df with ep_after calcs df on c("game_id","drive_id","new_id")
  ## 5) Calculate ep_before for kickoffs as if the pre-play assumption is a touchback
  ## 6) Prep variables for WPA
  ##


  clean_pbp <- play_df |>
    dplyr::mutate(down = as.numeric(.data$down)) |>
    dplyr::filter(.data$down > 0) |>
    dplyr::filter(.data$period <= 4)

  ## Taxonomy wiring -- single source of truth via .pbp_play_types()
  tt                 <- .pbp_play_types()
  turnover_play_type <- tt$turnover_play_type
  normalplay         <- tt$normalplay
  off_TD             <- tt$offense_score
  def_TD             <- tt$defense_score
  punt               <- tt$punt
  kickoff            <- tt$kickoff
  field_goal         <- tt$field_goal

  ## 1) pred_df and pred_df_after selection and prediction ----
  weights <- c(0, 3, -3, -2, -7, 2, 7)
  # get before play expected points model variables
  pred_df <- clean_pbp |>
    dplyr::select(
      "id_play",
      "drive_id",
      "game_id",
      "play_type",
      "TimeSecsRem",
      "down",
      "distance",
      "yards_to_goal",
      "log_ydstogo",
      "Under_two",
      "Goal_To_Go",
      "pos_score_diff_start"
    ) |>
    dplyr::filter(.data$down > 0) |>
    dplyr::mutate(down = as.factor(.data$down))

  # get after play expected points model variables
  pred_df_after <- clean_pbp |>
    dplyr::select(
      "id_play",
      "drive_id",
      "game_id",
      "play_type",
      "turnover",
      "new_TimeSecsRem",
      "new_down",
      "new_distance",
      "new_yardline",
      "new_log_ydstogo",
      "new_Under_two",
      "new_Goal_To_Go",
      "new_pos_score_diff_start"
    ) |>
    dplyr::mutate(new_down = as.numeric(.data$new_down)) |>
    dplyr::filter(.data$new_down > 0) |>
    dplyr::mutate(new_down = as.factor(.data$new_down))
  # rename column names for post play variables to expected points model variables
  # Fix (b) Site 1: name-based strip of "new_" prefix instead of positional [6:13]
  pred_df_after <- pred_df_after |>
    dplyr::rename_with(~ sub("^new_", "", .x), dplyr::starts_with("new_"))
  # rename yardline to yards_to_goal
  pred_df_after <- pred_df_after |>
    dplyr::rename("yards_to_goal" = "yardline")

  # ep_start - make predictions on pred_df
  # .ep_predict() returns the seven next-score probabilities already named AND
  # ordered by .EP_LEV whichever model generation is loaded, so the positional
  # `weights` vector below keeps its meaning across the artifact swap.
  ep_start <- .ep_predict(ep_model, pred_df)

  ## 2) .pbp_epa_fg_probs FG model and missed FG weighted adjustment ----
  # ep_start_update - return FG model predictions and missed FG weighted adjustment
  ep_start_update <- .pbp_epa_fg_probs(
    dat = clean_pbp,
    current_probs = ep_start,
    ep_model = ep_model,
    fg_mod = fg_model,
    season = season
  )
  # append `_before` to next score type probability columns
  # Fix (b) Site 2: name-based match instead of positional [1:7]
  prob_cols <- .EP_LEV
  colnames(ep_start_update)[match(prob_cols, colnames(ep_start_update))] <- paste0(prob_cols, "_before")
  pred_df <- cbind(pred_df, ep_start_update)
  pred_df$ep_before <- NA_real_
  # ep_before - calculate pre-play expected points
  pred_df$ep_before <- apply(ep_start_update[1:7], 1, function(row) {
    sum(row * weights)
  })
  ## 3) pred_df_after prediction ----
  # ep_after - calculate post-play expected points
  # Scored before the `_end` rename below, so pred_df_after still carries the
  # plain model column names here.
  ep_end <- .ep_predict(ep_model, pred_df_after)
  # append `_after` to next score type probability columns
  # Fix (b) Site 3: whole-frame, name-based -- left as-is (no positional indexing)
  colnames(ep_end) <- paste0(colnames(ep_end), "_after")
  pred_df_after <- cbind(pred_df_after, ep_end)
  pred_df_after$ep_after <- NA_real_
  # ep_after - calculate post-play expected points
  pred_df_after$ep_after <- apply(ep_end, 1, function(row) {
    sum(row * weights)
  })

  # Fix (b) Site 4: name-based suffix of "_end" instead of positional [6:13]
  # Columns 6:13 of pred_df_after after Site 1 rename + yardline->yards_to_goal:
  #   TimeSecsRem, down, distance, yards_to_goal, log_ydstogo, Under_two,
  #   Goal_To_Go, pos_score_diff_start
  end_cols <- c("TimeSecsRem", "down", "distance", "yards_to_goal",
                "log_ydstogo", "Under_two", "Goal_To_Go", "pos_score_diff_start")
  pred_df_after <- pred_df_after |>
    dplyr::rename_with(~ paste0(.x, "_end"), dplyr::all_of(end_cols))

  ## 5) Kickoff plays -----
  ## Calculate EP before at kickoff as what happens if it was a touchback
  ## 25 yard line in 2012 and onwards
  ## Question for the class: where is the EPA on touchbacks being set to 0?
  kickoff_ind <- (pred_df$play_type %in% kickoff)
  if (any(kickoff_ind)) {
    new_kick <- pred_df[kickoff_ind, ]
    new_kick["down"] <- as.factor(1)
    new_kick["distance"] <- 10
    new_kick["yards_to_goal"] <- 75
    new_kick["log_ydstogo"] <- log(10)
    ep_kickoffs <- .ep_predict(ep_model, new_kick)
    if (table(kickoff_ind)[2] > 1) {
      pred_df[kickoff_ind, "ep_before"] <- apply(ep_kickoffs, 1, function(row) {
        sum(row * weights)
      })
    }
    else {
      pred_df[kickoff_ind, "ep_before"] <- sum(ep_kickoffs * weights)
    }
  }

  kickoff_ind2 <- (pred_df_after$play_type %in% kickoff)
  # **Due to ESPN data quality issues, some drives end on 3rd down that are listed as turnovers
  # For turnover and punt plays make sure the ep_after is negative
  turnover_plays <- which(pred_df_after$turnover == 1 & !kickoff_ind2 & (pred_df_after$play_type %in% turnover_play_type))
  pred_df_after[turnover_plays, "ep_after"] <- -1 * pred_df_after[turnover_plays, "ep_after"]
  kickoff_turnovers <- which(pred_df_after$play_type %in% c("Kickoff Team Fumble Recovery", "Kickoff Team Fumble Recovery Touchdown"))
  pred_df_after[kickoff_turnovers, "ep_after"] <- -1 * pred_df_after[kickoff_turnovers, "ep_after"]
  punt_turnovers <- which(pred_df_after$play_type %in% punt)
  pred_df_after[punt_turnovers, "ep_after"] <- -1 * pred_df_after[punt_turnovers, "ep_after"]

  # Game end EP is 0
  pred_df[pred_df$end_of_half == 1, "ep_after"] <- 0

  ## Scoring plays from here on out
  pred_df_after[(pred_df_after$play_type %in% off_TD), "ep_after"] <- 7
  pred_df_after[(pred_df_after$play_type %in% def_TD), "ep_after"] <- -7
  pred_df_after[pred_df_after$play_type == "Defensive 2pt Conversion", "ep_after"] <- -2
  pred_df_after[pred_df_after$play_type == "Safety", "ep_after"] <- -2
  pred_df_after[pred_df_after$play_type == "Blocked Punt (Safety)", "ep_after"] <- -2
  pred_df_after[pred_df_after$play_type == "Punt (Safety)", "ep_after"] <- -2
  pred_df_after[pred_df_after$play_type == "Penalty (Safety)", "ep_after"] <- -2
  pred_df_after[pred_df_after$play_type == "Kickoff (Safety)", "ep_after"] <- -2
  pred_df_after[pred_df_after$play_type == "Field Goal Good", "ep_after"] <- 3

  pred_df[pred_df$play_type == "Defensive 2pt Conversion", "ep_before"] <- 0

  # insert before lags here
  pred_df <- pred_df |>
    dplyr::group_by(.data$game_id) |>
    dplyr::arrange(.data$id_play, .by_group = TRUE) |>
    dplyr::mutate(
      lag_ep_before3 = dplyr::lag(.data$ep_before, 3),
      lag_ep_before2 = dplyr::lag(.data$ep_before, 2),
      lag_ep_before = dplyr::lag(.data$ep_before, 1),
      lead_ep_before = dplyr::lead(.data$ep_before, 1),
      lead_ep_before2 = dplyr::lead(.data$ep_before, 2)
    ) |>
    dplyr::ungroup()

  # insert after lags here
  pred_df_after <- pred_df_after |>
    dplyr::group_by(.data$game_id) |>
    dplyr::arrange(.data$id_play, .by_group = TRUE) |>
    dplyr::mutate(
      lag_ep_after = dplyr::lag(.data$ep_after, 1),
      lag_ep_after2 = dplyr::lag(.data$ep_after, 2),
      lag_ep_after3 = dplyr::lag(.data$ep_after, 3),
      lead_ep_after = dplyr::lead(.data$ep_after, 1),
      lead_ep_after2 = dplyr::lead(.data$ep_after, 2)
    ) |>
    dplyr::ungroup()


  ## 4) Join ep_before calcs df, pred_df, with ep_after calcs df, pred_df_after. ----
  # join together multiple dataframes back together
  # to get ep_before and ep_after for plays
  pred_df <- play_df |>
    dplyr::left_join(
      pred_df_after |>
        dplyr::select(-"play_type", -"turnover"),
      by = c("game_id", "drive_id", "id_play")
    ) |>
    dplyr::left_join(
      pred_df |> select(-"play_type") |>
        dplyr::select(
          "id_play",
          "drive_id",
          "game_id",
          "No_Score_before",
          "FG_before",
          "Opp_FG_before",
          "Opp_Safety_before",
          "Opp_TD_before",
          "Safety_before",
          "TD_before",
          "ep_before",
          "fg_make_prob",
          "lag_ep_before3",
          "lag_ep_before2",
          "lag_ep_before",
          "lead_ep_before",
          "lead_ep_before2"
        ),
      by = c("game_id", "drive_id", "id_play")
    )

  pred_df <- pred_df |>
    dplyr::arrange(.data$game_id, .data$id_play) |>
    dplyr::mutate(
      ep_after = ifelse(.data$downs_turnover == 1, -1 * .data$lead_ep_before, .data$ep_after),
      ep_after = ifelse(stringr::str_detect(.data$play_text, regex("safety", ignore_case = TRUE)) &
        .data$play_type %in% c("Blocked Punt (Safety)", "Punt (Safety)", "Penalty (Safety)"),
      -2, .data$ep_after
      ),
      ep_after = ifelse(.data$kickoff_safety == 1, -2, .data$ep_after),
      ep_after = ifelse(.data$turnover_vec == 1 & is.na(.data$ep_after),
        -1 * .data$lead_ep_before,
        .data$ep_after
      ),
      ep_before = ifelse(.data$play_type == "Timeout" & !is.na(.data$lag_ep_after) &
        is.na(.data$ep_before), .data$lag_ep_after, .data$ep_before),
      ep_before = ifelse(.data$play_type == "Timeout" & is.na(.data$ep_before), .data$lag_ep_after2, .data$ep_before)
    )

  # 6) Prep WPA variables, drop transformed columns-----
  pred_df <- pred_df |>
    dplyr::mutate(
      adj_TimeSecsRem = ifelse(.data$half == 1, 1800 + .data$TimeSecsRem, .data$TimeSecsRem),
      turnover_vec_lag = dplyr::lag(.data$turnover_vec, 1),
      lag_defense_score_play = dplyr::lag(.data$defense_score_play, 1),
      play_after_turnover = ifelse(.data$turnover_vec_lag == 1 & .data$lag_defense_score_play != 1, 1, 0),
      EPA = NA_real_,
      def_EPA = NA_real_,
      home_EPA = NA_real_,
      away_EPA = NA_real_,
      EPA = ifelse(.data$scoring_play == 0 & .data$end_of_half == 1, -1 * .data$ep_before, .data$ep_after - .data$ep_before),
      def_EPA = -1 * .data$EPA,
      home_EPA = ifelse(.data$pos_team == .data$home, .data$EPA, -1 * .data$EPA),
      away_EPA = -1 * .data$home_EPA,
      home_EPA_rush = ifelse(.data$pos_team == .data$home & .data$rush == 1, .data$EPA, NA_real_),
      away_EPA_rush = ifelse(.data$pos_team == .data$away & .data$rush == 1, .data$EPA, NA_real_),
      home_EPA_pass = ifelse(.data$pos_team == .data$home & .data$pass == 1, .data$EPA, NA_real_),
      away_EPA_pass = ifelse(.data$pos_team == .data$away & .data$pass == 1, .data$EPA, NA_real_),
      total_home_EPA = cumsum(ifelse(is.na(.data$home_EPA), 0, .data$home_EPA)),
      total_away_EPA = cumsum(ifelse(is.na(.data$away_EPA), 0, .data$away_EPA)),
      total_home_EPA_rush = cumsum(ifelse(is.na(.data$home_EPA_rush), 0, .data$home_EPA_rush)),
      total_away_EPA_rush = cumsum(ifelse(is.na(.data$away_EPA_rush), 0, .data$away_EPA_rush)),
      total_home_EPA_pass = cumsum(ifelse(is.na(.data$home_EPA_pass), 0, .data$home_EPA_pass)),
      total_away_EPA_pass = cumsum(ifelse(is.na(.data$away_EPA_pass), 0, .data$away_EPA_pass)),
      net_home_EPA = cumsum(ifelse(is.na(.data$home_EPA), 0, .data$home_EPA)) -
        cumsum(ifelse(is.na(.data$away_EPA), 0, .data$away_EPA)),
      net_away_EPA = cumsum(ifelse(is.na(.data$away_EPA), 0, .data$away_EPA)) -
        cumsum(ifelse(is.na(.data$home_EPA), 0, .data$home_EPA)),
      net_home_EPA_rush = cumsum(ifelse(is.na(.data$home_EPA_rush), 0, .data$home_EPA_rush)) -
        cumsum(ifelse(is.na(.data$away_EPA_rush), 0, .data$away_EPA_rush)),
      net_home_EPA_pass = cumsum(ifelse(is.na(.data$home_EPA_pass), 0, .data$home_EPA_pass)) -
        cumsum(ifelse(is.na(.data$away_EPA_pass), 0, .data$away_EPA_pass)),
      net_away_EPA_rush = cumsum(ifelse(is.na(.data$away_EPA_rush), 0, .data$away_EPA_rush)) -
        cumsum(ifelse(is.na(.data$home_EPA_rush), 0, .data$home_EPA_rush)),
      net_away_EPA_pass = cumsum(ifelse(is.na(.data$away_EPA_pass), 0, .data$away_EPA_pass)) -
        cumsum(ifelse(is.na(.data$home_EPA_pass), 0, .data$home_EPA_pass)),
      ExpScoreDiff = .data$pos_score_diff_start + .data$ep_before,
      half = as.factor(.data$half),
      ExpScoreDiff_Time_Ratio = .data$ExpScoreDiff / (.data$adj_TimeSecsRem + 1)
    ) |>
    dplyr::select(
      -"new_TimeSecsRem",
      -"new_down",
      -"new_distance",
      -"new_yardline",
      -"new_log_ydstogo",
      -"new_Under_two",
      -"new_Goal_To_Go",
      -"new_pos_score_diff_start"
    ) |>
    dplyr::select(
      "game_id",
      "id_play",
      "drive_id",
      "home",
      "away",
      "drive_number",
      "drive_play_number",
      "game_play_number",
      "pos_team",
      "def_pos_team",
      "clock_minutes",
      "clock_seconds",
      "half",
      "period",
      "TimeSecsRem",
      "play_type",
      "play_text",
      "down",
      "distance",
      "yards_to_goal",
      "yards_gained",
      "Goal_To_Go",
      "Under_two",
      "pos_score_diff",
      "pos_score_diff_start",
      "pos_team_score",
      "def_pos_team_score",
      "ep_before",
      "ep_after",
      "EPA",
      "def_EPA",
      "pos_team_timeouts_rem_before",
      "def_pos_team_timeouts_rem_before",
      "offense_timeouts",
      "defense_timeouts",
      "down_end",
      "distance_end",
      "yards_to_goal_end",
      "TimeSecsRem_end",
      "log_ydstogo_end",
      "Goal_To_Go_end",
      "Under_two_end",
      "score_diff",
      "score_diff_start",
      "ppa",
      "drive_start_yards_to_goal",
      "drive_end_yards_to_goal",
      "drive_yards",
      "drive_scoring",
      "drive_result_detailed",
      "new_drive_pts",
      "offense_play",
      "defense_play",
      "offense_score",
      "defense_score",
      dplyr::everything()
    ) |>
    dplyr::mutate(
      middle_8 = ifelse(.data$adj_TimeSecsRem >= 1560 & .data$adj_TimeSecsRem <= 2040, TRUE, FALSE),
      rz_play = ifelse((.data$yards_to_goal <= 20), 1, 0),
      scoring_opp = ifelse((.data$yards_to_goal <= 40), 1, 0),
      stuffed_run = ifelse((.data$rush == 1 & .data$yards_gained <= 0), 1, 0),
      success =
        ifelse(.data$yards_gained >= .5 * .data$distance & .data$down == 1, 1,
          ifelse(.data$yards_gained >= .7 * .data$distance & .data$down == 2, 1,
            ifelse(.data$yards_gained >= .data$distance & .data$down == 3, 1,
              ifelse(.data$yards_gained >= .data$distance & .data$down == 4, 1, 0)
            )
          )
        ),
      success = ifelse(.data$play_type %in% turnover_play_type, 0, .data$success),
      epa_success = ifelse(.data$EPA > 0, 1, 0)
    )

  return(pred_df)
}

#' @keywords internal
#' @noRd
#' @importFrom mgcv predict.bam
#' @importFrom stringr str_detect
#' @importFrom dplyr mutate
.pbp_epa_fg_probs <- function(dat, current_probs, ep_model, fg_mod,
                              season = NULL) {
  fg_ind <- stringr::str_detect((dat$play_type), "Field Goal")
  ep_ind <- stringr::str_detect((dat$play_type), "Extra Point")
  inds <- fg_ind | ep_ind
  current_probs$fg_make_prob <- NA
  fg_dat <- dat[inds, ]
  if (nrow(fg_dat) > 0) {
    # we are setting everything after 0 seconds to have 0 probs.
    end_game_ind <- which(dat$TimeSecsRem <= 0)
    current_probs[end_game_ind, ] <- 0

    # Fix (c): drop the redundant first predict.bam() call (legacy line ~498).
    # Only the second call (below, wrapped in as.numeric()) is kept.

    missed_fg_dat <- fg_dat |>
      # Subtract 5.065401 from TimeSecs since average time for FG att:
      dplyr::mutate(
        TimeSecsRem = .data$TimeSecsRem - 5.065401,
        # Correct the yrdline100:
        yards_to_goal = 100 - (.data$yards_to_goal + 8),
        # Not GoalToGo:
        Goal_To_Go = rep(FALSE, n()),
        # Now first down:
        down = rep("1", n()),
        # 10 yards to go. `log_ydstogo` served the retired nnet formula; the
        # bundled model reads raw `distance`, which otherwise would have kept
        # the REAL play's distance and quietly contradicted the hypothetical.
        log_ydstogo = rep(log(10), n()),
        distance = rep(10, n()),
        # Create Under_TwoMinute_Warning indicator
        Under_two = ifelse(.data$TimeSecsRem < 120,
          TRUE, FALSE
        ),
        pos_score_diff_start = -1 * .data$pos_score_diff_start
      ) |> as.data.frame()

    # .ep_predict() always returns an n x 7 lev-named frame, so the old
    # single-row transpose special case is no longer needed.
    missed_fg_ep_preds <- .ep_predict(ep_model, missed_fg_dat)
    # Find the rows where TimeSecsRem became 0 or negative and
    # make all the probs equal to 0:
    end_game_i <-
      which(missed_fg_dat$TimeSecsRem <= 0)
    missed_fg_ep_preds[end_game_i, ] <- rep(
      0,
      ncol(missed_fg_ep_preds)
    )

    # Get the probability of making the field goal:
    make_fg_prob <- .fg_make_prob(fg_mod, fg_dat, season = season)
    # Multiply each value of the missed_fg_ep_preds by the 1 - make_fg_prob
    missed_fg_ep_preds <-
      missed_fg_ep_preds * (1 - make_fg_prob)

    # Now update the probabilities for the FG attempts
    # (also includes Opp_Field_Goal probability from missed_fg_ep_preds)
    current_probs[inds, "FG"] <- make_fg_prob +
      missed_fg_ep_preds[, "Opp_FG"]
    # Update the other columns based on the opposite possession:
    current_probs[inds, "TD"] <- missed_fg_ep_preds[, "Opp_TD"]
    current_probs[inds, "Opp_FG"] <- missed_fg_ep_preds[, "FG"]
    current_probs[inds, "Opp_TD"] <- missed_fg_ep_preds[, "TD"]
    current_probs[inds, "Safety"] <- missed_fg_ep_preds[, "Opp_Safety"]
    current_probs[inds, "Opp_Safety"] <- missed_fg_ep_preds[, "Safety"]
    current_probs[inds, "No_Score"] <- missed_fg_ep_preds[, "No_Score"]
    current_probs[inds, "fg_make_prob"] <- make_fg_prob
  }
  return(current_probs)
}
