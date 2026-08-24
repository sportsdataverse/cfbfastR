test_that("yahoo_cfb_scoreboard flattens games map and is self-describing", {
  testthat::skip_on_cran()
  fake <- list(service = list(scoreboard = list(games = list(
    `ncaaf.g.1` = list(gameid = "ncaaf.g.1", home_team_id = "ncaaf.t.1",
                       away_team_id = "ncaaf.t.2", total_home_points = "21",
                       total_away_points = "17")))))
  testthat::local_mocked_bindings(.yahoo_get = function(base, path, query = list()) fake)
  out <- yahoo_cfb_scoreboard(season = 2024, week = 1)
  expect_s3_class(out, "data.frame")
  expect_equal(out$gameid[1], "ncaaf.g.1")
  expect_equal(out$week[1], 1)
})

test_that("legacy wrappers validate category and flatten leaders", {
  testthat::skip_on_cran()
  fake <- list(data = list(leagues = list(list(leaders = list(
    list(player = list(playerId = "ncaaf.p.9", displayName = "RB Nine",
                       team = list(displayName = "Team C", abbreviation = "TC")),
         stats = list(list(statId = "RUSHING_YARDS", value = "1500"))))))))
  testthat::local_mocked_bindings(.yahoo_get = function(base, path, query = list()) fake)
  out <- yahoo_cfb_player_season_stats_legacy(season = 2024, category = "Rushing",
                                              sort_stat = "RUSHING_YARDS")
  expect_equal(out$rushing_yards[1], "1500")
  expect_equal(out$category[1], "Rushing")
  expect_error(
    yahoo_cfb_player_season_stats_legacy(season = 2024, category = "Bogus", sort_stat = "X"),
    "category"
  )
})

test_that("yahoo_cfb_player_season_stats flattens modern payload + is self-describing", {
  testthat::skip_on_cran()
  fake <- list(data = list(leagues = list(list(footballStats = list(
    list(player = list(playerId = "ncaaf.p.1", displayName = "QB One",
                       team = list(displayName = "Team A", abbreviation = "TA")),
         stats = list(list(statId = "PASSING_YARDS", value = "4000"))))))))
  testthat::local_mocked_bindings(.yahoo_get = function(base, path, query = list()) fake)
  out <- yahoo_cfb_player_season_stats(season = 2024)
  expect_s3_class(out, "data.frame")
  expect_true(all(c("player_id", "display_name", "team", "passing_yards", "season") %in% colnames(out)))
  expect_equal(out$season[1], 2024)
})

test_that(".yahoo_modern_rows pivots stats wide with entity columns", {
  testthat::skip_on_cran()
  payload <- list(data = list(leagues = list(list(footballStats = list(
    list(
      player = list(playerId = "ncaaf.p.1", displayName = "QB One",
                    team = list(displayName = "Team A", abbreviation = "TA")),
      stats = list(list(statId = "PASSING_YARDS", value = "4000"),
                   list(statId = "PASSING_TOUCHDOWNS", value = "40"))
    )
  )))))
  rows <- cfbfastR:::.yahoo_modern_rows(payload, "footballStats")
  expect_equal(length(rows), 1)
  expect_equal(rows[[1]][["player_id"]], "ncaaf.p.1")
  expect_equal(rows[[1]][["display_name"]], "QB One")
  expect_equal(rows[[1]][["team"]], "Team A")
  expect_equal(rows[[1]][["passing_yards"]], "4000")
  expect_equal(rows[[1]][["passing_touchdowns"]], "40")
})

test_that("yahoo_cfb_team_season_stats flattens modern team payload + is self-describing", {
  testthat::skip_on_cran()
  fake <- list(data = list(leagues = list(list(footballStats = list(
    list(team = list(displayName = "Team A", abbreviation = "TA"),
         stats = list(list(statId = "PASSING_YARDS", value = "4000"))))))))
  testthat::local_mocked_bindings(.yahoo_get = function(base, path, query = list()) fake)
  out <- yahoo_cfb_team_season_stats(season = 2024)
  expect_s3_class(out, "data.frame")
  expect_true(all(c("team", "team_abbreviation", "passing_yards", "season") %in% colnames(out)))
  expect_equal(out$team[1], "Team A")
  expect_equal(out$team_abbreviation[1], "TA")
  expect_equal(out$season[1], 2024)
})

test_that("yahoo_cfb_team_season_stats_legacy validates category and flattens team leaders", {
  testthat::skip_on_cran()
  fake <- list(data = list(leagues = list(list(leaders = list(
    list(team = list(displayName = "Team B", abbreviation = "TB"),
         stats = list(list(statId = "RUSHING_YARDS", value = "2000"))))))))
  testthat::local_mocked_bindings(.yahoo_get = function(base, path, query = list()) fake)
  out <- yahoo_cfb_team_season_stats_legacy(season = 2024, category = "Rushing",
                                            sort_stat = "RUSHING_YARDS")
  expect_s3_class(out, "data.frame")
  expect_true(all(c("team", "team_abbreviation", "rushing_yards", "season", "category") %in% colnames(out)))
  expect_equal(out$team[1], "Team B")
  expect_equal(out$team_abbreviation[1], "TB")
  expect_equal(out$category[1], "Rushing")
  expect_error(
    yahoo_cfb_team_season_stats_legacy(season = 2024, category = "Bogus", sort_stat = "X"),
    "category"
  )
})

test_that(".yahoo_entity_cols returns empty list for NULL entity", {
  testthat::skip_on_cran()
  row_no_player_no_team <- list()
  result <- cfbfastR:::.yahoo_entity_cols(row_no_player_no_team)
  expect_equal(result, list())
})

test_that("LIVE: yahoo_cfb_player_season_stats returns rows", {
  skip_on_cran()
  skip_on_ci()
  if (Sys.getenv("YAHOO_TESTS") != "1") skip("set YAHOO_TESTS=1 to run live Yahoo tests")
  x <- yahoo_cfb_player_season_stats(season = 2024)
  if (!is.data.frame(x) || nrow(x) == 0) skip("No rows returned at test time")
  core <- c("player_id", "display_name", "team", "season")
  expect_in(sort(core), sort(colnames(x)))   # subset direction: Yahoo adds columns
  expect_s3_class(x, "data.frame")
  Sys.sleep(2)
})
