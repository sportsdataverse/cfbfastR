

cols <- c(
  "nfl_location", "nfl_nickname", "nfl_display_name","nfl_logo"
)

test_that("NFL Draft Teams", {
  skip_on_cran()
  x <- cfbd_draft_teams()
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_setequal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})
