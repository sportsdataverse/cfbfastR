

test_that("ESPN CFB Game Player Box", {
  skip_on_cran()

  cols <- c(
    "game_id", "team_id", "home_away", "athlete_id", "athlete_name",
    "category_name", "category_display", "category_short_display",
    "category_summary", "stat_name", "abbreviation", "display_name",
    "short_display_name", "description", "value", "display_value",
    "statistics_ref"
  )

  x <- espn_cfb_game_player_box(game_id = 401628339)

  y <- espn_cfb_game_player_box(game_id = 401520375)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game player box data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")

  # position_detail = TRUE (default) joins the ESPN position catalog.
  pos_cols <- c(
    "position_id", "position_name", "position_display_name",
    "position_abbreviation", "position_leaf", "position_parent_id"
  )
  expect_in(pos_cols, colnames(x))
  expect_true(any(!is.na(x$position_abbreviation)))

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

test_that("ESPN CFB Game Player Box - team_detail = FALSE", {
  skip_on_cran()

  x <- espn_cfb_game_player_box(game_id = 401628339, team_detail = FALSE)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game player box data returned at test time")
  }

  expect_false("team_name" %in% colnames(x))
})

test_that("ESPN CFB Game Player Box - position_detail = FALSE", {
  skip_on_cran()

  x <- espn_cfb_game_player_box(game_id = 401628339,
                                position_detail = FALSE)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game player box data returned at test time")
  }

  # position_detail = FALSE omits the catalog-join columns.
  expect_false(any(c("position_name", "position_display_name",
                     "position_abbreviation", "position_leaf",
                     "position_parent_id") %in% colnames(x)))
})
