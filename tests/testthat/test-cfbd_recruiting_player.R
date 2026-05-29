

cols <- c(
  "id", "athlete_id", "recruit_type", "year", "ranking",
  "name", "school", "committed_to", "position",
  "height", "weight", "stars", "rating",
  "city", "state_province", "country","hometown_info_latitude",
  "hometown_info_longitude", "hometown_info_fips_code"
)

test_that("CFB Recruiting Player", {
  skip_on_cran()
  x <- cfbd_recruiting_player(2018, team = "Texas")
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }

  y <- cfbd_recruiting_player(2016, team = "Virginia")
  if (is.null(y) || !is.data.frame(y) || nrow(y) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }

  z <- cfbd_recruiting_player(2011)
  if (is.null(z) || !is.data.frame(z) || nrow(z) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_setequal(colnames(x), cols)
  expect_setequal(colnames(y), cols)
  expect_setequal(colnames(z), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_s3_class(z, "data.frame")
})
