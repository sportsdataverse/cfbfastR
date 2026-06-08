

test_that("ESPN CFB Game Team Linescores", {
  skip_on_cran()

  cols <- c(
    "game_id", "team_id", "home_away", "period", "value", "display_value",
    "source_id", "source_state", "source_description", "linescore_ref"
  )

  x <- espn_cfb_game_team_linescores(game_id = 401628339)

  y <- espn_cfb_game_team_linescores(game_id = 401520375)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game team linescores data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_true(is.numeric(x$value))

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

test_that("ESPN CFB Game Team Linescores - team_detail = FALSE", {
  skip_on_cran()

  x <- espn_cfb_game_team_linescores(game_id = 401628339,
                                     team_detail = FALSE)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game team linescores data returned at test time")
  }

  expect_false("team_name" %in% colnames(x))
})
