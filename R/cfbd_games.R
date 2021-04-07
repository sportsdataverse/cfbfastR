#' CFBD Games Endpoint
#'
#' @name cfbd_games
NULL
#' Get results information from games
#' @rdname cfbd_games
#' @param year (\emph{Integer} required): Year, 4 digit format(\emph{YYYY})
#' @param week (\emph{Integer} optional): Week - values from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
#' @param season_type (\emph{String} default regular): Select Season Type: regular, postseason, or both
#' @param team (\emph{String} optional): D-I Team
#' @param home_team (\emph{String} optional): Home D-I Team
#' @param away_team (\emph{String} optional): Away D-I Team
#' @param conference (\emph{String} optional): Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC\cr
#' @param game_id (\emph{Integer} optional): Game ID filter for querying a single game
#' @param quarter_scores (\emph{Logical} default FALSE): This is a parameter to return the
#' list columns that give the score at each quarter: `home_line_scores` and `away_line_scores`.\cr
#' I have defaulted the parameter to false so that you will not have to go to the trouble of dropping it.
#'
#' @return \code{\link[cfbfastR:cfbd_game_info]{cfbfastR::cfbd_game_info()}} - A data frame with 22 variables:
#' \describe{
#'   \item{\code{game_id}}{integer.}
#'   \item{\code{season}}{integer.}
#'   \item{\code{week}}{integer.}
#'   \item{\code{season_type}}{character.}
#'   \item{\code{start_date}}{character.}
#'   \item{\code{start_time_tbd}}{logical.}
#'   \item{\code{neutral_site}}{logical.}
#'   \item{\code{conference_game}}{logical.}
#'   \item{\code{attendance}}{integer.}
#'   \item{\code{venue_id}}{integer.}
#'   \item{\code{venue}}{character.}
#'   \item{\code{home_id}}{integer.}
#'   \item{\code{home_team}}{character.}
#'   \item{\code{home_conference}}{character.}
#'   \item{\code{home_points}}{integer.}
#'   \item{\code{home_post_win_prob}}{character.}
#'   \item{\code{away_id}}{integer.}
#'   \item{\code{away_team}}{character.}
#'   \item{\code{away_conference}}{character.}
#'   \item{\code{away_points}}{integer.}
#'   \item{\code{away_post_win_prob}}{character.}
#'   \item{\code{excitement_index}}{character.}
#' }
#' @source \url{https://api.collegefootballdata.com/games}
#' @keywords Game Info
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @export
#' @examples
#'
#' cfbd_game_info(2018, week = 1)
#'
#' cfbd_game_info(2018, week = 7, conference = "Ind")
#'
#' # 7 OTs LSU @ TAMU
#' cfbd_game_info(2018, week = 13, team = "Texas A&M", quarter_scores = TRUE)
cfbd_game_info <- function(year,
                           week = NULL,
                           season_type = "regular",
                           team = NULL,
                           home_team = NULL,
                           away_team = NULL,
                           conference = NULL,
                           game_id = NULL,
                           quarter_scores = FALSE) {
  # Check if year is numeric
  assertthat::assert_that(is.numeric(year) & nchar(year) == 4,
    msg = "Enter valid year as a number (YYYY)"
  )
  if (!is.null(week)) {
    # Check if week is numeric, if not NULL
    assertthat::assert_that(is.numeric(week) & nchar(week) <= 2,
      msg = "Enter valid week 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)"
    )
  }
  if (season_type != "regular") {
    # Check if season_type is appropriate, if not regular
    assertthat::assert_that(season_type %in% c("postseason", "both"),
      msg = "Enter valid season_type: regular, postseason, or both"
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
  if (!is.null(home_team)) {
    if (home_team == "San Jose State") {
      home_team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode home_team parameter for URL if not NULL
      home_team <- utils::URLencode(home_team, reserved = TRUE)
    }
  }
  if (!is.null(away_team)) {
    if (away_team == "San Jose State") {
      away_team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team parameter for URL if not NULL
      away_team <- utils::URLencode(away_team, reserved = TRUE)
    }
  }
  if (!is.null(conference)) {
    # # Check conference parameter in conference abbreviations, if not NULL
    # assertthat::assert_that(conference %in% cfbfastR::cfbd_conf_types_df$abbreviation,
    #             msg = "Incorrect conference abbreviation, potential misspelling.\nConference abbreviations P5: ACC, B12, B1G, SEC, PAC\nConference abbreviations G5 and Independents: CUSA, MAC, MWC, Ind, SBC, AAC")
    # Encode conference parameter for URL, if not NULL
    conference <- utils::URLencode(conference, reserved = TRUE)
  }
  if (!is.null(game_id)) {
    # Check if game_id is numeric, if not NULL
    assertthat::assert_that(is.numeric(game_id),
      msg = "Enter valid game_id (numeric value)"
    )
  }

  base_url <- "https://api.collegefootballdata.com/games?"

  full_url <- paste0(
    base_url,
    "year=", year,
    "&week=", week,
    "&seasonType=", season_type,
    "&team=", team,
    "&home=", home_team,
    "&away=", away_team,
    "&conference=", conference,
    "&id=", game_id
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
      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON()

      if (!quarter_scores) {
        df <- dplyr::select(df, -.data$home_line_scores, -.data$away_line_scores) %>%
          dplyr::rename(game_id = .data$id) %>%
          as.data.frame()
      } else {
        df <- df %>%
          tidyr::unnest_wider(.data$home_line_scores, names_sep = "_Q") %>%
          tidyr::unnest_wider(.data$away_line_scores, names_sep = "_Q")

        colnames(df) <- gsub("_line_scores", "_scores", colnames(df))
        df <- df %>%
          dplyr::rename(game_id = .data$id) %>%
          as.data.frame()
      }
      message(glue::glue("{Sys.time()}: Scraping game info data..."))
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no game info data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}

#' Calendar - Returns calendar of weeks by season
#' @rdname cfbd_games
#' @param year (\emph{Integer} required): Year, 4 digit format (\emph{YYYY})
#'
#' @return \code{\link[cfbfastR:cfbd_calendar]{cfbfastR::cfbd_calendar()}} A data frame with 5 variables:
#' @source \url{https://api.collegefootballdata.com/calendar}
#' @importFrom dplyr rename mutate
#' @importFrom janitor clean_names
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#' @export
#' @examples
#' \dontrun{
#' cfbd_calendar(2019)
#' }
#'
cfbd_calendar <- function(year) {

  # check if year is numeric
  assert_that(is.numeric(year) & nchar(year) == 4,
    msg = "Enter valid year as a number (YYYY)"
  )


  base_url <- "https://api.collegefootballdata.com/calendar?"
  full_url <- paste0(
    base_url,
    "year=", year
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
      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON() %>%
        janitor::clean_names() %>%
        as.data.frame()

      message(glue::glue("{Sys.time()}: Scraping calendar..."))
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}:Invalid arguments or no calendar data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}

#' Get Game media information (TV, radio, etc)
#' @rdname cfbd_games
#' @param year (\emph{Integer} required): Year, 4 digit format (\emph{YYYY})
#' @param week (\emph{Integer} optional): Week, values from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
#' @param season_type (\emph{String} default both): Select Season Type, regular, postseason, or both
#' @param team (\emph{String} optional): D-I Team
#' @param conference (\emph{String} optional): Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC\cr
#' @param media_type (\emph{String} optional): Media type filter: tv, radio, web, ppv, or mobile
#'
#' @return \code{\link[cfbfastR:cfbd_game_media]{cfbfastR::cfbd_game_media()}} - A data frame with 13 variables:
#' \describe{
#'   \item{\code{game_id}}{integer.}
#'   \item{\code{season}}{integer.}
#'   \item{\code{week}}{integer.}
#'   \item{\code{season_type}}{character.}
#'   \item{\code{start_time}}{character.}
#'   \item{\code{is_start_time_tbd}}{logical.}
#'   \item{\code{home_team}}{character.}
#'   \item{\code{home_conference}}{character.}
#'   \item{\code{away_team}}{character.}
#'   \item{\code{away_conference}}{character.}
#'   \item{\code{tv}}{list.}
#'   \item{\code{radio}}{logical.}
#'   \item{\code{web}}{list.}
#' }
#' @source \url{https://api.collegefootballdata.com/games/media}
#' @keywords Game Info
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @export
#' @examples
#'
#' cfbd_game_media(2019, week = 4, conference = "ACC")
cfbd_game_media <- function(year,
                            week = NULL,
                            season_type = "both",
                            team = NULL,
                            conference = NULL,
                            media_type = NULL) {

  ## check if year is numeric
  assertthat::assert_that(is.numeric(year) & nchar(year) == 4,
    msg = "Enter valid year as a number (YYYY)"
  )
  if (!is.null(week)) {
    assertthat::assert_that(is.numeric(week) & nchar(week) <= 2,
      msg = "Enter valid week 1-15 \n(14 for seasons pre-playoff, i.e. 2014 or earlier)"
    )
  }
  if (season_type != "both") {
    # Check if season_type is appropriate, if not regular
    assertthat::assert_that(season_type %in% c("postseason", "regular"),
      msg = "Enter valid season_type: regular, postseason, or both"
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
    # Encode conference parameter for URL, if not NULL
    conference <- utils::URLencode(conference, reserved = TRUE)
  }

  base_url <- "https://api.collegefootballdata.com/games/media?"

  full_url <- paste0(
    base_url,
    "year=", year,
    "&week=", week,
    "&seasonType=", season_type,
    "&team=", team,
    "&conference=", conference,
    "&mediaType=", media_type
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
    "game_id", "season", "week", "season_type", "start_time",
    "is_start_time_tbd", "home_team", "home_conference", "away_team",
    "away_conference", "tv", "radio", "web"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON() %>%
        tidyr::pivot_wider(
          names_from = .data$mediaType,
          values_from = .data$outlet,
          values_fn = list
        ) %>%
        janitor::clean_names() %>%
        dplyr::rename(game_id = .data$id)

      df[cols[!(cols %in% colnames(df))]] <- NA
      df <- df[!duplicated(df), ]

      df <- df %>%
        dplyr::select(cols, tidyr::everything()) %>%
        as.data.frame()

      message(glue::glue("{Sys.time()}: Scraping game media data..."))
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no game media data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' Get game advanced box score information
#' @rdname cfbd_games
#' @param game_id (\emph{Integer} required): Game ID filter for querying a single game
#' Can be found using the \code{\link[cfbfastR:cfbd_game_info]{cfbfastR::cfbd_game_info()}} function
#' @param long (\emph{Logical} default `FALSE`): Return the data in a long format.
#' @return \code{\link[cfbfastR:cfbd_game_box_advanced]{cfbfastR::cfbd_game_box_advanced()}} - A data frame with 2 rows and 69 variables:
#' \describe{
#'   \item{\code{team}}{character.}
#'   \item{\code{plays}}{double.}
#'   \item{\code{ppa_overall_total}}{double.}
#'   \item{\code{ppa_overall_quarter1}}{double.}
#'   \item{\code{ppa_overall_quarter2}}{double.}
#'   \item{\code{ppa_overall_quarter3}}{double.}
#'   \item{\code{ppa_overall_quarter4}}{double.}
#'   \item{\code{ppa_passing_total}}{double.}
#'   \item{\code{ppa_passing_quarter1}}{double.}
#'   \item{\code{ppa_passing_quarter2}}{double.}
#'   \item{\code{ppa_passing_quarter3}}{double.}
#'   \item{\code{ppa_passing_quarter4}}{double.}
#'   \item{\code{ppa_rushing_total}}{double.}
#'   \item{\code{ppa_rushing_quarter1}}{double.}
#'   \item{\code{ppa_rushing_quarter2}}{double.}
#'   \item{\code{ppa_rushing_quarter3}}{double.}
#'   \item{\code{ppa_rushing_quarter4}}{double.}
#'   \item{\code{cumulative_ppa_plays}}{double.}
#'   \item{\code{cumulative_ppa_overall_total}}{double.}
#'   \item{\code{cumulative_ppa_overall_quarter1}}{double.}
#'   \item{\code{cumulative_ppa_overall_quarter2}}{double.}
#'   \item{\code{cumulative_ppa_overall_quarter3}}{double.}
#'   \item{\code{cumulative_ppa_overall_quarter4}}{double.}
#'   \item{\code{cumulative_ppa_passing_total}}{double.}
#'   \item{\code{cumulative_ppa_passing_quarter1}}{double.}
#'   \item{\code{cumulative_ppa_passing_quarter2}}{double.}
#'   \item{\code{cumulative_ppa_passing_quarter3}}{double.}
#'   \item{\code{cumulative_ppa_passing_quarter4}}{double.}
#'   \item{\code{cumulative_ppa_rushing_total}}{double.}
#'   \item{\code{cumulative_ppa_rushing_quarter1}}{double.}
#'   \item{\code{cumulative_ppa_rushing_quarter2}}{double.}
#'   \item{\code{cumulative_ppa_rushing_quarter3}}{double.}
#'   \item{\code{cumulative_ppa_rushing_quarter4}}{double.}
#'   \item{\code{success_rates_overall_total}}{double.}
#'   \item{\code{success_rates_overall_quarter1}}{double.}
#'   \item{\code{success_rates_overall_quarter2}}{double.}
#'   \item{\code{success_rates_overall_quarter3}}{double.}
#'   \item{\code{success_rates_overall_quarter4}}{double.}
#'   \item{\code{success_rates_standard_downs_total}}{double.}
#'   \item{\code{success_rates_standard_downs_quarter1}}{double.}
#'   \item{\code{success_rates_standard_downs_quarter2}}{double.}
#'   \item{\code{success_rates_standard_downs_quarter3}}{double.}
#'   \item{\code{success_rates_standard_downs_quarter4}}{double.}
#'   \item{\code{success_rates_passing_downs_total}}{double.}
#'   \item{\code{success_rates_passing_downs_quarter1}}{double.}
#'   \item{\code{success_rates_passing_downs_quarter2}}{double.}
#'   \item{\code{success_rates_passing_downs_quarter3}}{double.}
#'   \item{\code{success_rates_passing_downs_quarter4}}{double.}
#'   \item{\code{explosiveness_overall_total}}{double.}
#'   \item{\code{explosiveness_overall_quarter1}}{double.}
#'   \item{\code{explosiveness_overall_quarter2}}{double.}
#'   \item{\code{explosiveness_overall_quarter3}}{double.}
#'   \item{\code{explosiveness_overall_quarter4}}{double.}
#'   \item{\code{rushing_power_success}}{double.}
#'   \item{\code{rushing_stuff_rate}}{double.}
#'   \item{\code{rushing_line_yds}}{double.}
#'   \item{\code{rushing_line_yd_avg}}{double.}
#'   \item{\code{rushing_second_lvl_yds}}{double.}
#'   \item{\code{rushing_second_lvl_yd_avg}}{double.}
#'   \item{\code{rushing_open_field_yds}}{double.}
#'   \item{\code{rushing_open_field_yd_avg}}{double.}
#'   \item{\code{havoc_total}}{double.}
#'   \item{\code{havoc_front_seven}}{double.}
#'   \item{\code{havoc_db}}{double.}
#'   \item{\code{scoring_opps_opportunities}}{double.}
#'   \item{\code{scoring_opps_points}}{double.}
#'   \item{\code{scoring_opps_pts_per_opp}}{double.}
#'   \item{\code{field_pos_avg_start}}{double.}
#'   \item{\code{field_pos_avg_starting_predicted_pts}}{double.}
#' }
#' @source \url{https://api.collegefootballdata.com/game/box/advanced}
#' @keywords Game Advanced Box Score
#' @importFrom tibble enframe
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode URLdecode
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#' @importFrom stringr str_detect
#' @import dplyr
#' @import tidyr
#' @import purrr
#' @export
#' @examples
#'
#' cfbd_game_box_advanced(game_id = 401114233)
cfbd_game_box_advanced <- function(game_id, long = FALSE) {
  if (!is.null(game_id)) {
    # Check if game_id is numeric, if not NULL
    assertthat::assert_that(is.numeric(game_id),
      msg = "Enter valid game_id (numeric value)"
    )
  }

  base_url <- "https://api.collegefootballdata.com/game/box/advanced?"

  full_url <- paste0(
    base_url,
    "gameId=", game_id
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
      # Get the content, tidyr::unnest, and return result as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE) %>%
        purrr::map_if(is.data.frame, list) %>%
        purrr::map_if(is.data.frame, list)

      df <- tibble::enframe(unlist(df$teams, use.names = TRUE))
      team1 <- seq(1, nrow(df) - 1, by = 2)
      df1 <- df[team1, ] %>%
        dplyr::rename(
          stat = .data$name,
          team1 = .data$value
        )

      team2 <- seq(2, nrow(df), by = 2)
      df2 <- df[team2, ] %>%
        dplyr::rename(team2 = .data$value) %>%
        dplyr::select(.data$team2)

      df <- data.frame(cbind(df1, df2))
      df$stat <- substr(df$stat, 1, nchar(df$stat) - 1)
      df$stat <- sub(".overall.", "_overall_", df$stat)
      df$stat <- sub("Downs.", "_downs_", df$stat)
      df$stat <- sub("Rates.", "_rates_", df$stat)
      df$stat <- sub("Rate", "_rate", df$stat)
      df$stat <- sub(".passing.", "_passing_", df$stat)
      df$stat <- sub(".rushing.", "_rushing_", df$stat)
      df$stat <- sub("rushing.", "rushing_", df$stat)
      df$stat <- sub("rushing.", "rushing_", df$stat)
      df$stat <- sub("fieldPosition.", "field_pos_", df$stat)
      df$stat <- sub("lineYards", "line_yds", df$stat)
      df$stat <- sub("secondLevelYards", "second_lvl_yds", df$stat)
      df$stat <- sub("openFieldYards", "open_field_yds", df$stat)
      df$stat <- sub("Success", "_success", df$stat)
      df$stat <- sub("scoringOpportunities.", "scoring_opps_", df$stat)
      df$stat <- sub("pointsPerOpportunity", "pts_per_opp", df$stat)
      df$stat <- sub("Seven", "_seven", df$stat)
      df$stat <- sub("havoc.", "havoc_", df$stat)
      df$stat <- sub(".Average", "_avg", df$stat)
      df$stat <- sub("averageStartingPredictedPoints", "avg_starting_predicted_pts", df$stat)
      df$stat <- sub("averageStart", "avg_start", df$stat)
      df$stat <- sub(".team", "_team", df$stat)
      df$stat <- sub(".plays", "_plays", df$stat)
      df$stat <- sub("cumulativePpa", "cumulative_ppa", df$stat)

      if (!long) {
        team <- df %>%
          dplyr::filter(.data$stat == "ppa_team") %>%
          tidyr::pivot_longer(cols = c(.data$team1, .data$team2)) %>%
          dplyr::transmute(team = .data$value)

        df <- df %>%
          dplyr::filter(!stringr::str_detect(.data$stat, "team")) %>%
          tidyr::pivot_longer(cols = c(.data$team1, .data$team2)) %>%
          tidyr::pivot_wider(names_from = .data$stat, values_from = .data$value) %>%
          dplyr::select(-.data$name) %>%
          dplyr::mutate_all(as.numeric) %>%
          dplyr::bind_cols(team) %>%
          dplyr::select(.data$team, tidyr::everything()) %>%
          as.data.frame()
      }

      message(glue::glue("{Sys.time()}: Scraping game advanced box score data for game_id '{game_id}'..."))
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: game_id '{game_id}' invalid or no game advanced box score data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}

#' Get results information from games
#'
#' @rdname cfbd_games
#' @param year (\emph{Integer} required): Year, 4 digit format(\emph{YYYY})
#' @param week (\emph{Integer} optional): Week - values from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
#' @param season_type (\emph{String} default regular): Select Season Type: regular or postseason
#' @param team (\emph{String} optional): D-I Team
#' @param category (\emph{String} optional): Category filter (e.g defensive)\cr
#' Offense: passing, receiving, rushing\cr
#' Defense: defensive, fumbles, interceptions\cr
#' Special Teams: punting, puntReturns, kicking, kickReturns\cr
#' @param conference (\emph{String} optional): Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC\cr
#' @param game_id (\emph{Integer} optional): Game ID filter for querying a single game
#' Can be found using the \code{\link[cfbfastR:cfbd_game_info]{cfbfastR::cfbd_game_info()}} function
#'
#' @return \code{\link[cfbfastR:cfbd_game_player_stats]{cfbfastR::cfbd_game_player_stats()}} - A data frame with 32 variables:
#' \describe{
#'   \item{\code{game_id}}{integer.}
#'   \item{\code{team}}{character.}
#'   \item{\code{conference}}{character.}
#'   \item{\code{home_away}}{character.}
#'   \item{\code{points}}{integer.}
#'   \item{\code{category}}{character.}
#'   \item{\code{athlete_id}}{character.}
#'   \item{\code{name}}{character.}
#'   \item{\code{c_att}}{character.}
#'   \item{\code{yds}}{double.}
#'   \item{\code{avg}}{double.}
#'   \item{\code{td}}{double.}
#'   \item{\code{int}}{double.}
#'   \item{\code{qbr}}{double.}
#'   \item{\code{car}}{double.}
#'   \item{\code{long}}{double.}
#'   \item{\code{rec}}{double.}
#'   \item{\code{no}}{double.}
#'   \item{\code{fg}}{character.}
#'   \item{\code{pct}}{double.}
#'   \item{\code{xp}}{character.}
#'   \item{\code{pts}}{double.}
#'   \item{\code{tb}}{double.}
#'   \item{\code{in_20}}{double.}
#'   \item{\code{fum}}{double.}
#'   \item{\code{lost}}{double.}
#'   \item{\code{tot}}{double.}
#'   \item{\code{solo}}{double.}
#'   \item{\code{sacks}}{double.}
#'   \item{\code{tfl}}{double.}
#'   \item{\code{pd}}{double.}
#'   \item{\code{qb_hur}}{double.}
#' }
#' @source \url{https://api.collegefootballdata.com/games/players}
#' @keywords Game Info
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode URLdecode
#' @importFrom assertthat assert_that
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @import purrr
#' @export
#' @examples
#' \dontrun{
#' cfbd_game_player_stats(2018, week = 15, conference = "Ind")
#'
#' cfbd_game_player_stats(2013, week = 1, team = "Florida State", category = "passing")
#' }
#'
cfbd_game_player_stats <- function(year,
                                   week = NULL,
                                   season_type = "regular",
                                   team = NULL,
                                   conference = NULL,
                                   category = NULL,
                                   game_id = NULL) {
  stat_categories <- c(
    "passing", "receiving", "rushing", "defensive", "fumbles",
    "interceptions", "punting", "puntReturns", "kicking", "kickReturns"
  )

  args <- list(year, week, season_type, team, conference, category, game_id)

  args <- args[lengths(args) != 0]

  # Check if year is numeric
  assertthat::assert_that(is.numeric(year) & nchar(year) == 4,
    msg = "Enter valid year as a number (YYYY)"
  )
  if (!is.null(week)) {
    # Check if week is numeric, if not NULL
    assertthat::assert_that(is.numeric(week) & nchar(week) <= 2,
      msg = "Enter valid week 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)"
    )
  }
  if (season_type != "regular") {
    # Check if season_type is appropriate, if not regular
    assertthat::assert_that(season_type %in% c("postseason"),
      msg = "Enter valid season_type: regular, postseason"
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
  if (!is.null(category)) {
    # Check category parameter in category if not NULL
    assertthat::assert_that(category %in% stat_categories,
      msg = "Incorrect category, potential misspelling.\nOffense: passing, receiving, rushing\nDefense: defensive, fumbles, interceptions\nSpecial Teams: punting, puntReturns, kicking, kickReturns"
    )
    # Encode conference parameter for URL, if not NULL
    category <- utils::URLencode(category, reserved = TRUE)
  }
  if (!is.null(game_id)) {
    # Check if game_id is numeric, if not NULL
    assertthat::assert_that(is.numeric(game_id),
      msg = "Enter valid game_id (numeric value)"
    )
  }

  base_url <- "https://api.collegefootballdata.com/games/players?"

  full_url <- paste0(
    base_url,
    "year=", year,
    "&week=", week,
    "&seasonType=", season_type,
    "&team=", team,
    "&conference=", conference,
    "&category=", category,
    "&gameId=", game_id
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
    "game_id", "team", "conference", "home_away", "points", "category",
    "athlete_id", "name", "c_att", "yds", "avg", "td", "int", "qbr",
    "car", "long", "rec", "no", "fg", "pct", "xp", "pts", "tb", "in_20",
    "fum", "lost", "tot", "solo", "sacks", "tfl", "pd", "qb_hur"
  )
  numeric_cols <- c(
    "yds", "avg", "td", "int", "qbr",
    "car", "long", "rec", "no", "pct", "pts", "tb", "in_20",
    "fum", "lost", "tot", "solo", "sacks", "tfl", "pd", "qb_hur"
  )

  df <- data.frame()
  tryCatch(
    expr = {
      # Get the content, tidyr::unnest, and return result as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE) %>%
        purrr::map_if(is.data.frame, list) %>%
        dplyr::as_tibble() %>%
        dplyr::rename(game_id = .data$id) %>%
        tidyr::unnest(.data$teams) %>%
        purrr::map_if(is.data.frame, list) %>%
        dplyr::as_tibble() %>%
        tidyr::unnest(.data$categories) %>%
        purrr::map_if(is.data.frame, list) %>%
        dplyr::as_tibble() %>%
        dplyr::rename(category = .data$name) %>%
        tidyr::unnest(.data$types) %>%
        purrr::map_if(is.data.frame, list) %>%
        dplyr::as_tibble() %>%
        dplyr::rename(stat_category = .data$name) %>%
        tidyr::unnest(.data$athletes) %>%
        dplyr::rename(
          athlete_id = .data$id,
          team = .data$school,
          value = .data$stat
        ) %>%
        tidyr::pivot_wider(names_from = .data$stat_category, values_from = .data$value) %>%
        janitor::clean_names()

      df[cols[!(cols %in% colnames(df))]] <- NA

      df <- df %>%
        dplyr::select(cols, dplyr::everything()) %>%
        dplyr::mutate_at(numeric_cols, as.numeric) %>%
        as.data.frame()

      message(glue::glue("{Sys.time()}: Scraping game player stats data..."))
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no game player stats data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  # is_c_att_present <- any(grepl("C/ATT",colnames(df)))
  # if(is_c_att_present){
  #   df <- df %>%
  #    dplyr::mutate("C/ATT"="0/0")
  # }
  return(df)
}


#' Get Team records by year
#'
#' @rdname cfbd_games
#' @param year (\emph{Integer} optional): Year, 4 digit format (\emph{YYYY})
#' @param team (\emph{String} optional): Team - Select a valid team, D1 football
#' @param conference (\emph{String} optional): DI Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC\cr
#' @return \code{\link[cfbfastR:cfbd_game_records]{cfbfastR::cfbd_game_records()}} - A data frame with 20 variables:
#' \describe{
#'   \item{\code{year}}{integer.}
#'   \item{\code{team}}{character.}
#'   \item{\code{conference}}{character.}
#'   \item{\code{division}}{character.}
#'   \item{\code{total_games}}{integer.}
#'   \item{\code{total_wins}}{integer.}
#'   \item{\code{total_losses}}{integer.}
#'   \item{\code{total_ties}}{integer.}
#'   \item{\code{conference_games}}{integer.}
#'   \item{\code{conference_wins}}{integer.}
#'   \item{\code{conference_losses}}{integer.}
#'   \item{\code{conference_ties}}{integer.}
#'   \item{\code{home_games}}{integer.}
#'   \item{\code{home_wins}}{integer.}
#'   \item{\code{home_losses}}{integer.}
#'   \item{\code{home_ties}}{integer.}
#'   \item{\code{away_games}}{integer.}
#'   \item{\code{away_wins}}{integer.}
#'   \item{\code{away_losses}}{integer.}
#'   \item{\code{away_ties}}{integer.}
#' }
#' @source \url{https://api.collegefootballdata.com/records}
#' @keywords Team Info
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @import dplyr
#' @import tidyr
#' @export
#' @examples
#' \dontrun{
#' cfbd_game_records(2018, team = "Notre Dame")
#'
#' cfbd_game_records(2013, team = "Florida State")
#' }
#'
cfbd_game_records <- function(year, team = NULL, conference = NULL) {


  ## check if year is numeric
  assertthat::assert_that(is.numeric(year) & nchar(year) == 4,
    msg = "Enter valid year (Integer): 4 digits (YYYY)"
  )

  if (!is.null(team)) {
    if (team == "San Jose State") {
      team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team parameter for URL if not NULL
      team <- utils::URLencode(team, reserved = TRUE)
    }
  }
  if (!is.null(conference)) {
    # Check conference parameter in conference abbreviations, if not NULL
    # assertthat::assert_that(conference %in% cfbfastR::cfbd_conf_types_df$abbreviation,
    #                         msg = "Incorrect conference abbreviation, potential misspelling.\nConference abbreviations P5: ACC, B12, B1G, SEC, PAC\nConference abbreviations G5 and Independents: CUSA, MAC, MWC, Ind, SBC, AAC")
    # # Encode conference parameter for URL, if not NULL
    conference <- utils::URLencode(conference, reserved = TRUE)
  }

  base_url <- "https://api.collegefootballdata.com/records?"

  full_url <- paste0(
    base_url,
    "year=", year,
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
  tryCatch(
    expr = {
      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE) %>%
        dplyr::rename(
          total_games = .data$total.games,
          total_wins = .data$total.wins,
          total_losses = .data$total.losses,
          total_ties = .data$total.ties,
          conference_games = .data$conferenceGames.games,
          conference_wins = .data$conferenceGames.wins,
          conference_losses = .data$conferenceGames.losses,
          conference_ties = .data$conferenceGames.ties,
          home_games = .data$homeGames.games,
          home_wins = .data$homeGames.wins,
          home_losses = .data$homeGames.losses,
          home_ties = .data$homeGames.ties,
          away_games = .data$awayGames.games,
          away_wins = .data$awayGames.wins,
          away_losses = .data$awayGames.losses,
          away_ties = .data$awayGames.ties
        )
      message(glue::glue("{Sys.time()}: Scraping game records data..."))
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no game records data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}



#' Get Team Statistics by Game
#'
#' @rdname cfbd_games
#' @param year (\emph{Integer} required): Year, 4 digit format (\emph{YYYY})
#' @param week (\emph{Integer} optional): Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param season_type (\emph{String} default: regular): Select Season Type - regular, postseason, or both
#' @param team (\emph{String} optional): D-I Team
#' @param conference (\emph{String} optional): Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC\cr
#' @param game_id (\emph{Integer} optional): Game ID filter for querying a single game\cr
#' Can be found using the \code{\link[cfbfastR:cfbd_game_info]{cfbfastR::cfbd_game_info()}} function
#' @param rows_per_team (\emph{Integer} default 1): Both Teams for each game on one or two row(s), Options: 1 or 2
#'
#' @return \code{\link[cfbfastR:cfbd_game_team_stats]{cfbfastR::cfbd_game_team_stats()}} - A data frame with 78 variables:
#' \describe{
#'   \item{\code{game_id}}{integer.}
#'   \item{\code{school}}{character.}
#'   \item{\code{conference}}{character.}
#'   \item{\code{home_away}}{character.}
#'   \item{\code{points}}{integer.}
#'   \item{\code{total_yards}}{character.}
#'   \item{\code{net_passing_yards}}{character.}
#'   \item{\code{completion_attempts}}{character.}
#'   \item{\code{passing_tds}}{character.}
#'   \item{\code{yards_per_pass}}{character.}
#'   \item{\code{passes_intercepted}}{character.}
#'   \item{\code{interception_yards}}{character.}
#'   \item{\code{interception_tds}}{character.}
#'   \item{\code{rushing_attempts}}{character.}
#'   \item{\code{rushing_yards}}{character.}
#'   \item{\code{rush_tds}}{character.}
#'   \item{\code{yards_per_rush_attempt}}{character.}
#'   \item{\code{first_downs}}{character.}
#'   \item{\code{third_down_eff}}{character.}
#'   \item{\code{fourth_down_eff}}{character.}
#'   \item{\code{punt_returns}}{character.}
#'   \item{\code{punt_return_yards}}{character.}
#'   \item{\code{punt_return_tds}}{character.}
#'   \item{\code{kick_return_yards}}{character.}
#'   \item{\code{kick_return_tds}}{character.}
#'   \item{\code{kick_returns}}{character.}
#'   \item{\code{kicking_points}}{character.}
#'   \item{\code{fumbles_recovered}}{character.}
#'   \item{\code{fumbles_lost}}{character.}
#'   \item{\code{total_fumbles}}{character.}
#'   \item{\code{tackles}}{character.}
#'   \item{\code{tackles_for_loss}}{character.}
#'   \item{\code{sacks}}{character.}
#'   \item{\code{qb_hurries}}{character.}
#'   \item{\code{interceptions}}{character.}
#'   \item{\code{passes_deflected}}{character.}
#'   \item{\code{turnovers}}{character.}
#'   \item{\code{defensive_tds}}{character.}
#'   \item{\code{total_penalties_yards}}{character.}
#'   \item{\code{possession_time}}{character.}
#'   \item{\code{conference_allowed}}{character.}
#'   \item{\code{home_away_allowed}}{character.}
#'   \item{\code{points_allowed}}{integer.}
#'   \item{\code{total_yards_allowed}}{character.}
#'   \item{\code{net_passing_yards_allowed}}{character.}
#'   \item{\code{completion_attempts_allowed}}{character.}
#'   \item{\code{passing_tds_allowed}}{character.}
#'   \item{\code{yards_per_pass_allowed}}{character.}
#'   \item{\code{passes_intercepted_allowed}}{character.}
#'   \item{\code{interception_yards_allowed}}{character.}
#'   \item{\code{interception_tds_allowed}}{character.}
#'   \item{\code{rushing_attempts_allowed}}{character.}
#'   \item{\code{rushing_yards_allowed}}{character.}
#'   \item{\code{rush_tds_allowed}}{character.}
#'   \item{\code{yards_per_rush_attempt_allowed}}{character.}
#'   \item{\code{first_downs_allowed}}{character.}
#'   \item{\code{third_down_eff_allowed}}{character.}
#'   \item{\code{fourth_down_eff_allowed}}{character.}
#'   \item{\code{punt_returns_allowed}}{character.}
#'   \item{\code{punt_return_yards_allowed}}{character.}
#'   \item{\code{punt_return_tds_allowed}}{character.}
#'   \item{\code{kick_return_yards_allowed}}{character.}
#'   \item{\code{kick_return_tds_allowed}}{character.}
#'   \item{\code{kick_returns_allowed}}{character.}
#'   \item{\code{kicking_points_allowed}}{character.}
#'   \item{\code{fumbles_recovered_allowed}}{character.}
#'   \item{\code{fumbles_lost_allowed}}{character.}
#'   \item{\code{total_fumbles_allowed}}{character.}
#'   \item{\code{tackles_allowed}}{character.}
#'   \item{\code{tackles_for_loss_allowed}}{character.}
#'   \item{\code{sacks_allowed}}{character.}
#'   \item{\code{qb_hurries_allowed}}{character.}
#'   \item{\code{interceptions_allowed}}{character.}
#'   \item{\code{passes_deflected_allowed}}{character.}
#'   \item{\code{turnovers_allowed}}{character.}
#'   \item{\code{defensive_tds_allowed}}{character.}
#'   \item{\code{total_penalties_yards_allowed}}{character.}
#'   \item{\code{possession_time_allowed}}{character.}
#' }
#' @source \url{https://api.collegefootballdata.com/games/teams}
#' @keywords Team Game Stats
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode URLdecode
#' @importFrom assertthat assert_that
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @import dplyr
#' @import tidyr
#' @import purrr
#' @export
#' @examples
#' \dontrun{
#' cfbd_game_team_stats(2019, team = "LSU")
#'
#' cfbd_game_team_stats(2013, team = "Florida State")
#' }
#'
cfbd_game_team_stats <- function(year,
                                 week = NULL,
                                 season_type = "regular",
                                 team = NULL,
                                 conference = NULL,
                                 game_id = NULL,
                                 rows_per_team = 1) {

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
  if (!is.null(game_id)) {
    # Check if game_id is numeric, if not NULL
    assertthat::assert_that(is.numeric(game_id),
      msg = "Enter valid game_id value (Integer)\nCan be found using the `cfbd_game_info()` function"
    )
  }
  if (rows_per_team != 1) {
    # Check if rows_per_team is 2, if not 1
    assertthat::assert_that(rows_per_team == 2,
      msg = "Enter valid rows_per_team value (Integer): 1 or 2"
    )
  }

  base_url <- "https://api.collegefootballdata.com/games/teams?"

  full_url <- paste0(
    base_url,
    "year=", year,
    "&week=", week,
    "&seasonType=", season_type,
    "&team=", team,
    "&conference=", conference,
    "&gameId=", game_id
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
    "id", "school", "conference", "home_away",
    "points", "rushing_t_ds", "punt_return_yards", "punt_return_t_ds",
    "punt_returns", "passing_t_ds", "kicking_points",
    "interception_yards", "interception_t_ds", "passes_intercepted",
    "fumbles_recovered", "total_fumbles", "tackles_for_loss",
    "defensive_t_ds", "tackles", "sacks", "qb_hurries",
    "passes_deflected", "possession_time", "interceptions",
    "fumbles_lost", "turnovers", "total_penalties_yards",
    "yards_per_rush_attempt", "rushing_attempts", "rushing_yards",
    "yards_per_pass", "completion_attempts", "net_passing_yards",
    "total_yards", "fourth_down_eff", "third_down_eff",
    "first_downs", "kick_return_yards", "kick_return_t_ds",
    "kick_returns"
  )
  # Get the content, unnest, and return result as data.frame
  df <- res %>%
    httr::content(as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON(flatten = TRUE) %>%
    purrr::map_if(is.data.frame, list) %>%
    dplyr::as_tibble()

  if (nrow(df) == 0) {
    warning("Most likely a bye week, the data pulled from the API was empty. Returning nothing
            for this one week or team.")
    return(NULL)
  }
  df <- df %>%
    tidyr::unnest(.data$teams) %>%
    tidyr::unnest(.data$stats)

  # Pivot category columns to get stats for each team game on one row
  df <- tidyr::pivot_wider(df,
    names_from = .data$category,
    values_from = .data$stat
  )
  df <- df %>%
    janitor::clean_names()
  df[cols[!(cols %in% colnames(df))]] <- NA
  df <- df %>%
    dplyr::rename(
      game_id = .data$id,
      rush_tds = .data$rushing_t_ds,
      punt_return_tds = .data$punt_return_t_ds,
      passing_tds = .data$passing_t_ds,
      interception_tds = .data$interception_t_ds,
      defensive_tds = .data$defensive_t_ds,
      kick_return_tds = .data$kick_return_t_ds
    )

  if (rows_per_team == 1) {
    # Join pivoted data with itself to get ultra-wide row
    # containing all game stats on one row for both teams
    df <- df %>%
      dplyr::left_join(df,
        by = c("game_id", "school"),
        suffix = c("", "_allowed")
      )

    cols1 <- c(
      "game_id", "school", "conference", "home_away",
      "points", "total_yards", "net_passing_yards",
      "completion_attempts", "passing_tds", "yards_per_pass",
      "passes_intercepted", "interception_yards", "interception_tds",
      "rushing_attempts", "rushing_yards", "rush_tds", "yards_per_rush_attempt",
      "first_downs", "third_down_eff", "fourth_down_eff",
      "punt_returns", "punt_return_yards", "punt_return_tds",
      "kick_return_yards", "kick_return_tds", "kick_returns", "kicking_points",
      "fumbles_recovered", "fumbles_lost", "total_fumbles",
      "tackles", "tackles_for_loss", "sacks", "qb_hurries",
      "interceptions", "passes_deflected", "turnovers", "defensive_tds",
      "total_penalties_yards", "possession_time",
      "conference_allowed", "home_away_allowed",
      "points_allowed", "total_yards_allowed", "net_passing_yards_allowed",
      "completion_attempts_allowed", "passing_tds_allowed", "yards_per_pass_allowed",
      "passes_intercepted_allowed", "interception_yards_allowed", "interception_tds_allowed",
      "rushing_attempts_allowed", "rushing_yards_allowed", "rush_tds_allowed", "yards_per_rush_attempt_allowed",
      "first_downs_allowed", "third_down_eff_allowed", "fourth_down_eff_allowed",
      "punt_returns_allowed", "punt_return_yards_allowed", "punt_return_tds_allowed",
      "kick_return_yards_allowed", "kick_return_tds_allowed", "kick_returns_allowed", "kicking_points_allowed",
      "fumbles_recovered_allowed", "fumbles_lost_allowed", "total_fumbles_allowed",
      "tackles_allowed", "tackles_for_loss_allowed", "sacks_allowed", "qb_hurries_allowed",
      "interceptions_allowed", "passes_deflected_allowed", "turnovers_allowed", "defensive_tds_allowed",
      "total_penalties_yards_allowed", "possession_time_allowed"
    )

    if (!is.null(team)) {
      team <- URLdecode(team)

      df <- df %>%
        dplyr::filter(.data$school == team) %>%
        dplyr::select(cols1)

      return(df)
    } else if (!is.null(conference)) {
      confs <- cfbd_conferences()

      conference <- URLdecode(conference)

      conf_name <- confs[confs$abbreviation == conference, ]$name

      df <- df %>%
        dplyr::filter(conference == conf_name) %>%
        dplyr::select(cols1)

      return(df)
    } else {
      df <- df %>%
        dplyr::select(cols1)
      return(df)
    }
  } else {
    cols2 <- c(
      "game_id", "school", "conference", "home_away",
      "points", "total_yards", "net_passing_yards",
      "completion_attempts", "passing_tds", "yards_per_pass",
      "passes_intercepted", "interception_yards", "interception_tds",
      "rushing_attempts", "rushing_yards", "rush_tds", "yards_per_rush_attempt",
      "first_downs", "third_down_eff", "fourth_down_eff",
      "punt_returns", "punt_return_yards", "punt_return_tds",
      "kick_return_yards", "kick_return_tds", "kick_returns", "kicking_points",
      "fumbles_recovered", "fumbles_lost", "total_fumbles",
      "tackles", "tackles_for_loss", "sacks", "qb_hurries",
      "interceptions", "passes_deflected", "turnovers", "defensive_tds",
      "total_penalties_yards", "possession_time"
    )
    if (!is.null(team)) {
      team <- URLdecode(team <- team)

      df <- df %>%
        dplyr::filter(.data$school == team) %>%
        dplyr::select(cols2)
      return(df)
    } else if (!is.null(conference)) {
      confs <- cfbd_conferences()

      conference <- URLdecode(conference)

      conf_name <- confs[confs$abbreviation == conference, ]$name

      df <- df %>%
        dplyr::filter(conference == conf_name) %>%
        dplyr::select(cols2)

      return(df)
    } else {
      df <- df %>%
        dplyr::select(cols2)
      return(df)
    }
  }
}
