
cols <- c(
  "season", "team", "conference", "total_ppa", "total_passing_ppa",
  "total_receiving_ppa", "total_rushing_ppa", "percent_ppa",
  "percent_passing_ppa", "percent_receiving_ppa", "percent_rushing_ppa", "usage",
  "passing_usage", "receiving_usage", "rushing_usage"
)

test_that("CFB Player Returning", {

  skip_on_cran()
  x <- cfbd_player_returning(year = 2020, team = "Florida State")
  expect_equal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})
