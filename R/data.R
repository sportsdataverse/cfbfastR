#' CFBD Data
#' @name data
NULL
#' College Football Mapping for Play Types
#' @rdname data
#' @keywords data
#' @format A data frame with 45 rows and 3 variables:
#' \describe{
#'   \item{id}{Referencing play id}
#'   \item{text}{play type description}
#'   \item{abbreviation}{play type abbreviation used for function call}
#'   ...
#' }
#' @source <https://api.collegefootballdata.com>
"cfbd_play_type_df"


#' College Football Conference
#' @rdname data
#' @keywords data
#' @format A data frame with 11 rows and 4 variables:
#' \describe{
#'   \item{id}{Referencing conference id}
#'   \item{name}{Conference name}
#'   \item{short_name}{Short name for Conference}
#'   \item{abbreviation}{Conference abbreviation}
#'   ...
#' }
#' @source <https://api.collegefootballdata.com>
"cfbd_conf_types_df"
