

test_that("ESPN CFB Weekly Rankings", {
  skip_on_cran()

  cols <- c(
    "season", "season_type", "week", "ranking_id", "ranking_name",
    "ranking_type", "occurrence", "rank_type", "current_rank",
    "previous_rank", "points", "first_place_votes", "trend",
    "record_summary", "team_id", "team_ref"
  )

  x <- espn_cfb_week_rankings(year = 2024, week = 8)

  y <- espn_cfb_week_rankings(year = 2023, week = 8)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN week rankings data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")

  # team_detail = TRUE (default) joins friendly team fields next to team_id.
  expect_in(
    c("team_name", "team_abbreviation", "team_location",
      "team_display_name", "team_alternate_color", "team_logo_href",
      "team_logo_dark_href"),
    colnames(x)
  )
  expect_true(any(!is.na(x$team_name)))
  expect_true(any(!is.na(x$team_logo_href)))
})

test_that("ESPN CFB Weekly Rankings - team_detail = FALSE", {
  skip_on_cran()

  x <- espn_cfb_week_rankings(year = 2024, week = 8, team_detail = FALSE)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN week rankings data returned at test time")
  }

  # team_detail = FALSE skips the catalog join.
  expect_false("team_name" %in% colnames(x))
})
