### Parity oracle: sdv-py's timeout block (`homeTimeoutCalled` / `awayTimeoutCalled`,
### `start.*TeamTimeouts`) -> .espn_timeouts() / .espn_add_timeouts() /
### .pbp_add_play_counts().
###
### `timeouts_oracle.csv.gz` is every play of 16 real games (2004-2025), each
### picked so one charging or counting rule decides at least one row: name
### parts, the 2004 mascot form, ties, initialisms, the shortened-name resolver,
### media stoppages charged to nobody, an adjacent repeat, two overtime games.
### The engine's old matcher compared up to ten characters after "Timeout "
### with the abbreviation and charged 8 of these 116 Timeout rows; sdv-py
### charges 112.

oracle_path <- testthat::test_path("fixtures", "parity", "timeouts_oracle.csv.gz")

read_oracle <- function() {
  skip_if_not(file.exists(oracle_path), "timeouts oracle not present")
  o <- utils::read.csv(oracle_path, colClasses = "character", na.strings = "")
  o$period <- as.integer(o$period)
  for (k in c("sdvpy_home_called", "sdvpy_away_called", "start_is_home")) o[[k]] <- o[[k]] == "true"
  for (k in grep("^sdvpy_(start|end)_", names(o), value = TRUE)) o[[k]] <- as.numeric(o[[k]])
  split(o, factor(o$game_id, unique(o$game_id)))
}

# sdv-py counts 401754372's overtime before its final sort, which moves the
# Timeout Virginia Tech row at 00:11 of the second overtime; replayed in the
# final order, the five rows after it read 1 left where sdv-py's count says 1
# was never used. Pinned so it cannot widen silently.
ot_order_rows <- function(g) {
  if (g$game_id[1] != "401754372") return(rep(FALSE, nrow(g)))
  seq_len(nrow(g)) > max(which(g$period == 6 & grepl("^Timeout Virginia Tech", g$text)))
}

test_that("Timeout rows are charged to the team sdv-py charges", {
  testthat::skip_on_cran()
  for (g in read_oracle()) {
    r <- .espn_timeouts(g$period, g$type, g$text,
                        g$home_abbr, g$home_location, g$home_name,
                        g$away_abbr, g$away_location, g$away_name)
    expect_identical(r$home_called, g$sdvpy_home_called, label = g$game_id[1])
    expect_identical(r$away_called, g$sdvpy_away_called, label = g$game_id[1])
    skip <- ot_order_rows(g)
    expect_equal(sum(skip), if (g$game_id[1] == "401754372") 5L else 0L)
    for (k in c("start_home", "start_away", "end_home", "end_away")) {
      expect_equal(r[[k]][!skip], g[[paste0("sdvpy_", k)]][!skip], label = paste(g$game_id[1], k))
    }
  }
})

test_that("timeouts remaining before a play match sdv-py through the engine", {
  testthat::skip_on_cran()
  mism <- 0L
  for (g in read_oracle()) {
    n <- nrow(g)
    home <- g$start_is_home
    df <- data.frame(
      game_id = 1L, id_play = g$id_play, play_type = g$type, play_text = g$text,
      period = g$period, half = ifelse(g$period <= 2, 1, ifelse(g$period <= 4, 2, g$period - 2)),
      # shuffled rows: the count must follow play_order, not row order
      play_order = seq_len(n),
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
    py_off <- ifelse(home, g$sdvpy_start_home, g$sdvpy_start_away)
    py_def <- ifelse(home, g$sdvpy_start_away, g$sdvpy_start_home)
    bad <- !(r$off_timeouts_rem_before %in% NA) &
      (r$off_timeouts_rem_before != py_off | r$def_timeouts_rem_before != py_def)
    mism <- mism + sum(bad[!ot_order_rows(g)])
  }
  # 3,021 plays. The one NA row (283332199's first second-half row, a Penalty
  # before any snap of the half) is the engine's own lag boundary, not a count.
  expect_identical(mism, 0L)
})
