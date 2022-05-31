
#' Get ESPN college football PBP data
#' @author Saiem Gilani
#' @param game_id Game ID
#' @param epa_wpa Logical parameter (TRUE/FALSE) to return the Expected Points Added/Win Probability Added variables
#' @keywords CFB PBP
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom dplyr filter select rename bind_cols bind_rows
#' @importFrom tidyr unnest unnest_wider everything
#' @export
#'
#' @examples
#'  \donttest{
#'    try(espn_cfb_pbp(game_id = 401282614))
#'  }
#'
espn_cfb_pbp <- function(game_id, epa_wpa = FALSE){
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old))

  play_base_url <- "http://site.api.espn.com/apis/site/v2/sports/football/college-football/summary?"

  ## Inputs
  ## game_id
  full_url <- paste0(play_base_url,
                     "event=", game_id)

  tryCatch(
    expr = {

      res <- httr::RETRY("GET", full_url)

      # Check the result
      check_status(res)

      resp <- res %>%
        httr::content(as = "text", encoding = "UTF-8")

      raw_df <- jsonlite::fromJSON(resp)
      playByPlaySource = raw_df[["header"]][["competitions"]][["playByPlaySource"]]
      raw_play_df <- jsonlite::fromJSON(jsonlite::toJSON(raw_df),flatten=TRUE)
      plays_df <- data.frame()
      #---- Play-by-Play ------
      if(playByPlaySource == 'full'){
        drives <- raw_play_df[["drives"]]
        plays_prev <- data.frame()
        plays_curr <- data.frame()
        if("previous" %in% names(drives)){
          drives_previous <- drives[["previous"]]

          colnames(drives_previous)[1:8] <- paste0("drive_", colnames(drives_previous)[1:8])
          colnames(drives_previous)[10:25] <- paste0("drive_", colnames(drives_previous)[10:25])
          drive_nums <- c(1:nrow(drives_previous))

          drives_prev <- purrr::map_df(drive_nums, function(x){
            drives_previous[x,"drive_team.logo"]<- drives_previous$drive_team.logos[[x]]$href[1]
            drives_previous[x,"drive_team.logo_dark"]<- drives_previous$drive_team.logos[[x]]$href[2]
            df <- drives_previous[x,] %>%
              tidyr::unnest_longer('plays')
            return(df)
          })
          plays_prev <- jsonlite::fromJSON(jsonlite::toJSON(drives_prev),flatten=TRUE)
        }
        if("current" %in% names(drives)){
          drives_current <- drives[["current"]]

          colnames(drives_current)[1:8] <- paste0("drive_", colnames(drives_current)[1:8])
          colnames(drives_current)[10:25] <- paste0("drive_", colnames(drives_current)[10:25])
          drive_nums_cur <- c(1:nrow(drives_current))
          drives_curr <- purrr::map_df(drive_nums_cur, function(x){
            drives_current[x,"drive_team.logo"]<- drives_current$drive_team.logos[[x]]$href[1]
            drives_current[x,"drive_team.logo_dark"]<- drives_current$drive_team.logos[[x]]$href[2]
            df <- drives_current[x,] %>%
              tidyr::unnest_longer('plays')
            return(df)
          })
          plays_curr <- jsonlite::fromJSON(jsonlite::toJSON(drives_curr),flatten=TRUE)
        }

        plays_df <- plays_curr %>%
          dplyr::bind_rows(plays_prev) %>%
          janitor::clean_names() %>%
          dplyr::select(-.data$drive_team_logos)

      }
      plays_df$season <- raw_df[['header']][['season']][['year']]
      plays_df$season_type <- raw_df[['header']][['season']][['type']]
      plays_df$week <- raw_df[['header']][['week']]
      plays_df$neutral_site <- raw_df[['header']][['competitions']][['neutralSite']]
      plays_df$conference_competition <- raw_df[['header']][['competitions']][['conferenceCompetition']]
      plays_df$game_date <- raw_df[['header']][['competitions']][['date']]
      competitors <- jsonlite::fromJSON(jsonlite::toJSON(raw_df[['header']][['competitions']][['competitors']][[1]]),flatten=TRUE)
      plays_df$home_team_id <- (competitors %>% dplyr::filter(.data$homeAway =='home'))[['id']]
      plays_df$home_team_name <- (competitors %>% dplyr::filter(.data$homeAway =='home'))[['team.name']]
      plays_df$home_team <- (competitors %>% dplyr::filter(.data$homeAway =='home'))[['team.location']]
      plays_df$home_team_abbreviation <- (competitors %>% dplyr::filter(.data$homeAway =='home'))[['team.abbreviation']]
      plays_df$home_team_color <- (competitors %>% dplyr::filter(.data$homeAway =='home'))[['team.color']]
      plays_df$home_team_alternate_color <- (competitors %>% dplyr::filter(.data$homeAway =='home'))[['team.alternateColor']]
      plays_df$home_team_rank <- (competitors %>% dplyr::filter(.data$homeAway =='home'))[['rank']]
      plays_df$away_team_id <- (competitors %>% dplyr::filter(.data$homeAway =='away'))[['id']]
      plays_df$away_team_name <- (competitors %>% dplyr::filter(.data$homeAway =='away'))[['team.name']]
      plays_df$away_team <- (competitors %>% dplyr::filter(.data$homeAway =='away'))[['team.location']]
      plays_df$away_team_abbreviation <- (competitors %>% dplyr::filter(.data$homeAway =='away'))[['team.abbreviation']]
      plays_df$away_team_color <- (competitors %>% dplyr::filter(.data$homeAway =='away'))[['team.color']]
      plays_df$away_team_alternate_color <- (competitors %>% dplyr::filter(.data$homeAway =='away'))[['team.alternateColor']]
      plays_df$away_team_rank <- (competitors %>% dplyr::filter(.data$homeAway =='away'))[['rank']]

      # #---- Pickcenter ------
      # pickcenter <- raw_df[['pickcenter']]

      if (isTRUE(epa_wpa)) {
        plays_df <- plays_df %>%
          dplyr::rename(
            play_text = .data$plays_text,
            play_type = .data$plays_type_text,
            down = .data$plays_start_down,
            distance = .data$plays_start_distance,
            period = .data$plays_period_number,
            id_play = .data$plays_id,
            home = .data$home_team,
            away = .data$away_team,
            yards_to_goal = .data$plays_start_yards_to_endzone,
            yards_gained = .data$plays_stat_yardage,
            yard_line = .data$plays_start_yard_line
          ) %>%
          dplyr::mutate(
            game_id = game_id,
            clock.minutes = as.numeric(stringr::str_extract(.data$plays_clock_display_value,".*(?=:)")),
            clock.seconds = as.numeric(stringr::str_extract(.data$plays_clock_display_value,"(?<=:).*")),
            offense_play = case_when(.data$plays_start_team_id == .data$home_team_id ~ .data$home,
                                     TRUE ~ .data$away),
            defense_play = case_when(.data$plays_start_team_id == .data$home_team_id ~ .data$home,
                                     TRUE ~ .data$away),
            offense_score = dplyr::case_when(.data$offense_play == .data$home ~ .data$plays_home_score,
                                             TRUE ~ .data$plays_away_score),
            defense_score = dplyr::case_when(.data$offense_play == .data$home ~ .data$plays_away_score,
                                             TRUE ~ .data$plays_home_score),
            half = dplyr::case_when(period <= 2 ~ 1,
                                    period <= 4 ~ 2,
                                    TRUE ~ period - 2),
            drive_start_field_side = str_remove(.data$drive_start_text," [0-9]{1,2}"),
            drive_start_yards_to_goal = ifelse(.data$drive_start_field_side == .data$home_team_abbreviation,
                                               100 - .data$drive_start_yard_line,
                                               .data$drive_start_yard_line),
            drive_end_field_side = str_remove(.data$drive_end_text," [0-9]{1,2}"),
            drive_end_yards_to_goal = ifelse(.data$drive_end_field_side == .data$home_team_abbreviation,
                                             100 - .data$drive_end_yard_line,
                                             .data$drive_end_yard_line),
            drive_number = cumsum(!duplicated(.data$drive_id)),
            ppa = NA_real_ #ppa is from CFBD but is coded into a select in the EPA functions so needs a placeholder
          ) %>%
          #Timeout handling
          dplyr::group_by(.data$half) %>%
          dplyr::mutate(
            timeout_team = stringr::str_extract(.data$play_text,"(?<=Timeout ).{1,10}(?=,)"),
            home_timeouts = 3-cumsum(dplyr::case_when(.data$timeout_team == .data$home_team_abbreviation ~ 1,TRUE ~0)),
            away_timeouts = 3-cumsum(dplyr::case_when(.data$timeout_team == .data$away_team_abbreviation ~ 1,TRUE ~0)),
            offense_timeouts = dplyr::case_when(.data$offense_play == .data$home ~ .data$home_timeouts,
                                                TRUE ~ .data$away_timeouts),
            defense_timeouts = dplyr::case_when(.data$offense_play == .data$home ~ .data$away_timeouts,
                                                TRUE ~ .data$home_timeouts)
          ) %>%
          dplyr::ungroup() %>%
          penalty_detection() %>%
          add_play_counts() %>%
          clean_pbp_dat() %>%
          clean_drive_dat() %>%
          add_yardage() %>%
          add_player_cols() %>%
          prep_epa_df_after() %>%
          create_epa(ep_model = ep_model, fg_model = fg_model) %>%
          # create_wpa_betting() %>%
          create_wpa_naive(wp_model = wp_model) %>%
          dplyr::select(-.data$ppa) #drop placeholder column

      }
      plays_df <- plays_df %>%
        make_cfbfastR_data("Play-by-play data from ESPN.com",Sys.time())

    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no play-by-play data for {game_id} available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )

  return(plays_df)
}
