#' @name cfbd_play
#' @title
#' **CFBD Plays Endpoint Overview**
#' @description College football plays data
#' \describe{
#' \item{`cfbd_plays()`:}{ CFBD's college football play-by-play.}
#' \item{`cfbd_play_stats_player()`:}{ Gets player info associated by play.}
#' \item{`cfbd_play_stats_types()`:}{ Gets CFBD play stat types.}
#' \item{`cfbd_play_types()`:}{ Gets CFBD play types.}
#' }
#' @details
#' ### **Pull first 3 weeks of 2020 season using `cfbd_plays()`**
#' ```r
#'  year_vector <- 2020
#'  week_vector <- 1:3
#'  weekly_year_df <- expand.grid(year = year_vector, week = week_vector)
#'  tictoc::tic()
#'  year_split <- split(weekly_year_df, weekly_year_df$year)
#'  for (i in 1:length(year_split)) {
#'    i <- 1
#'
#'    progressr::with_progress({
#'       year_split[[i]] <- year_split[[i]] %>%
#'          dplyr::mutate(
#'             pbp = purrr::map2(
#'                 .x = year,
#'                 .y = week,
#'                 cfbd_plays,
#'                 season_type = "both"
#'             )
#'          )
#'      Sys.sleep(1)
#'    })
#'  }
#'
#'  tictoc::toc()
#'  year_split <- lapply(year_split, function(x) {
#'      x %>% tidyr::unnest(pbp, names_repair = "minimal")
#'  })
#'
#'  all_years <- dplyr::bind_rows(year_split)
#'  glimpse(all_years)
#' ```
#' ### **Gets player info associated by play**
#' ```r
#' cfbd_play_stats_player(game_id = 401110722)
#' ```
#' ### **Gets CFBD play stat types**
#' ```r
#' cfbd_play_stats_types()
#' ```
#' ### **Gets CFBD play types**
#' ```r
#' cfbd_play_types()
#' ```
NULL
#' @title
#' **Get college football play-by-play data.**
#' @param season_type (*String* default regular): Season type - regular, postseason, both, allstar, spring_regular, spring_postseason
#' @param year Select year, (example: 2018)
#' @param week Select week, this is optional (also numeric)
#' @param team Select team name (example: Texas, Texas A&M, Clemson)
#' @param offense Select offense name (example: Texas, Texas A&M, Clemson)
#' @param defense Select defense name (example: Texas, Texas A&M, Clemson)
#' @param conference Select conference name (example: ACC, B1G, B12, SEC,
#'  PAC, MAC, MWC, CUSA, Ind, SBC, AAC, Western, MVIAA, SWC, PCC, Big 6, etc.)
#' @param offense_conference Select conference name (example: ACC, B1G, B12, SEC,
#'  PAC, MAC, MWC, CUSA, Ind, SBC, AAC, Western, MVIAA, SWC, PCC, Big 6, etc.)
#' @param defense_conference Select conference name (example: ACC, B1G, B12, SEC,
#'  PAC, MAC, MWC, CUSA, Ind, SBC, AAC, Western, MVIAA, SWC, PCC, Big 6, etc.)
#' @param play_type Select play type (example: see the [cfbd_play_type_df])
#' @param division (*String* optional): Division abbreviation - Select a valid division: fbs/fcs/ii/iii
#' @return [cfbd_plays()] - A data frame with 29 columns:
#' \describe{
#'   \item{`play_id`: character.}{Referencing play id.}
#'   \item{`offense`: character.}{Offense on the field.}
#'   \item{`offense_conference`: character.}{Conference of the offense on the field.}
#'   \item{`defense`: character.}{Defense on the field.}
#'   \item{`defense_conference`: character.}{Conference of the defense on the field.}
#'   \item{`home`: character.}{Home team.}
#'   \item{`away`: character.}{Away team.}
#'   \item{`offense_score`: integer.}{Offense's post-play score.}
#'   \item{`defense_score`: integer.}{Defense's post-play score.}
#'   \item{`game_id`: integer.}{Referencing game id.}
#'   \item{`drive_id`: character.}{Referencing drive id.}
#'   \item{`drive_number`: integer.}{Drive number in the game.}
#'   \item{`play_number`: integer.}{Play number in the game.}
#'   \item{`period`: integer.}{Game period (quarter).}
#'   \item{`offense_timeouts`: integer.}{Timeouts for the offense at the end of the play.}
#'   \item{`defense_timeouts`: integer.}{Timeouts for the defense at the end of the play.}
#'   \item{`yard_line`: integer.}{Yard line (~0-50) of the play.}
#'   \item{`yards_to_goal`: integer.}{Yards to the goal line (~0-100).}
#'   \item{`down`: integer.}{Down of the play.}
#'   \item{`distance`: integer.}{Distance to the sticks, i.e. 1st down or goal-line in goal-to-go situations.}
#'   \item{`scoring`: logical.}{Scoring play flag.}
#'   \item{`yards_gained`: integer.}{Yards net gained by the offense on the play.}
#'   \item{`play_type`: character.}{Categorical label of the type of the play.}
#'   \item{`play_text`: character.}{A text description of the play.}
#'   \item{`ppa`: character.}{Predicted Points Added (calculated by CFBD).}
#'   \item{`clock_minutes`: integer.}{Minutes left on the clock.}
#'   \item{`clock_seconds`: integer.}{Seconds left on the clock.}
#' }
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @family CFBD PBP
#' @export
#' @examples
#' \dontrun{
#'   try(cfbd_plays(year = 2021, week = 1))
#' }
cfbd_plays <- function(year = 2020,
                       season_type = "regular",
                       week = 1,
                       team = NULL,
                       offense = NULL,
                       defense = NULL,
                       conference = NULL,
                       offense_conference = NULL,
                       defense_conference = NULL,
                       play_type = NULL,
                       division = 'fbs') {

  # Validation ----
  validate_api_key()
  validate_year(year)
  validate_week(week)
  validate_season_type(season_type)

  # Team Name Handling ----
  team <- handle_accents(team)
  offense <- handle_accents(offense)
  defense <- handle_accents(defense)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/plays"
  query_params <- list(
    "year" = year,
    "week" = week,
    "team" = team,
    "offense" = offense,
    "defense" = defense,
    "offenseConference" = offense_conference,
    "defenseConference" = defense_conference,
    "seasonType" = season_type,
    "playType" = play_type,
    "classification" = division
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
        dplyr::rename("play_id" = "id") %>%
        janitor::clean_names()


      df <- df %>%
        make_cfbfastR_data("Play-by-play data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
        message(glue::glue("{Sys.time()}: Invalid arguments or no plays data available!"))
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **Gets player info associated by play**
#' @param year (*Integer* optional): Year, 4 digit format (*YYYY*)
#' @param week (*Integer* optional): Week - values from 1-15, 1-14 for seasons pre-playoff, i.e. 2013 or earlier
#' @param team (*String* optional): D-I Team
#' @param game_id (*Integer* optional): Game ID filter for querying a single game
#' Can be found using the [cfbd_game_info()] function
#' @param athlete_id (*Integer* optional): Athlete ID filter for querying a single athlete
#' Can be found using the [cfbd_player_info()] function.
#' @param stat_type_id (*Integer* optional): Stat Type ID filter for querying a single stat type
#' Can be found using the [cfbd_play_stats_types()] function
#' @param season_type (*String* default regular): Season type - regular, postseason, both, allstar, spring_regular, spring_postseason
#' @return [cfbd_play_stats_player()] - A data frame with 54 variables:
#' \describe{
#'   \item{`play_id`: character.}{Referencing play id.}
#'   \item{`game_id`: integer.}{Referencing game id.}
#'   \item{`season`: integer.}{Season of the play.}
#'   \item{`week`: integer.}{Week of the play.}
#'   \item{`opponent`: character.}{Opponent of the offense on the play.}
#'   \item{`team_score`: integer.}{Offense team score.}
#'   \item{`opponent_score`: integer.}{Defense team score.}
#'   \item{`drive_id`: character.}{Referencing drive id.}
#'   \item{`period`: integer.}{Game period (quarter) of the play.}
#'   \item{`yards_to_goal`: integer.}{Yards to the goal line (~0-100).}
#'   \item{`down`: integer.}{Down of the play.}
#'   \item{`distance`: integer.}{Distance to the sticks, i.e. 1st down or goal-line in goal-to-go situations.}
#'   \item{`reception_player_id`: character.}{Pass receiver player reference id.}
#'   \item{`reception_player`: character.}{Pass receiver player name.}
#'   \item{`reception_yds`: integer.}{Reception yards.}
#'   \item{`completion_player_id`: character.}{Passing player reference id.}
#'   \item{`completion_player`: character.}{Passing player name.}
#'   \item{`completion_yds`: integer.}{Passing yards.}
#'   \item{`rush_player_id`: character.}{Rushing player reference id.}
#'   \item{`rush_player`: character.}{Rushing player name.}
#'   \item{`rush_yds`: integer.}{Rushing yards.}
#'   \item{`interception_player_id`: character.}{Intercepting player reference id.}
#'   \item{`interception_player`: character.}{Intercepting player name.}
#'   \item{`interception_stat`: integer.}{Intercepting stat.}
#'   \item{`interception_thrown_player_id`: character.}{Interception passing player reference id.}
#'   \item{`interception_thrown_player`: character.}{Interception passing player name.}
#'   \item{`interception_thrown_stat`: integer.}{Interception thrown stat.}
#'   \item{`touchdown_player_id`: character.}{Touchdown scoring player reference id.}
#'   \item{`touchdown_player`: character.}{Touchdown scoring player name.}
#'   \item{`touchdown_stat`: integer.}{Touchdown scoring stat.}
#'   \item{`incompletion_player_id`: character.}{Incomplete receiver player reference id.}
#'   \item{`incompletion_player`: character.}{Incomplete receiver player name.}
#'   \item{`incompletion_stat`: integer.}{Incomplete stat.}
#'   \item{`target_player_id`: character.}{Targeted receiver player reference id.}
#'   \item{`target_player`: character.}{Targeted receiver player name.}
#'   \item{`target_stat`: integer.}{Target stat.}
#'   \item{`fumble_recovered_player_id`: logical.}{Fumble recovering player reference id.}
#'   \item{`fumble_recovered_player`: logical.}{Fumble recovering player name.}
#'   \item{`fumble_recovered_stat`: logical.}{Fumble recovered stat.}
#'   \item{`fumble_forced_player_id`: logical.}{Fumble forcing player reference id.}
#'   \item{`fumble_forced_player`: logical.}{Fumble forcing player name.}
#'   \item{`fumble_forced_stat`: logical.}{Fumble forced stat.}
#'   \item{`fumble_player_id`: logical.}{Fumbling player reference id.}
#'   \item{`fumble_player`: logical.}{Fumbling player name.}
#'   \item{`fumble_stat`: logical.}{Fumble stat.}
#'   \item{`sack_player_id`: character.}{Sacking player(s) reference id.}
#'   \item{`sack_player`: character.}{Sacking player(s) name.}
#'   \item{`sack_stat`: integer.}{Sack stat.}
#'   \item{`sack_taken_player_id`: character.}{Sack taking player reference id.}
#'   \item{`sack_taken_player`: character.}{Sack taking player name.}
#'   \item{`sack_taken_stat`: integer.}{Sack taken stat.}
#'   \item{`pass_breakup_player_id`: logical.}{Pass breakup player reference id.}
#'   \item{`pass_breakup_player`: logical.}{Pass breakup player name.}
#'   \item{`pass_breakup_stat`: logical.}{Pass breakup (PBU) stat.}
#' }
#' @keywords Player PBP
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom cli cli_abort
#' @import dplyr
#' @import tidyr
#' @import purrr
#' @family CFBD PBP
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_play_stats_player(game_id = 401110722))
#' }
cfbd_play_stats_player <- function(year = NULL,
                                   week = NULL,
                                   team = NULL,
                                   game_id = NULL,
                                   athlete_id = NULL,
                                   stat_type_id = NULL,
                                   season_type = "regular") {

  # Validation ----
  validate_api_key()
  validate_year(year)
  validate_week(week)
  validate_id(game_id)
  validate_id(athlete_id)
  validate_id(stat_type_id)
  validate_season_type(season_type)

  # Team Name Handling ----
  team <- handle_accents(team)

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/plays/stats"
  query_params <- list(
    "year" = year,
    "week" = week,
    "team" = team,
    "gameId" = game_id,
    "athleteID" = athlete_id,
    "statTypeId" = stat_type_id,
    "seasonType" = season_type
  )
  full_url <- httr::modify_url(base_url, query=query_params)

  clean_df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

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
          "game_id" = "gameId",
          "team_score" = "teamScore",
          "opponent_score" = "opponentScore",
          "drive_id" = "driveId",
          "play_id" = "playId",
          "yards_to_goal" = "yardsToGoal",
          "athlete_id" = "athleteId",
          "athlete_name" = "athleteName",
          "stat_type" = "statType",
          "stat" = "stat"
        )

      colnames(df) <- sub(" ", "_", tolower(colnames(df)))

      clean_df <- df %>%
        tidyr::pivot_wider(
          names_from = "stat_type",
          values_from = "athlete_name"
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
          "game_id",
          "season",
          "week",
          "opponent",
          "team_score",
          "opponent_score",
          "drive_id",
          "play_id",
          "period",
          "yards_to_goal",
          "down",
          "distance",
          "reception_player_id",
          "reception_player",
          "reception_yds",
          "completion_player_id",
          "completion_player",
          "completion_yds",
          "rush_player_id",
          "rush_player",
          "rush_yds",
          "interception_player_id",
          "interception_player",
          "interception_stat",
          "interception_thrown_player_id",
          "interception_thrown_player",
          "interception_thrown_stat",
          "touchdown_player_id",
          "touchdown_player",
          "touchdown_stat",
          "incompletion_player_id",
          "incompletion_player",
          "incompletion_stat",
          "target_player_id",
          "target_player",
          "target_stat",
          "fumble_recovered_player_id",
          "fumble_recovered_player",
          "fumble_recovered_stat",
          "fumble_forced_player_id",
          "fumble_forced_player",
          "fumble_forced_stat",
          "fumble_player_id",
          "fumble_player",
          "fumble_stat",
          "sack_player_id",
          "sack_player",
          "sack_stat",
          "sack_taken_player_id",
          "sack_taken_player",
          "sack_taken_stat",
          "pass_breakup_player_id",
          "pass_breakup_player",
          "pass_breakup_stat"
        ) %>%
        dplyr::group_by(.data$play_id) %>%
        dplyr::summarise_all(coalesce_by_column) %>%
        dplyr::ungroup()


      clean_df <- clean_df %>%
        make_cfbfastR_data("Play-level player data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no play-level player stats data available!"))
    },
    finally = {
    }
  )
  return(clean_df)
}

#' @title
#' **Get college football mapping for play stats types**
#' @return [cfbd_play_stats_types()] - A data frame with 25 rows and 2 variables:
#' \describe{
#'   \item{`play_stat_type_id`: integer}{Referencing play stat type ID.}
#'   \item{`name`: character}{Type of play stats.}
#' }
#' @keywords Plays
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom glue glue
#' @family CFBD PBP
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_play_stats_types())
#' }
cfbd_play_stats_types <- function() {

  # Validation ----
  validate_api_key()

  # Query API ----
  full_url <- "https://api.collegefootballdata.com/plays/stats/types"

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
        dplyr::rename("play_stat_type_id" = "id")


      df <- df %>%
        make_cfbfastR_data("Play stats type data from CollegeFootballData.com",Sys.time())

    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no play stats types data available!"))
    },
    finally = {
    }
  )
  return(df)
}

#' @title
#' **Get college football mapping for play types**
#' @return [cfbd_play_types()] - A data frame with 48 rows and 3 variables:
#' \describe{
#'   \item{`play_type_id`: integer}{Referencing play type id.}
#'   \item{`text`: character}{play type description.}
#'   \item{`abbreviation`: character}{play type abbreviation used for function call}
#' }
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @family CFBD PBP
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_play_types())
#' }
cfbd_play_types <- function() {

  # Validation ----
  validate_api_key()

  # Query API ----
  full_url <- "https://api.collegefootballdata.com/plays/types"

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
        dplyr::rename("play_type_id" = "id")

      df <- df %>%
        make_cfbfastR_data("Play types data from CollegeFootballData.com",Sys.time())

    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no play types data available!"))
    },
    finally = {
    }
  )
  return(df)
}


#' @title
#' **Get live college football play-by-play data.**
#' @param game_id (*Integer* Required): Game ID filter for querying a single game
#' Can be found using the [cfbd_game_info()] function
#' @return [cfbd_live_plays()] - A data frame with 94 columns:
#'
#'   |col_name                         |types     |
#'   |:--------------------------------|:---------|
#'   |game_id                          |integer   |
#'   |home_team_id                     |integer   |
#'   |home_team                        |character |
#'   |away_team_id                     |integer   |
#'   |away_team                        |character |
#'   |play_id                          |character |
#'   |home_score                       |integer   |
#'   |away_score                       |integer   |
#'   |period                           |integer   |
#'   |clock                            |character |
#'   |wall_clock                       |character |
#'   |offense_team_id                  |integer   |
#'   |offense_team                     |character |
#'   |down                             |integer   |
#'   |distance                         |integer   |
#'   |yards_to_goal                    |integer   |
#'   |yards_gained                     |integer   |
#'   |play_type_id                     |integer   |
#'   |play_type                        |character |
#'   |ppa                              |numeric   |
#'   |garbage_time                     |logical   |
#'   |success                          |logical   |
#'   |rush_pash                        |character |
#'   |down_type                        |character |
#'   |play_text                        |character |
#'   |drive_id                         |character |
#'   |drive_offense_id                 |integer   |
#'   |drive_offense_team               |character |
#'   |drive_defense_id                 |integer   |
#'   |drive_defense_team               |character |
#'   |drive_play_count                 |integer   |
#'   |drive_yards_gained               |integer   |
#'   |drive_start_period               |integer   |
#'   |drive_start_clock                |character |
#'   |drive_start_yards_to_goal        |integer   |
#'   |drive_end_period                 |integer   |
#'   |drive_end_clock                  |character |
#'   |drive_end_yards_to_goal          |integer   |
#'   |drive_duration                   |character |
#'   |drive_scoring_opportunity        |logical   |
#'   |drive_result                     |character |
#'   |drive_points_gained              |integer   |
#'   |current_clock                    |character |
#'   |current_possession               |character |
#'   |home_line_scores_q1              |integer   |
#'   |home_line_scores_q2              |integer   |
#'   |home_line_scores_q3              |integer   |
#'   |home_line_scores_q4              |integer   |
#'   |home_points                      |integer   |
#'   |home_drives                      |integer   |
#'   |home_scoring_opportunities       |integer   |
#'   |home_points_per_opportunity      |numeric   |
#'   |home_plays                       |integer   |
#'   |home_line_yards                  |numeric   |
#'   |home_line_yards_per_rush         |numeric   |
#'   |home_second_level_yards          |integer   |
#'   |home_second_level_yards_per_rush |numeric   |
#'   |home_open_field_yards            |integer   |
#'   |home_open_field_yards_per_rush   |numeric   |
#'   |home_ppa_per_play                |numeric   |
#'   |home_total_ppa                   |numeric   |
#'   |home_passing_ppa                 |numeric   |
#'   |home_ppa_per_pass                |numeric   |
#'   |home_rushing_ppa                 |numeric   |
#'   |home_ppa_per_rush                |numeric   |
#'   |home_success_rate                |numeric   |
#'   |home_standard_down_success_rate  |numeric   |
#'   |home_passing_down_success_rate   |numeric   |
#'   |home_explosiveness               |numeric   |
#'   |away_line_scores_q1              |integer   |
#'   |away_line_scores_q2              |integer   |
#'   |away_line_scores_q3              |integer   |
#'   |away_line_scores_q4              |integer   |
#'   |away_points                      |integer   |
#'   |away_drives                      |integer   |
#'   |away_scoring_opportunities       |integer   |
#'   |away_points_per_opportunity      |numeric   |
#'   |away_plays                       |integer   |
#'   |away_line_yards                  |numeric   |
#'   |away_line_yards_per_rush         |numeric   |
#'   |away_second_level_yards          |integer   |
#'   |away_second_level_yards_per_rush |numeric   |
#'   |away_open_field_yards            |integer   |
#'   |away_open_field_yards_per_rush   |numeric   |
#'   |away_ppa_per_play                |numeric   |
#'   |away_total_ppa                   |numeric   |
#'   |away_passing_ppa                 |numeric   |
#'   |away_ppa_per_pass                |numeric   |
#'   |away_rushing_ppa                 |numeric   |
#'   |away_ppa_per_rush                |numeric   |
#'   |away_success_rate                |numeric   |
#'   |away_standard_down_success_rate  |numeric   |
#'   |away_passing_down_success_rate   |numeric   |
#'   |away_explosiveness               |numeric   |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @family CFBD PBP
#' @export
#' @examples
#' \dontrun{
#'   try(cfbd_live_plays(game_id=401520182))
#' }
cfbd_live_plays <- function(game_id) {

  # Validation ----
  validate_api_key()

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/live/plays"
  query_params <- list(
    "gameId" = game_id
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
        jsonlite::fromJSON(simplifyDataFrame = FALSE, simplifyVector = FALSE, simplifyMatrix = FALSE) %>%
        tibble::tibble(data = .data$.)

      game_id <- df %>%
        purrr::pluck("data", "id")
      current_period <- df %>%
        purrr::pluck("data", "period")
      current_clock <- df %>%
        purrr::pluck("data", "clock")
      current_possession <- df %>%
        purrr::pluck("data", "possession")
      current_down <- df %>%
        purrr::pluck("data", "down")
      current_distance <- df %>%
        purrr::pluck("data", "distance")
      current_yards_to_goal <- df %>%
        purrr::pluck("data", "yardsToGoal")

      game_status_df <- tibble::tibble(
        game_id = game_id,
        current_period = current_period,
        current_clock = current_clock,
        current_possession = current_possession,
        current_down = current_down,
        current_distance = current_distance,
        current_yards_to_goal = current_yards_to_goal
      )

      df_teams <- df$data %>%
        purrr::pluck("teams") %>%
        tibble::tibble(teams = .data$.) %>%
        dplyr::select("teams") %>%
        tidyr::unnest_wider("teams") %>%
        tidyr::unnest_wider("lineScores", names_sep = "_Q") %>%
        janitor::clean_names() %>%
        dplyr::rename(dplyr::any_of(c(
          "ppa_per_play" = "epa_per_play",
          "total_ppa" = "total_epa",
          "passing_ppa" = "passing_epa",
          "ppa_per_pass" = "epa_per_pass",
          "rushing_ppa" = "rushing_epa",
          "ppa_per_rush" = "epa_per_rush"
        )))

      home_team_df <- df_teams %>% dplyr::filter(.data$home_away =="home")
      home_team_df <- home_team_df %>% dplyr::select(-dplyr::any_of("home_away"))
      colnames(home_team_df) <- paste0("home_", colnames(home_team_df))
      away_team_df <- df_teams %>% dplyr::filter(.data$home_away =="away")
      away_team_df <- away_team_df %>% dplyr::select(-dplyr::any_of("home_away"))
      colnames(away_team_df) <- paste0("away_", colnames(away_team_df))

      teams_df <- dplyr::bind_cols(home_team_df, away_team_df)
      game_df <- dplyr::bind_cols(game_status_df, teams_df)

      df_drives <- df$data %>%
        purrr::pluck("drives") %>%
        tibble::tibble(drives = .data$.) %>%
        dplyr::select("drives") %>%
        tidyr::unnest_wider("drives") %>%
        janitor::clean_names() %>%
        dplyr::rename(dplyr::any_of(c(
          "drive_id" = "id",
          "drive_offense_id" = "offense_id",
          "drive_offense_team" = "offense",
          "drive_defense_id" = "defense_id",
          "drive_defense_team" = "defense",
          "drive_play_count" = "play_count",
          "drive_yards_gained" = "yards",
          "drive_start_period" = "start_period",
          "drive_start_clock" = "start_clock",
          "drive_start_yards_to_goal" = "start_yards_to_goal",
          "drive_end_period" = "end_period",
          "drive_end_clock" = "end_clock",
          "drive_end_yards_to_goal" = "end_yards_to_goal",
          "drive_duration" = "duration",
          "drive_scoring_opportunity" = "scoring_opportunity",
          "drive_result" = "result",
          "drive_points_gained" = "points_gained"
        )))

      df_plays <- df_drives %>%
        tidyr::unnest_longer("plays") %>%
        tidyr::unnest_wider("plays") %>%
        janitor::clean_names() %>%
        dplyr::rename(dplyr::any_of(c(
          "play_id" = "id",
          "offense_team_id" = "team_id",
          "offense_team" = "team",
          "ppa" = "epa"
        )))

      df_plays <- df_plays %>%
        dplyr::select(dplyr::any_of(c(
          "play_id",
          "home_score",
          "away_score",
          "period",
          "clock",
          "wall_clock",
          "offense_team_id",
          "offense_team",
          "down",
          "distance",
          "yards_to_goal",
          "yards_gained",
          "play_type_id",
          "play_type",
          "ppa",
          "garbage_time",
          "success",
          "rush_pash",
          "down_type",
          "play_text"
        )), tidyr::everything())

      df <- df_plays %>%
        dplyr::bind_cols(game_df)
      df <- df %>%
        dplyr::select(dplyr::any_of(c(
          "game_id",
          "home_team_id",
          "home_team",
          "away_team_id",
          "away_team",
          "play_id"
        )), tidyr::everything())

      df <- df %>%
        make_cfbfastR_data("Live play-by-play data from CollegeFootballData.com",Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no plays data available!"))
    },
    finally = {
    }
  )
  return(df)
}
