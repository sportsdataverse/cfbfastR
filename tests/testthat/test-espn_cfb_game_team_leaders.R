

test_that("ESPN CFB Game Team Leaders", {
  skip_on_cran()

  cols <- c(
    "game_id", "team_id", "home_away", "category_name", "category_display",
    "category_short_display", "category_abbrev", "rank", "athlete_id",
    "leader_team_id", "value", "display_value", "athlete_ref",
    "leader_team_ref", "statistics_ref"
  )

  x <- espn_cfb_game_team_leaders(game_id = 401628339)

  y <- espn_cfb_game_team_leaders(game_id = 401520375)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game team leaders data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")

  # team_detail = TRUE (default) joins friendly team fields next to both
  # team-id columns -- team_id and leader_team_id.
  expect_in(
    c("team_name", "team_abbreviation", "team_alternate_color",
      "team_logo_href", "team_logo_dark_href",
      "leader_team_name", "leader_team_abbreviation",
      "leader_team_alternate_color", "leader_team_logo_href",
      "leader_team_logo_dark_href"),
    colnames(x)
  )
})

test_that("ESPN CFB Game Team Leaders - team_detail = FALSE", {
  skip_on_cran()

  x <- espn_cfb_game_team_leaders(game_id = 401628339, team_detail = FALSE)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game team leaders data returned at test time")
  }

  expect_false("team_name" %in% colnames(x))
  expect_false("leader_team_name" %in% colnames(x))
})
