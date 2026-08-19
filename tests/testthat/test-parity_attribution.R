### Parity oracle: sdv-py CFBPlayProcess.__add_attribution_cols
###                 -> .pbp_add_attribution_cols()
###
### Same 60-game offline corpus as the other parity files.
### `attribution_oracle.parquet` snapshots every column the Python stage READS
### and every column it WRITES (suffixed `__out`), so the assertion is "given the
### same inputs, does R produce the same output".

oracle_path <- testthat::test_path("fixtures", "parity", "attribution_oracle.parquet")

skip_if_no_fixture <- function() {
  testthat::skip_if_not(file.exists(oracle_path), "parity fixtures not generated")
  testthat::skip_if_not_installed("arrow")
}

attributed <- function() {
  o <- as.data.frame(arrow::read_parquet(oracle_path))
  inp <- setdiff(names(o), c(grep("__out$", names(o), value = TRUE), "fixture_game_id"))
  out <- lapply(split(seq_len(nrow(o)), o$fixture_game_id), function(ix) {
    res <- .pbp_add_attribution_cols(o[ix, inp, drop = FALSE])
    cbind(data.frame(.row = ix), res[, setdiff(names(res), inp), drop = FALSE])
  })
  list(r = do.call(rbind, out), o = o)
}

# Team columns are Int32 in polars and character here; compare as character so a
# dtype difference is not reported as a value difference.
differs <- function(a, b) {
  a <- as.character(a); b <- as.character(b)
  !((is.na(a) & is.na(b)) | (!is.na(a) & !is.na(b) & a == b))
}

test_that("team attribution matches sdv-py", {
  skip_if_no_fixture()
  x <- attributed()

  # The special-teams flip is the load-bearing convention: pos_team means the
  # RECEIVING team on a kickoff and the KICKING team on a punt or field goal.
  # Every kicking/return column below follows from it.
  for (nm in c("kicking_team", "return_team", "punt_return_team",
               "kick_return_team", "fg_team", "punt_team",
               "sack_team", "interception_team", "pass_breakup_team",
               "forced_fumble_team")) {
    bad <- sum(differs(x$r[[nm]], x$o[[paste0(nm, "__out")]][x$r$.row]))
    expect_equal(bad, 0L, info = paste0(nm, ": ", bad, " of ", nrow(x$r)))
  }
})

test_that("the fumble and recovery chain matches sdv-py", {
  skip_if_no_fixture()
  x <- attributed()

  for (nm in c("fumble_or_muff", "fumbling_team", "recovery_team",
               "recovery_team_2", "fumble_recovery_team")) {
    bad <- sum(differs(x$r[[nm]], x$o[[paste0(nm, "__out")]][x$r$.row]))
    expect_equal(bad, 0L, info = paste0(nm, ": ", bad, " of ", nrow(x$r)))
  }
})

test_that("the per-side turnover flags match sdv-py", {
  skip_if_no_fixture()
  x <- attributed()

  # Framed per side deliberately: a single play can lose the ball twice (offense
  # fumbles, defense recovers and fumbles back), and both teams must register a
  # turnover to match the official box's per-event accounting.
  for (nm in c("int_turnover", "pos_fumble_lost", "def_fumble_lost",
               "is_pos_team_turnover", "is_def_pos_team_turnover",
               "is_turnover", "turnover_team", "is_st_turnover",
               "is_blocked_punt_turnover", "is_blocked_fg_turnover")) {
    bad <- sum(differs(x$r[[nm]], x$o[[paste0(nm, "__out")]][x$r$.row]))
    expect_equal(bad, 0L, info = paste0(nm, ": ", bad, " of ", nrow(x$r)))
  }
})

test_that("penalty attribution matches sdv-py", {
  skip_if_no_fixture()
  x <- attributed()

  for (nm in c("penalized_team", "penalty_team_id", "penalty_yards_signed")) {
    bad <- sum(differs(x$r[[nm]], x$o[[paste0(nm, "__out")]][x$r$.row]))
    expect_equal(bad, 0L, info = paste0(nm, ": ", bad, " of ", nrow(x$r)))
  }
})

test_that("the oracle exercises every branch it claims to", {
  skip_if_no_fixture()
  o <- as.data.frame(arrow::read_parquet(oracle_path))

  # Guards the guard. A column that is constant in the oracle cannot fail a
  # comparison, so the parity tests above would pass on a stub returning NA.
  # Measured 2026-08-19 over 9,545 plays.
  expect_gt(sum(o$is_turnover__out %in% TRUE), 100L)        # 153
  expect_gt(sum(!is.na(o$kicking_team__out)), 1000L)        # 1,235
  expect_gt(sum(!is.na(o$recovery_team__out)), 20L)         # 31
  expect_gt(sum(!is.na(o$penalized_team__out)), 100L)       # 674, 68 team ids
  expect_gt(sum(o$int_turnover__out %in% TRUE), 50L)        # 88

  # THIN BRANCHES -- stated rather than hidden behind a passing threshold.
  # These three are exercised by exactly ONE oracle row each, so their parity
  # comparison is close to untested and a regression could slip through it.
  # They are covered instead by the hand-built cases below ("both teams can
  # register a turnover on one play", "a blocked punt stays out of
  # is_turnover"). Widening the fixture corpus is the real fix.
  expect_gte(sum(o$is_st_turnover__out %in% TRUE), 1L)
  expect_gte(sum(o$def_fumble_lost__out %in% TRUE), 1L)
  expect_gte(sum(!is.na(o$recovery_team_2__out)), 1L)
})

test_that("the derived flags reproduce the oracle exactly", {
  skip_if_no_fixture()
  o <- as.data.frame(arrow::read_parquet(oracle_path))
  inp <- setdiff(names(o), c(grep("__out$", names(o), value = TRUE), "fixture_game_id"))

  # `sp`, `fg_attempt` and `scrimmage_play` are sdv-py flags that cfbfastR's
  # pipeline does not produce, so PRODUCTION always takes the derived path while
  # the oracle above always takes the explicit one -- the parity tests would
  # never exercise the code that actually runs. Dropping the three columns
  # reproduces the production condition. Measured 2026-08-19: 0 differences
  # across 267,260 cells, i.e. the taxonomy derivation is exactly equivalent.
  cols <- setdiff(inp, c("sp", "fg_attempt", "scrimmage_play"))
  out <- lapply(split(seq_len(nrow(o)), o$fixture_game_id), function(ix) {
    res <- .pbp_add_attribution_cols(o[ix, cols, drop = FALSE])
    cbind(data.frame(.row = ix), res[, setdiff(names(res), cols), drop = FALSE])
  })
  r <- do.call(rbind, out)

  bad <- 0L
  for (nm in setdiff(names(r), ".row")) {
    k <- paste0(nm, "__out")
    if (!k %in% names(o)) next
    bad <- bad + sum(differs(r[[nm]], o[[k]][r$.row]))
  }
  expect_equal(bad, 0L)
})

test_that("an overturned play does not count its reversed fumble", {
  # ESPN appends the REVERSED description after CALL OVERTURNED. Parsing
  # recoveries out of that clause counts a reversed fumble as a real turnover.
  df <- data.frame(
    pos_team_id = c("1", "1"),
    def_pos_team_id = c("2", "2"),
    play_text = c(
      "J. Smith rush for 3 yards (Original Play: J. Smith fumbled, recovered by AWY)",
      "J. Smith fumbled, recovered by AWY"
    ),
    play_type = c("Rush", "Fumble Recovery (Opponent)"),
    fumble_vec = c(0, 1), int = c(0, 0), sp = c(0, 0), scrimmage_play = c(1, 1),
    kickoff_play = c(0, 0), punt = c(0, 0), fg_attempt = c(0, 0),
    change_of_poss = c(0, 1),
    home_team_id = c("1", "1"), away_team_id = c("2", "2"),
    home_team_abbreviation = c("HOM", "HOM"),
    away_team_abbreviation = c("AWY", "AWY"),
    stringsAsFactors = FALSE
  )
  out <- .pbp_add_attribution_cols(df)
  expect_true(is.na(out$recovery_team[1]))
  expect_equal(out$recovery_team[2], "2")
  expect_false(out$is_turnover[1])
  expect_true(out$is_turnover[2])
})

test_that("both teams can register a turnover on one play", {
  # Offense fumbles (defense recovers), defense fumbles on the return (offense
  # recovers). A single-flag model cannot express this.
  df <- data.frame(
    pos_team_id = "1", def_pos_team_id = "2",
    play_text = "J. Smith fumbled, recovered by AWY. B. Jones fumbled, recovered by HOM",
    play_type = "Fumble Recovery (Opponent)",
    fumble_vec = 1, int = 0, sp = 0, scrimmage_play = 1,
    kickoff_play = 0, punt = 0, fg_attempt = 0, change_of_poss = 1,
    home_team_id = "1", away_team_id = "2",
    home_team_abbreviation = "HOM", away_team_abbreviation = "AWY",
    stringsAsFactors = FALSE
  )
  out <- .pbp_add_attribution_cols(df)
  expect_true(out$pos_fumble_lost)
  expect_true(out$def_fumble_lost)
  expect_true(out$is_pos_team_turnover)
  expect_true(out$is_def_pos_team_turnover)
})

test_that("a blocked punt stays out of is_turnover", {
  # ESPN's official box counts only giveaways. Folding blocked kicks into
  # is_turnover breaks the reconciliation against it while looking more complete.
  df <- data.frame(
    pos_team_id = "1", def_pos_team_id = "2",
    play_text = "Punt blocked", play_type = "Blocked Punt Touchdown",
    fumble_vec = 0, int = 0, sp = 1, scrimmage_play = 0,
    kickoff_play = 0, punt = 1, fg_attempt = 0, change_of_poss = 1,
    home_team_id = "1", away_team_id = "2",
    home_team_abbreviation = "HOM", away_team_abbreviation = "AWY",
    stringsAsFactors = FALSE
  )
  out <- .pbp_add_attribution_cols(df)
  expect_true(out$is_blocked_punt_turnover)
  expect_false(out$is_turnover)
  expect_false(out$is_st_turnover)
})

test_that("the special-teams flip credits the right side", {
  df <- data.frame(
    pos_team_id = c("1", "1"), def_pos_team_id = c("2", "2"),
    play_text = c("Kickoff", "Punt"), play_type = c("Kickoff", "Punt"),
    kickoff_play = c(1, 0), punt = c(0, 1), fg_attempt = c(0, 0),
    fumble_vec = c(0, 0), int = c(0, 0), sp = c(1, 1), scrimmage_play = c(0, 0),
    change_of_poss = c(0, 0),
    home_team_id = c("1", "1"), away_team_id = c("2", "2"),
    home_team_abbreviation = c("HOM", "HOM"),
    away_team_abbreviation = c("AWY", "AWY"),
    stringsAsFactors = FALSE
  )
  out <- .pbp_add_attribution_cols(df)
  # Kickoff: pos_team is the RECEIVING team, so the kicker is the defence.
  expect_equal(out$kicking_team[1], "2")
  expect_equal(out$return_team[1], "1")
  # Punt: pos_team is the KICKING team.
  expect_equal(out$kicking_team[2], "1")
  expect_equal(out$return_team[2], "2")
})
