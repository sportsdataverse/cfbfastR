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
  # When the mode is "off" the helpers are left un-memoised; otherwise each
  # helper is wrapped with `memoise::memoise()` and reassigned into the
  # package namespace. `espn_cfb_clear_cache()` calls `memoise::forget()`.
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

  if (cache_mode != "off") {
    cache <- if (cache_mode == "filesystem") {
      cache_dir <- tools::R_user_dir("cfbfastR", which = "cache")
      dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)
      cachem::cache_disk(dir = cache_dir)
    } else {
      cachem::cache_mem()
    }

    ns <- rlang::ns_env("cfbfastR")
    for (fn in c(".espn_cfb_team_lookup", ".espn_cfb_position_lookup")) {
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
load_ep_model <- function(){
  ep_model <- NULL
  # load the model from GitHub because it is too large for the package
  .url = url("https://raw.githubusercontent.com/sportsdataverse/cfbfastR-data/main/models/ep_model.Rdata")
  on.exit(close(.url))
  try(
    load(.url),
    silent = TRUE
  )
  return (ep_model)
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
load_wp_model <- function(){
  wp_model <- NULL
  .url = url("https://raw.githubusercontent.com/sportsdataverse/cfbfastR-data/main/models/wp_model.Rdata")
  on.exit(close(.url))
  try(
    load(.url),
    silent = TRUE
  )
  return (wp_model)
}

