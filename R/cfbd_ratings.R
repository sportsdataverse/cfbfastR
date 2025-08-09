#' @name cfbd_ratings
#' @title
#' **CFBD Ratings and Rankings Endpoints Overview**
#' @description
#' \describe{
#' \item{`cfbd_rankings()`:}{ Gets Historical CFB poll rankings at a specific week.}
#' \item{`cfbd_ratings_sp()`:}{ Get SP historical rating data.}
#' \item{`cfbd_ratings_sp_conference()`:}{ Get SP conference-level historical rating data.}
#' \item{`cfbd_ratings_srs()`:}{ Get SRS historical rating data.}
#' }
#'
#' ### **Get historical Coaches and AP poll data**
#' ```r
#' cfbd_rankings(year = 2019, week = 12)
#'
#' cfbd_rankings(year = 2018, week = 14)
#'
#' cfbd_rankings(year = 2013, season_type = "postseason")
#' ```
#' ### **Get SP historical rating data**
#'
#' At least one of **year** or **team** must be specified for the function to run
#' ```r
#' cfbd_ratings_sp(year = 2018)
#'
#' cfbd_ratings_sp(team = "Texas A&M")
#'
#' cfbd_ratings_sp(year = 2019, team = "Texas")
#' ```
#' ### **Get conference level SP historical rating data**
#' ```r
#' cfbd_ratings_sp_conference(year = 2019)
#'
#' cfbd_ratings_sp_conference(year = 2012, conference = "SEC")
#'
#' cfbd_ratings_sp_conference(year = 2016, conference = "ACC")
#' ```
#' ### **Get SRS historical rating data**
#'
#' At least one of **year** or **team** must be specified for the function to run
#' ```r
#' cfbd_ratings_srs(year = 2019, team = "Texas")
#'
#' cfbd_ratings_srs(year = 2018, conference = "SEC")
#' ````
#'
#' ### **Get Elo historical rating data**
#' Acquire the CFBD calculated elo ratings data by **team**, **year**, **week**, and **conference**
#' ```r
#' cfbd_ratings_elo(year = 2019, team = "Texas")
#'
#' cfbd_ratings_elo(year = 2018, conference = "SEC")
#' ```
NULL
#' @title
#' **Get historical Coaches and AP poll data**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*)
#' @param week (*Integer* optional): Week, values from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
#' @param season_type (*String* default regular): Season type - regular or postseason
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
#' @keywords CFB Rankings
#' @importFrom cli cli_abort
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom dplyr arrange as_tibble group_by ungroup rename
#' @importFrom tidyr unnest
#' @importFrom purrr map_if
#' @importFrom glue glue
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_rankings(year = 2019, week = 12))
#'
#'   try(cfbd_rankings(year = 2018, week = 14))
#'
#'   try(cfbd_rankings(year = 2013, season_type = "postseason"))
#' }
#'
cfbd_rankings <- function(year, week = NULL, season_type = "regular") {

  # Validation ----
  validate_api_key()
  validate_year(year)
  validate_week(week)
  validate_season_type(season_type, allow_both = F)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/rankings?"
  query_params <- list(
    "year" = year,
    "week" = week,
    "seasonType" = season_type
  )
  full_url <- httr::modify_url(base_url, query=query_params)

  polls <- data.frame()
  tryCatch(
    expr = {
      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      polls <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE) %>%
        purrr::map_if(is.data.frame, list) %>%
        dplyr::as_tibble() %>%
        tidyr::unnest("polls") %>%
        tidyr::unnest("ranks") %>%
        dplyr::group_by(.data$week, .data$poll) %>%
        dplyr::arrange(.data$rank, .by_group = TRUE) %>%
        dplyr::ungroup() %>%
        dplyr::rename(
          "season_type" = "seasonType",
          "first_place_votes" = "firstPlaceVotes"
        )


      polls <- polls %>%
        make_cfbfastR_data("Rankings data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no rankings data available!"))
    },
    finally = {
    }
  )
  return(polls)
}

#' @title
#' **Get SP historical rating data**
#' @description
#' At least one of **year** or **team** must be specified for the function to run
#'
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*). Required if year not provided
#' @param team (*String* optional): D-I Team. Required if year not provided
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
#' @keywords SP+
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @importFrom dplyr rename
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_ratings_sp(year = 2018))
#'
#'   try(cfbd_ratings_sp(team = "Texas A&M"))
#'
#'   try(cfbd_ratings_sp(year = 2019, team = "Texas"))
#' }
#'
cfbd_ratings_sp <- function(year = NULL, team = NULL) {

  # Validation ----
  validate_reqs(year, team)
  validate_year(year)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/ratings/sp?"
  query_params <- list(
    "year" = year,
    "team" = team
  )
  full_url <- httr::modify_url(base_url, query=query_params)

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE) %>%
        dplyr::rename(
          "second_order_wins" = "secondOrderWins",
          "offense_ranking" = "offense.ranking",
          "offense_rating" = "offense.rating",
          "offense_success" = "offense.success",
          "offense_explosiveness" = "offense.explosiveness",
          "offense_rushing" = "offense.rushing",
          "offense_passing" = "offense.passing",
          "offense_standard_downs" = "offense.standardDowns",
          "offense_passing_downs" = "offense.passingDowns",
          "offense_run_rate" = "offense.runRate",
          "offense_pace" = "offense.pace",
          "defense_ranking" = "defense.ranking",
          "defense_rating" = "defense.rating",
          "defense_success" = "defense.success",
          "defense_explosiveness" = "defense.explosiveness",
          "defense_rushing" = "defense.rushing",
          "defense_passing" = "defense.passing",
          "defense_standard_downs" = "defense.standardDowns",
          "defense_passing_downs" = "defense.passingDowns",
          "defense_havoc_total" = "defense.havoc.total",
          "defense_havoc_front_seven" = "defense.havoc.frontSeven",
          "defense_havoc_db" = "defense.havoc.db",
          "special_teams_rating" = "specialTeams.rating"
        )


      df <- df %>%
        make_cfbfastR_data("SP+ data from CollegeFootballData.com",Sys.time())
    },
    error = function(e){
      message(glue::glue("{Sys.time()}: Invalid arguments or no S&P+ ratings data available!"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get conference level SP historical rating data**
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*)
#' @param conference (*String* optional): Conference abbreviation - S&P+ information by conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
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
#' @keywords SP+
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @importFrom dplyr rename
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_ratings_sp_conference(year = 2019))
#'
#'   try(cfbd_ratings_sp_conference(year = 2012, conference = "SEC"))
#'
#'   try(cfbd_ratings_sp_conference(year = 2016, conference = "ACC"))
#' }
#'
cfbd_ratings_sp_conference <- function(year = NULL, conference = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(year)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/ratings/sp/conferences?"
  query_params <- list(
    "year" = year,
    "conference" = conference
  )
  full_url <- httr::modify_url(base_url, query=query_params)

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE) %>%
        as.data.frame() %>%
        dplyr::rename(
          "second_order_wins" = "secondOrderWins",
          "offense_rating" = "offense.rating",
          "offense_success" = "offense.success",
          "offense_explosiveness" = "offense.explosiveness",
          "offense_rushing" = "offense.rushing",
          "offense_passing" = "offense.passing",
          "offense_standard_downs" = "offense.standardDowns",
          "offense_passing_downs" = "offense.passingDowns",
          "offense_run_rate" = "offense.runRate",
          "offense_pace" = "offense.pace",
          "defense_rating" = "defense.rating",
          "defense_success" = "defense.success",
          "defense_explosiveness" = "defense.explosiveness",
          "defense_rushing" = "defense.rushing",
          "defense_passing" = "defense.passing",
          "defense_standard_downs" = "defense.standardDowns",
          "defense_passing_downs" = "defense.passingDowns",
          "defense_havoc_total" = "defense.havoc.total",
          "defense_havoc_front_seven" = "defense.havoc.frontSeven",
          "defense_havoc_db" = "defense.havoc.db",
          "special_teams_rating" = "specialTeams.rating"
        )


      df <- df %>%
        make_cfbfastR_data("Conference SP+ data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no conference-level S&P+ ratings data available!"))
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **Get SRS historical rating data**
#' @description
#' At least one of **year** or **team** must be specified for the function to run
#'
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*). Required if team not provided
#' @param team (*String* optional): D-I Team. Required if year not provided
#' @param conference (*String* optional): Conference abbreviation - SRS information by conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
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
#' @keywords SRS
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_ratings_srs(year = 2019, team = "Texas"))
#'
#'   try(cfbd_ratings_srs(year = 2018, conference = "SEC"))
#' }
#'
cfbd_ratings_srs <- function(year = NULL, team = NULL, conference = NULL) {

  # Validation ----
  validate_api_key()
  validate_reqs(year, team)
  validate_year(year)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/ratings/srs?"
  query_params <- list(
    "year" = year,
    "team" = team,
    "conference" = conference
  )
  full_url <- httr::modify_url(base_url, query=query_params)

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON() %>%
        as.data.frame() %>%
        dplyr::mutate(
          rating = as.numeric(.data$rating),
          ranking = as.integer(.data$ranking)
        )


      df <- df %>%
        make_cfbfastR_data("SRS data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no simple rating system (SRS) data available!"))
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **Get Elo historical rating data**
#' @description
#' Acquire the CFBD calculated elo ratings data by team, year, week, and conference
#'
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*)
#' @param week (*Integer* optional): Maximum Week of ratings.
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - SRS information by conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#'
#' @return [cfbd_ratings_elo()] - A data frame with 6 variables:
#' \describe{
#'   \item{`year`: integer.}{Season of the SRS rating.}
#'   \item{`team`: character.}{Team name.}
#'   \item{`conference`: character.}{Conference of the team.}
#'   \item{`division`: logical.}{Division in the conference for the team.}
#'   \item{`rating`: double.}{Simple Rating System (SRS) rating.}
#'   \item{`ranking`: integer.}{Simple Rating System ranking within the group returned.}
#' }
#' @keywords elo
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET RETRY
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_ratings_elo(year = 2019, team = "Texas"))
#'
#'   try(cfbd_ratings_elo(year = 2018, conference = "SEC"))
#' }
#'
cfbd_ratings_elo <- function(year = NULL, week = NULL, team = NULL, conference = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(year)
  validate_week(week)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/ratings/elo?"
  query_params <- list(
    "year" = year,
    "week" = week,
    "team" = team,
    "conference" = conference
  )
  full_url <- httr::modify_url(base_url, query=query_params)

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON()


      df <- df %>%
        make_cfbfastR_data("ELO ratings from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no elo rating system data available!"))
    },
    finally = {
    }
  )
  return(df)
}
