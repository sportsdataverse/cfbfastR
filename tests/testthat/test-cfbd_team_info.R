
cols <- c(
  "team_id", "school", "mascot", "abbreviation", "alt_name1", "alt_name2",
  "alt_name3", "conference", "division",
  "color", "alt_color", "logo", "logo_2", "twitter", "venue_id", "venue_name",
  "city", "state", "zip", "country_code", "timezone",
  "latitude","longitude","elevation",
  "capacity", "year_constructed", "grass", "dome")

test_that("CFB Team Info", {
  skip_on_cran()
  x <- cfbd_team_info(year = 2019)

  expect_equal(nrow(x), 130)
  expect_equal(ncol(x), length(cols))
  expect_equal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})
