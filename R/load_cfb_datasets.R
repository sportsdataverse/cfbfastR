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
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.frame")
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
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.frame")
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
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.frame")
    out <- out |>
      make_cfbfastR_data("college football weekly ESPN FPI ratings from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' @rdname load_espn_cfb_team_summaries
#' @order 2
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
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.frame")
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
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.frame")
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
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.frame")
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
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.frame")
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
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published coverage runs 2004 through the most recent season. Pass `seasons = TRUE` for every published season. (Min: 2004)
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

  if (isTRUE(seasons)) seasons <- 2004:most_recent_cfb_season()

  stopifnot(is.numeric(seasons),
            all(seasons >= 2004),
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
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.frame")
    out <- out |>
      make_cfbfastR_data("college football returning production from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


# The cfb_crosswalk tag publishes schedule/teams files for 2004, 2010 and
# 2013 onward only; a plain floor would admit the missing 2005-2009/2011-2012.
cfb_crosswalk_seasons <- function() c(2004, 2010, 2013:most_recent_cfb_season())

#' **Load college football schedule id crosswalk from the SportsDataverse data repo**
#' @name load_cfb_schedule_crosswalk
NULL
#' @title
#' **Load college football schedule id crosswalk from the SportsDataverse data repo**
#' @rdname load_cfb_schedule_crosswalk
#' @author Saiem Gilani
#' @description
#'   Loads the game-level id crosswalk linking ESPN, Fox Sports, and Yahoo
#'   Sports game ids -- one row per game in each season's file. The files
#'   carry no `season` column and no CFBD game id. Published to the
#'   `cfb_crosswalk` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published seasons are 2004, 2010, and 2013 through the most recent season (no files exist for 2005-2009 or 2011-2012). Pass `seasons = TRUE` for every published season. (Min: 2004)
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

  if (isTRUE(seasons)) seasons <- cfb_crosswalk_seasons()

  stopifnot(is.numeric(seasons),
            all(seasons %in% cfb_crosswalk_seasons()),
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
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.frame")
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
#'   Loads the team-level id crosswalk linking ESPN, Fox Sports, and Yahoo
#'   Sports team ids, matched on a normalized team name (`norm_key`). One row
#'   per team in each season's file, including teams below FCS. The files
#'   carry no `season` column and no CFBD team id. Published to the
#'   `cfb_crosswalk` release tag on the sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college football seasons. Published seasons are 2004, 2010, and 2013 through the most recent season (no files exist for 2005-2009 or 2011-2012). Pass `seasons = TRUE` for every published season. (Min: 2004)
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
#'    |espn_abbreviation  |character |ESPN's short team code for the school. |
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

  if (isTRUE(seasons)) seasons <- cfb_crosswalk_seasons()

  stopifnot(is.numeric(seasons),
            all(seasons %in% cfb_crosswalk_seasons()),
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
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.frame")
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
#'   Loads the roster-level id crosswalk linking ESPN, Fox Sports, and Yahoo
#'   Sports athlete ids. A single snapshot of current rosters, not a
#'   per-season series: the providers' roster endpoints only expose the
#'   current roster. It carries no CFBD athlete id. Published to the
#'   `cfb_crosswalk` release tag on the sportsdataverse-data repo.
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
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.frame")
    out <- out |>
      make_cfbfastR_data("college football roster id crosswalk from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}
