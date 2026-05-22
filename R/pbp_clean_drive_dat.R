#' Modular PBP -- drive boundaries, drive_result_detailed, new_drive_pts
#'
#' Refactor of `clean_drive_dat()` for the modular `.run_epa_wpa()` engine.
#' Behavior-equivalent. The legacy function has no local play-type vectors
#' to centralize and no listed defects to fix; this is a structural copy
#' so the modular path doesn't reach into the legacy file.
#'
#' @param play_df Single-game play data frame (post-`.pbp_clean_pbp_dat()`).
#' @return `play_df` with drive-numbering and drive-result columns.
#' @keywords internal
#' @noRd
#' @importFrom rlang .data
#' @importFrom dplyr group_by arrange mutate ungroup case_when select lead lag
#' @importFrom stringr str_detect
#' @importFrom tidyr fill replace_na
#' @importFrom magrittr %>%
.pbp_clean_drive_dat <- function(play_df) {
  play_df <- play_df %>%
    dplyr::group_by(.data$game_id, .data$half) %>%
    dplyr::arrange(.data$game_id, .data$half, .data$period,
                   -.data$TimeSecsRem, -.data$lead_TimeSecsRem, .data$id_play,
                   .by_group = TRUE
    ) %>%
    dplyr::mutate(
      #---- Define Lag Pos Team/Kickoff Play/Punt/Scoring/Turnover/Downs Turnover----
      lag_change_of_poss = dplyr::lag(.data$change_of_poss, 1),
      lag_change_of_poss2 = dplyr::lag(.data$change_of_poss, 2),
      lag_change_of_poss3 = dplyr::lag(.data$change_of_poss, 3),
      lag_change_of_poss = ifelse(.data$half_event_number %in% c(1), 0, .data$lag_change_of_poss),
      lag_change_of_poss2 = ifelse(.data$half_event_number %in% c(1, 2), 0, .data$lag_change_of_poss2),
      lag_change_of_poss3 = ifelse(.data$half_event_number %in% c(1, 2, 3), 0, .data$lag_change_of_poss3),
      lag_change_of_pos_team = dplyr::lag(.data$change_of_pos_team, 1),
      lag_change_of_pos_team2 = dplyr::lag(.data$change_of_pos_team, 2),
      lag_change_of_pos_team3 = dplyr::lag(.data$change_of_pos_team, 3),
      lag_change_of_pos_team = ifelse(.data$half_event_number %in% c(1), 0, .data$lag_change_of_pos_team),
      lag_change_of_pos_team2 = ifelse(.data$half_event_number %in% c(1, 2), 0, .data$lag_change_of_pos_team2),
      lag_change_of_pos_team3 = ifelse(.data$half_event_number %in% c(1, 2, 3), 0, .data$lag_change_of_pos_team3),
      lag_kickoff_play = dplyr::lag(.data$kickoff_play, 1),
      lag_kickoff_play2 = dplyr::lag(.data$kickoff_play, 2),
      lag_kickoff_play3 = dplyr::lag(.data$kickoff_play, 3),
      lag_kickoff_play = ifelse(.data$half_event_number %in% c(1), 0, .data$lag_kickoff_play),
      lag_kickoff_play2 = ifelse(.data$half_event_number %in% c(1, 2), 0, .data$lag_kickoff_play2),
      lag_kickoff_play3 = ifelse(.data$half_event_number %in% c(1, 2, 3), 0, .data$lag_kickoff_play3),
      lag_punt = dplyr::lag(.data$punt, 1),
      lag_punt2 = dplyr::lag(.data$punt, 2),
      lag_punt3 = dplyr::lag(.data$punt, 3),
      lag_punt = ifelse(.data$half_event_number %in% c(1), 0, .data$lag_punt),
      lag_punt2 = ifelse(.data$half_event_number %in% c(1, 2), 0, .data$lag_punt2),
      lag_punt3 = ifelse(.data$half_event_number %in% c(1, 2, 3), 0, .data$lag_punt3),
      lag_scoring_play = dplyr::lag(.data$scoring_play, 1),
      lag_scoring_play2 = dplyr::lag(.data$scoring_play, 2),
      lag_scoring_play3 = dplyr::lag(.data$scoring_play, 3),
      lag_scoring_play = ifelse(.data$half_play_number %in% c(1), 0, .data$lag_scoring_play),
      lag_scoring_play2 = ifelse(.data$half_play_number %in% c(1, 2), 0, .data$lag_scoring_play2),
      lag_scoring_play3 = ifelse(.data$half_play_number %in% c(1, 2, 3), 0, .data$lag_scoring_play3),
      lag_turnover_vec = dplyr::lag(.data$turnover_vec, 1),
      lag_turnover_vec2 = dplyr::lag(.data$turnover_vec, 2),
      lag_turnover_vec3 = dplyr::lag(.data$turnover_vec, 3),
      lag_turnover_vec = ifelse(.data$half_event_number %in% c(1), 0, .data$lag_turnover_vec),
      lag_turnover_vec2 = ifelse(.data$half_event_number %in% c(1, 2), 0, .data$lag_turnover_vec2),
      lag_turnover_vec3 = ifelse(.data$half_event_number %in% c(1, 2, 3), 0, .data$lag_turnover_vec3),
      lag_downs_turnover = dplyr::lag(.data$downs_turnover, 1),
      lag_downs_turnover2 = dplyr::lag(.data$downs_turnover, 2),
      lag_downs_turnover3 = dplyr::lag(.data$downs_turnover, 3),
      lag_downs_turnover = ifelse(.data$half_event_number %in% c(1), 0, .data$lag_downs_turnover),
      lag_downs_turnover2 = ifelse(.data$half_event_number %in% c(1, 2), 0, .data$lag_downs_turnover2),
      lag_downs_turnover3 = ifelse(.data$half_event_number %in% c(1, 2, 3), 0, .data$lag_downs_turnover3),
      # drive_numbers = ifelse(.data$half_play_number == 1 & .data$play_type != "Timeout", 1,
      #                   ifelse((.data$lag_change_of_pos_team == 1 &
      #                             !(.data$lag_play_type %in% c("Timeout","End Period")) &
      #                             (.data$lag_punt == 1 | .data$lag_downs_turnover == 1 | .data$lag_turnover_vec == 1)) |
      #                            (.data$lag_change_of_pos_team2 == 1 & (.data$lag_play_type %in% c("Timeout","End Period")) &
      #                                  !(.data$lag_play_type2 %in% c("Timeout","End Period")) &
      #                                  (.data$lag_punt2 == 1 | .data$lag_downs_turnover2 == 1 | .data$lag_turnover_vec2 == 1))  , 1,
      #                               ifelse((.data$lag_scoring_play == 1 & .data$kickoff_play == 1 &
      #                                        !(.data$lag_play_type %in% c("Timeout","End Period")))|
      #                                      (.data$lag_scoring_play2 == 1 & .data$kickoff_play == 1 &
      #                                        (.data$lag_play_type %in% c("Timeout","End Period")) &
      #                                        !(.data$lag_play_type2 %in% c("Timeout","End Period")) ) , 1, 0))),
      drive_numbers = dplyr::case_when(
        #---- Drive Definition ----
        # 1) start of half plays start drives
        .data$half_event_number == 1 ~ 1,
        # 2-L.I) start by change of pos_team
        !(.data$lag_play_type %in% c("Timeout", "End Period")) & #    condition: has play event 1 row prior
          .data$lag_change_of_pos_team == 1 &
          (.data$lag_punt == 1 | .data$lag_downs_turnover == 1 | .data$lag_turnover_vec == 1) ~ 1,
        # 2-L.II) start by change of pos_team with 1 non-play event in between
        (.data$lag_play_type %in% c("Timeout", "End Period")) & #     condition: has non-play event 1 row prior, looks 2 rows back
          .data$lag_change_of_pos_team2 == 1 &
          !(.data$lag_play_type2 %in% c("Timeout", "End Period")) &
          (.data$lag_punt2 == 1 | .data$lag_downs_turnover2 == 1 | .data$lag_turnover_vec2 == 1) ~ 1,
        # 3-L.I) start by opponent scoring play
        .data$kickoff_play == 1 ~ 1,
        # 3-L.II) start by opponent scoring play
        !(.data$lag_play_type %in% c("Timeout", "End Period")) & #    condition: has play event 1 row prior
          .data$lag_scoring_play == 1 & .data$kickoff_play == 1 ~ 1,
        # 3-L.III) start by opponent scoring play with 1 non-play event in between
        (.data$lag_play_type %in% c("Timeout", "End Period")) & #     condition: has non-play event 1 row prior, looks 2 rows back
          !(.data$lag_play_type2 %in% c("Timeout", "End Period")) &
          .data$lag_scoring_play2 == 1 & .data$kickoff_play == 1 ~ 1,
        TRUE ~ 0
      ),
      number_of_drives = cumsum(.data$drive_numbers),
      pts_scored = dplyr::case_when(
        .data$play_type == "Blocked Field Goal Touchdown" ~ -7,
        .data$play_type == "Blocked Punt (Safety)" & .data$safety == 1 ~ -2,
        .data$play_type == "Punt (Safety)" & .data$safety == 1 ~ -2,
        .data$play_type == "Blocked Punt" & .data$safety == 1 ~ -2,
        .data$play_type == "Blocked Punt Touchdown" ~ -7,
        .data$play_type == "Missed Field Goal Return Touchdown" ~ -7,
        .data$play_type == "Fumble Recovery (Opponent) Touchdown" ~ -7,
        .data$play_type == "Fumble Return Touchdown" ~ -7,
        .data$play_type == "Interception Return Touchdown" ~ -7,
        .data$play_type == "Pass Interception Return Touchdown" ~ -7,
        .data$play_type == "Punt Touchdown" ~ 7,
        .data$play_type == "Punt Team Fumble Recovery Touchdown" ~ 7,
        .data$play_type == "Punt Return Touchdown" ~ -7,
        .data$play_type == "Sack Touchdown" ~ -7,
        .data$play_type == "Uncategorized Touchdown" ~ 7,
        .data$play_type == "Defensive 2pt Conversion" ~ -2,
        .data$play_type == "Safety" ~ -2,
        .data$play_type == "Penalty (Safety)" ~ -2,
        .data$play_type == "Passing Touchdown" ~ 7,
        .data$play_type == "Rushing Touchdown" ~ 7,
        .data$play_type == "Kickoff (Safety)" & .data$kickoff_safety == 1 ~ 2,
        .data$play_type == "Kickoff Return Touchdown" ~ 7,
        .data$play_type == "Kickoff Touchdown" ~ -7,
        .data$play_type == "Kickoff Tean Fumble Recovery Touchdown" ~ -7,
        .data$play_type == "Field Goal Good" ~ 3,
        .data$play_type == "Pass Reception Touchdown" ~ 7,
        .data$play_type == "Fumble Recovery (Own) Touchdown" ~ 7,
        TRUE ~ 0
      ),
      drive_result_detailed = dplyr::case_when(
        .data$downs_turnover == 1 ~ "Downs Turnover",
        .data$play_type == "Punt" ~ "Punt",
        .data$play_type == "Punt (Safety)" & .data$safety == 1 ~ "Safety",
        .data$play_type == "Blocked Punt (Safety)" & .data$safety == 1 ~ "Safety",
        .data$play_type == "Blocked Punt" & .data$safety == 1 ~ "Safety",
        .data$play_type == "Blocked Punt" ~ "Blocked Punt",
        .data$play_type == "Blocked Punt Touchdown" ~ "Blocked Punt Touchdown",
        .data$play_type == "Punt Touchdown" ~ "Punt Touchdown",
        .data$play_type == "Punt Team Fumble Recovery Touchdown" ~ "Punt Team Fumble Recovery Touchdown",
        .data$play_type == "Punt Return Touchdown" ~ "Punt Return Touchdown",
        .data$play_type == "Fumble Recovery (Opponent) Touchdown" ~ "Fumble Recovery (Opponent) Touchdown",
        .data$play_type == "Fumble Return Touchdown" ~ "Fumble Return Touchdown",
        .data$play_type == "Fumble Recovery (Opponent)" ~ "Fumble",
        .data$play_type == "Fumble Recovery (Own) Touchdown" ~ "Fumble Recovery (Own) Touchdown",
        .data$play_type == "Interception Return Touchdown" ~ "Interception Return Touchdown",
        .data$play_type == "Interception Return" ~ "Interception Return",
        .data$play_type == "Sack Touchdown" ~ "Sack Touchdown",
        .data$play_type == "Safety" & .data$kickoff_play == 0 ~ "Safety",
        .data$play_type == "Kickoff (Safety)" & .data$kickoff_safety == 1 ~ "Kickoff Safety",
        .data$play_type == "Kickoff" & .data$kickoff_safety == 1 ~ "Kickoff Safety",
        .data$play_type == "Kickoff Return Touchdown" ~ "Kickoff Return Touchdown",
        .data$play_type == "Kickoff Touchdown" ~ "Kickoff Touchdown",
        .data$play_type == "Kickoff Team Fumble Recovery" ~ "Kickoff Team Fumble Recovery",
        .data$play_type == "Kickoff Team Fumble Recovery Touchdown" ~ "Kickoff Team Fumble Recovery Touchdown",
        .data$play_type == "Penalty (Safety)" ~ "Safety",
        .data$play_type == "Passing Touchdown" ~ "Passing Touchdown",
        .data$play_type == "Pass Reception Touchdown" ~ "Passing Touchdown",
        .data$play_type == "Rushing Touchdown" ~ "Rushing Touchdown",
        .data$play_type == "Field Goal Good" ~ "Field Goal Good",
        .data$play_type == "Field Goal Missed" ~ "Field Goal Missed",
        .data$play_type == "Missed Field Goal Return" ~ "Missed Field Goal Return",
        .data$play_type == "Blocked Field Goal Touchdown" ~ "Blocked Field Goal Touchdown",
        .data$play_type == "Missed Field Goal Return Touchdown" ~ "Missed Field Goal Return Touchdown",
        .data$play_type == "Blocked Field Goal" ~ "Blocked Field Goal",
        .data$play_type == "Uncategorized Touchdown" ~ "Uncategorized Touchdown",
        .data$play_type == "End of Half" ~ "End Half",
        .data$play_type == "End of Game" ~ "End Game",
        .data$scoring_play == 0 & (.data$lead_TimeSecsRem == 0 | is.na(.data$lead_TimeSecsRem)) &
          period %in% c(2, 4) ~ "End Half",
        TRUE ~ NA_character_
      ),
      drive_result_detailed_flag = .data$drive_result_detailed,
      drive_result2 = dplyr::case_when(
        .data$downs_turnover == 1 ~ "DOWNS",
        .data$play_type == "Punt" ~ "PUNT",
        .data$play_type == "Punt (Safety)" ~ "SAFETY",
        .data$play_type == "Blocked Punt (Safety)" & .data$safety == 1 ~ "SAFETY",
        .data$play_type == "Blocked Punt" & .data$safety == 1 ~ "SAFETY",
        .data$play_type == "Blocked Punt" ~ "BLOCKED PUNT",
        .data$play_type == "Blocked Punt Touchdown" ~ "BLOCKED PUNT TD",
        .data$play_type == "Punt Touchdown" ~ "PUNT TEAM FUMBLE RECOVERY TD",
        .data$play_type == "Punt Team Fumble Recovery Touchdown" ~ "PUNT TEAM FUMBLE RECOVERY TD",
        .data$play_type == "Punt Return Touchdown" ~ "PUNT RETURN TD",
        .data$play_type == "Fumble Recovery (Opponent) Touchdown" ~ "FUMBLE RETURN TD",
        .data$play_type == "Fumble Return Touchdown" ~ "FUMBLE RETURN TD",
        .data$play_type == "Fumble Recovery (Opponent)" ~ "FUMBLE",
        .data$play_type == "Fumble Recovery (Own) Touchdown" ~ "FUMBLE OWN TD",
        .data$play_type == "Interception Return Touchdown" ~ "INT TD",
        .data$play_type == "Interception Return" ~ "INT",
        .data$play_type == "Sack Touchdown" ~ "SACK TD",
        .data$play_type == "Safety" & .data$kickoff_play == 0 ~ "SAFETY",
        .data$play_type == "Kickoff (Safety)" & .data$kickoff_safety == 1 ~ "KICKOFF SAFETY",
        .data$play_type == "Kickoff" & .data$kickoff_safety == 1 ~ "KICKOFF SAFETY",
        .data$play_type == "Kickoff Return Touchdown" ~ "KICKOFF RETURN TD",
        .data$play_type == "Kickoff Touchdown" ~ "KICKOFF TEAM FUMBLE RECOVERY TD",
        .data$play_type == "Kickoff Team Fumble Recovery Touchdown" ~ "KICKOFF TEAM FUMBLE RECOVERY TD",
        .data$play_type == "Penalty (Safety)" ~ "SAFETY",
        .data$play_type == "Passing Touchdown" ~ "TD",
        .data$play_type == "Pass Reception Touchdown" ~ "TD",
        .data$play_type == "Rushing Touchdown" ~ "TD",
        .data$play_type == "Field Goal Good" ~ "FG",
        .data$play_type == "Field Goal Missed" ~ "MISSED FG",
        .data$play_type == "Missed Field Goal Return" ~ "MISSED FG",
        .data$play_type == "Blocked Field Goal Touchdown" ~ "BLOCKED FG TD",
        .data$play_type == "Missed Field Goal Return Touchdown" ~ "MISSED FG RETURN TD",
        .data$play_type == "Blocked Field Goal" ~ "BLOCKED FG",
        .data$play_type == "Uncategorized Touchdown" ~ "UNCATEGORIZED TD",
        .data$play_type == "End of Half" ~ "END OF HALF",
        .data$play_type == "End of Game" ~ "END OF GAME",
        .data$scoring_play == 0 & (.data$lead_TimeSecsRem == 0 | is.na(.data$lead_TimeSecsRem)) &
          period %in% c(2, 4) ~ "END OF HALF",
        TRUE ~ NA_character_
      ),
      new_drive_pts = dplyr::case_when(
        .data$downs_turnover == 1 ~ 0,
        .data$play_type == "Punt" ~ 0,
        .data$play_type == "Blocked Punt (Safety)" & .data$safety == 1 ~ -2,
        .data$play_type == "Punt (Safety)" ~ -2,
        .data$play_type == "Blocked Punt" & .data$safety == 1 ~ -2,
        .data$play_type == "Blocked Punt" ~ 0,
        .data$play_type == "Blocked Punt Touchdown" ~ -7,
        .data$play_type == "Punt Touchdown" ~ 7,
        .data$play_type == "Punt Team Fumble Recovery Touchdown" ~ 7,
        .data$play_type == "Punt Return Touchdown" ~ -7,
        .data$play_type == "Fumble Recovery (Opponent) Touchdown" ~ -7,
        .data$play_type == "Fumble Return Touchdown" ~ -7,
        .data$play_type == "Fumble Recovery (Opponent)" ~ 0,
        .data$play_type == "Fumble Recovery (Own) Touchdown" ~ 7,
        .data$play_type == "Interception Return Touchdown" ~ -7,
        .data$play_type == "Interception Return" ~ 0,
        .data$play_type == "Sack Touchdown" ~ -7,
        .data$play_type == "Safety" & .data$kickoff_play == 0 ~ -2,
        .data$play_type == "Kickoff Team Fumble Recovery Touchdown" ~ -7,
        .data$play_type == "Kickoff (Safety)" & .data$kickoff_safety == 1 ~ -2,
        .data$play_type == "Kickoff" & .data$kickoff_safety == 1 ~ -2,
        .data$play_type == "Penalty (Safety)" ~ -2,
        .data$play_type == "Passing Touchdown" ~ 7,
        .data$play_type == "Pass Reception Touchdown" ~ 7,
        .data$play_type == "Rushing Touchdown" ~ 7,
        .data$play_type == "Field Goal Good" ~ 3,
        .data$play_type == "Field Goal Missed" ~ 0,
        .data$play_type == "Missed Field Goal Return" ~ 0,
        .data$play_type == "Blocked Field Goal Touchdown" ~ -7,
        .data$play_type == "Missed Field Goal Return Touchdown" ~ -7,
        .data$play_type == "Blocked Field Goal" ~ 0,
        .data$play_type == "Uncategorized Touchdown" ~ 7,
        .data$play_type == "End of Half" ~ 0,
        .data$play_type == "End of Game" ~ 0,
        .data$scoring_play == 0 & .data$TimeSecsRem == 0 & period %in% c(2, 4) ~ 0,
        TRUE ~ 0
      ),
      new_drive_pts = ifelse(.data$new_drive_pts == 0, NA_integer_, .data$new_drive_pts),
      drive_scoring = ifelse(.data$new_drive_pts != 0, .data$scoring_play, NA_integer_)
    ) %>%
    dplyr::ungroup() %>%
    dplyr::group_by(.data$game_id) %>%
    dplyr::arrange(.data$game_id, .data$half, .data$period,
                   -.data$TimeSecsRem, -.data$lead_TimeSecsRem,
                   .data$id_play,
                   .by_group = TRUE
    ) %>%
    dplyr::mutate(drive_num = cumsum(.data$drive_numbers)) %>%
    dplyr::group_by(.data$game_id, .data$half, .data$drive_num) %>%
    dplyr::arrange(.data$game_id, .data$half, .data$period,
                   -.data$TimeSecsRem, -.data$lead_TimeSecsRem,
                   .data$id_play,
                   .by_group = TRUE
    ) %>%
    tidyr::fill("drive_result_detailed", .direction = c("updown")) %>%
    tidyr::fill("drive_result2", .direction = c("updown")) %>%
    tidyr::fill("drive_scoring", .direction = c("updown")) %>%
    tidyr::fill("new_drive_pts", .direction = c("updown")) %>%
    dplyr::ungroup() %>%
    dplyr::arrange(
      .data$game_id, .data$half, .data$period,
      -.data$TimeSecsRem, -.data$lead_TimeSecsRem,
      .data$id_play
    ) %>%
    dplyr::mutate(
      lag_drive_result_detailed = dplyr::lag(.data$drive_result_detailed, 1),
      lead_drive_result_detailed = dplyr::lead(.data$drive_result_detailed, 1),
      drive_result_detailed = ifelse(is.na(.data$drive_result_detailed) &
                                       .data$play_type %in% c("Defensive 2pt Conversion", "Uncategorized", "Two Point Rush"),
                                     .data$lag_drive_result_detailed,
                                     .data$drive_result_detailed
      ),
      drive_result_detailed = ifelse(is.na(.data$drive_result_detailed) & .data$kickoff_play == 1,
                                     .data$lead_drive_result_detailed, .data$drive_result_detailed
      ),
      drive_scoring = ifelse(is.na(.data$drive_scoring), 0, .data$drive_scoring),
      new_drive_pts = ifelse(is.na(.data$new_drive_pts), 0, .data$new_drive_pts),
      lag_new_drive_pts = dplyr::lag(.data$new_drive_pts, 1),
      new_drive_pts = ifelse(is.na(.data$new_drive_pts), .data$lag_new_drive_pts, .data$new_drive_pts),
      id_drive = paste0(.data$game_id, .data$drive_num)
    ) %>%
    dplyr::group_by(.data$game_id, .data$id_drive) %>%
    dplyr::arrange(.data$game_id, .data$half, .data$period,
                   -.data$TimeSecsRem, -.data$lead_TimeSecsRem, .data$id_play,
                   .by_group = TRUE
    ) %>%
    dplyr::mutate(
      drive_play = ifelse(!(.data$play_type %in% c(
        "End Period", "End of Half", "End of Game",
        "Penalty", "Penalty (Kickoff)", "Timeout"
      )), 1, 0),
      drive_play_number = cumsum(.data$drive_play),
      drive_event = ifelse(!(.data$play_type %in% c("End Period", "End of Half", "End of Game")), 1, 0),
      drive_event_number = cumsum(.data$drive_event)
    ) %>%
    dplyr::ungroup() %>%
    dplyr::select(-"td_check")
  suppressWarnings(
    play_df <- play_df %>%
      dplyr::mutate(
        new_id = gsub(pattern = .data$game_id, "", x = .data$id_play),
        new_id = as.numeric(.data$new_id),
        log_ydstogo = ifelse(.data$distance == 0 | is.nan(log(.data$distance)) | is.na(.data$distance), log(1), log(.data$distance)),
        down = ifelse(stringr::str_detect(.data$play_type, "Kickoff"), 1, .data$down),
        distance = ifelse(stringr::str_detect(.data$play_type, "Kickoff"), 10, .data$distance),
        yards_to_goal = as.numeric(.data$yards_to_goal),
        yards_gained = as.numeric(.data$yards_gained),
        Goal_To_Go = ifelse(stringr::str_detect(.data$play_type, "Field Goal"),
                            .data$distance >= (.data$yards_to_goal),
                            .data$distance >= .data$yards_to_goal
        )
      )
  )
  return(play_df)
}
