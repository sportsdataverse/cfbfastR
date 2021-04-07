#' CFBD Stats Endpoint
#' @name cfbd_stats
NULL
#' College Football Mapping for Stats Categories
#'
#' This function identifies all Stats Categories identified in the regular stats endpoint.
#'
#' @rdname cfbd_stats
#' @return \code{\link[cfbfastR:cfbd_stats_categories]{cfbfastR::cfbd_stats_categories()}} A data frame with 38 values:
#' \describe{
#'   \item{name}{Statistics Categories}
#'   ...
#' }
#' @source \url{https://api.collegefootballdata.com/stats/categories}
#' @keywords Stats Categories
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom glue glue
#' @importFrom dplyr rename
#' @export
#' @examples
#' \dontrun{
#' cfbd_stats_categories()
#' }
#'
cfbd_stats_categories <- function() {
  full_url <- "https://api.collegefootballdata.com/stats/categories"

  # Check for internet
  check_internet()

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
      # Get the content and return it as list
      list <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON()
      df <- as.data.frame(matrix(unlist(list), nrow = length(list), byrow = TRUE)) %>%
        dplyr::rename(category = .data$V1)

      message(glue::glue("{Sys.time()}: Scraping stats categories data..."))
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no stats categories data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' Get Game Advanced Stats
#' @rdname cfbd_stats
#'
#' @param year (\emph{Integer} required): Year, 4 digit format(\emph{YYYY})
#' @param week (\emph{Integer} optional): Week - values from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
#' @param team (\emph{String} optional): D-I Team
#' @param opponent (\emph{String} optional): Opponent D-I Team
#' @param excl_garbage_time (\emph{Logical} default FALSE): Select whether to exclude Garbage Time (TRUE/FALSE)
#' @param season_type (\emph{String} default both): Select Season Type: regular, postseason, or both.
#'
#' @return \code{\link[cfbfastR:cfbd_stats_game_advanced]{cfbfastR::cfbd_stats_game_advanced()}} - A data frame with 60 variables:
#' \describe{
#'   \item{\code{game_id}}{integer.}
#'   \item{\code{week}}{integer.}
#'   \item{\code{team}}{character.}
#'   \item{\code{opponent}}{character.}
#'   \item{\code{off_plays}}{integer.}
#'   \item{\code{off_drives}}{integer.}
#'   \item{\code{off_ppa}}{double.}
#'   \item{\code{off_total_ppa}}{double.}
#'   \item{\code{off_success_rate}}{double.}
#'   \item{\code{off_explosiveness}}{double.}
#'   \item{\code{off_power_success}}{double.}
#'   \item{\code{off_stuff_rate}}{double.}
#'   \item{\code{off_line_yds}}{double.}
#'   \item{\code{off_line_yds_total}}{integer.}
#'   \item{\code{off_second_lvl_yds}}{double.}
#'   \item{\code{off_second_lvl_yds_total}}{integer.}
#'   \item{\code{off_open_field_yds}}{integer.}
#'   \item{\code{off_open_field_yds_total}}{integer.}
#'   \item{\code{off_standard_downs_ppa}}{double.}
#'   \item{\code{off_standard_downs_success_rate}}{double.}
#'   \item{\code{off_standard_downs_explosiveness}}{double.}
#'   \item{\code{off_passing_downs_ppa}}{double.}
#'   \item{\code{off_passing_downs_success_rate}}{double.}
#'   \item{\code{off_passing_downs_explosiveness}}{double.}
#'   \item{\code{off_rushing_plays_ppa}}{double.}
#'   \item{\code{off_rushing_plays_total_ppa}}{double.}
#'   \item{\code{off_rushing_plays_success_rate}}{double.}
#'   \item{\code{off_rushing_plays_explosiveness}}{double.}
#'   \item{\code{off_passing_plays_ppa}}{double.}
#'   \item{\code{off_passing_plays_total_ppa}}{double.}
#'   \item{\code{off_passing_plays_success_rate}}{double.}
#'   \item{\code{off_passing_plays_explosiveness}}{double.}
#'   \item{\code{def_plays}}{integer.}
#'   \item{\code{def_drives}}{integer.}
#'   \item{\code{def_ppa}}{double.}
#'   \item{\code{def_total_ppa}}{double.}
#'   \item{\code{def_success_rate}}{double.}
#'   \item{\code{def_explosiveness}}{double.}
#'   \item{\code{def_power_success}}{double.}
#'   \item{\code{def_stuff_rate}}{double.}
#'   \item{\code{def_line_yds}}{double.}
#'   \item{\code{def_line_yds_total}}{integer.}
#'   \item{\code{def_second_lvl_yds}}{double.}
#'   \item{\code{def_second_lvl_yds_total}}{integer.}
#'   \item{\code{def_open_field_yds}}{double.}
#'   \item{\code{def_open_field_yds_total}}{integer.}
#'   \item{\code{def_standard_downs_ppa}}{double.}
#'   \item{\code{def_standard_downs_success_rate}}{double.}
#'   \item{\code{def_standard_downs_explosiveness}}{double.}
#'   \item{\code{def_passing_downs_ppa}}{double.}
#'   \item{\code{def_passing_downs_success_rate}}{double.}
#'   \item{\code{def_passing_downs_explosiveness}}{double.}
#'   \item{\code{def_rushing_plays_ppa}}{double.}
#'   \item{\code{def_rushing_plays_total_ppa}}{double.}
#'   \item{\code{def_rushing_plays_success_rate}}{double.}
#'   \item{\code{def_rushing_plays_explosiveness}}{double.}
#'   \item{\code{def_passing_plays_ppa}}{double.}
#'   \item{\code{def_passing_plays_total_ppa}}{double.}
#'   \item{\code{def_passing_plays_success_rate}}{double.}
#'   \item{\code{def_passing_plays_explosiveness}}{double.}
#' }
#' @source \url{https://api.collegefootballdata.com/stats/game/advanced}
#' @keywords Game Advanced Stats
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode URLdecode
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#' @export
#' @examples
#' \dontrun{
#' cfbd_stats_game_advanced(year = 2018, week = 12, team = "Texas A&M")
#'
#' cfbd_stats_game_advanced(2019, team = "LSU")
#'
#' cfbd_stats_game_advanced(2013, team = "Florida State")
#' }
#'
cfbd_stats_game_advanced <- function(year,
                                     week = NULL,
                                     team = NULL,
                                     opponent = NULL,
                                     excl_garbage_time = FALSE,
                                     season_type = "both") {

  # Check if year is numeric
  assertthat::assert_that(is.numeric(year) & nchar(year) == 4,
    msg = "Enter valid year (Integer): 4-digit (YYYY)"
  )
  if (!is.null(week)) {
    # Check if week is numeric, if not NULL
    assertthat::assert_that(is.numeric(week) & nchar(week) <= 2,
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
  if (!is.null(opponent)) {
    # Encode opponent parameter for URL, if not NULL
    opponent <- utils::URLencode(opponent, reserved = TRUE)
  }
  if (excl_garbage_time != FALSE) {
    # Check if excl_garbage_time is TRUE, if not FALSE
    assertthat::assert_that(excl_garbage_time == TRUE,
      msg = "Enter valid excl_garbage_time value (Logical) - TRUE or FALSE"
    )
  }

  if (season_type != "both") {
    # Check if season_type is appropriate, if not regular
    assertthat::assert_that(season_type %in% c("postseason", "regular"),
      msg = "Enter valid season_type (String): regular, postseason, or both"
    )
  }



  base_url <- "https://api.collegefootballdata.com/stats/game/advanced?"

  full_url <- paste0(
    base_url,
    "year=", year,
    "&week=", week,
    "&team=", team,
    "&opponent=", opponent,
    "&excludeGarbageTime=", excl_garbage_time,
    "&seasonType=", season_type
  )

  # Check for internet
  check_internet()

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
      # Get the content, flatten and return result as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE)

      # Column renaming for the 76 returned columns
      colnames(df) <- gsub("offense.", "off_", colnames(df))
      colnames(df) <- gsub("defense.", "def_", colnames(df))
      colnames(df) <- gsub("Rate", "_rate", colnames(df))
      colnames(df) <- gsub("Total", "_total", colnames(df))
      colnames(df) <- gsub("Downs", "_downs", colnames(df))
      colnames(df) <- gsub("lineYards", "line_yds", colnames(df))
      colnames(df) <- gsub("secondLevelYards", "second_lvl_yds", colnames(df))
      colnames(df) <- gsub("openFieldYards", "open_field_yds", colnames(df))
      colnames(df) <- gsub("Success", "_success", colnames(df))
      colnames(df) <- gsub("fieldPosition", "field_pos", colnames(df))
      colnames(df) <- gsub("pointsPerOpportunity", "pts_per_opp", colnames(df))
      colnames(df) <- gsub("average", "avg_", colnames(df))
      colnames(df) <- gsub("Plays", "_plays", colnames(df))
      colnames(df) <- gsub("PPA", "_ppa", colnames(df))
      colnames(df) <- gsub("PredictedPoints", "predicted_points", colnames(df))
      colnames(df) <- gsub("Seven", "_seven", colnames(df))
      colnames(df) <- gsub(".avg", "_avg", colnames(df))
      colnames(df) <- gsub(".rate", "_rate", colnames(df))
      colnames(df) <- gsub(".explosiveness", "_explosiveness", colnames(df))
      colnames(df) <- gsub(".ppa", "_ppa", colnames(df))
      colnames(df) <- gsub(".total", "_total", colnames(df))
      colnames(df) <- gsub(".success", "_success", colnames(df))
      colnames(df) <- gsub(".front", "_front", colnames(df))
      colnames(df) <- gsub("_Start", "_start", colnames(df))
      colnames(df) <- gsub(".db", "_db", colnames(df))
      colnames(df) <- gsub("Id", "_id", colnames(df))

      df <- df %>%
        as.data.frame()

      message(glue::glue("{Sys.time()}: Scraping game advanced stats..."))
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no game advanced stats data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' Get Season Advanced Statistics by Team
#' @rdname cfbd_stats
#'
#' @param year (\emph{Integer} required): Year, 4 digit format (\emph{YYYY})
#' @param team (\emph{String} optional): D-I Team
#' @param excl_garbage_time (\emph{Logical} default FALSE): Select whether to exclude Garbage Time (TRUE/FALSE)
#' @param start_week (\emph{Integer} optional): Starting Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param end_week (\emph{Integer} optional): Ending Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#'
#' @return \code{\link[cfbfastR:cfbd_stats_season_advanced]{cfbfastR::cfbd_stats_season_advanced()}} - A data frame with 79 variables:
#' \describe{
#'   \item{\code{season}}{integer.}
#'   \item{\code{team}}{character.}
#'   \item{\code{conference}}{character.}
#'   \item{\code{off_plays}}{integer.}
#'   \item{\code{off_drives}}{integer.}
#'   \item{\code{off_ppa}}{double.}
#'   \item{\code{off_total_ppa}}{double.}
#'   \item{\code{off_success_rate}}{double.}
#'   \item{\code{off_explosiveness}}{double.}
#'   \item{\code{off_power_success}}{double.}
#'   \item{\code{off_stuff_rate}}{double.}
#'   \item{\code{off_line_yds}}{double.}
#'   \item{\code{off_line_yds_total}}{integer.}
#'   \item{\code{off_second_lvl_yds}}{double.}
#'   \item{\code{off_second_lvl_yds_total}}{integer.}
#'   \item{\code{off_open_field_yds}}{double.}
#'   \item{\code{off_open_field_yds_total}}{integer.}
#'   \item{\code{off_pts_per_opp}}{double.}
#'   \item{\code{off_field_pos_avg_start}}{double.}
#'   \item{\code{off_field_pos_avg_predicted_points}}{double.}
#'   \item{\code{off_havoc_total}}{double.}
#'   \item{\code{off_havoc_front_seven}}{double.}
#'   \item{\code{off_havoc_db}}{double.}
#'   \item{\code{off_standard_downs_rate}}{double.}
#'   \item{\code{off_standard_downs_ppa}}{double.}
#'   \item{\code{off_standard_downs_success_rate}}{double.}
#'   \item{\code{off_standard_downs_explosiveness}}{double.}
#'   \item{\code{off_passing_downs_rate}}{double.}
#'   \item{\code{off_passing_downs_ppa}}{double.}
#'   \item{\code{off_passing_downs_success_rate}}{double.}
#'   \item{\code{off_passing_downs_explosiveness}}{double.}
#'   \item{\code{off_rushing_plays_rate}}{double.}
#'   \item{\code{off_rushing_plays_ppa}}{double.}
#'   \item{\code{off_rushing_plays_total_ppa}}{double.}
#'   \item{\code{off_rushing_plays_success_rate}}{double.}
#'   \item{\code{off_rushing_plays_explosiveness}}{double.}
#'   \item{\code{off_passing_plays_rate}}{double.}
#'   \item{\code{off_passing_plays_ppa}}{double.}
#'   \item{\code{off_passing_plays_total_ppa}}{double.}
#'   \item{\code{off_passing_plays_success_rate}}{double.}
#'   \item{\code{off_passing_plays_explosiveness}}{double.}
#'   \item{\code{def_plays}}{integer.}
#'   \item{\code{def_drives}}{integer.}
#'   \item{\code{def_ppa}}{double.}
#'   \item{\code{def_total_ppa}}{double.}
#'   \item{\code{def_success_rate}}{double.}
#'   \item{\code{def_explosiveness}}{double.}
#'   \item{\code{def_power_success}}{double.}
#'   \item{\code{def_stuff_rate}}{double.}
#'   \item{\code{def_line_yds}}{double.}
#'   \item{\code{def_line_yds_total}}{integer.}
#'   \item{\code{def_second_lvl_yds}}{double.}
#'   \item{\code{def_second_lvl_yds_total}}{integer.}
#'   \item{\code{def_open_field_yds}}{double.}
#'   \item{\code{def_open_field_yds_total}}{integer.}
#'   \item{\code{def_pts_per_opp}}{double.}
#'   \item{\code{def_field_pos_avg_start}}{integer.}
#'   \item{\code{def_field_pos_avg_predicted_points}}{double.}
#'   \item{\code{def_havoc_total}}{double.}
#'   \item{\code{def_havoc_front_seven}}{double.}
#'   \item{\code{def_havoc_db}}{double.}
#'   \item{\code{def_standard_downs_rate}}{double.}
#'   \item{\code{def_standard_downs_ppa}}{double.}
#'   \item{\code{def_standard_downs_success_rate}}{double.}
#'   \item{\code{def_standard_downs_explosiveness}}{double.}
#'   \item{\code{def_passing_downs_rate}}{double.}
#'   \item{\code{def_passing_downs_ppa}}{double.}
#'   \item{\code{def_passing_downs_total_ppa}}{double.}
#'   \item{\code{def_passing_downs_success_rate}}{double.}
#'   \item{\code{def_passing_downs_explosiveness}}{double.}
#'   \item{\code{def_rushing_plays_rate}}{double.}
#'   \item{\code{def_rushing_plays_ppa}}{double.}
#'   \item{\code{def_rushing_plays_total_ppa}}{double.}
#'   \item{\code{def_rushing_plays_success_rate}}{double.}
#'   \item{\code{def_rushing_plays_explosiveness}}{double.}
#'   \item{\code{def_passing_plays_rate}}{double.}
#'   \item{\code{def_passing_plays_ppa}}{double.}
#'   \item{\code{def_passing_plays_success_rate}}{double.}
#'   \item{\code{def_passing_plays_explosiveness}}{double.}
#' }
#' @source \url{https://api.collegefootballdata.com/stats/season/advanced}
#' @keywords Team Season Advanced Stats
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode URLdecode
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#' @export
#' @examples
#' \dontrun{
#' cfbd_stats_season_advanced(2019, team = "LSU")
#' }
#'
cfbd_stats_season_advanced <- function(year,
                                       team = NULL,
                                       excl_garbage_time = FALSE,
                                       start_week = NULL,
                                       end_week = NULL) {

  # Check if year is numeric
  assertthat::assert_that(is.numeric(year) & nchar(year) == 4,
    msg = "Enter valid year (Integer): 4-digit (YYYY)"
  )
  if (!is.null(team)) {
    if (team == "San Jose State") {
      team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team parameter for URL if not NULL
      team <- utils::URLencode(team, reserved = TRUE)
    }
  }
  if (excl_garbage_time != FALSE) {
    # Check if excl_garbage_time is TRUE, if not FALSE
    assertthat::assert_that(excl_garbage_time == TRUE,
      msg = "Enter valid excl_garbage_time value (Logical) - TRUE or FALSE"
    )
  }
  if (!is.null(start_week)) {
    # Check if start_week is numeric, if not NULL
    assertthat::assert_that(is.numeric(start_week) & nchar(start_week) <= 2,
      msg = "Enter valid start_week (Integer): 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)"
    )
  }
  if (!is.null(end_week)) {
    # Check if week is numeric, if not NULL
    assertthat::assert_that(is.numeric(end_week) & nchar(end_week) <= 2,
      msg = "Enter valid end_week (Integer): 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)"
    )
  }
  if (!is.null(start_week) & !is.null(end_week)) {
    assertthat::assert_that(start_week <= end_week,
      msg = "Enter valid start_week, end_week range"
    )
  }



  base_url <- "https://api.collegefootballdata.com/stats/season/advanced?"

  full_url <- paste0(
    base_url,
    "year=", year,
    "&team=", team,
    "&excludeGarbageTime=", excl_garbage_time,
    "&startWeek=", start_week,
    "&endWeek=", end_week
  )

  # Check for internet
  check_internet()

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
      # Get the content and return result as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE)
      colnames(df) <- gsub("offense.", "off_", colnames(df))
      colnames(df) <- gsub("defense.", "def_", colnames(df))
      colnames(df) <- gsub("Rate", "_rate", colnames(df))
      colnames(df) <- gsub("Total", "_total", colnames(df))
      colnames(df) <- gsub("Downs", "_downs", colnames(df))
      colnames(df) <- gsub("lineYards", "line_yds", colnames(df))
      colnames(df) <- gsub("secondLevelYards", "second_lvl_yds", colnames(df))
      colnames(df) <- gsub("openFieldYards", "open_field_yds", colnames(df))
      colnames(df) <- gsub("Success", "_success", colnames(df))
      colnames(df) <- gsub("fieldPosition", "field_pos", colnames(df))
      colnames(df) <- gsub("pointsPerOpportunity", "pts_per_opp", colnames(df))
      colnames(df) <- gsub("average", "avg_", colnames(df))
      colnames(df) <- gsub("Plays", "_plays", colnames(df))
      colnames(df) <- gsub("PPA", "_ppa", colnames(df))
      colnames(df) <- gsub("PredictedPoints", "predicted_points", colnames(df))
      colnames(df) <- gsub("Seven", "_seven", colnames(df))
      colnames(df) <- gsub(".avg", "_avg", colnames(df))
      colnames(df) <- gsub(".rate", "_rate", colnames(df))
      colnames(df) <- gsub(".explosiveness", "_explosiveness", colnames(df))
      colnames(df) <- gsub(".ppa", "_ppa", colnames(df))
      colnames(df) <- gsub(".total", "_total", colnames(df))
      colnames(df) <- gsub(".success", "_success", colnames(df))
      colnames(df) <- gsub(".front", "_front", colnames(df))
      colnames(df) <- gsub("_Start", "_start", colnames(df))
      colnames(df) <- gsub(".db", "_db", colnames(df))

      df <- df %>%
        as.data.frame()

      message(glue::glue("{Sys.time()}: Scraping season advanced stats..."))
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no season advanced stats data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' Get Season Statistics by Player
#' @rdname cfbd_stats
#'
#' @param year (\emph{Integer} required): Year, 4 digit format (\emph{YYYY})
#' @param season_type (\emph{String} default: regular): Select Season Type - regular, postseason, or both
#' @param team (\emph{String} optional): D-I Team
#' @param conference (\emph{String} optional): Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC\cr
#' @param start_week (\emph{Integer} optional): Starting Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param end_week (\emph{Integer} optional): Ending Week - values range fom 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param category (\emph{String} optional): Category filter (e.g defensive)\cr
#' Offense: passing, receiving, rushing\cr
#' Defense: defensive, fumbles, interceptions\cr
#' Special Teams: punting, puntReturns, kicking, kickReturns\cr
#'
#' @return \code{\link[cfbfastR:cfbd_stats_season_player]{cfbfastR::cfbd_stats_season_player()}} - A data frame with 59 variables:
#' \describe{
#'   \item{\code{team}}{character.}
#'   \item{\code{conference}}{character.}
#'   \item{\code{athlete_id}}{character.}
#'   \item{\code{player}}{character.}
#'   \item{\code{category}}{character.}
#'   \item{\code{passing_completions}}{double.}
#'   \item{\code{passing_att}}{double.}
#'   \item{\code{passing_pct}}{double.}
#'   \item{\code{passing_yds}}{double.}
#'   \item{\code{passing_td}}{double.}
#'   \item{\code{passing_int}}{double.}
#'   \item{\code{passing_ypa}}{double.}
#'   \item{\code{rushing_car}}{double.}
#'   \item{\code{rushing_yds}}{double.}
#'   \item{\code{rushing_td}}{double.}
#'   \item{\code{rushing_ypc}}{double.}
#'   \item{\code{rushing_long}}{double.}
#'   \item{\code{receiving_rec}}{double.}
#'   \item{\code{receiving_yds}}{double.}
#'   \item{\code{receiving_td}}{double.}
#'   \item{\code{receiving_ypr}}{double.}
#'   \item{\code{receiving_long}}{double.}
#'   \item{\code{fumbles_fum}}{double.}
#'   \item{\code{fumbles_rec}}{double.}
#'   \item{\code{fumbles_lost}}{double.}
#'   \item{\code{defensive_solo}}{double.}
#'   \item{\code{defensive_tot}}{double.}
#'   \item{\code{defensive_tfl}}{double.}
#'   \item{\code{defensive_sacks}}{double.}
#'   \item{\code{defensive_qb_hur}}{double.}
#'   \item{\code{interceptions_int}}{double.}
#'   \item{\code{interceptions_yds}}{double.}
#'   \item{\code{interceptions_avg}}{double.}
#'   \item{\code{interceptions_td}}{double.}
#'   \item{\code{defensive_pd}}{double.}
#'   \item{\code{defensive_td}}{double.}
#'   \item{\code{kicking_fgm}}{double.}
#'   \item{\code{kicking_fga}}{double.}
#'   \item{\code{kicking_pct}}{double.}
#'   \item{\code{kicking_xpa}}{double.}
#'   \item{\code{kicking_xpm}}{double.}
#'   \item{\code{kicking_pts}}{double.}
#'   \item{\code{kicking_long}}{double.}
#'   \item{\code{kick_returns_no}}{double.}
#'   \item{\code{kick_returns_yds}}{double.}
#'   \item{\code{kick_returns_avg}}{double.}
#'   \item{\code{kick_returns_td}}{double.}
#'   \item{\code{kick_returns_long}}{double.}
#'   \item{\code{punting_no}}{double.}
#'   \item{\code{punting_yds}}{double.}
#'   \item{\code{punting_ypp}}{double.}
#'   \item{\code{punting_long}}{double.}
#'   \item{\code{punting_in_20}}{double.}
#'   \item{\code{punting_tb}}{double.}
#'   \item{\code{punt_returns_no}}{double.}
#'   \item{\code{punt_returns_yds}}{double.}
#'   \item{\code{punt_returns_avg}}{double.}
#'   \item{\code{punt_returns_td}}{double.}
#'   \item{\code{punt_returns_long}}{double.}
#' }
#' @source \url{https://api.collegefootballdata.com/stats/player/season}
#' @keywords Player Season Stats
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode URLdecode
#' @importFrom assertthat assert_that
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @importFrom dplyr mutate mutate_at rename select
#' @importFrom tidyr pivot_wider everything
#' @export
#' @examples
#' \dontrun{
#' cfbd_stats_season_player(year = 2018, conference = "B12", start_week = 1, end_week = 7)
#'
#' cfbd_stats_season_player(2019, team = "LSU", category = "passing")
#'
#' cfbd_stats_season_player(2013, team = "Florida State", category = "passing")
#' }
#'
cfbd_stats_season_player <- function(year,
                                     season_type = "regular",
                                     team = NULL,
                                     conference = NULL,
                                     start_week = NULL,
                                     end_week = NULL,
                                     category = NULL) {
  stat_categories <- c(
    "passing", "receiving", "rushing", "defensive", "fumbles",
    "interceptions", "punting", "puntReturns", "kicking", "kickReturns"
  )

  # Check if year is numeric
  assertthat::assert_that(is.numeric(year) & nchar(year) == 4,
    msg = "Enter valid year (Integer): 4-digit (YYYY)"
  )

  if (season_type != "regular") {
    # Check if season_type is appropriate, if not NULL
    assertthat::assert_that(season_type %in% c("postseason", "both"),
      msg = "Enter valid season_type (String): regular, postseason, or both"
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
  if (!is.null(conference)) {
    # # Check conference parameter in conference abbreviations, if not NULL
    # assertthat::assert_that(conference %in% cfbfastR::cfbd_conf_types_df$abbreviation,
    #             msg = "Incorrect conference abbreviation, potential misspelling.\nConference abbreviations P5: ACC, B12, B1G, SEC, PAC\nConference abbreviations G5 and Independents: CUSA, MAC, MWC, Ind, SBC, AAC")
    # Encode conference parameter for URL, if not NULL
    conference <- utils::URLencode(conference, reserved = TRUE)
  }

  if (!is.null(start_week)) {
    # Check if start_week is numeric, if not NULL
    assertthat::assert_that(is.numeric(start_week) & nchar(start_week) <= 2,
      msg = "Enter valid start_week (Integer): 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)"
    )
  }
  if (!is.null(end_week)) {
    # Check if week is numeric, if not NULL
    assertthat::assert_that(is.numeric(end_week) & nchar(end_week) <= 2,
      msg = "Enter valid end_week (Integer): 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)"
    )
  }
  if (!is.null(start_week) & !is.null(end_week)) {
    assertthat::assert_that(start_week <= end_week,
      msg = "Enter valid start_week, end_week range"
    )
  }
  if (!is.null(category)) {
    # Check category parameter in category if not NULL
    assertthat::assert_that(category %in% stat_categories,
      msg = "Incorrect category, potential misspelling.\nOffense: passing, receiving, rushing\nDefense: defensive, fumbles, interceptions\nSpecial Teams: punting, puntReturns, kicking, kickReturns"
    )
    # Encode conference parameter for URL, if not NULL
    category <- utils::URLencode(category, reserved = TRUE)
  }


  base_url <- "https://api.collegefootballdata.com/stats/player/season?"

  full_url <- paste0(
    base_url,
    "year=", year,
    "&seasonType=", season_type,
    "&startWeek=", start_week,
    "&endWeek=", end_week,
    "&team=", team,
    "&conference=", conference,
    "&category=", category
  )

  # Check for internet
  check_internet()

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  # Create the GET request and set response as res
  res <- httr::RETRY(
    "GET", full_url,
    httr::add_headers(Authorization = paste("Bearer", cfbd_key()))
  )

  # Check the result
  check_status(res)

  cols <- c(
    "team", "conference", "athlete_id", "player", "category",
    "passing_completions", "passing_att", "passing_pct", "passing_yds",
    "passing_td", "passing_int", "passing_ypa",
    "rushing_car", "rushing_yds", "rushing_td", "rushing_ypc", "rushing_long",
    "receiving_rec", "receiving_yds", "receiving_td", "receiving_ypr", "receiving_long",
    "fumbles_fum", "fumbles_rec", "fumbles_lost",
    "defensive_solo", "defensive_tot", "defensive_tfl", "defensive_sacks",
    "defensive_qb_hur", "interceptions_int", "interceptions_yds",
    "interceptions_avg", "interceptions_td", "defensive_pd", "defensive_td",
    "kicking_fgm", "kicking_fga", "kicking_pct",
    "kicking_xpa", "kicking_xpm", "kicking_pts", "kicking_long",
    "kick_returns_no", "kick_returns_yds", "kick_returns_avg",
    "kick_returns_td", "kick_returns_long",
    "punting_no", "punting_yds", "punting_ypp",
    "punting_long", "punting_in_20", "punting_tb",
    "punt_returns_no", "punt_returns_yds", "punt_returns_avg",
    "punt_returns_td", "punt_returns_long"
  )

  numeric_cols <- c(
    "passing_completions", "passing_att", "passing_pct", "passing_yds",
    "passing_td", "passing_int", "passing_ypa",
    "rushing_car", "rushing_yds", "rushing_td", "rushing_ypc", "rushing_long",
    "receiving_rec", "receiving_yds", "receiving_td", "receiving_ypr", "receiving_long",
    "fumbles_fum", "fumbles_rec", "fumbles_lost",
    "defensive_solo", "defensive_tot", "defensive_tfl", "defensive_sacks",
    "defensive_qb_hur", "interceptions_int", "interceptions_yds",
    "interceptions_avg", "interceptions_td", "defensive_pd", "defensive_td",
    "kicking_fgm", "kicking_fga", "kicking_pct",
    "kicking_xpa", "kicking_xpm", "kicking_pts", "kicking_long",
    "kick_returns_no", "kick_returns_yds", "kick_returns_avg",
    "kick_returns_td", "kick_returns_long",
    "punting_no", "punting_yds", "punting_ypp",
    "punting_long", "punting_in_20", "punting_tb",
    "punt_returns_no", "punt_returns_yds", "punt_returns_avg",
    "punt_returns_td", "punt_returns_long"
  )



  df <- data.frame()
  tryCatch(
    expr = {
      # Get the content and return result as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON() %>%
        dplyr::mutate(
          statType = paste0(.data$category, "_", .data$statType)
        ) %>%
        tidyr::pivot_wider(
          names_from = .data$statType,
          values_from = .data$stat
        ) %>%
        dplyr::rename(athlete_id = .data$playerId) %>%
        janitor::clean_names()

      df[cols[!(cols %in% colnames(df))]] <- NA

      df <- df %>%
        dplyr::select(cols, tidyr::everything()) %>%
        dplyr::mutate_at(numeric_cols, as.numeric) %>%
        as.data.frame()

      message(glue::glue("{Sys.time()}: Scraping season stats - player..."))
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no season stats - player data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' Get Season Statistics by Team
#' @rdname cfbd_stats
#'
#' @param year (\emph{Integer} required): Year, 4 digit format (\emph{YYYY})
#' @param season_type (\emph{String} default: regular): Select Season Type - regular, postseason, or both
#' @param team (\emph{String} optional): D-I Team
#' @param conference (\emph{String} optional): Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC\cr
#' @param start_week (\emph{Integer} optional): Starting Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param end_week (\emph{Integer} optional): Ending Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#'
#' @return \code{\link[cfbfastR:cfbd_stats_season_team]{cfbfastR::cfbd_stats_season_team()}} - A data frame with 46 variables:
#' \describe{
#'   \item{\code{games}}{integer.}
#'   \item{\code{team}}{character.}
#'   \item{\code{conference}}{character.}
#'   \item{\code{games}}{integer.}
#'   \item{\code{time_of_poss_total}}{integer.}
#'   \item{\code{time_of_poss_pg}}{double.}
#'   \item{\code{pass_comps}}{integer.}
#'   \item{\code{pass_atts}}{integer.}
#'   \item{\code{completion_pct}}{double.}
#'   \item{\code{net_pass_yds}}{integer.}
#'   \item{\code{pass_ypa}}{double.}
#'   \item{\code{pass_ypr}}{double.}
#'   \item{\code{pass_TDs}}{integer.}
#'   \item{\code{interceptions}}{integer.}
#'   \item{\code{int_pct}}{double.}
#'   \item{\code{rush_atts}}{integer.}
#'   \item{\code{rush_yds}}{integer.}
#'   \item{\code{rush_TDs}}{integer.}
#'   \item{\code{rush_ypc}}{double.}
#'   \item{\code{total_yds}}{integer.}
#'   \item{\code{fumbles_lost}}{integer.}
#'   \item{\code{turnovers}}{integer.}
#'   \item{\code{turnovers_pg}}{double.}
#'   \item{\code{first_downs}}{integer.}
#'   \item{\code{third_downs}}{integer.}
#'   \item{\code{third_down_convs}}{integer.}
#'   \item{\code{third_conv_rate}}{double.}
#'   \item{\code{fourth_down_convs}}{integer.}
#'   \item{\code{fourth_downs}}{integer.}
#'   \item{\code{fourth_conv_rate}}{double.}
#'   \item{\code{penalties}}{integer.}
#'   \item{\code{penalty_yds}}{integer.}
#'   \item{\code{penalties_pg}}{double.}
#'   \item{\code{penalty_yds_pg}}{double.}
#'   \item{\code{yards_per_penalty}}{double.}
#'   \item{\code{kick_returns}}{integer.}
#'   \item{\code{kick_return_yds}}{integer.}
#'   \item{\code{kick_return_TDs}}{integer.}
#'   \item{\code{kick_return_avg}}{double.}
#'   \item{\code{punt_returns}}{integer.}
#'   \item{\code{punt_return_yds}}{integer.}
#'   \item{\code{punt_return_TDs}}{integer.}
#'   \item{\code{punt_return_avg}}{double.}
#'   \item{\code{passes_intercepted}}{integer.}
#'   \item{\code{passes_intercepted_yds}}{integer.}
#'   \item{\code{passes_intercepted_TDs}}{integer.}
#' }
#' @source \url{https://api.collegefootballdata.com/stats/season}
#' @keywords Team Season Stats
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode URLdecode
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#' @importFrom dplyr select mutate rename
#' @importFrom tidyr pivot_wider
#' @export
#' @examples
#' \dontrun{
#' cfbd_stats_season_team(year = 2018, conference = "B12", start_week = 1, end_week = 8)
#'
#' cfbd_stats_season_team(2019, team = "LSU")
#'
#' cfbd_stats_season_team(2013, team = "Florida State")
#' }
#'
cfbd_stats_season_team <- function(year,
                                   season_type = "regular",
                                   team = NULL,
                                   conference = NULL,
                                   start_week = NULL,
                                   end_week = NULL) {

  # Check if year is numeric
  assertthat::assert_that(is.numeric(year) & nchar(year) == 4,
    msg = "Enter valid year (Integer): 4-digit (YYYY)"
  )
  if (season_type != "regular") {
    # Check if season_type is appropriate, if not NULL
    assertthat::assert_that(season_type %in% c("postseason", "both"),
      msg = "Enter valid season_type (String): regular, postseason, or both"
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
  if (!is.null(conference)) {
    # # Check conference parameter in conference abbreviations, if not NULL
    # assertthat::assert_that(conference %in% cfbfastR::cfbd_conf_types_df$abbreviation,
    #             msg = "Incorrect conference abbreviation, potential misspelling.\nConference abbreviations P5: ACC, B12, B1G, SEC, PAC\nConference abbreviations G5 and Independents: CUSA, MAC, MWC, Ind, SBC, AAC")
    # Encode conference parameter for URL, if not NULL
    conference <- utils::URLencode(conference, reserved = TRUE)
  }

  if (!is.null(start_week)) {
    # Check if start_week is numeric, if not NULL
    assertthat::assert_that(is.numeric(start_week) & nchar(start_week) <= 2,
      msg = "Enter valid start_week (Integer): 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)"
    )
  }
  if (!is.null(end_week)) {
    # Check if week is numeric, if not NULL
    assertthat::assert_that(is.numeric(end_week) & nchar(end_week) <= 2,
      msg = "Enter valid end_week (Integer): 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)"
    )
  }
  if (!is.null(start_week) & !is.null(end_week)) {
    assertthat::assert_that(start_week <= end_week,
      msg = "Enter valid start_week, end_week range"
    )
  }



  base_url <- "https://api.collegefootballdata.com/stats/season?"

  full_url <- paste0(
    base_url,
    "year=", year,
    "&seasonType=", season_type,
    "&startWeek=", start_week,
    "&endWeek=", end_week,
    "&team=", team,
    "&conference=", conference
  )

  # Check for internet
  check_internet()

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

  # Expected column names for full season data
  expected_colnames <- c(
    "season", "team", "conference", "passesIntercepted", "turnovers",
    "interceptionYards", "fumblesRecovered", "passCompletions", "rushingTDs", "puntReturnYards",
    "games", "fourthDowns", "puntReturns", "rushingYards", "totalYards",
    "kickReturnYards", "passingTDs", "rushingAttempts", "netPassingYards", "kickReturns",
    "possessionTime", "fourthDownConversions", "penalties", "puntReturnTDs", "firstDowns",
    "interceptionTDs", "penaltyYards", "passAttempts", "kickReturnTDs", "interceptions",
    "thirdDownConversions", "thirdDowns", "fumblesLost"
  )
  tryCatch(
    expr = {
      # Get the content and return result as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON()

      # Pivot category columns to get stats for each team game on one row
      df <- tidyr::pivot_wider(df,
        names_from = .data$statName,
        values_from = .data$statValue
      )

      # Find missing columns, if any, and add them to found data
      missing <- setdiff(expected_colnames, colnames(df))
      df[missing] <- NA_real_

      df <- df %>%
        dplyr::mutate(
          time_of_poss_pg = ifelse(is.na("games"), NA_real_, .data$possessionTime / 3600 / .data$games),
          completion_pct = ifelse(is.na("passAttempts"), NA_real_, .data$passCompletions / .data$passAttempts),
          pass_ypa = ifelse(is.na("passAttempts"), NA_real_, .data$netPassingYards / .data$passAttempts),
          pass_ypr = ifelse(is.na("passCompletions"), NA_real_, .data$netPassingYards / .data$passCompletions),
          int_pct = ifelse(is.na("passAttempts"), NA_real_, .data$interceptions / .data$passAttempts),
          rush_ypc = ifelse(is.na("rushingAttempts"), NA_real_, .data$rushingYards / .data$rushingAttempts),
          third_conv_rate = ifelse(is.na("thirdDowns"), NA_real_, .data$thirdDownConversions / .data$thirdDowns),
          fourth_conv_rate = ifelse(is.na("fourthDowns"), NA_real_, .data$fourthDownConversions / .data$fourthDowns),
          penalties_pg = ifelse(is.na("games"), NA_real_, .data$penalties / .data$games),
          penalty_yds_pg = ifelse(is.na("games"), NA_real_, .data$penaltyYards / .data$games),
          yards_per_penalty = ifelse(is.na("penalties"), NA_real_, .data$penaltyYards / .data$penalties),
          turnovers_pg = ifelse(is.na("games"), NA_real_, .data$turnovers / .data$games),
          kick_return_avg = ifelse(is.na("kickReturns"), NA_real_, .data$kickReturnYards / .data$kickReturns),
          punt_return_avg = ifelse(is.na("puntReturns"), NA_real_, .data$puntReturnYards / .data$puntReturns)
        ) %>%
        dplyr::select(
          .data$season, .data$team, .data$conference,
          .data$games, .data$possessionTime, .data$time_of_poss_pg,
          .data$passCompletions, .data$passAttempts, .data$completion_pct,
          .data$netPassingYards, .data$pass_ypa, .data$pass_ypr,
          .data$passingTDs, .data$interceptions, .data$int_pct,
          .data$rushingAttempts, .data$rushingYards, .data$rushingTDs,
          .data$rush_ypc, .data$totalYards,
          .data$fumblesLost, .data$turnovers, .data$turnovers_pg,
          .data$firstDowns, .data$thirdDowns, .data$thirdDownConversions,
          .data$third_conv_rate, .data$fourthDownConversions,
          .data$fourthDowns, .data$fourth_conv_rate,
          .data$penalties, .data$penaltyYards, .data$penalties_pg,
          .data$penalty_yds_pg, .data$yards_per_penalty,
          .data$kickReturns, .data$kickReturnYards,
          .data$kickReturnTDs, .data$kick_return_avg,
          .data$puntReturns, .data$puntReturnYards,
          .data$puntReturnTDs, .data$punt_return_avg,
          .data$passesIntercepted, .data$interceptionYards, .data$interceptionTDs
        ) %>%
        dplyr::rename(
          time_of_poss_total = .data$possessionTime,
          pass_comps = .data$passCompletions,
          pass_atts = .data$passAttempts,
          net_pass_yds = .data$netPassingYards,
          pass_TDs = .data$passingTDs,
          rush_atts = .data$rushingAttempts,
          rush_yds = .data$rushingYards,
          rush_TDs = .data$rushingTDs,
          total_yds = .data$totalYards,
          fumbles_lost = .data$fumblesLost,
          first_downs = .data$firstDowns,
          third_downs = .data$thirdDowns,
          third_down_convs = .data$thirdDownConversions,
          fourth_downs = .data$fourthDowns,
          fourth_down_convs = .data$fourthDownConversions,
          penalty_yds = .data$penaltyYards,
          kick_returns = .data$kickReturns,
          kick_return_yds = .data$kickReturnYards,
          kick_return_TDs = .data$kickReturnTDs,
          punt_returns = .data$puntReturns,
          punt_return_yds = .data$puntReturnYards,
          punt_return_TDs = .data$puntReturnTDs,
          passes_intercepted = .data$passesIntercepted,
          passes_intercepted_yds = .data$interceptionYards,
          passes_intercepted_TDs = .data$interceptionTDs
        ) %>%
        as.data.frame()

      message(glue::glue("{Sys.time()}: Scraping season team stats..."))
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no season team stats data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}
