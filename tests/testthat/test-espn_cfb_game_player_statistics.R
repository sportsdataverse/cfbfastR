

test_that("ESPN CFB Game Player Statistics", {
  skip_on_cran()

  cols <- c(
    "game_id", "athlete_id", "team_id", "athlete_display_name", "jersey",
    "starter", "did_not_play", "category_name", "category_display_name",
    "category_short_display_name", "category_summary", "stat_name",
    "stat_display_name", "stat_short_display_name", "abbreviation", "value",
    "display_value", "description"
  )

  x <- espn_cfb_game_player_statistics(game_id = 401628339,
                                       athlete_id = 4429105)

  y <- espn_cfb_game_player_statistics(game_id = 401520375,
                                       athlete_id = 4360204)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game player statistics data returned at test time")
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
  expect_in(pos_cols, colnames(y))

  # team_detail = TRUE (default) joins friendly team fields next to team_id.
  expect_in(
    c("team_name", "team_abbreviation", "team_location",
      "team_display_name", "team_alternate_color", "team_logo_href",
      "team_logo_dark_href"),
    colnames(x)
  )
})

test_that("ESPN CFB Game Player Statistics - team_detail = FALSE", {
  skip_on_cran()

  x <- espn_cfb_game_player_statistics(game_id = 401628339,
                                       athlete_id = 4429105,
                                       team_detail = FALSE)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game player statistics data returned at test time")
  }

  expect_false("team_name" %in% colnames(x))
})

test_that("ESPN CFB Game Player Statistics - position_detail = FALSE", {
  skip_on_cran()

  x <- espn_cfb_game_player_statistics(game_id = 401628339,
                                       athlete_id = 4429105,
                                       position_detail = FALSE)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game player statistics data returned at test time")
  }

  # position_detail = FALSE omits the catalog-join columns.
  expect_false(any(c("position_name", "position_display_name",
                     "position_abbreviation", "position_leaf",
                     "position_parent_id") %in% colnames(x)))
})
