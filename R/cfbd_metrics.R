#' CFBD Metrics Endpoint
#'
#' @name cfbd_metrics
NULL
#' Get team game averages for Predicted Points Added (PPA)
#' @rdname cfbd_metrics
#'
#' @param year (\emph{Integer} required): Year, 4 digit format (\emph{YYYY})
#' @param week (\emph{Integer} optional): Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param team (\emph{String} optional): D-I Team
#' @param conference (\emph{String} optional): Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC\cr
#' @param excl_garbage_time (\emph{Logical} default FALSE): Select whether to exclude Garbage Time (TRUE or FALSE)
#'
#' @return \code{\link[cfbfastR:cfbd_metrics_ppa_games]{cfbfastR::cfbd_metrics_ppa_games()}} - A data frame with 18 variables:
#' \describe{
#'   \item{\code{game_id}}{integer.}
#'   \item{\code{season}}{integer.}
#'   \item{\code{week}}{integer.}
#'   \item{\code{conference}}{character.}
#'   \item{\code{team}}{character.}
#'   \item{\code{opponent}}{character.}
#'   \item{\code{off_overall}}{character.}
#'   \item{\code{off_passing}}{character.}
#'   \item{\code{off_rushing}}{character.}
#'   \item{\code{off_first_down}}{character.}
#'   \item{\code{off_second_down}}{character.}
#'   \item{\code{off_third_down}}{character.}
#'   \item{\code{def_overall}}{character.}
#'   \item{\code{def_passing}}{character.}
#'   \item{\code{def_rushing}}{character.}
#'   \item{\code{def_first_down}}{character.}
#'   \item{\code{def_second_down}}{character.}
#'   \item{\code{def_third_down}}{character.}
#' }
#' @keywords Teams Predicted Points
#' @importFrom attempt stop_if_all
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @export
#' @examples
#' \dontrun{
#'   cfbd_metrics_ppa_games(year = 2019, team = 'TCU')
#' }

cfbd_metrics_ppa_games <- function(year,
                                   week = NULL,
                                   team = NULL,
                                   conference = NULL,
                                   excl_garbage_time = FALSE){

  args <- list(year = year)

  # Check that at search_term input argument is not null
  attempt::stop_if_all(args, is.null,
                       msg = "You need to specify at least one argument:\nyear as an integer 4 digit format (YYYY)")

  ## check if year is numeric
  assertthat::assert_that(is.numeric(year) & nchar(year)==4,
                          msg = 'Enter valid year as integer in 4 digit format (YYYY)')

  if(!is.null(week)){
    # Check if week is numeric, if not NULL
    assertthat::assert_that(is.numeric(week) & nchar(week) <= 2,
                            msg = 'Enter valid week (Integer): 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)')
  }
  if(!is.null(team)){
    if(team == "San Jose State"){
      team = utils::URLencode(paste0("San Jos","\u00e9", " State"), reserved = TRUE)
    } else{
      # Encode team parameter for URL if not NULL
      team = utils::URLencode(team, reserved = TRUE)
    }
  }
  if(!is.null(conference)){
    # # Check conference parameter in conference abbreviations, if not NULL
    # assertthat::assert_that(conference %in% cfbfastR::cfbd_conf_types_df$abbreviation,
    #                         msg = "Incorrect conference abbreviation, potential misspelling.\nConference abbreviations P5: ACC, B12, B1G, SEC, PAC\nConference abbreviations G5 and Independents: CUSA, MAC, MWC, Ind, SBC, AAC")
    # Encode conference parameter for URL, if not NULL
    conference = utils::URLencode(conference, reserved = TRUE)
  }
  if(excl_garbage_time!=FALSE){
    # Check if excl_garbage_time is TRUE, if not FALSE
    assertthat::assert_that(excl_garbage_time==TRUE,
                            msg = 'Enter valid excl_garbage_time value (Logical) - TRUE or FALSE')
  }

  base_url <- "https://api.collegefootballdata.com/ppa/games?"

  full_url <- paste0(base_url,
                     "year=", year,
                     "&week=", week,
                     "&team=", team,
                     "&conference=", conference,
                     "&excludeGarbageTime=", excl_garbage_time)

  # Check for internet
  check_internet()

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  # Create the GET request and set response as res
  res <- httr::RETRY("GET", full_url,
                     httr::add_headers(Authorization = paste("Bearer", cfbd_key())))

  # Check the result
  check_status(res)

  df <- data.frame()
  tryCatch(
    expr = {
      # Get the content, flatten and return result as data.frame
      df = res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE)
      colnames(df) = gsub("offense.", "off_", colnames(df))
      colnames(df) = gsub("defense.", "def_", colnames(df))
      colnames(df) = gsub("Down", "_down", colnames(df))

      df <- df %>%
        dplyr::rename(game_id = .data$gameId) %>%
        as.data.frame()

      message(glue::glue("{Sys.time()}: Scraping CFBData metrics PPA games data..."))
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no CFBData metrics PPA games data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' Get team game averages for Predicted Points Added (PPA)
#' @rdname cfbd_metrics
#'
#' @param year (\emph{Integer} required): Year, 4 digit format (\emph{YYYY})
#' @param week (\emph{Integer} optional): Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param team (\emph{String} optional): D-I Team
#' @param conference (\emph{String} optional): Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC\cr
#' @param excl_garbage_time (\emph{Logical} default FALSE): Select whether to exclude Garbage Time (TRUE or FALSE)
#'
#' @return \code{\link[cfbfastR:cfbd_metrics_ppa_games]{cfbfastR::cfbd_metrics_ppa_games()}} - A data frame with 18 variables:
#' \describe{
#'   \item{\code{game_id}}{integer.}
#'   \item{\code{season}}{integer.}
#'   \item{\code{week}}{integer.}
#'   \item{\code{conference}}{character.}
#'   \item{\code{team}}{character.}
#'   \item{\code{opponent}}{character.}
#'   \item{\code{off_overall}}{character.}
#'   \item{\code{off_passing}}{character.}
#'   \item{\code{off_rushing}}{character.}
#'   \item{\code{off_first_down}}{character.}
#'   \item{\code{off_second_down}}{character.}
#'   \item{\code{off_third_down}}{character.}
#'   \item{\code{def_overall}}{character.}
#'   \item{\code{def_passing}}{character.}
#'   \item{\code{def_rushing}}{character.}
#'   \item{\code{def_first_down}}{character.}
#'   \item{\code{def_second_down}}{character.}
#'   \item{\code{def_third_down}}{character.}
#' }
#' @keywords Teams Predicted Points
#' @importFrom attempt stop_if_all
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @export
#' @examples
#' \dontrun{
#'   cfbd_metrics_ppa_games(year = 2019, team = 'TCU')
#' }

cfbd_metrics_ppa_games <- function(year,
                                   week = NULL,
                                   team = NULL,
                                   conference = NULL,
                                   excl_garbage_time = FALSE){

  args <- list(year = year)

  # Check that at search_term input argument is not null
  attempt::stop_if_all(args, is.null,
                       msg = "You need to specify at least one argument:\nyear as an integer 4 digit format (YYYY)")

  ## check if year is numeric
  assertthat::assert_that(is.numeric(year) & nchar(year)==4,
                          msg = 'Enter valid year as integer in 4 digit format (YYYY)')

  if(!is.null(week)){
    # Check if week is numeric, if not NULL
    assertthat::assert_that(is.numeric(week) & nchar(week) <= 2,
                            msg = 'Enter valid week (Integer): 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)')
  }
  if(!is.null(team)){
    if(team == "San Jose State"){
      team = utils::URLencode(paste0("San Jos","\u00e9", " State"), reserved = TRUE)
    } else{
      # Encode team parameter for URL if not NULL
      team = utils::URLencode(team, reserved = TRUE)
    }
  }
  if(!is.null(conference)){
    # # Check conference parameter in conference abbreviations, if not NULL
    # assertthat::assert_that(conference %in% cfbfastR::cfbd_conf_types_df$abbreviation,
    #                         msg = "Incorrect conference abbreviation, potential misspelling.\nConference abbreviations P5: ACC, B12, B1G, SEC, PAC\nConference abbreviations G5 and Independents: CUSA, MAC, MWC, Ind, SBC, AAC")
    # Encode conference parameter for URL, if not NULL
    conference = utils::URLencode(conference, reserved = TRUE)
  }
  if(excl_garbage_time!=FALSE){
    # Check if excl_garbage_time is TRUE, if not FALSE
    assertthat::assert_that(excl_garbage_time==TRUE,
                            msg = 'Enter valid excl_garbage_time value (Logical) - TRUE or FALSE')
  }

  base_url <- "https://api.collegefootballdata.com/ppa/games?"

  full_url <- paste0(base_url,
                     "year=", year,
                     "&week=", week,
                     "&team=", team,
                     "&conference=", conference,
                     "&excludeGarbageTime=", excl_garbage_time)

  # Check for internet
  check_internet()

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  # Create the GET request and set response as res
  res <- httr::RETRY("GET", full_url,
                     httr::add_headers(Authorization = paste("Bearer", cfbd_key())))

  # Check the result
  check_status(res)

  df <- data.frame()
  tryCatch(
    expr = {
      # Get the content, flatten and return result as data.frame
      df = res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE)
      colnames(df) = gsub("offense.", "off_", colnames(df))
      colnames(df) = gsub("defense.", "def_", colnames(df))
      colnames(df) = gsub("Down", "_down", colnames(df))

      df <- df %>%
        dplyr::rename(game_id = .data$gameId) %>%
        as.data.frame()

      message(glue::glue("{Sys.time()}: Scraping CFBData metrics PPA games data..."))
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no CFBData metrics PPA games data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}



#' Get player game averages for Predicted Points Added (PPA)
#' @rdname cfbd_metrics
#'
#' @param year (\emph{Integer} required): Year, 4 digit format (\emph{YYYY})
#' @param week (\emph{Integer} optional): Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param team (\emph{String} optional): D-I Team
#' @param position (\emph{string} optional): Position abbreviation of the player you are searching for.\cr
#' Position Group  - options include:\cr
#'  * Offense: QB, RB, FB, TE,  OL, G, OT, C, WR\cr
#'  * Defense: DB, CB, S, LB,  DE, DT, NT, DL\cr
#'  * Special Teams: K, P, LS, PK\cr
#' @param athlete_id (\emph{Integer} optional): Athlete ID filter for querying a single athlete\cr
#' Can be found using the \code{\link[cfbfastR:cfbd_player_info]{cfbfastR::cfbd_player_info()}} function.
#' @param threshold (\emph{Integer} optional): Minimum threshold of plays.
#' @param excl_garbage_time (\emph{Logical} default FALSE): Select whether to exclude Garbage Time (TRUE or FALSE)
#'
#' @return \code{\link[cfbfastR:cfbd_metrics_ppa_players_games]{cfbfastR::cfbd_metrics_ppa_players_games()}} - A data frame with 9 variables:
#' \describe{
#'   \item{\code{season}}{integer.}
#'   \item{\code{week}}{integer.}
#'   \item{\code{name}}{character.}
#'   \item{\code{position}}{character.}
#'   \item{\code{team}}{character.}
#'   \item{\code{opponent}}{character.}
#'   \item{\code{avg_PPA_all}}{double.}
#'   \item{\code{avg_PPA_pass}}{double.}
#'   \item{\code{avg_PPA_rush}}{double.}
#' }
#' @source \url{https://api.collegefootballdata.com/ppa/players/games}
#' @keywords Players Predicted Points
#' @importFrom attempt stop_if_all
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @export
#' @examples
#' \dontrun{
#'   cfbd_metrics_ppa_players_games(year = 2019,week=3, team = 'TCU')
#' }

cfbd_metrics_ppa_players_games <- function(year = NULL,
                                           week = NULL,
                                           team = NULL,
                                           position = NULL,
                                           athlete_id = NULL,
                                           threshold = NULL,
                                           excl_garbage_time = FALSE){

  # Position Group vector to check input arguments against
  pos_groups <- c('QB', 'RB', 'FB', 'TE', 'WR', 'OL', 'OT', 'G', 'OC',
                  'DB', 'CB', 'S', 'LB', 'DE', 'NT','DL', 'DT',
                  'K', 'P','PK','LS')


  if(!is.null(year)){
    ## check if year is numeric
    assertthat::assert_that(is.numeric(year) & nchar(year)==4,
                            msg = 'Enter valid year as integer in 4 digit format (YYYY)')
  }
  if(!is.null(week)){
    # Check if week is numeric, if not NULL
    assertthat::assert_that(is.numeric(week) & nchar(week) <= 2,
                            msg = 'Enter valid week (Integer): 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)')
  }
  if(!is.null(team)){
    if(team == "San Jose State"){
      team = utils::URLencode(paste0("San Jos","\u00e9", " State"), reserved = TRUE)
    } else{
      # Encode team parameter for URL if not NULL
      team = utils::URLencode(team, reserved = TRUE)
    }
  }
  if(!is.null(position)){
    ## check if position in position group set
    assertthat::assert_that(position %in% pos_groups,
                            msg = 'Enter valid position group\nOffense: QB, RB, FB, TE, WR,  OL, G, OT, C\nDefense: DB, CB, S, LB, DL, DE, DT, NT\nSpecial Teams: K, P, LS, PK')
  }
  if(!is.null(athlete_id)){
    # Check if athlete_id is numeric, if not NULL
    assertthat::assert_that(is.numeric(athlete_id),
                            msg = 'Enter valid athlete_id value (Integer)\nCan be found using the `cfbd_player_info()` function')
  }
  if(!is.null(threshold)){
    # Check if threshold is numeric, if not NULL
    assertthat::assert_that(is.numeric(threshold),
                            msg = 'Enter valid threshold value (Integer)')
  }
  if(excl_garbage_time!=FALSE){
    # Check if excl_garbage_time is TRUE, if not FALSE
    assertthat::assert_that(excl_garbage_time==TRUE,
                            msg = 'Enter valid excl_garbage_time value (Logical) - TRUE or FALSE')
  }

  base_url <- "https://api.collegefootballdata.com/ppa/players/games?"

  full_url <- paste0(base_url,
                     "year=", year,
                     "&week=", week,
                     "&team=", team,
                     "&position=", position,
                     "&playerId=", athlete_id,
                     "&threshold=", threshold,
                     "&excludeGarbageTime=", excl_garbage_time)

  # Check for internet
  check_internet()

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  # Create the GET request and set response as res
  res <- httr::RETRY("GET", full_url,
                     httr::add_headers(Authorization = paste("Bearer", cfbd_key())))

  # Check the result
  check_status(res)

  df <- data.frame()
  tryCatch(
    expr = {
      # Get the content, flatten and return result as data.frame
      df = res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE)
      colnames(df) = gsub("averagePPA.", "avg_PPA_", colnames(df))

      message(glue::glue("{Sys.time()}: Scraping CFBData metrics PPA game-level players data..."))
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no CFBData metrics PPA game-level players data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}



#' Get player season averages for Predicted Points Added (PPA)
#' @rdname cfbd_metrics
#'
#' @param year (\emph{Integer} required): Year, 4 digit format (\emph{YYYY})
#' @param team (\emph{String} optional): D-I Team
#' @param conference (\emph{String} optional): Conference abbreviation - S&P+ information by conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC\cr
#' @param position (\emph{string} optional): Position abbreviation of the player you are searching for.\cr
#' Position Group  - options include:\cr
#'  * Offense: QB, RB, FB, TE,  OL, G, OT, C, WR\cr
#'  * Defense: DB, CB, S, LB,  DE, DT, NT, DL\cr
#'  * Special Teams: K, P, LS, PK\cr
#' @param athlete_id (\emph{Integer} optional): Athlete ID filter for querying a single athlete\cr
#' Can be found using the \code{\link[cfbfastR:cfbd_player_info]{cfbfastR::cfbd_player_info()}} function.
#' @param threshold (\emph{Integer} optional): Minimum threshold of plays.
#' @param excl_garbage_time (\emph{Logical} default FALSE): Select whether to exclude Garbage Time (TRUE or FALSE)
#'
#' @return \code{\link[cfbfastR:cfbd_metrics_ppa_players_season]{cfbfastR::cfbd_metrics_ppa_players_season()}} - A data frame with 23 variables:
#' \describe{
#'   \item{\code{season}}{integer.}
#'   \item{\code{id}}{character.}
#'   \item{\code{name}}{character.}
#'   \item{\code{position}}{character.}
#'   \item{\code{team}}{character.}
#'   \item{\code{conference}}{character.}
#'   \item{\code{countable_plays}}{integer.}
#'   \item{\code{avg_PPA_all}}{double.}
#'   \item{\code{avg_PPA_pass}}{double.}
#'   \item{\code{avg_PPA_rush}}{double.}
#'   \item{\code{avg_PPA_first_down}}{double.}
#'   \item{\code{avg_PPA_second_down}}{double.}
#'   \item{\code{avg_PPA_third_down}}{double.}
#'   \item{\code{avg_PPA_standard_downs}}{double.}
#'   \item{\code{avg_PPA_passing_downs}}{double.}
#'   \item{\code{total_PPA_all}}{double.}
#'   \item{\code{total_PPA_pass}}{double.}
#'   \item{\code{total_PPA_rush}}{double.}
#'   \item{\code{total_PPA_first_down}}{double.}
#'   \item{\code{total_PPA_second_down}}{double.}
#'   \item{\code{total_PPA_third_down}}{double.}
#'   \item{\code{total_PPA_standard_downs}}{double.}
#'   \item{\code{total_PPA_passing_downs}}{double.}
#' }
#' @source \url{https://api.collegefootballdata.com/ppa/players/season}
#' @keywords Players Predicted Points Season Averages
#' @importFrom attempt stop_if_all
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @export
#' @examples
#' \dontrun{
#'   cfbd_metrics_ppa_players_season(year = 2019, team = 'TCU')
#' }

cfbd_metrics_ppa_players_season <- function(year = NULL,
                                            team = NULL,
                                            conference = NULL,
                                            position = NULL,
                                            athlete_id = NULL,
                                            threshold = NULL,
                                            excl_garbage_time = FALSE){

  # Position Group vector to check input arguments against
  pos_groups <- c('QB', 'RB', 'FB', 'TE', 'WR', 'OL', 'OT', 'G', 'OC',
                  'DB', 'CB', 'S', 'LB', 'DE', 'NT','DL', 'DT',
                  'K', 'P','PK','LS')

  if(!is.null(year)){
    ## check if year is numeric
    assertthat::assert_that(is.numeric(year) & nchar(year)==4,
                            msg = 'Enter valid year as integer in 4 digit format (YYYY)')
  }
  if(!is.null(team)){
    if(team == "San Jose State"){
      team = utils::URLencode(paste0("San Jos","\u00e9", " State"), reserved = TRUE)
    } else{
      # Encode team parameter for URL if not NULL
      team = utils::URLencode(team, reserved = TRUE)
    }
  }
  if(!is.null(conference)){
    # # Check conference parameter in conference abbreviations, if not NULL
    # assertthat::assert_that(conference %in% cfbfastR::cfbd_conf_types_df$abbreviation,
    #             msg = "Incorrect conference abbreviation, potential misspelling.\nConference abbreviations P5: ACC, B12, B1G, SEC, PAC\nConference abbreviations G5 and Independents: CUSA, MAC, MWC, Ind, SBC, AAC")
    # Encode conference parameter for URL, if not NULL
    conference = utils::URLencode(conference, reserved = TRUE)
  }
  if(!is.null(position)){
    ## check if position in position group set
    assertthat::assert_that(position %in% pos_groups,
                            msg = 'Enter valid position group\nOffense: QB, RB, FB, TE, WR,  OL, G, OT, C\nDefense: DB, CB, S, LB, DL, DE, DT, NT\nSpecial Teams: K, P, LS, PK')
  }
  if(!is.null(athlete_id)){
    # Check if athlete_id is numeric, if not NULL
    assertthat::assert_that(is.numeric(athlete_id),
                            msg = 'Enter valid athlete_id value (Integer)\nCan be found using the `cfbd_player_info()` function')
  }
  if(!is.null(threshold)){
    # Check if threshold is numeric, if not NULL
    assertthat::assert_that(is.numeric(threshold),
                            msg = 'Enter valid threshold value (Integer)')
  }
  if(excl_garbage_time!=FALSE){
    # Check if excl_garbage_time is TRUE, if not FALSE
    assertthat::assert_that(excl_garbage_time==TRUE,
                            msg = 'Enter valid excl_garbage_time value (Logical) - TRUE or FALSE')
  }

  base_url <- "https://api.collegefootballdata.com/ppa/players/season?"

  full_url <- paste0(base_url,
                     "year=", year,
                     "&team=", team,
                     "&conference", conference,
                     "&position=", position,
                     "&playerId=", athlete_id,
                     "&threshold=", threshold,
                     "&excludeGarbageTime=", excl_garbage_time)

  # Check for internet
  check_internet()

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  # Create the GET request and set response as res
  res <- httr::RETRY("GET", full_url,
                     httr::add_headers(Authorization = paste("Bearer", cfbd_key())))

  # Check the result
  check_status(res)

  df <- data.frame()
  tryCatch(
    expr = {
      # Get the content, flatten and return result as data.frame
      df = res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE)
      colnames(df) = gsub("averagePPA.", "avg_PPA_", colnames(df))
      colnames(df) = gsub("totalPPA.", "total_PPA_", colnames(df))
      colnames(df) = gsub("countablePlays", "countable_plays", colnames(df))
      colnames(df) = gsub("Down", "_down", colnames(df))

      df <- df %>%
        dplyr::arrange(-.data$countable_plays) %>%
        as.data.frame()

      message(glue::glue("{Sys.time()}: Scraping CFBData metrics PPA season-level players data..."))
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no CFBData metrics PPA season-level players data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}



#' Calculate Predicted Points using Down and Distance
#' @rdname cfbd_metrics
#'
#' @param down (\emph{Integer} required): Down filter
#' @param distance (\emph{Integer} required): Distance filter
#'
#' @return \code{\link[cfbfastR:cfbd_metrics_ppa_predicted]{cfbfastR::cfbd_metrics_ppa_predicted()}} - A data frame with 2 variables:
#' \describe{
#'   \item{\code{yard_line}}{integer.}
#'   \item{\code{predicted_points}}{character.}
#' }
#' @source \url{https://api.collegefootballdata.com/ppa/predicted}
#' @keywords Predicted Points
#' @importFrom attempt stop_if_any
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @export
#' @examples
#' \dontrun{
#'   cfbd_metrics_ppa_predicted(down = 1, distance = 10)
#'
#'   cfbd_metrics_ppa_predicted(down = 3, distance = 10)
#' }

cfbd_metrics_ppa_predicted <- function(down,
                                       distance) {
  args <- list(down = down,
               distance = distance)

  # Check that none of arguments are null
  attempt::stop_if_any(args, is.null,
              msg = "You need to specify both arguments, down and distance, as integers")

  # Check if down is numeric
  assertthat::assert_that(is.numeric(down) & down <= 4,
                          msg = 'Enter valid down (Integer): values from 1-4')

  # Check if distance is numeric
  assertthat::assert_that(is.numeric(distance) & distance <= 99,
                          msg = 'Enter valid distance (Integer): values from 1-99')

  base_url <- "https://api.collegefootballdata.com/ppa/predicted?"

  full_url <- paste0(base_url,
                     "down=", down,
                     "&distance=", distance)

  # Check for internet
  check_internet()

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  # Create the GET request and set response as res
  res <- httr::RETRY("GET", full_url,
                     httr::add_headers(Authorization = paste("Bearer", cfbd_key())))

  # Check the result
  check_status(res)

  df <- data.frame()
  tryCatch(
    expr ={
      # Get the content, flatten and return result as data.frame
      df = res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON()
      colnames(df) = gsub("Line", "_line", colnames(df))
      colnames(df) = gsub("Points", "_points", colnames(df))

      message(glue::glue("{Sys.time()}: Scraping CFBData metrics PPA predicted data..."))
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no CFBData metrics PPA predicted data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' Get team averages for Predicted Points Added (PPA)
#' @rdname cfbd_metrics
#'
#' @param year (\emph{Integer} optional): Year, 4 digit format (\emph{YYYY})
#' @param team (\emph{String} optional): D-I Team
#' @param conference (\emph{String} optional): Conference name - select a valid FBS conference\cr
#' Conference names P5: ACC,  Big 12, Big Ten, SEC, Pac-12\cr
#' Conference names G5 and FBS Independents: Conference USA, Mid-American, Mountain West, FBS Independents, American Athletic\cr
#' @param excl_garbage_time (\emph{Logical} default FALSE): Select whether to exclude Garbage Time (TRUE or FALSE)
#'
#' @return \code{\link[cfbfastR:cfbd_metrics_ppa_teams]{cfbfastR::cfbd_metrics_ppa_teams()}} - A data frame with 21 variables:
#' \describe{
#'   \item{\code{season}}{integer.}
#'   \item{\code{conference}}{character.}
#'   \item{\code{team}}{character.}
#'   \item{\code{off_overall}}{character.}
#'   \item{\code{off_passing}}{character.}
#'   \item{\code{off_rushing}}{character.}
#'   \item{\code{off_first_down}}{character.}
#'   \item{\code{off_second_down}}{character.}
#'   \item{\code{off_third_down}}{character.}
#'   \item{\code{off_cumulative_total}}{character.}
#'   \item{\code{off_cumulative_passing}}{character.}
#'   \item{\code{off_cumulative_rushing}}{character.}
#'   \item{\code{def_overall}}{character.}
#'   \item{\code{def_passing}}{character.}
#'   \item{\code{def_rushing}}{character.}
#'   \item{\code{def_first_down}}{character.}
#'   \item{\code{def_second_down}}{character.}
#'   \item{\code{def_third_down}}{character.}
#'   \item{\code{def_cumulative_total}}{character.}
#'   \item{\code{def_cumulative_passing}}{character.}
#'   \item{\code{def_cumulative_rushing}}{character.}
#' }
#' @source \url{https://api.collegefootballdata.com/ppa/teams}
#' @keywords Teams Predicted Points
#' @importFrom attempt stop_if_all
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @import dplyr
#' @import tidyr
#' @import purrr
#' @export
#' @examples
#' \dontrun{
#'   cfbd_metrics_ppa_teams(year = 2019, team = 'TCU')
#' }

cfbd_metrics_ppa_teams <- function(year = 2019,
                                   team = NULL,
                                   conference = NULL,
                                   excl_garbage_time = FALSE){

  args <- list(year = year,
               team = team)

  # Check that at search_term input argument is not null
  attempt::stop_if_all(args, is.null,
                       msg = "You need to specify at least one of two arguments:\nyear as an integer 4 digit format (YYYY) or team (String) for a D-I team")

  if(!is.null(year)){
    ## check if year is numeric
    assertthat::assert_that(is.numeric(year) & nchar(year)==4,
                            msg = 'Enter valid year as integer in 4 digit format (YYYY)')
  }
  if(!is.null(team)){
    if(team == "San Jose State"){
      team = utils::URLencode(paste0("San Jos","\u00e9", " State"), reserved = TRUE)
    } else{
      # Encode team parameter for URL if not NULL
      team = utils::URLencode(team, reserved = TRUE)
    }
  }
  if(!is.null(conference)){
    # # Check conference parameter in conference names, if not NULL
    # assertthat::assert_that(conference %in% cfbfastR::cfbd_conf_types_df$name,
    #             msg = "Incorrect Conference name, potential misspelling.\nConference names P5: ACC,  Big 12, Big Ten, SEC, Pac-12\nConference Names G5 and Independents: Conference USA, Mid-American, Mountain West, FBS Independents, American Athletic")
    # Encode conference parameter for URL, if not NULL
    conference = utils::URLencode(conference, reserved = TRUE)
  }
  if(excl_garbage_time != FALSE){
    # Check if excl_garbage_time is TRUE, if not FALSE
    assertthat::assert_that(excl_garbage_time == TRUE,
                            msg = 'Enter valid excl_garbage_time value (Logical) - TRUE or FALSE')
  }

  base_url <- "https://api.collegefootballdata.com/ppa/teams?"

  full_url <- paste0(base_url,
                     "year=", year,
                     "&team=", team,
                     "&conference=", conference,
                     "&excludeGarbageTime=", excl_garbage_time)

  # Check for internet
  check_internet()

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  # Create the GET request and set response as res
  res <- httr::RETRY("GET", full_url,
                     httr::add_headers(Authorization = paste("Bearer", cfbd_key())))

  # Check the result
  check_status(res)

  df <- data.frame()
  tryCatch(
    expr = {
      # Get the content, flatten and return result as data.frame
      df = res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE)
      colnames(df) = gsub("offense.", "off_", colnames(df))
      colnames(df) = gsub("defense.", "def_", colnames(df))
      colnames(df) = gsub("cumulative.", "cumulative_", colnames(df))
      colnames(df) = gsub("Down", "_down", colnames(df))

      message(glue::glue("{Sys.time()}: Scraping CFBData metrics PPA teams data..."))
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no CFBData metrics PPA teams data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}



#' Get Pre-game Win Probability Data from API
#' @rdname cfbd_metrics
#'
#' @param year (\emph{Integer} optional): Year, 4 digit format (\emph{YYYY})
#' @param week (\emph{Integer} optional): Week - values from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param team (\emph{String} optional): D-I Team
#' @param season_type (\emph{String} default regular): Select Season Type: regular or postseason
#'
#' @return \code{\link[cfbfastR:cfbd_metrics_wp_pregame]{cfbfastR::cfbd_metrics_wp_pregame()}} - A data frame with 9 variables:
#' \describe{
#'   \item{\code{season}}{integer.}
#'   \item{\code{season_type}}{character.}
#'   \item{\code{week}}{integer.}
#'   \item{\code{game_id}}{integer.}
#'   \item{\code{home_team}}{character.}
#'   \item{\code{away_team}}{character.}
#'   \item{\code{spread}}{integer.}
#'   \item{\code{home_win_prob}}{double.}
#'   \item{\code{away_win_prob}}{double.}
#' }
#' @keywords Pre-game Win Probability Data
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode URLdecode
#' @importFrom assertthat assert_that
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @export
#' @examples
#' \dontrun{
#'   cfbd_metrics_wp_pregame(year = 2019, week=9, team='Texas A&M')
#' }

cfbd_metrics_wp_pregame <- function(year = NULL,
                                    week = NULL,
                                    team = NULL,
                                    season_type = 'regular') {

  if(!is.null(year)){
    # Check if year is numeric, if not NULL
    assertthat::assert_that(is.numeric(year) & nchar(year) == 4,
                            msg = 'Enter valid year (Integer): 4-digit (YYYY)')
  }
  if(!is.null(week)){
    # Check if week is numeric, if not NULL
    assertthat::assert_that(is.numeric(week) & nchar(week) <= 2 & week <= 15,
                            msg = 'Enter valid week (Integer): 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)')
  }
  if(!is.null(team)){
    # Encode team parameter for URL, if not NULL
    team = utils::URLencode(team, reserved = TRUE)
  }
  if(season_type != 'regular'){
    # Check if season_type is appropriate, if not NULL
    assertthat::assert_that(season_type %in% c('postseason'),
                            msg = 'Enter valid season_type (String): regular or postseason.')
  }
  base_url <- "https://api.collegefootballdata.com/metrics/wp/pregame?"

  full_url <- paste0(base_url,
                     "year=", year,
                     "&week=", week,
                     "&team=", team,
                     "&seasonType=", season_type)

  # Check for internet
  check_internet()

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  # Create the GET request and set response as res
  res <- httr::RETRY("GET", full_url,
                     httr::add_headers(Authorization = paste("Bearer", cfbd_key())))

  # Check the result
  check_status(res)

  cols <- c("season", "season_type", "week", "game_id",
            "home_team", "away_team", "spread", "home_win_prob","away_win_prob")

  df <- data.frame()
  tryCatch(
    expr ={
      # Get the content and return it as data.frame
      df = res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON() %>%
        janitor::clean_names() %>%
        dplyr::mutate(away_win_prob = 1 - as.numeric(.data$home_win_prob)) %>%
        dplyr::select(cols) %>%
        as.data.frame()

      message(glue::glue("{Sys.time()}: Scraping pre-game win probability data..."))
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no pre-game win probability data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' Get win probability chart data from API
#' @rdname cfbd_metrics
#'
#' @param game_id (\emph{Integer} required): Game ID filter for querying a single game\cr
#' Can be found using the \code{\link[cfbfastR:cfbd_game_info]{cfbfastR::cfbd_game_info()}} function
#'
#' @return \code{\link[cfbfastR:cfbd_metrics_wp]{cfbfastR::cfbd_metrics_wp()}} - A data frame with 16 variables:
#' \describe{
#'   \item{\code{play_id}}{character.}
#'   \item{\code{play_text}}{character.}
#'   \item{\code{home_id}}{integer.}
#'   \item{\code{home}}{character.}
#'   \item{\code{away_id}}{integer.}
#'   \item{\code{away}}{character.}
#'   \item{\code{spread}}{character.}
#'   \item{\code{home_ball}}{logical.}
#'   \item{\code{home_score}}{integer.}
#'   \item{\code{away_score}}{integer.}
#'   \item{\code{down}}{integer.}
#'   \item{\code{distance}}{integer.}
#'   \item{\code{home_win_prob}}{character.}
#'   \item{\code{away_win_prob}}{double.}
#'   \item{\code{play_number}}{integer.}
#'   \item{\code{yard_line}}{integer.}
#' }
#' @source \url{https://api.collegefootballdata.com/metrics/wp}
#' @keywords Win Probability Chart Data
#' @importFrom attempt stop_if_all
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode URLdecode
#' @importFrom assertthat assert_that
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @export
#' @examples
#' \dontrun{
#'   cfbd_metrics_wp(game_id = 401012356)
#' }

cfbd_metrics_wp <- function(game_id) {

  args <- list(game_id = game_id)

  # Check that at search_term input argument is not null
  attempt::stop_if_all(args, is.null,
                       msg = "You need to specify at least one argument: game_id\n Can be found using the `cfbd_game_info()` function")

  if(!is.null(game_id)){
    # Check if game_id is numeric, if not NULL
    assertthat::assert_that(is.numeric(game_id),
                            msg = 'Enter valid game_id value (Integer)\nCan be found using the `cfbd_game_info()` function')
  }

  base_url <- "https://api.collegefootballdata.com/metrics/wp?"

  full_url <- paste0(base_url,
                     "gameId=", game_id)

  # Check for internet
  check_internet()

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  # Create the GET request and set response as res
  res <- httr::RETRY("GET", full_url,
                     httr::add_headers(Authorization = paste("Bearer", cfbd_key())))

  # Check the result
  check_status(res)

  cols <- c("play_id", "play_text", "home_id", "home", "away_id", "away",
            "spread", "home_ball", "home_score", "away_score", "down",
            "distance", "home_win_prob", "away_win_prob", "play_number",  "yard_line")

  df <- data.frame()
  tryCatch(
    expr = {
      # Get the content and return it as data.frame
      df = res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON() %>%
        janitor::clean_names() %>%
        dplyr::mutate(away_win_prob = 1 - as.numeric(.data$home_win_prob)) %>%
        dplyr::select(cols)
      as.data.frame()

      message(glue::glue("{Sys.time()}: Scraping CFBData metrics win probability data..."))
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no CFBData metrics win probability data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}

