cols <- c("id", "team_id", "team_school")

test_that("CFB Coaches Tenures", {
  skip_on_cran()
  x <- cfbd_coaches_tenures(team = "Georgia")
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
