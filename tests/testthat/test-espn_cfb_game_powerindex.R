

test_that("ESPN CFB Game Power Index", {
  skip_on_cran()

  cols <- c(
    "game_id", "season", "team_id", "stat_name", "abbreviation",
    "display_name", "short_display_name", "value", "display_value",
    "description", "powerindex_ref", "team_ref"
  )

  x <- espn_cfb_game_powerindex(game_id = 401628339)

  y <- espn_cfb_game_powerindex(game_id = 401520375)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game power index data returned at test time")
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
})

test_that("ESPN CFB Game Power Index - team_detail = FALSE", {
  skip_on_cran()

  x <- espn_cfb_game_powerindex(game_id = 401628339, team_detail = FALSE)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game power index data returned at test time")
  }

  expect_false("team_name" %in% colnames(x))
})
