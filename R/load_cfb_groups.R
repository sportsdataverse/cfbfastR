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
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.frame")
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
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.frame")
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
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.frame")
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
              all(seasons >= 1869),
              all(seasons == trunc(seasons)))
    files <- paste0("cfb_team_group_seasons_", unique(seasons))
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
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.frame")
    out <- out |>
      make_cfbfastR_data("college football team conference membership by season from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}
#' @name load_cfb_team_aliases
NULL
#' @title
#' **Load college football provider team id and name aliases from the SportsDataverse data repo**
#' @rdname load_cfb_team_aliases
#' @author Saiem Gilani
#' @description
#'   Loads every team id and name another source uses for an ESPN college
#'   football team, with the seasons the source shows it on that team. Use it
#'   to map a Fox, Yahoo, CBS, CFBD, 247Sports or On3 team id or name onto the
#'   ESPN `team_id`. A source id means something only within its source (Fox
#'   25 is Ohio State, ESPN 25 is California), so always join on `source` as
#'   well. Published to the `cfb_groups` release tag on the
#'   sportsdataverse-data repo.
#'
#'   See [load_cfb_player_aliases()] for player ids and
#'   [load_cfb_group_aliases()] for conference and division aliases.
#' @inheritParams load_cfb_groups
#' @return Returns a `cfbfastR_data` tibble with one row per team alias, or `NULL` after
#'   appending the rows to `tablename` when `dbConnection` and `tablename` are both given.
#'
#'    |col_name       |types     |description |
#'    |---------------|----------|:-----------|
#'    |league         |character |League key, always `cfb`. |
#'    |team_id        |character |ESPN team id. |
#'    |team_id_source |character |Id system of `team_id`: `espn`. |
#'    |source         |character |Source that uses the alias: `fox`, `yahoo`, `cbs`, `cfbd`, `sports247` (247Sports) or `on3`. |
#'    |source_id      |character |The source's own team id (CFBD team ids are ESPN ids). |
#'    |id_kind        |character |`team` (the source's id for this sport's team) or `school` (one id for every sport of a school: 247Sports `institutionKey`, On3 `orgKey`). |
#'    |name_kind      |character |`name` or `abbreviation` when the source gives its own spelling, else `NA`. An id with a name and an abbreviation is two rows. |
#'    |value          |character |The source's own spelling of the name or abbreviation; `NA` when `name_kind` is `NA`. |
#'    |valid_from     |integer   |First season (fall year) the source shows this id or name on the team, inclusive; `NA` for an undated curated map (CBS). |
#'    |valid_to       |integer   |Last season (fall year) the source shows this id or name on the team, inclusive; `NA` for an undated curated map (CBS). A gap in the source splits the window into two rows. |
#'    |match_method   |character |How the row was matched: `deterministic` (a shared key: CFBD ids are ESPN ids), `crosswalk` (carried from a published crosswalk), `curated` (a cited hand-made map); for a captured team directory, `alias`, `exact_name` (normalized name) or `dict` (curated name dictionary). |
#'    |evidence       |character |The asset or file the row came from. |
#'
#' @examples
#' \donttest{
#'   try(load_cfb_team_aliases())
#' }
#' @export
load_cfb_team_aliases <- function(..., dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  url <- "https://github.com/sportsdataverse/sportsdataverse-data/releases/download/cfb_groups/cfb_team_aliases.parquet"
  out <- parquet_from_url(url)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.frame")
    out <- out |>
      make_cfbfastR_data("college football provider team id and name aliases from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}
#' @name load_cfb_player_aliases
NULL
#' @title
#' **Load college football provider player id aliases from the SportsDataverse data repo**
#' @rdname load_cfb_player_aliases
#' @author Saiem Gilani
#' @description
#'   Loads every player id another source uses for an ESPN college football
#'   athlete, with the ESPN team the athlete was on and the seasons the id
#'   held. Use it to map an NCAA (stats.ncaa.org), CBS, Yahoo or Fox player id
#'   onto the ESPN `athlete_id`. stats.ncaa.org roster ids are new every
#'   season, so an NCAA player has one row per season. Unmatched provider ids
#'   are not included. Published to the `cfb_groups` release tag on the
#'   sportsdataverse-data repo.
#'
#'   See [load_cfb_team_aliases()] for team ids and names.
#' @inheritParams load_cfb_groups
#' @return Returns a `cfbfastR_data` tibble with one row per player alias, or `NULL` after
#'   appending the rows to `tablename` when `dbConnection` and `tablename` are both given.
#'
#'    |col_name          |types     |description |
#'    |------------------|----------|:-----------|
#'    |league            |character |League key, always `cfb`. |
#'    |athlete_id        |character |ESPN athlete id. |
#'    |athlete_id_source |character |Id system of `athlete_id`: `espn`. |
#'    |source            |character |Source of the player id: `ncaa`, `cbs`, `yahoo` or `fox`. |
#'    |source_player_id  |character |The source's own player id. |
#'    |team_id           |character |ESPN team id of the team the athlete was on when matched. |
#'    |source_team_id    |character |The source's own team id when it gives one (the season's stats.ncaa.org team id), else `NA`. |
#'    |valid_from        |integer   |First season (fall year) the id is on that team, inclusive. |
#'    |valid_to          |integer   |Last season (fall year) the id is on that team, inclusive; a gap or a change of match method splits the window into two rows. |
#'    |match_method      |character |How the id was matched: the source leg's own method (NCAA `name_jersey`, `name`, `last_jersey`, `jaro_winkler`; CFB rosters `name`), `crosswalk` (a leg that names none), `propagated` (carried from the same id's match in another season) or `override` (a hand-verified fix). |
#'    |match_confidence  |numeric   |The leg's own confidence where it gives one (the lowest in the window; NCAA tiers score 1, 0.95, 0.9 and 0.85), else `NA`. |
#'    |evidence          |character |The asset or file the row came from. |
#'
#' @examples
#' \donttest{
#'   try(load_cfb_player_aliases())
#' }
#' @export
load_cfb_player_aliases <- function(..., dbConnection = NULL, tablename = NULL) {
  old <- options(list(stringsAsFactors = FALSE, scipen = 999))
  on.exit(options(old), add = TRUE)

  if (!is.null(dbConnection) && !is.null(tablename)) in_db <- TRUE else in_db <- FALSE

  url <- "https://github.com/sportsdataverse/sportsdataverse-data/releases/download/cfb_groups/cfb_player_aliases.parquet"
  out <- parquet_from_url(url)
  if (in_db) {
    DBI::dbWriteTable(dbConnection, tablename, out, append = TRUE, ...)
    out <- NULL
  } else {
    class(out) <- c("cfbfastR_data", "tbl_df", "tbl", "data.frame")
    out <- out |>
      make_cfbfastR_data("college football provider player id aliases from the SportsDataverse data repo", Sys.time())
  }
  return(out)
}
