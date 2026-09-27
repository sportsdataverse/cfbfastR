test_that("CFBD - Game Weather accepts game_id without year, and needs one of them", {
  # Offline: CFBD documents `year` as required unless `gameId` is given. The
  # wrapper must build the request from game_id alone and abort locally when
  # neither is supplied, never sending a request it knows is invalid.
  seen_url <- NULL
  local_mocked_bindings(
    validate_api_key = function() invisible(TRUE),
    get_req = function(full_url, proxy = NULL) {
      seen_url <<- full_url
      httr2::response(status_code = 200, body = charToRaw("[]"))
    }
  )
  expect_error(cfbd_game_weather(), "game_id")
  x <- cfbd_game_weather(game_id = 401628374)
  expect_s3_class(x, "data.frame")
  expect_match(seen_url, "gameId=401628374", fixed = TRUE)
  expect_false(grepl("year=", seen_url, fixed = TRUE))
})
