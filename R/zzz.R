`%||%` <- function(a, b) ifelse(is.null(a), b, a)

# ##' Check latest GitHub version of R package
# ##'
# ##' @param pkg package name
# ##' @return list
# ##' @examples
# ##' \dontrun{
# ##'   check_github('saiemgilani/cfbfastR')
# ##' }
# check_github <- function(pkg) {
#   installed_version <- tryCatch(packageVersion(gsub(".*/", "", pkg)), error=function(e) NA)
#   
#   
#   url <- paste0("https://raw.githubusercontent.com/", pkg, "/master/DESCRIPTION")
#   
#   
#   x <- readLines(url)
#   remote_version <- gsub("Version:\\s*", "", x[grep('Version:', x)])
#   
#   res <- list(package = pkg,
#               installed_version = installed_version,
#               latest_version = remote_version,
#               up_to_date = NA)
#   
#   if (is.na(installed_version)) {
#     message(paste("##", pkg, "is not installed..."))
#   } else {
#     if (remote_version > installed_version) {
#       msg <- paste("##", pkg, "is out of date...")
#       message(msg)
#       res$up_to_date <- FALSE
#     } else if (remote_version == installed_version) {
#       message("package is up-to-date devel version")
#       res$up_to_date <- TRUE
#     }
#   }
#   return(res)
# }
# 
# ##' @importFrom utils installed.packages
# ##' @importFrom utils packageDescription
# update_github <- function(lib.loc = NULL, ...) {
#   message("upgrading github packages...")
#   pkgs <- installed.packages()[, 'Package']
#   install_github <- get_fun_from_pkg("remotes", "install_github")
#   tmp <- sapply(pkgs, function(pkg) {
#     desc <- packageDescription(pkg, lib.loc = lib.loc)
#     if (length(desc) <= 1 || is.null(desc$GithubSHA1))
#       return(NULL)
#     tryCatch(install_github(repo=paste0(desc$GithubUsername, '/', desc$GithubRepo),
#                             ref = desc$GithubRef,
#                             checkBuilt=TRUE,
#                             lib.loc = lib.loc, ...),
#              error=function(e) NULL)
#   })
# }
# 
# ##' load function from package
# ##' @param pkg package
# ##' @param fun function
# ##' @return function
# get_fun_from_pkg <- function(pkg, fun) {
#   require(pkg, character.only = TRUE)
#   eval(parse(text = fun))
# }

.onLoad <- function(libname, pkgname) {
  ep_model <- NULL
  suppressWarnings(
    # load the model from GitHub because it is too large for the package
    try(
      load(url("https://raw.githubusercontent.com/saiemgilani/cfbfastR-data/master/models/ep_model.Rdata")),
      silent = TRUE
    )
  )
  fg_model <- NULL
  suppressWarnings(
    # load the model from GitHub because it is too large for the package
    try(
      load(url("https://raw.githubusercontent.com/saiemgilani/cfbfastR-data/master/models/fg_model.Rdata")),
      silent = TRUE
    )
  )
  wp_model <- NULL
  suppressWarnings(
    # load the model from GitHub because it is too large for the package
    try(
      load(url("https://raw.githubusercontent.com/saiemgilani/cfbfastR-data/master/models/wp_model.Rdata")),
      silent = TRUE
    )
  )
  
}