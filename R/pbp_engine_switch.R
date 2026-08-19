#' Choose which play-by-play engine the legacy entry points use
#'
#' @description `cfbd_pbp_data()` and `espn_cfb_pbp()` predate the modular
#'   PBP/EPA/WPA engine. Their v2 counterparts -- [cfbd_pbp_data_v2()] and
#'   [espn_cfb_pbp_v2()] -- run the same models through the shared
#'   `.run_epa_wpa()` pipeline, and are where new parsing work lands: penalty
#'   enforcement resolution, roster-resolved `*_player_id` columns, and the
#'   `output` tier selector.
#'
#' @details Rather than ask every caller to rewrite their code, the legacy
#'   functions can **delegate** to their v2 counterpart. There are two ways to
#'   ask for that, and they compose:
#'
#'   \describe{
#'     \item{Per call}{Pass `engine = "v2"` to the legacy function.}
#'     \item{Session-wide}{`options(cfbfastR.pbp_engine = "v2")`, after which
#'       every legacy call in the session upgrades with no code change.}
#'   }
#'
#'   The per-call argument wins over the option; the option wins over the
#'   default. **The default is `"v2"` as of this release.** An existing script
#'   keeps working and gains the new columns; a caller who needs the old frame
#'   back has the escape hatch `engine = "legacy"`, per call or session-wide via
#'   `options(cfbfastR.pbp_engine = "legacy")`.
#'
#'   `"auto"` means *whatever this version of the package considers current*, so
#'   a caller who writes it is carried forward by future flips rather than by
#'   editing their code again. It resolves to `"v2"` today.
#'
#'   Delegation is safe because `tests/testthat/test-pbp_equivalence.R` asserts
#'   v2 reproduces the legacy frames column-for-column, with an explicit
#'   allow-list of intentional deltas. What a delegating caller gains is the new
#'   columns and the `output` tiers; what they must not gain is a silently
#'   different shape.
#'
#' @param engine (*character* optional): `"legacy"`, `"v2"`, `"auto"`, or `NULL`
#'   to resolve from `getOption("cfbfastR.pbp_engine")`.
#' @return One of `"legacy"` or `"v2"`.
#' @keywords internal
#' @noRd
.pbp_engine <- function(engine = NULL) {
  # The version this package release considers current. Flipping the default is
  # a one-line change here plus the option default below.
  current <- "v2"

  e <- engine %||% getOption("cfbfastR.pbp_engine", current)
  if (!is.character(e) || length(e) != 1L || !e %in% c("legacy", "v2", "auto")) {
    cli::cli_abort(c(
      "{.arg engine} must be one of {.val legacy}, {.val v2}, or {.val auto}.",
      x = "You supplied {.val {e}}.",
      i = "Set it for the whole session with {.code options(cfbfastR.pbp_engine = \"v2\")}."
    ))
  }
  if (identical(e, "auto")) current else e
}

#' Warn once per session that a legacy engine is in use
#'
#' @description Nudges toward the v2 engine without turning every call into a
#'   console message. Deliberately once-per-session: a season sweep calls the
#'   legacy entry point per week, and a warning on each would be noise the user
#'   learns to filter out -- which is how a real deprecation notice gets missed.
#'
#' @keywords internal
#' @noRd
.pbp_engine_nudge_state <- new.env(parent = emptyenv())

.pbp_engine_nudge <- function(fn, v2_fn) {
  if (isTRUE(.pbp_engine_nudge_state$warned)) return(invisible(NULL))
  .pbp_engine_nudge_state$warned <- TRUE
  cli::cli_inform(c(
    "i" = "{.fn {fn}} is running the legacy play-by-play engine, which is no
           longer the default.",
    "*" = "{.fn {v2_fn}} adds penalty enforcement resolution, ESPN-resolved
           player names, {.field *_player_id} columns and the {.arg output}
           tier selector.",
    "*" = "Drop {.code engine = \"legacy\"} (or
           {.code options(cfbfastR.pbp_engine = \"legacy\")}) to get it back."
  ))
  invisible(NULL)
}
