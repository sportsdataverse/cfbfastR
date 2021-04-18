#' CFBD API Key Registration
#' @description Save your API Key as a system environment variable `CFBD_API_KEY`
#' @details To get access to an API key, follow the instructions at [https://collegefootballdata.com/key](https://collegefootballdata.com/key "Key Registration")\cr
#' \cr
#' **Using the key:** \cr
#' 
#' You can save the key for consistent usage by adding \cr
#' `CFBD_API_KEY=XXXX-YOUR-API-KEY-HERE-XXXXX` \cr
#' to your .REnviron file (easily accessed via [**`usethis::edit_r_environ()`**](https://usethis.r-lib.org/reference/edit.html)).\cr
#' \cr
#' Run [**`usethis::edit_r_environ()`**](https://usethis.r-lib.org/reference/edit.html) and THEN paste the following in the new script that pops up (with**out** quotations)\cr
#' ```r
#' CFBD_API_KEY = XXXX-YOUR-API-KEY-HERE-XXXXX
#' ```
#' For less consistent usage:\cr
#' At the beginning of every session or within an R environment, save your API key as the environment variable `CFBD_API_KEY` (with quotations) using a command like the following.\cr
#' ```{r}
#' Sys.setenv(CFBD_API_KEY = "XXXX-YOUR-API-KEY-HERE-XXXXX")
#' ```
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
