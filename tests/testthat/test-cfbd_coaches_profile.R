cols <- c("id", "first_name", "last_name",
          # career_* guards a REGRESSION, not a nicety: an earlier version
          # dropped the whole career block and still returned a clean
          # 1-row frame, so only naming these columns catches it coming back.
          "career_seasons", "career_games", "career_wins", "career_win_percentage")

test_that("CFB Coach Profile", {
  skip_on_cran()
  # The endpoint is keyed by coach id, so look one up rather than hard-coding
  # an id that could be retired upstream.
  tenures <- cfbd_coaches_tenures(team = "Georgia")
  if (is.null(tenures) || !is.data.frame(tenures) || nrow(tenures) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  id_col <- grep("coach", colnames(tenures), value = TRUE)[1]
  skip_if(is.na(id_col), "no coach id column in tenures")
  x <- cfbd_coaches_profile(coach_id = tenures[[id_col]][1])
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  # Subset direction (expected subset of actual), per the repo convention.
  expect_in(cols, colnames(x))
  expect_s3_class(x, "data.frame")
  # This endpoint ships a nested object; a surviving list-column would pass
  # every column assertion above while breaking dplyr verbs downstream.
  expect_true(all(vapply(x, is.atomic, logical(1))))
})
