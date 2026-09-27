# Offline: the query KEYS each wrapper sends must be the names CFBD 5.31.1
# documents. A renamed key is silently ignored server-side (the filter drops and
# the full result comes back), so these pin the URL, not the response.
.capture_url <- function() {
  seen <- new.env()
  local_mocked_bindings(
    validate_api_key = function() invisible(TRUE),
    get_req = function(full_url, proxy = NULL) {
      seen$url <- if (inherits(full_url, "httr2_request")) full_url$url else full_url
      httr2::response(status_code = 200, body = charToRaw("[]"))
    },
    .env = parent.frame()
  )
  seen
}

test_that("CFBD - coaches sends firstName / lastName", {
  seen <- .capture_url()
  cfbd_coaches(first = "Nick", last = "Saban")
  expect_match(seen$url, "firstName=Nick", fixed = TRUE)
  expect_match(seen$url, "lastName=Saban", fixed = TRUE)
  expect_false(grepl("[?&]first=", seen$url))
  expect_false(grepl("[?&]last=", seen$url))
})

test_that("CFBD - game player and team stats send id alone, not gameId", {
  # CFBD accepts `id` only by itself (year alongside it is a 400); the wrapper
  # therefore drops the season filters when game_id is supplied.
  seen <- .capture_url()
  cfbd_game_player_stats(game_id = 401628374)
  expect_match(seen$url, "id=401628374", fixed = TRUE)
  expect_false(grepl("gameId=", seen$url, fixed = TRUE))
  expect_false(grepl("year=", seen$url, fixed = TRUE))
  cfbd_game_player_stats(year = 2024, week = 1, game_id = 401628374)
  expect_false(grepl("year=|week=|seasonType=", seen$url))
  cfbd_game_team_stats(game_id = 401628374)
  expect_match(seen$url, "id=401628374", fixed = TRUE)
  expect_false(grepl("gameId=|year=", seen$url))
  expect_error(cfbd_game_player_stats(), "game_id")
  expect_error(cfbd_game_team_stats(), "game_id")
})

test_that("CFBD - plays sends conference", {
  seen <- .capture_url()
  cfbd_plays(year = 2024, week = 1, conference = "SEC")
  expect_match(seen$url, "conference=SEC", fixed = TRUE)
})
