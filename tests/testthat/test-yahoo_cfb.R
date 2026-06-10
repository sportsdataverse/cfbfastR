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
