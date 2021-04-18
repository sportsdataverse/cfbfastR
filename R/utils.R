`%||%` <- function(a, b) ifelse(is.null(a), b, a)

#' @keywords Internal
#' @importFrom httr status_code
#'
check_status <- function(res) {
  
    x = status_code(res)
    
    if(x != 200) stop("The API returned an error", call. = FALSE) 
  
}
# read qs files form an url
qs_from_url <- function(url) qs::qdeserialize(curl::curl_fetch_memory(url)$content)
#' Load cfbfastR play-by-play
#' @name load_cfb_pbp
NULL

#' Load cleaned pbp from the data repo
#' @rdname load_cfb_pbp
#' @description helper that loads multiple seasons from the data repo either into memory
#' or writes it into a db using some forwarded arguments in the dots
#' @param seasons A vector of 4-digit years associated with given NFL seasons.
#' @param ... Additional arguments passed to an underlying function that writes
#' the season data into a database (used by \code{\link[=update_cfb_db]{update_cfb_db()}}).
#' @param qs Wheter to use the function [qs::qdeserialize()] for more efficient loading.
#' @export
load_cfb_pbp <- function(seasons, ..., qs = FALSE) {
  dots <- rlang::dots_list(...)
  
  if (all(c("dbConnection", "tablename") %in% names(dots))) in_db <- TRUE else in_db <- FALSE
  
  if (isTRUE(qs) && !is_installed("qs")) {
    usethis::ui_stop("Package {usethis::ui_value('qs')} required for argument {usethis::ui_value('qs = TRUE')}. Please install it.")
  }
  
  most_recent <- most_recent_season()
  
  if (!all(seasons %in% 2014:most_recent)) {
    usethis::ui_stop("Please pass valid seasons between 2014 and {most_recent}")
  }
  
  if (length(seasons) > 1 && is_sequential() && isFALSE(in_db)) {
    usethis::ui_info(c(
      "It is recommended to use parallel processing when trying to load multiple seasons.",
      "Please consider running {usethis::ui_code('future::plan(\"multisession\")')}!",
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
# The function `message_completed` to create the green "...completed" message
# only exists to hide the option `in_builder` in dots
message_completed <- function(x, in_builder = FALSE) {
  if (!in_builder) {
    usethis::ui_done("{usethis::ui_field(x)}")
  } else if (in_builder) {
    usethis::ui_done(x)
  }
}
user_message <- function(x, type) {
  if (type == "done") {
    usethis::ui_done("{my_time()} | {x}")
  } else if (type == "todo") {
    usethis::ui_todo("{my_time()} | {x}")
  } else if (type == "info") {
    usethis::ui_info("{my_time()} | {x}")
  } else if (type == "oops") {
    usethis::ui_oops("{my_time()} | {x}")
  }
}
# Identify sessions with sequential future resolving
is_sequential <- function() inherits(future::plan(), "sequential")
# check if a package is installed
is_installed <- function(pkg) requireNamespace(pkg, quietly = TRUE)
# custom mode function from https://stackoverflow.com/questions/2547402/is-there-a-built-in-function-for-finding-the-mode/8189441
custom_mode <- function(x, na.rm = TRUE) {
  if (na.rm) {
    x <- x[!is.na(x)]
  }
  ux <- unique(x)
  return(ux[which.max(tabulate(match(x, ux)))])
}

most_recent_season <- function() {
  dplyr::if_else(
    as.double(substr(Sys.Date(), 6, 7)) >= 9,
    as.double(substr(Sys.Date(), 1, 4)),
    as.double(substr(Sys.Date(), 1, 4)) - 1
  )
}
my_time <- function() strftime(Sys.time(), format = "%H:%M:%S")



# rule_header <- function(x) {
#   rlang::inform(
#     cli::rule(
#       left = crayon::bold(x),
#       right = paste0("cfbfastR version ", utils::packageVersion("cfbfastR")),
#       width = getOption("width")
#     )
#   )
# }
# 
# rule_footer <- function(x) {
#   rlang::inform(
#     cli::rule(
#       left = crayon::bold(x),
#       width = getOption("width")
#     )
#   )
# }
