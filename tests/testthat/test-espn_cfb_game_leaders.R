

test_that("ESPN CFB Game Leaders", {
  skip_on_cran()

  cols <- c(
    "game_id", "category_name", "category_display_name",
    "category_short_display_name", "category_abbreviation", "leader_rank",
    "athlete_id", "team_id", "display_value", "value", "athlete_ref",
    "team_ref", "statistics_ref"
  )

  x <- espn_cfb_game_leaders(game_id = 401628339)

  y <- espn_cfb_game_leaders(game_id = 401520375)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game leaders data returned at test time")
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

test_that("ESPN CFB Game Leaders - team_detail = FALSE", {
  skip_on_cran()

  x <- espn_cfb_game_leaders(game_id = 401628339, team_detail = FALSE)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game leaders data returned at test time")
  }

  # team_detail = FALSE skips the catalog join.
  expect_false("team_name" %in% colnames(x))
})
