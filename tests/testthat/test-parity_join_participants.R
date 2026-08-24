### Parity oracle: sdv-py CFBPlayProcess.__join_participants -> .pbp_join_participants()
###
### Same 60-game offline corpus as the other parity files (5 games from each of
### 2004, 2006, 2008, 2010, 2013, 2014, 2017, 2019, 2020, 2021, 2023 and 2025,
### spread across each season including the postseason). The list straddles 2014
### deliberately: before it ESPN ships no structured participants[], so 26 of the
### 60 games exercise the no-participants path and 34 the real join.
###
### `participants_oracle.parquet` snapshots the pbp name columns immediately
### BEFORE and AFTER the Python stage, so the assertion is "given the same two
### inputs, does R produce the same output" rather than the far weaker "is the
### already-coalesced frame idempotent". 1,236 of the 9,545 x 11 name cells
### change at this stage, so the test has teeth.

oracle_path <- testthat::test_path("fixtures", "parity", "participants_oracle.parquet")
parts_path  <- testthat::test_path("fixtures", "parity", "play_participants.parquet")

skip_if_no_fixture <- function() {
  testthat::skip_on_cran()
  testthat::skip_if_not(file.exists(oracle_path) && file.exists(parts_path),
                        "parity fixtures not generated")
  testthat::skip_if_not_installed("arrow")
}

joined <- function() {
  o <- as.data.frame(arrow::read_parquet(oracle_path))
  p <- as.data.frame(arrow::read_parquet(parts_path))
  cols <- sub("__before$", "", grep("__before$", names(o), value = TRUE))

  out <- lapply(split(seq_len(nrow(o)), o$fixture_game_id), function(ix) {
    gid <- o$fixture_game_id[ix[1]]
    before <- o[ix, c("id", "int", paste0(cols, "__before")), drop = FALSE]
    names(before) <- c("id", "int", cols)
    res <- .pbp_join_participants(before, p[p$fixture_game_id == gid, , drop = FALSE])
    cbind(data.frame(.row = ix), res[, cols, drop = FALSE])
  })
  list(r = do.call(rbind, out), o = o, cols = cols)
}

differs <- function(a, b) !((is.na(a) & is.na(b)) | (!is.na(a) & !is.na(b) & a == b))

test_that("participant names coalesce exactly as sdv-py does", {
  testthat::skip_on_cran()
  skip_if_no_fixture()
  x <- joined()

  # Per-column so a failure names the role that broke rather than a total.
  for (nm in x$cols) {
    r  <- as.character(x$r[[nm]])
    py <- as.character(x$o[[paste0(nm, "__after")]][x$r$.row])
    expect_equal(sum(differs(r, py)), 0L,
                 info = paste0(nm, ": ", sum(differs(r, py)), " of ", length(r)))
  }
})

test_that("the stage actually rewrites names (the oracle is not a no-op)", {
  testthat::skip_on_cran()
  skip_if_no_fixture()
  x <- joined()

  # Guards the guard: if a future refactor silently stopped joining, every
  # column would still "match" a before/after pair that never diverged.
  changed <- sum(vapply(x$cols, function(nm) {
    sum(differs(as.character(x$o[[paste0(nm, "__before")]]),
                as.character(x$o[[paste0(nm, "__after")]])))
  }, integer(1)))
  expect_gt(changed, 1000L)
})

test_that("row count and column set survive the join", {
  testthat::skip_on_cran()
  skip_if_no_fixture()
  o <- as.data.frame(arrow::read_parquet(oracle_path))
  p <- as.data.frame(arrow::read_parquet(parts_path))
  gid <- p$fixture_game_id[1]
  cols <- sub("__before$", "", grep("__before$", names(o), value = TRUE))
  before <- o[o$fixture_game_id == gid, c("id", "int", paste0(cols, "__before")), drop = FALSE]
  names(before) <- c("id", "int", cols)

  out <- .pbp_join_participants(before, p[p$fixture_game_id == gid, , drop = FALSE])
  # A duplicated participant row would fan the play-by-play out and quietly
  # double every downstream drive and EPA total.
  expect_equal(nrow(out), nrow(before))
  expect_equal(names(out), names(before))
})

test_that("a duplicated participant row cannot fan out the plays", {
  testthat::skip_on_cran()
  skip_if_no_fixture()
  p <- as.data.frame(arrow::read_parquet(parts_path))
  gid <- p$fixture_game_id[1]
  pg <- p[p$fixture_game_id == gid, , drop = FALSE]
  before <- data.frame(id = as.character(pg$play_id[1:3]),
                       rusher_player_name = c("A. Smith", NA, "B. Jones"),
                       stringsAsFactors = FALSE)

  out <- .pbp_join_participants(before, rbind(pg, pg))
  expect_equal(nrow(out), 3L)
})

test_that("no participants leaves the frame untouched", {
  testthat::skip_on_cran()
  df <- data.frame(id = c("1", "2"),
                   rusher_player_name = c("A. Smith", NA_character_),
                   stringsAsFactors = FALSE)
  # Pre-2014 games and every offline path land here.
  expect_equal(.pbp_join_participants(df, NULL), df)
  expect_equal(.pbp_join_participants(df, df[0, , drop = FALSE]), df)
})

test_that("return roles clean up but never introduce a name", {
  testthat::skip_on_cran()
  df <- data.frame(
    id = c("10", "11"),
    punt_return_player_name    = c("J. Smth", NA_character_),
    kickoff_return_player_name = c(NA_character_, NA_character_),
    stringsAsFactors = FALSE
  )
  parts <- data.frame(play_id = c("10", "11"),
                      returner_player_name = c("Jordan Smith", "Kicking Teamer"),
                      stringsAsFactors = FALSE)
  out <- .pbp_join_participants(df, parts)

  # punt_return_team / return_team can point at the KICKING team on some play
  # types, so filling an empty name there invents a returner on the wrong side.
  expect_equal(out$punt_return_player_name, c("Jordan Smith", NA_character_))
  expect_true(all(is.na(out$kickoff_return_player_name)))
})

test_that("the pass defender is routed to the interceptor on interceptions", {
  testthat::skip_on_cran()
  df <- data.frame(
    id  = c("20", "21"),
    int = c(1, 0),
    interception_player_name = c(NA_character_, NA_character_),
    pass_breakup_player_name = c("T. Taylor", NA_character_),
    stringsAsFactors = FALSE
  )
  parts <- data.frame(play_id = c("20", "21"),
                      pass_defender_player_name = c("Kyle Bretz", "Marcus Taylor"),
                      stringsAsFactors = FALSE)
  out <- .pbp_join_participants(df, parts)

  # ESPN files the interceptor as the pass defender on an interception.
  expect_equal(out$interception_player_name, c("Kyle Bretz", NA_character_))
  # A regex-extracted breakup on an interception is KEPT -- a tip drill names
  # two different defenders and the breakup credit is real.
  expect_equal(out$pass_breakup_player_name, c("T. Taylor", "Marcus Taylor"))
})

test_that("an 18-digit play id joins exactly", {
  testthat::skip_on_cran()
  # ESPN play ids run past 2^53, so a numeric join key silently collides
  # neighbouring plays. Two ids that differ only in the last digit must not
  # cross-match.
  ids <- c("401135269101849902", "401135269101849903")
  df <- data.frame(id = ids, rusher_player_name = c(NA_character_, NA_character_),
                   stringsAsFactors = FALSE)
  parts <- data.frame(play_id = ids,
                      rusher_player_name = c("First Runner", "Second Runner"),
                      stringsAsFactors = FALSE)
  out <- .pbp_join_participants(df, parts)
  expect_equal(out$rusher_player_name, c("First Runner", "Second Runner"))

  # And integer64 -- what arrow hands back for these ids -- must round-trip
  # exactly. Guarded because bit64 is only a Suggests.
  skip_if_not_installed("bit64")
  expect_equal(.as_play_key(bit64::as.integer64(ids)), ids)
})
