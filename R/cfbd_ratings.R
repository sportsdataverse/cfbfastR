#' CFBD Ratings and Rankings Endpoints
#' @name cfbd_ratings
NULL
#' Gets Historical CFB poll rankings at a specific week
#'
#' Postseason polls are after Week 13
#' @rdname cfbd_ratings
#'
#' @param year (\emph{Integer} required): Year, 4 digit format (\emph{YYYY})
#' @param week (\emph{Integer} optional): Week, values from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
#' @param season_type (\emph{String} default regular): Season type - regular or postseason
#' @param verbose Logical parameter (TRUE/FALSE, default: FALSE) to return warnings and messages from function
#'
#' @return \code{\link[cfbfastR:cfbd_rankings]{cfbfastR::cfbd_rankings()}} - A data frame with 9 variables:
#' \describe{
#'   \item{\code{season}}{integer.}
#'   \item{\code{season_type}}{character.}
#'   \item{\code{week}}{integer.}
#'   \item{\code{poll}}{character.}
#'   \item{\code{rank}}{integer.}
#'   \item{\code{school}}{character.}
#'   \item{\code{conference}}{character.}
#'   \item{\code{first_place_votes}}{integer.}
#'   \item{\code{points}}{integer.}
#' }
#' @source \url{https://api.collegefootballdata.com/rankings}
#' @keywords CFB Rankings
#' @importFrom assertthat assert_that
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom dplyr arrange as_tibble group_by ungroup rename
#' @importFrom tidyr unnest
#' @importFrom purrr map_if
#' @importFrom glue glue
#' @export
#' @examples
#' \donttest{
#' cfbd_rankings(year = 2019, week = 12)
#'
#' cfbd_rankings(year = 2018, week = 14)
#'
#' cfbd_rankings(year = 2013, season_type = "postseason")
#' }
#'
cfbd_rankings <- function(year, week = NULL, season_type = "regular",
                          verbose = FALSE) {
  if (!is.null(year)) {
    ## check if year is numeric
    assertthat::assert_that(is.numeric(year) & nchar(year) == 4,
      msg = "Enter valid year (Integer) in 4 digit format (YYYY)"
    )
  }
  if (!is.null(week)) {
    # Check if week is numeric, if not NULL
    assertthat::assert_that(is.numeric(week) & nchar(week) <= 2,
      msg = "Enter valid week 1-15, 1-14 for seasons pre-playoff, \n(i.e. 2014 or earlier)"
    )
  }
  if (season_type != "regular") {
    assertthat::assert_that(season_type == "postseason",
      msg = "Enter a valid season_type (String): regular or postseason"
    )
  }

  base_url <- "https://api.collegefootballdata.com/rankings?"

  full_url <- paste0(
    base_url,
    "year=", year,
    "&week=", week,
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

  polls <- data.frame()
  tryCatch(
    expr = {
      polls <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE) %>%
        furrr::future_map_if(is.data.frame, list) %>%
        dplyr::as_tibble() %>%
        tidyr::unnest(.data$polls) %>%
        tidyr::unnest(.data$ranks) %>%
        dplyr::group_by(.data$week, .data$poll) %>%
        dplyr::arrange(.data$rank, .by_group = TRUE) %>%
        dplyr::ungroup() %>%
        dplyr::rename(
          season_type = .data$seasonType,
          first_place_votes = .data$firstPlaceVotes
        ) %>%
        as.data.frame()

      if(verbose){ 
        message(glue::glue("{Sys.time()}: Scraping rankings data..."))
      }
    },
    error = function(e) {
      if(verbose){ 
        message(glue::glue("{Sys.time()}: Invalid arguments or no rankings data available!"))
      }
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(polls)
}

#' Get SP historical rating data
#'
#' At least one of \strong{year} or \strong{team} must be specified for the function to run
#' @rdname cfbd_ratings
#'
#' @param year (\emph{Integer} optional): Year, 4 digit format (\emph{YYYY})
#' @param team (\emph{String} optional): D-I Team
#' @param verbose Logical parameter (TRUE/FALSE, default: FALSE) to return warnings and messages from function
#'
#' @return \code{\link[cfbfastR:cfbd_ratings_sp]{cfbfastR::cfbd_ratings_sp()}} - A data frame with 26 variables:
#' \describe{
#'   \item{\code{year}}{integer.}
#'   \item{\code{team}}{character.}
#'   \item{\code{conference}}{character.}
#'   \item{\code{rating}}{double.}
#'   \item{\code{ranking}}{integer.}
#'   \item{\code{second_order_wins}}{logical.}
#'   \item{\code{sos}}{logical.}
#'   \item{\code{offense_ranking}}{integer.}
#'   \item{\code{offense_rating}}{double.}
#'   \item{\code{offense_success}}{logical.}
#'   \item{\code{offense_explosiveness}}{logical.}
#'   \item{\code{offense_rushing}}{logical.}
#'   \item{\code{offense_passing}}{logical.}
#'   \item{\code{offense_standard_downs}}{logical.}
#'   \item{\code{offense_passing_downs}}{logical.}
#'   \item{\code{offense_run_rate}}{logical.}
#'   \item{\code{offense_pace}}{logical.}
#'   \item{\code{defense_ranking}}{integer.}
#'   \item{\code{defense_rating}}{double.}
#'   \item{\code{defense_success}}{logical.}
#'   \item{\code{defense_explosiveness}}{logical.}
#'   \item{\code{defense_rushing}}{logical.}
#'   \item{\code{defense_passing}}{logical.}
#'   \item{\code{defense_standard_downs}}{logical.}
#'   \item{\code{defense_passing_downs}}{logical.}
#'   \item{\code{defense_havoc_total}}{logical.}
#'   \item{\code{defense_havoc_front_seven}}{logical.}
#'   \item{\code{defense_havoc_db}}{logical.}
#'   \item{\code{special_teams_rating}}{double.}
#' }
#' @source \url{https://api.collegefootballdata.com/ratings/sp}
#' @keywords SP+
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#' @importFrom dplyr rename
#' @export
#' @examples
#' \donttest{
#' cfbd_ratings_sp(year = 2019)
#'
#' cfbd_ratings_sp(team = "Texas A&M")
#'
#' cfbd_ratings_sp(year = 2019, team = "Texas")
#' }
#'
cfbd_ratings_sp <- function(year = NULL, team = NULL,
                            verbose = FALSE) {
  
  if (!is.null(year)) {
    # check if year is numeric and correct length
    assertthat::assert_that(is.numeric(year) & nchar(year) == 4,
      msg = "Enter valid year as a number in 4 digit format (YYYY)"
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

  base_url <- "https://api.collegefootballdata.com/ratings/sp"
  full_url <- paste0(
    base_url,
    "?year=", year,
    "&team=", team
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
        dplyr::rename(
          second_order_wins = .data$secondOrderWins,
          offense_ranking = .data$offense.ranking,
          offense_rating = .data$offense.rating,
          offense_success = .data$offense.success,
          offense_explosiveness = .data$offense.explosiveness,
          offense_rushing = .data$offense.rushing,
          offense_passing = .data$offense.passing,
          offense_standard_downs = .data$offense.standardDowns,
          offense_passing_downs = .data$offense.passingDowns,
          offense_run_rate = .data$offense.runRate,
          offense_pace = .data$offense.pace,
          defense_ranking = .data$defense.ranking,
          defense_rating = .data$defense.rating,
          defense_success = .data$defense.success,
          defense_explosiveness = .data$defense.explosiveness,
          defense_rushing = .data$defense.rushing,
          defense_passing = .data$defense.passing,
          defense_standard_downs = .data$defense.standardDowns,
          defense_passing_downs = .data$defense.passingDowns,
          defense_havoc_total = .data$defense.havoc.total,
          defense_havoc_front_seven = .data$defense.havoc.frontSeven,
          defense_havoc_db = .data$defense.havoc.db,
          special_teams_rating = .data$specialTeams.rating
        ) %>%
        as.data.frame()

      if(verbose){ 
        message(glue::glue("{Sys.time()}: Scraping S&P+ ratings data..."))
      }
    },
    error = function(e) {
      if(verbose){ 
        message(glue::glue("{Sys.time()}: Invalid arguments or no S&P+ ratings data available!"))
      }
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}

#' Get conference level SP historical rating data
#' @rdname cfbd_ratings
#' @param year (\emph{Integer} optional): Year, 4 digit format (\emph{YYYY})
#' @param conference (\emph{String} optional): Conference abbreviation - S&P+ information by conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param verbose Logical parameter (TRUE/FALSE, default: FALSE) to return warnings and messages from function
#'
#' @return \code{\link[cfbfastR:cfbd_ratings_sp_conference]{cfbfastR::cfbd_ratings_sp_conference()}} - A data frame with 25 variables:
#' \describe{
#'   \item{\code{year}}{integer.}
#'   \item{\code{conference}}{character.}
#'   \item{\code{rating}}{double.}
#'   \item{\code{second_order_wins}}{logical.}
#'   \item{\code{sos}}{logical.}
#'   \item{\code{offense_rating}}{double.}
#'   \item{\code{offense_success}}{logical.}
#'   \item{\code{offense_explosiveness}}{logical.}
#'   \item{\code{offense_rushing}}{logical.}
#'   \item{\code{offense_passing}}{logical.}
#'   \item{\code{offense_standard_downs}}{logical.}
#'   \item{\code{offense_passing_downs}}{logical.}
#'   \item{\code{offense_run_rate}}{logical.}
#'   \item{\code{offense_pace}}{logical.}
#'   \item{\code{defense_rating}}{double.}
#'   \item{\code{defense_success}}{logical.}
#'   \item{\code{defense_explosiveness}}{logical.}
#'   \item{\code{defense_rushing}}{logical.}
#'   \item{\code{defense_passing}}{logical.}
#'   \item{\code{defense_standard_downs}}{logical.}
#'   \item{\code{defense_passing_downs}}{logical.}
#'   \item{\code{defense_havoc_total}}{logical.}
#'   \item{\code{defense_havoc_front_seven}}{logical.}
#'   \item{\code{defense_havoc_db}}{logical.}
#'   \item{\code{special_teams_rating}}{double.}
#' }
#' @source \url{https://api.collegefootballdata.com/ratings/sp/conferences}
#' @keywords SP+
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom utils URLencode
#' @importFrom assertthat assert_that
#' @importFrom glue glue
#' @importFrom dplyr rename
#' @export
#' @examples
#' \donttest{
#' cfbd_ratings_sp_conference(year = 2019)
#'
#' cfbd_ratings_sp_conference(year = 2012, conference = "SEC")
#'
#' cfbd_ratings_sp_conference(year = 2016, conference = "ACC")
#' }
#'
cfbd_ratings_sp_conference <- function(year = NULL, conference = NULL,
                                       verbose = FALSE) {

  if (!is.null(year)) {
    # check if year is numeric and correct length
    assertthat::assert_that(is.numeric(year) & nchar(year) == 4,
      msg = "Enter valid year as a number in 4 digit format (YYYY)"
    )
  }
  if (!is.null(conference)) {
    # # Check conference parameter in conference abbreviations, if not NULL
    # assertthat::assert_that(conference %in% cfbfastR::cfbd_conf_types_df$abbreviation,
    #             msg = "Incorrect conference abbreviation, potential misspelling.\nConference abbreviations P5: ACC, B12, B1G, SEC, PAC\nConference abbreviations G5 and Independents: CUSA, MAC, MWC, Ind, SBC, AAC")
    # Encode conference parameter for URL, if not NULL
    conference <- utils::URLencode(conference, reserved = TRUE)
  }
  base_url <- "https://api.collegefootballdata.com/ratings/sp/conferences?"

  full_url <- paste0(
    base_url,
    "year=", year,
    "&conference=", conference
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
        as.data.frame() %>%
        dplyr::rename(
          second_order_wins = .data$secondOrderWins,
          offense_rating = .data$offense.rating,
          offense_success = .data$offense.success,
          offense_explosiveness = .data$offense.explosiveness,
          offense_rushing = .data$offense.rushing,
          offense_passing = .data$offense.passing,
          offense_standard_downs = .data$offense.standardDowns,
          offense_passing_downs = .data$offense.passingDowns,
          offense_run_rate = .data$offense.runRate,
          offense_pace = .data$offense.pace,
          defense_rating = .data$defense.rating,
          defense_success = .data$defense.success,
          defense_explosiveness = .data$defense.explosiveness,
          defense_rushing = .data$defense.rushing,
          defense_passing = .data$defense.passing,
          defense_standard_downs = .data$defense.standardDowns,
          defense_passing_downs = .data$defense.passingDowns,
          defense_havoc_total = .data$defense.havoc.total,
          defense_havoc_front_seven = .data$defense.havoc.frontSeven,
          defense_havoc_db = .data$defense.havoc.db,
          special_teams_rating = .data$specialTeams.rating
        ) %>%
        as.data.frame()

      if(verbose){ 
        message(glue::glue("{Sys.time()}: Scraping conference-level S&P+ ratings data..."))
      }
    },
    error = function(e) {
      if(verbose){ 
        message(glue::glue("{Sys.time()}: Invalid arguments or no conference-level S&P+ ratings data available!"))
      }
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}


#' Get SRS historical rating data
#'
#' At least one of \strong{year} or \strong{team} must be specified for the function to run
#' @rdname cfbd_ratings
#'
#' @param year (\emph{Integer} optional): Year, 4 digit format (\emph{YYYY})
#' @param team (\emph{String} optional): D-I Team
#' @param conference (\emph{String} optional): Conference abbreviation - SRS information by conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#' @param verbose Logical parameter (TRUE/FALSE, default: FALSE) to return warnings and messages from function
#'
#' @return \code{\link[cfbfastR:cfbd_ratings_srs]{cfbfastR::cfbd_ratings_srs()}} - A data frame with 6 variables:
#' \describe{
#'   \item{\code{year}}{integer.}
#'   \item{\code{team}}{character.}
#'   \item{\code{conference}}{character.}
#'   \item{\code{division}}{logical.}
#'   \item{\code{rating}}{double.}
#'   \item{\code{ranking}}{integer.}
#' }
#' @source \url{https://api.collegefootballdata.com/ratings/srs}
#' @keywords SRS
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom assertthat assert_that
#' @importFrom utils URLencode
#' @importFrom glue glue
#' @export
#' @examples
#' \donttest{
#' cfbd_ratings_srs(year = 2019, team = "Texas")
#'
#' cfbd_ratings_srs(year = 2018, conference = "SEC")
#' }
#'
cfbd_ratings_srs <- function(year = NULL, team = NULL, conference = NULL,
                             verbose = FALSE) {

  if (!is.null(year)) {
    # check if year is numeric
    assertthat::assert_that(is.numeric(year) & nchar(year) == 4,
      msg = "Enter valid year as a number (YYYY)"
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
    #                         msg = "Incorrect conference abbreviation, potential misspelling.\nConference abbreviations P5: ACC, B12, B1G, SEC, PAC\nConference abbreviations G5 and Independents: CUSA, MAC, MWC, Ind, SBC, AAC")
    # Encode conference parameter for URL, if not NULL
    conference <- utils::URLencode(conference, reserved = TRUE)
  }

  base_url <- "https://api.collegefootballdata.com/ratings/srs?"

  full_url <- paste0(
    base_url,
    "year=", year,
    "&team=", team,
    "&conference=", conference
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
        jsonlite::fromJSON() %>%
        as.data.frame() %>%
        mutate(
          rating = as.numeric(.data$rating),
          ranking = as.integer(.data$ranking)
        )

      if(verbose){ 
        message(glue::glue("{Sys.time()}: Scraping simple rating system (SRS) data..."))
      }
    },
    error = function(e) {
      if(verbose){ 
        message(glue::glue("{Sys.time()}: Invalid arguments or no simple rating system (SRS) data available!"))
      }
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}
