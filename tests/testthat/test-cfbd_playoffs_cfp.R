cols <- c("round_code", "id", "bracket_slot", "start_date", "game_id", "slot1_school", "slot2_school", "season")

test_that("CFB Playoff Bracket", {
  skip_on_cran()
  x <- cfbd_playoffs_cfp(2024)
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  # Subset direction (expected subset of actual), per the repo convention:
  # CFBD adds columns over time and an exact set/count assertion turns that
  # into a red build for a change that broke nothing.
  expect_in(cols, colnames(x))
  expect_s3_class(x, "data.frame")
  # Every column must be atomic -- these endpoints ship nested objects and
  # a list-column surviving into the result breaks dplyr verbs downstream.
  expect_true(all(vapply(x, is.atomic, logical(1))))
})
