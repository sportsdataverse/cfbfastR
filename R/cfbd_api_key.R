#' @title
#' **CFBD API Key Registration**
#' @description Save your API Key as a system environment variable `CFBD_API_KEY`
#' @details To get access to an API key, follow the instructions at [https://collegefootballdata.com/key](https://collegefootballdata.com/key "Key Registration")
#'
#' **Using the key:**
#' You can save the key for consistent usage by adding `CFBD_API_KEY=YOUR-API-KEY-HERE` to your .Renviron file (easily accessed via [**`usethis::edit_r_environ()`**](https://usethis.r-lib.org/reference/edit.html)).
#' Run [**`usethis::edit_r_environ()`**](https://usethis.r-lib.org/reference/edit.html),
#' a new script will pop open named `.Renviron`, **THEN**
#' paste the following in the new script that pops up (with**out** quotations)
#' ```r
#' CFBD_API_KEY = YOUR-API-KEY-HERE
#' ```
#' Save the script and restart your RStudio session, by clicking `Session` (in between `Plots` and `Build`) and click `Restart R`
#' (there also exists the shortcut `Ctrl + Shift + F10` to restart your session).
#'
#' If set correctly, from then on you should be able to use any of the `cfbd_` functions without any other changes.
#'
#' **For less consistent usage:**
#' At the beginning of every session or within an R environment,
#' save your API key as the environment variable `CFBD_API_KEY` (**with** quotations)
#' using a command like the following.
#' ```r
#' Sys.setenv(CFBD_API_KEY = "YOUR-API-KEY-HERE")
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
