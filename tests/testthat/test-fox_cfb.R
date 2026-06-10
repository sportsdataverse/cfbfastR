# Live tests for the Fox Sports (Bifrost) college-football wrappers.
# Stable ids: game 41616 (completed 2025 FSU-Kent St.), team 11 (Miami FL).
# Subset-direction column checks (expected cols subseteq actual) because the
# Bifrost payloads add columns over time. Skip-if-empty guards handle the
# ephemeral odds market + transient API errors.

test_that("Fox CFB PBP", {
  skip_on_cran()
  x <- fox_cfb_pbp(game_id = "41616")
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) skip("No Fox PBP at test time")
  cols <- c("game_id", "quarter", "drive_id", "drive_result", "period",
            "clock", "play_text", "play_team")
  expect_in(cols, colnames(x))
  expect_s3_class(x, "data.frame")
  Sys.sleep(1)
})

test_that("Fox CFB Boxscore", {
  skip_on_cran()
  x <- fox_cfb_boxscore(game_id = "41616")
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) skip("No Fox boxscore at test time")
  cols <- c("game_id", "team", "stat_group", "player", "athlete_id", "stat", "value")
  expect_in(cols, colnames(x))
  expect_s3_class(x, "data.frame")
  Sys.sleep(1)
})

test_that("Fox CFB Team Roster", {
  skip_on_cran()
  x <- fox_cfb_team_roster(team_id = "11")
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) skip("No Fox roster at test time")
  cols <- c("team_id", "position_group", "player", "pos", "cls", "ht", "wt", "athlete_id")
  expect_in(cols, colnames(x))
  expect_s3_class(x, "data.frame")
  Sys.sleep(1)
})

test_that("Fox CFB Team Stats", {
  skip_on_cran()
  x <- fox_cfb_team_stats(team_id = "11")
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) skip("No Fox team stats at test time")
  cols <- c("team_id", "category", "stat", "stat_abbreviation", "player", "value")
  expect_in(cols, colnames(x))
  expect_s3_class(x, "data.frame")
  Sys.sleep(1)
})

test_that("Fox CFB Team Game Log", {
  skip_on_cran()
  x <- fox_cfb_team_gamelog(team_id = "11")
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) skip("No Fox game log at test time")
  cols <- c("team_id", "season_type", "category", "game_id", "game_date",
            "opponent", "stat", "value")
  expect_in(cols, colnames(x))
  expect_s3_class(x, "data.frame")
  Sys.sleep(1)
})

test_that("Fox CFB Standings", {
  skip_on_cran()
  x <- fox_cfb_standings(team_id = "11")
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) skip("No Fox standings at test time")
  expect_in(c("team_id", "section", "entity_id"), colnames(x))
  expect_s3_class(x, "data.frame")
  Sys.sleep(1)
})

test_that("Fox CFB League Leaders", {
  skip_on_cran()
  x <- fox_cfb_league_leaders(category = "passing")
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) skip("No Fox leaders at test time")
  expect_in("entity_id", colnames(x))
  expect_gt(ncol(x), 3L)
  expect_s3_class(x, "data.frame")
  Sys.sleep(1)
})

test_that("Fox CFB Odds", {
  skip_on_cran()
  # The matchup six-pack market is ephemeral (~60s TTL); tolerate an empty frame.
  x <- fox_cfb_odds(game_id = "41616")
  expect_s3_class(x, "data.frame")
  if (!is.null(x) && nrow(x) > 0) {
    expect_in(c("game_id", "team", "spread", "to_win", "total"), colnames(x))
  }
  Sys.sleep(1)
})
