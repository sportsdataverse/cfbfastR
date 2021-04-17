context("CFB Metrics PPA Games")


cols <- c(
  "game_id", "season", "week", "conference", "team",
  "opponent", "off_overall", "off_passing", "off_rushing", "off_first_down",
  "off_second_down", "off_third_down", "def_overall", "def_passing",
  "def_rushing", "def_first_down", "def_second_down", "def_third_down"
)

test_that("CFB Metrics PPA Games", {
  skip_on_cran()
  x <- cfbd_metrics_ppa_games(year = 2019, team = "TCU")
  
  y <- cfbd_metrics_ppa_games(year = 2019, team = "Alabama", week = 11)
  expect_equal(colnames(x), cols)
  expect_equal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
