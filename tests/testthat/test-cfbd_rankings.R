

cols <- c(
  "season", "season_type", "week", "poll", "rank",
  "school", "conference", "first_place_votes", "points"
)


test_that("CFB Poll Rankings", {
  skip_on_cran()
  x <- cfbd_rankings(year = 2019, week = 12)

  y <- cfbd_rankings(year = 2018, week = 14)

  z <- cfbd_rankings(year = 2013, season_type = "postseason")
  first_team_AP_13 <- z %>%
    filter(.data$poll == "AP Top 25" & .data$rank == 1) %>%
    select(.data$school)

  first_team_coaches_13 <- z %>%
    filter(.data$poll == "Coaches Poll" & .data$rank == 1) %>%
    select(.data$school)

  expect_equal(colnames(x), cols)
  expect_equal(colnames(y), cols)
  expect_equal(colnames(z), cols)
  expect_equal(dplyr::first(first_team_AP_13$school), "Florida State")
  expect_equal(dplyr::first(first_team_coaches_13$school), "Florida State")
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_s3_class(z, "data.frame")
})
