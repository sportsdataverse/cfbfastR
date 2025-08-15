
cols <- c(
  "year", "conference", "rating", "second_order_wins", "sos",
  "offense_rating", "offense_success", "offense_explosiveness",
  "offense_rushing", "offense_passing", "offense_standard_downs",
  "offense_passing_downs", "offense_run_rate",
  "offense_pace", "defense_rating", "defense_success", "defense_explosiveness",
  "defense_rushing", "defense_passing", "defense_standard_downs",
  "defense_passing_downs", "defense_havoc_total", "defense_havoc_front_seven",
  "defense_havoc_db", "special_teams_rating"
)

test_that("CFB Conference Ratings - Bill C.'s SP+", {
  skip_on_cran()
  x <- cfbd_ratings_sp_conference(year = 2019)

  y <- cfbd_ratings_sp_conference(year = 2012, conference = "SEC")

  z <- cfbd_ratings_sp_conference(year = 2016, conference = "ACC")

  expect_setequal(colnames(x), cols)
  expect_setequal(colnames(y), cols)
  expect_setequal(colnames(z), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_s3_class(z, "data.frame")
})
