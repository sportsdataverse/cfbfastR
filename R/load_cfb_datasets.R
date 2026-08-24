# Release-dataset loaders -- thin wrappers around rds_from_url() /
# parquet_from_url() following the wehoop load_ncaa_wbb.R shape. Backed by
# the sportsdataverse-data release tags produced by the cfbfastR-cfb-data /
# cfbfastR-cfb-raw pipelines. GENERATED once from sdv-py loader schemas
# (tools/codegen/schemas/loader_schemas.yaml) on 2026-08-24; maintained by
# hand from here on.

#' **Load college football season power ratings from the SportsDataverse data repo**
#' @name load_cfb_ratings
NULL
#' @title
#' **Load college football season power ratings from the SportsDataverse data repo**
#' @rdname load_cfb_ratings
#' @author Saiem Gilani
#' @description
#'   Loads season-end team power ratings from the cfbfastR modeling suite --
#'   one row per team with overall/offense/defense/special-teams ratings on
#'   the points scale. Published to the
#'   `cfb_ratings` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name    |types   |description |
#'    |------------|--------|:-----------|
#'    |season      |integer | |
#'    |team_id     |integer | |
#'    |adj_off_epa |double  |Opponent-adjusted offensive EPA per play: the team's raw per-game EPA on pass and rush plays net of each opponent's ridge-fitted defensive strength, averaged over its games. |
#'    |adj_def_epa |double  |Opponent-adjusted EPA per play allowed, netted the same way as the offensive rating, so lower is better because it measures EPA surrendered. |
#'    |adj_st_epa  |double  |Special-teams composite in EPA units: per-play mean EPA on field goals, punts, and kick returns, each centered on that unit's league mean and summed across the three units. |
#'    |adj_net     |double  |adj_off_epa minus adj_def_epa, the team's overall efficiency rating in EPA per play; special teams is deliberately excluded. |
#'    |fei_off     |double  |Drive-level offensive rating from a ridge fit on per-drive EPA, the Fremeau-style drive-efficiency counterpart to adj_off_epa. |
#'    |fei_def     |double  |Drive-level defensive rating from the same per-drive ridge fit, on the same scale as fei_off. |
#'    |fei_net     |double  |fei_off minus fei_def, the team's overall drive-efficiency rating, with the ridge's dropped reference team pinned at zero. |
#'    |games       |integer | |
#'    |off_pace    |double  |Tempo measure: scrimmage plays (pass plus rush) per game, centering near 65 and used as the pace input to the totals model. |
#'    |off_rank    |integer |Dense rank of adj_off_epa in descending order, so rank 1 is the season's most efficient offense. |
#'    |def_rank    |integer |Dense rank of adj_def_epa in ascending order, so rank 1 is the season's stingiest defense. |
#'    |net_rank    |integer |Dense rank of adj_net in descending order, so rank 1 is the season's strongest overall team. |
#'    |net_z       |double  |adj_net restated as a z-score against the mean and standard deviation of adj_net across the rated teams that season. |
#'
#' @examples
#' \donttest{
#'   try(load_cfb_ratings(2004))
#' }
#' @export
load_cfb_ratings <- function(seasons = most_recent_cfb_season(), ...,
                             dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "cfb_ratings/cfb_ratings_", seasons, ".rds")

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
      make_cfbfastR_data("college football season power ratings from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football weekly power ratings from the SportsDataverse data repo**
#' @name load_cfb_ratings_weekly
NULL
#' @title
#' **Load college football weekly power ratings from the SportsDataverse data repo**
#' @rdname load_cfb_ratings_weekly
#' @author Saiem Gilani
#' @description
#'   Loads weekly team power ratings -- one row per team-week, the as-of-
#'   week snapshots behind the season-end ratings. Published to the
#'   `cfb_ratings_weekly` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name     |types   |description |
#'    |-------------|--------|:-----------|
#'    |season       |integer | |
#'    |team_id      |integer | |
#'    |adj_off_epa  |double  |Opponent-adjusted offensive EPA per play as of the snapshot week: raw per-game EPA on pass and rush plays net of each opponent's ridge-fitted defensive strength. |
#'    |adj_def_epa  |double  |Opponent-adjusted EPA per play allowed as of the snapshot week, netted the same way as the offensive rating, so lower is better. |
#'    |adj_st_epa   |double  |Special-teams composite in EPA units as of the snapshot week, summing the league-centered per-play EPA of the field goal, punt, and kick-return units. |
#'    |adj_net      |double  |adj_off_epa minus adj_def_epa at the snapshot week, the team's overall efficiency rating in EPA per play with special teams excluded. |
#'    |fei_off      |double  |Drive-level offensive rating at the snapshot week, from a ridge fit on per-drive EPA. |
#'    |fei_def      |double  |Drive-level defensive rating at the snapshot week, from the same per-drive ridge fit and on the same scale as fei_off. |
#'    |fei_net      |double  |fei_off minus fei_def at the snapshot week, the team's overall drive-efficiency rating. |
#'    |games        |integer | |
#'    |off_pace     |double  |Scrimmage plays per game through the snapshot week, the tempo input consumed by the totals model. |
#'    |off_rank     |integer |Dense rank of adj_off_epa in descending order within the snapshot week, so rank 1 is the most efficient offense at that point. |
#'    |def_rank     |integer |Dense rank of adj_def_epa in ascending order within the snapshot week, so rank 1 is the stingiest defense at that point. |
#'    |net_rank     |integer |Dense rank of adj_net in descending order within the snapshot week, so rank 1 is the strongest overall team at that point. |
#'    |net_z        |double  |adj_net restated as a z-score against the mean and standard deviation of adj_net across the teams rated in that snapshot week. |
#'    |through_week |integer |Regular-season week the snapshot runs through; the ratings were refit using only games kicking off on or before that week's final kickoff date. |
#'
#' @examples
#' \donttest{
#'   try(load_cfb_ratings_weekly(2004))
#' }
#' @export
load_cfb_ratings_weekly <- function(seasons = most_recent_cfb_season(), ...,
                                    dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "cfb_ratings_weekly/cfb_ratings_weekly_", seasons, ".rds")

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
      make_cfbfastR_data("college football weekly power ratings from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football weekly ESPN FPI ratings from the SportsDataverse data repo**
#' @name load_cfb_fpi_weekly
NULL
#' @title
#' **Load college football weekly ESPN FPI ratings from the SportsDataverse data repo**
#' @rdname load_cfb_fpi_weekly
#' @author Saiem Gilani
#' @description
#'   Loads weekly ESPN FPI snapshots -- one row per team-week with FPI and
#'   its components as published that week. Published to the
#'   `cfb_fpi_weekly` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2005 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2005)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name                    |types     |description |
#'    |----------------------------|----------|:-----------|
#'    |season                      |integer   | |
#'    |season_type                 |integer   | |
#'    |week                        |integer   | |
#'    |team_id                     |integer   | |
#'    |last_updated                |character | |
#'    |run_date_time_key           |integer   |ESPN's run key for the snapshot, as an integer timestamp (e.g. 20241021040000). This is the AS-OF date the snapshot represents, which is not the same as last_updated (when ESPN computed it); the gap between the two is what snapshot_is_contemporaneous flags. |
#'    |snapshot_out_of_sequence    |logical   |True when this snapshot was computed AFTER one belonging to a later week of the same season type -- so it cannot be read as an as-of-that-week rating. Almost always the week-1 slot, which ESPN overwrites with a late-season computation (2024 week 1 is stamped 2024-12-15). Filter these out for any point-in-time or backtest use. |
#'    |fpi                         |double    |Football Power Index that measures team's true strength on net points scale; expected point margin vs average opponent on neutral field. |
#'    |fpirank                     |double    |ESPN's FPI rank field. Agrees with rank on 99.4% of rows; on the ~0.6% where they differ it is stale -- it never matches the rank implied by the published fpi, while rank always does. Prefer rank. |
#'    |projectedw                  |double    |Projected overall W-L, accounting for results to date and FPI-based projections for remaining scheduled games (and potential conference championship games). May not sum to a whole number because of differing number of games played in each simulation. |
#'    |projectedl                  |double    |Projected overall Losses, accounting for results to date and FPI-based projections for remaining scheduled games (including potential conference championship games). May not sum to a whole number because of differing number of games played in each simulation. |
#'    |projectedt                  |character |Projected ties. Always null -- college football abolished ties in 1996, and ESPN emits the key beside projectedw/projectedl without ever populating it. Retained so the column set matches the upstream payload. |
#'    |projectedwpctrank           |double    |Rank among FBS teams by projected win percentage. ESPN publishes the rank without the underlying percentage; derive it from projectedw and projectedl. |
#'    |probwinout                  |double    |Percent of season simulations in which team won all remaining scheduled games as well as conference championship game (if applicable). |
#'    |probwinconf                 |double    |Percent of season simulations in which team won its conference, incorporating chance of getting to and winning conference championship game (if applicable). Accounts for shared conference titles in conferences that allow them. |
#'    |sosremainingrank            |double    |Rank among all FBS teams of remaining schedule strength, from perspective of an average FBS team. |
#'    |accomplishment              |double    |Reflects chance that an average Top 25 team would have team's record or better, given the schedule. On a 0 to 100 scale, where 100 is best. |
#'    |accomplishmentrank          |double    |Strength of Record rank. Reflects chance that an average Top 25 team would have team's record or better, given the schedule. |
#'    |adjwins                     |double    |Team's Wins adjusted for chance an average FBS team would have team's record or better, given the schedule. |
#'    |adjlosses                   |double    |Team's Losses adjusted for chance an average FBS team would have team's record or better, given the schedule. |
#'    |adjwinpctrank               |double    |Rank among FBS teams by adjusted win percentage. ESPN publishes the rank without the underlying percentage; derive it from adjwins and adjlosses. 0 is an unranked placeholder, not a rank -- it appears where the underlying value is null. |
#'    |gamecontrol                 |double    |Reflects chance that an average Top 25 team would control games from start to end the way this team did, given the schedule. On a 0 to 100 scale, where 100 is best. |
#'    |gamecontrolrank             |double    |Game Control rank. Reflects chance that an average Top 25 team would control games from start to end the way this team did, given the schedule. |
#'    |adjavgingamewp              |double    |Team's average in-game win probability adjusted for chance that an average FBS team would control games from start to end the way this team did, given the schedule. |
#'    |adjavgingamewprank          |double    |Rank among FBS teams by adjavgingamewp (average in-game win probability adjusted for opponent). Null for most pre-2019 snapshots. 0 is an unranked placeholder, not a rank. |
#'    |avgingamewp                 |double    |Team's average in-game win probability across all plays of all games played, not adjusted for site or opponent. |
#'    |avgingamewprank             |double    |Team's average in-game win probability rank adjusted for chance that an average FBS team would control games from start to end the way this team did, given the schedule. |
#'    |avgsosrank                  |double    |Rank among all FBS teams of games already played schedule strength, from perspective of an average Top 25 team. |
#'    |topsosrank                  |double    |Rank among all FBS teams of games already played schedule strength, from perspective of an top FBS team. |
#'    |epaoffense                  |double    |Offensive component of FPI. Offensive contribution to expected point margin vs average opponent on neutral field. |
#'    |epadefense                  |double    |Defensive component of FPI. Defensive contribution to expected point margin vs average opponent on neutral field. |
#'    |epaspecialteams             |double    |Special teams component of FPI. Special teams contribution to expected point margin vs average opponent on neutral field. |
#'    |probwindiv                  |double    |Percent of season simulations in which team won its conference division, for those conferences that have divisions. |
#'    |probmakeplayoffs            |double    |Chance to make the CFB Playoff, according to the Playoff Predictor. |
#'    |probmaketitlegame           |double    |Chance to make the CFB Playoff National Championship game, according to the Playoff Predictor. |
#'    |numwins                     |double    |Actual wins to date at the time of the snapshot. Distinct from projectedw (full-season projection) and adjwins (opponent-adjusted). |
#'    |numlosses                   |double    |Actual losses to date at the time of the snapshot. Distinct from projectedl (full-season projection) and adjlosses (opponent-adjusted). |
#'    |numties                     |double    |Actual ties to date. Never nonzero -- college football abolished ties in 1996; the column is null or 0 in every published row. |
#'    |probwintitle                |double    |Chance to win the CFB Playoff National Championship, according to the Playoff Predictor. |
#'    |rankchange7days             |double    |FPI Rank change from previous week. |
#'    |prob6wins                   |double    |Percent of season simulations in which a team won at least 6 games (typically bowl-eligible). |
#'    |rank                        |double    |FPI rank among FBS teams for this snapshot (1 = best). Prefer this over fpirank: the two agree on 99.4% of rows, and on the ~0.6% where they differ, rank is always the one consistent with the published fpi value. |
#'    |offefficiency               |double    |Offensive efficiency on 0-100 scale; based on offense's contribution to scoring margin on per-play basis, adjusted for strength of opposing defenses faced. |
#'    |offefficiencyrank           |double    |Team's offensive efficiency rank among all FBS teams. |
#'    |defefficiency               |double    |Defensive efficiency on 0-100 scale; based on defense's contribution to scoring margin on per-play basis, adjusted for strength of opposing offenses faced. |
#'    |defefficiencyrank           |double    |Team's defensive efficiency rank among all FBS teams. |
#'    |stefficiency                |double    |Special teams efficiency on 0-100 scale; based on special teams' contribution to scoring margin on per-play basis, adjusted for strength of opposing special teams faced. |
#'    |stefficiencyrank            |double    |Team's special teams efficiency rank among all FBS teams. |
#'    |totefficiency               |double    |Net efficiency on 0-100 scale; incorporates offense, defense and special teams efficiencies into a single schedule-adjusted measure of per-play efficiency. |
#'    |totefficiencyrank           |double    |Team's overall efficiency rank among all FBS teams. |
#'    |snapshot_is_contemporaneous |logical   |True when the snapshot was computed inside its own season's window (August of the season year through February of the next), i.e. it is a live weekly run rather than a retrospective backfill. False for every row before 2015, which ESPN computed in one pass afterwards. A retrospective row is a reconstruction, not an as-of-week rating. |
#'
#' @examples
#' \donttest{
#'   try(load_cfb_fpi_weekly(2005))
#' }
#' @export
load_cfb_fpi_weekly <- function(seasons = most_recent_cfb_season(), ...,
                                dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2005:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2005),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "cfb_fpi_weekly/cfb_fpi_weekly_", seasons, ".rds")

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
      make_cfbfastR_data("college football weekly ESPN FPI ratings from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football weekly team summaries from the SportsDataverse data repo**
#' @name load_cfb_team_summaries_weekly
NULL
#' @title
#' **Load college football weekly team summaries from the SportsDataverse data repo**
#' @rdname load_cfb_team_summaries_weekly
#' @author Saiem Gilani
#' @description
#'   Loads weekly team summaries -- one row per team-week with cumulative-
#'   to-date EPA and success-rate profiles. Published
#'   to the `cfb_team_summaries_weekly` release tag on the sportsdataverse-data
#'   repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name                             |types     |description |
#'    |-------------------------------------|----------|:-----------|
#'    |team_id                              |integer   | |
#'    |pos_team                             |character | |
#'    |division                             |character | |
#'    |conference                           |character | |
#'    |season                               |integer   | |
#'    |plays_off                            |integer   |Plays run, with the team on offense. |
#'    |passrate_off                         |double    |Share of plays that were pass plays, with the team on offense. |
#'    |rushrate_off                         |double    |Share of plays that were rush plays, with the team on offense. |
#'    |havoc_off                            |double    |Havoc rate -- the share of plays carrying the defensive-disruption flag, with the team on offense. |
#'    |explosive_off                        |double    |Explosive-play rate -- the share of plays carrying the explosive flag, with the team on offense. |
#'    |TEPA_off                             |double    |Total EPA summed over every play, with the team on offense. |
#'    |EPAplay_off                          |double    |EPA per play, with the team on offense. |
#'    |yards_off                            |integer   |Total yards gained, with the team on offense. |
#'    |yardsplay_off                        |double    |Yards gained per play, with the team on offense. |
#'    |play_stuffed_off                     |double    |Stuffed-play rate -- the share of plays carrying the stuffed flag, with the team on offense. |
#'    |success_off                          |double    |Success rate -- the share of plays flagged as successful by EPA, with the team on offense. |
#'    |red_zone_success_off                 |double    |Success rate on red-zone plays, with the team on offense. |
#'    |third_down_success_off               |double    |Success rate on third-down plays, with the team on offense. |
#'    |third_down_distance_off              |double    |Average yards to go on third down, with the team on offense. |
#'    |late_down_success_off                |double    |Success rate on late-down plays, with the team on offense. |
#'    |early_down_EPA_off                   |double    |EPA per early-down play, with the team on offense. |
#'    |start_position_off                   |double    |Average drive start position, measured in yards from the opponent goal line, with the team on offense. |
#'    |nonExplosiveEpaPerPlay_off           |double    |EPA per play with explosive plays excluded, with the team on offense. |
#'    |line_yards_off                       |double    |Average line yards credited to the offensive line on rushes, with the team on offense. |
#'    |opportunity_rate_off                 |double    |Opportunity rate -- the share of rushes carrying the opportunity flag, with the team on offense. |
#'    |playsgame_off                        |double    |Plays run per game, with the team on offense. |
#'    |EPAdrive_off                         |double    |EPA per drive (total EPA divided by drives), with the team on offense. |
#'    |EPAgame_off                          |double    |EPA per game (total EPA divided by games), with the team on offense. |
#'    |yardsgame_off                        |double    |Yards gained per game, with the team on offense. |
#'    |drives_off                           |integer   |Offensive drives, with the team on offense. |
#'    |drivesgame_off                       |double    |Drives per game, with the team on offense. |
#'    |yardsdrive_off                       |double    |Yards gained per drive, with the team on offense. |
#'    |playsdrive_off                       |double    |Plays run per drive, with the team on offense. |
#'    |playsgame_off_rank                   |double    |National rank of the team's plays run per game with the team on offense, where 1 is best. |
#'    |TEPA_off_rank                        |double    |National rank of the team's total EPA summed over every play with the team on offense, where 1 is best. |
#'    |EPAgame_off_rank                     |double    |National rank of the team's EPA per game (total EPA divided by games) with the team on offense, where 1 is best. |
#'    |EPAplay_off_rank                     |double    |National rank of the team's EPA per play with the team on offense, where 1 is best. |
#'    |EPAdrive_off_rank                    |double    |National rank of the team's EPA per drive (total EPA divided by drives) with the team on offense, where 1 is best. |
#'    |early_down_EPA_off_rank              |double    |National rank of the team's EPA per early-down play with the team on offense, where 1 is best. |
#'    |success_off_rank                     |double    |National rank of the team's success rate -- the share of plays flagged as successful by EPA with the team on offense, where 1 is best. |
#'    |yards_off_rank                       |double    |National rank of the team's total yards gained with the team on offense, where 1 is best. |
#'    |yardsplay_off_rank                   |double    |National rank of the team's yards gained per play with the team on offense, where 1 is best. |
#'    |yardsgame_off_rank                   |double    |National rank of the team's yards gained per game with the team on offense, where 1 is best. |
#'    |drivesgame_off_rank                  |double    |National rank of the team's drives per game with the team on offense, where 1 is best. |
#'    |yardsdrive_off_rank                  |double    |National rank of the team's yards gained per drive with the team on offense, where 1 is best. |
#'    |playsdrive_off_rank                  |double    |National rank of the team's plays run per drive with the team on offense, where 1 is best. |
#'    |play_stuffed_off_rank                |double    |National rank of the team's stuffed-play rate -- the share of plays carrying the stuffed flag with the team on offense, where 1 is best. |
#'    |red_zone_success_off_rank            |double    |National rank of the team's success rate on red-zone plays with the team on offense, where 1 is best. |
#'    |third_down_success_off_rank          |double    |National rank of the team's success rate on third-down plays with the team on offense, where 1 is best. |
#'    |late_down_success_off_rank           |double    |National rank of the team's success rate on late-down plays with the team on offense, where 1 is best. |
#'    |third_down_distance_off_rank         |double    |National rank of the team's average yards to go on third down with the team on offense, where 1 is best. |
#'    |start_position_off_rank              |double    |National rank of the team's average drive start position, measured in yards from the opponent goal line with the team on offense, where 1 is best. |
#'    |havoc_off_rank                       |double    |National rank of the team's havoc rate -- the share of plays carrying the defensive-disruption flag with the team on offense, where 1 is best. |
#'    |explosive_off_rank                   |double    |National rank of the team's explosive-play rate -- the share of plays carrying the explosive flag with the team on offense, where 1 is best. |
#'    |passrate_off_rank                    |double    |National rank of the team's share of plays that were pass plays with the team on offense, where 1 is best. |
#'    |rushrate_off_rank                    |double    |National rank of the team's share of plays that were rush plays with the team on offense, where 1 is best. |
#'    |nonExplosiveEpaPerPlay_off_rank      |double    |National rank of the team's EPA per play with explosive plays excluded with the team on offense, where 1 is best. |
#'    |line_yards_off_rank                  |double    |National rank of the team's average line yards credited to the offensive line on rushes with the team on offense, where 1 is best. |
#'    |opportunity_rate_off_rank            |double    |National rank of the team's opportunity rate -- the share of rushes carrying the opportunity flag with the team on offense, where 1 is best. |
#'    |plays_def                            |integer   |Plays run, with the team on defense (i.e. allowed to opponents). |
#'    |passrate_def                         |double    |Share of plays that were pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |rushrate_def                         |double    |Share of plays that were rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |havoc_def                            |double    |Havoc rate -- the share of plays carrying the defensive-disruption flag, with the team on defense (i.e. allowed to opponents). |
#'    |explosive_def                        |double    |Explosive-play rate -- the share of plays carrying the explosive flag, with the team on defense (i.e. allowed to opponents). |
#'    |TEPA_def                             |double    |Total EPA summed over every play, with the team on defense (i.e. allowed to opponents). |
#'    |EPAplay_def                          |double    |EPA per play, with the team on defense (i.e. allowed to opponents). |
#'    |yards_def                            |integer   |Total yards gained, with the team on defense (i.e. allowed to opponents). |
#'    |yardsplay_def                        |double    |Yards gained per play, with the team on defense (i.e. allowed to opponents). |
#'    |play_stuffed_def                     |double    |Stuffed-play rate -- the share of plays carrying the stuffed flag, with the team on defense (i.e. allowed to opponents). |
#'    |success_def                          |double    |Success rate -- the share of plays flagged as successful by EPA, with the team on defense (i.e. allowed to opponents). |
#'    |red_zone_success_def                 |double    |Success rate on red-zone plays, with the team on defense (i.e. allowed to opponents). |
#'    |third_down_success_def               |double    |Success rate on third-down plays, with the team on defense (i.e. allowed to opponents). |
#'    |third_down_distance_def              |double    |Average yards to go on third down, with the team on defense (i.e. allowed to opponents). |
#'    |late_down_success_def                |double    |Success rate on late-down plays, with the team on defense (i.e. allowed to opponents). |
#'    |early_down_EPA_def                   |double    |EPA per early-down play, with the team on defense (i.e. allowed to opponents). |
#'    |start_position_def                   |double    |Average drive start position, measured in yards from the opponent goal line, with the team on defense (i.e. allowed to opponents). |
#'    |nonExplosiveEpaPerPlay_def           |double    |EPA per play with explosive plays excluded, with the team on defense (i.e. allowed to opponents). |
#'    |line_yards_def                       |double    |Average line yards credited to the offensive line on rushes, with the team on defense (i.e. allowed to opponents). |
#'    |opportunity_rate_def                 |double    |Opportunity rate -- the share of rushes carrying the opportunity flag, with the team on defense (i.e. allowed to opponents). |
#'    |playsgame_def                        |double    |Plays run per game, with the team on defense (i.e. allowed to opponents). |
#'    |EPAdrive_def                         |double    |EPA per drive (total EPA divided by drives), with the team on defense (i.e. allowed to opponents). |
#'    |EPAgame_def                          |double    |EPA per game (total EPA divided by games), with the team on defense (i.e. allowed to opponents). |
#'    |yardsgame_def                        |double    |Yards gained per game, with the team on defense (i.e. allowed to opponents). |
#'    |drives_def                           |integer   |Offensive drives, with the team on defense (i.e. allowed to opponents). |
#'    |drivesgame_def                       |double    |Drives per game, with the team on defense (i.e. allowed to opponents). |
#'    |yardsdrive_def                       |double    |Yards gained per drive, with the team on defense (i.e. allowed to opponents). |
#'    |playsdrive_def                       |double    |Plays run per drive, with the team on defense (i.e. allowed to opponents). |
#'    |playsgame_def_rank                   |double    |National rank of the team's plays run per game with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |TEPA_def_rank                        |double    |National rank of the team's total EPA summed over every play with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |EPAgame_def_rank                     |double    |National rank of the team's EPA per game (total EPA divided by games) with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |EPAplay_def_rank                     |double    |National rank of the team's EPA per play with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |EPAdrive_def_rank                    |double    |National rank of the team's EPA per drive (total EPA divided by drives) with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |early_down_EPA_def_rank              |double    |National rank of the team's EPA per early-down play with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |success_def_rank                     |double    |National rank of the team's success rate -- the share of plays flagged as successful by EPA with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |yards_def_rank                       |double    |National rank of the team's total yards gained with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |yardsplay_def_rank                   |double    |National rank of the team's yards gained per play with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |yardsgame_def_rank                   |double    |National rank of the team's yards gained per game with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |drivesgame_def_rank                  |double    |National rank of the team's drives per game with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |yardsdrive_def_rank                  |double    |National rank of the team's yards gained per drive with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |playsdrive_def_rank                  |double    |National rank of the team's plays run per drive with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |play_stuffed_def_rank                |double    |National rank of the team's stuffed-play rate -- the share of plays carrying the stuffed flag with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |red_zone_success_def_rank            |double    |National rank of the team's success rate on red-zone plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |third_down_success_def_rank          |double    |National rank of the team's success rate on third-down plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |late_down_success_def_rank           |double    |National rank of the team's success rate on late-down plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |third_down_distance_def_rank         |double    |National rank of the team's average yards to go on third down with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |start_position_def_rank              |double    |National rank of the team's average drive start position, measured in yards from the opponent goal line with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |havoc_def_rank                       |double    |National rank of the team's havoc rate -- the share of plays carrying the defensive-disruption flag with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |explosive_def_rank                   |double    |National rank of the team's explosive-play rate -- the share of plays carrying the explosive flag with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |passrate_def_rank                    |double    |National rank of the team's share of plays that were pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |rushrate_def_rank                    |double    |National rank of the team's share of plays that were rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |nonExplosiveEpaPerPlay_def_rank      |double    |National rank of the team's EPA per play with explosive plays excluded with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |line_yards_def_rank                  |double    |National rank of the team's average line yards credited to the offensive line on rushes with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |opportunity_rate_def_rank            |double    |National rank of the team's opportunity rate -- the share of rushes carrying the opportunity flag with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |TEPA_margin                          |double    |Margin in total EPA summed over every play: the team's offensive value minus the value it allowed on defense. |
#'    |EPAplay_margin                       |double    |Margin in EPA per play: the team's offensive value minus the value it allowed on defense. |
#'    |EPAdrive_margin                      |double    |Margin in EPA per drive (total EPA divided by drives): the team's offensive value minus the value it allowed on defense. |
#'    |EPAgame_margin                       |double    |Margin in EPA per game (total EPA divided by games): the team's offensive value minus the value it allowed on defense. |
#'    |success_margin                       |double    |Margin in success rate -- the share of plays flagged as successful by EPA: the team's offensive value minus the value it allowed on defense. |
#'    |yardsplay_margin                     |double    |Margin in yards gained per play: the team's offensive value minus the value it allowed on defense. |
#'    |TEPA_margin_rank                     |double    |Margin in total EPA summed over every play: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |EPAplay_margin_rank                  |double    |Margin in EPA per play: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |EPAdrive_margin_rank                 |double    |Margin in EPA per drive (total EPA divided by drives): the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |EPAgame_margin_rank                  |double    |Margin in EPA per game (total EPA divided by games): the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |success_margin_rank                  |double    |Margin in success rate -- the share of plays flagged as successful by EPA: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |yardsplay_margin_rank                |double    |Margin in yards gained per play: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |start_position_margin                |double    |Field-position margin: the team's own average starting field position minus the average starting field position it allowed, both measured as yards gained from their own goal line. Positive means the team started closer to scoring than its opponents. |
#'    |start_position_margin_rank           |double    |Field-position margin: the team's own average starting field position minus the average starting field position it allowed, both measured as yards gained from their own goal line. Positive means the team started closer to scoring than its opponents. National rank of that margin, 1 = largest. |
#'    |total_available_yards_off            |double    |Available yards are the yards a drive could theoretically gain, summed from each drive's starting distance to the opponent goal line. Total available yards on the team's own drives. |
#'    |total_gained_yards_off               |integer   |Total yards the team actually gained across its own drives. |
#'    |available_yards_pct_off              |double    |Share of available yards the team's offense actually gained (total_gained_yards_off divided by total_available_yards_off). Higher is better. |
#'    |available_yards_pct_off_rank         |double    |National rank of the team's offensive available-yards share, where 1 is best. |
#'    |total_available_yards_def            |double    |Available yards are the yards a drive could theoretically gain, summed from each drive's starting distance to the opponent goal line. Total available yards on drives the team defended. |
#'    |total_gained_yards_def               |integer   |Total yards the team allowed across the drives it defended. |
#'    |available_yards_pct_def              |double    |Share of available yards the team's defense allowed opponents to gain. Lower is better. |
#'    |available_yards_pct_def_rank         |double    |National rank of the team's defensive available-yards share, where 1 is best. |
#'    |total_available_yards_margin         |double    |Available yards on the team's own drives minus available yards on drives it defended. |
#'    |total_gained_yards_margin            |integer   |Yards the team gained minus yards it allowed. |
#'    |available_yards_pct_margin           |double    |Available-yards share gained by the offense minus the share allowed by the defense. Higher is better. |
#'    |total_available_yards_margin_rank    |double    |National rank of total_available_yards_margin, 1 = largest margin. |
#'    |total_gained_yards_margin_rank       |double    |National rank of total_gained_yards_margin, 1 = largest margin. |
#'    |available_yards_pct_margin_rank      |double    |National rank of available_yards_pct_margin, 1 = largest margin. |
#'    |plays_off_pass                       |integer   |Plays run on pass plays, with the team on offense. |
#'    |passrate_off_pass                    |double    |Share of plays that were pass plays on pass plays, with the team on offense. |
#'    |rushrate_off_pass                    |double    |Share of plays that were rush plays on pass plays, with the team on offense. |
#'    |havoc_off_pass                       |double    |Havoc rate -- the share of plays carrying the defensive-disruption flag on pass plays, with the team on offense. |
#'    |explosive_off_pass                   |double    |Explosive-play rate -- the share of plays carrying the explosive flag on pass plays, with the team on offense. |
#'    |TEPA_off_pass                        |double    |Total EPA summed over every play on pass plays, with the team on offense. |
#'    |EPAplay_off_pass                     |double    |EPA per play on pass plays, with the team on offense. |
#'    |yards_off_pass                       |integer   |Total yards gained on pass plays, with the team on offense. |
#'    |yardsplay_off_pass                   |double    |Yards gained per play on pass plays, with the team on offense. |
#'    |play_stuffed_off_pass                |double    |Stuffed-play rate -- the share of plays carrying the stuffed flag on pass plays, with the team on offense. |
#'    |success_off_pass                     |double    |Success rate -- the share of plays flagged as successful by EPA on pass plays, with the team on offense. |
#'    |red_zone_success_off_pass            |double    |Success rate on red-zone plays on pass plays, with the team on offense. |
#'    |third_down_success_off_pass          |double    |Success rate on third-down plays on pass plays, with the team on offense. |
#'    |third_down_distance_off_pass         |double    |Average yards to go on third down on pass plays, with the team on offense. |
#'    |late_down_success_off_pass           |double    |Success rate on late-down plays on pass plays, with the team on offense. |
#'    |early_down_EPA_off_pass              |double    |EPA per early-down play on pass plays, with the team on offense. |
#'    |nonExplosiveEpaPerPlay_off_pass      |double    |EPA per play with explosive plays excluded on pass plays, with the team on offense. |
#'    |line_yards_off_pass                  |double    |Average line yards credited to the offensive line on rushes on pass plays, with the team on offense. |
#'    |opportunity_rate_off_pass            |double    |Opportunity rate -- the share of rushes carrying the opportunity flag on pass plays, with the team on offense. |
#'    |playsgame_off_pass                   |double    |Plays run per game on pass plays, with the team on offense. |
#'    |EPAdrive_off_pass                    |double    |EPA per drive (total EPA divided by drives) on pass plays, with the team on offense. |
#'    |EPAgame_off_pass                     |double    |EPA per game (total EPA divided by games) on pass plays, with the team on offense. |
#'    |yardsgame_off_pass                   |double    |Yards gained per game on pass plays, with the team on offense. |
#'    |drives_off_pass                      |integer   |Offensive drives on pass plays, with the team on offense. |
#'    |drivesgame_off_pass                  |double    |Drives per game on pass plays, with the team on offense. |
#'    |yardsdrive_off_pass                  |double    |Yards gained per drive on pass plays, with the team on offense. |
#'    |playsdrive_off_pass                  |double    |Plays run per drive on pass plays, with the team on offense. |
#'    |playsgame_off_pass_rank              |double    |National rank of the team's plays run per game on pass plays with the team on offense, where 1 is best. |
#'    |TEPA_off_pass_rank                   |double    |National rank of the team's total EPA summed over every play on pass plays with the team on offense, where 1 is best. |
#'    |EPAgame_off_pass_rank                |double    |National rank of the team's EPA per game (total EPA divided by games) on pass plays with the team on offense, where 1 is best. |
#'    |EPAplay_off_pass_rank                |double    |National rank of the team's EPA per play on pass plays with the team on offense, where 1 is best. |
#'    |EPAdrive_off_pass_rank               |double    |National rank of the team's EPA per drive (total EPA divided by drives) on pass plays with the team on offense, where 1 is best. |
#'    |early_down_EPA_off_pass_rank         |double    |National rank of the team's EPA per early-down play on pass plays with the team on offense, where 1 is best. |
#'    |success_off_pass_rank                |double    |National rank of the team's success rate -- the share of plays flagged as successful by EPA on pass plays with the team on offense, where 1 is best. |
#'    |yards_off_pass_rank                  |double    |National rank of the team's total yards gained on pass plays with the team on offense, where 1 is best. |
#'    |yardsplay_off_pass_rank              |double    |National rank of the team's yards gained per play on pass plays with the team on offense, where 1 is best. |
#'    |yardsgame_off_pass_rank              |double    |National rank of the team's yards gained per game on pass plays with the team on offense, where 1 is best. |
#'    |drivesgame_off_pass_rank             |double    |National rank of the team's drives per game on pass plays with the team on offense, where 1 is best. |
#'    |yardsdrive_off_pass_rank             |double    |National rank of the team's yards gained per drive on pass plays with the team on offense, where 1 is best. |
#'    |playsdrive_off_pass_rank             |double    |National rank of the team's plays run per drive on pass plays with the team on offense, where 1 is best. |
#'    |play_stuffed_off_pass_rank           |double    |National rank of the team's stuffed-play rate -- the share of plays carrying the stuffed flag on pass plays with the team on offense, where 1 is best. |
#'    |red_zone_success_off_pass_rank       |double    |National rank of the team's success rate on red-zone plays on pass plays with the team on offense, where 1 is best. |
#'    |third_down_success_off_pass_rank     |double    |National rank of the team's success rate on third-down plays on pass plays with the team on offense, where 1 is best. |
#'    |late_down_success_off_pass_rank      |double    |National rank of the team's success rate on late-down plays on pass plays with the team on offense, where 1 is best. |
#'    |third_down_distance_off_pass_rank    |double    |National rank of the team's average yards to go on third down on pass plays with the team on offense, where 1 is best. |
#'    |havoc_off_pass_rank                  |double    |National rank of the team's havoc rate -- the share of plays carrying the defensive-disruption flag on pass plays with the team on offense, where 1 is best. |
#'    |explosive_off_pass_rank              |double    |National rank of the team's explosive-play rate -- the share of plays carrying the explosive flag on pass plays with the team on offense, where 1 is best. |
#'    |passrate_off_pass_rank               |double    |National rank of the team's share of plays that were pass plays on pass plays with the team on offense, where 1 is best. |
#'    |rushrate_off_pass_rank               |double    |National rank of the team's share of plays that were rush plays on pass plays with the team on offense, where 1 is best. |
#'    |nonExplosiveEpaPerPlay_off_pass_rank |double    |National rank of the team's EPA per play with explosive plays excluded on pass plays with the team on offense, where 1 is best. |
#'    |line_yards_off_pass_rank             |double    |National rank of the team's average line yards credited to the offensive line on rushes on pass plays with the team on offense, where 1 is best. |
#'    |opportunity_rate_off_pass_rank       |double    |National rank of the team's opportunity rate -- the share of rushes carrying the opportunity flag on pass plays with the team on offense, where 1 is best. |
#'    |plays_def_pass                       |integer   |Plays run on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |passrate_def_pass                    |double    |Share of plays that were pass plays on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |rushrate_def_pass                    |double    |Share of plays that were rush plays on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |havoc_def_pass                       |double    |Havoc rate -- the share of plays carrying the defensive-disruption flag on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |explosive_def_pass                   |double    |Explosive-play rate -- the share of plays carrying the explosive flag on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |TEPA_def_pass                        |double    |Total EPA summed over every play on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |EPAplay_def_pass                     |double    |EPA per play on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |yards_def_pass                       |integer   |Total yards gained on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |yardsplay_def_pass                   |double    |Yards gained per play on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |play_stuffed_def_pass                |double    |Stuffed-play rate -- the share of plays carrying the stuffed flag on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |success_def_pass                     |double    |Success rate -- the share of plays flagged as successful by EPA on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |red_zone_success_def_pass            |double    |Success rate on red-zone plays on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |third_down_success_def_pass          |double    |Success rate on third-down plays on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |third_down_distance_def_pass         |double    |Average yards to go on third down on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |late_down_success_def_pass           |double    |Success rate on late-down plays on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |early_down_EPA_def_pass              |double    |EPA per early-down play on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |nonExplosiveEpaPerPlay_def_pass      |double    |EPA per play with explosive plays excluded on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |line_yards_def_pass                  |double    |Average line yards credited to the offensive line on rushes on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |opportunity_rate_def_pass            |double    |Opportunity rate -- the share of rushes carrying the opportunity flag on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |playsgame_def_pass                   |double    |Plays run per game on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |EPAdrive_def_pass                    |double    |EPA per drive (total EPA divided by drives) on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |EPAgame_def_pass                     |double    |EPA per game (total EPA divided by games) on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |yardsgame_def_pass                   |double    |Yards gained per game on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |drives_def_pass                      |integer   |Offensive drives on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |drivesgame_def_pass                  |double    |Drives per game on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |yardsdrive_def_pass                  |double    |Yards gained per drive on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |playsdrive_def_pass                  |double    |Plays run per drive on pass plays, with the team on defense (i.e. allowed to opponents). |
#'    |playsgame_def_pass_rank              |double    |National rank of the team's plays run per game on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |TEPA_def_pass_rank                   |double    |National rank of the team's total EPA summed over every play on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |EPAgame_def_pass_rank                |double    |National rank of the team's EPA per game (total EPA divided by games) on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |EPAplay_def_pass_rank                |double    |National rank of the team's EPA per play on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |EPAdrive_def_pass_rank               |double    |National rank of the team's EPA per drive (total EPA divided by drives) on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |early_down_EPA_def_pass_rank         |double    |National rank of the team's EPA per early-down play on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |success_def_pass_rank                |double    |National rank of the team's success rate -- the share of plays flagged as successful by EPA on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |yards_def_pass_rank                  |double    |National rank of the team's total yards gained on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |yardsplay_def_pass_rank              |double    |National rank of the team's yards gained per play on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |yardsgame_def_pass_rank              |double    |National rank of the team's yards gained per game on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |drivesgame_def_pass_rank             |double    |National rank of the team's drives per game on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |yardsdrive_def_pass_rank             |double    |National rank of the team's yards gained per drive on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |playsdrive_def_pass_rank             |double    |National rank of the team's plays run per drive on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |play_stuffed_def_pass_rank           |double    |National rank of the team's stuffed-play rate -- the share of plays carrying the stuffed flag on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |red_zone_success_def_pass_rank       |double    |National rank of the team's success rate on red-zone plays on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |third_down_success_def_pass_rank     |double    |National rank of the team's success rate on third-down plays on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |late_down_success_def_pass_rank      |double    |National rank of the team's success rate on late-down plays on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |third_down_distance_def_pass_rank    |double    |National rank of the team's average yards to go on third down on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |havoc_def_pass_rank                  |double    |National rank of the team's havoc rate -- the share of plays carrying the defensive-disruption flag on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |explosive_def_pass_rank              |double    |National rank of the team's explosive-play rate -- the share of plays carrying the explosive flag on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |passrate_def_pass_rank               |double    |National rank of the team's share of plays that were pass plays on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |rushrate_def_pass_rank               |double    |National rank of the team's share of plays that were rush plays on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |nonExplosiveEpaPerPlay_def_pass_rank |double    |National rank of the team's EPA per play with explosive plays excluded on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |line_yards_def_pass_rank             |double    |National rank of the team's average line yards credited to the offensive line on rushes on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |opportunity_rate_def_pass_rank       |double    |National rank of the team's opportunity rate -- the share of rushes carrying the opportunity flag on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |TEPA_margin_pass                     |double    |Margin in total EPA summed over every play on pass plays: the team's offensive value minus the value it allowed on defense. |
#'    |EPAplay_margin_pass                  |double    |Margin in EPA per play on pass plays: the team's offensive value minus the value it allowed on defense. |
#'    |EPAdrive_margin_pass                 |double    |Margin in EPA per drive (total EPA divided by drives) on pass plays: the team's offensive value minus the value it allowed on defense. |
#'    |EPAgame_margin_pass                  |double    |Margin in EPA per game (total EPA divided by games) on pass plays: the team's offensive value minus the value it allowed on defense. |
#'    |success_margin_pass                  |double    |Margin in success rate -- the share of plays flagged as successful by EPA on pass plays: the team's offensive value minus the value it allowed on defense. |
#'    |yardsplay_margin_pass                |double    |Margin in yards gained per play on pass plays: the team's offensive value minus the value it allowed on defense. |
#'    |TEPA_margin_pass_rank                |double    |Margin in total EPA summed over every play on pass plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |EPAplay_margin_pass_rank             |double    |Margin in EPA per play on pass plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |EPAdrive_margin_pass_rank            |double    |Margin in EPA per drive (total EPA divided by drives) on pass plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |EPAgame_margin_pass_rank             |double    |Margin in EPA per game (total EPA divided by games) on pass plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |success_margin_pass_rank             |double    |Margin in success rate -- the share of plays flagged as successful by EPA on pass plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |yardsplay_margin_pass_rank           |double    |Margin in yards gained per play on pass plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |plays_off_rush                       |integer   |Plays run on rush plays, with the team on offense. |
#'    |passrate_off_rush                    |double    |Share of plays that were pass plays on rush plays, with the team on offense. |
#'    |rushrate_off_rush                    |double    |Share of plays that were rush plays on rush plays, with the team on offense. |
#'    |havoc_off_rush                       |double    |Havoc rate -- the share of plays carrying the defensive-disruption flag on rush plays, with the team on offense. |
#'    |explosive_off_rush                   |double    |Explosive-play rate -- the share of plays carrying the explosive flag on rush plays, with the team on offense. |
#'    |TEPA_off_rush                        |double    |Total EPA summed over every play on rush plays, with the team on offense. |
#'    |EPAplay_off_rush                     |double    |EPA per play on rush plays, with the team on offense. |
#'    |yards_off_rush                       |integer   |Total yards gained on rush plays, with the team on offense. |
#'    |yardsplay_off_rush                   |double    |Yards gained per play on rush plays, with the team on offense. |
#'    |play_stuffed_off_rush                |double    |Stuffed-play rate -- the share of plays carrying the stuffed flag on rush plays, with the team on offense. |
#'    |success_off_rush                     |double    |Success rate -- the share of plays flagged as successful by EPA on rush plays, with the team on offense. |
#'    |red_zone_success_off_rush            |double    |Success rate on red-zone plays on rush plays, with the team on offense. |
#'    |third_down_success_off_rush          |double    |Success rate on third-down plays on rush plays, with the team on offense. |
#'    |third_down_distance_off_rush         |double    |Average yards to go on third down on rush plays, with the team on offense. |
#'    |late_down_success_off_rush           |double    |Success rate on late-down plays on rush plays, with the team on offense. |
#'    |early_down_EPA_off_rush              |double    |EPA per early-down play on rush plays, with the team on offense. |
#'    |nonExplosiveEpaPerPlay_off_rush      |double    |EPA per play with explosive plays excluded on rush plays, with the team on offense. |
#'    |line_yards_off_rush                  |double    |Average line yards credited to the offensive line on rushes on rush plays, with the team on offense. |
#'    |opportunity_rate_off_rush            |double    |Opportunity rate -- the share of rushes carrying the opportunity flag on rush plays, with the team on offense. |
#'    |playsgame_off_rush                   |double    |Plays run per game on rush plays, with the team on offense. |
#'    |EPAdrive_off_rush                    |double    |EPA per drive (total EPA divided by drives) on rush plays, with the team on offense. |
#'    |EPAgame_off_rush                     |double    |EPA per game (total EPA divided by games) on rush plays, with the team on offense. |
#'    |yardsgame_off_rush                   |double    |Yards gained per game on rush plays, with the team on offense. |
#'    |drives_off_rush                      |integer   |Offensive drives on rush plays, with the team on offense. |
#'    |drivesgame_off_rush                  |double    |Drives per game on rush plays, with the team on offense. |
#'    |yardsdrive_off_rush                  |double    |Yards gained per drive on rush plays, with the team on offense. |
#'    |playsdrive_off_rush                  |double    |Plays run per drive on rush plays, with the team on offense. |
#'    |playsgame_off_rush_rank              |double    |National rank of the team's plays run per game on rush plays with the team on offense, where 1 is best. |
#'    |TEPA_off_rush_rank                   |double    |National rank of the team's total EPA summed over every play on rush plays with the team on offense, where 1 is best. |
#'    |EPAgame_off_rush_rank                |double    |National rank of the team's EPA per game (total EPA divided by games) on rush plays with the team on offense, where 1 is best. |
#'    |EPAplay_off_rush_rank                |double    |National rank of the team's EPA per play on rush plays with the team on offense, where 1 is best. |
#'    |EPAdrive_off_rush_rank               |double    |National rank of the team's EPA per drive (total EPA divided by drives) on rush plays with the team on offense, where 1 is best. |
#'    |early_down_EPA_off_rush_rank         |double    |National rank of the team's EPA per early-down play on rush plays with the team on offense, where 1 is best. |
#'    |success_off_rush_rank                |double    |National rank of the team's success rate -- the share of plays flagged as successful by EPA on rush plays with the team on offense, where 1 is best. |
#'    |yards_off_rush_rank                  |double    |National rank of the team's total yards gained on rush plays with the team on offense, where 1 is best. |
#'    |yardsplay_off_rush_rank              |double    |National rank of the team's yards gained per play on rush plays with the team on offense, where 1 is best. |
#'    |yardsgame_off_rush_rank              |double    |National rank of the team's yards gained per game on rush plays with the team on offense, where 1 is best. |
#'    |drivesgame_off_rush_rank             |double    |National rank of the team's drives per game on rush plays with the team on offense, where 1 is best. |
#'    |yardsdrive_off_rush_rank             |double    |National rank of the team's yards gained per drive on rush plays with the team on offense, where 1 is best. |
#'    |playsdrive_off_rush_rank             |double    |National rank of the team's plays run per drive on rush plays with the team on offense, where 1 is best. |
#'    |play_stuffed_off_rush_rank           |double    |National rank of the team's stuffed-play rate -- the share of plays carrying the stuffed flag on rush plays with the team on offense, where 1 is best. |
#'    |red_zone_success_off_rush_rank       |double    |National rank of the team's success rate on red-zone plays on rush plays with the team on offense, where 1 is best. |
#'    |third_down_success_off_rush_rank     |double    |National rank of the team's success rate on third-down plays on rush plays with the team on offense, where 1 is best. |
#'    |late_down_success_off_rush_rank      |double    |National rank of the team's success rate on late-down plays on rush plays with the team on offense, where 1 is best. |
#'    |third_down_distance_off_rush_rank    |double    |National rank of the team's average yards to go on third down on rush plays with the team on offense, where 1 is best. |
#'    |havoc_off_rush_rank                  |double    |National rank of the team's havoc rate -- the share of plays carrying the defensive-disruption flag on rush plays with the team on offense, where 1 is best. |
#'    |explosive_off_rush_rank              |double    |National rank of the team's explosive-play rate -- the share of plays carrying the explosive flag on rush plays with the team on offense, where 1 is best. |
#'    |passrate_off_rush_rank               |double    |National rank of the team's share of plays that were pass plays on rush plays with the team on offense, where 1 is best. |
#'    |rushrate_off_rush_rank               |double    |National rank of the team's share of plays that were rush plays on rush plays with the team on offense, where 1 is best. |
#'    |nonExplosiveEpaPerPlay_off_rush_rank |double    |National rank of the team's EPA per play with explosive plays excluded on rush plays with the team on offense, where 1 is best. |
#'    |line_yards_off_rush_rank             |double    |National rank of the team's average line yards credited to the offensive line on rushes on rush plays with the team on offense, where 1 is best. |
#'    |opportunity_rate_off_rush_rank       |double    |National rank of the team's opportunity rate -- the share of rushes carrying the opportunity flag on rush plays with the team on offense, where 1 is best. |
#'    |plays_def_rush                       |integer   |Plays run on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |passrate_def_rush                    |double    |Share of plays that were pass plays on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |rushrate_def_rush                    |double    |Share of plays that were rush plays on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |havoc_def_rush                       |double    |Havoc rate -- the share of plays carrying the defensive-disruption flag on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |explosive_def_rush                   |double    |Explosive-play rate -- the share of plays carrying the explosive flag on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |TEPA_def_rush                        |double    |Total EPA summed over every play on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |EPAplay_def_rush                     |double    |EPA per play on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |yards_def_rush                       |integer   |Total yards gained on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |yardsplay_def_rush                   |double    |Yards gained per play on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |play_stuffed_def_rush                |double    |Stuffed-play rate -- the share of plays carrying the stuffed flag on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |success_def_rush                     |double    |Success rate -- the share of plays flagged as successful by EPA on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |red_zone_success_def_rush            |double    |Success rate on red-zone plays on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |third_down_success_def_rush          |double    |Success rate on third-down plays on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |third_down_distance_def_rush         |double    |Average yards to go on third down on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |late_down_success_def_rush           |double    |Success rate on late-down plays on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |early_down_EPA_def_rush              |double    |EPA per early-down play on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |nonExplosiveEpaPerPlay_def_rush      |double    |EPA per play with explosive plays excluded on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |line_yards_def_rush                  |double    |Average line yards credited to the offensive line on rushes on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |opportunity_rate_def_rush            |double    |Opportunity rate -- the share of rushes carrying the opportunity flag on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |playsgame_def_rush                   |double    |Plays run per game on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |EPAdrive_def_rush                    |double    |EPA per drive (total EPA divided by drives) on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |EPAgame_def_rush                     |double    |EPA per game (total EPA divided by games) on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |yardsgame_def_rush                   |double    |Yards gained per game on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |drives_def_rush                      |integer   |Offensive drives on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |drivesgame_def_rush                  |double    |Drives per game on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |yardsdrive_def_rush                  |double    |Yards gained per drive on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |playsdrive_def_rush                  |double    |Plays run per drive on rush plays, with the team on defense (i.e. allowed to opponents). |
#'    |playsgame_def_rush_rank              |double    |National rank of the team's plays run per game on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |TEPA_def_rush_rank                   |double    |National rank of the team's total EPA summed over every play on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |EPAgame_def_rush_rank                |double    |National rank of the team's EPA per game (total EPA divided by games) on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |EPAplay_def_rush_rank                |double    |National rank of the team's EPA per play on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |EPAdrive_def_rush_rank               |double    |National rank of the team's EPA per drive (total EPA divided by drives) on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |early_down_EPA_def_rush_rank         |double    |National rank of the team's EPA per early-down play on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |success_def_rush_rank                |double    |National rank of the team's success rate -- the share of plays flagged as successful by EPA on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |yards_def_rush_rank                  |double    |National rank of the team's total yards gained on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |yardsplay_def_rush_rank              |double    |National rank of the team's yards gained per play on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |yardsgame_def_rush_rank              |double    |National rank of the team's yards gained per game on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |drivesgame_def_rush_rank             |double    |National rank of the team's drives per game on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |yardsdrive_def_rush_rank             |double    |National rank of the team's yards gained per drive on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |playsdrive_def_rush_rank             |double    |National rank of the team's plays run per drive on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |play_stuffed_def_rush_rank           |double    |National rank of the team's stuffed-play rate -- the share of plays carrying the stuffed flag on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |red_zone_success_def_rush_rank       |double    |National rank of the team's success rate on red-zone plays on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |third_down_success_def_rush_rank     |double    |National rank of the team's success rate on third-down plays on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |late_down_success_def_rush_rank      |double    |National rank of the team's success rate on late-down plays on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |third_down_distance_def_rush_rank    |double    |National rank of the team's average yards to go on third down on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |havoc_def_rush_rank                  |double    |National rank of the team's havoc rate -- the share of plays carrying the defensive-disruption flag on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |explosive_def_rush_rank              |double    |National rank of the team's explosive-play rate -- the share of plays carrying the explosive flag on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |passrate_def_rush_rank               |double    |National rank of the team's share of plays that were pass plays on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |rushrate_def_rush_rank               |double    |National rank of the team's share of plays that were rush plays on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |nonExplosiveEpaPerPlay_def_rush_rank |double    |National rank of the team's EPA per play with explosive plays excluded on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |line_yards_def_rush_rank             |double    |National rank of the team's average line yards credited to the offensive line on rushes on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |opportunity_rate_def_rush_rank       |double    |National rank of the team's opportunity rate -- the share of rushes carrying the opportunity flag on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
#'    |TEPA_margin_rush                     |double    |Margin in total EPA summed over every play on rush plays: the team's offensive value minus the value it allowed on defense. |
#'    |EPAplay_margin_rush                  |double    |Margin in EPA per play on rush plays: the team's offensive value minus the value it allowed on defense. |
#'    |EPAdrive_margin_rush                 |double    |Margin in EPA per drive (total EPA divided by drives) on rush plays: the team's offensive value minus the value it allowed on defense. |
#'    |EPAgame_margin_rush                  |double    |Margin in EPA per game (total EPA divided by games) on rush plays: the team's offensive value minus the value it allowed on defense. |
#'    |success_margin_rush                  |double    |Margin in success rate -- the share of plays flagged as successful by EPA on rush plays: the team's offensive value minus the value it allowed on defense. |
#'    |yardsplay_margin_rush                |double    |Margin in yards gained per play on rush plays: the team's offensive value minus the value it allowed on defense. |
#'    |TEPA_margin_rush_rank                |double    |Margin in total EPA summed over every play on rush plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |EPAplay_margin_rush_rank             |double    |Margin in EPA per play on rush plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |EPAdrive_margin_rush_rank            |double    |Margin in EPA per drive (total EPA divided by drives) on rush plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |EPAgame_margin_rush_rank             |double    |Margin in EPA per game (total EPA divided by games) on rush plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |success_margin_rush_rank             |double    |Margin in success rate -- the share of plays flagged as successful by EPA on rush plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |yardsplay_margin_rush_rank           |double    |Margin in yards gained per play on rush plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
#'    |fbs_class                            |character |Power/Group classification for the season: P4 or G6 from 2024 on, P5 or G5 through 2023, derived from conference membership (Notre Dame is classified with the power group). Null for teams outside FBS. |
#'    |valid_games                          |integer   |Number of the team's games that produced both an offensive and a defensive adjusted-EPA value; teams below two valid games are dropped from the adjusted ratings. |
#'    |adj_off_epa                          |double    |Offensive opponent-adjusted EPA per play from the ridge (RAPM-style) regression on offense/defense team indicators plus home field -- cfbfastR's adjust_epa adjustment, fit in-sample across the season, so the value is descriptive of that window rather than predictive. |
#'    |adj_def_epa                          |double    |Defensive opponent-adjusted EPA per play from the ridge (RAPM-style) regression on offense/defense team indicators plus home field -- cfbfastR's adjust_epa adjustment, fit in-sample across the season, so the value is descriptive of that window rather than predictive. Lower is better -- it is EPA allowed. |
#'    |off_strength_faced                   |double    |Average opponent-defense strength the team's offense faced, taken as the mean of the ridge's defensive coefficients across its opponents. Higher means a tougher slate. |
#'    |def_strength_faced                   |double    |Average opponent-offense strength the team's defense faced, taken as the mean of the ridge's offensive coefficients across its opponents. Higher means a tougher slate. |
#'    |net_adj_epa                          |double    |Net opponent-adjusted EPA per play: adj_off_epa minus adj_def_epa. Higher is better. |
#'    |adj_off_epa_rank                     |double    |National rank of the team's adj_off_epa, where 1 is best. |
#'    |adj_def_epa_rank                     |double    |National rank of the team's adj_def_epa, where 1 is best (fewest EPA allowed). |
#'    |net_adj_epa_rank                     |double    |National rank of the team's net_adj_epa, 1 = largest net adjusted EPA. |
#'    |through_week                         |integer   |Regular-season week this cumulative snapshot covers -- the row reflects the team's state through the end of that week. One asset holds every week, so filter on this column. |
#'
#' @examples
#' \donttest{
#'   try(load_cfb_team_summaries_weekly(2004))
#' }
#' @export
load_cfb_team_summaries_weekly <- function(seasons = most_recent_cfb_season(), ...,
                                           dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- rds_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "cfb_team_summaries_weekly/cfb_team_summaries_weekly_", seasons, ".rds")

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
      make_cfbfastR_data("college football weekly team summaries from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football team talent composite from the SportsDataverse data repo**
#' @name load_cfb_team_talent
NULL
#' @title
#' **Load college football team talent composite from the SportsDataverse data repo**
#' @rdname load_cfb_team_talent
#' @author Saiem Gilani
#' @description
#'   Loads the 247Sports team talent composite -- one row per team-season.
#'   Published to the
#'   `cfb_team_talent` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2005 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2005)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name         |types     |description |
#'    |-----------------|----------|:-----------|
#'    |season           |integer   | |
#'    |team_id          |integer   | |
#'    |team             |character | |
#'    |talent_composite |double    | |
#'    |talent_rank      |integer   | |
#'    |blue_chip_ratio  |double    | |
#'    |n_recruits       |integer   | |
#'
#' @examples
#' \donttest{
#'   try(load_cfb_team_talent(2005))
#' }
#' @export
load_cfb_team_talent <- function(seasons = most_recent_cfb_season(), ...,
                                 dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- parquet_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2005:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2005),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "cfb_team_talent/cfb_team_talent_", seasons, ".parquet")

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
      make_cfbfastR_data("college football team talent composite from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football recruiting rankings from the SportsDataverse data repo**
#' @name load_cfb_recruits
NULL
#' @title
#' **Load college football recruiting rankings from the SportsDataverse data repo**
#' @rdname load_cfb_recruits
#' @author Saiem Gilani
#' @description
#'   Loads player recruiting rankings -- one row per recruit-season with
#'   stars, rating, position, and school commitment. Published to the
#'   `cfb_recruits` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2002 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2002)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name    |types     |description |
#'    |------------|----------|:-----------|
#'    |season      |integer   | |
#'    |team_id     |integer   | |
#'    |team_id_247 |character | |
#'    |team        |character | |
#'    |recruit_id  |character | |
#'    |player_name |character | |
#'    |stars       |integer   | |
#'    |grade       |double    | |
#'    |position    |character | |
#'
#' @examples
#' \donttest{
#'   try(load_cfb_recruits(2002))
#' }
#' @export
load_cfb_recruits <- function(seasons = most_recent_cfb_season(), ...,
                              dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- parquet_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2002:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2002),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "cfb_recruits/cfb_recruits_", seasons, ".parquet")

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
      make_cfbfastR_data("college football recruiting rankings from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football recruiting projections from the SportsDataverse data repo**
#' @name load_cfb_recruiting_proj
NULL
#' @title
#' **Load college football recruiting projections from the SportsDataverse data repo**
#' @rdname load_cfb_recruiting_proj
#' @author Saiem Gilani
#' @description
#'   Loads recruiting-based team projections -- one row per team-season with
#'   talent-derived projection inputs. Published to the
#'   `cfb_recruiting_proj` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2016 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2016)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name     |types   |description |
#'    |-------------|--------|:-----------|
#'    |season       |integer | |
#'    |team_id      |integer | |
#'    |pred_wins    |double  |Ridge projection of the team's season win total, fit strictly on prior seasons from talent composite, blue-chip ratio, offensive and defensive returning production, and prior wins. |
#'    |pred_margin  |double  |Ridge projection of the team's average per-game scoring margin, from the same preseason-known feature set as pred_wins. |
#'    |pred_net_epa |double  |Reserved slot for a projected adjusted net EPA; it ships all-null because the adjusted-EPA training target is not currently loadable. |
#'
#' @examples
#' \donttest{
#'   try(load_cfb_recruiting_proj(2016))
#' }
#' @export
load_cfb_recruiting_proj <- function(seasons = most_recent_cfb_season(), ...,
                                     dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- parquet_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2016:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2016),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "cfb_recruiting_proj/cfb_recruiting_proj_", seasons, ".parquet")

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
      make_cfbfastR_data("college football recruiting projections from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football returning production from the SportsDataverse data repo**
#' @name load_cfb_returning_production
NULL
#' @title
#' **Load college football returning production from the SportsDataverse data repo**
#' @rdname load_cfb_returning_production
#' @author Saiem Gilani
#' @description
#'   Loads returning production shares -- one row per team-season with the
#'   share of prior-season production returning, overall and by unit.
#'   Published to
#'   the `cfb_returning_production` release tag on the sportsdataverse-data
#'   repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2005 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2005)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name          |types   |description |
#'    |------------------|--------|:-----------|
#'    |season            |integer | |
#'    |team_id           |integer | |
#'    |off_returning     |double  | |
#'    |def_returning     |double  | |
#'    |overall_returning |double  | |
#'    |n_returning       |integer | |
#'
#' @examples
#' \donttest{
#'   try(load_cfb_returning_production(2005))
#' }
#' @export
load_cfb_returning_production <- function(seasons = most_recent_cfb_season(), ...,
                                          dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- parquet_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2005:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2005),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "cfb_returning_production/cfb_returning_production_", seasons, ".parquet")

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
      make_cfbfastR_data("college football returning production from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football schedule id crosswalk from the SportsDataverse data repo**
#' @name load_cfb_schedule_crosswalk
NULL
#' @title
#' **Load college football schedule id crosswalk from the SportsDataverse data repo**
#' @rdname load_cfb_schedule_crosswalk
#' @author Saiem Gilani
#' @description
#'   Loads the game-level id crosswalk linking CFBD game ids to ESPN event
#'   ids -- one row per game-season. Published to the
#'   `cfb_crosswalk` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2014 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2014)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name             |types     |description |
#'    |---------------------|----------|:-----------|
#'    |matchup_key          |character |Order-independent key for the game: the two normalized team names sorted alphabetically and joined with a pipe. |
#'    |espn_game_id         |integer   |ESPN game id for the crosswalk row. |
#'    |fox_game_id          |character |Fox Sports game id for the same game. |
#'    |yahoo_game_id        |character |Yahoo Sports game id for the same game. |
#'    |yahoo_global_game_id |character |Yahoo's cross-season global game key in `ncaaf.g.NNNN` form, distinct from the date-encoded yahoo_game_id. |
#'    |home_team            |character | |
#'    |away_team            |character | |
#'    |espn_date            |character |Kickoff date as YYYY-MM-DD taken from ESPN's schedule, null on games that matched no ESPN row. |
#'    |fox_date             |character |Kickoff date as YYYY-MM-DD taken from the Fox Sports schedule, null on games that matched no Fox row. |
#'    |yahoo_date           |character |Kickoff date as YYYY-MM-DD, parsed from Yahoo's RFC-2822 start_time string. |
#'    |matched_sources      |character |Plus-joined provenance tag naming which of espn, fox, and yahoo actually supplied a row for this game. |
#'
#' @examples
#' \donttest{
#'   try(load_cfb_schedule_crosswalk(2014))
#' }
#' @export
load_cfb_schedule_crosswalk <- function(seasons = most_recent_cfb_season(), ...,
                                        dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- parquet_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2014:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2014),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "cfb_crosswalk/cfb_schedule_crosswalk_", seasons, ".parquet")

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
      make_cfbfastR_data("college football schedule id crosswalk from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football team id crosswalk from the SportsDataverse data repo**
#' @name load_cfb_teams_crosswalk
NULL
#' @title
#' **Load college football team id crosswalk from the SportsDataverse data repo**
#' @rdname load_cfb_teams_crosswalk
#' @author Saiem Gilani
#' @description
#'   Loads the team-level id crosswalk linking CFBD team ids to ESPN team
#'   ids -- one row per team-season. Published to the
#'   `cfb_crosswalk` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2014 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2014)
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name           |types     |description |
#'    |-------------------|----------|:-----------|
#'    |norm_key           |character |Shared join key across providers: the team name lowercased, ASCII-folded, stripped of punctuation, whitespace-collapsed, and alias-mapped. |
#'    |espn_team_id       |integer   |ESPN team id for the crosswalk row. |
#'    |espn_team          |character |ESPN's full team display name, school plus mascot, null when the row was anchored on a non-ESPN provider. |
#'    |espn_abbreviation  |character | |
#'    |fox_team_id        |character |Fox Sports team id for the same team. |
#'    |fox_team           |character |Fox Sports' team name, which that feed ships in all capitals. |
#'    |fox_abbreviation   |character |Fox Sports' short team code, which frequently differs from the ESPN abbreviation for the same school. |
#'    |yahoo_team_id      |character |Yahoo Sports team id for the same team. |
#'    |yahoo_team         |character |Yahoo Sports' team display name, school plus mascot. |
#'    |yahoo_abbreviation |character |Yahoo Sports' short team code for the school. |
#'    |matched_sources    |character |Plus-joined provenance tag naming which of espn, fox, and yahoo contributed a directory row for this team. |
#'
#' @examples
#' \donttest{
#'   try(load_cfb_teams_crosswalk(2014))
#' }
#' @export
load_cfb_teams_crosswalk <- function(seasons = most_recent_cfb_season(), ...,
                                     dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  loader <- parquet_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) seasons <- 2014:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2014),
            all(seasons <= most_recent_cfb_season()))

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "cfb_crosswalk/cfb_teams_crosswalk_", seasons, ".parquet")

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
      make_cfbfastR_data("college football team id crosswalk from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football roster id crosswalk from the SportsDataverse data repo**
#' @name load_cfb_rosters_crosswalk
NULL
#' @title
#' **Load college football roster id crosswalk from the SportsDataverse data repo**
#' @rdname load_cfb_rosters_crosswalk
#' @author Saiem Gilani
#' @description
#'   Loads the roster-level id crosswalk linking CFBD athlete ids to ESPN
#'   athlete ids across seasons. Single cumulative file (not season-
#'   partitioned). Published to the `cfb_crosswalk` release tag on the
#'   sportsdataverse-data repo.
#' @param ... Additional arguments passed to an underlying function that
#'   writes the season data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble.
#'
#'    |col_name         |types     |description |
#'    |-----------------|----------|:-----------|
#'    |espn_team_id     |integer   | |
#'    |fox_team_id      |character | |
#'    |person_key       |character | |
#'    |espn_athlete_id  |integer   | |
#'    |fox_athlete_id   |character | |
#'    |yahoo_athlete_id |character | |
#'    |name             |character | |
#'    |espn_jersey      |character | |
#'    |fox_jersey       |character | |
#'    |espn_position    |character | |
#'    |fox_position     |character | |
#'    |yahoo_position   |character | |
#'    |match_method     |character | |
#'    |matched_sources  |character | |
#'
#' @examples
#' \donttest{
#'   try(load_cfb_rosters_crosswalk())
#' }
#' @export
load_cfb_rosters_crosswalk <- function(...,
                                       dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)
  dots <- rlang::dots_list(...)

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  url <- "https://github.com/sportsdataverse/sportsdataverse-data/releases/download/cfb_crosswalk/cfb_rosters_crosswalk.parquet"
  out <- parquet_from_url(url)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("college football roster id crosswalk from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}
