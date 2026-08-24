#' Attach query-context columns to a wrapper response (internal)
#'
#' Echoes the wrapper's call arguments back onto the returned data
#' frame so downstream callers can `dplyr::bind_rows()` multi-year or
#' multi-team output without manually re-attaching context.
#'
#' Without this, `espn_cfb_team_stats(team_id = 57, year = 2020)`
#' returned rows with no `season` or `season_type` column, forcing
#' callers to `mutate(season = 2020, season_type = "regular")` by
#' hand for each call. The catalog wrappers introduced in 2.3.0 use
#' this helper to flip that default -- the call-args land as the
#' first columns of the result.
#'
#' Behaviour:
#' * Only non-NULL arguments are added.
#' * If `df` already has a column of the same name, the response value
#'   wins (ESPN is authoritative -- e.g. it may canonicalise a team_id).
#' * Empty (zero-row) frames get the new columns as zero-length
#'   vectors of the appropriate type, so the schema is stable across
#'   empty/non-empty returns.
#' * New columns are prepended (left-most) so `head()` shows the
#'   query context first.
#'
#' @param df Data frame returned by the wrapper.
#' @param ... Named call-args to echo. Conventional names: `season`,
#'   `season_type`, `week`, `team_id`, `athlete_id`, `game_id`.
#' @return `df` with the non-NULL, non-conflicting call-args prepended
#'   as columns.
#' @keywords internal
#' @noRd
.attach_query_meta <- function(df, ...) {
  if (is.null(df) || !is.data.frame(df)) {
    return(df)
  }

  args <- list(...)
  args <- args[!vapply(args, is.null, logical(1))]
  if (length(args) == 0L) {
    return(df)
  }

  # Response is authoritative: drop args whose name already exists.
  args <- args[!names(args) %in% colnames(df)]
  if (length(args) == 0L) {
    return(df)
  }

  if (nrow(df) == 0L) {
    for (nm in names(args)) {
      df[[nm]] <- vector(typeof(args[[nm]]), 0L)
    }
  } else {
    for (nm in names(args)) {
      df[[nm]] <- args[[nm]]
    }
  }

  new_cols <- names(args)
  df[, c(new_cols, setdiff(colnames(df), new_cols)), drop = FALSE]
}


#' Auto-attach the calling wrapper's query args (internal)
#'
#' Convenience wrapper around `.attach_query_meta()` that introspects
#' the calling function's formals and lifts the conventionally-named
#' query args (`year`, `season`, `season_type`, `week`, `team_id`,
#' `athlete_id`, `game_id`) from `parent.frame()`. `year` is renamed
#' to `season` on the way through so the output column carries the
#' canonical name.
#'
#' Usage at the end of a wrapper:
#'   return(.attach_query_meta_auto(df))
#'
#' This avoids having to spell out the wrapper's specific arg names
#' in 38+ places (DRY); it also means adding a new query arg to a
#' wrapper signature later automatically gets the column echo without
#' a second edit.
#'
#' @param df Data frame returned by the wrapper.
#' @return `df` with the calling wrapper's query args echoed as
#'   leading columns.
#' @keywords internal
#' @noRd
.attach_query_meta_auto <- function(df) {
  if (is.null(df) || !is.data.frame(df)) {
    return(df)
  }

  caller_env <- parent.frame()
  caller_fn  <- sys.function(-1L)
  if (is.null(caller_fn)) {
    return(df)
  }
  caller_args <- names(formals(caller_fn))

  # Conventional query arg names, in the order we want them in the
  # output frame. `year` is canonicalised to `season` so binding rows
  # across calls that mix the two argument names still works.
  conventional <- c(
    season       = "year",
    season       = "season",
    season_type  = "season_type",
    week         = "week",
    team_id      = "team_id",
    athlete_id   = "athlete_id",
    coach_id     = "coach_id",
    game_id      = "game_id"
  )

  args <- list()
  for (i in seq_along(conventional)) {
    out_name <- names(conventional)[[i]]
    in_name  <- conventional[[i]]
    if (!in_name %in% caller_args) next
    if (out_name %in% names(args)) next  # `season` already filled from `year`
    val <- tryCatch(get(in_name, envir = caller_env, inherits = FALSE),
                    error = function(e) NULL)
    if (is.null(val)) next
    args[[out_name]] <- val
  }

  do.call(.attach_query_meta, c(list(df = df), args))
}
