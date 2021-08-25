#' **Load cfbfastR play-by-play**
#' @name load_cfb_pbp
NULL
#' @title 
#' **Load cleaned play-by-play from the data repo**
#' @rdname load_cfb_pbp
#' @description helper that loads multiple seasons from the data repo either into memory
#' or writes it into a db using some forwarded arguments in the dots
#' @param seasons A vector of 4-digit years associated with given College Football seasons.
#' @param ... Additional arguments passed to an underlying function that writes
#' the season data into a database (used by [`update_cfb_db()`][update_cfb_db]).
#' @param qs Wheter to use the function [qs::qdeserialize()] for more efficient loading.
#' @export
load_cfb_pbp <- function(seasons, ..., qs = FALSE) {
  dots <- rlang::dots_list(...)
  
  if (all(c("dbConnection", "tablename") %in% names(dots))) in_db <- TRUE else in_db <- FALSE
  
  if (isTRUE(qs) && !is_installed("qs")) {
    cli::cli_abort("Package {.val qs} required for argument {.val qs = TRUE}. Please install it.")
  }
  
  most_recent <- most_recent_season()
  
  if (!all(seasons %in% 2014:most_recent)) {
    cli::cli_abort("Please pass valid seasons between 2014 and {most_recent}")
  }
  
  if (length(seasons) > 1 && is_sequential() && isFALSE(in_db)) {
    cli::cli_alert_info(c(
      "It is recommended to use parallel processing when trying to load multiple seasons.",
      "Please consider running {.code future::plan(\"multisession\")}!",
      "Will go on sequentially..."
    ))
  }
  
  
  p <- progressr::progressor(along = seasons)
  
  if (isFALSE(in_db)) {
    out <- furrr::future_map_dfr(seasons, cfb_single_season, p = p, qs = qs)
  }
  
  if (isTRUE(in_db)) {
    purrr::walk(seasons, cfb_single_season, p, ..., qs = qs)
    out <- NULL
  }
  
  return(out)
}

cfb_single_season <- function(season, p, dbConnection = NULL, tablename = NULL, qs = FALSE) {
  if (isTRUE(qs)) {
    
    .url <- glue::glue("https://github.com/saiemgilani/cfbfastR-data/blob/master/data/rds/pbp_players_pos_{season}.qs")
    pbp <- qs_from_url(.url)
    
  }
  if (isFALSE(qs)) {
    .url <- glue::glue("https://raw.githubusercontent.com/saiemgilani/cfbfastR-data/master/data/rds/pbp_players_pos_{season}.rds")
    con <- url(.url)
    pbp <- readRDS(con)
    close(con)
  }
  if (!is.null(dbConnection) && !is.null(tablename)) {
    DBI::dbWriteTable(dbConnection, tablename, pbp, append = TRUE)
    out <- NULL
  } else {
    out <- pbp
  }
  p(sprintf("season=%g", season))
  return(out)
}

# load games file
load_games <- function(){
  .url <- "https://raw.githubusercontent.com/saiemgilani/cfbfastR-data/master/data/games_in_data_repo.csv"
  con <- url(.url)
  dat <- utils::read.csv(con)
  # close(con)
  return (dat)
}

#' @name update_cfb_db
#' @aliases update_cfb_db cfb_db cfb database cfb_pbp_db
#' @title 
#' **Update or create a cfbfastR play-by-play database**
#' @description `update_cfb_db()` updates or creates a database with `cfbfastR`
#' play by play data of all completed games since 2014.
#'
#' @details This function creates and updates a data table with the name `tblname`
#' within a SQLite database (other drivers via `db_connection`) located in
#' `dbdir` and named `dbname`.
#' The data table combines all play by play data for every available game back
#' to the 2014 season and adds the most recent completed games as soon as they
#' are available for `cfbfastR`.
#'
#' The argument `force_rebuild` is of hybrid type. It can rebuild the play
#' by play data table either for the whole cfbfastR era (with `force_rebuild = TRUE`)
#' or just for specified seasons (e.g. `force_rebuild = c(2019, 2020)`).
#' Please note the following behavior:
#' \itemize{
#'  \item{`force_rebuild = TRUE`}{: The data table with the name `tblname`
#'   will be removed completely and rebuilt from scratch. This is helpful when
#'   new columns are added during the Off-Season.}
#'  \item{`force_rebuild = c(2019, 2020)`}{: The data table with the name `tblname`
#'  will be preserved and only rows from the 2019 and 2020 seasons will be
#'  deleted and re-added. This is intended to be used for ongoing seasons because
#'  ESPN's data provider can make changes to the underlying data during the week.}
#' }
#'
#' The parameter `db_connection` is intended for advanced users who want
#' to use other DBI drivers, such as MariaDB, Postgres or odbc. Please note that
#' the arguments `dbdir` and `dbname` are dropped in case a `db_connection`
#' is provided but the argument `tblname` will still be used to write the
#' data table into the database.
#'
#' @param dbdir Directory in which the database is or shall be located
#' @param dbname File name of an existing or desired SQLite database within `dbdir`
#' @param tblname The name of the play by play data table within the database
#' @param force_rebuild Hybrid parameter (logical or numeric) to rebuild parts
#' of or the complete play by play data table within the database (please see details for further information)
#' @param db_connection A `DBIConnection` object, as returned by
#' [DBI::dbConnect()] (please see details for further information)
#' @export
update_cfb_db <- function(dbdir = ".",
                          dbname = "cfb_pbp_db",
                          tblname = "cfbfastR_pbp",
                          force_rebuild = FALSE,
                          db_connection = NULL) {
  
  rule_header("Update cfbfastR Play-by-Play Database")
  
  if (!is_installed("DBI") | !is_installed("purrr") |
      (!is_installed("RSQLite") & is.null(db_connection))) {
    cli::cli_abort("{my_time()} | Packages {.val DBI}, {.val RSQLite} and {.val purrr} required for database communication. Please install them.")
  }
  
  if (any(force_rebuild == "NEW")) {
    cli::cli_abort("{my_time()} | The argument {.val 'force_rebuild = NEW'} is only for internal usage!")
  }
  
  if (!(is.logical(force_rebuild) | is.numeric(force_rebuild))) {
    cli::cli_abort("{my_time()} | The argument {.val 'force_rebuild'} has to be either logical or numeric!")
  }
  
  if (!dir.exists(dbdir) & is.null(db_connection)) {
    cli::cli_alert_danger("{my_time()} | Directory {.file {dbdir}} doesn't exist yet. Try creating...")
    dir.create(dbdir)
  }
  
  if (is.null(db_connection)) {
    connection <- DBI::dbConnect(RSQLite::SQLite(), glue::glue("{dbdir}/{dbname}"))
  } else {
    connection <- db_connection
  }
  
  # create db if it doesn't exist or user forces rebuild
  if (!DBI::dbExistsTable(connection, tblname)) {
    build_cfb_db(tblname, connection, rebuild = "NEW")
  } else if (DBI::dbExistsTable(connection, tblname) & all(force_rebuild != FALSE)) {
    build_cfb_db(tblname, connection, rebuild = force_rebuild)
  }
  
  # get completed games using Lee's file (thanks Lee!)
  user_message("Checking for missing completed games...", "todo")
  completed_games <- load_games() %>%
    # completed games since 2014, excluding the broken games
    dplyr::filter(.data$season >= 2014) %>%
    dplyr::arrange(.data$week) %>%
    dplyr::pull(.data$game_id)
  
  # function below
  missing <- get_missing_cfb_games(completed_games, connection, tblname)
  
  # rebuild db if number of missing games is too large
  if(length(missing) > 16) {# limit set to >16 to make sure this doesn't get triggered on gameday (e.g. week 17)
    # message("The number of missing games is so large that rebuilding the database is more efficient.")
    build_cfb_db(tblname, connection, show_message = FALSE, rebuild = as.numeric(unique(stringr::str_sub(missing, 1, 4))))
    missing <- get_missing_cfb_games(completed_games, connection, tblname)
  }
  
  # # if there's missing games, scrape and write to db
  # if (length(missing) > 0) {
  #   new_pbp <- build_cfbfastR_pbp(missing, rules = FALSE)
  #   
  #   if (nrow(new_pbp) == 0) {
  #     user_message("Raw data of new games are not yet ready. Please try again in about 10 minutes.", "oops")
  #   } else {
  #     user_message("Appending new data to database...", "todo")
  #     DBI::dbWriteTable(connection, tblname, new_pbp, append = TRUE)
  #   }
  # }
  
  message_completed("Database update completed", in_builder = TRUE)
  cli::cli_alert_info("{my_time()} | Path to your db: {.file {DBI::dbGetInfo(connection)$dbname}}")
  if (is.null(db_connection)) DBI::dbDisconnect(connection)
  rule_footer("DONE")
}
# this is a helper function to build cfbfastR database from Scratch
build_cfb_db <- function(tblname = "cfbfastR_pbp", db_conn, rebuild = FALSE, show_message = TRUE) {
  
  valid_seasons <- load_games() %>%
    dplyr::filter(.data$season >= 2014) %>%
    dplyr::group_by(.data$season) %>%
    dplyr::summarise() %>%
    dplyr::ungroup()
  
  if (all(rebuild == TRUE)) {
    cli::cli_ul("{my_time()} | Purging the complete data table {.val {tblname}} in your connected database...")
    DBI::dbRemoveTable(db_conn, tblname)
    seasons <- valid_seasons %>% dplyr::pull("season")
    cli::cli_ul("{my_time()} | Starting download of {length(seasons)} seasons between {min(seasons)} and {max(seasons)}...")
  } else if (is.numeric(rebuild) & all(rebuild %in% valid_seasons$season)) {
    string <- paste0(rebuild, collapse = ", ")
    if (show_message){cli::cli_ul("{my_time()} | Purging {string} season(s) from the data table {.val {tblname}} in your connected database...")}
    DBI::dbExecute(db_conn, glue::glue_sql("DELETE FROM {`tblname`} WHERE season IN ({vals*})", vals = rebuild, .con = db_conn))
    seasons <- valid_seasons %>% dplyr::filter(.data$season %in% rebuild) %>% dplyr::pull("season")
    cli::cli_ul("{my_time()} | Starting download of the {string} season(s)...")
  } else if (all(rebuild == "NEW")) {
    cli::cli_alert_info("{my_time()} | Can't find the data table {.val {tblname}} in your database. Will load the play by play data from scratch.")
    seasons <- valid_seasons %>% dplyr::pull("season")
    cli::cli_ul("{my_time()} | Starting download of {length(seasons)} seasons between {min(seasons)} and {max(seasons)}...")
  } else {
    seasons <- NULL
    cli::cli_alert_danger("{my_time()} | At least one invalid value passed to argument {.val force_rebuild}. Please try again with valid input.")
  }
  
  if (!is.null(seasons)) {
    # this function lives in R/utils.R
    load_cfb_pbp(seasons, dbConnection = db_conn, tablename = tblname, qs = FALSE)
  }
}

# this is a helper function to check a list of completed games
# against the games that exist in a database connection
get_missing_cfb_games <- function(completed_games, dbConnection, tablename) {
  db_ids <- dplyr::tbl(dbConnection, tablename) %>%
    dplyr::select("game_id") %>%
    dplyr::distinct() %>%
    dplyr::collect() %>%
    dplyr::pull("game_id")
  
  need_scrape <- completed_games[!completed_games %in% db_ids]
  
  cli::cli_alert_info("{my_time()} | You have {length(db_ids)} games and are missing {length(need_scrape)}.")
  return(need_scrape)
}
