#' @name cfbd_play
#' @title
#' **CFBD Plays Endpoint Overview**
#' @description College football plays data
#'
#' * `cfbd_plays()`: CFBD's college football play-by-play.
#' * `cfbd_play_stats_player()`: Gets player info associated by play.
#' * `cfbd_play_stats_types()`: Gets CFBD play stat types.
#' * `cfbd_play_types()`: Gets CFBD play types.
#'
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
#' @return [cfbd_plays()] - A data frame with 27 columns:
#'
#'    |col_name           |types     |description                                                                                |
#'    |:------------------|:---------|:------------------------------------------------------------------------------------------|
#'    |play_id            |character |CFBD play identifier (unique within a game when combined with game_id).                    |
#'    |offense            |character |Full name of the offense (team in possession) on the play.                                 |
#'    |offense_conference |character |Conference name of the offense (e.g. "SEC", "ACC").                                        |
#'    |defense            |character |Full name of the defense on the play.                                                      |
#'    |defense_conference |character |Conference name of the defense (e.g. "SEC", "ACC").                                        |
#'    |home               |character |Full home team name for the game.                                                          |
#'    |away               |character |Full away team name for the game.                                                          |
#'    |offense_score      |integer   |Offense's score after the play (points).                                                   |
#'    |defense_score      |integer   |Defense's score after the play (points).                                                   |
#'    |game_id            |integer   |CFBD game identifier the play belongs to.                                                  |
#'    |drive_id           |character |CFBD drive identifier the play belongs to.                                                 |
#'    |drive_number       |integer   |Sequential drive number within the game (1-indexed).                                       |
#'    |play_number        |integer   |Sequential play number within the game (1-indexed).                                        |
#'    |period             |integer   |Game period / quarter (1-4 regulation, 5+ overtime).                                       |
#'    |offense_timeouts   |integer   |Timeouts remaining for the offense at the end of the play.                                 |
#'    |defense_timeouts   |integer   |Timeouts remaining for the defense at the end of the play.                                 |
#'    |yard_line          |integer   |Field-position yard line at the start of the play (0-50 scale from the offense's side).    |
#'    |yards_to_goal      |integer   |Distance in yards from the offense's spot to the opponent's goal line (0-100).             |
#'    |down               |integer   |Down of the play (1-4).                                                                    |
#'    |distance           |integer   |Yards to gain for a first down (or to the goal line in goal-to-go situations).             |
#'    |scoring            |logical   |TRUE when the play results in a score (TD, FG, safety, two-point conversion).              |
#'    |yards_gained       |integer   |Net yards gained by the offense on the play.                                               |
#'    |play_type          |character |CFBD categorical label for the play type (see [cfbd_play_types()]).                        |
#'    |play_text          |character |Free-form text description of the play from the CFBD feed.                                 |
#'    |ppa                |character |Predicted Points Added (CFBD's CFB-EPA analogue) for the play.                             |
#'    |clock_minutes      |integer   |Minutes remaining on the game clock at the start of the play.                              |
#'    |clock_seconds      |integer   |Seconds remaining on the game clock at the start of the play.                              |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @family CFBD PBP
#' @export
#' @examples
#' \donttest{
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
  full_url <- httr::modify_url(base_url, query = query_params)

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
#' @param season_type (*String* default both): Season type - regular, postseason, both, allstar, spring_regular, spring_postseason
#' @return [cfbd_play_stats_player()] - A data frame with 66 variables:
#'
#'    |col_name                      |types     |description                                                                                |
#'    |:-----------------------------|:---------|:------------------------------------------------------------------------------------------|
#'    |play_id                       |character |CFBD play identifier the stat is attributed to.                                            |
#'    |game_id                       |integer   |CFBD game identifier the play belongs to.                                                  |
#'    |season                        |integer   |Four-digit season year (e.g. 2024).                                                        |
#'    |week                          |integer   |Season week number (1-15 regular season; 1 = postseason/bowl week).                        |
#'    |opponent                      |character |Full name of the opponent on the play.                                                     |
#'    |team_score                    |integer   |Offense team score at the time of the play.                                                |
#'    |opponent_score                |integer   |Defense / opponent team score at the time of the play.                                     |
#'    |drive_id                      |character |CFBD drive identifier the play belongs to.                                                 |
#'    |period                        |integer   |Game period / quarter of the play (1-4 regulation, 5+ overtime).                           |
#'    |yards_to_goal                 |integer   |Distance in yards from the offense's spot to the opponent's goal line (0-100).             |
#'    |down                          |integer   |Down of the play (1-4).                                                                    |
#'    |distance                      |integer   |Yards to gain for a first down (or to the goal line in goal-to-go situations).             |
#'    |reception_player_id           |character |CFBD athlete_id of the receiver credited with a reception.                                 |
#'    |reception_player              |character |Name of the receiver credited with a reception.                                            |
#'    |reception_yds                 |integer   |Reception yards gained on the play.                                                        |
#'    |completion_player_id          |character |CFBD athlete_id of the passer credited with a completion.                                  |
#'    |completion_player             |character |Name of the passer credited with a completion.                                             |
#'    |completion_yds                |integer   |Passing yards gained on the completion.                                                    |
#'    |rush_player_id                |character |CFBD athlete_id of the player credited with a rush attempt.                                |
#'    |rush_player                   |character |Name of the player credited with a rush attempt.                                           |
#'    |rush_yds                      |integer   |Rushing yards gained on the play.                                                          |
#'    |interception_player_id        |character |CFBD athlete_id of the defender credited with an interception.                             |
#'    |interception_player           |character |Name of the defender credited with an interception.                                        |
#'    |interception_stat             |integer   |Interception stat value reported by CFBD (typically 1 per INT).                            |
#'    |interception_thrown_player_id |character |CFBD athlete_id of the passer charged with the interception.                               |
#'    |interception_thrown_player    |character |Name of the passer charged with the interception.                                          |
#'    |interception_thrown_stat      |integer   |Interception-thrown stat value reported by CFBD (typically 1 per INT thrown).              |
#'    |touchdown_player_id           |character |CFBD athlete_id of the player credited with the touchdown.                                 |
#'    |touchdown_player              |character |Name of the player credited with the touchdown.                                            |
#'    |touchdown_stat                |integer   |Touchdown stat value reported by CFBD (typically 1 per TD scored).                         |
#'    |incompletion_player_id        |character |CFBD athlete_id of the targeted receiver on an incompletion.                               |
#'    |incompletion_player           |character |Name of the targeted receiver on an incompletion.                                          |
#'    |incompletion_stat             |integer   |Incompletion stat value reported by CFBD (typically 1 per incompletion).                   |
#'    |target_player_id              |character |CFBD athlete_id of the targeted receiver on a pass.                                        |
#'    |target_player                 |character |Name of the targeted receiver on a pass.                                                   |
#'    |target_stat                   |integer   |Target stat value reported by CFBD (typically 1 per target).                               |
#'    |fumble_recovered_player_id    |logical   |CFBD athlete_id of the player recovering the fumble.                                       |
#'    |fumble_recovered_player       |logical   |Name of the player recovering the fumble.                                                  |
#'    |fumble_recovered_stat         |logical   |Fumble-recovered stat value reported by CFBD (typically 1 per recovery).                   |
#'    |fumble_forced_player_id       |logical   |CFBD athlete_id of the defender credited with forcing the fumble.                          |
#'    |fumble_forced_player          |logical   |Name of the defender credited with forcing the fumble.                                     |
#'    |fumble_forced_stat            |logical   |Fumble-forced stat value reported by CFBD (typically 1 per forced fumble).                 |
#'    |fumble_player_id              |logical   |CFBD athlete_id of the player who fumbled.                                                 |
#'    |fumble_player                 |logical   |Name of the player who fumbled.                                                            |
#'    |fumble_stat                   |logical   |Fumble stat value reported by CFBD (typically 1 per fumble).                               |
#'    |sack_player_id                |character |Comma-separated CFBD athlete_id(s) of the sacking defender(s).                             |
#'    |sack_player                   |character |Comma-separated name(s) of the sacking defender(s).                                        |
#'    |sack_stat                     |integer   |Sack stat value reported by CFBD (sack credit can be split between defenders).             |
#'    |sack_taken_player_id          |character |CFBD athlete_id of the QB charged with taking the sack.                                    |
#'    |sack_taken_player             |character |Name of the QB charged with taking the sack.                                               |
#'    |sack_taken_stat               |integer   |Sack-taken stat value reported by CFBD (typically 1 per sack taken).                       |
#'    |pass_breakup_player_id        |logical   |CFBD athlete_id of the defender credited with the pass breakup (PBU).                      |
#'    |pass_breakup_player           |logical   |Name of the defender credited with the pass breakup (PBU).                                 |
#'    |pass_breakup_stat             |logical   |Pass breakup (PBU) stat value reported by CFBD (typically 1 per PBU).                      |
#'    |field_goal_attempt_player_id  |character |CFBD athlete_id of the kicker attempting the field goal.                                   |
#'    |field_goal_attempt_player     |character |Name of the kicker attempting the field goal.                                              |
#'    |field_goal_attempt_stat       |integer   |Field goal attempt distance in yards reported by CFBD.                                     |
#'    |field_goal_made_player_id     |character |CFBD athlete_id of the kicker on a made field goal.                                        |
#'    |field_goal_made_player        |character |Name of the kicker on a made field goal.                                                   |
#'    |field_goal_made_stat          |integer   |Made-field-goal distance in yards reported by CFBD.                                        |
#'    |field_goal_missed_player_id   |character |CFBD athlete_id of the kicker on a missed field goal.                                      |
#'    |field_goal_missed_player      |character |Name of the kicker on a missed field goal.                                                 |
#'    |field_goal_missed_stat        |integer   |Missed-field-goal distance in yards reported by CFBD.                                      |
#'    |field_goal_blocked_player_id  |character |CFBD athlete_id of the defender credited with blocking the field goal.                     |
#'    |field_goal_blocked_player     |character |Name of the defender credited with blocking the field goal.                                |
#'    |field_goal_blocked_stat       |integer   |Blocked-field-goal distance in yards reported by CFBD.                                     |
#'
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
#'   try(cfbd_play_stats_player(game_id = 401628414))
#'   try(cfbd_play_stats_player(year = 2025, week = 1))
#' }
cfbd_play_stats_player <- function(year = NULL,
                                   week = NULL,
                                   team = NULL,
                                   game_id = NULL,
                                   athlete_id = NULL,
                                   stat_type_id = NULL,
                                   season_type = "both") {

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
    "athleteId" = athlete_id,
    "statTypeId" = stat_type_id,
    "seasonType" = season_type
  )
  full_url <- httr::modify_url(base_url, query = query_params)

  clean_df <- data.frame()
  tryCatch(
    expr = {

      # Create the GET request and set response as res
      res <- get_req(full_url)
      check_status(res)

      # Get the content and return it as data.frame
      df <- res %>%
        httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON() %>%
        as.data.frame()

      cols <- c(
        "game_id", "season", "week", "team",
        "conference", "opponent", "team_score", "opponent_score",
        "drive_id", "play_id", "period", "clock_minutes","clock_seconds", "yards_to_goal", "down", "distance",
        "athlete_id", "stat",
        "reception", "completion", "rush", "interception", "interception_thrown",
        "touchdown", "incompletion", "target", "fumble_recovered", "fumble_forced",
        "fumble", "sack", "sack_taken", "pass_breakup",
        "field_goal_attempt", "field_goal_made", "field_goal_missed", "fg_attempt_blocked",
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
        "pass_breakup_player_id", "pass_breakup_player", "pass_breakup_stat",
        "field_goal_attempt_player_id", "field_goal_attempt_player", "field_goal_attempt_stat",
        "field_goal_made_player_id", "field_goal_made_player", "field_goal_made_stat",
        "field_goal_missed_player_id", "field_goal_missed_player", "field_goal_missed_stat",
        "field_goal_blocked_player_id", "field_goal_blocked_player", "field_goal_blocked_stat"

      )

      df_cols <- data.frame(matrix(NA, nrow = 0, ncol = 90))

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

      colnames(df) <- gsub(" ", "_", tolower(colnames(df)))

      clean_df <- df %>%
        dplyr::distinct() %>%
        tidyr::unnest_wider("clock", names_sep = "_") %>%
        tidyr::pivot_wider(
          names_from = "stat_type",
          values_from = "athlete_name"
        )

      colnames(clean_df) <- gsub(" ", "_", tolower(colnames(clean_df)))

      clean_df[cols[!(cols %in% colnames(clean_df))]] <- NA

      clean_df[clean_df == "NULL"] <- NA

      clean_df <- clean_df %>%
        dplyr::rename(dplyr::any_of(c(
          "field_goal_blocked" = "fg_attempt_blocked"
        ))) %>%
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
          pass_breakup_player_id = ifelse(!is.na(.data$pass_breakup), .data$athlete_id, NA),
          field_goal_attempt_player_id = ifelse(!is.na(.data$field_goal_attempt), .data$athlete_id, NA),
          field_goal_attempt_player = ifelse(!is.na(.data$field_goal_attempt), .data$field_goal_attempt, NA),
          field_goal_attempt_stat = ifelse(!is.na(.data$field_goal_attempt), .data$stat, NA),
          field_goal_made_player_id = ifelse(!is.na(.data$field_goal_made), .data$athlete_id, NA),
          field_goal_made_player = ifelse(!is.na(.data$field_goal_made), .data$field_goal_made, NA),
          field_goal_made_stat = ifelse(!is.na(.data$field_goal_made), .data$stat, NA),
          field_goal_blocked_player_id = ifelse(!is.na(.data$field_goal_blocked), .data$athlete_id, NA),
          field_goal_blocked_player = ifelse(!is.na(.data$field_goal_blocked), .data$field_goal_blocked, NA),
          field_goal_blocked_stat = ifelse(!is.na(.data$field_goal_blocked), .data$stat, NA),
          field_goal_missed_player_id = ifelse(!is.na(.data$field_goal_missed), .data$athlete_id, NA),
          field_goal_missed_player = ifelse(!is.na(.data$field_goal_missed), .data$field_goal_missed, NA),
          field_goal_missed_stat = ifelse(!is.na(.data$field_goal_missed), .data$stat, NA)

        ) %>%
        dplyr::select(dplyr::any_of(c(
          "game_id",
          "season",
          "week",
          "team",
          "conference",
          "opponent",
          "team_score",
          "opponent_score",
          "drive_id",
          "play_id",
          "period",
          "clock_minutes",
          "clock_seconds",
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
          "pass_breakup_stat",
          "field_goal_attempt_player_id",
          "field_goal_attempt_player",
          "field_goal_attempt_stat",
          "field_goal_made_player_id",
          "field_goal_made_player",
          "field_goal_made_stat",
          "field_goal_missed_player_id",
          "field_goal_missed_player",
          "field_goal_missed_stat",
          "field_goal_blocked_player_id",
          "field_goal_blocked_player",
          "field_goal_blocked_stat"
        )))

      clean_sack_df <- clean_df %>%
        dplyr::group_by(.data$play_id) %>%
        dplyr::summarize(
          sack_player = paste(unique(na.omit(.data$sack_player)), collapse = ", "),
          sack_player_id = paste(unique(na.omit(.data$sack_player_id)), collapse = ", "),
          .groups = "drop"
        )


      clean_df <- clean_df %>%
        dplyr::select(-"sack_player", -"sack_player_id") %>%
        dplyr::left_join(clean_sack_df, by = "play_id") %>%
        dplyr::group_by(.data$play_id) %>%
        dplyr::summarise_all(coalesce_by_column) %>%
        dplyr::ungroup() %>%
        dplyr::select(dplyr::any_of(c(
          "game_id",
          "season",
          "week",
          "team",
          "conference",
          "opponent",
          "team_score",
          "opponent_score",
          "drive_id",
          "play_id",
          "period",
          "clock_minutes",
          "clock_seconds",
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
          "pass_breakup_stat",
          "field_goal_attempt_player_id",
          "field_goal_attempt_player",
          "field_goal_attempt_stat",
          "field_goal_made_player_id",
          "field_goal_made_player",
          "field_goal_made_stat",
          "field_goal_missed_player_id",
          "field_goal_missed_player",
          "field_goal_missed_stat",
          "field_goal_blocked_player_id",
          "field_goal_blocked_player",
          "field_goal_blocked_stat"
        )))



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
#'
#'    |col_name          |types     |description                                                                          |
#'    |:-----------------|:---------|:------------------------------------------------------------------------------------|
#'    |play_stat_type_id |integer   |CFBD play stat type identifier (used as a filter in [cfbd_play_stats_player()]).     |
#'    |name              |character |Human-readable name of the play stat type (e.g. "Reception", "Sack", "Touchdown").   |
#'
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
#'
#'    |col_name     |types     |description                                                                          |
#'    |:------------|:---------|:------------------------------------------------------------------------------------|
#'    |play_type_id |integer   |CFBD play type identifier (matches `play_type` IDs in [cfbd_plays()]).               |
#'    |text         |character |Human-readable play type description (e.g. "Rush", "Pass Reception", "Field Goal").  |
#'    |abbreviation |character |Short play type abbreviation used as the `play_type` filter argument in API calls.   |
#'
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
#'  |col_name                         |types     |description                                                                            |
#'  |:--------------------------------|:---------|:--------------------------------------------------------------------------------------|
#'  |game_id                          |integer   |CFBD game id for the live game.                                                        |
#'  |home_team_id                     |integer   |CFBD team id of the home team.                                                         |
#'  |home_team                        |character |Name of the home team.                                                                 |
#'  |away_team_id                     |integer   |CFBD team id of the away team.                                                         |
#'  |away_team                        |character |Name of the away team.                                                                 |
#'  |play_id                          |character |Unique CFBD play id for this play.                                                     |
#'  |home_score                       |integer   |Home team score at the conclusion of the play.                                         |
#'  |away_score                       |integer   |Away team score at the conclusion of the play.                                         |
#'  |period                           |integer   |Quarter (1-4, or overtime period) in which the play occurred.                          |
#'  |clock                            |character |Game clock at the snap, formatted as "MM:SS".                                          |
#'  |wall_clock                       |character |Real-world UTC timestamp when the play was recorded.                                   |
#'  |offense_team_id                  |integer   |CFBD team id of the team on offense for this play.                                     |
#'  |offense_team                     |character |Name of the team on offense for this play.                                             |
#'  |down                             |integer   |Down (1-4) at the start of the play.                                                   |
#'  |distance                         |integer   |Yards to gain for a first down at the snap.                                            |
#'  |yards_to_goal                    |integer   |Yards from the offense to the opponent's end zone at the snap (0-100).                 |
#'  |yards_gained                     |integer   |Net yards gained by the offense on the play.                                           |
#'  |play_type_id                     |integer   |CFBD play_type identifier; see `cfbd_play_types()`.                                    |
#'  |play_type                        |character |Play type label (e.g. "Rush", "Pass Reception", "Punt").                               |
#'  |ppa                              |numeric   |Predicted Points Added (CFBD PPA/EPA) value for the play.                              |
#'  |garbage_time                     |logical   |TRUE if the play occurred during garbage time.                                         |
#'  |success                          |logical   |TRUE if the play met CFBD success-rate criteria.                                       |
#'  |rush_pass                        |character |Classification of the play as "Rush" or "Pass".                                        |
#'  |down_type                        |character |Down/distance classification (e.g. "standard" vs "passing" down).                      |
#'  |play_text                        |character |Free-text narrative description of the play.                                           |
#'  |drive_id                         |character |CFBD drive identifier for the drive containing this play.                              |
#'  |drive_offense_id                 |integer   |CFBD team id of the offense on the drive.                                              |
#'  |drive_offense_team               |character |Name of the offensive team on the drive.                                               |
#'  |drive_defense_id                 |integer   |CFBD team id of the defense on the drive.                                              |
#'  |drive_defense_team               |character |Name of the defensive team on the drive.                                               |
#'  |drive_play_count                 |integer   |Number of plays in the drive.                                                          |
#'  |drive_yards_gained               |integer   |Total net yards gained on the drive.                                                   |
#'  |drive_start_period               |integer   |Quarter in which the drive started.                                                    |
#'  |drive_start_clock                |character |Game clock ("MM:SS") when the drive started.                                           |
#'  |drive_start_yards_to_goal        |integer   |Yards to opponent's end zone at drive start (0-100).                                   |
#'  |drive_end_period                 |integer   |Quarter in which the drive ended.                                                      |
#'  |drive_end_clock                  |character |Game clock ("MM:SS") when the drive ended.                                             |
#'  |drive_end_yards_to_goal          |integer   |Yards to opponent's end zone at drive end (0-100).                                     |
#'  |drive_duration                   |character |Drive duration measured in elapsed game clock.                                         |
#'  |drive_scoring_opportunity        |logical   |TRUE if the drive reached scoring territory.                                           |
#'  |drive_result                     |character |Outcome of the drive (e.g. "TD", "FG", "PUNT", "INT").                                 |
#'  |drive_points_gained              |integer   |Points scored by the offense on the drive.                                             |
#'  |current_clock                    |character |Current game clock at the time of the live API snapshot.                               |
#'  |current_possession               |character |Team currently in possession at the snapshot time.                                     |
#'  |home_line_scores_q1              |integer   |Home team points scored in the first quarter.                                          |
#'  |home_line_scores_q2              |integer   |Home team points scored in the second quarter.                                         |
#'  |home_line_scores_q3              |integer   |Home team points scored in the third quarter.                                          |
#'  |home_line_scores_q4              |integer   |Home team points scored in the fourth quarter.                                         |
#'  |home_points                      |integer   |Home team total points scored in the game so far.                                      |
#'  |home_drives                      |integer   |Number of offensive drives by the home team.                                           |
#'  |home_scoring_opportunities       |integer   |Number of home drives that reached scoring territory.                                  |
#'  |home_points_per_opportunity      |numeric   |Home points scored per scoring opportunity.                                            |
#'  |home_average_start_yard_line     |numeric   |Average starting field position (yards from own goal) for home drives.                 |
#'  |home_plays                       |integer   |Total offensive plays run by the home team.                                            |
#'  |home_line_yards                  |numeric   |Total offensive line yards credited to the home team's rushing attack.                 |
#'  |home_line_yards_per_rush         |numeric   |Home offensive line yards per rush attempt.                                            |
#'  |home_second_level_yards          |integer   |Home rushing yards gained at the second level (5-10 yards past the line).              |
#'  |home_second_level_yards_per_rush |numeric   |Home second-level rushing yards per rush attempt.                                      |
#'  |home_open_field_yards            |integer   |Home rushing yards gained in the open field (10+ yards past the line).                 |
#'  |home_open_field_yards_per_rush   |numeric   |Home open-field rushing yards per rush attempt.                                        |
#'  |home_ppa_per_play                |numeric   |Average PPA per play for the home team (CFBD renames `epa_per_play`).                  |
#'  |home_total_ppa                   |numeric   |Cumulative PPA for the home team across all plays.                                     |
#'  |home_passing_ppa                 |numeric   |Cumulative passing PPA for the home team.                                              |
#'  |home_ppa_per_pass                |numeric   |Average PPA per pass attempt for the home team.                                        |
#'  |home_rushing_ppa                 |numeric   |Cumulative rushing PPA for the home team.                                              |
#'  |home_ppa_per_rush                |numeric   |Average PPA per rush attempt for the home team.                                        |
#'  |home_success_rate                |numeric   |Home team overall success rate (0-1).                                                  |
#'  |home_standard_down_success_rate  |numeric   |Home success rate on standard downs (0-1).                                             |
#'  |home_passing_down_success_rate   |numeric   |Home success rate on passing downs (0-1).                                              |
#'  |home_explosiveness               |numeric   |Home explosiveness metric (average PPA on successful plays).                           |
#'  |home_deserve_to_win              |numeric   |Home team "deserve-to-win" probability metric (0-1).                                   |
#'  |away_line_scores_q1              |integer   |Away team points scored in the first quarter.                                          |
#'  |away_line_scores_q2              |integer   |Away team points scored in the second quarter.                                         |
#'  |away_line_scores_q3              |integer   |Away team points scored in the third quarter.                                          |
#'  |away_line_scores_q4              |integer   |Away team points scored in the fourth quarter.                                         |
#'  |away_points                      |integer   |Away team total points scored in the game so far.                                      |
#'  |away_drives                      |integer   |Number of offensive drives by the away team.                                           |
#'  |away_scoring_opportunities       |integer   |Number of away drives that reached scoring territory.                                  |
#'  |away_points_per_opportunity      |numeric   |Away points scored per scoring opportunity.                                            |
#'  |away_average_start_yard_line     |numeric   |Average starting field position (yards from own goal) for away drives.                 |
#'  |away_plays                       |integer   |Total offensive plays run by the away team.                                            |
#'  |away_line_yards                  |numeric   |Total offensive line yards credited to the away team's rushing attack.                 |
#'  |away_line_yards_per_rush         |numeric   |Away offensive line yards per rush attempt.                                            |
#'  |away_second_level_yards          |integer   |Away rushing yards gained at the second level (5-10 yards past the line).              |
#'  |away_second_level_yards_per_rush |numeric   |Away second-level rushing yards per rush attempt.                                      |
#'  |away_open_field_yards            |integer   |Away rushing yards gained in the open field (10+ yards past the line).                 |
#'  |away_open_field_yards_per_rush   |numeric   |Away open-field rushing yards per rush attempt.                                        |
#'  |away_ppa_per_play                |numeric   |Average PPA per play for the away team (CFBD renames `epa_per_play`).                  |
#'  |away_total_ppa                   |numeric   |Cumulative PPA for the away team across all plays.                                     |
#'  |away_passing_ppa                 |numeric   |Cumulative passing PPA for the away team.                                              |
#'  |away_ppa_per_pass                |numeric   |Average PPA per pass attempt for the away team.                                        |
#'  |away_rushing_ppa                 |numeric   |Cumulative rushing PPA for the away team.                                              |
#'  |away_ppa_per_rush                |numeric   |Average PPA per rush attempt for the away team.                                        |
#'  |away_success_rate                |numeric   |Away team overall success rate (0-1).                                                  |
#'  |away_standard_down_success_rate  |numeric   |Away success rate on standard downs (0-1).                                             |
#'  |away_passing_down_success_rate   |numeric   |Away success rate on passing downs (0-1).                                              |
#'  |away_explosiveness               |numeric   |Away explosiveness metric (average PPA on successful plays).                           |
#'  |away_deserve_to_win              |numeric   |Away team "deserve-to-win" probability metric (0-1).                                   |
#'
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom cli cli_abort
#' @importFrom glue glue
#' @family CFBD PBP
#' @export
#' @examples
#' \donttest{
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
  full_url <- httr::modify_url(base_url, query = query_params)

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

      home_team_df <- df_teams %>% dplyr::filter(.data$home_away == "home")
      home_team_df <- home_team_df %>% dplyr::select(-dplyr::any_of("home_away"))
      colnames(home_team_df) <- paste0("home_", colnames(home_team_df))
      away_team_df <- df_teams %>% dplyr::filter(.data$home_away == "away")
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
          "rush_pass",
          "down_type",
          "play_text"
        )), dplyr::everything())

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
        )), dplyr::everything())

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
