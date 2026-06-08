

test_that("ESPN CFB Venues Index", {
  skip_on_cran()

  cols <- c(
    "venue_id", "full_name", "city", "state", "zip_code", "country",
    "grass", "indoor", "venue_ref"
  )

  x <- espn_cfb_venues(max_results = 50)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN venues data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_s3_class(x, "data.frame")
  expect_lte(nrow(x), 50L)
})
