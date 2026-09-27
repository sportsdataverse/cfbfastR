test_that("CFBD - Team Season Overview", {
  skip_on_cran()
  x <- cfbd_team_season_overview(year = 2024, team = "Texas")
  if (is.null(x) || !is.list(x) || length(x) == 0L || nrow(x$overview) == 0L) skip("CFBD rate-limited or returned no rows")
  expect_type(x, "list")
  expect_in(c("overview", "record", "ratings", "advanced", "passing",
              "rushing", "players"), names(x))
  expect_in(c("season", "team_id", "team"), colnames(x$overview))
  expect_s3_class(x$overview, "data.frame")
})

test_that("CFBD - Team Season Overview parses a fixed payload", {
  # Offline: pins section names and a stable ratings column set even when a
  # rating system comes back `null`, which the live test cannot guarantee.
  payload <- paste0(
    '{"season":2024,"teamId":251,"team":"Texas",',
    '"record":{"games":16,"wins":13,"losses":3,"ties":0},',
    '"ratings":{"sp":null,"srs":{"rating":20.5,"rank":4},"elo":null,',
    '"core":{"overall":{"rating":1.2,"rank":3},"offense":null,"defense":{"rating":0.4,"rank":9}},',
    '"fpi":null},',
    '"advanced":null,"passing":null,"rushing":null,"players":{"usage":[],"ppa":[]}}'
  )
  local_mocked_bindings(
    validate_api_key = function() invisible(TRUE),
    get_req = function(full_url, proxy = NULL) {
      httr2::response(status_code = 200, body = charToRaw(payload))
    }
  )
  x <- cfbd_team_season_overview(year = 2024, team = "Texas")
  expect_type(x, "list")
  expect_named(x, c("overview", "record", "ratings", "advanced", "passing", "rushing", "players"))
  expect_equal(x$overview$team_id, 251L)
  expect_in(c("games", "wins", "losses", "ties"), colnames(x$record))
  expect_in(c("elo", "srs_rating", "srs_rank", "sp_overall_rating", "sp_overall_rank",
              "core_offense_rating", "fpi_special_teams_rank"), colnames(x$ratings))
  expect_false(any(c("sp", "fpi", "core_offense") %in% colnames(x$ratings)))
  expect_type(x$ratings$sp_overall_rank, "integer")
  expect_type(x$ratings$elo, "double")
  expect_equal(x$ratings$srs_rank, 4L)
  expect_equal(ncol(x$advanced), 0L)
})
