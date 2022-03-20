#' Load CFB Game/Schedule Data from data repo
#'
#' This returns game/schedule information
#'
#' @param seasons a numeric vector of seasons to return, default `TRUE` returns all available data.
#'
#' @return A tibble of game information for past and/or future games.
#'
#' @seealso Issues with this data should be filed here: <https://github.com/saiemgilani/cfbfastR-data>
#'
#' @examples
#' \donttest{
#'  load_cfb_schedules(2020)
#' }
#'
#' @export
load_cfb_schedules <- function(seasons = most_recent_season()){

  current_year <- most_recent_season()
  if(isTRUE(seasons)) seasons <- 2001:current_year
  stopifnot(is.numeric(seasons),
            seasons >= 2001,
            seasons <= current_year)

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  urls <- paste0("https://github.com/saiemgilani/cfbfastR-data/raw/master/schedules/rds/cfb_schedules_",
                 seasons, ".rds")

  out <- lapply(urls, progressively(rds_from_url, p))
  out <- rbindlist_with_attrs(out)
  class(out) <- c("cfbfastR_data","tbl_df","tbl","data.table","data.frame")
  attr(out,"cfbfastR_type") <- "Games and schedules from data repository"
  out
}


#' Load College Football Rosters
#'
#' @param seasons a numeric vector of seasons to return, defaults to returning
#' this year's data if it is September or later. If set to `TRUE`, will return all available data.
#'
#' @examples
#' \donttest{
#'   load_cfb_rosters(2020)
#' }
#'
#' @return A tibble of season-level roster data.
#' @seealso Issues with this data should be filed here: <https://github.com/saiemgilani/cfbfastR-data>
#'
#' @export
load_cfb_rosters <- function(seasons = most_recent_season()){

  current_year <- most_recent_season()
  if(isTRUE(seasons)) seasons <- 2001:current_year
  stopifnot(is.numeric(seasons),
            seasons >= 2001,
            seasons <= current_year)

  p <- NULL
  if (is_installed("progressr")) p <- progressr::progressor(along = seasons)

  urls <- paste0("https://github.com/saiemgilani/cfbfastR-data/raw/master/rosters/rds/cfb_rosters_",
                 seasons, ".rds")

  out <- lapply(urls, progressively(rds_from_url, p))
  out <- rbindlist_with_attrs(out)
  class(out) <- c("cfbfastR_data","tbl_df","tbl","data.table","data.frame")
  out
}

#' Load CFB team info from the data repo
#'
#' @description Loads team information including colors and logos - useful for plots!
#'
#' @examples
#' \donttest{
#'   load_cfb_teams()
#' }
#'
#' @return A tibble of team-level image URLs and hex color codes.
#'
#' @seealso Issues with this data should be filed here: <https://github.com/saiemgilani/cfbfastR-data>
#'
#' @export
load_cfb_teams <- function(fbs_only = TRUE){

  out <- rds_from_url("https://github.com/saiemgilani/cfbfastR-data/raw/master/team_info/rds/cfb_team_info_2020.rds")
  if(isTRUE(fbs_only)) out <- dplyr::filter(out,!is.na(.data$conference))

  class(out) <- c("cfbfastR_data","tbl_df","tbl","data.table","data.frame")
  attr(out,"cfbfastR_type") <- "Team information"
  out
}
