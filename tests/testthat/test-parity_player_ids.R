### Parity oracle: sdv-py CFBPlayProcess.__attach_player_ids -> .pbp_attach_player_ids()
###
### Same 60-game offline oracle as test-parity_penalty_enforcement.R (5 games from
### each of 2004..2025, spread across each season including the postseason).
### 56 of the 60 have a cached game roster; the other 4 exercise the no-roster
### path, where only the name cleanup runs.

fixture_path <- testthat::test_path("fixtures", "parity", "sdvpy_golden.parquet")
roster_path  <- testthat::test_path("fixtures", "parity", "game_rosters.parquet")
box_path     <- testthat::test_path("fixtures", "parity", "game_boxscores.parquet")

skip_if_no_fixture <- function() {
  testthat::skip_on_cran()
  testthat::skip_if_not(file.exists(fixture_path) && file.exists(roster_path),
                        "parity fixtures not generated")
  testthat::skip_if_not_installed("arrow")
}

# sdv-py resolves ids against roster records PLUS box-score records. `use_box`
# exists so the tests can assert both what each source is worth on its own and
# that the combination is what reaches parity.
resolved <- function(use_box = TRUE) {
  g <- as.data.frame(arrow::read_parquet(fixture_path))
  ros <- as.data.frame(arrow::read_parquet(roster_path))
  box <- if (use_box && file.exists(box_path)) {
    as.data.frame(arrow::read_parquet(box_path))
  } else {
    NULL
  }
  idc <- grep("_player_id$", names(g), value = TRUE)
  out <- lapply(split(seq_len(nrow(g)), g$fixture_game_id), function(ix) {
    gid <- g$fixture_game_id[ix[1]]
    rr <- ros[ros$fixture_game_id == gid, , drop = FALSE]
    recs <- if (nrow(rr)) {
      data.frame(athlete_id   = as.character(rr$athlete_id),
                 display_name = as.character(rr$athlete_display_name),
                 team_id      = as.character(rr$team_id),
                 stringsAsFactors = FALSE)
    } else {
      NULL
    }
    if (!is.null(box)) {
      bb <- box[box$fixture_game_id == gid, , drop = FALSE]
      if (nrow(bb)) {
        recs <- rbind(recs, data.frame(athlete_id   = as.character(bb$athlete_id),
                                       display_name = as.character(bb$display_name),
                                       team_id      = as.character(bb$team_id),
                                       stringsAsFactors = FALSE))
      }
    }
    if (is.null(recs) || !nrow(recs)) return(NULL)
    res <- .pbp_attach_player_ids(g[ix, setdiff(names(g), idc), drop = FALSE], roster = recs)
    cbind(data.frame(.row = ix), res[, intersect(idc, names(res)), drop = FALSE])
  })
  list(r = do.call(rbind, Filter(Negate(is.null), out)), g = g, idc = idc)
}

# The golden predates sdv-py's clause cut (`_PLAYER_NAME_CLAUSE_CUT`, ported in
# .pbp_attach_player_ids()), so it holds ids resolved from uncut names such as
# "Trapper Pannell 3 Yd", mostly NA. These are the 22 cells where R now differs
# from it because of the cut, each pinned with the id R must give (measured
# 2026-11-01). 20 are the ids sdv-py 4b78a45a3d gives; the two receivers
# ("Tracy Woods, broken up by ...", "Michael Campbell, broken up by D.J. Brown")
# stay NA, where the golden's ids are wrong (482165 is Temple's Matt Brown).
rewritten_cells <- utils::read.csv(text = "col,id,r_id
rusher_player_id,401520276102897901,4695951
rusher_player_id,401520276104988801,4695951
rusher_player_id,401520401102966001,4363050
receiver_player_id,303270193126,
receiver_player_id,303270193167,
punter_player_id,2429502771208,136102
punter_player_id,2434925723206,147899
kickoff_return_player_id,283232309014,174171
kickoff_return_player_id,283232309057,174171
kickoff_return_player_id,283232309087,174171
kickoff_return_player_id,283232309100,174171
kickoff_return_player_id,283232309107,174171
kickoff_return_player_id,283232309129,174171
kickoff_return_player_id,283232309157,174171
kickoff_return_player_id,302450005028,232848
kickoff_return_player_id,302450005040,232848
kickoff_return_player_id,302450005080,232848
kickoff_return_player_id,302450005097,232848
kickoff_return_player_id,303270193093,236499
punt_block_player_id,400933827103958201,3925347
punt_block_player_id,400933930102867101,4035369
punt_block_return_player_id,401110806103947001,4361090
", colClasses = "character", na.strings = "")

# Every cell where R's id differs from the golden: column, play id, R, golden.
mismatch_cells <- function(x) {
  do.call(rbind, lapply(x$idc, function(nm) {
    a <- as.character(x$r[[nm]])
    b <- as.character(x$g[[nm]][x$r$.row])
    d <- differs(a, b)
    data.frame(col = rep(nm, sum(d)), id = as.character(x$g$id[x$r$.row][d]),
               r_id = a[d], golden_id = b[d], stringsAsFactors = FALSE)
  }))
}

count_mismatches <- function(x) {
  total <- sum(vapply(x$idc, function(nm) length(x$r[[nm]]), integer(1)))
  cells <- mismatch_cells(x)
  pinned <- paste(cells$col, cells$id) %in% paste(rewritten_cells$col, rewritten_cells$id)
  c(mism = sum(!pinned), total = total)
}

differs <- function(a, b) !((is.na(a) & is.na(b)) | (!is.na(a) & !is.na(b) & a == b))

test_that("player ids resolve to sdv-py's athlete ids", {
  testthat::skip_on_cran()
  skip_if_no_fixture()
  x <- resolved()
  m <- count_mismatches(x)

  # Measured 2026-08-19 with roster + box-score records: 26 of 166,482
  # (0.0156%), down from 52 of 163,656 with the roster alone -- fewer
  # mismatches over MORE plays, because three fixture games have no roster and
  # were previously skipped outright. Three residual classes remain, all
  # characterised:
  #   16  R yields NA where Python resolves, concentrated on the fumble columns
  #       whose team column points at the side that did not have the ball
  #    5  R resolves where Python yields NA (game 400953746, one receiver and
  #       one sack) -- R over-matching, not a missing source
  #    5  a "TEAM" tail on rusher/punter where the two disagree on whether the
  #       box entry is reachable
  # Tighten this whenever one of those classes is closed.
  expect_lt(m[["mism"]] / m[["total"]], 0.0002)
  expect_identical(m[["mism"]], 26L)
  # the 22 cells the clause cut changes give exactly their pinned ids
  cells <- mismatch_cells(x)
  got <- merge(rewritten_cells, cells, by = c("col", "id"), all.x = TRUE, suffixes = c("", ".got"))
  expect_identical(nrow(got), 22L)
  expect_identical(got$r_id.got, got$r_id)

  # A pinned wrong-person id. 303270193058 "... fumbled, recovered by MiaOh D.J.
  # Brown at the Temp 20" resolves fumble_recovered_player_id to 482165 (Matt
  # Brown, Temple), as the golden does; sdv-py 4b78a45a3d gives None and the
  # player is 385205 (Miami (OH)). The golden's fumble_recovery_team, which this
  # test feeds in, is Temple (218): R's .pbp_add_attribution_cols() matches only
  # an ALL-CAPS "recovered by" token, as the August sdv-py did, while 4b78a45a3d
  # reads mixed-case tokens ("MiaOh") and the recoverer's box-score team
  # (_parse_recovery_sides / _recovery_sides_by_recoverer) and says 193. With
  # 218, the clause-cut name "MiaOh D.J. Brown" reaches the first-initial tier
  # (M. Brown) on Temple's roster. Not a small port; tracked as a follow-up.
  row <- which(as.character(x$g$id[x$r$.row]) == "303270193058")
  expect_identical(as.character(x$r$fumble_recovered_player_id[row]), "482165")
})

test_that("the box score is what closes the gap, not the roster alone", {
  testthat::skip_on_cran()
  skip_if_no_fixture()
  skip_if_not(file.exists(box_path), "box-score fixture not generated")

  roster_only <- count_mismatches(resolved(use_box = FALSE))
  both        <- count_mismatches(resolved(use_box = TRUE))

  # ESPN 404s the roster resource for a large share of games, so the box score
  # is not a nicety -- it is the only identity source on those. It must both cut
  # the mismatches AND cover more plays.
  expect_lt(both[["mism"]], roster_only[["mism"]])
  expect_gt(both[["total"]], roster_only[["total"]])
})

test_that("a bare Team sentinel is never fuzzy-matched to a player", {
  testthat::skip_on_cran()
  # "Team" with no play-text or box-score provenance must not resolve: reaching
  # the surname tier returns whichever roster player the fallback lands on -- a
  # wrong athlete on a play that had no individual ball carrier.
  roster <- data.frame(
    athlete_id   = c("111", "222"),
    display_name = c("Russell Team", "Alex Wilson"),
    team_id      = c("1", "1"),
    stringsAsFactors = FALSE
  )
  df <- data.frame(rusher_player_name = "Team", pos_team = "1",
                   stringsAsFactors = FALSE)
  expect_true(is.na(.pbp_attach_player_ids(df, roster = roster)$rusher_player_id))
})

test_that("the play-text sentinel resolves to the box score's team entry", {
  testthat::skip_on_cran()
  # ESPN writes "TEAM" in the play text and " Team" in the box score, and
  # sdv-py credits the box entry's negative id. Both must normalise to the same
  # key while a bare "Team" stays blanked -- see .norm_player_name, where the
  # case sensitivity is deliberate and load-bearing.
  roster <- data.frame(athlete_id = "-5154", display_name = " Team",
                       team_id = "333", stringsAsFactors = FALSE)
  df <- data.frame(rusher_player_name = c("TEAM", "Team"),
                   pos_team = c("333", "333"), stringsAsFactors = FALSE)
  out <- .pbp_attach_player_ids(df, roster = roster)
  expect_equal(out$rusher_player_id, c("-5154", NA_character_))
})

test_that("no roster still yields the id columns, all NA", {
  testthat::skip_on_cran()
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
  testthat::skip_on_cran()
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
