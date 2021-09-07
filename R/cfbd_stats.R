#' @name cfbd_stats
#' @title 
#' **CFBD Stats Endpoint Overview**
#' @description 
#' \describe{
#' \item{`cfbd_stats_categories()`:}{ Get college football mapping for stats categories.}
#' \item{`cfbd_stats_season_team()`:}{ Get season statistics by team.}
#' \item{`cfbd_stats_season_advanced()`:}{ Get season advanced statistics by team.}
#' \item{`cfbd_stats_game_advanced()`:}{ Get game advanced stats.}
#' \item{`cfbd_stats_season_player()`:}{ Get season statistics by player.}
#' }
#' 
#' ### **Get game advanced stats**
#' ```r
#' cfbd_stats_game_advanced(year = 2018, week = 12, team = "Texas A&M")
#'
#' cfbd_stats_game_advanced(2019, team = "LSU")
#'
#' cfbd_stats_game_advanced(2013, team = "Florida State")
#' ```
#' 
#' ### **Get season advanced statistics by team**
#' ```r
#' cfbd_stats_season_advanced(2019, team = "LSU")
#' ```
#' 
#' ### **Get season statistics by player**
#' ```r
#' cfbd_stats_season_player(year = 2018, conference = "B12", start_week = 1, end_week = 7)
#'
#' cfbd_stats_season_player(2019, team = "LSU", category = "passing")
#'
#' cfbd_stats_season_player(2013, team = "Florida State", category = "passing")
#' ```
#' ### **Get season statistics by team**
#' ```r
#' cfbd_stats_season_team(year = 2018, conference = "B12", start_week = 1, end_week = 8)
#'
#' cfbd_stats_season_team(2019, team = "LSU")
#'
#' cfbd_stats_season_team(2013, team = "Florida State")
#' ````
#' 
#' ### **Get stats categories**
#' 
#' This function identifies all Stats Categories identified in the regular stats endpoint.
#' ```r
#' cfbd_stats_categories() 
#' ````
#'
NULL

#' @title  
#' **Get stats categories**
#' @description
#' This function identifies all Stats Categories identified in the regular stats endpoint.
#' @examples
#' \donttest{
#'    cfbd_stats_categories()
#' }
#' @return [cfbd_stats_categories()] A data frame with 38 values:
#' \describe{
#'   \item{name}{Statistics Categories}
#'   ...
#' }
#' @source <https://api.collegefootballdata.com/stats/categories>
#' @keywords Stats Categories
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom glue glue
#' @importFrom dplyr rename
#' @export
#'
cfbd_stats_categories <- function() {
  full_url <- "https://api.collegefootballdata.com/stats/categories"

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

      # message(glue::glue("{Sys.time()}: Scraping stats categories data..."))
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

#' @title 
#' **Get game advanced stats**
#' @param year (*Integer* required): Year, 4 digit format(*YYYY*)
#' @param week (*Integer* optional): Week - values from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
#' @param team (*String* optional): D-I Team
#' @param opponent (*String* optional): Opponent D-I Team
#' @param excl_garbage_time (*Logical* default FALSE): Select whether to exclude Garbage Time (TRUE/FALSE)
#' @param season_type (*String* default both): Select Season Type: regular, postseason, or both.
#' @param verbose Logical parameter (TRUE/FALSE, default: FALSE) to return warnings and messages from function
#'
#' @examples
#' \donttest{
#'    cfbd_stats_game_advanced(year = 2018, week = 12, team = "Texas A&M")
#'
#'    cfbd_stats_game_advanced(2019, team = "LSU")
#'
#'    cfbd_stats_game_advanced(2013, team = "Florida State")
#' }
#' @return [cfbd_stats_game_advanced()] - A data frame with 60 variables:
#' \describe{
#'   \item{`game_id`: integer.}{Referencing game id.}
#'   \item{`week`: integer.}{Game week of the season.}
#'   \item{`team`: character.}{Team name.}
#'   \item{`opponent`: character.}{Opponent team name.}
#'   \item{`off_plays`: integer.}{Offense plays in the game.}
#'   \item{`off_drives`: integer.}{Offense drives in the game.}
#'   \item{`off_ppa`: double.}{Offense predicted points added (PPA).}
#'   \item{`off_total_ppa`: double.}{Offense total predicted points added (PPA).}
#'   \item{`off_success_rate`: double.}{Offense success rate.}
#'   \item{`off_explosiveness`: double.}{Offense explosiveness rate.}
#'   \item{`off_power_success`: double.}{Offense power success rate.}
#'   \item{`off_stuff_rate`: double.}{Opponent stuff rate.}
#'   \item{`off_line_yds`: double.}{Offensive line yards.}
#'   \item{`off_line_yds_total`: integer.}{Offensive line yards total.}
#'   \item{`off_second_lvl_yds`: double.}{Offense second-level yards.}
#'   \item{`off_second_lvl_yds_total`: integer.}{Offense second-level yards total.}
#'   \item{`off_open_field_yds`: integer.}{Offense open field yards.}
#'   \item{`off_open_field_yds_total`: integer.}{Offense open field yards total.}
#'   \item{`off_standard_downs_ppa`: double.}{Offense standard downs predicted points added (PPA).}
#'   \item{`off_standard_downs_success_rate`: double.}{Offense standard downs success rate.}
#'   \item{`off_standard_downs_explosiveness`: double.}{Offense standard downs explosiveness rate.}
#'   \item{`off_passing_downs_ppa`: double.}{Offense passing downs predicted points added (PPA).}
#'   \item{`off_passing_downs_success_rate`: double.}{Offense passing downs success rate.}
#'   \item{`off_passing_downs_explosiveness`: double.}{Offense passing downs explosiveness rate.}
#'   \item{`off_rushing_plays_ppa`: double.}{Offense rushing plays predicted points added (PPA).}
#'   \item{`off_rushing_plays_total_ppa`: double.}{Offense rushing plays total predicted points added (PPA).}
#'   \item{`off_rushing_plays_success_rate`: double.}{Offense rushing plays success rate.}
#'   \item{`off_rushing_plays_explosiveness`: double.}{Offense rushing plays explosiveness rate.}
#'   \item{`off_passing_plays_ppa`: double.}{Offense passing plays predicted points added (PPA).}
#'   \item{`off_passing_plays_total_ppa`: double.}{Offense passing plays total predicted points added (PPA).}
#'   \item{`off_passing_plays_success_rate`: double.}{Offense passing plays success rate.}
#'   \item{`off_passing_plays_explosiveness`: double.}{Offense passing plays explosiveness rate.}
#'   \item{`def_plays`: integer.}{Defense plays in the game.}
#'   \item{`def_drives`: integer.}{Defense drives in the game.}
#'   \item{`def_ppa`: double.}{Defense predicted points added (PPA).}
#'   \item{`def_total_ppa`: double.}{Defense total predicted points added (PPA).}
#'   \item{`def_success_rate`: double.}{Defense success rate.}
#'   \item{`def_explosiveness`: double.}{Defense explosiveness rate.}
#'   \item{`def_power_success`: double.}{Defense power success rate.}
#'   \item{`def_stuff_rate`: double.}{Opponent stuff rate.}
#'   \item{`def_line_yds`: double.}{Offensive line yards.}
#'   \item{`def_line_yds_total`: integer.}{Offensive line yards total.}
#'   \item{`def_second_lvl_yds`: double.}{Defense second-level yards.}
#'   \item{`def_second_lvl_yds_total`: integer.}{Defense second-level yards total.}
#'   \item{`def_open_field_yds`: integer.}{Defense open field yards.}
#'   \item{`def_open_field_yds_total`: integer.}{Defense open field yards total.}
#'   \item{`def_standard_downs_ppa`: double.}{Defense standard downs predicted points added (PPA).}
#'   \item{`def_standard_downs_success_rate`: double.}{Defense standard downs success rate.}
#'   \item{`def_standard_downs_explosiveness`: double.}{Defense standard downs explosiveness rate.}
#'   \item{`def_passing_downs_ppa`: double.}{Defense passing downs predicted points added (PPA).}
#'   \item{`def_passing_downs_success_rate`: double.}{Defense passing downs success rate.}
#'   \item{`def_passing_downs_explosiveness`: double.}{Defense passing downs explosiveness rate.}
#'   \item{`def_rushing_plays_ppa`: double.}{Defense rushing plays predicted points added (PPA).}
#'   \item{`def_rushing_plays_total_ppa`: double.}{Defense rushing plays total predicted points added (PPA).}
#'   \item{`def_rushing_plays_success_rate`: double.}{Defense rushing plays success rate.}
#'   \item{`def_rushing_plays_explosiveness`: double.}{Defense rushing plays explosiveness rate.}
#'   \item{`def_passing_plays_ppa`: double.}{Defense passing plays predicted points added (PPA).}
#'   \item{`def_passing_plays_total_ppa`: double.}{Defense passing plays total predicted points added (PPA).}
#'   \item{`def_passing_plays_success_rate`: double.}{Defense passing plays success rate.}
#'   \item{`def_passing_plays_explosiveness`: double.}{Defense passing plays explosiveness rate.}
#' }
#' @source <https://api.collegefootballdata.com/stats/game/advanced>
#' @keywords Game Advanced Stats
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode URLdecode
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @export
#'
cfbd_stats_game_advanced <- function(year,
                                     week = NULL,
                                     team = NULL,
                                     opponent = NULL,
                                     excl_garbage_time = FALSE,
                                     season_type = "both",
                                     verbose = FALSE) {

  if(!is.numeric(year) && nchar(year) != 4){
    cli::cli_abort("Enter valid year as a number (YYYY)")
  }
  if (!is.null(week) && !is.numeric(week) && nchar(week) > 2) {
    # Check if week is numeric, if not NULL
    cli::cli_abort("Enter valid week 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)")
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
  if (excl_garbage_time != FALSE && excl_garbage_time!=TRUE) {
    # Check if excl_garbage_time is TRUE, if not FALSE
    cli::cli_abort("Enter valid excl_garbage_time value (Logical) - TRUE or FALSE")
  }

  
  if (!(season_type %in% c("postseason", "regular","both"))) {
    # Check if season_type is appropriate, if not NULL
    cli::cli_abort("Enter valid season_type (String): regular, postseason, or both")
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

      if(verbose){ 
        message(glue::glue("{Sys.time()}: Scraping game advanced stats..."))
      }
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

#' @title 
#' **Get season advanced statistics by team**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*)
#' @param team (*String* optional): D-I Team
#' @param excl_garbage_time (*Logical* default FALSE): Select whether to exclude Garbage Time (TRUE/FALSE)
#' @param start_week (*Integer* optional): Starting Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param end_week (*Integer* optional): Ending Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param verbose Logical parameter (TRUE/FALSE, default: FALSE) to return warnings and messages from function
#'
#' @examples
#' \donttest{
#'    cfbd_stats_season_advanced(2019, team = "LSU")
#' }
#' @return [cfbd_stats_season_advanced()] - A data frame with 79 variables:
#' \describe{
#'   \item{`season`: integer.}{Season of the statistics.}
#'   \item{`team`: character.}{Team name.}
#'   \item{`conference`: character.}{Conference of the team.}
#'   \item{`off_plays`: integer.}{Offense plays in the game.}
#'   \item{`off_drives`: integer.}{Offense drives in the game.}
#'   \item{`off_ppa`: double.}{Offense predicted points added (PPA).}
#'   \item{`off_total_ppa`: double.}{Offense total predicted points added (PPA).}
#'   \item{`off_success_rate`: double.}{Offense success rate.}
#'   \item{`off_explosiveness`: double.}{Offense explosiveness rate.}
#'   \item{`off_power_success`: double.}{Offense power success rate.}
#'   \item{`off_stuff_rate`: double.}{Offense rushing stuff rate.}
#'   \item{`off_line_yds`: double.}{Offensive line yards.}
#'   \item{`off_line_yds_total`: integer.}{Offensive line yards total.}
#'   \item{`off_second_lvl_yds`: double.}{Offense second-level yards.}
#'   \item{`off_second_lvl_yds_total`: integer.}{Offense second-level yards total.}
#'   \item{`off_open_field_yds`: integer.}{Offense open field yards.}
#'   \item{`off_open_field_yds_total`: integer.}{Offense open field yards total.}
#'   \item{`off_pts_per_opp`: double.}{Offense points per scoring opportunity.}
#'   \item{`off_field_pos_avg_start`: double.}{Offense starting average field position.}
#'   \item{`off_field_pos_avg_predicted_points`: double.}{Offense starting average field position predicted points (PP).}
#'   \item{`off_havoc_total`: double.}{Offense havor rate total.}
#'   \item{`off_havoc_front_seven`: double.}{Offense front-7 havoc rate.}
#'   \item{`off_havoc_db`: double.}{Offense defensive back havor rate.}
#'   \item{`off_standard_downs_rate`: double.}{Offense standard downs rate.}
#'   \item{`off_standard_downs_ppa`: double.}{Offense standard downs predicted points added (PPA).}
#'   \item{`off_standard_downs_success_rate`: double.}{Offense standard downs success rate.}
#'   \item{`off_standard_downs_explosiveness`: double.}{Offense standard downs explosiveness rate.}
#'   \item{`off_passing_downs_rate`: double.}{Offense passing downs rate.}
#'   \item{`off_passing_downs_ppa`: double.}{Offense passing downs predicted points added (PPA).}
#'   \item{`off_passing_downs_success_rate`: double.}{Offense passing downs success rate.}
#'   \item{`off_passing_downs_explosiveness`: double.}{Offense passing downs explosiveness rate.}
#'   \item{`off_rushing_plays_rate`: double.}{Offense rushing plays rate.}
#'   \item{`off_rushing_plays_ppa`: double.}{Offense rushing plays predicted points added (PPA).}
#'   \item{`off_rushing_plays_total_ppa`: double.}{Offense rushing plays total predicted points added (PPA).}
#'   \item{`off_rushing_plays_success_rate`: double.}{Offense rushing plays success rate.}
#'   \item{`off_rushing_plays_explosiveness`: double.}{Offense rushing plays explosiveness rate.}
#'   \item{`off_passing_plays_rate`: double.}{Offense passing plays rate.}
#'   \item{`off_passing_plays_ppa`: double.}{Offense passing plays predicted points added (PPA).}
#'   \item{`off_passing_plays_total_ppa`: double.}{Offense passing plays total predicted points added (PPA).}
#'   \item{`off_passing_plays_success_rate`: double.}{Offense passing plays success rate.}
#'   \item{`off_passing_plays_explosiveness`: double.}{Offense passing plays explosiveness rate.}
#'   \item{`def_plays`: integer.}{Defense plays in the game.}
#'   \item{`def_drives`: integer.}{Defense drives in the game.}
#'   \item{`def_ppa`: double.}{Defense predicted points added (PPA).}
#'   \item{`def_total_ppa`: double.}{Defense total predicted points added (PPA).}
#'   \item{`def_success_rate`: double.}{Defense success rate.}
#'   \item{`def_explosiveness`: double.}{Defense explosiveness rate.}
#'   \item{`def_power_success`: double.}{Defense power success rate.}
#'   \item{`def_stuff_rate`: double.}{Defense rushing stuff rate.}
#'   \item{`def_line_yds`: double.}{Defense Offensive line yards allowed.}
#'   \item{`def_line_yds_total`: integer.}{Defense Offensive line yards total allowed.}
#'   \item{`def_second_lvl_yds`: double.}{Defense second-level yards.}
#'   \item{`def_second_lvl_yds_total`: integer.}{Defense second-level yards total.}
#'   \item{`def_open_field_yds`: integer.}{Defense open field yards.}
#'   \item{`def_open_field_yds_total`: integer.}{Defense open field yards total.}
#'   \item{`def_pts_per_opp`: double.}{Defense points per scoring opportunity.}
#'   \item{`def_field_pos_avg_start`: double.}{Defense starting average field position.}
#'   \item{`def_field_pos_avg_predicted_points`: double.}{Defense starting average field position predicted points (PP).}
#'   \item{`def_havoc_total`: double.}{Defense havor rate total.}
#'   \item{`def_havoc_front_seven`: double.}{Defense front-7 havoc rate.}
#'   \item{`def_havoc_db`: double.}{Defense defensive back havor rate.}
#'   \item{`def_standard_downs_rate`: double.}{Defense standard downs rate.}
#'   \item{`def_standard_downs_ppa`: double.}{Defense standard downs predicted points added (PPA).}
#'   \item{`def_standard_downs_success_rate`: double.}{Defense standard downs success rate.}
#'   \item{`def_standard_downs_explosiveness`: double.}{Defense standard downs explosiveness rate.}
#'   \item{`def_passing_downs_rate`: double.}{Defense passing downs rate.}
#'   \item{`def_passing_downs_ppa`: double.}{Defense passing downs predicted points added (PPA).}
#'   \item{`def_passing_downs_success_rate`: double.}{Defense passing downs success rate.}
#'   \item{`def_passing_downs_explosiveness`: double.}{Defense passing downs explosiveness rate.}
#'   \item{`def_rushing_plays_rate`: double.}{Defense rushing plays rate.}
#'   \item{`def_rushing_plays_ppa`: double.}{Defense rushing plays predicted points added (PPA).}
#'   \item{`def_rushing_plays_total_ppa`: double.}{Defense rushing plays total predicted points added (PPA).}
#'   \item{`def_rushing_plays_success_rate`: double.}{Defense rushing plays success rate.}
#'   \item{`def_rushing_plays_explosiveness`: double.}{Defense rushing plays explosiveness rate.}
#'   \item{`def_passing_plays_rate`: double.}{Defense passing plays rate.}
#'   \item{`def_passing_plays_ppa`: double.}{Defense passing plays predicted points added (PPA).}
#'   \item{`def_passing_plays_total_ppa`: double.}{Defense passing plays total predicted points added (PPA).}
#'   \item{`def_passing_plays_success_rate`: double.}{Defense passing plays success rate.}
#'   \item{`def_passing_plays_explosiveness`: double.}{Defense passing plays explosiveness rate.}
#' }
#' @source <https://api.collegefootballdata.com/stats/season/advanced>
#' @keywords Team Season Advanced Stats
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode URLdecode
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @export
#'
cfbd_stats_season_advanced <- function(year,
                                       team = NULL,
                                       excl_garbage_time = FALSE,
                                       start_week = NULL,
                                       end_week = NULL,
                                       verbose = FALSE) {

  if(!is.numeric(year) && nchar(year) != 4){
    cli::cli_abort("Enter valid year as a number (YYYY)")
  }
  
  if (!is.null(team)) {
    if (team == "San Jose State") {
      team <- utils::URLencode(paste0("San Jos", "\u00e9", " State"), reserved = TRUE)
    } else {
      # Encode team parameter for URL if not NULL
      team <- utils::URLencode(team, reserved = TRUE)
    }
  }
  if (excl_garbage_time != FALSE && excl_garbage_time!=TRUE) {
    # Check if excl_garbage_time is TRUE, if not FALSE
    cli::cli_abort("Enter valid excl_garbage_time value (Logical) - TRUE or FALSE")
  }
  if (!is.null(start_week) && !is.numeric(start_week) && nchar(start_week) > 2) {
    # Check if start_week is numeric, if not NULL
    cli::cli_abort("Enter valid start_week 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)")
  }
  if (!is.null(end_week) && !is.numeric(end_week) && nchar(end_week) > 2) {
    # Check if end_week is numeric, if not NULL
    cli::cli_abort("Enter valid end_week 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)")
  }
  if (!is.null(start_week) && !is.null(end_week) && start_week > end_week) {
    cli::cli_abort("Enter valid start_week, end_week range")
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

      if(verbose){ 
        message(glue::glue("{Sys.time()}: Scraping season advanced stats..."))
      }
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


#' @title 
#' **Get season statistics by player**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*)
#' @param season_type (*String* default: regular): Select Season Type - regular, postseason, or both
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC\cr
#' @param start_week (*Integer* optional): Starting Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param end_week (*Integer* optional): Ending Week - values range fom 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param category (*String* optional): Category filter (e.g defensive)\cr
#' Offense: passing, receiving, rushing\cr
#' Defense: defensive, fumbles, interceptions\cr
#' Special Teams: punting, puntReturns, kicking, kickReturns
#' @param verbose Logical parameter (TRUE/FALSE, default: FALSE) to return warnings and messages from function
#' 
#' @examples
#' \donttest{
#'    cfbd_stats_season_player(year = 2018, conference = "B12", start_week = 1, end_week = 7)
#'
#'    cfbd_stats_season_player(2019, team = "LSU", category = "passing")
#'
#'    cfbd_stats_season_player(2013, team = "Florida State", category = "passing")
#' }
#' @return [cfbd_stats_season_player()] - A data frame with 59 variables:
#' \describe{
#'   \item{`team`: character.}{Team name.}
#'   \item{`conference`: character.}{Conference of the team.}
#'   \item{`athlete_id`: character.}{Athlete referencing id.}
#'   \item{`player`: character.}{Player name.}
#'   \item{`category`: character.}{Statistic category.}
#'   \item{`passing_completions`: double.}{Passing completions.}
#'   \item{`passing_att`: double.}{Passing attempts.}
#'   \item{`passing_pct`: double.}{Passing completion percentage.}
#'   \item{`passing_yds`: double.}{Passing yardage.}
#'   \item{`passing_td`: double.}{Passing touchdowns.}
#'   \item{`passing_int`: double.}{Passing interceptions.}
#'   \item{`passing_ypa`: double.}{Passing yards per attempt.}
#'   \item{`rushing_car`: double.}{Rushing yards per carry.}
#'   \item{`rushing_yds`: double.}{Rushing yards total.}
#'   \item{`rushing_td`: double.}{Rushing touchdowns.}
#'   \item{`rushing_ypc`: double.}{Rushing yards per carry.}
#'   \item{`rushing_long`: double.}{Rushing longest yardage attempt.}
#'   \item{`receiving_rec`: double.}{Receiving - pass receptions.}
#'   \item{`receiving_yds`: double.}{Receiving - pass reception yards.}
#'   \item{`receiving_td`: double.}{Receiving - passing reception touchdowns.}
#'   \item{`receiving_ypr`: double.}{Receiving - passing yards per reception.}
#'   \item{`receiving_long`: double.}{Receiving - longest pass reception yardage.}
#'   \item{`fumbles_fum`: double.}{Fumbles.}
#'   \item{`fumbles_rec`: double.}{Fumbles recovered.}
#'   \item{`fumbles_lost`: double.}{Fumbles lost.}
#'   \item{`defensive_solo`: double.}{Defensive solo tackles.}
#'   \item{`defensive_tot`: double.}{Defensive total tackles.}
#'   \item{`defensive_tfl`: double.}{Defensive tackles for loss.}
#'   \item{`defensive_sacks`: double.}{Defensive sacks.}
#'   \item{`defensive_qb_hur`: double.}{Defensive quarterback hurries.}
#'   \item{`interceptions_int`: double.}{Interceptions total.}
#'   \item{`interceptions_yds`: double.}{Interception return yards.}
#'   \item{`interceptions_avg`: double.}{Interception return yards average.}
#'   \item{`interceptions_td`: double.}{Interception return touchdowns.}
#'   \item{`defensive_pd`: double.}{Defense - passes defensed.}
#'   \item{`defensive_td`: double.}{Defense - defensive touchdowns.}
#'   \item{`kicking_fgm`: double.}{Kicking - field goals made.}
#'   \item{`kicking_fga`: double.}{Kicking - field goals attempted.}
#'   \item{`kicking_pct`: double.}{Kicking - field goal percentage.}
#'   \item{`kicking_xpa`: double.}{Kicking - extra points attempted.}
#'   \item{`kicking_xpm`: double.}{Kicking - extra points made.}
#'   \item{`kicking_pts`: double.}{Kicking - total points.}
#'   \item{`kicking_long`: double.}{Kicking - longest successful field goal attempt.}
#'   \item{`kick_returns_no`: double.}{Kick Returns - number of kick returns.}
#'   \item{`kick_returns_yds`: double.}{Kick Returns - kick return yards.}
#'   \item{`kick_returns_avg`: double.}{Kick Returns - kick return average yards per return.}
#'   \item{`kick_returns_td`: double.}{Kick Returns - kick return touchdowns.}
#'   \item{`kick_returns_long`: double.}{Kick Returns - longest kick return yardage.}
#'   \item{`punting_no`: double.}{Punting - number of punts.}
#'   \item{`punting_yds`: double.}{Punting - punting yardage.}
#'   \item{`punting_ypp`: double.}{Punting - yards per punt.}
#'   \item{`punting_long`: double.}{Punting - longest punt yardage.}
#'   \item{`punting_in_20`: double.}{Punting - punt downed inside the 20 yard line.}
#'   \item{`punting_tb`: double.}{Punting - punt caused a touchback.}
#'   \item{`punt_returns_no`: double.}{Punt Returns - number of punt returns.}
#'   \item{`punt_returns_yds`: double.}{Punt Returns - punt return yardage total.}
#'   \item{`punt_returns_avg`: double.}{Punt Returns - punt return average yards per return.}
#'   \item{`punt_returns_td`: double.}{Punt Returns - punt return touchdowns.}
#'   \item{`punt_returns_long`: double.}{Punt Returns - longest punt return yardage.}
#' }
#' @source <https://api.collegefootballdata.com/stats/player/season>
#' @keywords Player Season Stats
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode URLdecode
#' @importFrom cli cli_abort
#' @importFrom janitor clean_names
#' @importFrom glue glue
#' @importFrom dplyr mutate mutate_at rename select
#' @importFrom tidyr pivot_wider everything
#' @export
#'
cfbd_stats_season_player <- function(year,
                                     season_type = "regular",
                                     team = NULL,
                                     conference = NULL,
                                     start_week = NULL,
                                     end_week = NULL,
                                     category = NULL,
                                     verbose = FALSE) {
  stat_categories <- c(
    "passing", "receiving", "rushing", "defensive", "fumbles",
    "interceptions", "punting", "puntReturns", "kicking", "kickReturns"
  )

  # Check if year is numeric
  if(!is.numeric(year) && nchar(year) != 4){
    cli::cli_abort("Enter valid year as a number (YYYY)")
  }

  if (!(season_type %in% c("postseason", "regular","both"))) {
    # Check if season_type is appropriate, if not NULL
    cli::cli_abort("Enter valid season_type (String): regular, postseason, or both")
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
    # Encode conference parameter for URL, if not NULL
    conference <- utils::URLencode(conference, reserved = TRUE)
  }

  if (!is.null(start_week) && !is.numeric(start_week) && nchar(start_week) > 2) {
    # Check if start_week is numeric, if not NULL
    cli::cli_abort("Enter valid start_week 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)")
  }
  if (!is.null(end_week) && !is.numeric(end_week) && nchar(end_week) > 2) {
    # Check if end_week is numeric, if not NULL
    cli::cli_abort("Enter valid end_week 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)")
  }
  if (!is.null(start_week) && !is.null(end_week) && start_week > end_week) {
    cli::cli_abort("Enter valid start_week, end_week range")
  }
  if (!is.null(category)){ 
    if(!(category %in% stat_categories)) {
      # Check category parameter in category if not NULL
      cli::cli_abort("Incorrect category, potential misspelling.\nOffense: passing, receiving, rushing\nDefense: defensive, fumbles, interceptions\nSpecial Teams: punting, puntReturns, kicking, kickReturns")
    }
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

      if(verbose){ 
        message(glue::glue("{Sys.time()}: Scraping season stats - player..."))
      }
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

#' @title 
#' **Get season statistics by team**
#' @param year (*Integer* required): Year, 4 digit format (*YYYY*)
#' @param season_type (*String* default: regular): Select Season Type - regular, postseason, or both
#' @param team (*String* optional): D-I Team
#' @param conference (*String* optional): Conference abbreviation - Select a valid FBS conference\cr
#' Conference abbreviations P5: ACC, B12, B1G, SEC, PAC\cr
#' Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC\cr
#' @param start_week (*Integer* optional): Starting Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param end_week (*Integer* optional): Ending Week - values range from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param verbose Logical parameter (TRUE/FALSE, default: FALSE) to return warnings and messages from function
#'
#' @examples
#' \donttest{
#'    cfbd_stats_season_team(year = 2018, conference = "B12", start_week = 1, end_week = 8)
#'
#'    cfbd_stats_season_team(2019, team = "LSU")
#'
#'    cfbd_stats_season_team(2013, team = "Florida State")
#' }
#' @return [cfbd_stats_season_team()] - A data frame with 46 variables:
#' \describe{
#'   \item{`games`: integer.}{Number of games.}
#'   \item{`team`: character.}{Team name.}
#'   \item{`conference`: character.}{Conference of team.}
#'   \item{`games`: integer.}{Number of games.}
#'   \item{`time_of_poss_total`: integer.}{Time of possession total.}
#'   \item{`time_of_poss_pg`: double.}{Time of possession per game.}
#'   \item{`pass_comps`: integer.}{Total number of pass completions.}
#'   \item{`pass_atts`: integer.}{Total number of pass attempts.}
#'   \item{`completion_pct`: double.}{Passing completion percentage.}
#'   \item{`net_pass_yds`: integer.}{Net passing yards.}
#'   \item{`pass_ypa`: double.}{Passing yards per attempt.}
#'   \item{`pass_ypr`: double.}{Passing yards per reception.}
#'   \item{`pass_TDs`: integer.}{Passing touchdowns.}
#'   \item{`interceptions`: integer.}{Passing interceptions.}
#'   \item{`int_pct`: double.}{Interception percentage (of attempts).}
#'   \item{`rush_atts`: integer.}{Rushing attempts.}
#'   \item{`rush_yds`: integer.}{Rushing yards.}
#'   \item{`rush_TDs`: integer.}{Rushing touchdowns.}
#'   \item{`rush_ypc`: double.}{Rushing yards per carry.}
#'   \item{`total_yds`: integer.}{Rushing total yards.}
#'   \item{`fumbles_lost`: integer.}{Fumbles lost.}
#'   \item{`turnovers`: integer.}{Turnovers total.}
#'   \item{`turnovers_pg`: double.}{Turnovers per game.}
#'   \item{`first_downs`: integer.}{Number of first downs.}
#'   \item{`third_downs`: integer.}{Number of third downs.}
#'   \item{`third_down_convs`: integer.}{Number of third down conversions.}
#'   \item{`third_conv_rate`: double.}{Third down conversion rate.}
#'   \item{`fourth_down_convs`: integer.}{Fourth down conversions.}
#'   \item{`fourth_downs`: integer.}{Fourth downs.}
#'   \item{`fourth_conv_rate`: double.}{Fourth down conversion rate.}
#'   \item{`penalties`: integer.}{Total number of penalties.}
#'   \item{`penalty_yds`: integer.}{Penalty yards total.}
#'   \item{`penalties_pg`: double.}{Penalties per game.}
#'   \item{`penalty_yds_pg`: double.}{Penalty yardage per game.}
#'   \item{`yards_per_penalty`: double.}{Average yards per penalty.}
#'   \item{`kick_returns`: integer.}{Number of kick returns.}
#'   \item{`kick_return_yds`: integer.}{Total kick return yards.}
#'   \item{`kick_return_TDs`: integer.}{Total kick return touchdowns.}
#'   \item{`kick_return_avg`: double.}{Kick return yards average.}
#'   \item{`punt_returns`: integer.}{Number of punt returns.}
#'   \item{`punt_return_yds`: integer.}{Punt return total yards.}
#'   \item{`punt_return_TDs`: integer.}{Punt return total touchdowns.}
#'   \item{`punt_return_avg`: double.}{Punt return yards average.}
#'   \item{`passes_intercepted`: integer.}{Passes intercepted.}
#'   \item{`passes_intercepted_yds`: integer.}{Pass interception return yards.}
#'   \item{`passes_intercepted_TDs`: integer.}{Pass interception return touchdowns.}
#' }
#' @source <https://api.collegefootballdata.com/stats/season>
#' @keywords Team Season Stats
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode URLdecode
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @importFrom dplyr select mutate rename
#' @importFrom tidyr pivot_wider
#' @export
#'
cfbd_stats_season_team <- function(year,
                                   season_type = "regular",
                                   team = NULL,
                                   conference = NULL,
                                   start_week = NULL,
                                   end_week = NULL,
                                   verbose = FALSE) {

  # Check if year is numeric
  if(!is.numeric(year) && nchar(year) != 4){
    cli::cli_abort("Enter valid year as a number (YYYY)")
  }
  
  if (!(season_type %in% c("postseason", "regular","both"))) {
    # Check if season_type is appropriate, if not NULL
    cli::cli_abort("Enter valid season_type (String): regular, postseason, or both")
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
    # Encode conference parameter for URL, if not NULL
    conference <- utils::URLencode(conference, reserved = TRUE)
  }

  if (!is.null(start_week) && !is.numeric(start_week) && nchar(start_week) > 2) {
    # Check if start_week is numeric, if not NULL
    cli::cli_abort("Enter valid start_week 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)")
  }
  if (!is.null(end_week) && !is.numeric(end_week) && nchar(end_week) > 2) {
    # Check if end_week is numeric, if not NULL
    cli::cli_abort("Enter valid end_week 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)")
  }
  if (!is.null(start_week) && !is.null(end_week) && start_week > end_week) {
    cli::cli_abort("Enter valid start_week, end_week range")
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

      if(verbose){ 
        message(glue::glue("{Sys.time()}: Scraping season team stats..."))
      }
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
