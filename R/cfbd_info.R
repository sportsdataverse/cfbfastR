#' @name cfbd_info
#' @aliases cfbd_info info usage
#' @title
#' **CFBD Info Endpoint Overview**
#' @description
#'
#' * `cfbd_info_usage()`: API key usage and remaining quota.
#'
NULL

#' @title
#' **Get API key usage information**
#' @param days (*Integer* optional): Look-back window in days.
#' @param limit (*Integer* optional): Maximum rows to return.
#' @param api (*String* optional): API filter -- `all`, `cfb` or `cbb`.
#' @description
#' **Get API key usage information**
#' Call volume and remaining quota for the configured CFBD API key.
#'
#' @return [cfbd_info_usage()] - A tibble with 11 columns:
#'
#'    |col_name           |types     |description                                                                             |
#'    |:-----------------|:--------|:--------------------------------------------------------------------------------------|
#'    |api                |character |API the request was made against (`cfb` or `cbb`).                                      |
#'    |endpoint           |character |API endpoint path.                                                                      |
#'    |kind               |character |Row type -- `top_endpoint` (aggregated count) or `recent_request` (single event).       |
#'    |requests           |integer   |Number of requests recorded.                                                            |
#'    |occurred_at        |character |Timestamp for the row (last use for `top_endpoint`, request time for `recent_request`). |
#'    |window_start       |character |Start of the reporting window (ISO 8601).                                               |
#'    |window_end         |character |End of the reporting window (ISO 8601).                                                 |
#'    |total_requests     |integer   |Total requests in the window.                                                           |
#'    |total_cfb_requests |integer   |College football requests in the window.                                                |
#'    |total_cbb_requests |integer   |College basketball requests in the window.                                              |
#'    |unique_endpoints   |integer   |Distinct endpoints called in the window.                                                |
#'
#' @keywords Info
#' @importFrom jsonlite fromJSON
#' @importFrom httr2 resp_body_string url_modify
#' @import dplyr
#' @import tidyr
#' @family CFBD Info Functions
#' @export
#' @examples
#' \donttest{
#'   try(cfbd_info_usage())
#' }
cfbd_info_usage <- function(days = NULL, limit = NULL, api = NULL) {

  # Validation ----
  validate_api_key()
  if (!is.null(api)) validate_list(api, c('all','cfb','cbb'))

  # Query API ----
  base_url <- "https://api.collegefootballdata.com/info/usage"
  query_params <- list(
    "days" = days,
    "limit" = limit,
    "api" = api
  )
  full_url <- httr2::url_modify(base_url, query = .compact(query_params))

  df <- data.frame()
  tryCatch(
    expr = {
      res <- get_req(full_url)
      check_status(res)

      df <- res |>
        httr2::resp_body_string(encoding = "UTF-8") |>
        jsonlite::fromJSON(flatten = TRUE)

      # The endpoint returns one object holding scalars (window, totals) plus
      # TWO same-shaped tables: `topEndpoints` (endpoint + request count + last
      # use) and `recentRequests` (endpoint + timestamp). They stack cleanly into
      # one long frame keyed by `kind`, with the window/total scalars recycled
      # onto every row as context -- rather than three incompatible shapes in
      # list-columns that a caller has to unpack by hand.
      win <- df[["window"]] %||% list()
      tot <- df[["totals"]] %||% list()
      ctx <- data.frame(
        window_start        = win[["start"]] %||% NA_character_,
        window_end          = win[["end"]]   %||% NA_character_,
        total_requests      = tot[["requests"]]        %||% NA_integer_,
        total_cfb_requests  = tot[["cfbRequests"]]     %||% NA_integer_,
        total_cbb_requests  = tot[["cbbRequests"]]     %||% NA_integer_,
        unique_endpoints    = tot[["uniqueEndpoints"]] %||% NA_integer_,
        stringsAsFactors = FALSE
      )

      part <- function(tbl, kind, ts_col) {
        if (is.null(tbl) || !NROW(tbl)) return(NULL)
        data.frame(
          api        = tbl[["api"]]      %||% NA_character_,
          endpoint   = tbl[["endpoint"]] %||% NA_character_,
          kind       = kind,
          # `requests` is a top-endpoint concept; a recent request is a single
          # event, so it is NA there rather than a misleading 1.
          requests   = if ("requests" %in% names(tbl)) tbl[["requests"]] else NA_integer_,
          occurred_at = tbl[[ts_col]] %||% NA_character_,
          stringsAsFactors = FALSE
        )
      }
      rows <- dplyr::bind_rows(
        part(df[["topEndpoints"]],   "top_endpoint",   "lastUsedAt"),
        part(df[["recentRequests"]], "recent_request", "requestedAt")
      )
      df <- if (NROW(rows)) {
        dplyr::as_tibble(cbind(rows, ctx[rep(1L, NROW(rows)), , drop = FALSE])) |>
          janitor::clean_names()
      } else {
        dplyr::as_tibble(cbind(
          data.frame(api = df[["api"]] %||% NA_character_, endpoint = NA_character_,
                     kind = NA_character_, requests = NA_integer_,
                     occurred_at = NA_character_, stringsAsFactors = FALSE), ctx))
      }

      df <- df |>
        make_cfbfastR_data("Get API key usage information from CollegeFootballData.com", Sys.time())
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no info data available! {conditionMessage(e)}"))
    },
    finally = {
    }
  )
  return(df)
}
