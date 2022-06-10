
cols <- c(
  #"athlete_id",
  "season", "first_name", "last_name", "position", "origin", "destination", "transfer_date",
  "rating", "stars", "eligibility"
)

test_that("CFB Transfer Portal", {
  skip_on_cran()
  x <- cfbd_recruiting_transfer_portal(year = 2021)
  expect_equal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})
