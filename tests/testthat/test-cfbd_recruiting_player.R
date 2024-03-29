

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

  y <- cfbd_recruiting_player(2016, team = "Virginia")

  z <- cfbd_recruiting_player(2011)
  expect_equal(colnames(x), cols)
  expect_equal(colnames(y), cols)
  expect_equal(colnames(z), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_s3_class(z, "data.frame")
})
