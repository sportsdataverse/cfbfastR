test_that("CFBD - Game Preview", {
  skip_on_cran()
  skip_if(!has_cfbd_key(), "CFBD API key not available")
  x <- cfbd_game_preview(game_id = 401114233)
  if (is.null(x) || !is.list(x) || length(x) == 0L || nrow(x$game) == 0L) skip("CFBD rate-limited or returned no rows")
  expect_type(x, "list")
  expect_in(c("game", "broadcasts", "odds", "teams", "key_players",
              "recent_results", "series", "series_meetings"), names(x))
  expect_in(c("game_id", "season", "week", "availability"), colnames(x$game))
  expect_s3_class(x$game, "data.frame")
})

test_that("CFBD - Adjusted Game Preview", {
  skip_on_cran()
  skip_if(!has_cfbd_key(), "CFBD API key not available")
  # Requires a CFBD Patreon Tier 1 key; other keys get an empty list.
  x <- cfbd_game_preview_adjusted(game_id = 401114233)
  if (is.null(x) || !is.list(x) || length(x) == 0L || nrow(x$game) == 0L) skip("CFBD rate-limited, key below Tier 1, or returned no rows")
  expect_type(x, "list")
  expect_in(c("game", "team_metrics", "passing", "rushing", "kicking"), names(x))
  expect_in(c("game_id", "season", "week", "availability"), colnames(x$game))
  expect_s3_class(x$game, "data.frame")
})

test_that("CFBD - Game Preview parses a pregame analysis payload", {
  # Offline: a live completed game is metadata-only, so the analysis sections
  # (teams, key_players, recent_results, series) are never exercised there.
  # This pins the parsing of a populated pregame payload built from the 5.31.1
  # schema: 2 sides, one key player, one recent result each, one past meeting.
  side <- function(team_id, opp_id, kp_rows) {
    paste0(
      '{"teamId":', team_id, ',"season":2026,',
      '"record":{"status":"ok","reason":null,"assembledAt":"2026-09-25T00:00:00.000Z","sourceUpdatedAt":null,',
      '"data":{"games":3,"wins":3,"losses":0,"ties":0}},',
      '"ratings":{"status":"ok","reason":null,"assembledAt":"2026-09-25T00:00:00.000Z","sourceUpdatedAt":null,',
      '"data":{"elo":1900,"srs":{"rating":10.1,"rank":5},"sp":null}},',
      '"statistics":{"status":"no_data","reason":"no_results_yet","assembledAt":null,"sourceUpdatedAt":null,"data":null},',
      '"keyPlayers":{"season":2026,',
      '"passing":{"status":"ok","reason":null,"assembledAt":null,"sourceUpdatedAt":null,"data":', kp_rows, '},',
      '"rushing":{"status":"ok","reason":null,"assembledAt":null,"sourceUpdatedAt":null,"data":[]},',
      '"receiving":{"status":"ok","reason":null,"assembledAt":null,"sourceUpdatedAt":null,"data":[]}},',
      '"recentResults":{"status":"ok","reason":null,"assembledAt":null,"sourceUpdatedAt":null,',
      '"data":[{"gameId":400,"season":2026,"startDate":"2026-09-19","opponent":{"id":', opp_id, ',"name":"Rice"},',
      '"homeAway":"home","neutralSite":false,"venue":null,"teamPoints":35,"opponentPoints":10,"result":"W"}]}}'
    )
  }
  payload <- paste0(
    '{"game":{"id":401,"season":2026,"week":4,"seasonType":"regular","startDate":"2026-09-26T20:00:00.000Z",',
    '"homeTeamId":251,"homeTeam":"Texas","awayTeamId":333,"awayTeam":"Alabama"},',
    '"availability":"available","reason":"kickoff_unknown","assembledAt":"2026-09-25T00:00:00.000Z",',
    '"analysis":{',
    '"broadcasts":{"status":"ok","reason":null,"assembledAt":null,"sourceUpdatedAt":null,"data":[{"mediaType":"tv","outlet":"ABC"}]},',
    '"odds":{"status":"ok","reason":null,"assembledAt":null,"sourceUpdatedAt":null,',
    '"data":{"providerId":1,"provider":"consensus","spread":-3.5,"overUnder":51.5,"homeMoneyline":-160,"awayMoneyline":140}},',
    '"home":', side(251, 9, '[{"athleteId":"1","name":"QB One","position":"QB","usage":0.3,"averagePPA":0.4,"totalPPA":12.5}]'), ',',
    '"away":', side(333, 8, '[]'), ',',
    '"series":{"status":"ok","reason":null,"assembledAt":null,"sourceUpdatedAt":null,',
    '"data":{"homeTeamId":251,"awayTeamId":333,"meetings":10,"knownResults":10,"unknownResults":0,',
    '"homeWins":6,"awayWins":4,"ties":0,"firstSeason":1902,"lastSeason":2023,"latestMeeting":null,',
    '"streak":{"teamId":251,"wins":2},',
    '"recentMeetings":[{"season":2023,"week":2,"homeTeamId":333,"awayTeamId":251,"homePoints":24,"awayPoints":34}]}}',
    '}}'
  )
  local_mocked_bindings(
    validate_api_key = function() invisible(TRUE),
    get_req = function(full_url, proxy = NULL) {
      httr2::response(status_code = 200, body = charToRaw(payload))
    }
  )
  x <- cfbd_game_preview(game_id = 401)
  expect_named(x, c("game", "broadcasts", "odds", "teams", "key_players",
                    "recent_results", "series", "series_meetings"))
  expect_equal(x$game$game_id, 401L)
  expect_equal(x$game$availability, "available")
  expect_equal(nrow(x$broadcasts), 1L)
  expect_equal(x$odds$spread, -3.5)
  # one row per side, record/ratings flattened under their section prefix
  expect_equal(nrow(x$teams), 2L)
  expect_equal(sort(x$teams$side), c("away", "home"))
  expect_in(c("team_id", "record_data_wins", "ratings_data_srs_rating"), colnames(x$teams))
  # ratings are padded and typed like the overview's: the `sp: null` system
  # still yields its rating/rank pair, ranks integer, ratings double, no
  # raw placeholder column
  expect_in(c("ratings_data_elo", "ratings_data_sp_overall_rating",
              "ratings_data_sp_overall_rank", "ratings_data_srs_rank"), colnames(x$teams))
  expect_false("ratings_data_sp" %in% colnames(x$teams))
  expect_type(x$teams$ratings_data_sp_overall_rank, "integer")
  expect_type(x$teams$ratings_data_elo, "double")
  expect_equal(x$teams$ratings_data_srs_rank, c(5L, 5L))
  # only the home side has a key player; the away side's empty arrays are dropped
  expect_equal(nrow(x$key_players), 1L)
  expect_equal(x$key_players$side, "home")
  expect_equal(x$key_players$category, "passing")
  expect_equal(x$key_players$total_ppa, 12.5)
  expect_equal(nrow(x$recent_results), 2L)
  expect_in("opponent_id", colnames(x$recent_results))
  expect_gt(ncol(x$series), 0L)
  expect_false("recent_meetings" %in% colnames(x$series))
  expect_equal(nrow(x$series_meetings), 1L)
  expect_equal(x$series_meetings$away_points, 34L)
  for (section in x) expect_s3_class(section, "cfbfastR_data")
})
