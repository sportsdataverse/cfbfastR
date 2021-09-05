#' **ESPN Scoreboard**
#' @name espn_cfb_scoreboard
NULL
#' Get live scoreboard data from ESPN
#' @rdname espn_cfb_scoreboard
#'
#' @param date (*Integer* required - YYYYMMDD): Date to pull 
#'
#' @return [espn_cfb_scoreboard()]
#' @keywords Scoreboard Data
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode URLdecode
#' @importFrom assertthat assert_that
#' @importFrom janitor clean_names
#' @importFrom stringr str_sub str_length
#' @import dplyr
#' @export
#' @examples
#' \donttest{
#' espn_cfb_scoreboard()
#' }
#'
espn_cfb_scoreboard <- function(date = NULL) {
  
  if (!is.null(date) && !is.numeric(date)) {
    # Check if game_id is numeric, if not NULL
    cli::cli_abort("Enter valid date as a number (YYYYMMDD)")
  }
  
  espn_date <- date
  url = paste0("http://site.api.espn.com/apis/site/v2/sports/football/college-football/scoreboard?limit=150",
               "&groups=", 80,
               "&dates=",date)
  res <- httr::RETRY("GET", url)
  espn_sched <- data.frame()
  
  tryCatch(
    expr = {
      raw_sched <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyDataFrame = FALSE, simplifyVector = FALSE, simplifyMatrix = FALSE)
      
      
      cfb_data <- raw_sched[["events"]] %>%
        tibble::tibble(data = .data$.) %>%
        tidyr::unnest_wider(.data$data) %>%
        tidyr::unchop(.data$competitions) %>%
        dplyr::select(-.data$id, -.data$uid, -.data$date, -.data$status) %>%
        tidyr::unnest_wider(.data$competitions) %>%
        dplyr::rename(matchup = .data$name, matchup_short = .data$shortName, game_id = .data$id, game_uid = .data$uid, game_date = .data$date) %>%
        tidyr::hoist(.data$status,
                     status_name = list("type", "name")) %>%
        dplyr::select(!dplyr::any_of(c("timeValid", "neutralSite", "conferenceCompetition","recent", "venue", "type"))) %>%
        tidyr::unnest_wider(.data$season) %>%
        dplyr::rename(season = .data$year) %>%
        dplyr::select(-dplyr::any_of("status")) %>%
        tidyr::hoist(
          .data$competitors,
          home_team_name = list(1, "team", "name"),
          home_team_logo = list(1, "team", "logo"),
          home_team_abb = list(1, "team", "abbreviation"),
          home_team_id = list(1, "team", "id"),
          home_team_location = list(1, "team", "location"),
          home_team_full = list(1, "team", "displayName"),
          home_team_color = list(1, "team", "color"),
          home_score = list(1, "score"),
          home_win = list(1, "winner"),
          home_record = list(1, "records", 1, "summary"),
          # away team
          away_team_name = list(2, "team", "name"),
          away_team_logo = list(2, "team", "logo"),
          away_team_abb = list(2, "team", "abbreviation"),
          away_team_id = list(2, "team", "id"),
          away_team_location = list(2, "team", "location"),
          away_team_full = list(2, "team", "displayName"),
          away_team_color = list(2, "team", "color"),
          away_score = list(2, "score"),
          away_win = list(2, "winner"),
          away_record = list(2, "records", 1, "summary"),
        ) %>%
        dplyr::mutate(home_win = as.integer(.data$home_win),
                      away_win = as.integer(.data$away_win),
                      home_score = as.integer(.data$home_score),
                      away_score = as.integer(.data$away_score))
      
      if("leaders" %in% names(cfb_data)){
        schedule_out <- cfb_data %>%
          tidyr::hoist(
            .data$leaders,
            # points
            points_leader_points = list(1, "leaders", 1, "value"),
            points_leader_stat = list(1, "leaders", 1, "displayValue"),
            points_leader_name = list(1, "leaders", 1, "athlete", "displayName"),
            points_leader_shortname = list(1, "leaders", 1, "athlete", "shortName"),
            points_leader_headshot = list(1, "leaders", 1, "athlete", "headshot"),
            points_leader_team_id = list(1, "leaders", 1, "team", "id"),
            points_leader_pos = list(1, "leaders", 1, "athlete", "position", "abbreviation"),
            # rebounds
            rebounds_leader_rebounds = list(2, "leaders", 1, "value"),
            rebounds_leader_stat = list(2, "leaders", 1, "displayValue"),
            rebounds_leader_name = list(2, "leaders", 1, "athlete", "displayName"),
            rebounds_leader_shortname = list(2, "leaders", 1, "athlete", "shortName"),
            rebounds_leader_headshot = list(2, "leaders", 1, "athlete", "headshot"),
            rebounds_leader_team_id = list(2, "leaders", 1, "team", "id"),
            rebounds_leader_pos = list(2, "leaders", 1, "athlete", "position", "abbreviation"),
            # assists
            assists_leader_assists = list(3, "leaders", 1, "value"),
            assists_leader_stat = list(3, "leaders", 1, "displayValue"),
            assists_leader_name = list(3, "leaders", 1, "athlete", "displayName"),
            assists_leader_shortname = list(3, "leaders", 1, "athlete", "shortName"),
            assists_leader_headshot = list(3, "leaders", 1, "athlete", "headshot"),
            assists_leader_team_id = list(3, "leaders", 1, "team", "id"),
            assists_leader_pos = list(3, "leaders", 1, "athlete", "position", "abbreviation"),
          )
        
        if("broadcasts" %in% names(schedule_out)) {
          schedule_out %>%
            tidyr::hoist(
              .data$broadcasts,
              broadcast_market = list(1, "market"),
              broadcast_name = list(1, "names", 1)
            ) %>%
            dplyr::select(!where(is.list)) %>%
            janitor::clean_names()
        } else {
          schedule_out %>%
            janitor::clean_names()
        }
      } else {
        cfb_data %>% dplyr::select(!where(is.list)) %>%
          janitor::clean_names()
      }
      
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: game_id '{espn_game_id}' invalid or no ESPN win probability data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
}
