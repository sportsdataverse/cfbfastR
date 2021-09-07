context("CFB Coaches")

cols <- c(
  "first_name", "last_name","hire_date", "school", "year", "games",
  "wins", "losses", "ties", "preseason_rank", "postseason_rank", "srs", "sp_overall",
  "sp_offense", "sp_defense"
)

test_that("CFB Coaches", {
  skip_on_cran()
  x <- cfbd_coaches(first = "Nick", last = "Saban", team = "alabama")
  expect_equal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})
