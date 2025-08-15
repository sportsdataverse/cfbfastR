

cols <- c(
  "position_name", "position_abbreviation"
)

test_that("NFL Draft Positions", {
  skip_on_cran()
  x <- cfbd_draft_positions()
  expect_setequal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})
