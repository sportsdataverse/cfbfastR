### Parity oracle: sdv-py's timeout block (`homeTimeoutCalled` / `awayTimeoutCalled`,
### `start.*TeamTimeouts`, `_overtime_period`) -> .espn_timeouts() /
### .espn_overtime_period() / .espn_add_timeouts() / .pbp_add_play_counts().
###
### `timeouts_oracle.csv.gz` is every play of 17 real games (2004-2025), each
### picked so one charging or counting rule decides at least one row: name
### parts, the 2004 mascot form, ties, initialisms, the shortened-name resolver,
### media stoppages charged to nobody, an adjacent repeat, and three overtime
### games -- one (401112081) whose feed numbers all three overtimes 5. The
### engine's old matcher compared up to ten characters after "Timeout " with the
### abbreviation and charged 8 of these games' first 116 Timeout rows.

oracle_path <- testthat::test_path("fixtures", "parity", "timeouts_oracle.csv.gz")

read_oracle <- function() {
  skip_if_not(file.exists(oracle_path), "timeouts oracle not present")
  o <- utils::read.csv(oracle_path, colClasses = "character", na.strings = "")
  o$period <- as.integer(o$period)
  for (k in c("sdvpy_home_called", "sdvpy_away_called", "start_is_home")) o[[k]] <- o[[k]] == "true"
  for (k in c(grep("^sdvpy_(start|end)_", names(o), value = TRUE),
              "drive_start_yard_line", "drive_start_period")) o[[k]] <- as.numeric(o[[k]])
  split(o, factor(o$game_id, unique(o$game_id)))
}

replay <- function(g) {
  .espn_timeouts(g$period, g$type, g$text,
                 g$home_abbr, g$home_location, g$home_name,
                 g$away_abbr, g$away_location, g$away_name,
                 drive_id = g$drive_id, drive_start_yard_line = g$drive_start_yard_line,
                 drive_start_period = g$drive_start_period)
}

# A documented divergence, R kept: sdv-py's `_overtime_period` pairs overtime
# drives on every drive-id CHANGE. 401754372's first overtime is three rows
# filed under drives 37, 36, 37, so drive 37 counts twice and the second
# overtime's second possession (drive 39, from row 191) opens a third window,
# handing Virginia Tech (home) back the overtime timeout it called at row 190.
# R counts each overtime drive once and leaves Virginia Tech at 0 -- correct.
# Exactly these five rows; pinned so the exemption cannot widen.
pairing_bug_rows <- function(g) {
  if (g$game_id[1] != "401754372") return(rep(FALSE, nrow(g)))
  seq_len(nrow(g)) > max(which(g$period == 6 & grepl("^Timeout Virginia Tech", g$text)))
}

test_that("Timeout rows are charged and counted as sdv-py does", {
  testthat::skip_on_cran()
  for (g in read_oracle()) {
    r <- replay(g)
    expect_identical(r$home_called, g$sdvpy_home_called, label = g$game_id[1])
    expect_identical(r$away_called, g$sdvpy_away_called, label = g$game_id[1])
    skip <- pairing_bug_rows(g)
    expect_equal(sum(skip), if (g$game_id[1] == "401754372") 5L else 0L)
    for (k in c("start_home", "start_away", "end_home", "end_away")) {
      expect_equal(r[[k]][!skip], g[[paste0("sdvpy_", k)]][!skip], label = paste(g$game_id[1], k))
    }
  }
})

test_that("overtime windows: paired drives in a feed that numbers every OT 5, not sdv-py's double count", {
  testthat::skip_on_cran()
  o <- read_oracle()
  # 401112081 (2019, 3OT, sportsdataverse-py #505): three overtime windows from
  # drive pairs, so each team gets one timeout per overtime, as in sdv-py
  g <- o[["401112081"]]
  w <- replay(g)$window
  expect_identical(sort(unique(w[g$period >= 5])), c(5, 6, 7))
  # 401754372: two overtimes, and Virginia Tech has none left after row 190
  g <- o[["401754372"]]
  r <- replay(g)
  expect_identical(sort(unique(r$window[g$period >= 5])), c(5, 6))
  skip <- pairing_bug_rows(g)
  expect_true(all(r$start_home[skip] == 0))
  expect_true(all(g$sdvpy_start_home[skip] == 1))
  # without drive fields the period is the window
  expect_identical(.espn_overtime_period(c(1, 5, 5, 6)), c(1, 5, 5, 6))
})

test_that("timeouts remaining before a play match sdv-py through the engine", {
  testthat::skip_on_cran()
  mism <- 0L
  n_na <- 0L
  for (g in read_oracle()) {
    n <- nrow(g)
    home <- g$start_is_home
    df <- data.frame(
      game_id = 1L, id_play = g$id_play, play_type = g$type, play_text = g$text,
      period = g$period, half = ifelse(g$period <= 2, 1, ifelse(g$period <= 4, 2, g$period - 2)),
      # shuffled rows: the count must follow play_order, not row order
      play_order = seq_len(n),
      drive_id = g$drive_id, drive_start_yard_line = g$drive_start_yard_line,
      drive_start_period = g$drive_start_period,
      home = g$home_location, away = g$away_location,
      home_team_abbreviation = g$home_abbr, away_team_abbreviation = g$away_abbr,
      home_team_mascot = g$home_name, away_team_mascot = g$away_name,
      home_team_id = "1", away_team_id = "2",
      offense_play_id = ifelse(home, "1", "2"), defense_play_id = ifelse(home, "2", "1"),
      down = 1, distance = 10, yards_to_goal = 75, yards_gained = 0,
      clock_minutes = 5, clock_seconds = 0, offense_score = 0, defense_score = 0,
      stringsAsFactors = FALSE
    )
    df$offense_play <- ifelse(home, df$home, df$away)
    df$defense_play <- ifelse(home, df$away, df$home)
    shuffled <- rev(seq_len(n))
    r <- .pbp_add_play_counts(.espn_add_timeouts(df[shuffled, ]))
    r <- r[order(r$play_order), ]
    expect_false("timeout_window" %in% names(r))
    py_off <- ifelse(home, g$sdvpy_start_home, g$sdvpy_start_away)
    py_def <- ifelse(home, g$sdvpy_start_away, g$sdvpy_start_home)
    is_na <- is.na(r$off_timeouts_rem_before) | is.na(r$def_timeouts_rem_before)
    n_na <- n_na + sum(is_na)
    bad <- !is_na & (r$off_timeouts_rem_before != py_off | r$def_timeouts_rem_before != py_def)
    mism <- mism + sum(bad[!pairing_bug_rows(g)])
  }
  expect_identical(mism, 0L)
  # The one NA row (283332199's first second-half row, a Penalty before any
  # snap of the half) is the engine's own lag boundary, not a count. Counted so
  # the NA exemption above cannot swallow more rows.
  expect_identical(n_na, 1L)
})
