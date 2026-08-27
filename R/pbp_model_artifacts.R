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
#' @name cfb_model_artifacts
#' @keywords internal
NULL

#' @rdname cfb_model_artifacts
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

#' @rdname cfb_model_artifacts
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
