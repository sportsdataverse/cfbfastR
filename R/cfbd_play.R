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
#' @param season_type Select Season Type (regular, postseason, both)
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
#'   \item{`clock.minutes`: integer.}{Minutes left on the clock.}
#'   \item{`clock.seconds`: integer.}{Seconds left on the clock.}
#' }
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom utils URLencode
#' @importFrom cli cli_abort
#' @importFrom glue glue
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
  # Check if year is numeric
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
  if (!(season_type %in% c("postseason", "regular", "both"))) {
    # Check if season_type is appropriate, if not NULL
    cli::cli_abort("Enter valid season_type (String): regular, postseason, or both")
  }
  if (!is.null(division)) {
    # # Check division parameter
    division <- utils::URLencode(division, reserved = TRUE)
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
    "&seasonType=", season_type,
    "&playType=", play_type,
    "&classification=", division
  )

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- httr::RETRY(
        "GET", full_url,
        httr::add_headers(Authorization = paste("Bearer", cfbd_key()))
      )

      # Check the result
      check_status(res)

      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE) %>%
        dplyr::rename("play_id" = "id")


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
#' @param season_type (*String* default regular): Select Season Type: regular, postseason, or both
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
#' @importFrom utils URLencode
#' @importFrom cli cli_abort
#' @import dplyr
#' @import tidyr
#' @import purrr
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

  # Check if year is numeric
  if(!is.null(year) && !is.numeric(year) && nchar(year) != 4){
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
  if (!is.null(game_id) && !is.numeric(game_id)) {
    # Check if game_id is numeric, if not NULL
    cli::cli_abort("Enter valid game_id (numeric value)")
  }

  if (!is.null(athlete_id) && !is.numeric(athlete_id)) {
    # Check if athlete_id is numeric, if not NULL
    cli::cli_abort("Enter valid athlete_id value (Integer)\nCan be found using the `cfbd_player_info()` function")
  }
  if (!is.null(stat_type_id)&&!is.numeric(stat_type_id)) {
    # Check if stat_type_id is numeric, if not NULL
    cli::cli_abort("Enter valid stat_type_id value (Integer)\nCan be found using the `cfbd_play_stat_types()` function")
  }
  if (!(season_type %in% c("postseason", "regular","both"))) {
    # Check if season_type is appropriate, if not NULL
    cli::cli_abort("Enter valid season_type (String): regular, postseason, or both")
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

  clean_df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- httr::RETRY(
        "GET", full_url,
        httr::add_headers(Authorization = paste("Bearer", cfbd_key()))
      )

      # Check the result
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
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_play_stats_types())
#' }
cfbd_play_stats_types <- function() {
  full_url <- "https://api.collegefootballdata.com/play/stat/types"

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)

  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- httr::RETRY(
        "GET", full_url,
        httr::add_headers(Authorization = paste("Bearer", cfbd_key()))
      )

      # Check the result
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
#' @importFrom utils URLencode
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_play_types())
#' }
cfbd_play_types <- function() {
  full_url <- "https://api.collegefootballdata.com/play/types"

  # Check for CFBD API key
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)


  df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- httr::RETRY(
        "GET", full_url,
        httr::add_headers(Authorization = paste("Bearer", cfbd_key()))
      )

      # Check the result
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
