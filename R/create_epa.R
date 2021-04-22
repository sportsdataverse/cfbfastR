#' @name create_epa
#' @aliases create_epa epa_fg_probs
#' @title Create EPA
#' @description Adds Expected Points calculations to Play-by-Play data.frame
#'
#' @param clean_pbp_dat (\emph{data.frame} required): Clean PBP as input from [cfbd_pbp_data()]
#' @param ep_model (\emph{model} default ```cfbfastR```'s `ep_model`): Expected Points (EP) Model
#' @param fg_model (\emph{model} default ```cfbfastR```'s `fg_model`): Field Goal (FG) Model
#' @details Code Description
#' \describe{
#'   \item{1. `pred_df`:}{Use select before play model variables -> Make predictions.}
#'   \item{2. `epa_fg_probs`:}{Update expected points predictions from before variables with FG make/miss probability weighted adjustment.}
#'   \item{3. `pred_df_after`:}{Use select after play model variables -> Make predictions.}
#'   \item{4. `join_ep`:}{Join `ep_before` calcs `pred_df` with `ep_after` calcs `pred_df_after` on c("game_id","drive_id","new_id").}
#'   \item{5. `kickoffs`:}{Calculate ep_before for kickoffs as if the pre-play assumption is a touchback.}
#'   \item{6. `wpa_prep`:}{Prep variables for WPA.}
#' }
#' @keywords internal
#' @importFrom stats na.omit
#' @importFrom stats predict
#' @importFrom nnet multinom
#' @importFrom rlang .data
#' @importFrom dplyr mutate left_join select rename filter group_by arrange ungroup lead lag
#' @importFrom stringr str_detect
#' @import tidyr
#' @export
#'

create_epa <- function(play_df,
                       ep_model,
                       fg_model) {
  #----------------- Code Description--------
  ## 1) pred_df: Use select before play model variables -> Make predictions
  ## 2) epa_fg_probs: Update expected points predictions from before variables with FG make/miss probability weighted adjustment
  ## 3) pred_df_after: Use select after play model variables -> Make predictions
  ## 4) Join ep_before calcs df with ep_after calcs df on c("game_id","drive_id","new_id")
  ## 5) Calculate ep_before for kickoffs as if the pre-play assumption is a touchback
  ## 6) Prep variables for WPA
  ##
  
  
  clean_pbp <- play_df %>%
    dplyr::mutate(down = as.numeric(.data$down)) %>%
    dplyr::filter(.data$down > 0) %>%
    dplyr::filter(.data$period <= 4)

  ## 1) pred_df and pred_df_after selection and prediction ----
  weights <- c(0, 3, -3, -2, -7, 2, 7)
  # get before play expected points model variables
  pred_df <- clean_pbp %>%
    dplyr::select(
      .data$id_play,
      .data$drive_id,
      .data$game_id,
      .data$play_type,
      .data$TimeSecsRem,
      .data$down,
      .data$distance,
      .data$yards_to_goal,
      .data$log_ydstogo,
      .data$Under_two,
      .data$Goal_To_Go,
      .data$pos_score_diff_start
    ) %>%
    dplyr::filter(.data$down > 0) %>%
    dplyr::mutate(down = as.factor(.data$down))

  # get after play expected points model variables
  pred_df_after <- clean_pbp %>%
    dplyr::select(
      .data$id_play,
      .data$drive_id,
      .data$game_id,
      .data$play_type,
      .data$turnover,
      .data$new_TimeSecsRem,
      .data$new_down,
      .data$new_distance,
      .data$new_yardline,
      .data$new_log_ydstogo,
      .data$new_Under_two,
      .data$new_Goal_To_Go,
      .data$new_pos_score_diff_start
    ) %>%
    dplyr::mutate(new_down = as.numeric(.data$new_down)) %>%
    dplyr::filter(.data$new_down > 0) %>%
    dplyr::mutate(new_down = as.factor(.data$new_down))
  # rename column names for post play variables to expected points model variables
  colnames(pred_df_after)[6:13] <- gsub("new_", "", colnames(pred_df_after)[6:13])
  # rename yardline to yards_to_goal
  pred_df_after <- pred_df_after %>%
    dplyr::rename("yards_to_goal" = "yardline")

  # ep_start - make predictions on pred_df
  ep_start <- as.data.frame(predict(ep_model, pred_df, type = "prob"))
  # ep_start - rename next score type probability columns to ep_model$lev
  colnames(ep_start) <- ep_model$lev

  ## 2) epa_fg_probs FG model and missed FG weighted adjustment ----
  # ep_start_update - return FG model predictions and missed FG weighted adjustment
  ep_start_update <- epa_fg_probs(
    dat = clean_pbp,
    current_probs = ep_start,
    ep_model = ep_model,
    fg_mod = fg_model
  )
  # append `_before` to next score type probability columns
  colnames(ep_start_update)[1:7] <- paste0(colnames(ep_start_update)[1:7], "_before")
  pred_df <- cbind(pred_df, ep_start_update)
  pred_df$ep_before <- NA_real_
  # ep_before - calculate pre-play expected points
  pred_df$ep_before <- apply(ep_start_update[1:7], 1, function(row) {
    sum(row * weights)
  })
  ## 3) pred_df_after prediction ----
  # ep_after - calculate post-play expected points
  ep_end <- predict(ep_model, pred_df_after, type = "prob")
  # ep_end - rename next score type probability columns to ep_model$lev
  colnames(ep_end) <- ep_model$lev
  # append `_after` to next score type probability columns
  colnames(ep_end) <- paste0(colnames(ep_end), "_after")
  pred_df_after <- cbind(pred_df_after, ep_end)
  pred_df_after$ep_after <- NA_real_
  # ep_after - calculate post-play expected points
  pred_df_after$ep_after <- apply(ep_end, 1, function(row) {
    sum(row * weights)
  })

  colnames(pred_df_after)[6:13] <- paste0(colnames(pred_df_after)[6:13], "_end")

  # constant vectors to be used again
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
    "Interception Return",
    "Interception Return Touchdown",
    "Pass Interception Return",
    "Pass Interception Return Touchdown",
    "Uncategorized Touchdown"
  )
  normalplay <- c(
    "Rush",
    "Pass",
    "Pass Reception",
    "Pass Incompletion",
    "Pass Completion",
    "Sack",
    "Fumble Recovery (Own)"
  )
  off_TD <- c(
    "Passing Touchdown",
    "Rushing Touchdown",
    "Field Goal Good",
    "Pass Reception Touchdown",
    "Fumble Recovery (Own) Touchdown",
    "Kickoff Return Touchdown",
    "Punt Touchdown",
    "Punt Team Fumble Recovery Touchdown"
  )
  def_TD <- c(
    "Defensive 2pt Conversion",
    "Safety",
    "Blocked Field Goal Touchdown",
    "Missed Field Goal Return Touchdown",
    "Fumble Return Touchdown",
    "Fumble Recovery (Opponent) Touchdown",
    "Sack Touchdown",
    "Blocked Punt Touchdown",
    "Punt Return Touchdown",
    "Kickoff Touchdown",
    "Kickoff Team Fumble Recovery Touchdown",
    "Interception Return Touchdown",
    "Pass Interception Return Touchdown",
    "Uncategorized Touchdown"
  )
  punt <- c(
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
  field_goal <- c(
    "Field Goal Good",
    "Blocked Field Goal",
    "Field Goal Missed",
    "Missed Field Goal Return",
    "Blocked Field Goal Touchdown",
    "Missed Field Goal Return Touchdown"
  )

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
    ep_kickoffs <- as.data.frame(predict(ep_model, new_kick, type = "prob"))
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

  # insert begore lags here
  pred_df <- pred_df %>%
    dplyr::group_by(.data$game_id) %>%
    dplyr::arrange(.data$id_play, .by_group = TRUE) %>%
    dplyr::mutate(
      lag_ep_before3 = dplyr::lag(.data$ep_before, 3),
      lag_ep_before2 = dplyr::lag(.data$ep_before, 2),
      lag_ep_before = dplyr::lag(.data$ep_before, 1),
      lead_ep_before = dplyr::lead(.data$ep_before, 1),
      lead_ep_before2 = dplyr::lead(.data$ep_before, 2)
    ) %>%
    dplyr::ungroup()

  # insert after lags here
  pred_df_after <- pred_df_after %>%
    dplyr::group_by(.data$game_id) %>%
    dplyr::arrange(.data$id_play, .by_group = TRUE) %>%
    dplyr::mutate(
      lag_ep_after = dplyr::lag(.data$ep_after, 1),
      lag_ep_after2 = dplyr::lag(.data$ep_after, 2),
      lag_ep_after3 = dplyr::lag(.data$ep_after, 3),
      lead_ep_after = dplyr::lead(.data$ep_after, 1),
      lead_ep_after2 = dplyr::lead(.data$ep_after, 2)
    ) %>%
    dplyr::ungroup()


  ## 4) Join ep_before calcs df, pred_df, with ep_after calcs df, pred_df_after. ----
  # join together multiple dataframes back together
  # to get ep_before and ep_after for plays
  pred_df <- play_df %>%
    dplyr::left_join(
      pred_df_after %>%
        dplyr::select(-.data$play_type, -.data$turnover),
      by = c("game_id", "drive_id", "id_play")
    ) %>%
    dplyr::left_join(
      pred_df %>% select(-.data$play_type) %>%
        dplyr::select(
          .data$id_play, .data$drive_id, .data$game_id,
          .data$No_Score_before, .data$FG_before,
          .data$Opp_FG_before, .data$Opp_Safety_before,
          .data$Opp_TD_before, .data$Safety_before,
          .data$TD_before, .data$ep_before, .data$fg_make_prob,
          .data$lag_ep_before3, .data$lag_ep_before2,
          .data$lag_ep_before, .data$lead_ep_before,
          .data$lead_ep_before2
        ),
      by = c("game_id", "drive_id", "id_play")
    )

  pred_df <- pred_df %>%
    dplyr::arrange(.data$game_id, .data$id_play) %>%
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
  pred_df <- pred_df %>%
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
    ) %>%
    dplyr::select(
      -.data$new_TimeSecsRem,
      -.data$new_down,
      -.data$new_distance,
      -.data$new_yardline,
      -.data$new_log_ydstogo,
      -.data$new_Under_two,
      -.data$new_Goal_To_Go,
      -.data$new_pos_score_diff_start
    ) %>%
    dplyr::select(
      .data$game_id,
      .data$id_play,
      .data$drive_id,
      .data$home,
      .data$away,
      .data$drive_number,
      .data$drive_play_number,
      .data$game_play_number,
      .data$pos_team,
      .data$def_pos_team,
      .data$clock.minutes,
      .data$clock.seconds,
      .data$half,
      .data$period,
      .data$TimeSecsRem,
      .data$play_type,
      .data$play_text,
      .data$down,
      .data$distance,
      .data$yards_to_goal,
      .data$yards_gained,
      .data$Goal_To_Go,
      .data$Under_two,
      .data$pos_score_diff,
      .data$pos_score_diff_start,
      .data$pos_team_score,
      .data$def_pos_team_score,
      .data$ep_before,
      .data$ep_after,
      .data$EPA,
      .data$def_EPA,
      .data$pos_team_timeouts_rem_before,
      .data$def_pos_team_timeouts_rem_before,
      .data$offense_timeouts,
      .data$defense_timeouts,
      .data$down_end,
      .data$distance_end,
      .data$yards_to_goal_end,
      .data$TimeSecsRem_end,
      .data$log_ydstogo_end,
      .data$Goal_To_Go_end,
      .data$Under_two_end,
      .data$score_diff,
      .data$score_diff_start,
      .data$ppa,
      .data$drive_start_yards_to_goal,
      .data$drive_end_yards_to_goal,
      .data$drive_yards,
      .data$drive_scoring,
      .data$drive_result_detailed,
      .data$new_drive_pts,
      .data$offense_play,
      .data$defense_play,
      .data$offense_score,
      .data$defense_score,
      dplyr::everything()
    ) %>%
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

#' @rdname create_epa
#' @param df (__data.frame__ required): Clean Play-By-Play data.frame as can be pulled from [clean_pbp_dat()]
#' @param current_probs (__data.frame__ required): Expected Points (EP) model raw probability outputs from initial prediction
#' @param ep_model (__model__, default ```cfbfastR```'s `ep_model`): FG Model to be used for prediction on field goal (FG) attempts in Play-by-Play data.frame
#' @param fg_mod (__model__, default ```cfbfastR```'s `fg_model`): FG Model to be used for prediction on field goal (FG) attempts in Play-by-Play data.frame
#'
#' @keywords internal
#' @importFrom mgcv predict.bam
#' @importFrom stringr str_detect
#' @importFrom dplyr mutate
#' @export

epa_fg_probs <- function(dat, current_probs, ep_model, fg_mod) {
  fg_ind <- stringr::str_detect((dat$play_type), "Field Goal")
  ep_ind <- stringr::str_detect((dat$play_type), "Extra Point")
  inds <- fg_ind | ep_ind
  current_probs$fg_make_prob <- NA
  fg_dat <- dat[inds, ]
  if (nrow(fg_dat) > 0) {
    # we are setting everything after 0 seconds to have 0 probs.
    end_game_ind <- which(dat$TimeSecsRem <= 0)
    current_probs[end_game_ind, ] <- 0

    make_fg_prob <- mgcv::predict.bam(fg_mod, newdata = fg_dat, type = "response")

    missed_fg_dat <- fg_dat %>%
      # Subtract 5.065401 from TimeSecs since average time for FG att:
      dplyr::mutate(
        TimeSecsRem = .data$TimeSecsRem - 5.065401,
        # Correct the yrdline100:
        yards_to_goal = 100 - (.data$yards_to_goal + 8),
        # Not GoalToGo:
        Goal_To_Go = rep(FALSE, n()),
        # Now first down:
        down = rep("1", n()),
        # 10 yards to go
        log_ydstogo = rep(log(10), n()),
        # Create Under_TwoMinute_Warning indicator
        Under_two = ifelse(.data$TimeSecsRem < 120,
          TRUE, FALSE
        ),
        pos_score_diff_start = -1 * .data$pos_score_diff_start
      ) %>% as.data.frame()

    missed_fg_ep_preds <- ep_model %>%
      predict(newdata = missed_fg_dat, type = "probs") %>%
      as.data.frame()

    if (dim(missed_fg_ep_preds)[2] == 1) {
      missed_fg_ep_preds <- t(missed_fg_ep_preds)
    }


    colnames(missed_fg_ep_preds) <- ep_model$lev
    # Find the rows where TimeSecsRem became 0 or negative and
    # make all the probs equal to 0:
    end_game_i <-
      which(missed_fg_dat$TimeSecsRem <= 0)
    missed_fg_ep_preds[end_game_i, ] <- rep(
      0,
      ncol(missed_fg_ep_preds)
    )

    # Get the probability of making the field goal:
    make_fg_prob <- as.numeric(mgcv::predict.bam(fg_mod,
      newdata = fg_dat,
      type = "response"
    ))
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
