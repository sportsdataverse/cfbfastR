cols <- c(
  "year",
  "team",
  "conference",
  "fpi",
  "resume_ranks_strength_of_record",
  "resume_ranks_fpi",
  "resume_ranks_average_win_probability",
  "resume_ranks_strength_of_schedule",
  "resume_ranks_remaining_strength_of_schedule",
  "resume_ranks_game_control",
  "efficiencies_overall",
  "efficiencies_offense",
  "efficiencies_defense",
  "efficiencies_special_teams"
)

test_that("CFBD ESPN FPI ratings", {
  skip_on_cran()
  x <- cfbd_ratings_fpi(year = 2019, team = "Texas")

  y <- cfbd_ratings_fpi(year = 2018, conference = "SEC")

  z <- cfbd_ratings_fpi(year = 2013, conference = "ACC")

  expect_setequal(colnames(x), cols)
  expect_setequal(colnames(y), cols)
  expect_setequal(colnames(z), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_s3_class(z, "data.frame")
})
