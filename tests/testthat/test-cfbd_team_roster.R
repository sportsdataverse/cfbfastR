context("CFB Team Roster")

x <- cfbd_team_roster(2019, team = 'Florida State')

y <- cfbd_team_roster(2018, team = 'Texas A&M')

z <- cfbd_team_roster(2017)

cols <- c("athlete_id", "first_name", "last_name","team", "weight", "height",
          "jersey", "year", "position","home_city","home_state",
          "home_country")

test_that("CFB Team Roster", {
  expect_equal(colnames(x), cols)
  expect_equal(colnames(y), cols)
  expect_equal(colnames(z), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_s3_class(z, "data.frame")
})
