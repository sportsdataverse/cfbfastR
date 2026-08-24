.datatable.aware <- TRUE

#' @keywords Internal
#' @importFrom httr2 resp_status resp_status_desc
#'
check_status <- function(res) {

    x <- httr2::resp_status(res)

    if (x != 200) {
      desc <- tryCatch(
        httr2::resp_status_desc(res),
        error = function(e) ""
      )
      stop(
        sprintf("The CFBD API returned HTTP %s%s", x,
                if (nzchar(desc)) paste0(" (", desc, ")") else ""),
        call. = FALSE
      )
    }

}




# Progressively
#
# This function helps add progress-reporting to any function - given function `f()` and progressor `p()`, it will return a new function that calls `f()` and then (on-exiting) will call `p()` after every iteration.
#
# This is inspired by purrr's `safely`, `quietly`, and `possibly` function decorators.
# Taken from nflreadr
progressively <- function(f, p = NULL){
  if(!is.null(p) && !inherits(p, "progressor")) stop("`p` must be a progressor function!")
  if(is.null(p)) p <- function(...) NULL
  force(f)

  function(...){
    on.exit(p("loading..."))
    f(...)
  }

}


#' @title
#' **Load .csv / .csv.gz file from a remote connection**
#' @description
#' This is a thin wrapper on data.table::fread
#' @param ... passed to data.table::fread
#' @keywords Internal
#' @importFrom data.table fread
csv_from_url <- function(...){
  data.table::fread(...)
}


#' Load .rds file from a remote connection
#'
#' @param url a character url
#'
#' @return a dataframe as created by [`readRDS()`]
#' @importFrom data.table data.table setDT
rds_from_url <- function(url) {
  con <- url(url)
  on.exit(close(con))
  load <- try(readRDS(con), silent = TRUE)

  if (inherits(load, "try-error")) {
    cli::cli_warn("Failed to readRDS from {.url {url}}")
    return(data.table::data.table())
  }

  data.table::setDT(load)
  return(load)
}

#' Load .parquet file from a remote connection
#'
#' @param url a character url
#'
#' @return a dataframe as created by [`arrow::read_parquet()`]; a zero-row
#'   `data.table` when the download or read fails.
#' @keywords internal
#' @importFrom data.table data.table setDT
parquet_from_url <- function(url) {
  rlang::check_installed("arrow")
  tmp <- tempfile(fileext = ".parquet")
  on.exit(unlink(tmp), add = TRUE)
  dl <- try(utils::download.file(url, tmp, mode = "wb", quiet = TRUE), silent = TRUE)
  if (inherits(dl, "try-error")) {
    cli::cli_warn("Failed to download {.url {url}}")
    return(data.table::data.table())
  }
  load <- try(arrow::read_parquet(tmp), silent = TRUE)
  if (inherits(load, "try-error")) {
    cli::cli_warn("Failed to read parquet from {.url {url}}")
    return(data.table::data.table())
  }
  data.table::setDT(load)
  return(load)
}
# read rds that has been pre-fetched
read_raw_rds <- function(raw) {
  con <- gzcon(rawConnection(raw))
  ret <- readRDS(con)
  close(con)
  return(ret)
}


# The function `message_completed` to create the green "...completed" message
# only exists to hide the option `in_builder` in dots
message_completed <- function(x, in_builder = FALSE) {
  if (isFALSE(in_builder)) {
    str <- paste0(my_time(), " | ", x)
    cli::cli_alert_success("{{.field {str}}}")
  } else if (in_builder) {
    cli::cli_alert_success("{my_time()} | {x}")
  }
}

user_message <- function(x, type) {
  if (type == "done") {
    cli::cli_alert_success("{my_time()} | {x}")
  } else if (type == "todo") {
    cli::cli_ul("{my_time()} | {x}")
  } else if (type == "info") {
    cli::cli_alert_info("{my_time()} | {x}")
  } else if (type == "oops") {
    cli::cli_alert_danger("{my_time()} | {x}")
  }
}

#' @import utils
utils::globalVariables(c("where"))


# check if a package is installed
is_installed <- function(pkg) requireNamespace(pkg, quietly = TRUE)


#' @importFrom Rcpp getRcppVersion
#' @importFrom RcppParallel defaultNumThreads
NULL


`%c%` <- function(x,y){
  ifelse(!is.na(x),x,y)
}

# custom mode function from https://stackoverflow.com/questions/2547402/is-there-a-built-in-function-for-finding-the-mode/8189441
custom_mode <- function(x, na.rm = TRUE) {
  if (na.rm) {
    x <- x[!is.na(x)]
  }
  ux <- unique(x)
  return(ux[which.max(tabulate(match(x, ux)))])
}

most_recent_cfb_season <- function() {
  date <- Sys.Date()
  dplyr::case_when(
    as.double(substr(date, 6, 7)) >= 8 & as.double(substr(date, 9, 10)) >= 15  ~ as.double(substr(date, 1, 4)),
    as.double(substr(date, 6, 7)) >= 9 ~ as.double(substr(date, 1, 4)),
    TRUE ~ as.double(substr(date, 1, 4)) - 1
  )
}
my_time <- function() strftime(Sys.time(), format = "%H:%M:%S")



rule_header <- function(x) {
  rlang::inform(
    cli::rule(
      left = ifelse(is_installed("crayon"), crayon::bold(x), glue::glue("\033[1m{x}\033[22m")),
      right = paste0("cfbfastR version ", utils::packageVersion("cfbfastR")),
      width = getOption("width")
    )
  )
}

rule_footer <- function(x) {
  rlang::inform(
    cli::rule(
      left = ifelse(is_installed("crayon"), crayon::bold(x), glue::glue("\033[1m{x}\033[22m")),
      width = getOption("width")
    )
  )
}
# take a time string of the format "MM:SS" and convert it to seconds
time_to_seconds <- function(time){
  as.numeric(strptime(time, format = "%M:%S")) -
    as.numeric(strptime("0", format = "%S"))
}
# write season pbp to a connected db
write_pbp <- function(seasons, dbConnection, tablename){
  p <- if (is_installed("progressr")) {
    progressr::progressor(along = seasons)
  } else {
    function(...) NULL
  }
  purrr::walk(seasons, function(x, p){
    pbp <- load_cfb_pbp(x)
    DBI::dbWriteTable(dbConnection, tablename, pbp, append = TRUE)
    p("loading...")
  }, p)
}

# Functions for custom class
# turn a data.frame into a tibble/cfbfastR_data
make_cfbfastR_data <- function(df,type,timestamp){
  out <- df |>
    tidyr::as_tibble()

  class(out) <- c("cfbfastR_data","tbl_df","tbl","data.table","data.frame")
  attr(out,"cfbfastR_timestamp") <- timestamp
  attr(out,"cfbfastR_type") <- type
  return(out)
}

#' @export
#' @noRd
print.cfbfastR_data <- function(x,...) {
  cli::cli_rule(left = "{attr(x,'cfbfastR_type')}",right = "{.emph cfbfastR {utils::packageVersion('cfbfastR')}}")

  if(!is.null(attr(x,'cfbfastR_timestamp'))) {
    cli::cli_alert_info(
      "Data updated: {.field {format(attr(x,'cfbfastR_timestamp'), tz = Sys.timezone(), usetz = TRUE)}}"
    )
  }

  NextMethod(print,x)
  invisible(x)
}


# rbindlist but maintain attributes of last file, taken from nflreadr
rbindlist_with_attrs <- function(dflist){

  cfbfastR_timestamp <- attr(dflist[[length(dflist)]], "cfbfastR_timestamp")
  cfbfastR_type <- attr(dflist[[length(dflist)]], "cfbfastR_type")
  out <- data.table::rbindlist(dflist, use.names = TRUE, fill = TRUE)
  attr(out,"cfbfastR_timestamp") <- cfbfastR_timestamp
  attr(out,"cfbfastR_type") <- cfbfastR_type
  out
}

# Request Functions ----
#' @keywords Internal
#' @importFrom httr2 request req_headers req_timeout req_retry req_error req_perform req_proxy
get_req <- function(full_url, proxy = NULL) {
  req <- httr2::request(full_url) |>
    httr2::req_headers(Authorization = paste("Bearer", cfbd_key())) |>
    httr2::req_timeout(60)

  # Optional proxy support. Resolution order:
  #   1. `proxy` argument (caller-supplied, highest precedence).
  #   2. `getOption("cfbfastR.proxy")` (session-level fallback -- set once
  #      with `options(cfbfastR.proxy = ...)` and every cfbd_*() call picks
  #      it up; useful when a user can't thread a proxy arg through every
  #      call site).
  #   3. `http_proxy` / `https_proxy` / `no_proxy` env vars (libcurl reads
  #      these automatically when no explicit proxy is supplied -- no code
  #      path here).
  #
  # The `proxy` argument accepts:
  #   - a single URL string -- e.g. "http://host:port", passed to
  #     `httr2::req_proxy(url = ...)`.
  #   - a named list -- spread as keyword args into `httr2::req_proxy()`
  #     for full control (`url`, `port`, `username`, `password`, `auth`).
  if (is.null(proxy)) {
    proxy <- getOption("cfbfastR.proxy", default = NULL)
  }
  if (!is.null(proxy)) {
    req <- if (is.list(proxy)) {
      do.call(httr2::req_proxy, c(list(req = req), proxy))
    } else {
      httr2::req_proxy(req, url = proxy)
    }
  }

  req |>
    httr2::req_retry(
      max_tries = 3,
      backoff   = function(i) stats::runif(1, 0.5, 1.5) * (2 ^ i)
    ) |>
    httr2::req_error(is_error = function(resp) FALSE) |>
    httr2::req_perform()
}

#' Drop NULL entries from a list (internal)
#'
#' Used to compact query-parameter lists before passing them to
#' httr2::url_modify / req_url_query, both of which error on NULL
#' values (unlike httr::modify_url which silently dropped them).
#'
#' @param x A list.
#' @return `x` with NULL entries removed; the names of the
#'   remaining entries are preserved.
#' @keywords internal
#' @noRd
.compact <- function(x) {
  x[!vapply(x, is.null, logical(1))]
}

# Edge Case Handling ----
handle_accents <- function(var = NULL){
  if(!is.null(var)){
    var <- ifelse(var == "San Jose State", "San Jos\u00e9 State", var)
  }
  var
}

# CFBD API Key Validation ----
validate_api_key <- function(){
  if (!has_cfbd_key()) stop("CollegeFootballData.com now requires an API key.", "\n       See ?register_cfbd for details.", call. = FALSE)
}

# Argument Validations ----
validate_year <- function(year = NULL){
  if(!is.null(year)){
    checks <- c(
      num_check = is.numeric(year),
      len_check = nchar(year) == 4
    )
    if(!all(checks)){
      cli::cli_abort(glue::glue("Enter valid {deparse(substitute(year))} as a number (YYYY)"))
    }
  }
}

validate_week <- function(week = NULL){
  if(!is.null(week)){
    checks <- c(
      num_check = is.numeric(week),
      range_check = dplyr::between(as.numeric(week), 1, 16)
    )
    if(!all(checks)){
      cli::cli_abort(glue::glue("Enter valid {deparse(substitute(week))} 1-15\n(14 for seasons pre-playoff, i.e. 2014 or earlier)"))
    }
  }
}

validate_range <- function(var, min = NULL, max = NULL){
  if(!is.null(var) && length(var) != 0){
    checks <- c(
      lower_check <- is.null(min) || (var >= min),
      upper_check <- is.null(max) || (var <= max)
    )
    if(!all(checks)){
      cli::cli_abort(glue::glue("{deparse(substitute(var))} out of bounds: ({ifelse(is.null(min),'',min)}, {ifelse(is.null(max),'',max)})"))
    }
  }
}

validate_list <- function(var = NULL, allowable = NULL){
  if(!is.null(var)){
    list_check <- var %in% allowable
    if(!list_check){
      cli::cli_abort(
        glue::glue("Enter valid {deparse(substitute(var))} ({typeof(allowable)}): ({paste0(allowable, collapse = ', ')})")
      )
    }
  }
}

#' Flatten a nested CFBD object into rectangular columns
#'
#' @description Several CFBD endpoints return a single nested **object** rather
#'   than an array of records -- scalars at the top level, with one or more
#'   nested blocks beneath. `jsonlite` hands those back as a bare list, which
#'   breaks cfbfastR's tibble contract and any dplyr verb a caller reaches for.
#'
#' @details Recursively lifts every nested scalar into a prefixed column
#'   (`usage$overall` becomes `usage_overall`), so the result is one row of
#'   atomic columns. Members that are themselves rectangular -- a data frame of
#'   career seasons, say -- are left for the caller to unnest, because the right
#'   row grain differs per endpoint and guessing it here would be wrong.
#'
#' @param x A named list parsed from a CFBD response.
#' @param prefix Column-name prefix used during recursion.
#' @return A named list of length-1 atomic values.
#' @keywords internal
#' @noRd
.cfbd_flatten_scalars <- function(x, prefix = "") {
  out <- list()
  if (is.null(x) || !length(x)) return(out)
  for (nm in names(x)) {
    v <- x[[nm]]
    key <- if (nzchar(prefix)) paste0(prefix, "_", nm) else nm
    if (is.null(v) || (is.atomic(v) && !length(v))) {
      out[[key]] <- NA
    } else if (is.atomic(v) && length(v) == 1L) {
      out[[key]] <- v
    } else if (is.list(v) && !is.data.frame(v) && !is.null(names(v))) {
      out <- c(out, .cfbd_flatten_scalars(v, key))
    }
    # data frames and unnamed lists are deliberately skipped -- see @details
  }
  out
}

#' Validate a CFBD division / classification value
#'
#' @description CFBD calls this filter `classification` on the wire; cfbfastR
#'   has always exposed it to users as `division`. Both names refer to the same
#'   five values.
#'
#' @details Worth validating rather than passing through: CFBD **ignores** a
#'   filter value it does not recognise instead of rejecting it, so a typo
#'   returns every division silently rather than erroring. That is the same
#'   failure mode that hid the `division=` vs `classification=` rename.
#'
#' @param division Division/classification value.
#' @param allow_null When `TRUE`, `NULL` passes (the filter is simply omitted).
#' @return Invisibly `TRUE`; aborts otherwise.
#' @keywords internal
#' @noRd
validate_division <- function(division = NULL, allow_null = TRUE) {
  if (is.null(division)) {
    if (allow_null) return(invisible(TRUE))
    cli::cli_abort("Missing required field: division")
  }
  validate_list(division, c("fbs", "fcs", "ii", "ii/iii", "iii"))
}

validate_season_type <- function(season_type = NULL, allow_both = TRUE){
  allowable <- c('postseason', 'regular', 'both', 'allstar', 'spring_regular', 'spring_postseason')
  if(allow_both) allowable <- c(allowable, 'both')
  if(is.null(season_type)) cli::cli_abort("Missing required field: season_type")
  validate_list(season_type, allowable)
}

validate_id <- function(id = NULL){
  if(!is.null(id)){
    checks <- c(
      num_check <- is.numeric(id)
    )
    if(!all(checks)){
      cli::cli_abort(glue::glue("Enter valid {deparse(substitute(id))} (numeric value)"))
    }
  }
}

validate_reqs <- function(...){
  labs = vars(...)
  vars = list(...)
  null_check <- any(map_lgl(vars, ~!is.null(.x)))
  if(!null_check){
    cli::cli_abort(paste0("At least one of these arguments must not be NULL: ",
                          paste0(map_vec(labs, as_label), collapse = ', ')))
  }
}
