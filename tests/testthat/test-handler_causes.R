# A wrapper's tryCatch() error handler must name the cause of a failure, not
# only "no data available": a 429, a 403 and a parse bug otherwise read like an
# empty result. Every request is made to fail offline and each wrapper whose
# body reports conditionMessage() must pass that cause on.

# Functions that cannot reach their error handler with this setup, with why.
.handler_cause_skip <- c(
  .espn_cfb_pbp_line = "no request to fail",
  cfbd_pbp_data = "a failed plays request is raised, not handled",
  cfbd_pbp_data_v2 = "a failed plays request is raised, not handled"
)

.handler_cause_args <- list(
  year = 2024L, season = 2024L, game_id = 401628374L, team_id = 2633L,
  athlete_id = 4426333L, team = "Texas", week = 1L, event_id = 401628374L,
  coach_id = 1L, franchise_id = 1L, position_id = 1L, venue_id = 1L,
  award_id = 1L, player_id = 1L, group_id = 80L, type = 1L,
  season_type = "regular", date = 20240907, id = 1L, drive_id = 1L,
  play_id = 1L, team1 = "Texas", team2 = "Oklahoma", down = 1L,
  distance = 10L, search_term = "Ewers", label = "punting",
  full_url = "https://api.collegefootballdata.com/punting/players/season?year=2024"
)

# Memoised helpers (.espn_cfb_team_lookup, ...) hide their body behind
# memoise's wrapper; test the function underneath.
.unmemoise <- function(f) {
  if (requireNamespace("memoise", quietly = TRUE) && memoise::is.memoised(f)) {
    environment(f)$`_f`
  } else {
    f
  }
}

test_that("error handlers report the cause of a failed request", {
  ns <- asNamespace("cfbfastR")
  reports_cause <- function(nm) {
    f <- .unmemoise(get(nm, envir = ns))
    if (!is.function(f) || is.primitive(f)) return(FALSE)
    b <- paste(deparse(body(f)), collapse = "\n")
    grepl("tryCatch", b, fixed = TRUE) &&
      grepl("error = function(e)", b, fixed = TRUE) &&
      grepl("conditionMessage(e)", b, fixed = TRUE)
  }
  fns <- Filter(reports_cause, ls(ns, all.names = TRUE))
  fns <- setdiff(fns, names(.handler_cause_skip))
  expect_gt(length(fns), 150L)

  withr::local_options(cfbfastR.cache = "off", cfbfastR.test_request_delay = 0)
  withr::local_envvar(CFBD_API_KEY = "test-key")
  # Wrappers call memoised lookups; don't leave failed results cached for later tests.
  espn_cfb_clear_cache()
  withr::defer(espn_cfb_clear_cache())
  local_mocked_bindings(
    req_perform = function(...) stop("mock outage"),
    .package = "httr2"
  )

  silent <- character()
  for (nm in fns) {
    f <- .unmemoise(get(nm, envir = ns))
    args <- .handler_cause_args[intersect(names(formals(f)), names(.handler_cause_args))]
    msgs <- character()
    withCallingHandlers(
      tryCatch(do.call(f, args), error = function(e) msgs <<- c(msgs, conditionMessage(e))),
      message = function(m) {
        msgs <<- c(msgs, conditionMessage(m))
        invokeRestart("muffleMessage")
      },
      warning = function(w) invokeRestart("muffleWarning")
    )
    if (!any(grepl("mock outage", msgs, fixed = TRUE))) silent <- c(silent, nm)
  }
  expect_identical(silent, character())
})
