#' @name cfbd_ratings
#' @title
#' **CFBD Ratings and Rankings Endpoints Overview**
#' @description
#'
#' * `cfbd_rankings()`: Gets Historical CFB poll rankings at a specific week.
#' * `cfbd_ratings_sp()`: Get SP historical rating data.
#' * `cfbd_ratings_sp_conference()`: Get SP conference-level historical rating data.
#' * `cfbd_ratings_srs()`: Get SRS historical rating data.
#' * `cfbd_ratings_elo()`: Get Elo historical rating data.
#' * `cfbd_ratings_fpi()`: Get FPI historical rating data.
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
#' ### **Get FPI historical rating data**
#' Acquire the ESPN FPI ratings data by **team**, **year**, and **conference**
#' ```r
#' cfbd_ratings_fpi(year = 2019, team = "Texas")
#'
#' cfbd_ratings_fpi(year = 2018, conference = "SEC")
#' ```
NULL
#' @title
#' **Get historical Coaches and AP poll data**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*)
#' @param week (*Integer* optional): Week, values from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
#' @param season_type (*String* default both): Season type - regular, postseason, both, allstar, spring_regular, spring_postseason
#'
#' @return [cfbd_rankings()] - A data frame with 9 variables:
#'
#'  |col_name          |types     |description                                                                            |
#'  |:-----------------|:---------|:--------------------------------------------------------------------------------------|
#'  |season            |integer   |Four-digit year of the season (e.g. 2019).                                             |
#'  |season_type       |character |CFBD season type: "regular", "postseason", "both", or "allstar".                       |
#'  |week              |integer   |Week number within the season (1-15 regular, 1 for postseason).                        |
#'  |poll              |character |Poll name (e.g. "AP Top 25", "Coaches Poll", "Playoff Committee Rankings").            |
#'  |rank              |integer   |Position of the school within the poll for the given week (1 = top-ranked).            |
#'  |school            |character |Full school/team name as reported by the poll (e.g. "Georgia").                        |
#'  |conference        |character |Conference affiliation of the ranked school (e.g. "SEC", "ACC").                       |
#'  |first_place_votes |integer   |Number of first-place votes the school received in this poll week.                     |
#'  |points            |integer   |Total points accumulated by the school in the poll's weighted voting.                  |
#'
#' @keywords CFB Rankings
#' @importFrom cli cli_abort
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify resp_body_string
#' @importFrom dplyr arrange as_tibble group_by ungroup rename
#' @importFrom tidyr unnest
#' @importFrom purrr map_if
#' @importFrom glue glue
#' @family CFBD Ratings and Rankings
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
cfbd_rankings <- function(year, week = NULL, season_type = "both") {

  # Validation ----
  validate_api_key()
  validate_year(year)
  validate_week(week)
  validate_season_type(season_type, allow_both = TRUE)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/rankings"
  query_params <- list(
    "year" = year,
    "week" = week,
    "seasonType" = season_type
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  polls <- data.frame()
  tryCatch(
    expr = {
      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      polls <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE) |>
        purrr::map_if(is.data.frame, list) |>
        dplyr::as_tibble() |>
        tidyr::unnest("polls") |>
        tidyr::unnest("ranks") |>
        dplyr::group_by(.data$week, .data$poll) |>
        dplyr::arrange(.data$rank, .by_group = TRUE) |>
        dplyr::ungroup() |>
        dplyr::rename(
          "season_type" = "seasonType",
          "first_place_votes" = "firstPlaceVotes"
        )


      polls <- polls |>
        make_cfbfastR_data("Rankings data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no rankings data available! {conditionMessage(e)}"))
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
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*). Required if team not provided
#' @param team (*String* optional): D-I Team. Required if year not provided
#'
#' @return [cfbd_ratings_sp()] - A data frame with 26 variables:
#'
#'  |col_name                  |types     |description                                                                              |
#'  |:-------------------------|:---------|:----------------------------------------------------------------------------------------|
#'  |year                      |integer   |Four-digit season year (e.g. 2018).                                                      |
#'  |team                      |character |Full team name (e.g. "Texas A&M").                                                       |
#'  |conference                |character |Conference affiliation for the team in the given season.                                 |
#'  |rating                    |numeric   |Overall SP+ rating (Bill Connelly methodology, in points per game).                      |
#'  |ranking                   |integer   |National rank of the team's overall SP+ rating (1 = best).                               |
#'  |second_order_wins         |numeric   |Estimated wins based on opponent-adjusted efficiency rather than actual results.         |
#'  |sos                       |numeric   |Strength of schedule rating (SP+ scale).                                                 |
#'  |offense_ranking           |integer   |National rank of the team's offensive SP+ rating (1 = best).                             |
#'  |offense_rating            |numeric   |Offensive SP+ rating (points per drive adjusted for opponent).                           |
#'  |offense_success           |numeric   |Offensive success rate component of SP+ (probability 0-1).                               |
#'  |offense_explosiveness     |numeric   |Offensive explosiveness component of SP+ (EqPts/play on successful plays).               |
#'  |offense_rushing           |numeric   |Offensive rushing efficiency component of SP+.                                           |
#'  |offense_passing           |numeric   |Offensive passing efficiency component of SP+.                                           |
#'  |offense_standard_downs    |numeric   |Offensive SP+ on standard downs (1st, 2nd & <= 7, 3rd/4th & <= 4).                       |
#'  |offense_passing_downs     |numeric   |Offensive SP+ on passing downs (2nd & >= 8, 3rd/4th & >= 5).                             |
#'  |offense_run_rate          |numeric   |Share of offensive snaps that are designed runs (0-1).                                   |
#'  |offense_pace              |numeric   |Average seconds per play for the offense.                                                |
#'  |defense_ranking           |integer   |National rank of the team's defensive SP+ rating (1 = best).                             |
#'  |defense_rating            |numeric   |Defensive SP+ rating (points per drive allowed, opponent-adjusted).                      |
#'  |defense_success           |numeric   |Defensive success rate component of SP+ (probability 0-1).                               |
#'  |defense_explosiveness     |numeric   |Defensive explosiveness component of SP+ (EqPts/play allowed on successes).              |
#'  |defense_rushing           |numeric   |Defensive rushing efficiency component of SP+.                                           |
#'  |defense_passing           |numeric   |Defensive passing efficiency component of SP+.                                           |
#'  |defense_standard_downs    |numeric   |Defensive SP+ on standard downs.                                                         |
#'  |defense_passing_downs     |numeric   |Defensive SP+ on passing downs.                                                          |
#'  |defense_havoc_total       |numeric   |Total havoc rate (TFLs + PBUs + forced fumbles divided by plays).                        |
#'  |defense_havoc_front_seven |numeric   |Havoc rate contributed by the defensive front seven.                                     |
#'  |defense_havoc_db          |numeric   |Havoc rate contributed by defensive backs.                                               |
#'  |special_teams_rating      |numeric   |Special teams SP+ rating (points per game).                                              |
#'
#' @keywords SP+
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify resp_body_string
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @importFrom dplyr rename
#' @family CFBD Ratings and Rankings
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
  base_url <- "https://api.collegefootballdata.com/ratings/sp"
  query_params <- list(
    "year" = year,
    "team" = team
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE) |>
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


      df <- df |>
        make_cfbfastR_data("SP+ data from CollegeFootballData.com",Sys.time())
    },
    error = function(e){
      message(glue::glue("{Sys.time()}: Invalid arguments or no SP+ ratings data available! {conditionMessage(e)}"))
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
#'
#'  |col_name                  |types     |description                                                                              |
#'  |:-------------------------|:---------|:----------------------------------------------------------------------------------------|
#'  |year                      |integer   |Season of the conference rating.                                                         |
#'  |conference                |character |Conference name.                                                                         |
#'  |rating                    |numeric   |Conference SP+ rating.                                                                   |
#'  |second_order_wins         |logical   |Second-order wins for the conference - Not available for recent seasons.                 |
#'  |sos                       |logical   |Strength of schedule for the conference - Not available for recent seasons.              |
#'  |offense_rating            |numeric   |Overall offense rating for the conference.                                               |
#'  |offense_success           |logical   |Offense success rating for the conference - Not available for recent seasons.            |
#'  |offense_explosiveness     |logical   |Offense explosiveness rating for the conference - Not available for recent seasons.      |
#'  |offense_rushing           |logical   |Offense rushing rating for the conference - Not available for recent seasons.            |
#'  |offense_passing           |logical   |Offense passing rating for the conference - Not available for recent seasons.            |
#'  |offense_standard_downs    |logical   |Offense standard downs rating for the conference - Not available for recent seasons.     |
#'  |offense_passing_downs     |logical   |Offensive passing downs rating for the conference - Not available for recent seasons.    |
#'  |offense_run_rate          |logical   |Offense rushing rate for the conference - Not available for recent seasons.              |
#'  |offense_pace              |logical   |Offense pace factor for the conference - Not available for recent seasons.               |
#'  |defense_ranking           |integer   |Overall defense ranking for the conference.                                              |
#'  |defense_rating            |numeric   |Overall defense rating for the conference.                                               |
#'  |defense_success           |logical   |Defense success rating for the conference - Not available for recent seasons.            |
#'  |defense_explosiveness     |logical   |Defense explosiveness rating for the conference - Not available for recent seasons.      |
#'  |defense_rushing           |logical   |Defense rushing rating for the conference - Not available for recent seasons.            |
#'  |defense_passing           |logical   |Defense passing rating for the conference - Not available for recent seasons.            |
#'  |defense_standard_downs    |logical   |Defense standard downs rating for the conference - Not available for recent seasons.     |
#'  |defense_passing_downs     |logical   |Defensive passing downs rating for the conference - Not available for recent seasons.    |
#'  |defense_havoc_total       |logical   |Total defensive havoc rate for the conference - Not available for recent seasons.        |
#'  |defense_havoc_front_seven |logical   |Defense havoc rate from front 7 players for the conference - Not available for recent seasons. |
#'  |defense_havoc_db          |logical   |Defense havoc rate from defensive backs for the conference - Not available for recent seasons. |
#'  |special_teams_rating      |numeric   |Special teams rating for the conference.                                                 |
#'
#' @keywords SP+ Conference
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify resp_body_string
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @importFrom dplyr rename
#' @family CFBD Ratings and Rankings
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
  base_url <- "https://api.collegefootballdata.com/ratings/sp/conferences"
  query_params <- list(
    "year" = year,
    "conference" = conference
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE) |>
        as.data.frame() |>
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


      df <- df |>
        make_cfbfastR_data("Conference SP+ data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no conference-level SP+ ratings data available! {conditionMessage(e)}"))
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
#'
#'  |col_name   |types     |description                                                  |
#'  |:----------|:---------|:------------------------------------------------------------|
#'  |year       |integer   |Season of the SRS rating.                                    |
#'  |team       |character |Team name.                                                   |
#'  |conference |character |Conference of the team.                                      |
#'  |division   |character |Division in the conference for the team.                    |
#'  |rating     |numeric   |Simple Rating System (SRS) rating.                           |
#'  |ranking    |integer   |Simple Rating System ranking within the group returned.      |
#'
#' @keywords SRS
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify resp_body_string
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @family CFBD Ratings and Rankings
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
  base_url <- "https://api.collegefootballdata.com/ratings/srs"
  query_params <- list(
    "year" = year,
    "team" = team,
    "conference" = conference
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON() |>
        as.data.frame() |>
        dplyr::mutate(
          rating = as.numeric(.data$rating),
          ranking = as.integer(.data$ranking)
        )


      df <- df |>
        make_cfbfastR_data("SRS data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no simple rating system (SRS) data available! {conditionMessage(e)}"))
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
#' @param season_type (*String* default both): Season type - regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Elo information by conference
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
#'
#' @return [cfbd_ratings_elo()] - A data frame with 4 variables:
#'
#'  |col_name   |types     |description                                                                       |
#'  |:----------|:---------|:---------------------------------------------------------------------------------|
#'  |year       |integer   |Four-digit season year (e.g. 2019).                                               |
#'  |team       |character |Full team name (e.g. "Texas").                                                    |
#'  |conference |character |Conference affiliation for the team in the given season.                          |
#'  |elo        |numeric   |CFBD-calculated Elo rating for the team as of the requested week.                 |
#'
#' @keywords elo
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify resp_body_string
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @family CFBD Ratings and Rankings
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_ratings_elo(year = 2019, team = "Texas"))
#'
#'   try(cfbd_ratings_elo(year = 2018, conference = "SEC"))
#' }
#'
cfbd_ratings_elo <- function(year = NULL, week = NULL, season_type = "both", team = NULL, conference = NULL) {

  # Validation ----
  validate_api_key()
  validate_year(year)
  validate_week(week)
  validate_season_type(season_type)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/ratings/elo"
  query_params <- list(
    "year" = year,
    "week" = week,
    "seasonType" = season_type,
    "team" = team,
    "conference" = conference
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE) |>
        as.data.frame() |>
        janitor::clean_names() |>
        dplyr::mutate(elo = as.numeric(.data$elo))


      df <- df |>
        make_cfbfastR_data("Elo ratings from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no elo rating system data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **Get Football Power Index (FPI) historical rating data**
#' @description
#' Acquire the ESPN calculated FPI ratings data by team, year, and conference
#'
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*). Required if team not provided
#' @param team (*String* optional): D-I Team. Required if year not provided
#' @param conference (*String* optional): Conference name - select a valid FBS conference
#' Conference names P5: ACC,  Big 12, Big Ten, SEC, Pac-12
#' Conference names G5 and FBS Independents: Conference USA, Mid-American, Mountain West, FBS Independents, American Athletic
#'
#' @return [cfbd_ratings_fpi()] - A data frame with 14 variables:
#'
#'  |col_name                                    |types     |description                                                                                |
#'  |:-------------------------------------------|:---------|:------------------------------------------------------------------------------------------|
#'  |year                                        |integer   |Four-digit season year (e.g. 2019).                                                        |
#'  |team                                        |character |Full team name (e.g. "Texas").                                                             |
#'  |conference                                  |character |Conference affiliation for the team in the given season.                                   |
#'  |fpi                                         |numeric   |ESPN Football Power Index rating (projected scoring margin vs. average team).              |
#'  |resume_ranks_strength_of_record             |integer   |National rank of the team's strength of record (1 = best).                                 |
#'  |resume_ranks_fpi                            |integer   |National rank of the team's FPI rating (1 = best).                                         |
#'  |resume_ranks_average_win_probability        |integer   |National rank of the team's average single-game win probability (1 = best).                |
#'  |resume_ranks_strength_of_schedule           |integer   |National rank of the team's schedule strength to date (1 = toughest).                      |
#'  |resume_ranks_remaining_strength_of_schedule |integer   |National rank of the team's remaining schedule strength (1 = toughest).                    |
#'  |resume_ranks_game_control                   |integer   |National rank of the team's average in-game win probability (1 = best).                    |
#'  |efficiencies_overall                        |numeric   |Overall FPI efficiency rating (combined offense, defense, and special teams).              |
#'  |efficiencies_offense                        |numeric   |FPI offensive efficiency rating.                                                           |
#'  |efficiencies_defense                        |numeric   |FPI defensive efficiency rating.                                                           |
#'  |efficiencies_special_teams                  |numeric   |FPI special teams efficiency rating.                                                       |
#'
#' @keywords Ratings FPI
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 url_modify resp_body_string
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @family CFBD Ratings and Rankings
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_ratings_fpi(year = 2019, team = "Texas"))
#'
#'   try(cfbd_ratings_fpi(year = 2018, conference = "SEC"))
#' }
#'
cfbd_ratings_fpi <- function(year = NULL, team = NULL, conference = NULL) {

  # Validation ----
  validate_api_key()
  validate_reqs(year, team)
  validate_year(year)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/ratings/fpi"
  query_params <- list(
    "year" = year,
    "team" = team,
    "conference" = conference
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE) |>
        as.data.frame() |>
        janitor::clean_names()


      df <- df |>
        make_cfbfastR_data("ESPN FPI ratings from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no ESPN FPI rating system data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}
