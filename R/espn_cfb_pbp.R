
#' Get ESPN college football PBP data
#' @author Saiem Gilani
#' @param game_id Game ID
#' @keywords CFB PBP
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom dplyr filter select rename bind_cols bind_rows
#' @importFrom tidyr unnest unnest_wider everything
#' @export
#'
#' @examples
#'
#'  espn_cfb_pbp(game_id = 401282614)
#'
espn_cfb_pbp <- function(game_id){
  options(stringsAsFactors = FALSE)
  options(scipen = 999)
  
  play_base_url <- "http://site.api.espn.com/apis/site/v2/sports/football/college-football/summary?"
  
  ## Inputs
  ## game_id
  full_url <- paste0(play_base_url,
                     "event=", game_id)
  
  res <- httr::RETRY("GET", full_url)
  
  # Check the result
  check_status(res)
  
  resp <- res %>%
    httr::content(as = "text", encoding = "UTF-8")
  
  tryCatch(
    expr = {
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