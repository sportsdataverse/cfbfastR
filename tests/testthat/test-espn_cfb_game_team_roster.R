

test_that("ESPN CFB Game Team Roster", {
  skip_on_cran()

  cols <- c(
    "game_id", "team_id", "home_away", "athlete_id", "player_id",
    "display_name", "jersey", "position_id", "period", "starter", "active",
    "did_not_play", "valid", "athlete_ref", "position_ref"
  )

  x <- espn_cfb_game_team_roster(game_id = 401628339)

  y <- espn_cfb_game_team_roster(game_id = 401520375)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game team roster data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")

  # position_detail = TRUE (default) joins the ESPN position catalog.
  pos_cols <- c(
    "position_name", "position_display_name", "position_abbreviation",
    "position_leaf", "position_parent_id"
  )
  expect_in(pos_cols, colnames(x))
  expect_true(any(!is.na(x$position_abbreviation)))
  expect_type(x$position_leaf, "logical")

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

test_that("ESPN CFB Game Team Roster - team_detail = FALSE", {
  skip_on_cran()

  x <- espn_cfb_game_team_roster(game_id = 401628339, team_detail = FALSE)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game team roster data returned at test time")
  }

  expect_false("team_name" %in% colnames(x))
})

test_that("ESPN CFB Game Team Roster - position_detail = FALSE", {
  skip_on_cran()

  x <- espn_cfb_game_team_roster(game_id = 401628339,
                                 position_detail = FALSE)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game team roster data returned at test time")
  }

  # position_detail = FALSE omits the catalog-join columns.
  expect_false(any(c("position_name", "position_display_name",
                     "position_abbreviation", "position_leaf",
                     "position_parent_id") %in% colnames(x)))
  expect_true("position_id" %in% colnames(x))
})
