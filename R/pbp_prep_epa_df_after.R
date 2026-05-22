#' Modular PBP -- post-play model inputs (new_down/distance/yardline)
#'
#' Refactor of `prep_epa_df_after()` for the modular `.run_epa_wpa()` engine.
#' Differences from legacy:
#'   * play-type vectors sourced from `.pbp_play_types()`
#'   * bounds-checked indexing of `dat$yard_line[na_yd_line + 1]` and
#'     `dat$distance[neg_distance + 1]` -- legacy silently NA's the last row.
#'
#' @param dat Single-game play data frame (post-`.pbp_add_yardage()` and
#'   `.pbp_add_player_cols()`).
#' @return `dat` with the post-play model inputs and series columns.
#' @keywords internal
#' @noRd
#' @importFrom rlang .data
#' @importFrom dplyr mutate arrange group_by case_when mutate_at ungroup n
#'   lag lead if_else
#' @importFrom tidyr replace_na
#' @importFrom magrittr %>%
.pbp_prep_epa_df_after <- function(dat) {
  tt                 <- .pbp_play_types()
  turnover_play_type <- tt$turnover_play_type
  turnover_vec       <- tt$turnover
  normalplay         <- tt$normalplay
  penalty            <- tt$penalty
  offense_score_vec  <- tt$offense_score
  defense_score_vec  <- tt$defense_score
  kickoff            <- tt$kickoff

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

  dat <- dat %>%
    dplyr::ungroup() %>%
    dplyr::group_by(.data$game_id, .data$half) %>%
    dplyr::arrange(.data$id_play, .by_group = TRUE) %>%
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
    dat <- dat %>%
      dplyr::mutate(
        new_log_ydstogo = dplyr::if_else(.data$new_distance == 0 |
                                           is.nan(log(.data$new_distance)) |
                                           is.na(.data$new_distance),
                                         log(1), log(.data$new_distance)
        )
      )
  )
  dat <- dat %>%
    dplyr::mutate_at(c("new_TimeSecsRem"), ~ tidyr::replace_na(., 0)) %>%
    dplyr::group_by(.data$game_id, .data$half, .data$drive_id) %>%
    dplyr::arrange(.data$id_play, .by_group = TRUE) %>%
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
    ) %>%
    dplyr::ungroup() %>%
    dplyr::arrange(.data$new_id, .by_group = TRUE) %>%
    # dplyr::select(-.data$play, -.data$half_play, -.data$drive_play) %>%
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
  dat <- dat %>%
    dplyr::mutate(
      new_yardline = dplyr::if_else(is.na(.data$new_yardline) &
                                      .data$play_type %in% c("Field Goal Missed", "Blocked Field Goal"),
                                    100 - (.data$yards_to_goal - 9),
                                    .data$new_yardline
      )
    )

  #--General weird plays that don't have an easy fix----
  na_yd_line <- which(is.na(dat$new_yardline) | dat$new_yardline >= 100)
  if (length(na_yd_line) > 0) {
    nxt <- pmin(na_yd_line + 1L, nrow(dat))
    dat$new_yardline[na_yd_line] <- dat$yard_line[nxt]
  }
  neg_distance <- which(dat$new_distance < 0)
  if (length(neg_distance) > 0) {
    nxt <- pmin(neg_distance + 1L, nrow(dat))
    dat$new_distance[neg_distance]    <- dat$distance[nxt]
    dat$new_log_ydstogo[neg_distance] <- log(dat$new_distance[neg_distance])
  }

  #--Missing yd_line Plays--------------------------
  missing_yd_line <- dat$new_yardline == 0
  dat$new_yardline[missing_yd_line] <- 100
  dat$new_log_ydstogo[missing_yd_line] <- log(100)
  dat$new_down[missing_yd_line] <- 1
  dat$missing_yard_flag <- FALSE
  dat$missing_yard_flag[missing_yd_line] <- TRUE

  dat <- dat %>%
    dplyr::arrange(.data$id_play) %>%
    dplyr::mutate(
      new_yardline = ifelse(.data$end_of_half == 1 & is.na(.data$new_yardline), 100, .data$new_yardline),
      new_id = gsub(pattern = unique(.data$game_id), "", x = .data$new_id),
      new_id = as.numeric(.data$new_id)
    )



  return(dat)
}
