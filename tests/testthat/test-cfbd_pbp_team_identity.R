# CFBD plays carry team NAMES only; the modeled path's team-aware stages key on
# ids and abbreviations. Rows below are real: game 401752677 (2025 week 1,
# Texas at Ohio State) as CFBD's /plays, /games and /teams return it.

cfbd_identity_plays <- function() {
  data.frame(
    game_id      = rep(401752677L, 5),
    home         = "Ohio State",
    away         = "Texas",
    offense_play = c("Ohio State", "Ohio State", "Texas", "Texas", "Army"),
    defense_play = c("Texas", "Texas", "Ohio State", "Ohio State", NA),
    stringsAsFactors = FALSE
  )
}
cfbd_identity_games <- function() {
  data.frame(game_id = 401752677L, home_id = 194L, home_team = "Ohio State",
             away_id = 251L, away_team = "Texas")
}
cfbd_identity_teams <- function() {
  data.frame(team_id = c("194", "251"), school = c("Ohio State", "Texas"),
             abbreviation = c("OSU", "TEX"))
}

test_that("CFBD plays get the team ids and abbreviations the engine keys on", {
  x <- .cfbd_team_identity(cfbd_identity_plays(), cfbd_identity_games(), cfbd_identity_teams())

  expect_identical(x$game_id, rep(401752677L, 5))          # type untouched
  expect_identical(x$home_team_id, rep("194", 5))
  expect_identical(x$away_team_id, rep("251", 5))
  expect_identical(x$home_team_abbreviation, rep("OSU", 5))
  expect_identical(x$away_team_abbreviation, rep("TEX", 5))
  expect_identical(x$offense_play_id[1:4], c("194", "194", "251", "251"))
  expect_identical(x$defense_play_id[1:4], c("251", "251", "194", "194"))
  # A name that is neither team stays unknown -- never a confirmed away side.
  expect_true(is.na(x$offense_play_id[5]))
  expect_true(is.na(x$defense_play_id[5]))
})

test_that("CFBD plays with no matching game keep NA ids rather than guessing", {
  # cfbd_game_info() returns data.frame() when the request fails.
  x <- .cfbd_team_identity(cfbd_identity_plays(), data.frame(), cfbd_identity_teams())
  expect_true(all(is.na(x$home_team_id)))
  expect_true(all(is.na(x$offense_play_id)))
})

test_that("CFBD game ids match whatever their type", {
  # as.character(401000000) is "4.01e+08" at the default scipen.
  plays <- cfbd_identity_plays()
  plays$game_id <- as.character(plays$game_id)
  x <- .cfbd_team_identity(plays, cfbd_identity_games(), cfbd_identity_teams())
  expect_identical(x$home_team_id, rep("194", 5))
  g <- cfbd_identity_games(); g$game_id <- 401000000; plays$game_id <- 401000000L
  expect_identical(.cfbd_team_identity(plays, g, cfbd_identity_teams())$home_team_id, rep("194", 5))
})

test_that("CFBD plays whose home team disagrees with /games stay unknown", {
  g <- cfbd_identity_games()
  g$home_team <- "Texas"   # the sides swapped between /plays and /games
  x <- .cfbd_team_identity(cfbd_identity_plays(), g, cfbd_identity_teams())
  expect_true(all(is.na(x$home_team_id)))
  expect_true(all(is.na(x$offense_play_id)))
})

test_that("CFBD season roster drops players it cannot scope to a team", {
  # Real 2025 /roster rows; Caldwell's first name blanked to exercise the NA
  # path. Cumberland (TN) is not in /teams, so its player has no team id.
  rows <- data.frame(
    athlete_id = c("4870906", "4877717", "5078278", "4696126"),
    first_name = c("Arch", NA, "Lincoln", "Shaikyi"),
    last_name  = c("Manning", "Caldwell", "Kienholz", "Hannah"),
    team       = c("Texas", "Texas", "Ohio State", "Cumberland (TN)")
  )
  asked <- character()
  local_mocked_bindings(cfbd_team_roster = function(year, team = NULL, ...) {
    asked <<- c(asked, if (is.null(team)) "<season>" else team)
    if (is.null(team)) rows else rows[rows$team == team, ]
  })
  r <- .cfbd_season_roster(2025, teams = cfbd_identity_teams())
  expect_identical(r$athlete_id, c("4870906", "4877717", "5078278"))
  expect_identical(r$display_name, c("Arch Manning", "Caldwell", "Lincoln Kienholz"))
  expect_identical(r$team_id, c("251", "251", "194"))
  asked <- character()
  r2 <- .cfbd_season_roster(2025, teams = cfbd_identity_teams(), schools = c("Ohio State", "Texas"))
  expect_identical(asked, c("Ohio State", "Texas"))
  expect_setequal(r2$athlete_id, r$athlete_id)
})

test_that("CFBD pbp possession ids match the ESPN path play for play", {
  skip_on_cran()
  skip_if(!has_cfbd_key(), "CFBD API key not available")
  cf <- suppressWarnings(cfbd_pbp_data(year = 2025, week = 1, season_type = "regular",
                                       team = "Texas", epa_wpa = TRUE))
  es <- suppressWarnings(espn_cfb_pbp(game_id = 401752677, epa_wpa = TRUE))
  if (!is.data.frame(cf) || !nrow(cf) || !is.data.frame(es) || !nrow(es)) {
    skip("CFBD or ESPN returned no plays")
  }
  ids <- c("pos_team_id", "def_pos_team_id", "passer_player_id", "rusher_player_id",
           "receiver_player_id")
  keys <- function(d) data.frame(id_play = as.character(d$id_play),
                                  lapply(d[ids], as.character), stringsAsFactors = FALSE)
  j <- merge(keys(cf), keys(es), by = "id_play", suffixes = c("_cfbd", "_espn"))
  expect_gt(nrow(j), 100L)
  for (k in ids) expect_identical(j[[paste0(k, "_cfbd")]], j[[paste0(k, "_espn")]], label = k)
  # Player ids come from the roster; all-NA on both sides would pass the above.
  expect_gt(sum(!is.na(j$passer_player_id_cfbd)), 20L)
})
