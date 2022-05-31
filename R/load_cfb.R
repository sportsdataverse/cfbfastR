#' Load CFB Game/Schedule Data from data repo
#'
#' This returns game/schedule information
#'
#' @param seasons a numeric vector of seasons to return, default `TRUE` returns all available data.
#'
#' @return A tibble of game information for past and/or future games.
#'
#' @seealso [cfbd_game_info()]
#' @seealso Issues with this data should be filed here: <https://github.com/sportsdataverse/cfbfastR-data>
#'
#' @examples
#' \donttest{
#'   try(load_cfb_schedules(2020))
#' }
#'
#' @export
load_cfb_schedules <- function(seasons = most_recent_cfb_season()){

  current_year <- most_recent_cfb_season()
  if(isTRUE(seasons)) seasons <- 2001:current_year
  stopifnot(is.numeric(seasons),
            seasons >= 2001,
            seasons <= current_year)

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  urls <- paste0("https://github.com/sportsdataverse/cfbfastR-data/raw/main/schedules/rds/cfb_schedules_",
                 seasons, ".rds")

  # out <- purrr::map_dfr(urls, progressively(rds_from_url, p = p))

  out <- lapply(urls, progressively(rds_from_url, p))
  out <- rbindlist_with_attrs(out)
  class(out) <- c("cfbfastR_data","tbl_df","tbl","data.table","data.frame")
  attr(out,"cfbfastR_type") <- "Games and schedules from data repository"
  # change this later when data in repo has attributes
  if(is.null(attr(out,"cfbfastR_timestamp"))) {
    out <- out %>%
      make_cfbfastR_data("Games and schedules from data repository",Sys.time())
  }
  out
}


#' Load College Football Rosters
#'
#' @param seasons a numeric vector of seasons to return, defaults to returning
#' this year's data if it is September or later. If set to `TRUE`, will return all available data.
#'
#' @examples
#' \donttest{
#'   try(load_cfb_rosters(2020))
#' }
#'
#' @return A tibble of season-level roster data.
#'
#' @seealso [cfbd_team_roster()]
#' @seealso Issues with this data should be filed here: <https://github.com/sportsdataverse/cfbfastR-data>
#'
#' @export
load_cfb_rosters <- function(seasons = most_recent_cfb_season()){

  current_year <- most_recent_cfb_season()
  if(isTRUE(seasons)) seasons <- 2001:current_year
  stopifnot(is.numeric(seasons),
            seasons >= 2001,
            seasons <= current_year)

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  urls <- paste0("https://github.com/sportsdataverse/cfbfastR-data/raw/main/rosters/rds/cfb_rosters_",
                 seasons, ".rds")

  # out <- purrr::map_dfr(urls, progressively(rds_from_url, p = p))

  out <- lapply(urls, progressively(rds_from_url, p))
  out <- rbindlist_with_attrs(out)
  class(out) <- c("cfbfastR_data","tbl_df","tbl","data.table","data.frame")
  # change this later when data in repo has attributes
  if(is.null(attr(out,"cfbfastR_timestamp"))) {
    out <- out %>%
      make_cfbfastR_data("Roster data from data repository",Sys.time())
  }
  out
}

#' Load CFB team info from the data repo
#'
#' @description Loads team information including colors and logos - useful for plots!
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
#'
#' @export
load_cfb_teams <- function(fbs_only = TRUE){

  out <- rds_from_url("https://github.com/sportsdataverse/cfbfastR-data/raw/main/team_info/rds/cfb_team_info_2020.rds")
  if(isTRUE(fbs_only)) out <- dplyr::filter(out,!is.na(.data$conference))

  class(out) <- c("cfbfastR_data","tbl_df","tbl","data.table","data.frame")
  attr(out,"cfbfastR_type") <- "Team information"
  out
}
