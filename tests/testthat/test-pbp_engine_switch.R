### The legacy -> v2 upgrade path.
###
### These are offline: they exercise the resolver and the precedence rules, not
### the network. The delegation itself is covered by test-pbp_equivalence.R,
### which already asserts v2 reproduces the legacy frames column-for-column.

test_that("engine resolution follows per-call > option > default", {
  withr::local_options(list(cfbfastR.pbp_engine = NULL))
  # Default stays legacy so an existing script is untouched until it opts in.
  expect_equal(.pbp_engine(NULL), "legacy")
  expect_equal(.pbp_engine("v2"), "v2")
  expect_equal(.pbp_engine("legacy"), "legacy")

  withr::local_options(list(cfbfastR.pbp_engine = "v2"))
  expect_equal(.pbp_engine(NULL), "v2")
  # A per-call argument must beat the session option, or a user cannot pin one
  # call back to legacy while the rest of the session is upgraded.
  expect_equal(.pbp_engine("legacy"), "legacy")
})

test_that("auto tracks whatever this release considers current", {
  withr::local_options(list(cfbfastR.pbp_engine = NULL))
  # The point of "auto": a caller who writes it now is carried forward by the
  # release that flips the default, instead of editing their code a second time.
  expect_equal(.pbp_engine("auto"), "v2")
})

test_that("an unknown engine aborts with an actionable message", {
  expect_error(.pbp_engine("turbo"), "must be one of")
  expect_error(.pbp_engine(c("v2", "legacy")), "must be one of")
  expect_error(.pbp_engine(2L), "must be one of")
})

test_that("the legacy nudge fires once per session, not once per call", {
  # A season sweep calls the legacy entry point per week. A message on each is
  # noise the user learns to filter, which is how a real deprecation notice ends
  # up missed.
  .pbp_engine_nudge_state$warned <- NULL
  expect_message(.pbp_engine_nudge("cfbd_pbp_data", "cfbd_pbp_data_v2"))
  expect_no_message(.pbp_engine_nudge("cfbd_pbp_data", "cfbd_pbp_data_v2"))
  .pbp_engine_nudge_state$warned <- NULL
})

test_that("both legacy entry points accept the engine argument", {
  expect_true("engine" %in% names(formals(cfbd_pbp_data)))
  expect_true("engine" %in% names(formals(espn_cfb_pbp)))
  # output must be reachable from the legacy name too, or delegating callers
  # cannot get at the tier selector without renaming their call.
  expect_true("output" %in% names(formals(espn_cfb_pbp)))
})
