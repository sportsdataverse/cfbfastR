context("CFB Player Usage")


cols <- c(
  "season", "athlete_id", "name", "position", "team", "conference", "usg_overall",
  "usg_pass", "usg_rush", "usg_1st_down", "usg_2nd_down", "usg_3rd_down",
  "usg_standard_downs", "usg_passing_downs"
)

test_that("CFB Player Usage", {
  skip_on_cran()
  x <- cfbd_player_usage(year = 2019, position = "WR", team = "Florida State")
  expect_equal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})
