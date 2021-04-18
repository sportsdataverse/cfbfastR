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
  .url = url("https://raw.githubusercontent.com/saiemgilani/cfbfastR-data/master/models/ep_model.Rdata")
  on.exit(close(.url))
  try(
    load(.url),
    silent = TRUE
  )
  return (ep_model)
}
load_fg_model <- function(){
  fg_model <- NULL
  .url = url("https://raw.githubusercontent.com/saiemgilani/cfbfastR-data/master/models/fg_model.Rdata")
  on.exit(close(.url))
  try(
    load(.url),
    silent = TRUE
  )
  return (fg_model)
}
load_wp_model <- function(){
  wp_model <- NULL
  .url = url("https://raw.githubusercontent.com/saiemgilani/cfbfastR-data/master/models/wp_model.Rdata")
  on.exit(close(.url))
  try(
    load(.url),
    silent = TRUE
  )
  return (wp_model)
}

##' Check latest GitHub version of R package
##'
##' @param pkg package name
##' @return list
##' @importFrom utils packageVersion
##' @examples
##' \dontrun{
##'   check_github('saiemgilani/cfbfastR')
##' }
check_github <- function(pkg) {
  installed_version <- tryCatch(utils::packageVersion(gsub(".*/", "", pkg)), error=function(e) NA)


  url <- paste0("https://raw.githubusercontent.com/", pkg, "/master/DESCRIPTION")


  x <- readLines(url)
  remote_version <- gsub("Version:\\s*", "", x[grep('Version:', x)])

  res <- list(package = pkg,
              installed_version = installed_version,
              latest_version = remote_version,
              up_to_date = NA)

  if (is.na(installed_version)) {
    message(paste("##", pkg, "is not installed..."))
  } else {
    if (remote_version > installed_version) {
      msg <- paste("##", pkg, "is out of date...")
      message(msg)
      res$up_to_date <- FALSE
    } else if (remote_version == installed_version) {
      message("package is up-to-date devel version")
      res$up_to_date <- TRUE
    }
  }
  return(res)
}

##' @importFrom utils installed.packages
##' @importFrom utils packageDescription
update_github <- function(lib.loc = NULL, ...) {
  message("upgrading github packages...")
  pkgs <- installed.packages()[, 'Package']
  install_github <- get_fun_from_pkg("remotes", "install_github")
  tmp <- sapply(pkgs, function(pkg) {
    desc <- packageDescription(pkg, lib.loc = lib.loc)
    if (length(desc) <= 1 || is.null(desc$GithubSHA1))
      return(NULL)
    tryCatch(install_github(repo=paste0(desc$GithubUsername, '/', desc$GithubRepo),
                            ref = desc$GithubRef,
                            checkBuilt=TRUE,
                            lib.loc = lib.loc, ...),
             error=function(e) NULL)
  })
}

##' load function from package
##' @param pkg package
##' @param fun function
##' @return function
get_fun_from_pkg <- function(pkg, fun) {
  require(pkg, character.only = TRUE)
  eval(parse(text = fun))
}

