### Parity oracle: sdv-py's timeout block (`homeTimeoutCalled` / `awayTimeoutCalled`,
### `start.*TeamTimeouts`, `_overtime_period`) -> .espn_timeouts() /
### .espn_overtime_period() / .espn_add_timeouts() / .pbp_add_play_counts().
###
### `timeouts_oracle.csv.gz` is every play of 19 real games (2004-2025), each
### picked so one charging or counting rule decides at least one row: name
### parts, the 2004 mascot form, ties, initialisms, the shortened-name resolver,
### media stoppages charged to nobody, an adjacent repeat, and five overtime
### games, two of whose feeds number every overtime 5 (401112081, 323152633) so
### the window comes from pairing the overtime drives. The engine's old matcher
### compared up to ten characters after "Timeout " with the abbreviation and
### charged 8 of the first 16 games' 116 Timeout rows.

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

test_that("Timeout rows are charged and counted as sdv-py does", {
  testthat::skip_on_cran()
  for (g in read_oracle()) {
    r <- replay(g)
    expect_identical(r$home_called, g$sdvpy_home_called, label = g$game_id[1])
    expect_identical(r$away_called, g$sdvpy_away_called, label = g$game_id[1])
    for (k in c("start_home", "start_away", "end_home", "end_away")) {
      expect_equal(r[[k]], g[[paste0("sdvpy_", k)]], label = paste(g$game_id[1], k))
    }
  }
})

test_that("overtime windows pair the overtime drives, as sdv-py's _overtime_period does", {
  testthat::skip_on_cran()
  o <- read_oracle()
  # 401112081 (2019, 3OT, all numbered 5; sportsdataverse-py #505)
  g <- o[["401112081"]]
  expect_identical(sort(unique(replay(g)$window[g$period >= 5])), c(5, 6, 7))
  # A bug sdv-py and R share, pinned so a change to either side shows. The rule
  # counts an overtime drive on every drive-id change. 401754372's first
  # overtime is three rows filed under drives 37, 36, 37, so drive 37 counts
  # twice and the second overtime's second possession opens a third window that
  # never happened. Virginia Tech (home) called its one second-overtime timeout
  # at "Timeout Virginia Tech, clock 00:11", yet both report it 1 left on the
  # five rows after (truth: 0). Counting drives once by id fixes this game but
  # disagrees with sdv-py on 10 of 128 overtime games, wrongly more often than
  # not, so the shared rule stays until sdv-py has a better one.
  g <- o[["401754372"]]
  r <- replay(g)
  expect_identical(sort(unique(r$window[g$period >= 5])), c(5, 6, 7))
  after <- seq_len(nrow(g)) > max(which(g$period == 6 & grepl("^Timeout Virginia Tech", g$text)))
  expect_equal(sum(after), 5L)
  expect_equal(r$start_home[after], rep(1, 5))
  expect_equal(r$start_home[after], g$sdvpy_start_home[after])
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
    mism <- mism + sum(!is_na & (r$off_timeouts_rem_before != py_off | r$def_timeouts_rem_before != py_def))
  }
  expect_identical(mism, 0L)
  # The NA rows are the engine's own lag boundary (a half's first row is a
  # Penalty before any snap, e.g. 283332199), not a count. Counted so the NA
  # exemption cannot swallow more rows.
  expect_identical(n_na, 1L)
})
