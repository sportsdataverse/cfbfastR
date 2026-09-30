test_that("ESPN CFB PBP v2 (core-v2) -- epa_wpa = FALSE", {
  skip_on_cran()

  x <- espn_cfb_pbp_v2(game_id = 401628339)

  # Skip-if-empty guard -- handles transient ESPN outages / stream errors.
  if (!is.data.frame(x) || nrow(x) == 0) {
    skip("No rows returned from espn_cfb_pbp_v2() at test time")
  }

  cols_x <- c(
    "game_id", "play_id", "type_text", "text", "period", "clock",
    "start_down", "start_distance", "start_yard_line",
    "start_yards_to_endzone", "stat_yardage",
    "drive_drive_id", "drive_result",
    "season", "season_type", "week", "neutral_site",
    "conference_competition", "game_date",
    "home_team_id", "home_team", "away_team_id", "away_team"
  )
  expect_in(sort(cols_x), sort(colnames(x)))
  expect_s3_class(x, "data.frame")
})

test_that("ESPN CFB PBP v2 (core-v2) -- epa_wpa = TRUE", {
  skip_on_cran()

  x <- espn_cfb_pbp_v2(game_id = 401628339, epa_wpa = TRUE)

  # Skip-if-empty guard.
  if (!is.data.frame(x) || nrow(x) == 0) {
    skip("No rows returned from espn_cfb_pbp_v2() at test time")
  }

  # The EPA/WPA modeling may not always be reachable (model objects /
  # transient ESPN errors); only assert the modeled columns when present.
  if (!("EPA" %in% colnames(x))) {
    skip("EPA/WPA modeling not attached at test time")
  }

  # The modeled EPA/WPA columns must be present.
  cols_x <- c(
    "game_id", "play_id", "play_type", "play_text",
    "down", "distance", "yards_to_goal", "yards_gained",
    "ep_before", "ep_after", "EPA", "def_EPA",
    "wp_before", "wp_after", "wpa"
  )
  expect_in(sort(cols_x), sort(colnames(x)))
  expect_s3_class(x, "data.frame")
})

test_that("ESPN CFB PBP v2 (core-v2) -- epa_wpa = TRUE columns superset FALSE", {
  skip_on_cran()

  v0 <- espn_cfb_pbp_v2(game_id = 401628339)
  v1 <- espn_cfb_pbp_v2(game_id = 401628339, epa_wpa = TRUE)

  # Skip-if-empty guard.
  if (!is.data.frame(v0) || nrow(v0) == 0 ||
      !is.data.frame(v1) || nrow(v1) == 0) {
    skip("No rows returned from espn_cfb_pbp_v2() at test time")
  }

  # The EPA/WPA modeling may not always be reachable (model objects /
  # transient ESPN errors); only assert the superset when present.
  if (!("EPA" %in% colnames(v1))) {
    skip("EPA/WPA modeling not attached at test time")
  }

  # epa_wpa = TRUE columns must be a strict superset of epa_wpa = FALSE.
  expect_in(sort(colnames(v0)), sort(colnames(v1)))
  expect_true(ncol(v1) > ncol(v0))

  # The join is 1:1 on play_id -- no plays dropped or duplicated.
  expect_equal(nrow(v1), nrow(v0))

  # Game / drive context survives into the modeled output.
  context_cols <- c(
    "season", "season_type", "week", "game_date", "neutral_site",
    "conference_competition", "drive_drive_id", "drive_result"
  )
  expect_in(sort(context_cols), sort(colnames(v1)))
})

test_that("espn_cfb_pbp_v2() returns rows in the order EPA was computed on", {
  skip_on_cran()
  # 312810077 (2011): the ESPN feed lists "4th & 3" (...007) before "3rd & 3"
  # (...004). The engine sorts by id before modeling, but the output used to come
  # back in the feed's order, so game_play_number stepped backwards 15 times.
  d <- suppressWarnings(suppressMessages(espn_cfb_pbp(game_id = 312810077, epa_wpa = TRUE)))
  if (!is.data.frame(d) || !nrow(d)) skip("ESPN returned no plays")
  gp <- d$game_play_number[!is.na(d$game_play_number)]
  expect_true(all(diff(gp) >= 0))
  expect_lt(match("312810077004", d$id_play), match("312810077007", d$id_play))
})
