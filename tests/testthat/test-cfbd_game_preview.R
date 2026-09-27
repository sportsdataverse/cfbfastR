test_that("CFBD - Game Preview", {
  skip_on_cran()
  x <- cfbd_game_preview(game_id = 401114233)
  if (is.null(x) || !is.list(x) || length(x) == 0L || nrow(x$game) == 0L) skip("CFBD rate-limited or returned no rows")
  expect_type(x, "list")
  expect_in(c("game", "broadcasts", "odds", "teams", "key_players",
              "recent_results", "series", "series_meetings"), names(x))
  expect_in(c("game_id", "season", "week", "availability"), colnames(x$game))
  expect_s3_class(x$game, "data.frame")
})

