cols <- c(
  "season",
  "season_type",
  "week",
  "poll",
  "rank",
  "school",
  "conference",
  "first_place_votes",
  "points"
)


test_that("CFB Poll Rankings", {
  skip_on_cran()
  x <- cfbd_rankings(year = 2019, week = 12)
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }

  y <- cfbd_rankings(year = 2018, week = 14)
  if (is.null(y) || !is.data.frame(y) || nrow(y) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }

  z <- cfbd_rankings(year = 2013, season_type = "postseason")
  if (is.null(z) || !is.data.frame(z) || nrow(z) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  first_team_AP_13 <- z |>
    filter(.data$poll == "AP Top 25" & .data$rank == 1) |>
    select("school")

  first_team_coaches_13 <- z |>
    filter(.data$poll == "Coaches Poll" & .data$rank == 1) |>
    select("school")

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_in(cols, colnames(z))
  expect_equal(dplyr::first(first_team_AP_13$school), "Florida State")
  expect_equal(dplyr::first(first_team_coaches_13$school), "Florida State")
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_s3_class(z, "data.frame")
})
