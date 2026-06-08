

test_that("ESPN CFB Game Team Records", {
  skip_on_cran()

  cols <- c(
    "game_id", "team_id", "home_away", "record_id", "name", "abbreviation",
    "display_name", "short_display_name", "description", "type", "summary",
    "display_value", "value", "record_ref"
  )

  x <- espn_cfb_game_team_records(game_id = 401628339)

  y <- espn_cfb_game_team_records(game_id = 401520375)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game team records data returned at test time")
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

test_that("ESPN CFB Game Team Records - detail = TRUE", {
  skip_on_cran()

  cols <- c(
    "game_id", "team_id", "home_away", "record_type", "record_summary",
    "stat_name", "stat_type", "abbreviation", "display_name",
    "short_display_name", "description", "value", "display_value"
  )

  x <- espn_cfb_game_team_records(game_id = 401628339, detail = TRUE)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game team records data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_s3_class(x, "data.frame")
  # team_detail composes with detail -- both shapes carry team_id.
  expect_in(c("team_name", "team_abbreviation"), colnames(x))
})

test_that("ESPN CFB Game Team Records - team_detail = FALSE", {
  skip_on_cran()

  x <- espn_cfb_game_team_records(game_id = 401628339, team_detail = FALSE)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game team records data returned at test time")
  }

  expect_false("team_name" %in% colnames(x))
})
