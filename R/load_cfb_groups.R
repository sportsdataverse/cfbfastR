# Conference / division group loaders for the `cfb_groups` release tag on
# sportsdataverse-data, published by sportsdataverse/sdv-reference-data (table
# contract: that repo's CONTRACT.md). Parquet only -- the tag's csv siblings
# would re-type the character ids ("150") as integers. Same shape as the
# load_cfb_datasets.R loaders.

#' **Load college football conference and division lineages from the SportsDataverse data repo**
#' @name load_cfb_groups
NULL
#' @title
#' **Load college football conference and division lineages from the SportsDataverse data repo**
#' @rdname load_cfb_groups
#' @author Saiem Gilani
#' @description
#'   Loads one row per college football group lineage -- the FBS / FCS
#'   subdivisions, the conferences, and the conference divisions -- with the
#'   first and last season each had at least one member. A lineage keeps one
#'   `group_id` across renames that keep continuity (Pac-10 to Pac-12 stays
#'   `cfb:pac-12`); a new body gets a new id. Published to the `cfb_groups`
#'   release tag on the sportsdataverse-data repo.
#'
#'   See [load_cfb_group_seasons()] for per-season names and parents,
#'   [load_cfb_group_aliases()] for the names and ids other sources use, and
#'   [load_cfb_team_group_seasons()] for team membership.
#' @param ... Additional arguments passed to an underlying function that
#'   writes the data into a database.
#' @param dbConnection A `DBIConnection` object, as returned by [DBI::dbConnect()]
#' @param tablename The name of the data table within the database
#' @return Returns a `cfbfastR_data` tibble with one row per group lineage.
#'
#'    |col_name     |types     |description |
#'    |-------------|----------|:-----------|
#'    |league       |character |League key, always `cfb`. |
#'    |group_id     |character |SDV group id, `cfb:{slug}` (e.g. `cfb:big-ten`, `cfb:fbs`); one id per lineage across renames. |
#'    |level        |character |Group level: `subdivision`, `conference`, or `division`. |
#'    |first_season |integer   |First season (fall year) with at least one member. |
#'    |last_season  |integer   |Last season (fall year) with at least one member. |
#'    |notes        |character |Lineage decisions and source caveats. |
#'
#' @examples
#' \donttest{
#'   try(load_cfb_groups())
#' }
#' @export
load_cfb_groups <- function(..., dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  url <- "https://github.com/sportsdataverse/sportsdataverse-data/releases/download/cfb_groups/cfb_groups.parquet"
  out <- parquet_from_url(url)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("college football conference and division lineages from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football conference and division names by season from the SportsDataverse data repo**
#' @name load_cfb_group_seasons
NULL
#' @title
#' **Load college football conference and division names by season from the SportsDataverse data repo**
#' @rdname load_cfb_group_seasons
#' @author Saiem Gilani
#' @description
#'   Loads one row per college football group per season it existed, with the
#'   group's name, short name, abbreviation, and parent group **as of that
#'   season** rather than today's labels, plus its member count. Published to
#'   the `cfb_groups` release tag on the sportsdataverse-data repo.
#' @inheritParams load_cfb_groups
#' @return Returns a `cfbfastR_data` tibble with one row per group-season.
#'
#'    |col_name        |types     |description |
#'    |----------------|----------|:-----------|
#'    |league          |character |League key, always `cfb`. |
#'    |group_id        |character |SDV group id, `cfb:{slug}`. |
#'    |season          |integer   |Season (fall year; 2025 = fall 2025). |
#'    |level           |character |Group level: `subdivision`, `conference`, or `division`. |
#'    |name            |character |Group name as of that season. |
#'    |short_name      |character |Group short name as of that season. |
#'    |abbreviation    |character |Group abbreviation as of that season. |
#'    |parent_group_id |character |Parent group id as of that season (division to conference to subdivision). |
#'    |n_teams         |integer   |Number of member teams that season. |
#'
#' @examples
#' \donttest{
#'   try(load_cfb_group_seasons())
#' }
#' @export
load_cfb_group_seasons <- function(..., dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  url <- "https://github.com/sportsdataverse/sportsdataverse-data/releases/download/cfb_groups/cfb_group_seasons.parquet"
  out <- parquet_from_url(url)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("college football conference and division names by season from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football conference and division aliases from the SportsDataverse data repo**
#' @name load_cfb_group_aliases
NULL
#' @title
#' **Load college football conference and division aliases from the SportsDataverse data repo**
#' @rdname load_cfb_group_aliases
#' @author Saiem Gilani
#' @description
#'   Loads every name and id that a source (ESPN, CFBD, SDV) uses for a college
#'   football group, with the seasons each alias is valid for. Use it to map a
#'   source's conference id or name onto an SDV `group_id`. Published to the
#'   `cfb_groups` release tag on the sportsdataverse-data repo.
#' @inheritParams load_cfb_groups
#' @return Returns a `cfbfastR_data` tibble with one row per alias.
#'
#'    |col_name   |types     |description |
#'    |-----------|----------|:-----------|
#'    |league     |character |League key, always `cfb`. |
#'    |group_id   |character |SDV group id, `cfb:{slug}`. |
#'    |source     |character |Source that uses the alias: `espn`, `cfbd`, or `sdv`. |
#'    |source_id  |character |The source's own id for the group (e.g. ESPN group id, CFBD conference id), when it has one. |
#'    |name_kind  |character |Kind of alias: `name`, `short_name`, `abbreviation`, `slug`, or `code`. |
#'    |value      |character |The alias itself. |
#'    |valid_from |integer   |First season the alias applies (inclusive); `NA` means unbounded. |
#'    |valid_to   |integer   |Last season the alias applies (inclusive); `NA` means unbounded. |
#'
#' @examples
#' \donttest{
#'   try(load_cfb_group_aliases())
#' }
#' @export
load_cfb_group_aliases <- function(..., dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  url <- "https://github.com/sportsdataverse/sportsdataverse-data/releases/download/cfb_groups/cfb_group_aliases.parquet"
  out <- parquet_from_url(url)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("college football conference and division aliases from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}


#' **Load college football team conference membership by season from the SportsDataverse data repo**
#' @name load_cfb_team_group_seasons
NULL
#' @title
#' **Load college football team conference membership by season from the SportsDataverse data repo**
#' @rdname load_cfb_team_group_seasons
#' @author Saiem Gilani
#' @description
#'   Loads one row per college football team per season with the team's
#'   subdivision, conference, and division that season, taken from the most
#'   reliable per-season source and cross-checked against a second source
#'   where one exists. Membership is never back-filled from today's
#'   alignment. Published to the `cfb_groups` release tag on the
#'   sportsdataverse-data repo.
#' @param seasons A vector of 4-digit years associated with given college
#'   football seasons (fall year). Published coverage runs 1869 through the
#'   most recent season; 1871, when no intercollegiate games were played, has
#'   no file. Pass `seasons = TRUE` to read every published season from one file. (Min: 1869)
#' @inheritParams load_cfb_groups
#' @return Returns a `cfbfastR_data` tibble with one row per team-season.
#'
#'    |col_name       |types     |description |
#'    |---------------|----------|:-----------|
#'    |league         |character |League key, always `cfb`. |
#'    |season         |integer   |Season (fall year; 2025 = fall 2025). |
#'    |team_id        |character |ESPN team id where ESPN covers the team, otherwise the CFBD team id (see `team_id_source`). |
#'    |team_id_source |character |Id system of `team_id`: `espn` or `cfbd`. |
#'    |team_name      |character |Team name as of that season. |
#'    |subdivision_id |character |SDV group id of the subdivision (`cfb:fbs`, `cfb:fcs`, ...); `NA` where it does not apply. |
#'    |conference_id  |character |SDV group id of the conference. |
#'    |division_id    |character |SDV group id of the conference division; `NA` where the conference had none. |
#'    |source         |character |Source the membership came from: `espn` or `cfbd`. |
#'    |sources_agree  |logical   |Whether a second source agrees; `NA` when only one source covers the season. |
#'    |notes          |character |Membership caveats. |
#'
#' @examples
#' \donttest{
#'   try(load_cfb_team_group_seasons(2024))
#' }
#' @export
load_cfb_team_group_seasons <- function(seasons = most_recent_cfb_season(), ...,
                                        dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)

  loader <- parquet_from_url

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  if (isTRUE(seasons)) {
    # the release's single all-seasons file
    files <- "cfb_team_group_seasons"
  } else {
    stopifnot(is.numeric(seasons),
              all(seasons >= 1869))
    files <- paste0("cfb_team_group_seasons_", seasons)
  }

  urls <- paste0("https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
                 "cfb_groups/", files, ".parquet")

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = urls)

  out <- lapply(urls, progressively(loader, p))
  out <- data.table::rbindlist(out, use.names = TRUE, fill = TRUE)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.table", "data.frame")
    out <- out |>
      make_cfbfastR_data("college football team conference membership by season from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}
