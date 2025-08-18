cols <- c(
  "venue_id", "name", "capacity", "grass", "city", "state",
  "zip", "country_code", "latitude", "longitude", "elevation", "year_constructed",
  "dome", "timezone"
)

test_that("CFB Venues", {
  skip_on_cran()

  x <- cfbd_venues()

  expect_setequal(ncol(x), length(cols))
  expect_setequal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})
