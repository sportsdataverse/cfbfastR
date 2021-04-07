#' CFBD API Key Registration
#' @description Save your API Key as a system environment variable `CFBD_API_KEY`
#' @details To get access to an API key, follow the instructions at [https://collegefootballdata.com/key](https://collegefootballdata.com/key "Key Registration")
#'
#' @name register_cfbd
NULL
#' @rdname register_cfbd
#' @export
cfbd_key <- function() {
  key <- Sys.getenv("CFBD_API_KEY")

  if (key == "") {
    return(NA_character_)
  } else {
    return(key)
  }
}

#' @rdname register_cfbd
#' @export
has_cfbd_key <- function() !is.na(cfbd_key())
