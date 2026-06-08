

test_that("ESPN CFB Game Team Statistics", {
  skip_on_cran()

  cols <- c(
    "game_id", "team_id", "home_away", "split_id", "split_name",
    "split_abbreviation", "category_name", "category_display",
    "category_short_display", "category_abbreviation", "category_summary",
    "stat_name", "abbreviation", "display_name", "short_display_name",
    "value", "display_value", "description", "statistics_ref", "team_ref"
  )

  x <- espn_cfb_game_team_statistics(game_id = 401628339)

  y <- espn_cfb_game_team_statistics(game_id = 401520375)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game team statistics data returned at test time")
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

test_that("ESPN CFB Game Team Statistics - team_detail = FALSE", {
  skip_on_cran()

  x <- espn_cfb_game_team_statistics(game_id = 401628339,
                                     team_detail = FALSE)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game team statistics data returned at test time")
  }

  expect_false("team_name" %in% colnames(x))
})
