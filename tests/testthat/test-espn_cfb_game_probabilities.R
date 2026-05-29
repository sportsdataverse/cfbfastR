

test_that("ESPN CFB Game Probabilities", {
  skip_on_cran()

  cols <- c(
    "game_id", "play_id", "sequence_number", "home_team_id", "away_team_id",
    "home_win_percentage", "away_win_percentage", "tie_percentage",
    "seconds_left", "spread_cover_prob_home", "spread_push_prob",
    "total_over_prob", "total_push_prob", "source_id", "source_description",
    "source_state", "last_modified", "play_ref", "competition_ref",
    "home_team_ref", "away_team_ref"
  )

  x <- espn_cfb_game_probabilities(game_id = 401628339)

  y <- espn_cfb_game_probabilities(game_id = 401520375)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game probabilities data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_true(is.numeric(x$home_win_percentage))

  # team_detail = TRUE (default) joins friendly team fields next to both
  # home_team_id and away_team_id.
  expect_in(
    c("home_team_name", "home_team_abbreviation", "home_team_alternate_color",
      "home_team_logo_href", "home_team_logo_dark_href",
      "away_team_name", "away_team_abbreviation", "away_team_alternate_color",
      "away_team_logo_href", "away_team_logo_dark_href"),
    colnames(x)
  )
})

test_that("ESPN CFB Game Probabilities - team_detail = FALSE", {
  skip_on_cran()

  x <- espn_cfb_game_probabilities(game_id = 401628339,
                                   team_detail = FALSE)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game probabilities data returned at test time")
  }

  expect_false("home_team_name" %in% colnames(x))
  expect_false("away_team_name" %in% colnames(x))
})
