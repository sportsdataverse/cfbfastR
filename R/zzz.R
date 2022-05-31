.onLoad <- function(libname, pkgname) {
  ep_model <- load_ep_model()
  fg_model <- load_fg_model()
  wp_model <- load_wp_model()
  assign("ep_model", ep_model, envir = parent.env(environment()))
  assign("fg_model", fg_model, envir = parent.env(environment()))
  assign("wp_model", wp_model, envir = parent.env(environment()))
}
load_ep_model <- function(){
  ep_model <- NULL
  # load the model from GitHub because it is too large for the package
  .url = url("https://raw.githubusercontent.com/sportsdataverse/cfbfastR-data/main/models/ep_model.Rdata")
  on.exit(close(.url))
  try(
    load(.url),
    silent = TRUE
  )
  return (ep_model)
}
load_fg_model <- function(){
  fg_model <- NULL
  .url = url("https://raw.githubusercontent.com/sportsdataverse/cfbfastR-data/main/models/fg_model.Rdata")
  on.exit(close(.url))
  try(
    load(.url),
    silent = TRUE
  )
  return (fg_model)
}
load_wp_model <- function(){
  wp_model <- NULL
  .url = url("https://raw.githubusercontent.com/sportsdataverse/cfbfastR-data/main/models/wp_model.Rdata")
  on.exit(close(.url))
  try(
    load(.url),
    silent = TRUE
  )
  return (wp_model)
}


#' load function from package
#' @param pkg package
#' @param fun function
#' @return function
#' @keywords internal
get_fun_from_pkg <- function(pkg, fun) {
  require(pkg, character.only = TRUE)
  eval(parse(text = fun))
}
