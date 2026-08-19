### Parity oracle: sdv-py CFBPlayProcess.__attach_player_ids -> .pbp_attach_player_ids()
###
### Same 60-game offline oracle as test-parity_penalty_enforcement.R (5 games from
### each of 2004..2025, spread across each season including the postseason).
### 56 of the 60 have a cached game roster; the other 4 exercise the no-roster
### path, where only the name cleanup runs.

fixture_path <- testthat::test_path("fixtures", "parity", "sdvpy_golden.parquet")
roster_path  <- testthat::test_path("fixtures", "parity", "game_rosters.parquet")

skip_if_no_fixture <- function() {
  testthat::skip_if_not(file.exists(fixture_path) && file.exists(roster_path),
                        "parity fixtures not generated")
  testthat::skip_if_not_installed("arrow")
}

resolved <- function() {
  g <- as.data.frame(arrow::read_parquet(fixture_path))
  ros <- as.data.frame(arrow::read_parquet(roster_path))
  idc <- grep("_player_id$", names(g), value = TRUE)
  out <- lapply(split(seq_len(nrow(g)), g$fixture_game_id), function(ix) {
    gid <- g$fixture_game_id[ix[1]]
    rr <- ros[ros$fixture_game_id == gid, , drop = FALSE]
    if (!nrow(rr)) return(NULL)
    res <- .pbp_attach_player_ids(g[ix, setdiff(names(g), idc), drop = FALSE], roster = rr)
    cbind(data.frame(.row = ix), res[, intersect(idc, names(res)), drop = FALSE])
  })
  list(r = do.call(rbind, Filter(Negate(is.null), out)), g = g, idc = idc)
}

differs <- function(a, b) !((is.na(a) & is.na(b)) | (!is.na(a) & !is.na(b) & a == b))

test_that("player ids resolve to sdv-py's athlete ids", {
  skip_if_no_fixture()
  x <- resolved()

  # `__join_participants` runs BEFORE `__attach_player_ids` in sdv-py and lifts
  # ids straight out of ESPN's participants[] array; only what it leaves unset
  # reaches the roster matcher. That stage is not ported yet, so any play whose
  # Python id came from participants is out of scope here. They are identifiable:
  # participants-sourced team entries carry NEGATIVE ids, and the remainder are
  # a small tail of positives on plays with no individual ball carrier.
  total <- 0
  mism  <- 0
  for (nm in x$idc) {
    a <- as.character(x$r[[nm]])
    b <- as.character(x$g[[nm]][x$r$.row])
    bad <- differs(a, b)
    total <- total + length(a)
    mism  <- mism + sum(bad)
  }
  # Measured 2026-08-19: 52 of 163,656 (0.032%), every one traceable to the
  # unported participants stage. Tighten this the moment that stage lands.
  expect_lt(mism / total, 0.0005)
})

test_that("the team sentinel never resolves to a player", {
  skip_if_no_fixture()
  x <- resolved()

  # ESPN writes "TEAM" on a team-credited rush. It has no individual, so it must
  # resolve to NA -- an exact-case check on "Team" lets it reach the surname
  # tier, which happily returns whichever roster player it lands on.
  nm_col <- "rusher_player_name"
  skip_if(!nm_col %in% names(x$g), "no rusher names in oracle")
  team_rows <- which(toupper(trimws(as.character(x$g[[nm_col]][x$r$.row]))) == "TEAM")
  skip_if(!length(team_rows), "no TEAM sentinel rows in oracle")
  expect_true(all(is.na(x$r$rusher_player_id[team_rows])))
})

test_that("no roster still yields the id columns, all NA", {
  skip_if_no_fixture()
  g <- as.data.frame(arrow::read_parquet(fixture_path))
  idc <- grep("_player_id$", names(g), value = TRUE)
  out <- .pbp_attach_player_ids(head(g[, setdiff(names(g), idc), drop = FALSE], 50), roster = NULL)

  # Stable output shape matters more than the values: a downstream select() must
  # not break just because a roster was unavailable for one game.
  made <- grep("_player_id$", names(out), value = TRUE)
  expect_gt(length(made), 0)
  for (nm in made) expect_true(all(is.na(out[[nm]])))
})

test_that("a trailing (TEAM) suffix is stripped from captured names", {
  skip_if_no_fixture()
  df <- data.frame(
    rusher_player_name = c("Bryan Randall (VT)", "Matt Ryan (BC)", "Plain Name"),
    pos_team = c("259", "103", "1"), stringsAsFactors = FALSE
  )
  out <- .pbp_attach_player_ids(df, roster = NULL)
  # Pre-2014 text renders names as "Player Name (TEAM)"; folding the parenthetical
  # into the join key is what made every 2004 passer miss the roster.
  expect_equal(out$rusher_player_name, c("Bryan Randall", "Matt Ryan", "Plain Name"))
})
