#' Shared CFB model artifacts (`cfb_model_artifacts` bundle)
#'
#' @description Fetch and score the models published in the
#'   `cfb_model_artifacts` release, the single source of truth read by BOTH
#'   `cfbfastR` and `sportsdataverse-py`. Publishing to that release is the one
#'   change that updates both libraries.
#'
#' @details The historical EP model was an `nnet::multinom` downloaded from
#'   `cfbfastR-data`. It aborts on mid-era CFBD data
#'   (`predict.nnet(): missing values in 'x'`, seasons ~2006-2013; see issue #5)
#'   and is a different generation from the models sdv-py scores with, so the
#'   two libraries disagreed on EPA for the same play.
#'
#'   Everything here funnels through [`.ep_predict()`] so the eight historical
#'   `predict(ep_model, ...)` call sites share one implementation of the
#'   feature contract and the class-order permutation. Fixing the contract in
#'   one place is the point -- a per-call-site fix would leave the next new
#'   call site free to get it wrong.
#'
#' @keywords internal
#' @noRd
NULL

#' @keywords internal
#' @noRd
.CFB_MODEL_BASE <- paste0(
  "https://github.com/sportsdataverse/sportsdataverse-data/releases/download/",
  "cfb_model_artifacts/"
)

#' Process-lifetime cache for the manifest (and anything else bundle-scoped).
#' @keywords internal
#' @noRd
.cfb_model_env <- new.env(parent = emptyenv())
.cfb_model_env$unavailable <- list()

#' EP next-score class order, point values and feature contract
#'
#' `.EP_LEV` preserves the *historical* `ep_model$lev` ordering. Every
#' downstream column name (`TD_before`, `Opp_FG_after`, ...) and the positional
#' `weights <- c(0, 3, -3, -2, -7, 2, 7)` vector in [.pbp_create_epa()] are
#' expressed in this order, so keeping it lets the model swap stay invisible to
#' the rest of the pipeline.
#'
#' @keywords internal
#' @noRd
.EP_LEV <- c("No_Score", "FG", "Opp_FG", "Opp_Safety", "Opp_TD", "Safety", "TD")

#' @keywords internal
#' @noRd
.EP_FEATURES <- c(
  "TimeSecsRem", "yards_to_goal", "distance",
  "down_1", "down_2", "down_3", "down_4", "pos_score_diff_start"
)

#' Fallback for the bundle's EP class permutation
#'
#' The authoritative value lives in the bundle's `MANIFEST.json`
#' (`ep_class_contract$permutation_to_cfbfastR_lev_1based`) and is read from
#' there by [.ep_class_permutation()]; this constant only covers the offline
#' case. `test-ep_model_artifacts.R` asserts the two agree, so an upstream
#' reordering cannot silently diverge from this copy.
#'
#' @keywords internal
#' @noRd
.EP_PERM_FALLBACK <- c(7L, 3L, 4L, 6L, 2L, 5L, 1L)

#' Fetch a bundle asset to the on-disk model cache and return its path
#'
#' `xgboost::xgb.load()` reads a local file, not a URL, so the asset is
#' downloaded first. The copy is cached under the package's user cache dir and
#' re-downloaded once it is older than `cfbfastR.cache_duration` (default 24h) --
#' that TTL is what makes "publish to the release once and both libraries pick
#' it up" true without anyone editing code.
#'
#' @param asset File name within the release, e.g. `"ep_model.ubj"`.
#' @return Local path, or `NULL` when the asset could not be fetched and no
#'   usable cached copy exists.
#' @keywords internal
#' @noRd
.cfb_model_file <- function(asset) {
  dir <- file.path(tools::R_user_dir("cfbfastR", which = "cache"), "models")
  dir.create(dir, recursive = TRUE, showWarnings = FALSE)
  dest <- file.path(dir, asset)

  ttl <- getOption("cfbfastR.cache_duration", default = 86400)
  fresh <- file.exists(dest) &&
    difftime(Sys.time(), file.info(dest)$mtime, units = "secs") < ttl
  if (fresh) return(dest)

  tmp <- paste0(dest, ".part")
  ok <- try(
    utils::download.file(paste0(.CFB_MODEL_BASE, asset), tmp,
                         mode = "wb", quiet = TRUE),
    silent = TRUE
  )
  if (!inherits(ok, "try-error") && file.exists(tmp) && file.size(tmp) > 0) {
    # Only replace the cached copy once the download is complete, so an
    # interrupted fetch can't leave a truncated model in place. file.rename()
    # returns FALSE rather than erroring when the destination is locked (a
    # concurrent R session on Windows holds the file), so returning `dest`
    # unconditionally would hand back a stale-or-absent path as if it were the
    # fresh download.
    if (isTRUE(file.rename(tmp, dest))) return(dest)
    # Rename lost: score from the freshly downloaded copy in place.
    return(tmp)
  }
  unlink(tmp)
  # Stale beats absent: an expired cached copy still scores.
  if (file.exists(dest)) dest else NULL
}

#' Download and cache the bundle manifest
#'
#' @return The parsed manifest, or `NULL` when it cannot be fetched (offline,
#'   rate-limited, asset moved). Callers must degrade rather than abort --
#'   a missing manifest is not a reason to refuse to score.
#' @keywords internal
#' @noRd
.cfb_model_manifest <- function() {
  if (!is.null(.cfb_model_env$manifest)) return(.cfb_model_env$manifest)
  man <- try(
    jsonlite::fromJSON(paste0(.CFB_MODEL_BASE, "MANIFEST.json"),
                       simplifyVector = FALSE),
    silent = TRUE
  )
  if (inherits(man, "try-error")) return(NULL)
  .cfb_model_env$manifest <- man
  man
}

#' Resolve the EP class permutation, manifest-first
#'
#' Maps the bundle's class order (`TD, Opp_TD, FG, Opp_FG, Safety, Opp_Safety,
#' No_Score`) onto [.EP_LEV]. The two orderings share no fixed point, so
#' applying the wrong one yields EP that is wrong yet lands in a plausible
#' range -- it will not trip a sanity check. That is why this is read from the
#' published manifest and validated rather than inlined at the call site.
#'
#' @keywords internal
#' @noRd
.ep_class_permutation <- function() {
  man <- .cfb_model_manifest()
  p <- try(
    unlist(man$ep_class_contract$permutation_to_cfbfastR_lev_1based),
    silent = TRUE
  )
  if (inherits(p, "try-error") || length(p) != 7L ||
      !setequal(as.integer(p), 1:7)) {
    return(.EP_PERM_FALLBACK)
  }
  as.integer(p)
}

#' Build the EP model's feature matrix
#'
#' The bundle's EP model takes one-hot `down_1..down_4` and *raw* `distance`.
#' The retired `nnet` formula instead used a `down` factor plus `log_ydstogo`,
#' `Goal_To_Go`, `Under_two` and interactions, so the caller's frame is
#' translated here rather than passed through.
#'
#' @param newdata Frame carrying `TimeSecsRem`, `yards_to_goal`, `distance`,
#'   `down` (factor, numeric or character) and `pos_score_diff_start`.
#' @keywords internal
#' @noRd
.ep_feature_matrix <- function(newdata) {
  need <- c("TimeSecsRem", "yards_to_goal", "distance", "down",
            "pos_score_diff_start")
  missing_cols <- setdiff(need, names(newdata))
  if (length(missing_cols)) {
    cli::cli_abort(c(
      "EP scoring frame is missing required column{?s}: {.field {missing_cols}}.",
      i = "The bundled EP model needs {.field {need}}."
    ))
  }
  # as.character() first: as.numeric() on a factor yields its integer CODES,
  # which silently mislabels down whenever the levels are not 1:4 in order.
  down <- suppressWarnings(as.numeric(as.character(newdata$down)))
  m <- cbind(
    TimeSecsRem = as.numeric(newdata$TimeSecsRem),
    yards_to_goal = as.numeric(newdata$yards_to_goal),
    distance = as.numeric(newdata$distance),
    down_1 = as.numeric(down == 1),
    down_2 = as.numeric(down == 2),
    down_3 = as.numeric(down == 3),
    down_4 = as.numeric(down == 4),
    pos_score_diff_start = as.numeric(newdata$pos_score_diff_start)
  )
  colnames(m) <- .EP_FEATURES
  m
}

#' Win Probability feature contract (naive, spread-free)
#'
#' Order matters -- it is the booster's own feature order, taken from the
#' bundle manifest. Eleven of the twelve already exist on the frame
#' `.pbp_create_wpa_naive()` receives; only `is_home` is derived here.
#'
#' @keywords internal
#' @noRd
.WP_NAIVE_FEATURES <- c(
  "pos_team_receives_2H_kickoff", "TimeSecsRem", "adj_TimeSecsRem",
  "ExpScoreDiff_Time_Ratio", "pos_score_diff_start", "down", "distance",
  "yards_to_goal", "is_home", "pos_team_timeouts_rem_before",
  "def_pos_team_timeouts_rem_before", "period"
)

#' Is the team in possession the home team?
#'
#' Mirrors sdv-py's `is_home = pos_team == homeTeamId` (it compares team ids;
#' the cfbfastR frame carries team names, same semantic). Returns 0/1 with
#' `NA` treated as not-home, since the booster cannot take a missing value and
#' a neutral-site or unresolved possession team should not fabricate an
#' advantage.
#'
#' @keywords internal
#' @noRd
.wp_is_home <- function(newdata) {
  if ("is_home" %in% names(newdata)) {
    v <- suppressWarnings(as.numeric(newdata$is_home))
    return(ifelse(is.na(v), 0, v))
  }
  if (!all(c("pos_team", "home") %in% names(newdata))) {
    cli::cli_abort(c(
      "Cannot derive {.field is_home} for the WP model.",
      i = "Need either {.field is_home}, or both {.field pos_team} and {.field home}."
    ))
  }
  as.numeric(!is.na(newdata$pos_team) & !is.na(newdata$home) &
               newdata$pos_team == newdata$home)
}

#' Build the WP model's feature matrix
#'
#' @param newdata One row per play, carrying the WP inputs
#'   `.pbp_create_epa()` prepares.
#' @keywords internal
#' @noRd
.wp_feature_matrix <- function(newdata) {
  derived <- "is_home"
  need <- setdiff(.WP_NAIVE_FEATURES, derived)
  missing_cols <- setdiff(need, names(newdata))
  if (length(missing_cols)) {
    # Bound locally: cli's glue transformer cannot interpolate a dot-prefixed
    # symbol inside {.field {...}}.
    wanted <- .WP_NAIVE_FEATURES
    cli::cli_abort(c(
      "WP scoring frame is missing required column{?s}: {.field {missing_cols}}.",
      i = "The bundled WP model needs {.field {wanted}}."
    ))
  }
  cols <- lapply(need, function(nm) {
    # as.character() first so a factor `down` contributes its VALUE, not its
    # level code -- the same trap guarded in .ep_feature_matrix().
    suppressWarnings(as.numeric(as.character(newdata[[nm]])))
  })
  names(cols) <- need
  cols$is_home <- .wp_is_home(newdata)
  m <- do.call(cbind, cols[.WP_NAIVE_FEATURES])
  colnames(m) <- .WP_NAIVE_FEATURES
  m
}

#' Score the Win Probability model, whichever generation is loaded
#'
#' @param wp_model The bundle's `xgb.Booster`, or the retired `mgcv::bam` GAM.
#' @param newdata One row per play.
#' @return Numeric vector of offense win probabilities, `nrow(newdata)` long.
#' @keywords internal
#' @noRd
.wp_predict <- function(wp_model, newdata) {
  if (!inherits(wp_model, "xgb.Booster")) {
    return(as.vector(stats::predict(wp_model, newdata = newdata,
                                    type = "response")))
  }
  rlang::check_installed("xgboost", reason = "to score the bundled WP model.")
  x <- .wp_feature_matrix(newdata)
  p <- as.numeric(stats::predict(wp_model, x))
  if (length(p) != nrow(x)) {
    cli::cli_abort(
      "WP model returned {length(p)} value{?s} for {nrow(x)} play{?s}."
    )
  }
  p
}

#' Score the EP model, whichever generation is loaded
#'
#' Single entry point for every EP prediction in the package. Returns a
#' `data.frame` of seven next-score probabilities named and **ordered** by
#' [.EP_LEV], regardless of which model generation is in hand -- so callers can
#' keep applying the positional `weights` vector unchanged.
#'
#' @param ep_model Either the bundle's `xgb.Booster` or a legacy
#'   `nnet::multinom` (still accepted so a cached old artifact keeps working).
#' @param newdata One row per play.
#' @return `data.frame`, `nrow(newdata)` x 7, columns named [.EP_LEV].
#' @keywords internal
#' @noRd
.ep_predict <- function(ep_model, newdata) {
  if (!inherits(ep_model, "xgb.Booster")) {
    # Legacy nnet::multinom path, preserved verbatim.
    out <- as.data.frame(stats::predict(ep_model, newdata, type = "prob"))
    if (ncol(out) == 1L) out <- as.data.frame(t(out))
    colnames(out) <- ep_model$lev
    return(out)
  }

  rlang::check_installed("xgboost", reason = "to score the bundled EP model.")
  x <- .ep_feature_matrix(newdata)
  p <- stats::predict(ep_model, x)

  # multi:softprob returns either an n x 7 matrix or a flat row-major vector
  # depending on the xgboost version. Reshape byrow so class probabilities stay
  # attached to their own play -- column-major would silently interleave rows.
  if (!is.matrix(p) || ncol(p) != length(.EP_LEV)) {
    p <- matrix(as.numeric(p), ncol = length(.EP_LEV), byrow = TRUE)
  }
  if (nrow(p) != nrow(x)) {
    cli::cli_abort(
      "EP model returned {nrow(p)} row{?s} for {nrow(x)} play{?s}."
    )
  }

  p <- p[, .ep_class_permutation(), drop = FALSE]
  colnames(p) <- .EP_LEV
  as.data.frame(p)
}

#' Completion Probability feature contract
#'
#' Order is the booster's own, from the bundle manifest.
#'
#' **`score_diff` is fed from `pos_score_diff_start`, not from the frame's own
#' `score_diff` column.** Both exist in cfbfastR and they are NOT equal (the
#' former is signed from the possessing team's view), so reading the
#' like-named column would produce completion probabilities that are wrong yet
#' entirely plausible. sdv-py's `cp_sources` map is the reference.
#'
#' @keywords internal
#' @noRd
.CP_FEATURES <- c(
  "down", "distance", "yards_to_goal", "score_diff",
  "seconds_remaining", "is_home", "period", "passing_down"
)

#' Lazily load the bundled completion-probability model
#'
#' Unlike EP/WP there is no legacy CFB CP model to fall back to, so this is
#' bundle-or-nothing and returns `NULL` when unavailable. Loaded on first use
#' rather than at `.onLoad()` so users who never ask for CP pay no download.
#'
#' @keywords internal
#' @noRd
.cfb_cp_model <- function() {
  if (!is.null(.cfb_model_env$cp_model)) return(.cfb_model_env$cp_model)
  # A failed fetch is remembered too. Without it .cfb_model_file() retries the
  # download on EVERY game of a season sweep and pays the timeout each time.
  if (isTRUE(.cfb_model_env$unavailable[["cp_model"]])) return(NULL)
  fail <- function() {
    .cfb_model_env$unavailable[["cp_model"]] <- TRUE
    NULL
  }
  if (!requireNamespace("xgboost", quietly = TRUE)) return(fail())
  f <- .cfb_model_file("cfb_cp_model.ubj")
  if (is.null(f)) return(fail())
  b <- try(xgboost::xgb.load(f), silent = TRUE)
  if (inherits(b, "try-error") || is.null(b)) return(fail())
  .cfb_model_env$cp_model <- b
  b
}

#' Is this a passing down?
#'
#' cfbfastR/sdv-py definition: a scrimmage play on 2nd & 8+, 3rd & 5+, or
#' 4th & 5+. cfbfastR carries no `scrimmage_play` column, so it is taken as
#' pass-or-rush.
#'
#' @keywords internal
#' @noRd
.cp_passing_down <- function(df) {
  num <- function(nm) if (nm %in% names(df)) {
    suppressWarnings(as.numeric(as.character(df[[nm]])))
  } else rep(NA_real_, nrow(df))
  scrimmage <- (num("pass") %in% 1) | (num("rush") %in% 1)
  # `%in%` above collapses NA to FALSE, which is the intent: an unclassified
  # play is not a passing down.
  d <- num("down"); dist <- num("distance")
  out <- scrimmage & (
    (d == 2 & dist >= 8) | (d == 3 & dist >= 5) | (d == 4 & dist >= 5)
  )
  as.numeric(!is.na(out) & out)
}

#' Build the CP model's feature matrix
#' @keywords internal
#' @noRd
.cp_feature_matrix <- function(df) {
  n <- nrow(df)
  pick <- function(nm) suppressWarnings(as.numeric(as.character(df[[nm]])))
  m <- cbind(
    down = pick("down"),
    distance = pick("distance"),
    yards_to_goal = pick("yards_to_goal"),
    # NOT df$score_diff -- see .CP_FEATURES.
    score_diff = pick("pos_score_diff_start"),
    seconds_remaining = pick("TimeSecsRem"),
    is_home = .wp_is_home(df),
    period = pick("period"),
    passing_down = .cp_passing_down(df)
  )
  colnames(m) <- .CP_FEATURES
  m
}

#' Append completion probability (`cp`) and completion % over expected (`cpoe`)
#'
#' `cp` is populated on pass plays only; `cpoe` is
#' `100 * (completion - cp)` on those same plays, matching sdv-py's
#' percentage-point scale. Both are `NA` elsewhere.
#'
#' Never raises: a missing model, missing `xgboost`, or a frame lacking the
#' required inputs yields all-`NA` columns, so the surface is safe to run
#' unconditionally in the pipeline.
#'
#' **Interpreting `cpoe` before ~2014.** ESPN's early play-by-play does not
#' label sacks: 2013 week 1 carries 5 across 13,800 plays, against ~337 per
#' week from 2018 on. A sack is a pass play with no completion, so its absence
#' inflates the observed completion rate and pushes league-wide `cpoe` roughly
#' +6 percentage points in those seasons (2013 wk1 +5.9pp and wk8 +6.7pp,
#' against +0.05pp in 2018 and +0.54pp in 2021). This is an upstream
#' data-coverage artefact rather than a model or scoring error -- mean `cp`
#' itself is stable at ~0.566 in every era, and excluding sacks the completion
#' rates converge (0.626 / 0.601 / 0.605). Treat early-era `cpoe` as
#' non-comparable to the modern era, not as better quarterback play.
#'
#' @keywords internal
#' @noRd
.pbp_add_cp_cpoe <- function(df) {
  # rep() not a scalar: `df$cp <- NA_real_` errors on a zero-row frame
  # ("replacement has 1 row, data has 0").
  df$cp <- rep(NA_real_, nrow(df))
  df$cpoe <- rep(NA_real_, nrow(df))
  need <- c("down", "distance", "yards_to_goal", "pos_score_diff_start",
            "TimeSecsRem", "period", "pass", "completion")
  if (!nrow(df) || !all(need %in% names(df))) return(df)
  model <- .cfb_cp_model()
  if (is.null(model)) return(df)

  p <- try({
    x <- .cp_feature_matrix(df)
    as.numeric(stats::predict(model, x))
  }, silent = TRUE)
  if (inherits(p, "try-error") || length(p) != nrow(df)) return(df)

  is_pass <- suppressWarnings(as.numeric(as.character(df$pass))) %in% 1
  comp <- suppressWarnings(as.numeric(as.character(df$completion)))
  df$cp <- ifelse(is_pass, p, NA_real_)
  df$cpoe <- ifelse(is_pass & !is.na(comp), 100 * (comp - df$cp), NA_real_)
  df
}

#' Season of a game, falling back to its date
#'
#' `.espn_pbp_game_meta()` leaves `season` as `NA_integer_` when the event's
#' week/season `$ref` cannot be resolved. Handing that to the era-aware FG
#' model aborts scoring for the whole game, and the wrapper's outer handler
#' swallows it -- the game comes back silently unmodeled.
#'
#' The season is therefore DERIVED from the game date rather than defaulted:
#' fabricating one would produce a valid-looking era one-hot and quietly skew
#' every field-goal probability, which is the failure this whole path is built
#' to avoid. The cut matches [most_recent_cfb_season()] -- a game before
#' August belongs to the previous season, which is what keeps bowl and playoff
#' games in January with the season they were played in.
#'
#' @param season Season as resolved by the caller; used when usable.
#' @param game_date Date-like string, e.g. ESPN's ISO timestamp.
#' @return Numeric season, or `NA_real_` when neither source is usable.
#' @keywords internal
#' @noRd
.cfb_season_or_date <- function(season, game_date = NULL) {
  s <- suppressWarnings(as.numeric(season))
  if (length(s) && !all(is.na(s))) return(s)
  if (is.null(game_date) || !length(game_date) || all(is.na(game_date))) {
    return(NA_real_)
  }
  # tryCatch, not suppressWarnings: as.Date() on an unparseable string ERRORS
  # ("character string is not in a standard unambiguous format"), which would
  # propagate out of the very helper that exists to degrade gracefully.
  d <- tryCatch(as.Date(substr(as.character(game_date[1]), 1, 10)),
                error = function(e) NA)
  if (length(d) != 1L || is.na(d)) return(NA_real_)
  yr <- as.numeric(format(d, "%Y"))
  mo <- as.numeric(format(d, "%m"))
  ifelse(mo < 8, yr - 1, yr)
}

#' Field-goal model feature contract and rule-era cuts
#'
#' The bundled `fg_model` is era-aware: `yards_to_goal` plus one-hot rule-era
#' dummies. The retired model was a single-feature `mgcv::bam`
#' (`fg_made ~ 1 + yards_to_goal`), so era is new information the frame has to
#' supply.
#'
#' **These cuts (2006/2013/2020) are the ONE-HOT `era0..era3` cuts used by
#' `fg_model` and `fd_model`.** sdv-py also carries a distinct *ordinal* `era`
#' with cuts 2006/2013/**2017** for `xpass_model` / `two_pt_model`. The two are
#' not interchangeable; conflating them silently mis-labels the 2018-2020
#' seasons.
#'
#' @keywords internal
#' @noRd
.FG_ERA_CUTS <- c(2006, 2013, 2020)

#' @keywords internal
#' @noRd
.FG_FEATURES <- c("yards_to_goal", "era0", "era1", "era2", "era3")

#' Feature names of a booster, across xgboost API generations
#'
#' xgboost 3.x exposes these via `getinfo(m, "feature_name")`; the older
#' `m$feature_names` handle attribute comes back empty there and would make a
#' contract check silently pass on an empty set.
#'
#' @keywords internal
#' @noRd
.booster_feature_names <- function(model) {
  fn <- try(xgboost::getinfo(model, "feature_name"), silent = TRUE)
  if (inherits(fn, "try-error") || !length(fn)) fn <- model$feature_names
  as.character(fn %||% character())
}

#' One-hot CFB rule-era dummies from season
#'
#' @param season Scalar or length-`n` season; recycled to `n` rows.
#' @param n Number of rows to emit.
#' @keywords internal
#' @noRd
.cfb_era_onehot <- function(season, n) {
  s <- suppressWarnings(as.numeric(season))
  if (length(s) == 1L) s <- rep(s, n)
  lo <- .FG_ERA_CUTS[1]; mid <- .FG_ERA_CUTS[2]; hi <- .FG_ERA_CUTS[3]
  cbind(
    era0 = as.numeric(s <= lo),
    era1 = as.numeric(s > lo & s <= mid),
    era2 = as.numeric(s > mid & s <= hi),
    era3 = as.numeric(s > hi)
  )
}

#' Field-goal make probability, whichever model generation is loaded
#'
#' @param fg_mod The bundle's `xgb.Booster`, or the retired `mgcv::bam`.
#' @param newdata Frame carrying `yards_to_goal`.
#' @param season Season of the game, required when the loaded model declares
#'   era features.
#' @return Numeric make-probability, `nrow(newdata)` long.
#' @keywords internal
#' @noRd
.fg_make_prob <- function(fg_mod, newdata, season = NULL) {
  if (!inherits(fg_mod, "xgb.Booster")) {
    return(as.numeric(mgcv::predict.bam(fg_mod, newdata = newdata,
                                        type = "response")))
  }
  rlang::check_installed("xgboost", reason = "to score the bundled FG model.")
  fnames <- .booster_feature_names(fg_mod)
  if (!length(fnames)) fnames <- "yards_to_goal"

  x <- cbind(yards_to_goal = as.numeric(newdata$yards_to_goal))
  if (any(startsWith(fnames, "era"))) {
    # Fail loudly rather than defaulting season: an absent season would make
    # every era dummy 0, which is not a valid one-hot and silently shifts every
    # field-goal probability. sdv-py raises here for the same reason.
    if (is.null(season) || all(is.na(season))) {
      cli::cli_abort(c(
        "The bundled era-aware FG model requires {.arg season}.",
        x = "Without it the era features would all be zero and quietly skew every FG probability.",
        i = "Pass {.arg season} through {.fn .run_epa_wpa}."
      ))
    }
    x <- cbind(x, .cfb_era_onehot(season, nrow(newdata)))
  }
  keep <- intersect(fnames, colnames(x))
  as.numeric(stats::predict(fg_mod, x[, keep, drop = FALSE]))
}

#' Spread-aware Win Probability feature contract
#'
#' `wp_naive` plus `spread_time` in slot 2 -- the booster's own order.
#'
#' @keywords internal
#' @noRd
.WP_SPREAD_FEATURES <- append(.WP_NAIVE_FEATURES, "spread_time", after = 1L)

#' Lazily load the bundled spread-aware WP model
#' @keywords internal
#' @noRd
.cfb_wp_spread_model <- function() {
  if (!is.null(.cfb_model_env$wp_spread)) return(.cfb_model_env$wp_spread)
  # A failed fetch is remembered too. Without it .cfb_model_file() retries the
  # download on EVERY game of a season sweep and pays the timeout each time.
  if (isTRUE(.cfb_model_env$unavailable[["wp_spread"]])) return(NULL)
  fail <- function() {
    .cfb_model_env$unavailable[["wp_spread"]] <- TRUE
    NULL
  }
  if (!requireNamespace("xgboost", quietly = TRUE)) return(fail())
  f <- .cfb_model_file("wp_spread.ubj")
  if (is.null(f)) return(fail())
  b <- try(xgboost::xgb.load(f), silent = TRUE)
  if (inherits(b, "try-error") || is.null(b)) return(fail())
  .cfb_model_env$wp_spread <- b
  b
}

#' Spread from the possessing team's point of view
#'
#' **Sign convention, verified empirically over 83 games of 2021 week 1 with
#' zero exceptions** (`formatted_spread` names the favourite, so it is ground
#' truth): CFBD's `spread` is negative when the HOME team is favoured and
#' positive when the AWAY team is favoured.
#'
#' The booster reads the opposite orientation: scoring the model directly shows
#' win probability rising monotonically with `spread_time`
#' (-28 -> 0.04, 0 -> 0.49, +28 -> 0.96), i.e. **positive means the team in
#' possession is favoured**. So the home team's spread is negated and the away
#' team's is kept.
#'
#' Getting this backwards is not a crash -- it produces confident, exactly
#' inverted win probabilities. That is why the convention is pinned by test.
#'
#' @keywords internal
#' @noRd
.wp_pos_team_spread <- function(df) {
  if (!all(c("spread", "pos_team", "home") %in% names(df))) return(NULL)
  spread <- suppressWarnings(as.numeric(df$spread))
  if (all(is.na(spread))) return(NULL)
  is_home <- !is.na(df$pos_team) & !is.na(df$home) & df$pos_team == df$home
  ifelse(is_home, -spread, spread)
}

#' Time-decayed spread (`spread_time`)
#'
#' `pos_team_spread * exp(-4 * elapsed_share)`, so the pre-game line's
#' influence decays as the game runs down. `elapsed_share` is clamped at 0
#' below only, matching sdv-py -- its nominal upper clamp cannot bind for any
#' non-negative `adj_TimeSecsRem`.
#'
#' @keywords internal
#' @noRd
.wp_spread_time <- function(df) {
  pts <- .wp_pos_team_spread(df)
  if (is.null(pts)) return(NULL)
  adj <- suppressWarnings(as.numeric(df$adj_TimeSecsRem))
  elapsed_share <- pmax((3600 - adj) / 3600, 0)
  pts * exp(-4 * elapsed_share)
}

#' Append spread-aware win probability (`vegas_wp`)
#'
#' Additive and non-breaking: the naive `wp_before` / `wpa` columns are left
#' exactly as they were, and `vegas_wp` is added alongside -- the same split
#' nflfastR draws between `wp` and `vegas_wp`. `NA` wherever no pre-game spread
#' is available (the whole ESPN path today, and CFBD before 2013).
#'
#' Never raises; a missing model or missing inputs yields an all-`NA` column.
#'
#' @keywords internal
#' @noRd
.pbp_add_vegas_wp <- function(df) {
  df$vegas_wp <- rep(NA_real_, nrow(df))
  if (!nrow(df)) return(df)
  spread_time <- .wp_spread_time(df)
  if (is.null(spread_time)) return(df)
  model <- .cfb_wp_spread_model()
  if (is.null(model)) return(df)

  p <- try({
    base <- .wp_feature_matrix(df)
    x <- cbind(base, spread_time = spread_time)[, .WP_SPREAD_FEATURES, drop = FALSE]
    as.numeric(stats::predict(model, x))
  }, silent = TRUE)
  if (inherits(p, "try-error") || length(p) != nrow(df)) return(df)

  # Rows whose game had no line keep NA rather than a spread-less guess.
  df$vegas_wp <- ifelse(is.na(spread_time), NA_real_, p)
  df
}

#' Expected-pass feature contract and the ORDINAL rule-era cuts
#'
#' `.XPASS_ERA_CUTS` is the **ordinal** `era` used by `xpass_model` and
#' `two_pt_model` -- cuts 2006/2013/**2017**, encoded 0/1/2/3 in one column.
#' It is NOT [.FG_ERA_CUTS], the one-hot `era0..era3` set used by
#' `fg_model`/`fd_model`, whose third cut is **2020**. The two disagree over
#' 2018-2020, so they are deliberately separate constants.
#'
#' @keywords internal
#' @noRd
.XPASS_ERA_CUTS <- c(2006, 2013, 2017)

#' @keywords internal
#' @noRd
.XPASS_FEATURES <- c(
  "down", "distance", "yards_to_goal", "pos_score_diff",
  "TimeSecsRem", "era", "period"
)

#' Ordinal CFB rule era from season
#'
#' @return 0 (<=2006), 1 (<=2013), 2 (<=2017), 3 (later).
#' @keywords internal
#' @noRd
.cfb_era_ordinal <- function(season, n) {
  s <- suppressWarnings(as.numeric(season))
  if (length(s) == 1L) s <- rep(s, n)
  cuts <- .XPASS_ERA_CUTS
  ifelse(s <= cuts[1], 0,
         ifelse(s <= cuts[2], 1,
                ifelse(s <= cuts[3], 2, 3)))
}

#' Lazily load the bundled expected-pass model
#' @keywords internal
#' @noRd
.cfb_xpass_model <- function() {
  if (!is.null(.cfb_model_env$xpass)) return(.cfb_model_env$xpass)
  # A failed fetch is remembered too. Without it .cfb_model_file() retries the
  # download on EVERY game of a season sweep and pays the timeout each time.
  if (isTRUE(.cfb_model_env$unavailable[["xpass"]])) return(NULL)
  fail <- function() {
    .cfb_model_env$unavailable[["xpass"]] <- TRUE
    NULL
  }
  if (!requireNamespace("xgboost", quietly = TRUE)) return(fail())
  f <- .cfb_model_file("xpass_model.ubj")
  if (is.null(f)) return(fail())
  b <- try(xgboost::xgb.load(f), silent = TRUE)
  if (inherits(b, "try-error") || is.null(b)) return(fail())
  .cfb_model_env$xpass <- b
  b
}

#' Append expected pass rate (`xpass`) and pass over expected (`pass_oe`)
#'
#' nflfastR's `xpass` / `pass_oe`, on scrimmage plays only, with `pass_oe` on
#' the percentage-point scale `100 * (pass - xpass)`.
#'
#' Note the `pos_score_diff` feature is fed from **`pos_score_diff_start`**,
#' the same sourcing subtlety as the CP model: cfbfastR carries a separate
#' like-named `pos_score_diff` column holding a different value.
#'
#' Never raises; missing model, season or inputs yield all-`NA` columns.
#'
#' @param season Season of the game, needed for the ordinal era feature.
#' @keywords internal
#' @noRd
.pbp_add_xpass <- function(df, season = NULL) {
  df$xpass <- rep(NA_real_, nrow(df))
  df$pass_oe <- rep(NA_real_, nrow(df))
  need <- c("down", "distance", "yards_to_goal", "pos_score_diff_start",
            "TimeSecsRem", "period", "pass", "rush")
  if (!nrow(df) || !all(need %in% names(df))) return(df)
  if (is.null(season) || all(is.na(season))) return(df)
  model <- .cfb_xpass_model()
  if (is.null(model)) return(df)

  p <- try({
    pick <- function(nm) suppressWarnings(as.numeric(as.character(df[[nm]])))
    x <- cbind(
      down = pick("down"),
      distance = pick("distance"),
      yards_to_goal = pick("yards_to_goal"),
      # NOT df$pos_score_diff -- see the note above.
      pos_score_diff = pick("pos_score_diff_start"),
      TimeSecsRem = pick("TimeSecsRem"),
      era = .cfb_era_ordinal(season, nrow(df)),
      period = pick("period")
    )
    colnames(x) <- .XPASS_FEATURES
    as.numeric(stats::predict(model, x))
  }, silent = TRUE)
  if (inherits(p, "try-error") || length(p) != nrow(df)) return(df)

  pass <- suppressWarnings(as.numeric(as.character(df$pass)))
  rush <- suppressWarnings(as.numeric(as.character(df$rush)))
  scrimmage <- (pass %in% 1) | (rush %in% 1)
  df$xpass <- ifelse(scrimmage, p, NA_real_)
  df$pass_oe <- ifelse(scrimmage & !is.na(pass), 100 * (pass - df$xpass), NA_real_)
  df
}

#' Two-point conversion feature contract
#'
#' Uses the ORDINAL era ([.cfb_era_ordinal()], cuts 2006/2013/2017), the same
#' encoding `xpass_model` takes -- not the one-hot set the FG model uses.
#'
#' @keywords internal
#' @noRd
.TWO_PT_FEATURES <- c("posteam_spread", "posteam_total", "pos_score_diff", "era")

#' Lazily load the bundled two-point conversion model
#' @keywords internal
#' @noRd
.cfb_two_pt_model <- function() {
  if (!is.null(.cfb_model_env$two_pt)) return(.cfb_model_env$two_pt)
  # A failed fetch is remembered too. Without it .cfb_model_file() retries the
  # download on EVERY game of a season sweep and pays the timeout each time.
  if (isTRUE(.cfb_model_env$unavailable[["two_pt"]])) return(NULL)
  fail <- function() {
    .cfb_model_env$unavailable[["two_pt"]] <- TRUE
    NULL
  }
  if (!requireNamespace("xgboost", quietly = TRUE)) return(fail())
  f <- .cfb_model_file("two_pt_model.ubj")
  if (is.null(f)) return(fail())
  b <- try(xgboost::xgb.load(f), silent = TRUE)
  if (inherits(b, "try-error") || is.null(b)) return(fail())
  .cfb_model_env$two_pt <- b
  b
}

#' Implied team total for the team in possession
#'
#' Not the game over/under: the market's expected points for THIS team, split
#' out of the total using the spread. `(homeTeamSpread + overUnder) / 2` when
#' the posteam is home, `(overUnder - homeTeamSpread) / 2` when away.
#'
#' `homeTeamSpread` is the negation of CFBD's `spread` -- CFBD is negative when
#' the home team is favoured (verified over 83 games, see
#' [.wp_pos_team_spread()]) while `homeTeamSpread` is positive then. Skipping
#' that conversion silently swaps the two teams' implied totals.
#'
#' @keywords internal
#' @noRd
.cfb_posteam_total <- function(df) {
  if (!all(c("spread", "over_under") %in% names(df))) return(NULL)
  spread <- suppressWarnings(as.numeric(df$spread))
  ou <- suppressWarnings(as.numeric(df$over_under))
  if (all(is.na(spread)) || all(is.na(ou))) return(NULL)
  home_spread <- -spread
  is_home <- .wp_is_home(df) == 1
  ifelse(is_home, (home_spread + ou) / 2, (ou - home_spread) / 2)
}

#' Score differential at the two-point decision, from the scoring team's view
#'
#' The PAT shares the touchdown's play row in this data (CFBD emits no separate
#' extra-point rows), so `pos_score_diff_start` is the PRE-touchdown margin and
#' the decision has to be scored at the POST-touchdown one: add 6.
#'
#' The `+6` applies to OFFENSIVE touchdowns only. `pass_td` also fires on
#' pick-sixes, so it is ANDed with `offense_score_play`; without that a
#' defensive return touchdown would push the possessing team's score frame the
#' wrong way by six points.
#'
#' @keywords internal
#' @noRd
.two_pt_score_diff <- function(df) {
  diff <- suppressWarnings(as.numeric(df$pos_score_diff_start))
  tf <- function(nm) {
    if (!nm %in% names(df)) return(rep(FALSE, nrow(df)))
    v <- df[[nm]]
    if (is.logical(v)) return(!is.na(v) & v)
    suppressWarnings(as.numeric(v)) %in% 1
  }
  offensive_td <- (tf("pass_td") | tf("rush_td")) & tf("offense_score_play")
  ifelse(offensive_td, diff + 6, diff)
}

#' Rows where a two-point decision is actually faced
#'
#' Offensive touchdowns. A defensive score is not the possessing team's
#' decision, and a non-scoring play has no try to make.
#'
#' @keywords internal
#' @noRd
.two_pt_decision_rows <- function(df) {
  tf <- function(nm) {
    if (!nm %in% names(df)) return(rep(FALSE, nrow(df)))
    v <- df[[nm]]
    if (is.logical(v)) return(!is.na(v) & v)
    suppressWarnings(as.numeric(v)) %in% 1
  }
  (tf("pass_td") | tf("rush_td")) & tf("offense_score_play")
}

#' Append the two-point conversion probability (`prob_2pt`)
#'
#' The bundled model's conversion probability on the rows where a team has just
#' scored an offensive touchdown and must choose between the extra point and
#' going for two. `NA` on every other row, and wherever the game has no
#' pre-game line (the model reads the spread and the implied team total).
#'
#' This is the model-scoring half of the surface. The full cfb4th decision
#' (`two_pt_wp` / `xp_wp` / `two_pt_recommendation`) additionally needs the
#' opponent's ensuing-drive win probability scored for each try outcome, which
#' is tracked separately.
#'
#' Never raises.
#'
#' @param season Season of the game, for the ordinal era feature.
#' @keywords internal
#' @noRd
.pbp_add_two_pt_prob <- function(df, season = NULL) {
  df$prob_2pt <- rep(NA_real_, nrow(df))
  if (!nrow(df) || !"pos_score_diff_start" %in% names(df)) return(df)
  if (is.null(season) || all(is.na(season))) return(df)
  total <- .cfb_posteam_total(df)
  spread <- .wp_pos_team_spread(df)
  if (is.null(total) || is.null(spread)) return(df)
  model <- .cfb_two_pt_model()
  if (is.null(model)) return(df)

  p <- try({
    x <- cbind(
      posteam_spread = spread,
      posteam_total = total,
      pos_score_diff = .two_pt_score_diff(df),
      era = .cfb_era_ordinal(season, nrow(df))
    )
    colnames(x) <- .TWO_PT_FEATURES
    as.numeric(stats::predict(model, x))
  }, silent = TRUE)
  if (inherits(p, "try-error") || length(p) != nrow(df)) return(df)

  rows <- .two_pt_decision_rows(df)
  df$prob_2pt <- ifelse(rows & !is.na(spread) & !is.na(total), p, NA_real_)
  df
}
