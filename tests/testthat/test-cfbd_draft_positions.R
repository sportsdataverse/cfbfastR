

cols <- c(
  "position_name", "position_abbreviation"
)

test_that("NFL Draft Positions", {
  skip_on_cran()
  x <- cfbd_draft_positions()
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_setequal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})
