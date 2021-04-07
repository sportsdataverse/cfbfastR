context("CFB Coaches")

x <- cfbd_coaches(first = "Nick", last = "Saban", team = "alabama")

cols <- c(
  "first_name", "last_name", "school", "year", "games",
  "wins", "losses", "ties", "preseason_rank", "postseason_rank", "srs", "sp_overall",
  "sp_offense", "sp_defense"
)

test_that("CFB Coaches", {
  expect_equal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})
