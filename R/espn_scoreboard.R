#' **ESPN Scoreboard**
#' @name espn_cfb_scoreboard
NULL
#' Get live scoreboard data from ESPN or look up the college football schedule for a given season
#' @rdname espn_cfb_scoreboard
#'
#' @param date (*Integer* required - YYYYMMDD): Date to pull
#'
#' @return [espn_cfb_scoreboard()] & [espn_cfb_schedule()] - A data frame with 33 or 54 variables depending on if there are completed games:
#'  shared variables
#' \describe{
#'   \item{`matchup`: character.}{Long matchup description with full team names (Utah Utes at UCLA Bruins).}
#'   \item{`matchup_short`: character.}{Short matchup description with team abbreviations (UTAH @ UCLA).}
#'   \item{`season`: integer.}{Season of the game.}
#'   \item{`type`: character.}{Season type of the game in CFBD format.}
#'   \item{`slug`: character.}{Season type of the game in ESPN format.}
#'   \item{`game_id`: character.}{Referencing game ID.}
#'   \item{`game_uid`: character.}{}
#'   \item{`game_date`: character.}{Game date.}
#'   \item{`attendance`: integer.}{Reported attendance at the game.}
#'   \item{`play_by_play_available`: logical}{}
#'   \item{`home_team_name`: character.}{Home team mascot name (Sun Devils).}
#'   \item{`home_team_logo`: character.}{Home team logo url.}
#'   \item{`home_team_abb`: character.}{Home team abbreviation (ASU).}
#'   \item{`home_team_id`: character.}{Home team ID.}
#'   \item{`home_team_location`: character.}{Home team name (Arizona State).}
#'   \item{`home_team_full`: character.}{Home team full name (Arizona State Sun Devils).}
#'   \item{`home_team_color`: character.}{Home team color.}
#'   \item{`home_score`: integer.}{Home team points.}
#'   \item{`home_win`: integer.}{1 if home team won, 0 if home team lost, NA if game is unfinished}
#'   \item{`home_record`: character}{Home team record.}
#'   \item{`away_team_name`: character.}{Away team mascot name (Sun Devils).}
#'   \item{`away_team_logo`: character.}{Away team logo url.}
#'   \item{`away_team_abb`: character.}{Away team abbreviation (ASU).}
#'   \item{`away_team_id`: character.}{Away team ID.}
#'   \item{`away_team_location`: character.}{Away team name (Arizona State).}
#'   \item{`away_team_full`: character.}{Away team full name (Arizona State Sun Devils).}
#'   \item{`away_team_color`: character.}{Away team color.}
#'   \item{`away_score`: integer.}{Away team points.}
#'   \item{`away_win`: integer.}{1 if away team won, 0 if home team lost, NA if game is unfinished}
#'   \item{`away_record`: character}{Away team record.}
#'   \item{`status_name`: character.}{Status of the game}
#'   \item{`start_date`: character.}{Game date.}
#' }
#' Unique variables when there are completed games
#' \describe{
#'   \item{`broadcast_market`: character.}{Broadcast market (typically "national" or NA)}
#'   \item{`broadcast_name`: character.}{Broadcast channel i.e. ESPN, ABC, FOX}
#'   \item{`passing_leader_yards`: numeric.}{Passing yards of game's passing leader}
#'   \item{`passing_leader_stat`: character.}{Stat line of game's passing leader}
#'   \item{`passing_leader_name`: character.}{Name of game's passing leader}
#'   \item{`passing_leader_shortname`: character.}{First initial and last name of game's passing leader}
#'   \item{`passing_leader_headshot`: character.}{Headshot url of game's passing leader}
#'   \item{`passing_leader_team_id`: character.}{Team ID of game's passing leader}
#'   \item{`passing_leader_pos`: character.}{Position of game's passing leader}
#'   \item{`rushing_leader_yards`: numeric.}{Passing yards of game's rushing leader}
#'   \item{`rushing_leader_stat`: character.}{Stat line of game's rushing leader}
#'   \item{`rushing_leader_name`: character.}{Name of game's rushing leader}
#'   \item{`rushing_leader_shortname`: character.}{First initial and last name of game's rushing leader}
#'   \item{`rushing_leader_headshot`: character.}{Headshot url of game's rushing leader}
#'   \item{`rushing_leader_team_id`: character.}{Team ID of game's rushing leader}
#'   \item{`rushing_leader_pos`: character.}{Position of game's rushing leader}
#'   \item{`receiving_leader_yards`: numeric.}{Passing yards of game's receiving leader}
#'   \item{`receiving_leader_stat`: character.}{Stat line of game's receiving leader}
#'   \item{`receiving_leader_name`: character.}{Name of game's receiving leader}
#'   \item{`receiving_leader_shortname`: character.}{First initial and last name of game's receiving leader}
#'   \item{`receiving_leader_headshot`: character.}{Headshot url of game's receiving leader}
#'   \item{`receiving_leader_team_id`: character.}{Team ID of game's receiving leader}
#'   \item{`receiving_leader_pos`: character.}{Position of game's receiving leader}
#' }
#' @keywords Scoreboard Data
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode URLdecode
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom stringr str_sub str_length
#' @import dplyr
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_scoreboard())
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

  espn_sched <- data.frame()
  tryCatch(
    expr = {

      res <- httr::RETRY("GET", url)
      raw_sched <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyDataFrame = FALSE, simplifyVector = FALSE, simplifyMatrix = FALSE)


      cfb_data <- raw_sched[["events"]] %>%
        tibble::tibble(data = .data$.) %>%
        tidyr::unnest_wider("data") %>%
        tidyr::unchop("competitions") %>%
        dplyr::select(
          -"id",
          -"uid",
          -"date",
          -"status") %>%
        tidyr::unnest_wider("competitions") %>%
        dplyr::rename(
          "matchup" = "name",
          "matchup_short" = "shortName",
          "game_id" = "id",
          "game_uid" = "uid",
          "game_date" = "date") %>%
        tidyr::hoist("status",
                     status_name = list("type", "name")) %>%
        dplyr::select(!dplyr::any_of(c("timeValid", "neutralSite", "conferenceCompetition","recent", "venue", "type"))) %>%
        tidyr::unnest_wider("season") %>%
        dplyr::rename("season" = "year") %>%
        dplyr::select(-dplyr::any_of("status"))

      cfb_data <- cfb_data %>%
        dplyr::mutate(
          game_date_time = lubridate::ymd_hm(substr(.data$game_date, 1, nchar(.data$game_date) - 1)) %>%
            lubridate::with_tz(tzone = "America/New_York"),
          game_date = as.Date(substr(.data$game_date_time, 1, 10)))

      cfb_data <- cfb_data %>%
        tidyr::hoist(
          "competitors",
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
                      away_score = as.integer(.data$away_score),
                      type = dplyr::case_when(type == 2 ~ "regular",
                                       type == 3 ~ "postseason",
                                       type == 4 ~ "off-season",
                                       TRUE ~ as.character(type)))

      if ("leaders" %in% names(cfb_data)) {
        schedule_out <- cfb_data %>%
          tidyr::hoist(
            "leaders",
            # passing
            passing_leader_yards = list(1, "leaders", 1, "value"),
            passing_leader_stat = list(1, "leaders", 1, "displayValue"),
            passing_leader_name = list(1, "leaders", 1, "athlete", "displayName"),
            passing_leader_shortname = list(1, "leaders", 1, "athlete", "shortName"),
            passing_leader_headshot = list(1, "leaders", 1, "athlete", "headshot"),
            passing_leader_team_id = list(1, "leaders", 1, "team", "id"),
            passing_leader_pos = list(1, "leaders", 1, "athlete", "position", "abbreviation"),
            # rushing
            rushing_leader_yards = list(2, "leaders", 1, "value"),
            rushing_leader_stat = list(2, "leaders", 1, "displayValue"),
            rushing_leader_name = list(2, "leaders", 1, "athlete", "displayName"),
            rushing_leader_shortname = list(2, "leaders", 1, "athlete", "shortName"),
            rushing_leader_headshot = list(2, "leaders", 1, "athlete", "headshot"),
            rushing_leader_team_id = list(2, "leaders", 1, "team", "id"),
            rushing_leader_pos = list(2, "leaders", 1, "athlete", "position", "abbreviation"),
            # receiving
            receiving_leader_yards = list(3, "leaders", 1, "value"),
            receiving_leader_stat = list(3, "leaders", 1, "displayValue"),
            receiving_leader_name = list(3, "leaders", 1, "athlete", "displayName"),
            receiving_leader_shortname = list(3, "leaders", 1, "athlete", "shortName"),
            receiving_leader_headshot = list(3, "leaders", 1, "athlete", "headshot"),
            receiving_leader_team_id = list(3, "leaders", 1, "team", "id"),
            receiving_leader_pos = list(3, "leaders", 1, "athlete", "position", "abbreviation")
          )

        if ("broadcasts" %in% names(schedule_out)) {
          schedule_out <- schedule_out %>%
            tidyr::hoist(
              "broadcasts",
              broadcast_market = list(1, "market"),
              broadcast_name = list(1, "names", 1)
            ) %>%
            dplyr::select(!where(is.list)) %>%
            janitor::clean_names()
        } else {
          schedule_out <- schedule_out %>%
            janitor::clean_names()
        }
      } else {
        schedule_out <- cfb_data %>%
          dplyr::select(!where(is.list)) %>%
          janitor::clean_names()
      }
      schedule_out %>%
        dplyr::mutate(
          highlights = ifelse('highlights' %in% names(.), highlights, NA)
        ) %>% 
        make_cfbfastR_data("Live Scoreboard Data from ESPN",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN scoreboard data available!"))
    },
    finally = {
    }
  )
}

#' ESPN Schedule
#' @rdname espn_cfb_scoreboard
#' @param year (int): Used to define different seasons. 2002 is the earliest available season.
#' @param week (int): Week of the schedule.
#' @param groups (string): Used to define different divisions. FBS or FCS.
#' @param season_type (string): "regular", "postseason", "off-season", or "both".
#' @param limit (int): number of records to return, default: 500.
#' 
#' @return [espn_cfb_schedule()] - A data frame with 8 variables:
#' \describe{
#'   \item{`matchup`: character.}{.}
#'   \item{`matchup_short`: character.}{.}
#'   \item{`season`: integer.}{.}
#'   \item{`type`: character.}{.}
#'   \item{`slug`: character.}{.}
#'   \item{`game_id`: character.}{.}
#'   \item{`game_uid`: character.}{.}
#'   \item{`game_date`: Date.}{.}
#'   \item{`attendance`: integer.}{.}
#'   \item{`date_valid`: logical.}{.}
#'   \item{`play_by_play_available`: logical.}{.}
#'   \item{`home_team_name`: character.}{.}
#'   \item{`home_team_logo`: character.}{.}
#'   \item{`home_team_abb`: character.}{.}
#'   \item{`home_team_id`: character.}{.}
#'   \item{`home_team_location`: character.}{.}
#'   \item{`home_team_full`: character.}{.}
#'   \item{`home_team_color`: character.}{.}
#'   \item{`home_score`: integer.}{.}
#'   \item{`home_win`: integer.}{.}
#'   \item{`home_record`: character.}{.}
#'   \item{`away_team_name`: character.}{.}
#'   \item{`away_team_logo`: character.}{.}
#'   \item{`away_team_abb`: character.}{.}
#'   \item{`away_team_id`: character.}{.}
#'   \item{`away_team_location`: character.}{.}
#'   \item{`away_team_full`: character.}{.}
#'   \item{`away_team_color`: character.}{.}
#'   \item{`away_score`: integer.}{.}
#'   \item{`away_win`: integer.}{.}
#'   \item{`away_record`: character.}{.}
#'   \item{`status_name`: character.}{.}
#'   \item{`start_date`: character.}{.}
#'   \item{`highlights`: logical.}{.}
#'   \item{`game_date_time`: datetime.}{.}
#' }
#' @keywords Schedule Data
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode URLdecode
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom stringr str_sub str_length
#' @importFrom lubridate ymd_hm with_tz
#' @import dplyr
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_schedule(2021, week = 8))
#' }

espn_cfb_schedule <- function(year=NULL, week=NULL, season_type=NULL, groups=NULL, limit=500){

  validate_year(year)
  validate_week(week)

  if (is.null(week)) {
    week = ''
  } else {
    week = paste0('&week=',week)
  }
  if (is.null(year)) {
    year <- ''
  } else {
    year <- paste0('&dates=',year)
  }
  if (is.null(season_type)) {
    season_type <- ''
  } else {
    if (season_type %in% c("regular","postseason","off-season","both")) {
      season_type <- dplyr::case_when(
        season_type=="regular" ~ "2",
        season_type=="postseason" ~ "3",
        season_type=="off-season" ~ "4",
        season_type=="both" ~ ''
      )
    } else {
      cli::cli_abort("Enter valid season_type (String): regular, postseason, or both")
    }
    season_type <- paste0('&seasontype=',season_type)
  }
  if (is.null(groups)) {
    groups <- '&groups=80'
  } else {
    if (tolower(groups) %in% c("fbs","fcs")) {
      groups <- dplyr::case_when(tolower(groups) == "fbs" ~ 80,
                                 tolower(groups) == "fcs" ~ 81)
    } else {
      cli::cli_abort("Enter valid group (String): FBS or FCS")
    }
    groups <- paste0('&groups=',groups)
  }
  url <- paste0( "http://site.api.espn.com/apis/site/v2/sports/football/college-football/scoreboard?limit=",
                 limit, groups, year, week, season_type)


  schedule_out <- data.frame()

  tryCatch(
    expr = {

      res <- httr::RETRY("GET", url)

      raw_sched <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyDataFrame = FALSE, simplifyVector = FALSE, simplifyMatrix = FALSE)


      cfb_data <- raw_sched[["events"]] %>%
        tibble::tibble(data = .data$.) %>%
        tidyr::unnest_wider("data") %>%
        tidyr::unchop("competitions") %>%
        dplyr::select(
          -"id",
          -"uid",
          -"date",
          -"status") %>%
        tidyr::unnest_wider("competitions") %>%
        dplyr::rename(
          "matchup" = "name",
          "matchup_short" = "shortName",
          "game_id" = "id",
          "game_uid" = "uid",
          "game_date" = "date") %>%
        tidyr::hoist("status",
                     status_name = list("type", "name")) %>%
        dplyr::select(!dplyr::any_of(c("timeValid", "neutralSite", "conferenceCompetition","recent", "venue", "type"))) %>%
        tidyr::unnest_wider("season") %>%
        dplyr::rename("season" = "year") %>%
        dplyr::select(-dplyr::any_of("status"))

      cfb_data <- cfb_data %>%
        dplyr::mutate(
          game_date_time = lubridate::ymd_hm(substr(.data$game_date, 1, nchar(.data$game_date) - 1)) %>%
            lubridate::with_tz(tzone = "America/New_York"),
          game_date = as.Date(substr(.data$game_date_time, 1, 10)))

      cfb_data <- cfb_data %>%
        tidyr::hoist(
          "competitors",
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
                      away_score = as.integer(.data$away_score),
                      type = dplyr::case_when(type == 2 ~ "regular",
                                       type == 3 ~ "postseason",
                                       type == 4 ~ "off-season",
                                       TRUE ~ as.character(type)))


      if("leaders" %in% names(cfb_data)){
        schedule_out <- cfb_data %>%
          tidyr::hoist(
            "leaders",
            # passing
            passing_leader_yards = list(1, "leaders", 1, "value"),
            passing_leader_stat = list(1, "leaders", 1, "displayValue"),
            passing_leader_name = list(1, "leaders", 1, "athlete", "displayName"),
            passing_leader_shortname = list(1, "leaders", 1, "athlete", "shortName"),
            passing_leader_headshot = list(1, "leaders", 1, "athlete", "headshot"),
            passing_leader_team_id = list(1, "leaders", 1, "team", "id"),
            passing_leader_pos = list(1, "leaders", 1, "athlete", "position", "abbreviation"),
            # rushing
            rushing_leader_yards = list(2, "leaders", 1, "value"),
            rushing_leader_stat = list(2, "leaders", 1, "displayValue"),
            rushing_leader_name = list(2, "leaders", 1, "athlete", "displayName"),
            rushing_leader_shortname = list(2, "leaders", 1, "athlete", "shortName"),
            rushing_leader_headshot = list(2, "leaders", 1, "athlete", "headshot"),
            rushing_leader_team_id = list(2, "leaders", 1, "team", "id"),
            rushing_leader_pos = list(2, "leaders", 1, "athlete", "position", "abbreviation"),
            # receiving
            receiving_leader_yards = list(3, "leaders", 1, "value"),
            receiving_leader_stat = list(3, "leaders", 1, "displayValue"),
            receiving_leader_name = list(3, "leaders", 1, "athlete", "displayName"),
            receiving_leader_shortname = list(3, "leaders", 1, "athlete", "shortName"),
            receiving_leader_headshot = list(3, "leaders", 1, "athlete", "headshot"),
            receiving_leader_team_id = list(3, "leaders", 1, "team", "id"),
            receiving_leader_pos = list(3, "leaders", 1, "athlete", "position", "abbreviation"),
          )

        if("broadcasts" %in% names(schedule_out)) {
          schedule_out <- schedule_out %>%
            tidyr::hoist(
              "broadcasts",
              broadcast_market = list(1, "market"),
              broadcast_name = list(1, "names", 1)
            ) %>%
            dplyr::select(!where(is.list)) %>%
            janitor::clean_names()
        } else {
          schedule_out <- schedule_out %>%
            janitor::clean_names()
        }
      } else {
        schedule_out <- cfb_data %>%
          dplyr::select(!where(is.list)) %>%
          janitor::clean_names()
      }
      schedule_out <- schedule_out %>%
        dplyr::mutate(
          highlights = ifelse('highlights' %in% names(.), highlights, NA)
        ) %>% 
        make_cfbfastR_data("Schedule Data from ESPN",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: invalid input or no ESPN schedule data available!"))
    },
    finally = {
    }
  )
  return(schedule_out)
}

#' ESPN Calendar
#'
#' look up the men's college football calendar for a given season
#'
#' @param year (int): Used to define different seasons. 2002 is the earliest available season.
#' @param groups (string): Used to define different divisions. FBS or FCS.
#'
#' @return [espn_cfb_calendar()] - A data frame with 8 variables:
#' \describe{
#'   \item{`season`: character.}{.}
#'   \item{`season_type`: character.}{.}
#'   \item{`label`: character.}{.}
#'   \item{`alternate_label`: character.}{.}
#'   \item{`detail`: character.}{.}
#'   \item{`week`: character.}{.}
#'   \item{`start_date`: character.}{.}
#'   \item{`end_date`: character.}{.}
#' }
#' @keywords Schedule Data
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom tidyr unnest unnest_wider
#' @import dplyr
#' @export
#' @examples
#' \donttest{
#'   try(espn_cfb_calendar(2021))
#' }
espn_cfb_calendar <- function(year=NULL, groups=NULL){

  if(is.null(year)) {
    year <- ''
  } else {
    year <- paste0('&dates=',year)
  }
  if(is.null(groups)) {
    groups <- '&groups=80'
  } else {
    if (tolower(groups) %in% c("fbs","fcs")) {
      groups <- dplyr::case_when(tolower(groups) == "fbs" ~ 80,
                                 tolower(groups) == "fcs" ~ 81)
    } else {
      cli::cli_abort("Enter valid group (String): FBS or FCS")
    }
    groups <- paste0('&groups=',groups)
  }
  url <- paste0( "http://site.api.espn.com/apis/site/v2/sports/football/college-football/scoreboard?",
                 year, groups)

  calendar_out <- data.frame()
  tryCatch(
    expr = {

      res <- httr::RETRY("GET", url)

      # Check the result
      check_status(res)

      raw_cal <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(simplifyDataFrame = FALSE, simplifyVector = FALSE, simplifyMatrix = FALSE)

      calendar_out <- raw_cal[["leagues"]] %>%
        tibble::tibble(data = .data$.) %>%
        tidyr::unnest_wider("data") %>%
        tidyr::unnest("calendar") %>%
        tidyr::unnest_wider("calendar") %>%
        tidyr::unnest("entries") %>%
        dplyr::rename("season_type" = "label")

      calendar_out$season <- substr(calendar_out$calendarStartDate[1],1,4)

      calendar_out <- calendar_out %>%
        dplyr::select(
          "season",
          "season_type",
          "entries") %>%
        tidyr::unnest_wider("entries") %>%
        janitor::clean_names() %>%
        dplyr::rename("week" = "value")

      calendar_out <- calendar_out %>%
        make_cfbfastR_data("Calendar Data from ESPN",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: invalid input or no ESPN calendar available!"))
    },
    finally = {
    }
  )
  return(calendar_out)
}
