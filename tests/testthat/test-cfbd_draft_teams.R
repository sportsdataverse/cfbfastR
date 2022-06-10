

cols <- c(
  "nfl_location", "nfl_nickname", "nfl_display_name","nfl_logo"
)

test_that("NFL Draft Teams", {
  skip_on_cran()
  x <- cfbd_draft_teams()
  expect_equal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})
