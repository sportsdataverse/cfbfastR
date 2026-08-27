#' Internal helpers wrapped by the ESPN cache
#'
#' Single source of truth for `.onLoad()` (which memoises them) and
#' [espn_cfb_clear_cache()] (which forgets them). Kept as one constant because
#' the two lists silently diverging means a helper that caches but never clears.
#'
#' `.espn_cfb_participant_roster` is game-scoped rather than a static catalog,
#' but it is the most-repeated ESPN call in the package: `espn_cfb_pbp_v2()`
#' needs one game's roster twice -- once to name participants, once to resolve
#' player ids -- and a season sweep asks for it once per game. Memoising by
#' `game_id` collapses both to a single request.
#'
#' @keywords internal
#' @noRd
.espn_memoised_helpers <- c(
  ".espn_cfb_team_lookup",
  ".espn_cfb_position_lookup",
  ".espn_cfb_participant_roster",
  ".espn_cfb_pbp_sidecar"
)

.onLoad <- function(libname, pkgname) {
  ep_model <- load_ep_model()
  fg_model <- load_fg_model()
  wp_model <- load_wp_model()
  assign("ep_model", ep_model, envir = parent.env(environment()))
  assign("fg_model", fg_model, envir = parent.env(environment()))
  assign("wp_model", wp_model, envir = parent.env(environment()))

  # ----------------------------------------------------------------------
  # ESPN catalog caching (mirrors the nflreadr caching mechanism).
  #
  # The static ESPN CFB catalog helpers (`.espn_cfb_team_lookup()` and
  # `.espn_cfb_position_lookup()`) are memoised with `cachem` + `memoise`
  # so repeated wrapper calls reuse one catalog fetch instead of re-hitting
  # ESPN. Two `options()` control behaviour:
  #
  #   * `cfbfastR.cache`          -- "memory" (default), "filesystem", or "off".
  #   * `cfbfastR.cache_duration` -- TTL in seconds (default 86400 = 24h).
  #
  # When the mode is "off" -- or when either `memoise` or `cachem` is not
  # installed (both are Suggests, not Imports) -- the helpers are left
  # un-memoised; otherwise each helper is wrapped with `memoise::memoise()`
  # and reassigned into the package namespace. `espn_cfb_clear_cache()`
  # calls `memoise::forget()` only on memoised helpers.
  # ----------------------------------------------------------------------
  cache_mode <- getOption("cfbfastR.cache", default = "memory")
  if (!cache_mode %in% c("memory", "filesystem", "off")) {
    warning(
      "Invalid `cfbfastR.cache` option '", cache_mode,
      "'. Falling back to 'memory'. Valid values: ",
      "'memory', 'filesystem', 'off'.",
      call. = FALSE
    )
    cache_mode <- "memory"
  }

  ttl <- getOption("cfbfastR.cache_duration", default = 86400)

  caching_available <-
    requireNamespace("memoise", quietly = TRUE) &&
    requireNamespace("cachem",  quietly = TRUE)

  if (cache_mode != "off" && caching_available) {
    cache <- if (cache_mode == "filesystem") {
      cache_dir <- tools::R_user_dir("cfbfastR", which = "cache")
      dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)
      cachem::cache_disk(dir = cache_dir)
    } else {
      cachem::cache_mem()
    }

    ns <- rlang::ns_env("cfbfastR")
    for (fn in .espn_memoised_helpers) {
      assign(
        fn,
        memoise::memoise(
          get(fn, envir = ns),
          ~ memoise::timeout(ttl),
          cache = cache
        ),
        envir = ns
      )
    }
  }
}
#' Load the Expected Points model
#'
#' Fetches `ep_model.ubj` from the shared `cfb_model_artifacts` release -- the
#' same artifact `sportsdataverse-py` scores with, so both libraries agree on
#' EPA and a retrain updates both in one publish.
#'
#' Falls back to the retired `nnet::multinom` on `cfbfastR-data` when the
#' bundle or `xgboost` is unavailable, so an offline session still returns a
#' usable model. [`.ep_predict()`] accepts either generation. Note the legacy
#' model aborts on mid-era CFBD data (issue #5); the bundled model does not.
#'
#' @keywords internal
#' @noRd
load_ep_model <- function() {
  if (requireNamespace("xgboost", quietly = TRUE)) {
    f <- .cfb_model_file("ep_model.ubj")
    if (!is.null(f)) {
      booster <- try(xgboost::xgb.load(f), silent = TRUE)
      if (!inherits(booster, "try-error") && !is.null(booster)) return(booster)
    }
  }
  .load_legacy_ep_model()
}

#' Retired nnet EP model, kept as the offline/no-xgboost fallback
#' @keywords internal
#' @noRd
.load_legacy_ep_model <- function() {
  ep_model <- NULL
  # load the model from GitHub because it is too large for the package
  .url <- url("https://raw.githubusercontent.com/sportsdataverse/cfbfastR-data/main/models/ep_model.Rdata")
  on.exit(close(.url))
  try(
    load(.url),
    silent = TRUE
  )
  return(ep_model)
}
load_fg_model <- function(){
  fg_model <- NULL
  .url = url("https://raw.githubusercontent.com/sportsdataverse/cfbfastR-data/main/models/fg_model.Rdata")
  on.exit(close(.url))
  try(
    load(.url),
    silent = TRUE
  )
  return (fg_model)
}
#' Load the Win Probability model
#'
#' Prefers `wp_naive.ubj` from the shared `cfb_model_artifacts` release, the
#' same artifact `sportsdataverse-py` scores with. Falls back to the retired
#' `mgcv::bam` GAM on `cfbfastR-data` when the bundle or `xgboost` is
#' unavailable; [`.wp_predict()`] accepts either generation.
#'
#' @keywords internal
#' @noRd
load_wp_model <- function() {
  if (requireNamespace("xgboost", quietly = TRUE)) {
    f <- .cfb_model_file("wp_naive.ubj")
    if (!is.null(f)) {
      booster <- try(xgboost::xgb.load(f), silent = TRUE)
      if (!inherits(booster, "try-error") && !is.null(booster)) return(booster)
    }
  }
  .load_legacy_wp_model()
}

#' Retired mgcv GAM WP model, kept as the offline/no-xgboost fallback
#' @keywords internal
#' @noRd
.load_legacy_wp_model <- function() {
  wp_model <- NULL
  .url <- url("https://raw.githubusercontent.com/sportsdataverse/cfbfastR-data/main/models/wp_model.Rdata")
  on.exit(close(.url))
  try(
    load(.url),
    silent = TRUE
  )
  return(wp_model)
}

