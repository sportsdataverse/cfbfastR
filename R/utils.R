.datatable.aware <- TRUE

#' @keywords internal
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
#' @return A `data.table` of the file's contents.
#' @keywords internal
#' @importFrom data.table fread
csv_from_url <- function(...){
  data.table::fread(...)
}

# Read a sportsdataverse release / data-repo csv through `.read_release_asset()`
# (raised timeout, retries). Live third-party csv endpoints keep calling
# `csv_from_url()` directly. These are single files (games index, manifests),
# so when every try fails the last error is raised, as before, after the
# warning that names the url.
#
# The file is downloaded with libcurl first and fread() reads the local copy:
# fread(url) under `download.file.method = "curl"` shells out to curl, which
# ignores R's `timeout` and saves an HTTP 503 error page as if it were the csv.
# With `strict = TRUE` a fread() warning (it stops early on a malformed row and
# returns the rows before it) is an error, so a partial table never passes.
.release_csv_from_url <- function(url, ..., strict = FALSE) {
  read <- function(u) {
    tmp <- tempfile(fileext = if (grepl("\\.gz$", u)) ".csv.gz" else ".csv")
    on.exit(unlink(tmp), add = TRUE)
    .download_url(u, tmp, method = "libcurl")
    if (!strict) return(csv_from_url(file = tmp, ...))
    # Collect the warnings and raise after fread() returns: stopping inside
    # its handler skips fread()'s cleanup, and the next fread() call warns.
    warned <- character()
    out <- withCallingHandlers(
      csv_from_url(file = tmp, ...),
      warning = function(w) {
        warned <<- c(warned, conditionMessage(w))
        invokeRestart("muffleWarning")
      }
    )
    if (length(warned)) {
      # classed, so .read_release_asset() does not retry it: the file is the same on every try
      stop(errorCondition(
        paste0("fread() warned, so the table may be partial: ", paste(warned, collapse = "; ")),
        class = "release_csv_partial", call = NULL
      ))
    }
    out
  }
  load <- .read_release_asset(url, read)
  if (inherits(load, "try-error")) stop(attr(load, "condition"))
  load
}


#' Load .rds file from a remote connection
#'
#' @param url a character url
#'
#' @return a dataframe as created by [`readRDS()`]
#' @importFrom data.table data.table setDT
rds_from_url <- function(url) {
  load <- .read_release_asset(url, .read_rds_url)
  if (inherits(load, "try-error")) return(data.table::data.table())

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
  # The parquet read is inside the retry: a truncated download fails to parse.
  load <- .read_release_asset(url, function(u) {
    .download_url(u, tmp)
    arrow::read_parquet(tmp)
  })
  if (inherits(load, "try-error")) return(data.table::data.table())
  data.table::setDT(load)
  # An all-null parquet column arrives as `vctrs_unspecified`; rbindlist()
  # refuses to stack it onto a season where the same column is logical.
  for (col in names(load)[vapply(load, inherits, logical(1), "vctrs_unspecified")]) {
    data.table::set(load, j = col, value = as.logical(unclass(load[[col]])))
  }
  return(load)
}

# Read one release asset with `read(url)`, retrying a failed read.
#
# A slow asset used to hit R's default 60 s `timeout`, and the loader dropped
# that season from a multi-season load with a vague warning. The timeout is
# raised to at least 150 s for the read (a larger user setting is kept), and a
# failed read is tried again after 1 s and 2 s. A 404 and a partial strict csv
# read (class `release_csv_partial`) are not retried. Warnings
# from a read that then succeeds are passed on. When every try fails, it warns
# that the file is missing from the result and returns the `try-error`.
.read_release_asset <- function(url, read, tries = 3L) {
  old <- options(timeout = max(150, getOption("timeout", 60)))
  on.exit(options(old), add = TRUE)
  for (i in seq_len(tries)) {
    warns <- list()
    out <- withCallingHandlers(
      try(read(url), silent = TRUE),
      warning = function(w) {
        warns[[length(warns) + 1L]] <<- w
        invokeRestart("muffleWarning")
      }
    )
    if (!inherits(out, "try-error")) {
      # Re-raised with cli, keeping the reader's own warning classes.
      for (w in warns) {
        cli::cli_warn("{conditionMessage(w)}",
                      class = setdiff(class(w), c("rlang_warning", "simpleWarning", "warning", "condition")))
      }
      return(out)
    }
    why <- unique(c(conditionMessage(attr(out, "condition")),
                    vapply(warns, conditionMessage, character(1))))
    if (i == tries || inherits(attr(out, "condition"), "release_csv_partial") ||
        any(grepl("HTTP status was '404", why, fixed = TRUE))) break
    Sys.sleep(i)
  }
  why <- paste(why, collapse = "; ")
  cli::cli_warn(c(
    "Failed to read {.url {url}} after {i} attempt{?s}.",
    "!" = "The result is incomplete: it is missing this file.",
    "x" = "{why}"
  ))
  out
}

.read_rds_url <- function(url) {
  con <- url(url)
  on.exit(close(con))
  readRDS(con)
}

# `...` goes to download.file(), e.g. `method = "libcurl"`.
.download_url <- function(url, dest, ...) {
  status <- utils::download.file(url, dest, mode = "wb", quiet = TRUE, ...)
  if (status != 0L || !file.exists(dest) || file.size(dest) == 0) {
    stop("Download failed (status ", status, ") or the file is empty.", call. = FALSE)
  }
  invisible(dest)
}

# Play ids are Int64 values of up to 18 digits; above 2^53 a double cannot hold them
# (2025 espn_cfb_pbp: 166,360 ids collapse to 149,864 as doubles). Convert
# exactly to character, the dtype espn_cfb_pbp_v2() returns. Integer64 goes
# through bit64; a plain double is left alone because casting it would only
# bake in the rounding.
ids_to_character <- function(df, cols) {
  for (col in intersect(cols, names(df))) {
    x <- df[[col]]
    if (inherits(x, "integer64")) {
      rlang::check_installed("bit64")
      x <- bit64::as.character.integer64(x)
    } else if (is.integer(x)) {
      x <- as.character(x)
    } else if (is.double(x)) {
      cli::cli_warn("{.field {col}} arrived as a double; ids above 2^53 may already be rounded.")
    }
    data.table::set(df, j = col, value = x)
  }
  df
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

  class(out) <- c("cfbfastR_data","tbl_df","tbl","data.frame")
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
# build_req() is split out from get_req() so the retry/timeout policy can be
# asserted in a test without performing a request (see
# tests/testthat/test-utils_request_policy.R). get_req() remains the only entry
# point callers use. Deliberately kept title-free so roxygen generates no .Rd
# for an internal helper.
#' @keywords internal
#' @importFrom httr2 request req_headers req_timeout req_retry req_error req_perform req_proxy
build_req <- function(full_url, proxy = NULL) {
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

  # Retry budget. httr2 retries 429/503 by default (`retry_is_transient`) and
  # honours a `Retry-After` header when the server sends one, falling back to
  # `backoff` when it does not.
  #
  # The previous budget -- 3 tries, ~1-9s of backoff -- is enough for an
  # incidental 429 but not for sustained throttling, which is what a parallel
  # caller produces. When it ran out, `req_error(is_error = ~FALSE)` handed the
  # still-429 response back and `check_status()` turned it into a plain error,
  # which every cfbd_*() tryCatch reports as "no data available". A throttle
  # then looks exactly like an empty result. That is how cfbfastR_cfb_pbp
  # published nothing from 2026-07-01 onward while its job stayed green:
  # `cfbd_play_stats_player()` 429'd 63 times in one run, `sack_player_id`
  # never materialised, and the downstream join aborted the whole script.
  #
  # `max_seconds` bounds the total wait so a hard-down API still fails in
  # bounded time rather than hanging a caller for max_tries * backoff.
  #
  # Note this is the production path only -- tests already slow themselves via
  # the `get_req()` wrapper in tests/testthat/setup-cfbd-throttle.R.
  #
  # httr2's default `is_transient` covers 429 and 503 only. CFBD's gateway also
  # answers 502/504 while the backend restarts; without a retry the first one
  # surfaced as "The CFBD API returned HTTP 502 (Bad Gateway)" (the 2026-10-23
  # weekly R-CMD-check, test-goal_to_go_distance.R).
  req |>
    httr2::req_retry(
      max_tries   = 6,
      max_seconds = 120,
      is_transient = function(resp) httr2::resp_status(resp) %in% c(429L, 502L, 503L, 504L),
      backoff     = function(i) stats::runif(1, 0.5, 1.5) * (2 ^ i)
    ) |>
    httr2::req_error(is_error = function(resp) FALSE)
}

#' @keywords internal
get_req <- function(full_url, proxy = NULL) {
  httr2::req_perform(build_req(full_url, proxy = proxy))
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
    # isTRUE, not `!all()`: nchar(NA_integer_) is NA, so `checks` carries an NA,
    # `all()` returns NA and `if (!NA)` raises base R's "missing value where
    # TRUE/FALSE needed" instead of the cli message this function exists to give.
    # Hit via year = NA_integer_ or c(2025, NA) (CodeRabbit on #151).
    if(!isTRUE(all(checks))){
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

#' Turn one section of a nested CFBD object into a tibble
#'
#' @description The preview and overview endpoints return one object built from
#'   sections of different row grain: a single record, an array of rows, or a
#'   named group of arrays. This reads whichever shape arrives.
#'
#' @details A data frame comes back flattened, as it is. A named list whose
#'   members are all data frames (or empty) is stacked with `bind_rows()`, the
#'   member name kept in an `id` column. Anything else is read as one record
#'   and flattened to a single row with [.cfbd_flatten_scalars()]. An empty or
#'   `NULL` section returns a 0-column tibble rather than failing, so a caller
#'   can always pass the result on to `make_cfbfastR_data()`.
#'
#' @param x One parsed section.
#' @param id Column that holds member names when `x` is a group of arrays.
#' @return A tibble with cleaned names.
#' @keywords internal
#' @noRd
.cfbd_section_tbl <- function(x, id = "category") {
  is_rows <- function(v) is.data.frame(v) || is.null(v) || !length(v)
  if (is.null(x) || !length(x)) {
    return(dplyr::tibble())
  }
  if (is.data.frame(x)) {
    df <- jsonlite::flatten(x)
  } else if (is.list(x) && !is.null(names(x)) && all(vapply(x, is_rows, logical(1)))) {
    x <- Filter(is.data.frame, x)
    df <- dplyr::bind_rows(lapply(x, jsonlite::flatten), .id = id)
  } else if (is.list(x)) {
    df <- as.data.frame(.cfbd_flatten_scalars(x), stringsAsFactors = FALSE)
  } else {
    return(dplyr::tibble())
  }
  if (!ncol(df)) {
    return(dplyr::tibble())
  }
  janitor::clean_names(dplyr::as_tibble(df))
}

#' Stack home and away sections with a leading `side` column
#'
#' @param sides A named list (`home`, `away`) of tibbles.
#' @return One tibble; sides with no columns are dropped.
#' @keywords internal
#' @noRd
.cfbd_bind_sides <- function(sides) {
  sides <- Filter(function(s) ncol(s) > 0L, sides)
  if (!length(sides)) {
    return(dplyr::tibble())
  }
  dplyr::bind_rows(sides, .id = "side")
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

# First season of the NCAA's 2012 kickoff rules (internal rules
# notes): kickoffs from the 35, a
# touchback out to the receiving team's 25 (the 20 before) and a kickoff out of
# bounds to the 35 (the 40 before). Python twin: `_KICKOFF_2012_RULES_FROM` in
# sdv-py `cfb/cfb_pbp.py` (sportsdataverse-py#778).
.KICKOFF_2012_RULES_FROM <- 2012

#' Do the 2012 kickoff rules apply to this season?
#'
#' @param season Scalar season (a factor is read by its label); only its first
#'   element is read. `NULL` or `NA`
#'   reads as the current rules (`TRUE`).
#' @return `TRUE` from 2012 (or when the season is unknown), `FALSE` through 2011.
#' @keywords internal
#' @noRd
.kickoff_2012_rules <- function(season) {
  s <- if (length(season)) suppressWarnings(as.numeric(as.character(season[[1]]))) else NA_real_
  is.na(s) || s >= .KICKOFF_2012_RULES_FROM
}

#' Kickoff touchback spot, in yards to goal, by season
#'
#' 75 (the 25) from 2012, 80 (the 20) through 2011; see
#' `.KICKOFF_2012_RULES_FROM`.
#'
#' @param season Scalar season (a factor is read by its label); only its first
#'   element is read. `NULL` or `NA`
#'   reads as the current rule (75).
#' @return 75 or 80.
#' @keywords internal
#' @noRd
.kickoff_touchback_ytg <- function(season) {
  if (.kickoff_2012_rules(season)) 75 else 80
}

# First season a fair catch of a kickoff is a touchback (internal
# rules notes). Python twin:
# `CFB_KICKOFF_FAIR_CATCH_TOUCHBACK_FROM` in sdv-py `cfb/model_vars.py`.
.KICKOFF_FAIR_CATCH_TOUCHBACK_FROM <- 2018

#' Is a fair-caught kickoff a touchback in this season?
#'
#' @param season Scalar season; `NULL` or `NA` reads as the current rules.
#' @return `TRUE` from 2018 (or when the season is unknown), `FALSE` before.
#' @keywords internal
#' @noRd
.kickoff_fair_catch_touchback <- function(season) {
  s <- if (length(season)) suppressWarnings(as.numeric(as.character(season[[1]]))) else NA_real_
  is.na(s) || s >= .KICKOFF_FAIR_CATCH_TOUCHBACK_FROM
}

#' Punt distance from play text, signed
#'
#' "punt for 43 yards" is 43; "punt for a loss of 12 yards" is -12, a punt that
#' ended behind the line of scrimmage (ESPN's next snap confirms it). sdv-py
#' reads the clause the same way, in any case (#156). Only the first "punt for"
#' clause is read, and its number must follow directly, so "punt for no gain to
#' the BC 20" has no distance rather than 20, and a return's "punt for a loss"
#' never stands in for the punt.
#'
#' @param play_text Character vector of play text.
#' @return Numeric vector, `NA` where the text gives no punt distance.
#' @keywords internal
#' @noRd
.punt_yards <- function(play_text) {
  clause <- stringr::str_match(play_text, stringr::regex("\\bpunt for ([^,]*)", ignore_case = TRUE))[, 2]
  m <- stringr::str_match(clause, stringr::regex("^(a loss of )?(\\d+)", ignore_case = TRUE))
  yds <- as.numeric(m[, 3])
  ifelse(is.na(m[, 2]), yds, -yds)
}

#' The season an exported entry point applies the kickoff rules to
#'
#' An explicit `season` wins; otherwise the frame's own `season` column (its
#' first non-missing value). With neither, warns once per session that
#' kickoffs are scored under the 2012 rules, and returns `NA`.
#'
#' @param season `NULL` or a scalar season.
#' @param df The play-by-play frame.
#' @return A scalar season, or `NA_real_`.
#' @keywords internal
#' @noRd
.kickoff_rule_season <- function(season, df) {
  if (is.null(season) && "season" %in% names(df)) {
    s <- df[["season"]]
    season <- s[!is.na(s)][1]
  }
  season <- if (length(season)) suppressWarnings(as.numeric(as.character(season[[1]]))) else NA_real_
  if (is.na(season)) {
    cli::cli_warn(
      c("No {.arg season} given and no {.field season} column: kickoffs are scored under the 2012 rules: a touchback at the 25 (75 yards to goal) and a kickoff out of bounds at the 35.",
        "i" = "Pass {.arg season} for games before 2012, when a touchback came out to the 20 and a kickoff out of bounds to the 40."),
      .frequency = "once", .frequency_id = "cfbfastR_kickoff_tb_season"
    )
  }
  season
}
