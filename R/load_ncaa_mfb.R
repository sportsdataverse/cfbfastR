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
#'   participant context. Published to the `ncaa_mfb_pbp_cfbfastr` release tag
#'   on the sportsdataverse-data repo.
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
      make_cfbfastR_data("NCAA men's football play-by-play (stats.ncaa.org) from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}
