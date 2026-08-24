# Release-dataset loaders -- thin wrappers around rds_from_url() /
# parquet_from_url() following the wehoop load_ncaa_wbb.R shape. Backed by
# the sportsdataverse-data release tags produced by the cfbfastR-cfb-data /
# cfbfastR-cfb-raw pipelines. GENERATED once from sdv-py loader schemas
# (tools/codegen/schemas/loader_schemas.yaml) on 2026-08-24; maintained by
# hand from here on.

#' **Load NCAA men's football play-by-play (stats.ncaa.org) from the SportsDataverse data repo**
#' @name load_ncaa_mfb_pbp
NULL
#' @title
#' **Load NCAA men's football play-by-play (stats.ncaa.org) from the SportsDataverse data repo**
#' @rdname load_ncaa_mfb_pbp
#' @author Saiem Gilani
#' @description
#'   Loads season-level NCAA men's football play-by-play parsed from
#'   stats.ncaa.org by the sdv-py cfb_ncaa_pbp parser. Covers FCS and lower
#'   divisions that ESPN's feed misses; one row per play with drive and
#'   participant context. Published to the `ncaa_mfb_pbp` release tag on the
#'   sportsdataverse-data repo.
#'
#'   For the same plays reshaped onto cfbfastR pbp column conventions (for
#'   binding with [load_cfb_pbp()] / [load_espn_cfb_pbp()] output), use
#'   [load_ncaa_mfb_pbp_cfbfastr()].
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2013 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2013)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name         |types     |description |
#'    |-----------------|----------|:-----------|
#'    |contest_id       |character | |
#'    |drive_number     |integer   | |
#'    |play_number      |integer   | |
#'    |offense          |character | |
#'    |drive_result     |character | |
#'    |drive_scored     |logical   | |
#'    |down             |integer   | |
#'    |distance         |integer   | |
#'    |yard_line        |character | |
#'    |yard_line_side   |character | |
#'    |yard_line_number |integer   | |
#'    |play_type        |character | |
#'    |clock            |character | |
#'    |yards_gained     |integer   | |
#'    |formation        |character | |
#'    |passer           |character | |
#'    |rusher           |character | |
#'    |receiver         |character | |
#'    |kicker           |character | |
#'    |punter           |character | |
#'    |returner         |character | |
#'    |run_direction    |character | |
#'    |qb_scramble      |logical   | |
#'    |pass_complete    |logical   | |
#'    |pass_depth       |character | |
#'    |pass_direction   |character | |
#'    |tackler_1        |character | |
#'    |tackler_2        |character | |
#'    |kick_yards       |integer   | |
#'    |return_yards     |integer   | |
#'    |punt_yards       |integer   | |
#'    |fg_distance      |integer   | |
#'    |fg_made          |logical   | |
#'    |is_first_down    |logical   | |
#'    |is_touchdown     |logical   | |
#'    |is_safety        |logical   | |
#'    |is_fumble        |logical   | |
#'    |is_turnover      |logical   | |
#'    |turnover_type    |character | |
#'    |out_of_bounds    |logical   | |
#'    |no_play          |logical   | |
#'    |fair_catch       |logical   | |
#'    |penalty_flag     |logical   | |
#'    |penalty_team     |character | |
#'    |penalty_type     |character | |
#'    |penalty_player   |character | |
#'    |penalty_yards    |integer   | |
#'    |end_yard_line    |character | |
#'    |play_text        |character | |
#'    |espn_game_id     |character | |
#'    |season           |integer   | |
#'
#' @examples
#' \donttest{
#'   try(load_ncaa_mfb_pbp(2013))
#' }
#' @export
load_ncaa_mfb_pbp <- function(seasons = most_recent_cfb_season(), ...,
                              dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2013:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2013),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "ncaa_mfb_pbp/ncaa_mfb_pbp_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("NCAA men's football play-by-play (stats.ncaa.org) from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load NCAA men's football play-by-play, cfbfastR-shaped from the SportsDataverse data repo**
#' @name load_ncaa_mfb_pbp_cfbfastr
NULL
#' @title
#' **Load NCAA men's football play-by-play, cfbfastR-shaped from the SportsDataverse data repo**
#' @rdname load_ncaa_mfb_pbp_cfbfastr
#' @author Saiem Gilani
#' @description
#'   Loads the cfbfastR-schema-shaped variant of the stats.ncaa.org men's
#'   football play-by-play -- the same plays as `load_ncaa_mfb_pbp()` reshaped
#'   onto cfbfastR pbp column conventions for cross-source binds. Published to
#'   the `ncaa_mfb_pbp_cfbfastr` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2013 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2013)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name                     |types     |description |
#'    |-----------------------------|----------|:-----------|
#'    |game_id                      |integer   | |
#'    |id_play                      |integer   | |
#'    |drive_id                     |integer   | |
#'    |game_play_number             |integer   | |
#'    |half_play_number             |integer   | |
#'    |drive_play_number            |integer   | |
#'    |drive_number                 |integer   | |
#'    |season                       |integer   | |
#'    |year                         |integer   | |
#'    |week                         |integer   | |
#'    |period                       |integer   | |
#'    |half                         |integer   | |
#'    |clock.minutes                |integer   | |
#'    |clock.seconds                |integer   | |
#'    |TimeSecsRem                  |integer   | |
#'    |Under_two                    |logical   | |
#'    |pos_team                     |character | |
#'    |def_pos_team                 |character | |
#'    |offense_play                 |character | |
#'    |defense_play                 |character | |
#'    |home                         |character | |
#'    |away                         |character | |
#'    |pos_team_score               |integer   | |
#'    |def_pos_team_score           |integer   | |
#'    |offense_score                |integer   | |
#'    |defense_score                |integer   | |
#'    |pos_score_diff               |integer   | |
#'    |score_pts                    |integer   | |
#'    |scoring_play                 |logical   | |
#'    |scoring                      |logical   | |
#'    |down                         |integer   | |
#'    |distance                     |integer   | |
#'    |yard_line                    |character | |
#'    |yards_to_goal                |integer   | |
#'    |yards_to_goal_end            |integer   | |
#'    |Goal_To_Go                   |logical   | |
#'    |log_ydstogo                  |double    | |
#'    |yards_gained                 |integer   | |
#'    |play_type                    |character | |
#'    |orig_play_type               |character | |
#'    |play_text                    |character | |
#'    |rush                         |logical   | |
#'    |rush_td                      |logical   | |
#'    |pass                         |logical   | |
#'    |pass_td                      |logical   | |
#'    |pass_attempt                 |logical   | |
#'    |completion                   |logical   | |
#'    |target                       |logical   | |
#'    |sack                         |logical   | |
#'    |sack_vec                     |logical   | |
#'    |int                          |logical   | |
#'    |int_td                       |logical   | |
#'    |turnover_vec                 |logical   | |
#'    |downs_turnover               |logical   | |
#'    |touchdown                    |logical   | |
#'    |td_play                      |logical   | |
#'    |safety                       |logical   | |
#'    |fumble_vec                   |logical   | |
#'    |punt                         |logical   | |
#'    |punt_play                    |logical   | |
#'    |kickoff_play                 |logical   | |
#'    |kick_play                    |logical   | |
#'    |fg_inds                      |logical   | |
#'    |fg_made                      |logical   | |
#'    |punt_blocked                 |logical   | |
#'    |punt_fair_catch              |logical   | |
#'    |firstD_by_yards              |logical   | |
#'    |firstD_by_penalty            |logical   | |
#'    |penalty_flag                 |logical   | |
#'    |penalty_no_play              |logical   | |
#'    |penalty_declined             |logical   | |
#'    |penalty_offset               |logical   | |
#'    |penalty_text                 |character | |
#'    |yds_penalty                  |integer   | |
#'    |rusher_player_name           |character | |
#'    |passer_player_name           |character | |
#'    |receiver_player_name         |character | |
#'    |interception_player_name     |character | |
#'    |punter_player_name           |character | |
#'    |punt_returner_player_name    |character | |
#'    |fg_kicker_player_name        |character | |
#'    |kickoff_player_name          |character | |
#'    |kickoff_returner_player_name |character | |
#'    |yds_rushed                   |integer   | |
#'    |yds_receiving                |integer   | |
#'    |yds_sacked                   |integer   | |
#'    |yds_punted                   |integer   | |
#'    |yds_punt_return              |integer   | |
#'    |yds_kickoff                  |integer   | |
#'    |yds_kickoff_return           |integer   | |
#'    |yds_int_return               |integer   | |
#'    |yds_fg                       |integer   | |
#'    |drive_result                 |character | |
#'    |drive_scoring                |logical   | |
#'    |ot_synthesized               |logical   | |
#'    |lag_pos_team                 |character | |
#'    |lead_pos_team                |character | |
#'    |lag_play_type                |character | |
#'    |lead_play_type               |character | |
#'    |lag_play_text                |character | |
#'    |lead_play_text               |character | |
#'    |change_of_pos_team           |logical   | |
#'    |play_after_turnover          |logical   | |
#'    |n_plays_in_game              |integer   | |
#'    |espn_game_id                 |character | |
#'
#' @examples
#' \donttest{
#'   try(load_ncaa_mfb_pbp_cfbfastr(2013))
#' }
#' @export
load_ncaa_mfb_pbp_cfbfastr <- function(seasons = most_recent_cfb_season(), ...,
                                       dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2013:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2013),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "ncaa_mfb_pbp_cfbfastr/ncaa_mfb_pbp_cfbfastr_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("NCAA men's football play-by-play, cfbfastR-shaped from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load NCAA men's football drives (stats.ncaa.org) from the SportsDataverse data repo**
#' @name load_ncaa_mfb_drives
NULL
#' @title
#' **Load NCAA men's football drives (stats.ncaa.org) from the SportsDataverse data repo**
#' @rdname load_ncaa_mfb_drives
#' @author Saiem Gilani
#' @description
#'   Loads season-level NCAA men's football drive summaries parsed from
#'   stats.ncaa.org; one row per drive. Published to the `ncaa_mfb_drives`
#'   release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2013 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2013)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name        |types     |description |
#'    |----------------|----------|:-----------|
#'    |contest_id      |character | |
#'    |drive_number    |integer   | |
#'    |quarter         |integer   | |
#'    |period          |integer   | |
#'    |team            |character | |
#'    |start_period    |integer   | |
#'    |start_how       |character | |
#'    |start_clock     |character | |
#'    |start_yard_line |character | |
#'    |end_period      |integer   | |
#'    |end_how         |character | |
#'    |end_clock       |character | |
#'    |end_yard_line   |character | |
#'    |n_plays         |integer   | |
#'    |yards           |integer   | |
#'    |espn_game_id    |character | |
#'    |season          |integer   | |
#'
#' @examples
#' \donttest{
#'   try(load_ncaa_mfb_drives(2013))
#' }
#' @export
load_ncaa_mfb_drives <- function(seasons = most_recent_cfb_season(), ...,
                                 dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2013:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2013),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "ncaa_mfb_drives/ncaa_mfb_drives_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("NCAA men's football drives (stats.ncaa.org) from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load NCAA men's football linescores (stats.ncaa.org) from the SportsDataverse data repo**
#' @name load_ncaa_mfb_linescore
NULL
#' @title
#' **Load NCAA men's football linescores (stats.ncaa.org) from the SportsDataverse data repo**
#' @rdname load_ncaa_mfb_linescore
#' @author Saiem Gilani
#' @description
#'   Loads season-level NCAA men's football period linescores parsed from
#'   stats.ncaa.org; one row per team-period. Published to the
#'   `ncaa_mfb_linescore` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2013 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2013)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name     |types     |description |
#'    |-------------|----------|:-----------|
#'    |contest_id   |character | |
#'    |team         |character | |
#'    |home_away    |character | |
#'    |period       |character | |
#'    |points       |integer   | |
#'    |final        |integer   | |
#'    |game_date    |character | |
#'    |venue        |character | |
#'    |attendance   |integer   | |
#'    |espn_game_id |character | |
#'    |season       |integer   | |
#'
#' @examples
#' \donttest{
#'   try(load_ncaa_mfb_linescore(2013))
#' }
#' @export
load_ncaa_mfb_linescore <- function(seasons = most_recent_cfb_season(), ...,
                                    dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2013:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2013),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "ncaa_mfb_linescore/ncaa_mfb_linescore_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("NCAA men's football linescores (stats.ncaa.org) from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load NCAA men's football officials (stats.ncaa.org) from the SportsDataverse data repo**
#' @name load_ncaa_mfb_officials
NULL
#' @title
#' **Load NCAA men's football officials (stats.ncaa.org) from the SportsDataverse data repo**
#' @rdname load_ncaa_mfb_officials
#' @author Saiem Gilani
#' @description
#'   Loads season-level NCAA men's football game officials parsed from
#'   stats.ncaa.org; one row per game-official. Published to the
#'   `ncaa_mfb_officials` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2013 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2013)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name     |types     |description |
#'    |-------------|----------|:-----------|
#'    |contest_id   |character | |
#'    |role         |character | |
#'    |official     |character | |
#'    |espn_game_id |character | |
#'    |season       |integer   | |
#'
#' @examples
#' \donttest{
#'   try(load_ncaa_mfb_officials(2013))
#' }
#' @export
load_ncaa_mfb_officials <- function(seasons = most_recent_cfb_season(), ...,
                                    dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2013:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2013),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "ncaa_mfb_officials/ncaa_mfb_officials_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("NCAA men's football officials (stats.ncaa.org) from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load NCAA men's football player stats (stats.ncaa.org) from the SportsDataverse data repo**
#' @name load_ncaa_mfb_player_stats
NULL
#' @title
#' **Load NCAA men's football player stats (stats.ncaa.org) from the SportsDataverse data repo**
#' @rdname load_ncaa_mfb_player_stats
#' @author Saiem Gilani
#' @description
#'   Loads season-level NCAA men's football player box statistics parsed from
#'   stats.ncaa.org; one row per player-game-category. Published to the
#'   `ncaa_mfb_player_stats` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2013 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2013)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name            |types     |description |
#'    |--------------------|----------|:-----------|
#'    |contest_id          |character | |
#'    |team_id             |character | |
#'    |number              |character | |
#'    |name                |character | |
#'    |position            |character | |
#'    |rush_attempts       |character | |
#'    |rush_yds_gained     |character | |
#'    |rush_yds_lost       |character | |
#'    |yds_rush            |character | |
#'    |rush_tds            |character | |
#'    |rush_long           |character | |
#'    |category            |character | |
#'    |espn_game_id        |character | |
#'    |pass_attempts       |character | |
#'    |completions         |character | |
#'    |pass_yards          |character | |
#'    |interceptions       |character | |
#'    |pass_tds            |character | |
#'    |pass_eff            |character | |
#'    |yds_per_completion  |character | |
#'    |pct                 |character | |
#'    |long_pass           |character | |
#'    |rec                 |character | |
#'    |receiving_yards     |character | |
#'    |yards_per_reception |character | |
#'    |rec_td              |character | |
#'    |long_rec            |character | |
#'    |yds                 |character | |
#'    |plays               |character | |
#'    |pbu                 |character | |
#'    |int                 |character | |
#'    |intyds              |character | |
#'    |int_ret_tds         |character | |
#'    |pdef                |character | |
#'    |ko_ret              |character | |
#'    |ko_ret_yds          |character | |
#'    |kick_ret_tds        |character | |
#'    |long_kor            |character | |
#'    |sacks               |character | |
#'    |solo_tack           |character | |
#'    |asst_tack           |character | |
#'    |tackles             |character | |
#'    |fgm                 |character | |
#'    |fga                 |character | |
#'    |fg_blocks_allowed   |character | |
#'    |punt_ret            |character | |
#'    |punt_ret_yds        |character | |
#'    |punt_ret_tds        |character | |
#'    |long_pr             |character | |
#'    |season              |integer   | |
#'
#' @examples
#' \donttest{
#'   try(load_ncaa_mfb_player_stats(2013))
#' }
#' @export
load_ncaa_mfb_player_stats <- function(seasons = most_recent_cfb_season(), ...,
                                       dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2013:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2013),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "ncaa_mfb_player_stats/ncaa_mfb_player_stats_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("NCAA men's football player stats (stats.ncaa.org) from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load NCAA men's football rosters (stats.ncaa.org) from the SportsDataverse data repo**
#' @name load_ncaa_mfb_rosters
NULL
#' @title
#' **Load NCAA men's football rosters (stats.ncaa.org) from the SportsDataverse data repo**
#' @rdname load_ncaa_mfb_rosters
#' @author Saiem Gilani
#' @description
#'   Loads season-level NCAA men's football rosters from stats.ncaa.org; one
#'   row per player-team-season. Published to the `ncaa_mfb_rosters` release
#'   tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2013 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2013)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name        |types     |description |
#'    |----------------|----------|:-----------|
#'    |team_id         |character | |
#'    |team_name       |character | |
#'    |player_id       |character | |
#'    |player_name     |character | |
#'    |jersey          |character | |
#'    |statcrew_jersey |character | |
#'    |player_class    |character | |
#'    |position        |character | |
#'    |height          |character | |
#'    |weight          |integer   | |
#'    |hometown        |character | |
#'    |high_school     |character | |
#'    |games_played    |integer   | |
#'    |games_started   |integer   | |
#'    |academic_year   |integer   | |
#'    |season          |integer   | |
#'
#' @examples
#' \donttest{
#'   try(load_ncaa_mfb_rosters(2013))
#' }
#' @export
load_ncaa_mfb_rosters <- function(seasons = most_recent_cfb_season(), ...,
                                  dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2013:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2013),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "ncaa_mfb_rosters/ncaa_mfb_rosters_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("NCAA men's football rosters (stats.ncaa.org) from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load NCAA men's football schedules (stats.ncaa.org) from the SportsDataverse data repo**
#' @name load_ncaa_mfb_schedule
NULL
#' @title
#' **Load NCAA men's football schedules (stats.ncaa.org) from the SportsDataverse data repo**
#' @rdname load_ncaa_mfb_schedule
#' @author Saiem Gilani
#' @description
#'   Loads season-level NCAA men's football schedules from stats.ncaa.org; one
#'   row per game. Published to the `ncaa_mfb_schedule` release tag on the
#'   sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2013 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2013)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name       |types     |description |
#'    |---------------|----------|:-----------|
#'    |team_id        |character | |
#'    |team_name      |character | |
#'    |date           |character | |
#'    |opponent_id    |character | |
#'    |opponent       |character | |
#'    |result         |character | |
#'    |outcome        |character | |
#'    |team_score     |integer   | |
#'    |opponent_score |integer   | |
#'    |contest_id     |character | |
#'    |attendance     |integer   | |
#'    |academic_year  |integer   | |
#'    |espn_game_id   |character | |
#'    |season         |integer   | |
#'
#' @examples
#' \donttest{
#'   try(load_ncaa_mfb_schedule(2013))
#' }
#' @export
load_ncaa_mfb_schedule <- function(seasons = most_recent_cfb_season(), ...,
                                   dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2013:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2013),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "ncaa_mfb_schedule/ncaa_mfb_schedule_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("NCAA men's football schedules (stats.ncaa.org) from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load NCAA men's football team stats (stats.ncaa.org) from the SportsDataverse data repo**
#' @name load_ncaa_mfb_team_stats
NULL
#' @title
#' **Load NCAA men's football team stats (stats.ncaa.org) from the SportsDataverse data repo**
#' @rdname load_ncaa_mfb_team_stats
#' @author Saiem Gilani
#' @description
#'   Loads season-level NCAA men's football team box statistics parsed from
#'   stats.ncaa.org; one row per team-game-category. Published to the
#'   `ncaa_mfb_team_stats` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2013 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2013)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name     |types     |description |
#'    |-------------|----------|:-----------|
#'    |contest_id   |character | |
#'    |category     |character | |
#'    |stat         |character | |
#'    |period       |character | |
#'    |away_team    |character | |
#'    |away_value   |character | |
#'    |home_team    |character | |
#'    |home_value   |character | |
#'    |espn_game_id |character | |
#'    |season       |integer   | |
#'
#' @examples
#' \donttest{
#'   try(load_ncaa_mfb_team_stats(2013))
#' }
#' @export
load_ncaa_mfb_team_stats <- function(seasons = most_recent_cfb_season(), ...,
                                     dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2013:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2013),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "ncaa_mfb_team_stats/ncaa_mfb_team_stats_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("NCAA men's football team stats (stats.ncaa.org) from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load NCAA men's football teams (stats.ncaa.org) from the SportsDataverse data repo**
#' @name load_ncaa_mfb_teams
NULL
#' @title
#' **Load NCAA men's football teams (stats.ncaa.org) from the SportsDataverse data repo**
#' @rdname load_ncaa_mfb_teams
#' @author Saiem Gilani
#' @description
#'   Loads season-level NCAA men's football team directories from
#'   stats.ncaa.org, with division/conference alignment; one row per team-
#'   season. Published to the `ncaa_mfb_teams` release tag on the
#'   sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2013 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2013)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name      |types     |description |
#'    |--------------|----------|:-----------|
#'    |team_id       |character | |
#'    |team_name     |character | |
#'    |academic_year |integer   | |
#'    |division      |integer   | |
#'    |season        |integer   | |
#'
#' @examples
#' \donttest{
#'   try(load_ncaa_mfb_teams(2013))
#' }
#' @export
load_ncaa_mfb_teams <- function(seasons = most_recent_cfb_season(), ...,
                                dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2013:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2013),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "ncaa_mfb_teams/ncaa_mfb_teams_", seasons, ".rds")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("NCAA men's football teams (stats.ncaa.org) from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}
