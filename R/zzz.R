#' Internal helpers wrapped by the ESPN cache
#'
#' Single source of truth for `.onLoad()` (which memoizes them) and
#' [espn_cfb_clear_cache()] (which forgets them). Kept as one constant because
#' the two lists silently diverging means a helper that caches but never clears.
#'
#' `.espn_cfb_participant_roster` is game-scoped rather than a static catalog,
#' but it is the most-repeated ESPN call in the package: `espn_cfb_pbp_v2()`
#' needs one game's roster twice -- once to name participants, once to resolve
#' player ids -- and a season sweep asks for it once per game. Memoising by
#' `game_id` collapses both to a single request.
#'
#' `.cfbd_team_catalog` and `.cfbd_roster_year` are the per-season CFBD
#' `/teams` and `/roster` lookups `cfbd_pbp_data()` uses for team and player
#' ids. Keyed on `year` alone, they cannot return another query's rows, which
#' is why the public `cfbd_*` wrappers stay uncached while these do not.
#'
#' @keywords internal
#' @noRd
.espn_memoised_helpers <- c(
  ".espn_cfb_team_lookup",
  ".espn_cfb_position_lookup",
  ".espn_cfb_participant_roster",
  ".espn_cfb_pbp_sidecar",
  ".cfbd_team_catalog",
  ".cfbd_roster_year"
)

.onLoad <- function(libname, pkgname) {
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
      # max_age: each TTL window writes a new copy (a season roster is ~30k
      # rows), so let expired ones go instead of piling up to the size cap.
      cachem::cache_disk(dir = cache_dir, max_age = ttl)
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
# Loaded EP / FG / WP models, filled on first use by .cfb_model().
.cfb_models <- new.env(parent = emptyenv())

#' The session's EP, FG or WP model, fetched on first use
#'
#' `library(cfbfastR)` must work offline and write nothing, and most sessions
#' never score a play, so the models are not loaded in `.onLoad()`. They live in
#' a private environment rather than as namespace bindings because
#' `R CMD check` calls `get()` on every namespace object, which would force a
#' download. A failed load (`NULL`) is not kept, so the next call retries.
#'
#' @param name `"ep_model"`, `"fg_model"` or `"wp_model"`.
#' @keywords internal
#' @noRd
.cfb_model <- function(name) {
  m <- .cfb_models[[name]]
  if (is.null(m)) {
    m <- switch(name,
      ep_model = load_ep_model(),
      fg_model = load_fg_model(),
      wp_model = load_wp_model(),
      cli::cli_abort("Unknown model {.val {name}}.")
    )
    if (!is.null(m)) assign(name, m, envir = .cfb_models)
  }
  m
}

#' Load a booster from the bundle, or say why it could not be
#'
#' @param asset File name in the `cfb_model_artifacts` release.
#' @return The `xgb.Booster`, or a string naming why it is unavailable:
#'   `"no_xgboost"`, `"download_failed"` or `"load_failed"`.
#' @keywords internal
#' @noRd
.cfb_bundle_booster <- function(asset) {
  if (!requireNamespace("xgboost", quietly = TRUE)) return("no_xgboost")
  f <- .cfb_model_file(asset)
  if (is.null(f)) return("download_failed")
  booster <- try(xgboost::xgb.load(f), silent = TRUE)
  if (inherits(booster, "try-error") || is.null(booster)) return("load_failed")
  booster
}

# The models whose legacy-fallback warning this session has already raised.
.cfb_fallback_warned <- new.env(parent = emptyenv())

#' Warn, once per session and model, that a retired model is in use
#'
#' The retired `nnet`/GAM models are a different model generation from the
#' bundle `sportsdataverse-py` scores with, so EPA/WPA from them disagree on
#' every play. That must not be silent: the warning names the model in use,
#' why the bundle was not used and the fix. Classed `cfbfastR_legacy_model` so a
#' caller can catch or muffle it.
#'
#' @param what `"EP"`, `"FG"` or `"WP"`.
#' @param asset The bundle asset that could not be used.
#' @param legacy The retired model now in use.
#' @param reason What [.cfb_bundle_booster()] returned.
#' @keywords internal
#' @noRd
.cfb_warn_legacy_model <- function(what, asset, legacy, reason) {
  if (isTRUE(.cfb_fallback_warned[[what]])) return(invisible(NULL))
  assign(what, TRUE, envir = .cfb_fallback_warned)
  why <- switch(reason,
    no_xgboost = c(
      "x" = "The {.pkg xgboost} package is not installed.",
      "i" = "Install it with {.code install.packages(\"xgboost\")} and restart R."
    ),
    download_failed = c(
      "x" = "{.file {asset}} could not be downloaded from the {.val cfb_model_artifacts} release, and no copy is cached.",
      "i" = "Check the network connection to {.url https://github.com} and try again."
    ),
    c(
      "x" = "{.pkg xgboost} could not read {.file {asset}}.",
      "i" = "Update {.pkg xgboost} with {.code install.packages(\"xgboost\")}."
    )
  )
  cli::cli_warn(c(
    "!" = "cfbfastR is scoring {what} with the retired {legacy}, not the {.file {asset}} booster.",
    "i" = "Its values differ from the current model and from sportsdataverse-py on every play.",
    why,
    "i" = "This warning is shown once per session."
  ), class = "cfbfastR_legacy_model")
}

#' The bundle booster, else the retired model with a warning
#' @keywords internal
#' @noRd
.cfb_booster_or_legacy <- function(asset, what, legacy, load_legacy) {
  b <- .cfb_bundle_booster(asset)
  if (!is.character(b)) return(b)
  m <- load_legacy()
  # Nothing loaded at all: .require_model() aborts with its own message, and a
  # warning about a fallback that did not happen would only mislead.
  if (!is.null(m)) .cfb_warn_legacy_model(what, asset, legacy, b)
  m
}

#' Load the Expected Points model
#'
#' Fetches `ep_model.ubj` from the shared `cfb_model_artifacts` release -- the
#' same artifact `sportsdataverse-py` scores with, so both libraries agree on
#' EPA and a retrain updates both in one publish.
#'
#' Falls back to the retired `nnet::multinom` on `cfbfastR-data` when the
#' bundle or `xgboost` is unavailable, with a once-per-session
#' `cfbfastR_legacy_model` warning. [`.ep_predict()`] accepts either
#' generation. Note the legacy model aborts on mid-era CFBD data (issue #5);
#' the bundled model does not.
#'
#' @keywords internal
#' @noRd
load_ep_model <- function() {
  .cfb_booster_or_legacy("ep_model.ubj", "EP", "nnet expected points model",
                         .load_legacy_ep_model)
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
    suppressWarnings(load(.url)),
    silent = TRUE
  )
  return(ep_model)
}
#' Load the Field Goal model
#'
#' Prefers the era-aware `fg_model.ubj` from the shared `cfb_model_artifacts`
#' release; falls back to the retired single-feature `mgcv::bam` when the
#' bundle or `xgboost` is unavailable, with a once-per-session
#' `cfbfastR_legacy_model` warning. [`.fg_make_prob()`] scores either.
#'
#' @keywords internal
#' @noRd
load_fg_model <- function() {
  .cfb_booster_or_legacy("fg_model.ubj", "FG", "mgcv field goal model",
                         .load_legacy_fg_model)
}

#' Retired single-feature GAM FG model, kept as the offline fallback
#' @keywords internal
#' @noRd
.load_legacy_fg_model <- function() {
  fg_model <- NULL
  .url <- url("https://raw.githubusercontent.com/sportsdataverse/cfbfastR-data/main/models/fg_model.Rdata")
  on.exit(close(.url))
  try(
    suppressWarnings(load(.url)),
    silent = TRUE
  )
  return(fg_model)
}
#' Load the Win Probability model
#'
#' Prefers `wp_naive.ubj` from the shared `cfb_model_artifacts` release, the
#' same artifact `sportsdataverse-py` scores with. Falls back to the retired
#' `mgcv::bam` GAM on `cfbfastR-data` when the bundle or `xgboost` is
#' unavailable, with a once-per-session `cfbfastR_legacy_model` warning;
#' [`.wp_predict()`] accepts either generation.
#'
#' @keywords internal
#' @noRd
load_wp_model <- function() {
  .cfb_booster_or_legacy("wp_naive.ubj", "WP", "mgcv win probability model",
                         .load_legacy_wp_model)
}

#' Retired mgcv GAM WP model, kept as the offline/no-xgboost fallback
#' @keywords internal
#' @noRd
.load_legacy_wp_model <- function() {
  wp_model <- NULL
  .url <- url("https://raw.githubusercontent.com/sportsdataverse/cfbfastR-data/main/models/wp_model.Rdata")
  on.exit(close(.url))
  try(
    suppressWarnings(load(.url)),
    silent = TRUE
  )
  return(wp_model)
}

