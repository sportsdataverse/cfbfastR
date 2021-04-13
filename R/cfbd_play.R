#' CFBD Plays Endpoint
#' @name cfbd_play
NULL
#' College Football Plays
#' @rdname cfbd_play
#' @source \url{https://api.collegefootballdata.com/plays}
#'
#' @param season_type Select Season Type (regular, postseason, both)
#' @param year Select year, (example: 2018)
#' @param week Select week, this is optional (also numeric)
#' @param team Select team name (example: Texas, Texas A&M, Clemson)
#' @param offense Select offense name (example: Texas, Texas A&M, Clemson)
#' @param defense Select defense name (example: Texas, Texas A&M, Clemson)
#' @param conference Select conference name (example: ACC, B1G, B12, SEC,\cr
#'  PAC, MAC, MWC, CUSA, Ind, SBC, AAC, Western, MVIAA, SWC, PCC, Big 6, etc.)
#' @param offense_conference Select conference name (example: ACC, B1G, B12, SEC,\cr
#'  PAC, MAC, MWC, CUSA, Ind, SBC, AAC, Western, MVIAA, SWC, PCC, Big 6, etc.)
#' @param defense_conference Select conference name (example: ACC, B1G, B12, SEC,\cr
#'  PAC, MAC, MWC, CUSA, Ind, SBC, AAC, Western, MVIAA, SWC, PCC, Big 6, etc.)
#' @param play_type Select play type (example: see the \code{\link[cfbfastR:cfbd_play_type_df]{cfbd_play_type_df}})
#' @param verbose Logical parameter (TRUE/FALSE, default: FALSE) to return warnings and messages from function
#' @return \code{\link[cfbfastR:cfbd_plays]{cfbfastR::cfbd_plays()}}
#' @source \url{https://api.collegefootballdata.com/plays}
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#'


cfbd_plays <- function(year = 2020,
                       season_type = "regular",
                       week = 4,
                       team = "Florida State",
                       offense = NULL,
                       defense = NULL,
                       conference = NULL,
                       offense_conference = NULL,
                       defense_conference = NULL,
                       play_type = NULL,
                       verbose = FALSE) {
  if (!is.null(year)) {
    # Check if year is numeric, if not NULL
    assertthat::assert_that(is.numeric(year) & nchar(year) == 4,
      msg = "Enter valid year (Integer): 4-digit (YYYY)"
    )
  }
  if (!is.null(week)) {
    # Check if week is numeric, if not NULL
    assertthat::assert_that(is.numeric(week) & nchar(week) <= 2 & week <= 15,
      msg = "Enter valid week (Integer): 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)"
    )
  }
  if (!is.null(team)) {
    if (team == "San Jose State") {
      team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team parameter for URL if not NULL
      team <- utils::URLencode(team, reserved = TRUE)
    }
  }
  if (!is.null(offense)) {
    if (offense == "San Jose State") {
      offense <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode offense parameter for URL if not NULL
      offense <- utils::URLencode(offense, reserved = TRUE)
    }
  }
  if (!is.null(defense)) {
    if (defense == "San Jose State") {
      defense <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode defense parameter for URL if not NULL
      defense <- utils::URLencode(defense, reserved = TRUE)
    }
  }
  if (!is.null(offense_conference)) {
    # Encode offense_conference parameter for URL if not NULL
    offense_conference <- utils::URLencode(offense_conference, reserved = TRUE)
  }
  if (!is.null(defense_conference)) {
    # Encode defense_conference parameter for URL if not NULL
    defense_conference <- utils::URLencode(defense_conference, reserved = TRUE)
  }
  if (season_type != "regular") {
    # Check if season_type is appropriate, if not NULL
    assertthat::assert_that(season_type %in% c("postseason", "both"),
      msg = "Enter valid season_type (String): regular, postseason, or both"
    )
  }

  base_url <- "https://api.collegefootballdata.com/plays?"
  full_url <- paste0(
    base_url,
    "year=", year,
    "&week=", week,
    "&team=", team,
    "&offense=", offense,
    "&defense=", defense,
    "&offenseConference=", offense_conference,
    "&defenseConference=", defense_conference,
    "&seasonType=", season_type
  )

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  # Create the GET request and set response as res
  res <- httr::RETRY(
    "GET", full_url,
    httr::add_headers(Authorization = paste("Bearer", cfbd_key()))
  )

  # Check the result
  check_status(res)

  df <- data.frame()
  tryCatch(
    expr = {
      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE) %>%
        dplyr::rename(play_id = .data$id) %>%
        as.data.frame()

      if(verbose){ 
        message(glue::glue("{Sys.time()}: Scraping plays data..."))
      }
    },
    error = function(e) {
      if(verbose){ 
        message(glue::glue("{Sys.time()}: Invalid arguments or no plays data available!"))
      }
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}

#' Gets player info associated by play
#' @rdname cfbd_play
#' @param year (\emph{Integer} optional): Year, 4 digit format (\emph{YYYY})
#' @param week (\emph{Integer} optional): Week - values from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param team (\emph{String} optional): D-I Team
#' @param game_id (\emph{Integer} optional): Game ID filter for querying a single game\cr
#' Can be found using the \code{\link[cfbfastR:cfbd_game_info]{cfbfastR::cfbd_game_info()}} function
#' @param athlete_id (\emph{Integer} optional): Athlete ID filter for querying a single athlete\cr
#' Can be found using the \code{\link[cfbfastR:cfbd_player_info]{cfbfastR::cfbd_player_info()}} function.
#' @param stat_type_id (\emph{Integer} optional): Stat Type ID filter for querying a single stat type\cr
#' Can be found using the \code{\link[cfbfastR:cfbd_play_stats_types]{cfbfastR::cfbd_play_stats_types()}} function
#' @param season_type (\emph{String} default regular): Select Season Type: regular, postseason, or both
#' @param verbose Logical parameter (TRUE/FALSE, default: FALSE) to return warnings and messages from function
#'
#' @return \code{\link[cfbfastR:cfbd_play_stats_player]{cfbfastR::cfbd_play_stats_player()}} - A data frame with 54 variables:
#' \describe{
#'   \item{\code{play_id}}{character.}
#'   \item{\code{game_id}}{integer.}
#'   \item{\code{season}}{integer.}
#'   \item{\code{week}}{integer.}
#'   \item{\code{opponent}}{character.}
#'   \item{\code{team_score}}{integer.}
#'   \item{\code{opponent_score}}{integer.}
#'   \item{\code{drive_id}}{character.}
#'   \item{\code{period}}{integer.}
#'   \item{\code{yards_to_goal}}{integer.}
#'   \item{\code{down}}{integer.}
#'   \item{\code{distance}}{integer.}
#'   \item{\code{reception_player_id}}{character.}
#'   \item{\code{reception_player}}{character.}
#'   \item{\code{reception_yds}}{integer.}
#'   \item{\code{completion_player_id}}{character.}
#'   \item{\code{completion_player}}{character.}
#'   \item{\code{completion_yds}}{integer.}
#'   \item{\code{rush_player_id}}{character.}
#'   \item{\code{rush_player}}{character.}
#'   \item{\code{rush_yds}}{integer.}
#'   \item{\code{interception_player_id}}{character.}
#'   \item{\code{interception_player}}{character.}
#'   \item{\code{interception_stat}}{integer.}
#'   \item{\code{interception_thrown_player_id}}{character.}
#'   \item{\code{interception_thrown_player}}{character.}
#'   \item{\code{interception_thrown_stat}}{integer.}
#'   \item{\code{touchdown_player_id}}{character.}
#'   \item{\code{touchdown_player}}{character.}
#'   \item{\code{touchdown_stat}}{integer.}
#'   \item{\code{incompletion_player_id}}{character.}
#'   \item{\code{incompletion_player}}{character.}
#'   \item{\code{incompletion_stat}}{integer.}
#'   \item{\code{target_player_id}}{character.}
#'   \item{\code{target_player}}{character.}
#'   \item{\code{target_stat}}{integer.}
#'   \item{\code{fumble_recovered_player_id}}{logical.}
#'   \item{\code{fumble_recovered_player}}{logical.}
#'   \item{\code{fumble_recovered_stat}}{logical.}
#'   \item{\code{fumble_forced_player_id}}{logical.}
#'   \item{\code{fumble_forced_player}}{logical.}
#'   \item{\code{fumble_forced_stat}}{logical.}
#'   \item{\code{fumble_player_id}}{logical.}
#'   \item{\code{fumble_player}}{logical.}
#'   \item{\code{fumble_stat}}{logical.}
#'   \item{\code{sack_player_id}}{character.}
#'   \item{\code{sack_player}}{character.}
#'   \item{\code{sack_stat}}{integer.}
#'   \item{\code{sack_taken_player_id}}{character.}
#'   \item{\code{sack_taken_player}}{character.}
#'   \item{\code{sack_taken_stat}}{integer.}
#'   \item{\code{pass_breakup_player_id}}{logical.}
#'   \item{\code{pass_breakup_player}}{logical.}
#'   \item{\code{pass_breakup_stat}}{logical.}
#' }
#' @source \url{https://api.collegefootballdata.com/play/stats}
#' @keywords Player PBP
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @import dplyr
#' @import tidyr
#' @import purrr
#' @export
#' @examples
#' \donttest{
#'   cfbd_play_stats_player(game_id = 401110722)
#' }
cfbd_play_stats_player <- function(year = NULL,
                                   week = NULL,
                                   team = NULL,
                                   game_id = NULL,
                                   athlete_id = NULL,
                                   stat_type_id = NULL,
                                   season_type = "regular",
                                   verbose = FALSE) {
  if (!is.null(year)) {
    # Check if year is numeric, if not NULL
    assertthat::assert_that(is.numeric(year) & nchar(year) == 4,
      msg = "Enter valid year (Integer): 4-digit (YYYY)"
    )
  }
  if (!is.null(week)) {
    # Check if week is numeric, if not NULL
    assertthat::assert_that(is.numeric(week) & nchar(week) <= 2 & week <= 15,
      msg = "Enter valid week (Integer): 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)"
    )
  }
  if (!is.null(team)) {
    if (team == "San Jose State") {
      team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team parameter for URL if not NULL
      team <- utils::URLencode(team, reserved = TRUE)
    }
  }
  if (!is.null(game_id)) {
    # Check if game_id is numeric, if not NULL
    assertthat::assert_that(is.numeric(game_id),
      msg = "Enter valid game_id value (Integer)\nCan be found using the `cfbd_game_info()` function"
    )
  }
  if (!is.null(athlete_id)) {
    # Check if athlete_id is numeric, if not NULL
    assertthat::assert_that(is.numeric(athlete_id),
      msg = "Enter valid athlete_id value (Integer)\nCan be found using the `cfbd_player_info()` function"
    )
  }
  if (!is.null(stat_type_id)) {
    # Check if stat_type_id is numeric, if not NULL
    assertthat::assert_that(is.numeric(stat_type_id),
      msg = "Enter valid stat_type_id value (Integer)\nCan be found using the `cfbd_play_stat_types()` function"
    )
  }
  if (season_type != "regular") {
    # Check if season_type is appropriate, if not NULL
    assertthat::assert_that(season_type %in% c("postseason", "both"),
      msg = "Enter valid season_type (String): regular, postseason, or both"
    )
  }

  base_url <- "https://api.collegefootballdata.com/play/stats?"

  full_url <- paste0(
    base_url,
    "year=", year,
    "&week=", week,
    "&team=", team,
    "&gameId=", game_id,
    "&athleteID=", athlete_id,
    "&statTypeId=", stat_type_id,
    "&seasonType=", season_type
  )

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  # Create the GET request and set response as res
  res <- httr::RETRY(
    "GET", full_url,
    httr::add_headers(Authorization = paste("Bearer", cfbd_key()))
  )

  # Check the result
  check_status(res)

  clean_df <- data.frame()
  tryCatch(
    expr = {
      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON()

      cols <- c(
        "game_id", "season", "week", "opponent", "team_score", "opponent_score",
        "drive_id", "play_id", "period", "yards_to_goal", "down", "distance",
        "athlete_id", "stat",
        "reception", "completion", "rush", "interception", "interception_thrown",
        "touchdown", "incompletion", "target", "fumble_recovered", "fumble_forced",
        "fumble", "sack", "sack_taken", "pass_breakup",
        "reception_player_id", "reception_player", "reception_yds",
        "completion_player_id", "completion_player", "completion_yds",
        "rush_player_id", "rush_player", "rush_yds",
        "interception_player_id", "interception_player", "interception_stat",
        "interception_thrown_player_id", "interception_thrown_player", "interception_thrown_stat",
        "touchdown_player_id", "touchdown_player", "touchdown_stat",
        "incompletion_player_id", "incompletion_player", "incompletion_stat",
        "target_player_id", "target_player", "target_stat",
        "fumble_recovered_player_id", "fumble_recovered_player", "fumble_recovered_stat",
        "fumble_forced_player_id", "fumble_forced_player", "fumble_forced_stat",
        "fumble_player_id", "fumble_player", "fumble_stat",
        "sack_player_id", "sack_player", "sack_stat",
        "sack_taken_player_id", "sack_taken_player", "sack_taken_stat",
        "pass_breakup_player_id", "pass_breakup_player", "pass_breakup_stat"
      )

      df_cols <- data.frame(matrix(NA, nrow = 0, ncol = 70))

      names(df_cols) <- cols

      df <- df[!duplicated(df), ]

      # Supply lists by splicing them into dots:
      coalesce_by_column <- function(df) {
        return(dplyr::coalesce(!!!as.list(df)))
      }

      df <- df %>%
        dplyr::rename(
          game_id = .data$gameId,
          team_score = .data$teamScore,
          opponent_score = .data$opponentScore,
          drive_id = .data$driveId,
          play_id = .data$playId,
          yards_to_goal = .data$yardsToGoal,
          athlete_id = .data$athleteId,
          athlete_name = .data$athleteName,
          stat_type = .data$statType,
          stat = .data$stat
        )

      colnames(df) <- sub(" ", "_", tolower(colnames(df)))

      clean_df <- df %>%
        tidyr::pivot_wider(
          names_from = .data$stat_type,
          values_from = .data$athlete_name
        )

      colnames(clean_df) <- sub(" ", "_", tolower(colnames(clean_df)))

      clean_df[cols[!(cols %in% colnames(clean_df))]] <- NA

      clean_df <- clean_df %>%
        dplyr::mutate(
          reception_player = ifelse(!is.na(.data$reception), .data$reception, NA),
          completion_player = ifelse(!is.na(.data$completion), .data$completion, NA),
          rush_player = ifelse(!is.na(.data$rush), .data$rush, NA),
          interception_player = ifelse(!is.na(.data$interception), .data$interception, NA),
          interception_thrown_player = ifelse(!is.na(.data$interception_thrown), .data$interception_thrown, NA),
          touchdown_player = ifelse(!is.na(.data$touchdown), .data$touchdown, NA),
          incompletion_player = ifelse(!is.na(.data$incompletion), .data$incompletion, NA),
          target_player = ifelse(!is.na(.data$target), .data$target, NA),
          fumble_recovered_player = ifelse(!is.na(.data$fumble_recovered), .data$fumble_recovered, NA),
          fumble_forced_player = ifelse(!is.na(.data$fumble_forced), .data$fumble_forced, NA),
          fumble_player = ifelse(!is.na(.data$fumble), .data$fumble, NA),
          sack_player = ifelse(!is.na(.data$sack), .data$sack, NA),
          sack_taken_player = ifelse(!is.na(.data$sack_taken), .data$sack_taken, NA),
          pass_breakup_player = ifelse(!is.na(.data$pass_breakup), .data$pass_breakup, NA),
          reception_yds = ifelse(!is.na(.data$reception), .data$stat, NA),
          completion_yds = ifelse(!is.na(.data$completion), .data$stat, NA),
          rush_yds = ifelse(!is.na(.data$rush), .data$stat, NA),
          interception_stat = ifelse(!is.na(.data$interception), .data$stat, NA),
          interception_thrown_stat = ifelse(!is.na(.data$interception_thrown), .data$stat, NA),
          touchdown_stat = ifelse(!is.na(.data$touchdown), .data$stat, NA),
          incompletion_stat = ifelse(!is.na(.data$incompletion), .data$stat, NA),
          target_stat = ifelse(!is.na(.data$target), .data$stat, NA),
          fumble_recovered_stat = ifelse(!is.na(.data$fumble_recovered), .data$stat, NA),
          fumble_forced_stat = ifelse(!is.na(.data$fumble_forced), .data$stat, NA),
          fumble_stat = ifelse(!is.na(.data$fumble), .data$stat, NA),
          sack_stat = ifelse(!is.na(.data$sack), .data$stat, NA),
          sack_taken_stat = ifelse(!is.na(.data$sack_taken), .data$stat, NA),
          pass_breakup_stat = ifelse(!is.na(.data$pass_breakup), .data$stat, NA),
          reception_player_id = ifelse(!is.na(.data$reception), .data$athlete_id, NA),
          completion_player_id = ifelse(!is.na(.data$completion), .data$athlete_id, NA),
          rush_player_id = ifelse(!is.na(.data$rush), .data$athlete_id, NA),
          interception_player_id = ifelse(!is.na(.data$interception), .data$athlete_id, NA),
          interception_thrown_player_id = ifelse(!is.na(.data$interception_thrown), .data$athlete_id, NA),
          touchdown_player_id = ifelse(!is.na(.data$touchdown), .data$athlete_id, NA),
          incompletion_player_id = ifelse(!is.na(.data$incompletion), .data$athlete_id, NA),
          target_player_id = ifelse(!is.na(.data$target), .data$athlete_id, NA),
          fumble_recovered_player_id = ifelse(!is.na(.data$fumble_recovered), .data$athlete_id, NA),
          fumble_forced_player_id = ifelse(!is.na(.data$fumble_forced), .data$athlete_id, NA),
          fumble_player_id = ifelse(!is.na(.data$fumble), .data$athlete_id, NA),
          sack_player_id = ifelse(!is.na(.data$sack), .data$athlete_id, NA),
          sack_taken_player_id = ifelse(!is.na(.data$sack_taken), .data$athlete_id, NA),
          pass_breakup_player_id = ifelse(!is.na(.data$pass_breakup), .data$athlete_id, NA)
        ) %>%
        dplyr::select(
          .data$game_id, .data$season, .data$week,
          .data$opponent, .data$team_score, .data$opponent_score,
          .data$drive_id, .data$play_id, .data$period,
          .data$yards_to_goal, .data$down, .data$distance,
          .data$reception_player_id,
          .data$reception_player,
          .data$reception_yds,
          .data$completion_player_id,
          .data$completion_player,
          .data$completion_yds,
          .data$rush_player_id,
          .data$rush_player,
          .data$rush_yds,
          .data$interception_player_id,
          .data$interception_player,
          .data$interception_stat,
          .data$interception_thrown_player_id,
          .data$interception_thrown_player,
          .data$interception_thrown_stat,
          .data$touchdown_player_id,
          .data$touchdown_player,
          .data$touchdown_stat,
          .data$incompletion_player_id,
          .data$incompletion_player,
          .data$incompletion_stat,
          .data$target_player_id,
          .data$target_player,
          .data$target_stat,
          .data$fumble_recovered_player_id,
          .data$fumble_recovered_player,
          .data$fumble_recovered_stat,
          .data$fumble_forced_player_id,
          .data$fumble_forced_player,
          .data$fumble_forced_stat,
          .data$fumble_player_id,
          .data$fumble_player,
          .data$fumble_stat,
          .data$sack_player_id,
          .data$sack_player,
          .data$sack_stat,
          .data$sack_taken_player_id,
          .data$sack_taken_player,
          .data$sack_taken_stat,
          .data$pass_breakup_player_id,
          .data$pass_breakup_player,
          .data$pass_breakup_stat
        ) %>%
        dplyr::group_by(.data$play_id) %>%
        dplyr::summarise_all(coalesce_by_column) %>%
        dplyr::ungroup()

      clean_df <- as.data.frame(clean_df)
      if(verbose){ 
        message(glue::glue("{Sys.time()}: Scraping play-level player stats data..."))
      }
    },
    error = function(e) {
      if(verbose){ 
        message(glue::glue("{Sys.time()}: Invalid arguments or no play-level player stats data available!"))
      }
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(clean_df)
}


#' College Football Mapping for Play Stats Types
#' @rdname cfbd_play
#' @return \code{\link[cfbfastR:cfbd_play_stats_types]{cfbfastR::cfbd_play_stats_types()}} - A data frame with 22 rows and 2 variables:
#' \describe{
#'   \item{play_stat_type_id}{Referencing play stat type ID}
#'   \item{name}{Type of play stats}
#' }
#' @source \url{https://api.collegefootballdata.com/play/stat/types}
#' @keywords Plays
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom glue glue
#' @export
#' @examples
#' \donttest{
#'   cfbd_play_stats_types()
#' }
#'
cfbd_play_stats_types <- function() {
  full_url <- "https://api.collegefootballdata.com/play/stat/types"

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  # Create the GET request and set response as res
  res <- httr::RETRY(
    "GET", full_url,
    httr::add_headers(Authorization = paste("Bearer", cfbd_key()))
  )

  # Check the result
  check_status(res)

  df <- data.frame()
  tryCatch(
    expr = {
      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON() %>%
        dplyr::rename(play_stat_type_id = .data$id) %>%
        as.data.frame()
      
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no play stats types data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' College Football Mapping for Play Types
#' @rdname cfbd_play
#' @return \code{\link[cfbfastR:cfbd_play_types]{cfbfastR::cfbd_play_types()}} - A data frame with 48 rows and 3 variables:
#' \describe{
#'   \item{play_type_id}{Referencing play type id}
#'   \item{text}{play type description}
#'   \item{abbreviation}{play type abbreviation used for function call}
#' }
#' @source \url{https://api.collegefootballdata.com/play/types}
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#'


cfbd_play_types <- function() {
  full_url <- "https://api.collegefootballdata.com/play/types"

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  # Create the GET request and set response as res
  res <- httr::RETRY(
    "GET", full_url,
    httr::add_headers(Authorization = paste("Bearer", cfbd_key()))
  )

  # Check the result
  check_status(res)

  df <- data.frame()
  tryCatch(
    expr = {
      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON() %>%
        dplyr::rename(play_type_id = .data$id) %>%
        as.data.frame()

      
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no play types data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}
