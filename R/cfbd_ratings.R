#' 
#' @name cfbd_ratings
#' @aliases cfbd_rankings cfbd_ratings_sp cfbd_ratings_sp_conference cfbd_ratings_srs
#' @title CFBD Ratings and Rankings Endpoints
#' @description
#' \describe{
#' \item{`cfbd_rankings()`: Gets Historical CFB poll rankings at a specific week}{.}
#' \item{`cfbd_ratings_sp()`: Get SP historical rating data}{.}
#' \item{`cfbd_ratings_sp_conference()`: Get SP conference-level historical rating data}{.}
#' \item{`cfbd_ratings_srs()`: Get SRS historical rating data}{.}
#' }
#' @param year (\emph{Integer} required): Year, 4 digit format (\emph{YYYY})
#' @param week (\emph{Integer} optional): Week, values from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
#' @param season_type (\emph{String} default regular): Season type - regular or postseason
#' @param verbose Logical parameter (TRUE/FALSE, default: FALSE) to return warnings and messages from function
#'
#' @return [cfbd_rankings()] - A data frame with 9 variables:
#' \describe{
#'   \item{`season`: integer.}{Rankings season.}
#'   \item{`season_type`: character.}{Season type of rankings.}
#'   \item{`week`: integer.}{Week of rankings.}
#'   \item{`poll`: character.}{Name of the poll.}
#'   \item{`rank`: integer.}{Rank in the poll.}
#'   \item{`school`: character.}{Team name.}
#'   \item{`conference`: character.}{Conference of the team.}
#'   \item{`first_place_votes`: integer.}{Number of first place votes.}
#'   \item{`points`: integer.}{Total poll points.}
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
        message(glue::glue("{Sys.time()}: Invalid arguments or no rankings data available!"))
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
#' @return [cfbd_ratings_sp()] - A data frame with 26 variables:
#' \describe{
#'   \item{`year`: integer.}{Season of the ratings.}
#'   \item{`team`: character.}{Team name.}
#'   \item{`conference`: character.}{Conference of the team.}
#'   \item{`rating`: double.}{SP+ rating.}
#'   \item{`ranking`: integer.}{Ranking in the SP+ ratings.}
#'   \item{`second_order_wins`: logical.}{Total second-order wins - Not available for recent seasons.}
#'   \item{`sos`: logical.}{Strength of schedule - Not available for recent seasons.}
#'   \item{`offense_ranking`: integer.}{Overall offense ranking.}
#'   \item{`offense_rating`: double.}{Overall offense rating.}
#'   \item{`offense_success`: logical.}{Offense success rating - Not available for recent seasons.}
#'   \item{`offense_explosiveness`: logical.}{Offense explosiveness rating - Not available for recent seasons.}
#'   \item{`offense_rushing`: logical.}{Offense rushing rating - Not available for recent seasons.}
#'   \item{`offense_passing`: logical.}{Offense passing rating - Not available for recent seasons.}
#'   \item{`offense_standard_downs`: logical.}{Offense standard downs rating - Not available for recent seasons.}
#'   \item{`offense_passing_downs`: logical.}{Offensive passing downs rating - Not available for recent seasons.}
#'   \item{`offense_run_rate`: logical.}{Offense rushing rate - Not available for recent seasons.}
#'   \item{`offense_pace`: logical.}{Offense pace factor - Not available for recent seasons.}
#'   \item{`defense_ranking`: integer.}{Overall defense ranking.}
#'   \item{`defense_rating`: double.}{Overall defense rating.}
#'   \item{`defense_success`: logical.}{Defense success rating - Not available for recent seasons.}
#'   \item{`defense_explosiveness`: logical.}{Defense explosiveness rating - Not available for recent seasons.}
#'   \item{`defense_rushing`: logical.}{Defense rushing rating - Not available for recent seasons.}
#'   \item{`defense_passing`: logical.}{Defense passing rating - Not available for recent seasons.}
#'   \item{`defense_standard_downs`: logical.}{Defense standard downs rating - Not available for recent seasons.}
#'   \item{`defense_passing_downs`: logical.}{Defensive passing downs rating - Not available for recent seasons.}
#'   \item{`defense_havoc_total`: logical.}{Total defensive havoc rate - Not available for recent seasons.}
#'   \item{`defense_havoc_front_seven`: logical.}{Defense havoc rate from front 7 players - Not available for recent seasons.}
#'   \item{`defense_havoc_db`: logical.}{Defense havoc rate from defensive backs - Not available for recent seasons.}
#'   \item{`special_teams_rating`: double.}{Special teams rating.}
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
#' cfbd_ratings_sp(year = 2018)
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
        message(glue::glue("{Sys.time()}: Invalid arguments or no S&P+ ratings data available!"))
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
#' @return [cfbd_ratings_sp_conference()] - A data frame with 25 variables:
#' \describe{
#'   \item{`year`: integer.}{Season of the conference rating.}
#'   \item{`conference`: character.}{Conference name.}
#'   \item{`rating`: double.}{Conference SP+ rating.}
#'   \item{`second_order_wins`: logical.}{Second-order wins for the conference - Not available for recent seasons.}
#'   \item{`sos`: logical.}{Strength of schedule for the conference  - Not available for recent seasons..}
#'   \item{`offense_rating`: double.}{Overall offense rating for the conference.}
#'   \item{`offense_success`: logical.}{Offense success rating for the conference - Not available for recent seasons.}
#'   \item{`offense_explosiveness`: logical.}{Offense explosiveness rating for the conference - Not available for recent seasons.}
#'   \item{`offense_rushing`: logical.}{Offense rushing rating for the conference - Not available for recent seasons.}
#'   \item{`offense_passing`: logical.}{Offense passing rating for the conference - Not available for recent seasons.}
#'   \item{`offense_standard_downs`: logical.}{Offense standard downs rating for the conference - Not available for recent seasons.}
#'   \item{`offense_passing_downs`: logical.}{Offensive passing downs rating for the conference - Not available for recent seasons.}
#'   \item{`offense_run_rate`: logical.}{Offense rushing rate for the conference - Not available for recent seasons.}
#'   \item{`offense_pace`: logical.}{Offense pace factor for the conference - Not available for recent seasons.}
#'   \item{`defense_ranking`: integer.}{Overall defense ranking for the conference.}
#'   \item{`defense_rating`: double.}{Overall defense rating for the conference.}
#'   \item{`defense_success`: logical.}{Defense success rating for the conference - Not available for recent seasons.}
#'   \item{`defense_explosiveness`: logical.}{Defense explosiveness rating for the conference - Not available for recent seasons.}
#'   \item{`defense_rushing`: logical.}{Defense rushing rating for the conference - Not available for recent seasons.}
#'   \item{`defense_passing`: logical.}{Defense passing rating for the conference - Not available for recent seasons.}
#'   \item{`defense_standard_downs`: logical.}{Defense standard downs rating for the conference - Not available for recent seasons.}
#'   \item{`defense_passing_downs`: logical.}{Defensive passing downs rating for the conference - Not available for recent seasons.}
#'   \item{`defense_havoc_total`: logical.}{Total defensive havoc rate for the conference - Not available for recent seasons.}
#'   \item{`defense_havoc_front_seven`: logical.}{Defense havoc rate from front 7 players for the conference - Not available for recent seasons.}
#'   \item{`defense_havoc_db`: logical.}{Defense havoc rate from defensive backs for the conference - Not available for recent seasons.}
#'   \item{`special_teams_rating`: double.}{Special teams rating for the conference.}
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
        message(glue::glue("{Sys.time()}: Invalid arguments or no conference-level S&P+ ratings data available!"))
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
#' @return [cfbd_ratings_srs()] - A data frame with 6 variables:
#' \describe{
#'   \item{`year`: integer.}{Season of the SRS rating.}
#'   \item{`team`: character.}{Team name.}
#'   \item{`conference`: character.}{Conference of the team.}
#'   \item{`division`: logical.}{Division in the conference for the team.}
#'   \item{`rating`: double.}{Simple Rating System (SRS) rating.}
#'   \item{`ranking`: integer.}{Simple Rating System ranking within the group returned.}
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
        message(glue::glue("{Sys.time()}: Invalid arguments or no simple rating system (SRS) data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
  )
  return(df)
}
