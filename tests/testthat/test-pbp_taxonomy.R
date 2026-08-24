test_that(".pbp_play_types() returns the canonical play-type vectors", {
  testthat::skip_on_cran()
  tt <- cfbfastR:::.pbp_play_types()

  expect_type(tt, "list")
  expect_named(tt, c(
    "kickoff", "turnover", "scores", "offense_score", "defense_score",
    "normalplay", "penalty", "int", "punt", "field_goal", "turnover_play_type"
  ), ignore.order = TRUE)

  # Each entry is a non-empty character vector
  purrr::walk(tt, function(v) {
    expect_type(v, "character")
    expect_gt(length(v), 0L)
  })

  # Each entry has no duplicates
  purrr::walk(tt, function(v) expect_equal(length(unique(v)), length(v)))

  # Canonical taxonomy resolutions
  expect_true("Fumble Recovery (Own)" %in% tt$normalplay)   # union resolution
  expect_true("Kickoff Return Touchdown" %in% tt$offense_score)
  expect_true("Penalty (Kickoff)" %in% tt$kickoff)
  expect_true("Safety" %in% tt$defense_score)
})
