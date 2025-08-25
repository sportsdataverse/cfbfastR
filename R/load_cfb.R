#' Load CFB Game/Schedule Data from data repo
#'
#' @description This function returns game/schedule information for the specified season(s).
#' This function wraps the `cfbd_game_info()` function sourced from the College Football Data API.
#'
#' @param seasons a numeric vector of seasons to return, default `TRUE` returns all available data.
#'
#' @return A tibble of game information for past and/or future games.
#'
#' @seealso [cfbd_game_info()]
#' @seealso Issues with this data should be filed here: <https://github.com/sportsdataverse/cfbfastR-data>
#' @family loaders
#' @examples
#' \donttest{
#'   try(load_cfb_schedules(2024))
#' }
#'
#' @export
load_cfb_schedules <- function(seasons = most_recent_cfb_season()){

  current_year <- most_recent_cfb_season()
  if (isTRUE(seasons)) seasons <- 2001:current_year
  stopifnot(is.numeric(seasons),
            seasons >= 2001,
            seasons <= current_year)

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- purrr::map_dfr(seasons, progressively(cfbd_game_info, p = p))

  class(out) <- c("cfbfastR_data","tbl_df","tbl","data.table","data.frame")
  attr(out,"cfbfastR_type") <- "Games and schedules from CollegeFootballData.com"
  # change this later when data in repo has attributes
  if (is.null(attr(out,"cfbfastR_timestamp"))) {
    out <- out %>%
      make_cfbfastR_data("Games and schedules from CollegeFootballData.com",Sys.time())
  }
  out
}


#' Load College Football Rosters
#'
#' @description Loads team rosters for specified seasons.
#' This function wraps the `cfbd_team_roster()` function sourced from the College Football Data API.
#'
#' @param seasons a numeric vector of seasons to return, defaults to returning
#' this year's data if it is September or later. If set to `TRUE`, will return all available data.
#'
#' @examples
#' \donttest{
#'   try(load_cfb_rosters(2024))
#' }
#'
#' @return A tibble of season-level roster data.
#'
#' @seealso [cfbd_team_roster()]
#' @seealso Issues with this data should be filed here: <https://github.com/sportsdataverse/cfbfastR-data>
#' @family loaders
#' @export
load_cfb_rosters <- function(seasons = most_recent_cfb_season()){

  current_year <- most_recent_cfb_season()
  if (isTRUE(seasons)) seasons <- 2001:current_year
  stopifnot(is.numeric(seasons),
            seasons >= 2001,
            seasons <= current_year)

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  out <- purrr::map_dfr(seasons, progressively(cfbd_team_roster, p = p))

  # out <- lapply(urls, progressively(rds_from_url, p))
  # out <- rbindlist_with_attrs(out)
  class(out) <- c("cfbfastR_data","tbl_df","tbl","data.table","data.frame")
  # change this later when data in repo has attributes
  if (is.null(attr(out,"cfbfastR_timestamp"))) {
    out <- out %>%
      make_cfbfastR_data("Team roster data from CollegeFootballData.com",Sys.time())
  }
  out
}

#' Load CFB team info from the data repo
#'
#' @description Loads team information including colors and logos - useful for plots!
#' This function wraps the `cfbd_team_info()` function sourced from the College Football Data API.
#'
#' @param fbs_only if TRUE, returns only FBS teams, otherwise returns all teams in the dataset
#'
#' @examples
#' \donttest{
#'   try(load_cfb_teams())
#' }
#'
#' @return A tibble of team-level image URLs and hex color codes.
#'
#' @seealso [cfbd_team_info()]
#' @seealso Issues with this data should be filed here: <https://github.com/sportsdataverse/cfbfastR-data>
#' @family loaders
#'
#' @export
load_cfb_teams <- function(fbs_only = TRUE){
  stopifnot(is.logical(fbs_only),
            length(fbs_only) == 1,
            !is.na(fbs_only))

  out <- cfbd_team_info(only_fbs=fbs_only)

  class(out) <- c("cfbfastR_data","tbl_df","tbl","data.table","data.frame")
  attr(out,"cfbfastR_type") <- "Team information from CollegeFootballData.com"
  out
}
