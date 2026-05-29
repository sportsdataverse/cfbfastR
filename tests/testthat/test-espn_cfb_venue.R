

test_that("ESPN CFB Venue Detail", {
  skip_on_cran()

  cols <- c(
    "venue_id", "full_name", "city", "state", "zip_code", "country",
    "grass", "indoor", "venue_ref"
  )

  x <- espn_cfb_venue(venue_id = 3785)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN venue data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_s3_class(x, "data.frame")
})
