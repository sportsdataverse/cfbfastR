
cols <- c(
  #"athlete_id",
  "season", "first_name", "last_name", "position", "origin", "destination", "transfer_date",
  "rating", "stars", "eligibility"
)

test_that("CFB Transfer Portal", {
  skip_on_cran()
  x <- cfbd_recruiting_transfer_portal(year = 2021)
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_setequal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})
