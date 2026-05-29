

test_that("ESPN CFB Game Teams", {
  skip_on_cran()

  cols <- c(
    "game_id", "competitor_id", "team_id", "order", "home_away", "winner",
    "competitor_type", "curated_rank", "uid", "team_ref", "score_ref",
    "linescores_ref", "roster_ref", "statistics_ref", "leaders_ref",
    "record_ref", "ranks_ref", "competitor_ref"
  )

  x <- espn_cfb_game_teams(game_id = 401628339)

  y <- espn_cfb_game_teams(game_id = 401520375)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game teams data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_true(all(x$home_away %in% c("home", "away")))

  # team_detail = TRUE (default) joins friendly team fields next to every
  # team-id column -- team_id and competitor_id.
  team_cols <- c(
    "team_name", "team_abbreviation", "team_location", "team_display_name",
    "team_short_display_name", "team_nickname", "team_color",
    "team_alternate_color", "team_logo_href", "team_logo_dark_href",
    "competitor_name", "competitor_abbreviation",
    "competitor_alternate_color", "competitor_logo_href",
    "competitor_logo_dark_href"
  )
  expect_in(team_cols, colnames(x))
  expect_true(any(!is.na(x$team_name)))
  expect_true(any(!is.na(x$competitor_name)))
  expect_true(any(!is.na(x$team_alternate_color)))
  expect_true(any(!is.na(x$team_logo_href)))
  expect_true(any(!is.na(x$team_logo_dark_href)))
})

test_that("ESPN CFB Game Teams - team_detail = FALSE", {
  skip_on_cran()

  # team_detail = FALSE skips the catalog join -- the prior column set.
  prior_cols <- c(
    "game_id", "competitor_id", "team_id", "order", "home_away", "winner",
    "competitor_type", "curated_rank", "uid", "team_ref", "score_ref",
    "linescores_ref", "roster_ref", "statistics_ref", "leaders_ref",
    "record_ref", "ranks_ref", "competitor_ref"
  )

  x <- espn_cfb_game_teams(game_id = 401628339, team_detail = FALSE)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game teams data returned at test time")
  }

  # team_detail = FALSE + format = "long" reproduces the prior schema.
  expect_equal(colnames(x), prior_cols)
  expect_equal(nrow(x), 2L)
  expect_false("team_name" %in% colnames(x))
})

test_that("ESPN CFB Game Teams - format = wide", {
  skip_on_cran()

  # format = "wide" collapses to one row per game with home_* / away_*
  # columns keyed off home_away.
  x <- espn_cfb_game_teams(game_id = 401628339, format = "wide")

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game teams data returned at test time")
  }

  expect_s3_class(x, "data.frame")
  # Exactly one row per game.
  expect_equal(nrow(x), 1L)
  # game_id stays a single key column.
  expect_true("game_id" %in% colnames(x))
  expect_false("home_away" %in% colnames(x))
  # Per-competitor columns are pivoted to home_* / away_*.
  expect_in(
    c("home_team_id", "away_team_id", "home_winner", "away_winner",
      "home_curated_rank", "away_curated_rank"),
    colnames(x)
  )
  # team_detail composes with format = "wide": home_team_id / away_team_id
  # get their friendly siblings too.
  expect_in(
    c("home_team_name", "home_team_abbreviation", "home_team_alternate_color",
      "home_team_logo_href", "home_team_logo_dark_href",
      "away_team_name", "away_team_abbreviation", "away_team_alternate_color",
      "away_team_logo_href", "away_team_logo_dark_href"),
    colnames(x)
  )

  # format = "wide" + team_detail = FALSE: still one row, no friendly cols.
  z <- espn_cfb_game_teams(game_id = 401628339, format = "wide",
                           team_detail = FALSE)
  if (!is.null(z) && is.data.frame(z) && nrow(z) > 0) {
    expect_equal(nrow(z), 1L)
    expect_false("home_team_name" %in% colnames(z))
  }
})
