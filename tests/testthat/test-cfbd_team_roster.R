
cols <- c(
  "athlete_id", "first_name", "last_name", "team", "weight", "height",
  "jersey", "season", "year", "position", "home_city", "home_state",
  "home_country","home_latitude","home_longitude", "home_county_fips",'recruit_ids','headshot_url'
)

test_that("CFB Team Roster", {
  skip_on_cran()

  x <- cfbd_team_roster(2019, team = "Florida State")
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }

  y <- cfbd_team_roster(2018, team = "Texas A&M")
  if (is.null(y) || !is.data.frame(y) || nrow(y) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }

  z <- cfbd_team_roster(2017)
  if (is.null(z) || !is.data.frame(z) || nrow(z) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_setequal(colnames(x), cols)
  expect_setequal(colnames(y), cols)
  expect_setequal(colnames(z), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_s3_class(z, "data.frame")

  # season is the requested year; year is a class year (0-8, 0 = unknown) or NA
  # where CFBD returned the season instead (cfbfastR-data#14) -- never 4 digits.
  expect_true(all(x$season == 2019L))
  expect_true(all(y$season == 2018L))
  expect_true(all(z$season == 2017L))
  for (d in list(x, y, z)) {
    expect_type(d$year, "integer")
    expect_true(all(is.na(d$year) | (d$year >= 0L & d$year <= 8L)))
  }
})
