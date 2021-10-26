#' @name cfbd_pbp_data
#' @aliases play-by-play pbp_data cfbd_pbp_data
#' @title
#' **Get college football play by play data with cfbfastR expected points/win probability added**
#' @description
#' Extract college football (D-I) play by play Data - for plays
#' @param season_type Select Season Type (regular, postseason, both)
#' @param year Select year, (example: 2018)
#' @param week Select week, this is optional (also numeric)
#' @param team Select team name (example: Texas, Texas A&M, Clemson)
#' @param play_type Select play type (example: see the [cfbd_play_type_df])
#' @param epa_wpa Logical parameter (TRUE/FALSE) to return the Expected Points Added/Win Probability Added variables
#' @param ... Additional arguments passed to an underlying function.
#' @return A data frame with 351 variables:
#' \describe{
#'   \item{`season`: double.}{.}
#'   \item{`wk`: double.}{.}
#'   \item{`id_play`: character.}{.}
#'   \item{`game_id`: integer.}{.}
#'   \item{`game_play_number`: double.}{.}
#'   \item{`half_play_number`: double.}{.}
#'   \item{`pos_team`: character.}{.}
#'   \item{`def_pos_team`: character.}{.}
#'   \item{`half`: integer.}{.}
#'   \item{`period`: integer.}{.}
#'   \item{`clock.minutes`: integer.}{.}
#'   \item{`clock.seconds`: integer.}{.}
#'   \item{`play_type`: character.}{.}
#'   \item{`play_text`: character.}{.}
#'   \item{`down`: double.}{.}
#'   \item{`distance`: double.}{.}
#'   \item{`yards_to_goal`: double.}{.}
#'   \item{`yards_gained`: double.}{.}
#'   \item{`penalty_1st_conv`: logical.}{.}
#'   \item{`new_series`: double.}{.}
#'   \item{`change_of_pos_team`: double.}{.}
#'   \item{`lag_change_of_pos_team`: double.}{.}
#'   \item{`orig_play_type`: character.}{.}
#'   \item{`lead_play_type`: character.}{.}
#'   \item{`lag_play_type`: character.}{.}
#'   \item{`lag_play_type2`: character.}{.}
#'   \item{`lag_play_type3`: character.}{.}
#'   \item{`row`: integer.}{.}
#'   \item{`drive_play_number`: double.}{.}
#'   \item{`drive_event_number`: double.}{.}
#'   \item{`lag_play_text`: character.}{.}
#'   \item{`lag_play_text2`: character.}{.}
#'   \item{`lead_play_text`: character.}{.}
#'   \item{`firstD_by_kickoff`: double.}{.}
#'   \item{`firstD_by_poss`: double.}{.}
#'   \item{`firstD_by_penalty`: double.}{.}
#'   \item{`firstD_by_yards`: double.}{.}
#'   \item{`lag_first_by_penalty`: double.}{.}
#'   \item{`lag_first_by_penalty2`: double.}{.}
#'   \item{`lag_first_by_yards`: double.}{.}
#'   \item{`lag_first_by_yards2`: double.}{.}
#'   \item{`first_by_penalty`: double.}{.}
#'   \item{`first_by_yards`: double.}{.}
#'   \item{`play_after_turnover`: double.}{.}
#'   \item{`lag_change_of_poss`: double.}{.}
#'   \item{`lag_kickoff_play`: double.}{.}
#'   \item{`lag_punt`: double.}{.}
#'   \item{`lag_scoring_play`: double.}{.}
#'   \item{`lag_turnover_vec`: double.}{.}
#'   \item{`lag_downs_turnover`: double.}{.}
#'   \item{`lag_defense_score_play`: double.}{.}
#'   \item{`EPA`: double.}{.}
#'   \item{`ep_before`: double.}{.}
#'   \item{`ep_after`: double.}{.}
#'   \item{`wpa`: double.}{.}
#'   \item{`wp_before`: double.}{.}
#'   \item{`wp_after`: double.}{.}
#'   \item{`def_wp_before`: double.}{.}
#'   \item{`def_wp_after`: double.}{.}
#'   \item{`penalty_detail`: character.}{.}
#'   \item{`yds_penalty`: double.}{.}
#'   \item{`downs_turnover`: double.}{.}
#'   \item{`turnover`: double.}{.}
#'   \item{`pos_score_diff_start`: double.}{.}
#'   \item{`pos_score_pts`: double.}{.}
#'   \item{`pos_team_score`: integer.}{.}
#'   \item{`def_pos_team_score`: integer.}{.}
#'   \item{`log_ydstogo`: double.}{.}
#'   \item{`ExpScoreDiff`: double.}{.}
#'   \item{`ExpScoreDiff_Time_Ratio`: double.}{.}
#'   \item{`half_clock.minutes`: double.}{.}
#'   \item{`TimeSecsRem`: double.}{.}
#'   \item{`adj_TimeSecsRem`: double.}{.}
#'   \item{`Goal_To_Go`: logical.}{.}
#'   \item{`Under_two`: logical.}{.}
#'   \item{`home`: character.}{.}
#'   \item{`away`: character.}{.}
#'   \item{`home_wp_before`: double.}{.}
#'   \item{`away_wp_before`: double.}{.}
#'   \item{`home_wp_after`: double.}{.}
#'   \item{`away_wp_after`: double.}{.}
#'   \item{`end_of_half`: double.}{.}
#'   \item{`pos_team_receives_2H_kickoff`: double.}{.}
#'   \item{`lead_pos_team`: character.}{.}
#'   \item{`lag_pos_team`: character.}{.}
#'   \item{`Under_three`: logical.}{.}
#'   \item{`down_end`: integer.}{.}
#'   \item{`distance_end`: double.}{.}
#'   \item{`log_ydstogo_end`: double.}{.}
#'   \item{`yards_to_goal_end`: double.}{.}
#'   \item{`TimeSecsRem_end`: double.}{.}
#'   \item{`Goal_To_Go_end`: logical.}{.}
#'   \item{`Under_two_end`: logical.}{.}
#'   \item{`def_EPA`: double.}{.}
#'   \item{`offense_score_play`: double.}{.}
#'   \item{`defense_score_play`: double.}{.}
#'   \item{`ppa`: character.}{.}
#'   \item{`yard_line`: integer.}{.}
#'   \item{`scoring`: logical.}{.}
#'   \item{`pos_team_timeouts_rem_before`: double.}{.}
#'   \item{`def_pos_team_timeouts_rem_before`: double.}{.}
#'   \item{`pos_team_timeouts`: integer.}{.}
#'   \item{`def_pos_team_timeouts`: integer.}{.}
#'   \item{`pos_score_diff`: integer.}{.}
#'   \item{`pos_score_diff_start_end`: double.}{.}
#'   \item{`offense_play`: character.}{.}
#'   \item{`defense_play`: character.}{.}
#'   \item{`offense_receives_2H_kickoff`: double.}{.}
#'   \item{`change_of_poss`: double.}{.}
#'   \item{`score_pts`: double.}{.}
#'   \item{`score_diff_start`: double.}{.}
#'   \item{`score_diff`: integer.}{.}
#'   \item{`offense_score`: integer.}{.}
#'   \item{`defense_score`: integer.}{.}
#'   \item{`offense_conference`: character.}{.}
#'   \item{`defense_conference`: character.}{.}
#'   \item{`off_timeout_called`: double.}{.}
#'   \item{`def_timeout_called`: double.}{.}
#'   \item{`offense_timeouts`: integer.}{.}
#'   \item{`defense_timeouts`: integer.}{.}
#'   \item{`off_timeouts_rem_before`: double.}{.}
#'   \item{`def_timeouts_rem_before`: double.}{.}
#'   \item{`rusher_player_name`: character.}{.}
#'   \item{`yds_rushed`: double.}{.}
#'   \item{`passer_player_name`: character.}{.}
#'   \item{`receiver_player_name`: character.}{.}
#'   \item{`yds_receiving`: double.}{.}
#'   \item{`yds_sacked`: double.}{.}
#'   \item{`sack_players`: character.}{.}
#'   \item{`sack_player_name`: character.}{.}
#'   \item{`sack_player_name2`: character.}{.}
#'   \item{`pass_breakup_player_name`: character.}{.}
#'   \item{`interception_player_name`: character.}{.}
#'   \item{`yds_int_return`: double.}{.}
#'   \item{`fumble_player_name`: character.}{.}
#'   \item{`fumble_forced_player_name`: character.}{.}
#'   \item{`fumble_recovered_player_name`: character.}{.}
#'   \item{`yds_fumble_return`: double.}{.}
#'   \item{`punter_player_name`: character.}{.}
#'   \item{`yds_punted`: double.}{.}
#'   \item{`punt_returner_player_name`: character.}{.}
#'   \item{`yds_punt_return`: double.}{.}
#'   \item{`yds_punt_gained`: double.}{.}
#'   \item{`punt_block_player_name`: character.}{.}
#'   \item{`punt_block_return_player_name`: character.}{.}
#'   \item{`fg_kicker_player_name`: character.}{.}
#'   \item{`yds_fg`: double.}{.}
#'   \item{`fg_block_player_name`: character.}{.}
#'   \item{`fg_return_player_name`: character.}{.}
#'   \item{`kickoff_player_name`: character.}{.}
#'   \item{`yds_kickoff`: double.}{.}
#'   \item{`kickoff_returner_player_name`: character.}{.}
#'   \item{`yds_kickoff_return`: double.}{.}
#'   \item{`new_id`: double.}{.}
#'   \item{`orig_drive_number`: integer.}{.}
#'   \item{`drive_number`: integer.}{.}
#'   \item{`drive_result_detailed`: character.}{.}
#'   \item{`new_drive_pts`: double.}{.}
#'   \item{`drive_id`: double.}{.}
#'   \item{`drive_result`: character.}{.}
#'   \item{`drive_start_yards_to_goal`: double.}{.}
#'   \item{`drive_end_yards_to_goal`: integer.}{.}
#'   \item{`drive_yards`: integer.}{.}
#'   \item{`drive_scoring`: double.}{.}
#'   \item{`drive_pts`: double.}{.}
#'   \item{`drive_start_period`: integer.}{.}
#'   \item{`drive_end_period`: integer.}{.}
#'   \item{`drive_time_minutes_start`: integer.}{.}
#'   \item{`drive_time_seconds_start`: integer.}{.}
#'   \item{`drive_time_minutes_end`: integer.}{.}
#'   \item{`drive_time_seconds_end`: integer.}{.}
#'   \item{`drive_time_minutes_elapsed`: integer.}{.}
#'   \item{`drive_time_seconds_elapsed`: integer.}{.}
#'   \item{`drive_numbers`: double.}{.}
#'   \item{`number_of_drives`: double.}{.}
#'   \item{`pts_scored`: double.}{.}
#'   \item{`drive_result_detailed_flag`: character.}{.}
#'   \item{`drive_result2`: character.}{.}
#'   \item{`drive_num`: double.}{.}
#'   \item{`lag_drive_result_detailed`: character.}{.}
#'   \item{`lead_drive_result_detailed`: character.}{.}
#'   \item{`lag_new_drive_pts`: double.}{.}
#'   \item{`id_drive`: character.}{.}
#'   \item{`rush`: double.}{.}
#'   \item{`rush_td`: double.}{.}
#'   \item{`pass`: double.}{.}
#'   \item{`pass_td`: double.}{.}
#'   \item{`completion`: double.}{.}
#'   \item{`pass_attempt`: double.}{.}
#'   \item{`target`: double.}{.}
#'   \item{`sack_vec`: double.}{.}
#'   \item{`sack`: double.}{.}
#'   \item{`int`: double.}{.}
#'   \item{`int_td`: double.}{.}
#'   \item{`turnover_vec`: double.}{.}
#'   \item{`turnover_vec_lag`: double.}{.}
#'   \item{`turnover_indicator`: double.}{.}
#'   \item{`kickoff_play`: double.}{.}
#'   \item{`receives_2H_kickoff`: double.}{.}
#'   \item{`missing_yard_flag`: logical.}{.}
#'   \item{`scoring_play`: double.}{.}
#'   \item{`td_play`: double.}{.}
#'   \item{`touchdown`: double.}{.}
#'   \item{`safety`: double.}{.}
#'   \item{`fumble_vec`: double.}{.}
#'   \item{`kickoff_tb`: double.}{.}
#'   \item{`kickoff_onside`: double.}{.}
#'   \item{`kickoff_oob`: double.}{.}
#'   \item{`kickoff_fair_catch`: double.}{.}
#'   \item{`kickoff_downed`: double.}{.}
#'   \item{`kickoff_safety`: double.}{.}
#'   \item{`kick_play`: double.}{.}
#'   \item{`punt`: double.}{.}
#'   \item{`punt_play`: double.}{.}
#'   \item{`punt_tb`: double.}{.}
#'   \item{`punt_oob`: double.}{.}
#'   \item{`punt_fair_catch`: double.}{.}
#'   \item{`punt_downed`: double.}{.}
#'   \item{`punt_safety`: double.}{.}
#'   \item{`punt_blocked`: double.}{.}
#'   \item{`penalty_safety`: double.}{.}
#'   \item{`fg_inds`: double.}{.}
#'   \item{`fg_made`: logical.}{.}
#'   \item{`fg_make_prob`: double.}{.}
#'   \item{`home_EPA`: double.}{.}
#'   \item{`away_EPA`: double.}{.}
#'   \item{`home_EPA_rush`: double.}{.}
#'   \item{`away_EPA_rush`: double.}{.}
#'   \item{`home_EPA_pass`: double.}{.}
#'   \item{`away_EPA_pass`: double.}{.}
#'   \item{`total_home_EPA`: double.}{.}
#'   \item{`total_away_EPA`: double.}{.}
#'   \item{`total_home_EPA_rush`: double.}{.}
#'   \item{`total_away_EPA_rush`: double.}{.}
#'   \item{`total_home_EPA_pass`: double.}{.}
#'   \item{`total_away_EPA_pass`: double.}{.}
#'   \item{`net_home_EPA`: double.}{.}
#'   \item{`net_away_EPA`: double.}{.}
#'   \item{`net_home_EPA_rush`: double.}{.}
#'   \item{`net_away_EPA_rush`: double.}{.}
#'   \item{`net_home_EPA_pass`: double.}{.}
#'   \item{`net_away_EPA_pass`: double.}{.}
#'   \item{`success`: double.}{.}
#'   \item{`epa_success`: double.}{.}
#'   \item{`rz_play`: double.}{.}
#'   \item{`scoring_opp`: double.}{.}
#'   \item{`middle_8`: logical.}{.}
#'   \item{`stuffed_run`: double.}{.}
#'   \item{`spread`: double.}{.}
#'   \item{`formatted_spread`: character.}{.}
#'   \item{`No_Score_before`: double.}{.}
#'   \item{`FG_before`: double.}{.}
#'   \item{`Opp_FG_before`: double.}{.}
#'   \item{`Opp_Safety_before`: double.}{.}
#'   \item{`Opp_TD_before`: double.}{.}
#'   \item{`Safety_before`: double.}{.}
#'   \item{`TD_before`: double.}{.}
#'   \item{`No_Score_after`: double.}{.}
#'   \item{`FG_after`: double.}{.}
#'   \item{`Opp_FG_after`: double.}{.}
#'   \item{`Opp_Safety_after`: double.}{.}
#'   \item{`Opp_TD_after`: double.}{.}
#'   \item{`Safety_after`: double.}{.}
#'   \item{`TD_after`: double.}{.}
#'   \item{`penalty_flag`: logical.}{.}
#'   \item{`penalty_declined`: logical.}{.}
#'   \item{`penalty_no_play`: logical.}{.}
#'   \item{`penalty_offset`: logical.}{.}
#'   \item{`penalty_text`: logical.}{.}
#'   \item{`penalty_play_text`: character.}{.}
#'   \item{`lead_wp_before2`: double.}{.}
#'   \item{`wpa_half_end`: double.}{.}
#'   \item{`wpa_base`: double.}{.}
#'   \item{`wpa_base_nxt`: double.}{.}
#'   \item{`wpa_change`: double.}{.}
#'   \item{`wpa_change_nxt`: double.}{.}
#'   \item{`wpa_base_ind`: double.}{.}
#'   \item{`wpa_base_nxt_ind`: double.}{.}
#'   \item{`wpa_change_ind`: double.}{.}
#'   \item{`wpa_change_nxt_ind`: double.}{.}
#'   \item{`lead_wp_before`: double.}{.}
#'   \item{`lead_pos_team2`: character.}{.}
#'   \item{`lag_change_of_pos_team2`: double.}{.}
#'   \item{`lag_punt2`: double.}{.}
#'   \item{`lag_score_diff`: double.}{.}
#'   \item{`lag_offense_play`: character.}{.}
#'   \item{`lead_offense_play`: character.}{.}
#'   \item{`lead_offense_play2`: character.}{.}
#'   \item{`lag_pos_score_diff`: double.}{.}
#'   \item{`lag_off_timeouts`: double.}{.}
#'   \item{`lag_def_timeouts`: double.}{.}
#'   \item{`lag_TimeSecsRem2`: double.}{.}
#'   \item{`lag_TimeSecsRem`: double.}{.}
#'   \item{`lead_TimeSecsRem`: double.}{.}
#'   \item{`lead_TimeSecsRem2`: double.}{.}
#'   \item{`lag_yards_to_goal2`: integer.}{.}
#'   \item{`lag_yards_to_goal`: integer.}{.}
#'   \item{`lead_yards_to_goal`: double.}{.}
#'   \item{`lead_yards_to_goal2`: integer.}{.}
#'   \item{`lag_down2`: double.}{.}
#'   \item{`lag_down`: double.}{.}
#'   \item{`lead_down`: double.}{.}
#'   \item{`lead_down2`: double.}{.}
#'   \item{`lead_distance`: double.}{.}
#'   \item{`lead_distance2`: integer.}{.}
#'   \item{`lead_play_type2`: character.}{.}
#'   \item{`lead_play_type3`: character.}{.}
#'   \item{`lag_ep_before3`: double.}{.}
#'   \item{`lag_ep_before2`: double.}{.}
#'   \item{`lag_ep_before`: double.}{.}
#'   \item{`lead_ep_before`: double.}{.}
#'   \item{`lead_ep_before2`: double.}{.}
#'   \item{`lag_ep_after`: double.}{.}
#'   \item{`lag_ep_after2`: double.}{.}
#'   \item{`lag_ep_after3`: double.}{.}
#'   \item{`lead_ep_after`: double.}{.}
#'   \item{`lead_ep_after2`: double.}{.}
#'   \item{`play_number`: integer.}{.}
#'   \item{`over_under`: double.}{.}
#'   \item{`event`: double.}{.}
#'   \item{`game_event_number`: double.}{.}
#'   \item{`game_row_number`: integer.}{.}
#'   \item{`half_event`: double.}{.}
#'   \item{`half_event_number`: double.}{.}
#'   \item{`half_row_number`: integer.}{.}
#'   \item{`lag_distance3`: integer.}{.}
#'   \item{`lag_distance2`: integer.}{.}
#'   \item{`lag_distance`: integer.}{.}
#'   \item{`lag_yards_gained3`: integer.}{.}
#'   \item{`lag_yards_gained2`: integer.}{.}
#'   \item{`lag_yards_gained`: integer.}{.}
#'   \item{`lead_yards_gained`: integer.}{.}
#'   \item{`lead_yards_gained2`: integer.}{.}
#'   \item{`lag_play_text3`: character.}{.}
#'   \item{`lead_play_text2`: character.}{.}
#'   \item{`lead_play_text3`: character.}{.}
#'   \item{`lag_change_of_poss2`: double.}{.}
#'   \item{`lag_change_of_poss3`: double.}{.}
#'   \item{`lag_change_of_pos_team3`: double.}{.}
#'   \item{`lag_kickoff_play2`: double.}{.}
#'   \item{`lag_kickoff_play3`: double.}{.}
#'   \item{`lag_punt3`: double.}{.}
#'   \item{`lag_scoring_play2`: double.}{.}
#'   \item{`lag_scoring_play3`: double.}{.}
#'   \item{`lag_turnover_vec2`: double.}{.}
#'   \item{`lag_turnover_vec3`: double.}{.}
#'   \item{`lag_downs_turnover2`: double.}{.}
#'   \item{`lag_downs_turnover3`: double.}{.}
#'   \item{`drive_event`: double.}{.}
#'   \item{`lag_first_by_penalty3`: double.}{.}
#'   \item{`lag_first_by_yards3`: double.}{.}
#' }
#' @keywords Play-by-Play
#' @import stringr
#' @importFrom rlang .data
#' @importFrom tidyr everything
#' @importFrom purrr map_dfr
#' @importFrom glue glue
#' @importFrom dplyr mutate left_join select rename filter group_by arrange ungroup setdiff
#' @importFrom jsonlite fromJSON
#' @importFrom utils URLencode
#' @importFrom utils globalVariables
#' @importFrom cli cli_abort
#' @export
#'

cfbd_pbp_data <- function(year,
                          season_type = "regular",
                          week = 1,
                          team = NULL,
                          play_type = NULL,
                          epa_wpa = FALSE,
                          ...) {
  old <- options()
  on.exit(options(old))
  options(stringsAsFactors = FALSE)
  options(scipen = 999)
  # Check if year is numeric, if not NULL
  if (!is.null(year) & !(is.numeric(year) & nchar(year) == 4)) {
    # Check if year is numeric, if not NULL
    cli::cli_abort("Enter valid year as a number (YYYY)")
  }
  if (!is.null(week) & !(is.numeric(week) & nchar(week) <= 2)) {
    # Check if week is numeric, if not NULL
    cli::cli_abort("Enter valid week 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)")
  }
  if (season_type != "regular" & season_type != "postseason" & season_type != "both") {
    # Check if season_type is appropriate, if not regular
    cli::cli_abort("Enter valid season_type: regular, postseason, or both")
  }
  if (!is.null(team)) {
    if (team == "San Jose State") {
      team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team parameter for URL if not NULL
      team <- utils::URLencode(team, reserved = TRUE)
    }
  }

  if (!is.null(play_type)) {
    text <- play_type %in% cfbfastR::cfbd_play_type_df$text
    abbr <- play_type %in% cfbfastR::cfbd_play_type_df$abbreviation

    if ((text | abbr) == FALSE) {
      cli::cli_abort("Incorrect play type selected, please look at the available options in the Play Type DF.")
    }
    if (text) {
      pt_id <- cfbfastR::cfbd_play_type_df$id[which(cfbfastR::cfbd_play_type_df$text == play_type)]
    } else {
      pt_id <- cfbfastR::cfbd_play_type_df$id[which(cfbfastR::cfbd_play_type_df$abbreviation == play_type)]
    }
  } else {
    pt_id <- NULL
  }

  play_base_url <- "https://api.collegefootballdata.com/plays?"

  ## Inputs
  ## Year, Week, Team
  full_url <- paste0(
    play_base_url,
    "seasonType=", season_type,
    "&year=", year,
    "&week=", week,
    "&team=", team,
    "&playType=", pt_id
  )

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  # Create the GET request and set response as res
  res <- httr::RETRY(
    "GET", full_url,
    httr::add_headers(Authorization = paste("Bearer", cfbd_key()))
  )

  # # Check the result
  # check_status(res)
  raw_play_df <- res %>%
    httr::content(as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON()
  raw_play_df <- do.call(data.frame, raw_play_df)

  if (nrow(raw_play_df) == 0) {
      warning("Most likely a bye week, the data pulled from the API was empty. Returning nothing
              for this one week or team.")
    return(NULL)
  }
  raw_play_df$spread <- NA_real_
  raw_play_df$formatted_spread <- NA_character_
  raw_play_df$over_under <- NA_real_
  if (year >= 2013) {
    tryCatch(
      expr = {
        game_spread <- cfbd_betting_lines(year = year, week = week, season_type = season_type, team = team)

        game_spread <- game_spread %>%
          dplyr::filter(.data$provider == "consensus") %>%
          dplyr::mutate(
            spread = as.numeric(.data$spread),
            over_under = as.numeric(.data$over_under)
          ) %>%
          dplyr::select(.data$game_id, .data$spread, .data$formatted_spread, .data$over_under)

        raw_play_df <- raw_play_df %>%
          dplyr::left_join(game_spread, by = c("game_id"))
      },
      error = function(e) {
      },
      warning = function(w) {
      },
      finally = {
      }
    )
  }
  ## call/drive information
  drive_info <- cfbd_drives(year = year, season_type = season_type, team = team, week = week)

  clean_drive_df <- clean_drive_info(drive_info)

  colnames(clean_drive_df) <- paste0("drive_", colnames(clean_drive_df))

  play_df <- raw_play_df %>%
    dplyr::mutate(drive_id = as.numeric(.data$drive_id)) %>%
    dplyr::left_join(clean_drive_df,
      by = c(
        "drive_id" = "drive_drive_id",
        "game_id" = "drive_game_id"
      ),
      suffix = c("_play", "_drive")
    )

  rm_cols <- c(
    "drive_game_id", "drive_id_drive", #' drive_drive_number',
    "drive_plays", "drive_start_yardline", "drive_end_yardline",
    "drive_offense", "drive_offense_conference",
    "drive_defense", "drive_defense_conference",
    "drive_start_time.hours", "drive_start_time.minutes", "drive_start_time.seconds",
    "drive_end_time.hours", "drive_end_time.minutes", "drive_end_time.seconds",
    "drive_elapsed.hours", "drive_elapsed.minutes", "drive_elapsed.seconds"
  )


  play_df <- play_df %>%
    dplyr::select(dplyr::setdiff(names(play_df), rm_cols)) %>%
    dplyr::rename(
      drive_pts = .data$drive_pts_drive,
      drive_result = .data$drive_drive_result,
      orig_drive_number = .data$drive_drive_number,
      id_play = .data$id,
      offense_play = .data$offense,
      defense_play = .data$defense
    ) %>%
    dplyr::mutate(
      season = year,
      wk = week
    )

  if (epa_wpa) {
    if (year <= 2005) {
        warning(
          "Data Quality prior to 2005 is not as consistent. This can affect the EPA/WPA values, proceed with caution."
        )
    }

    #---- Purrr Map Function -----
    g_ids <- sort(unique(play_df$game_id))
    game_count <- length(g_ids)
    builder <- TRUE

    if (game_count > 1) {
      user_message(glue::glue("Start processing of {game_count} games..."),"todo")
    } else {
      user_message(glue::glue("Start processing of {game_count} game..."),"todo")
    }

    p <- progressr::progressor(along = g_ids)

    play_df <- furrr::future_map_dfr(
      g_ids,
      function(x){
        play_df <- play_df %>%
          dplyr::filter(.data$game_id == x) %>%
          penalty_detection() %>%
          add_play_counts() %>%
          clean_pbp_dat() %>%
          clean_drive_dat() %>%
          add_yardage() %>%
          add_player_cols() %>%
          prep_epa_df_after() %>%
          create_epa(ep_model = ep_model, fg_model = fg_model) %>%
          # create_wpa_betting() %>%
          create_wpa_naive(wp_model = wp_model)
        p(sprintf("x=%s", as.integer(x)))
        return(play_df)
      }, ...)
    # } else{
    #   play_df <- purrr::map_dfr(
    #     g_ids,
    #     function(x) {
    #       play_df <- play_df %>%
    #         dplyr::filter(.data$game_id == x) %>%
    #         penalty_detection() %>%
    #         add_play_counts() %>%
    #         clean_pbp_dat() %>%
    #         clean_drive_dat() %>%
    #         add_yardage() %>%
    #         add_player_cols() %>%
    #         prep_epa_df_after() %>%
    #         create_epa() %>%
    #         # create_wpa_betting() %>%
    #         create_wpa_naive()
    #       p(sprintf("x=%s", as.integer(x)))
    #       return(play_df)
    #     }
    #   )
    # }



    #---- Select Output Ordering -----

    play_columns <- c(
      "season", "wk", "id_play", "game_id", "game_play_number", "half_play_number", "drive_play_number",
      "pos_team", "def_pos_team", "pos_team_score", "def_pos_team_score",
      "half", "period", "clock.minutes", "clock.seconds",
      "play_type", "play_text",
      "down", "distance", "yards_to_goal", "yards_gained"
    )
    model_columns <- c(
      "EPA", "ep_before", "ep_after",
      "wpa", "wp_before", "wp_after",
      "def_wp_before", "def_wp_after",
      "penalty_detail", "yds_penalty", "penalty_1st_conv"
    )
    series_columns <- c(
      # "srs_new", "srs_1stD_by_kickoff", "srs_1stD_by_poss", "srs_1stD_by_penalty", "srs_1stD_by_yards"
      "new_series", "firstD_by_kickoff", "firstD_by_poss", "firstD_by_penalty", "firstD_by_yards"
    )
    epa_flag_columns <- c(
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
      "middle_8", "stuffed_run"
    )
    team_columns <- c(
      "change_of_pos_team", "downs_turnover", "turnover",
      "pos_score_diff_start", "pos_score_pts", "log_ydstogo",
      "ExpScoreDiff", "ExpScoreDiff_Time_Ratio", "half_clock.minutes",
      "TimeSecsRem", "adj_TimeSecsRem", "Goal_To_Go", "Under_two",
      "home", "away", "home_wp_before", "away_wp_before", "home_wp_after", "away_wp_after",
      "end_of_half", "pos_team_receives_2H_kickoff",
      "lead_pos_team", "lead_play_type", "lag_pos_team", "lag_play_type",
      "orig_play_type", "Under_three"
    )
    model_end_columns <- c(
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
      "off_timeouts_rem_before", "def_timeouts_rem_before"
    )
    player_name_columns <- c(
      "rusher_player_name", "yds_rushed", "passer_player_name", "receiver_player_name", "yds_receiving",
      "yds_sacked", "sack_players", "sack_player_name", "sack_player_name2",
      "pass_breakup_player_name", "interception_player_name", "yds_int_return",
      "fumble_player_name", "fumble_forced_player_name", "fumble_recovered_player_name", "yds_fumble_return",
      "punter_player_name", "yds_punted", "punt_returner_player_name", "yds_punt_return", "yds_punt_gained",
      "punt_block_player_name", "punt_block_return_player_name",
      "fg_kicker_player_name", "yds_fg", "fg_block_player_name", "fg_return_player_name",
      "kickoff_player_name", "yds_kickoff", "kickoff_returner_player_name", "yds_kickoff_return", "new_id"
    )
    drive_columns <- c(
      "orig_drive_number", "drive_number",
      "drive_result_detailed", "new_drive_pts", "drive_id", "drive_result",
      "drive_start_yards_to_goal", "drive_end_yards_to_goal", "drive_yards", "drive_scoring", "drive_pts",
      "drive_start_period", "drive_end_period", "drive_time_minutes_start",
      "drive_time_seconds_start", "drive_time_minutes_end", "drive_time_seconds_end",
      "drive_time_minutes_elapsed", "drive_time_seconds_elapsed",
      "drive_numbers", "number_of_drives", "pts_scored", "drive_result_detailed_flag", "drive_result2",
      "drive_num", "lag_drive_result_detailed", "lead_drive_result_detailed",
      "lag_new_drive_pts", "id_drive"
    )
    penalty_columns <- c(
      "penalty_flag", "penalty_declined",
      "penalty_no_play", "penalty_offset",
      "penalty_text", "penalty_play_text"
    )
    play_flag_columns <- c(
      "rush", "rush_td", "pass", "pass_td",
      "completion", "pass_attempt", "target",
      "sack_vec", "sack", "int", "int_td",
      "turnover_vec", "turnover_vec_lag", "turnover_indicator",
      "kickoff_play", "receives_2H_kickoff", "missing_yard_flag",
      "scoring_play", "td_play", "touchdown", "safety", "fumble_vec",
      "kickoff_tb", "kickoff_onside", "kickoff_oob", "kickoff_fair_catch", "kickoff_downed",
      "kickoff_safety", "kick_play",
      "punt", "punt_play", "punt_tb", "punt_oob", "punt_fair_catch", "punt_downed",
      "punt_safety", "punt_blocked", "penalty_safety",
      "fg_inds", "fg_made", "fg_make_prob"
    )
    model_prob_columns <- c(
      "No_Score_before", "FG_before", "Opp_FG_before", "Opp_Safety_before",
      "Opp_TD_before", "Safety_before", "TD_before",
      "No_Score_after", "FG_after", "Opp_FG_after", "Opp_Safety_after",
      "Opp_TD_after", "Safety_after", "TD_after"
    )
    wpa_extra_columns <- c(
      "lead_wp_before2", "wpa_half_end", "wpa_base", "wpa_base_nxt", "wpa_change", "wpa_change_nxt",
      "wpa_base_ind", "wpa_base_nxt_ind", "wpa_change_ind", "wpa_change_nxt_ind", "lead_wp_before",
      "lead_pos_team2"
    )
    lag_series_columns <- c(
      "row", "drive_event_number",
      "orig_play_type", "lead_play_type",
      "lag_play_type", "lag_play_type2", "lag_play_type3",
      "lag_play_text", "lag_play_text2", "lead_play_text",
      "lag_first_by_penalty", "lag_first_by_penalty2",
      "lag_first_by_yards", "lag_first_by_yards2",
      "first_by_penalty", "first_by_yards", "play_after_turnover",
      "lag_change_of_poss", "lag_change_of_pos_team", "lag_change_of_pos_team2",
      "lag_kickoff_play", "lag_punt", "lag_punt2",
      "lag_scoring_play", "lag_turnover_vec",
      "lag_downs_turnover", "lag_defense_score_play"
    )
    lag_lead_columns <- c(
      "lag_score_diff", "lag_offense_play", "lead_offense_play", "lead_offense_play2",
      "lag_pos_score_diff", "lag_off_timeouts",
      "lag_def_timeouts", "lag_TimeSecsRem2", "lag_TimeSecsRem", "lead_TimeSecsRem",
      "lead_TimeSecsRem2", "lag_yards_to_goal2", "lag_yards_to_goal",
      "lead_yards_to_goal", "lead_yards_to_goal2", "lag_down2", "lag_down",
      "lead_down", "lead_down2", "lead_distance", "lead_distance2", "lead_play_type2", "lead_play_type3",
      # "lag_change_of_poss","lag_change_of_pos_team", "lag_kickoff_play", "lag_punt", "lag_scoring_play",
      # "lag_turnover_vec", "lag_downs_turnover", "lag_defense_score_play",
      "lag_ep_before3", "lag_ep_before2", "lag_ep_before", "lead_ep_before", "lead_ep_before2",
      "lag_ep_after", "lag_ep_after2", "lag_ep_after3", "lead_ep_after", "lead_ep_after2"
    )

    play_df <- play_df %>%
      select(
        dplyr::all_of(play_columns),
        dplyr::all_of(model_columns),
        dplyr::all_of(series_columns),
        dplyr::all_of(epa_flag_columns),
        dplyr::all_of(team_columns),
        dplyr::all_of(model_end_columns),
        dplyr::all_of(player_name_columns),
        dplyr::all_of(drive_columns),
        dplyr::all_of(play_flag_columns),
        dplyr::all_of(model_prob_columns),
        dplyr::all_of(penalty_columns),
        dplyr::all_of(wpa_extra_columns),
        dplyr::all_of(lag_series_columns),
        dplyr::all_of(lag_lead_columns),
        tidyr::everything()
      )
  }
  play_df <- as.data.frame(play_df)

  return(play_df)
}




#' @name helpers_pbp
#' @aliases add_play_counts clean_drive_dat prep_epa_df_after clean_drive_info
#' add_player_cols add_yardage clean_pbp_dat penalty_detection
#' @title
#' **Series of functions to help clean the play-by-play data for analysis**
#' @description
#' \describe{
#' \item{`add_play_counts()`: function}{Adds play counts to Play-by-Play data pulled from the API's raw game data.}
#' \item{`add_yardage()`: Add yardage extracted from play text}{.}
#' \item{`add_player_cols()`:  function}{Add player columns extracted from play text.}
#' \item{`clean_drive_dat()`: function}{Create new Drive results and id data.}
#' \item{`clean_pbp_dat()`: function}{Clean Play-by-Play data.}
#' \item{`penalty_detection()`: function}{Adds penalty columns to Play-by-Play data pulled from the API.}
#' \item{`prep_epa_df_after()`: function}{Creates the post-play inputs for the Expected Points model to predict on for each game.}
#' \item{`clean_drive_info()`: function}{Cleans CFB (D-I) Drive-By-Drive Data to create `pts_drive` column.}
#' }
#' @param play_df (*data.frame* required): Adds play counts to Play-by-Play dataframe, as pulled from `cfbd_pbp_data()`
#' @details Requires the following columns to be present
#' \describe{
#' \item{`game_id`}{.}
#' \item{`id_play`}{.}
#' \item{`clock.minutes`}{.}
#' \item{`clock.seconds`}{.}
#' \item{`half`}{.}
#' \item{`period`}{.}
#' \item{`offense_play`}{.}
#' \item{`defense_play`}{.}
#' \item{`home`}{.}
#' \item{`away`}{.}
#' \item{`offense_score`}{.}
#' \item{`defense_score`}{.}
#' \item{`offense_timeouts`}{.}
#' \item{`offense_timeouts`}{.}
#' \item{`play_text`}{.}
#' \item{`play_type`}{.}
#' }
#' @return The original `play_df` with the following columns appended/redefined:
#' \describe{
#' \item{`game_play_number`.}{.}
#' \item{`half_clock.minutes`.}{.}
#' \item{`TimeSecsRem`.}{.}
#' \item{`Under_two`.}{.}
#' \item{`half`.}{.}
#' \item{`kickoff_play`.}{.}
#' \item{`pos_team`.}{.}
#' \item{`def_pos_team`.}{.}
#' \item{`receives_2H_kickoff`.}{.}
#' \item{`pos_score_diff`.}{.}
#' \item{`lag_pos_score_diff`.}{.}
#' \item{`lag_pos_team`.}{.}
#' \item{`lead_pos_team`.}{.}
#' \item{`lead_pos_team2`.}{.}
#' \item{`pos_score_pts`.}{.}
#' \item{`pos_score_diff_start`.}{.}
#' \item{`score_diff`.}{.}
#' \item{`lag_score_diff`.}{.}
#' \item{`lag_offense_play`.}{.}
#' \item{`lead_offense_play`.}{.}
#' \item{`lead_offense_play2`.}{.}
#' \item{`score_pts`.}{.}
#' \item{`score_diff_start`.}{.}
#' \item{`offense_receives_2H_kickoff`.}{.}
#' \item{`half_play_number`.}{.}
#' \item{`lag_off_timeouts`.}{.}
#' \item{`lag_def_timeouts`.}{.}
#' \item{`off_timeouts_rem_before`.}{.}
#' \item{`def_timeouts_rem_before`.}{.}
#' \item{`off_timeout_called`.}{.}
#' \item{`def_timeout_called`.}{.}
#' \item{`lead_TimeSecsRem`.}{.}
#' \item{`lead_TimeSecsRem2`.}{.}
#' \item{`lead_yards_to_goal`.}{.}
#' \item{`lead_yards_to_goal2`.}{.}
#' \item{`lead_down`.}{.}
#' \item{`lead_down2`.}{.}
#' \item{`lag_distance3`.}{.}
#' \item{`lag_distance2`.}{.}
#' \item{`lag_distance`.}{.}
#' \item{`lead_distance`.}{.}
#' \item{`lead_distance2`.}{.}
#' \item{`end_of_half`.}{.}
#' \item{`lag_play_type3`.}{.}
#' \item{`lag_play_type2`.}{.}
#' \item{`lag_play_type`.}{.}
#' \item{`lead_play_type`.}{.}
#' \item{`lead_play_type2`.}{.}
#' \item{`lead_play_type3`.}{.}
#' \item{`change_of_poss`.}{.}
#' \item{`change_of_pos_team`.}{.}
#' \item{`pos_team_timeouts`.}{.}
#' \item{`def_pos_team_timeouts`.}{.}
#' \item{`pos_team_timeouts_rem_before`.}{.}
#' \item{`def_pos_team_timeouts_rem_before`.}{.}
#' }
#' @keywords internal
#' @importFrom rlang .data
#' @importFrom dplyr group_by mutate ungroup lead lag arrange n case_when
#' @importFrom tidyr fill
#' @export
#'
#'

add_play_counts <- function(play_df) {
  ## --Play type vectors------
  penalty <- c(
    "Penalty",
    "Penalty (Kickoff)",
    "Penalty (Safety)"
  )
  scores_vec <- c(
    "Blocked Punt Touchdown",
    "Blocked Punt (Safety)",
    "Punt (Safety)",
    "Blocked Field Goal Touchdown",
    "Missed Field Goal Return Touchdown",
    "Fumble Recovery (Opponent) Touchdown",
    "Fumble Return Touchdown",
    "Interception Return Touchdown",
    "Pass Interception Return Touchdown",
    "Punt Touchdown",
    "Punt Return Touchdown",
    "Penalty (Safety)",
    "Punt Team Fumble Recovery Touchdown",
    "Sack Touchdown",
    "Uncategorized Touchdown",
    "Defensive 2pt Conversion",
    "Safety",
    "Kickoff Team Fumble Recovery Touchdown",
    "Kickoff (Safety)",
    "Passing Touchdown",
    "Rushing Touchdown",
    "Field Goal Good",
    "Pass Reception Touchdown",
    "Fumble Recovery (Own) Touchdown"
  )
  turnover_vec <- c(
    "Blocked Field Goal",
    "Blocked Field Goal Touchdown",
    "Field Goal Missed",
    "Missed Field Goal Return",
    "Missed Field Goal Return Touchdown",
    "Fumble Recovery (Opponent)",
    "Fumble Recovery (Opponent) Touchdown",
    "Fumble Return Touchdown",
    "Defensive 2pt Conversion",
    "Interception",
    "Interception Return",
    "Interception Return Touchdown",
    "Pass Interception",
    "Pass Interception Return",
    "Pass Interception Return Touchdown",
    "Blocked Punt",
    "Blocked Punt Touchdown",
    "Punt Touchdown",
    "Punt Return Touchdown",
    "Sack Touchdown",
    "Uncategorized Touchdown"
  )
  offense_score_vec <- c(
    "Passing Touchdown",
    "Rushing Touchdown",
    "Field Goal Good",
    "Pass Reception Touchdown",
    "Fumble Recovery (Own) Touchdown",
    "Punt Touchdown", #<--- Punting Team recovers the return team fumble and scores
    "Punt Team Fumble Recovery Touchdown",
    "Kickoff Touchdown", #<--- Kickoff Team recovers the return team fumble and scores
    "Kickoff Team Fumble Recovery Touchdown"
  )
  defense_score_vec <- c(
    "Blocked Punt Touchdown",
    "Blocked Punt (Safety)",
    "Blocked Field Goal Touchdown",
    "Missed Field Goal Return Touchdown",
    "Punt Return Touchdown",
    "Fumble Recovery (Opponent) Touchdown",
    "Fumble Return Touchdown",
    "Kickoff Return Touchdown",
    "Defensive 2pt Conversion",
    "Penalty (Safety)",
    "Blocked Punt (Safety)",
    "Kickoff (Safety)",
    "Safety",
    "Sack Touchdown",
    "Interception Return Touchdown",
    "Pass Interception Return Touchdown",
    "Uncategorized Touchdown"
  )
  kickoff_vec <- c(
    "Kickoff",
    "Kickoff Return (Offense)",
    "Kickoff Return Touchdown",
    "Kickoff Touchdown",
    "Kickoff Team Fumble Recovery",
    "Kickoff Team Fumble Recovery Touchdown",
    "Kickoff (Safety)",
    "Penalty (Kickoff)"
  )
  punt_vec <- c(
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
  int_vec <- c(
    "Interception",
    "Interception Return",
    "Interception Return Touchdown",
    "Pass Interception",
    "Pass Interception Return",
    "Pass Interception Return Touchdown"
  )

  play_df <- play_df %>%
    dplyr::group_by(.data$game_id) %>%
    dplyr::arrange(.data$id_play, .by_group = TRUE) %>%
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
      half_clock.minutes = ifelse(.data$period %in% c(1, 3), 15 +
        .data$clock.minutes, .data$clock.minutes),
      TimeSecsRem = .data$half_clock.minutes * 60 + .data$clock.seconds,
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
    ) %>%
    tidyr::fill(.data$receives_2H_kickoff) %>%
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
    ) %>%
    dplyr::group_by(.data$game_id, .data$half) %>%
    dplyr::arrange(.data$game_id, .data$half, .data$period,
      -.data$TimeSecsRem, .data$id_play,
      .by_group = TRUE
    ) %>%
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
    ) %>%
    dplyr::ungroup() %>%
    dplyr::arrange(
      .data$game_id, .data$half, .data$period,
      -.data$TimeSecsRem, -.data$lead_TimeSecsRem, .data$id_play
    )
  return(play_df)
}


#' @rdname helpers_pbp
#' @title Create new Drive results and id data
#' @description Cleans Play-by-Play data pulled from the API's raw game data
#'
#' @param play_df (*data.frame* required): Performs data cleansing on Play-by-Play DataFrame, as pulled from `cfbd_pbp_data()`
#' @return The original `play_df` with the following columns appended/redefined:
#' \describe{
#' \item{`lag_change_of_poss`.}{.}
#' \item{`lag_punt`.}{.}
#' \item{`lag_scoring_play`.}{.}
#' \item{`lag_turnover_vec`.}{.}
#' \item{`lag_downs_turnover`.}{.}
#' \item{`lead_play_type`.}{.}
#' \item{`lead_play_type2`.}{.}
#' \item{`lead_play_type3`.}{.}
#' \item{`drive_numbers`.}{.}
#' \item{`number_of_drives`.}{.}
#' \item{`pts_scored`.}{.}
#' \item{`drive_result_detailed`.}{.}
#' \item{`drive_result_detailed_flag`.}{.}
#' \item{`drive_result2`.}{.}
#' \item{`lag_new_drive_pts`.}{.}
#' \item{`lag_drive_result_detailed`.}{.}
#' \item{`lead_drive_result_detailed`.}{.}
#' \item{`new_drive_pts`.}{.}
#' \item{`drive_scoring`.}{.}
#' \item{`drive_play`.}{.}
#' \item{`drive_play_number`.}{.}
#' \item{`drive_event`.}{.}
#' \item{`drive_event_number`.}{.}
#' \item{`new_id`.}{.}
#' \item{`log_ydstogo`.}{.}
#' \item{`down`.}{.}
#' \item{`distance`.}{.}
#' \item{`yards_to_goal`.}{.}
#' \item{`yards_gained`.}{.}
#' \item{`Goal_To_Go`.}{.}
#' }
#' @keywords internal
#' @importFrom rlang .data
#' @importFrom dplyr group_by arrange mutate ungroup case_when select lead lag
#' @importFrom stringr str_detect
#' @importFrom tidyr fill
#' @export
#'

clean_drive_dat <- function(play_df) {
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
    tidyr::fill(.data$drive_result_detailed, .direction = c("updown")) %>%
    tidyr::fill(.data$drive_result2, .direction = c("updown")) %>%
    tidyr::fill(.data$drive_scoring, .direction = c("updown")) %>%
    tidyr::fill(.data$new_drive_pts, .direction = c("updown")) %>%
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
    dplyr::select(-.data$td_check)
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

#' @rdname helpers_pbp
#'
#' @param dat (*Data.Frame* required) Clean Play-by-Play DataFrame pulled from `cfbd_pbp_dat()`
#' @details Prep for EPA calculations at the end of the play. Requires the following columns be present:
#' \itemize{
#' \item{`game_id`.}{.}
#' \item{`id_play`.}{.}
#' \item{`drive_id`.}{.}
#' \item{`down`.}{.}
#' \item{`distance`.}{.}
#' \item{`period`.}{.}
#' \item{`yards_to_goal`.}{.}
#' \item{`play_type`.}{.}
#' }
#' @return `dat` with the following columns appended/modified:
#' \itemize{
#'  \item{`turnover_indicator`.}{.}
#'  \item{`down`.}{.}
#'  \item{`new_id`.}{.}
#'  \item{`new_down`.}{.}
#'  \item{`distance`.}{.}
#'  \item{`yards_to_goal`.}{.}
#'  \item{`yards_gained`.}{.}
#'  \item{`turnover`.}{.}
#'  \item{`drive_start_yards_to_goal`.}{.}
#'  \item{`end_of_half`.}{.}
#'  \item{`new_yardline`.}{.}
#'  \item{`new_distance`.}{.}
#'  \item{`new_log_ydstogo`.}{.}
#'  \item{`new_Goal_To_Go`.}{.}
#'  \item{`new_TimeSecsRem`.}{.}
#'  \item{`new_Under_two`.}{.}
#'  \item{`first_by_penalty`.}{.}
#'  \item{`lag_first_by_penalty`.}{.}
#'  \item{`lag_first_by_penalty2`.}{.}
#'  \item{`first_by_yards`.}{.}
#'  \item{`lag_first_by_yards`.}{.}
#'  \item{`lag_first_by_yards2`.}{.}
#'  \item{`row`.}{.}
#'  \item{`new_series`.}{.}
#'  \item{`firstD_by_kickoff`.}{.}
#'  \item{`firstD_by_poss`.}{.}
#'  \item{`firstD_by_yards`.}{.}
#'  \item{`firstD_by_penalty`.}{.}
#'  \item{`yds_punted`.}{.}
#'  \item{`yds_punt_gained`.}{.}
#'  \item{`missing_yard_flag`.}{.}
#' }
#' @keywords internal
#' @importFrom rlang .data
#' @importFrom dplyr mutate arrange group_by case_when mutate_at ungroup n lag lead if_else
#' @export
#'

prep_epa_df_after <- function(dat) {
  ## --Play type vectors------
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
    "Interception",
    "Interception Return",
    "Interception Return Touchdown",
    "Pass Interception Return",
    "Pass Interception Return Touchdown",
    "Uncategorized Touchdown"
  )
  turnover_vec <- c(
    "Blocked Field Goal",
    "Blocked Field Goal Touchdown",
    "Blocked Punt",
    "Blocked Punt Touchdown",
    "Field Goal Missed",
    "Missed Field Goal Return",
    "Missed Field Goal Return Touchdown",
    "Fumble Recovery (Opponent)",
    "Fumble Recovery (Opponent) Touchdown",
    "Fumble Return Touchdown",
    "Defensive 2pt Conversion",
    "Interception",
    "Interception Return",
    "Interception Return Touchdown",
    "Pass Interception Return",
    "Pass Interception Return Touchdown",
    "Kickoff Team Fumble Recovery",
    "Kickoff Team Fumble Recovery Touchdown",
    "Punt Touchdown",
    "Punt Return Touchdown",
    "Sack Touchdown",
    "Uncategorized Touchdown"
  )
  normalplay <- c(
    "Rush",
    "Pass",
    "Pass Reception",
    "Pass Incompletion",
    "Pass Completion",
    "Sack"
  )
  penalty <- c(
    "Penalty",
    "Penalty (Kickoff)",
    "Penalty (Safety)"
  )
  offense_score_vec <- c(
    "Passing Touchdown",
    "Rushing Touchdown",
    "Field Goal Good",
    "Pass Reception Touchdown",
    "Fumble Recovery (Own) Touchdown",
    "Kickoff Return Touchdown",
    "Punt Touchdown",
    "Punt Team Fumble Recovery Touchdown"
  )
  defense_score_vec <- c(
    "Blocked Punt Touchdown",
    "Blocked Field Goal Touchdown",
    "Missed Field Goal Return Touchdown",
    "Punt Return Touchdown",
    "Fumble Recovery (Opponent) Touchdown",
    "Fumble Return Touchdown",
    "Defensive 2pt Conversion",
    "Safety",
    "Kickoff (Safety)",
    "Blocked Punt (Safety)",
    "Punt (Safety)",
    "Penalty (Safety)",
    "Sack Touchdown",
    "Interception Return Touchdown",
    "Pass Interception Return Touchdown",
    "Uncategorized Touchdown"
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
    dplyr::mutate_at(vars(.data$new_TimeSecsRem), ~ replace_na(., 0)) %>%
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
  dat$new_yardline[na_yd_line] <- dat$yard_line[na_yd_line + 1]
  neg_distance <- which(dat$new_distance < 0)
  dat$new_distance[neg_distance] <- dat$distance[neg_distance + 1]
  dat$new_log_ydstogo[neg_distance] <- log(dat$new_distance[neg_distance])

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


#' @rdname helpers_pbp
#'
#' @param drive_df (*data.frame* required) Drive dataframe pulled from API via the `cfbd_drives()` function
#' @details Cleans CFB (D-I) Drive-By-Drive Data to create `pts_drive` column. Requires the following columns be present:
#' \itemize{
#' \item{`drive_id`: Returned as `drive_id`}{.}
#' \item{`drive_result`: End result of the drive}{.}
#' \item{`scoring`: Logical flag for if drive was a scoring drive}{.}
#' \item{`game_id`: Unique game identifier}{.}
#' }
#' @return The original `drive_df` with the following columns appended to it:
#' \describe{
#' \item{`drive_id`: Returned as `drive_id` from original variable `drive_id`}{.}
#' \item{`pts_drive`: End result of the drive}{.}
#' \item{`scoring`: Logical flag for if drive was a scoring drive updated}{.}
#' }
#' @keywords internal
#' @importFrom rlang .data
#' @importFrom stringr str_detect
#' @importFrom dplyr mutate arrange case_when
#' @export
#'

clean_drive_info <- function(drive_df) {
  clean_drive <- drive_df %>%
    dplyr::mutate(
      pts_drive = dplyr::case_when(
        .data$drive_result == "TD" ~ 7,
        stringr::str_detect(.data$drive_result, "SF") ~ -2,
        .data$drive_result == "FG GOOD" ~ 3,
        .data$drive_result == "FG" ~ 3,
        .data$drive_result == "MISSED FG TD" ~ -7,
        .data$drive_result == "KICKOFF RETURN TD" ~ -7,
        .data$drive_result == "END OF HALF TD" ~ 7,
        .data$drive_result == "END OF GAME TD" ~ 7,
        .data$drive_result == "PUNT RETURN TD" ~ -7,
        .data$drive_result == "PUNT TD" ~ -7,
        .data$drive_result == "INT TD" ~ -7,
        .data$drive_result == "INT RETURN TOUCH" ~ -7,
        .data$drive_result == "FUMBLE RETURN TD" ~ -7,
        .data$drive_result == "FUMBLE TD" ~ -7,
        .data$drive_result == "DOWNS TD" ~ -7,
        stringr::str_detect(.data$drive_result, "TD") ~ 7,
        TRUE ~ 0
      ),
      scoring = ifelse(.data$pts_drive != 0, TRUE, .data$scoring)
    ) %>%
    dplyr::mutate(drive_id = as.numeric(.data$drive_id)) %>%
    dplyr::arrange(.data$game_id, .data$drive_id)

  return(clean_drive)
}
