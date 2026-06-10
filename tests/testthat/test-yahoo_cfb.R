test_that("legacy wrappers validate category and flatten leaders", {
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
