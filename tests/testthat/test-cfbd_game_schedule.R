test_that("CFBD - Game Schedule", {
  skip_on_cran()
  skip_if(!has_cfbd_key(), "CFBD API key not available")
  x <- cfbd_game_schedule(year = 2025, season_type = "regular", week = 1)
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) skip("CFBD rate-limited or returned no rows")
  cols <- c("game_id", "season", "week", "season_type", "start_date",
            "status", "neutral_site", "home_team_id", "away_team_id")
  expect_in(cols, colnames(x))
  expect_s3_class(x, "data.frame")
})

test_that("CFBD - Game Schedule rejects a partial window before any request", {
  # Offline: the API needs year, season_type and week together for an explicit
  # window; a partial one must abort locally, never reach get_req().
  local_mocked_bindings(
    validate_api_key = function() invisible(TRUE),
    get_req = function(full_url, proxy = NULL) stop("get_req() must not be called")
  )
  expect_error(cfbd_game_schedule(year = 2025), "supplied together")
  expect_error(cfbd_game_schedule(season_type = "regular", week = 1), "supplied together")
})
