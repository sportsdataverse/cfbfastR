### Parity oracles for the two play-text derivations:
###   CFBPlayProcess.__add_air_yards_cols  -> .pbp_add_air_yards_cols()
###   the depth/direction block of __add_player_cols
###                                        -> .pbp_add_pass_direction_cols()
###
### Same 60-game offline corpus. Each oracle snapshots every column the Python
### stage reads and every column it writes (suffixed `__out`).

air_path <- testthat::test_path("fixtures", "parity", "airyards_oracle.parquet")
dir_path <- testthat::test_path("fixtures", "parity", "direction_oracle.parquet")

differs <- function(a, b) {
  a <- as.character(a)
  b <- as.character(b)
  !((is.na(a) & is.na(b)) | (!is.na(a) & !is.na(b) & a == b))
}

replay <- function(path, fn) {
  o <- as.data.frame(arrow::read_parquet(path))
  inp <- setdiff(names(o), c(grep("__out$", names(o), value = TRUE), "fixture_game_id"))
  out <- lapply(split(seq_len(nrow(o)), o$fixture_game_id), function(ix) {
    res <- fn(o[ix, inp, drop = FALSE])
    cbind(data.frame(.row = ix), res[, setdiff(names(res), inp), drop = FALSE])
  })
  list(r = do.call(rbind, out), o = o)
}


test_that("air yards match sdv-py on every row", {
  testthat::skip_on_cran()
  skip_if_not(file.exists(air_path), "air-yards fixture not generated")
  skip_if_not_installed("arrow")
  x <- replay(air_path, .pbp_add_air_yards_cols)

  # Exact parity on every row, both directions: sdv-py resolves the article
  # form too since #418, and this port learns the vendor abbreviations the same
  # way, so there is no longer a partition to explain away.
  for (nm in c("air_yardsToEndzone", "air_yards", "yards_after_catch")) {
    bad <- sum(differs(x$r[[nm]], x$o[[paste0(nm, "__out")]][x$r$.row]))
    expect_equal(bad, 0L, info = paste0(nm, ": ", bad, " of ", nrow(x$r)))
  }
})

test_that("vendor abbreviations the payload does not carry still resolve", {
  testthat::skip_on_cran()
  skip_if_not(file.exists(air_path), "air-yards fixture not generated")
  skip_if_not_installed("arrow")
  x <- replay(air_path, .pbp_add_air_yards_cols)
  o <- x$o[x$r$.row, ]
  # The five 2025/26 games whose text abbreviation is not ESPN's (TA&M-SC,
  # UNLV-HAW, CCU-GAST, LIB-DEL, NDSU-JVST). Every spot-phrase pass play in
  # them must resolve -- the payload-abbreviation fallback alone resolved 0-51%.
  vendor <- o$fixture_game_id %in% c(401752772, 401760418, 401761645, 401757293, 401864577)
  spot <- grepl("caught at|thrown to", o$text, ignore.case = TRUE)
  expect_gt(sum(vendor & spot), 200L)
  expect_equal(sum(is.na(x$r$air_yardsToEndzone[vendor & spot])), 0L)
})

test_that("the air-yards oracle is not degenerate", {
  testthat::skip_on_cran()
  skip_if_not(file.exists(air_path), "air-yards fixture not generated")
  skip_if_not_installed("arrow")
  o <- as.data.frame(arrow::read_parquet(air_path))

  # A column that is all-NA in the oracle cannot fail a comparison, so the test
  # above would pass on a stub. Both sides of the field must be represented too
  # -- the whole point of the stage is siding the catch abbreviation, and an
  # oracle with only one side would not test it. Re-captured 2026-09-01 from
  # sdv-py 9efee9f1 (see fixtures/parity/README.md): the 56 fixture games
  # contribute ~140 air-yards rows (ESPN only annotates the catch point on
  # recent seasons); the five vendor-abbreviation games add several hundred.
  expect_gt(sum(!is.na(o$air_yards__out)), 400L)
  expect_gt(sum(!is.na(o$yards_after_catch__out)), 200L)
  expect_gt(length(unique(stats::na.omit(o$air_yardsToEndzone__out))), 40L)
  expect_true("end.yardsToEndzone" %in% names(o))
  # Both sides of the field, asserted directly: a port that mirrors the catch
  # point about midfield would still pass a uniqueness count.
  yl <- suppressWarnings(as.integer(stringr::str_match(
    o$text, stringr::regex(.catch_spot_re, ignore_case = TRUE))[, 3]))
  out <- o$air_yardsToEndzone__out
  expect_gt(sum(!is.na(out) & out == yl), 50L)          # defending side
  expect_gt(sum(!is.na(out) & out == 100L - yl), 50L)   # possessing side
})

test_that("the catch point is sided against the right team", {
  testthat::skip_on_cran()
  # "caught at HOM35" with the possessing team owning that side means 65 yards
  # still to the endzone; the same text on the DEFENDING team's side means 35.
  # Getting this backwards silently mirrors every air-yards value about midfield.
  df <- data.frame(
    play_text = c("A. Smith pass complete to B. Jones caught at HOM35",
                  "A. Smith pass complete to B. Jones caught at AWY35"),
    pos_team_id = c("1", "1"), def_pos_team_id = c("2", "2"),
    home_team_id = c("1", "1"),
    home_team_abbreviation = c("HOM", "HOM"),
    away_team_abbreviation = c("AWY", "AWY"),
    yards_to_goal = c(80, 80), yards_gained = c(30, 30),
    completion = c(1, 1), stringsAsFactors = FALSE
  )
  out <- .pbp_add_air_yards_cols(df)
  expect_equal(out$air_yardsToEndzone, c(65L, 35L))
  expect_equal(out$air_yards, c(15L, 45L))
  expect_equal(out$yards_after_catch, c(15L, -15L))
})

test_that("an abbreviation ESPN spells differently still resolves", {
  testthat::skip_on_cran()
  # ESPN ships two abbreviation forms for some teams -- "caught at BUF35" in the
  # text while the payload carries "BUFF". Prefix-tolerant matching is what
  # keeps those plays from silently losing their air yards.
  df <- data.frame(
    play_text = "pass complete caught at BUF35",
    pos_team_id = "1", def_pos_team_id = "2", home_team_id = "1",
    home_team_abbreviation = "BUFF", away_team_abbreviation = "AWY",
    yards_to_goal = 80, yards_gained = 30, completion = 1,
    stringsAsFactors = FALSE
  )
  expect_equal(.pbp_add_air_yards_cols(df)$air_yardsToEndzone, 65L)
})

test_that("yards after catch is computed for completions only", {
  testthat::skip_on_cran()
  # An incompletion has a catch point but no yards after it; subtracting there
  # would invent a number.
  df <- data.frame(
    play_text = c("pass complete caught at HOM35", "pass incomplete thrown to HOM35"),
    pos_team_id = c("1", "1"), def_pos_team_id = c("2", "2"),
    home_team_id = c("1", "1"),
    home_team_abbreviation = c("HOM", "HOM"), away_team_abbreviation = c("AWY", "AWY"),
    yards_to_goal = c(80, 80), yards_gained = c(30, 0),
    completion = c(1, 0), stringsAsFactors = FALSE
  )
  out <- .pbp_add_air_yards_cols(df)
  expect_equal(out$yards_after_catch, c(15L, NA_integer_))
  # The target still gets air yards -- that is the point of "thrown to".
  expect_equal(out$air_yards, c(15L, 15L))
})

test_that("no catch text yields NA, not zero", {
  testthat::skip_on_cran()
  df <- data.frame(
    play_text = "J. Smith run for 5 yards",
    pos_team_id = "1", def_pos_team_id = "2", home_team_id = "1",
    home_team_abbreviation = "HOM", away_team_abbreviation = "AWY",
    yards_to_goal = 80, yards_gained = 5, completion = 0,
    stringsAsFactors = FALSE
  )
  out <- .pbp_add_air_yards_cols(df)
  expect_true(is.na(out$air_yardsToEndzone))
  expect_true(is.na(out$air_yards))
})

.vendor_game <- function(extra) {
  # NDSU (home, payload "NDSU") vs Jacksonville St (away, payload "JVST", text "JSU").
  base <- data.frame(
    play_text = c("#3 C.Miller rush for 5 yards to the JSU30",
                  "#3 C.Miller rush for 4 yards to the JSU26",
                  "#3 C.Miller rush for 2 yards to the NDSU40",
                  "#3 C.Miller rush for 3 yards to the NDSU43"),
    pos_team_id = "2449", def_pos_team_id = "55", home_team_id = "2449",
    home_team_abbreviation = "NDSU", away_team_abbreviation = "JVST",
    yards_to_goal = c(35, 30, 62, 60), yards_to_goal_end = c(30, 26, 60, 57),
    yards_gained = c(5, 4, 2, 3), completion = 0, stringsAsFactors = FALSE
  )
  rbind(base, extra)
}

test_that("a vendor abbreviation is learned from the game's own end spots", {
  testthat::skip_on_cran()
  # "JSU" is not a prefix of the payload's "JVST": only the end spots can side it.
  df <- .vendor_game(data.frame(
    play_text = c("#2 N.Hayes pass complete short left to #18 J.Williams caught at JSU47, for 14 yards",
                  "#12 C.Creel pass incomplete short right to #9 R.Johnson thrown to JSU33"),
    pos_team_id = c("55", "2449"), def_pos_team_id = c("2449", "55"), home_team_id = "2449",
    home_team_abbreviation = "NDSU", away_team_abbreviation = "JVST",
    yards_to_goal = c(65, 40), yards_to_goal_end = c(51, 40),
    yards_gained = c(14, 0), completion = c(1, 0), stringsAsFactors = FALSE
  ))
  out <- .pbp_add_air_yards_cols(df)
  expect_equal(utils::tail(out$air_yardsToEndzone, 2), c(53L, 33L))
  expect_equal(utils::tail(out$air_yards, 2), c(12L, 7L))
  expect_equal(utils::tail(out$yards_after_catch, 2), c(2L, NA_integer_))
})

test_that("the side vote needs a majority and two votes, and uses the last spot", {
  testthat::skip_on_cran()
  df <- .vendor_game(data.frame(
    play_text = c(
      # a mis-stated spot that says JSU is the possessing side (end 70 at "JSU30")
      "#3 C.Miller rush for 1 yard to the JSU30",
      # a fumble return: two spots, only the LAST matches the end yardline
      "#3 C.Miller rush for 5 yards to the JSU30, fumble, recovered by JSU returned to the NDSU45",
      # a lone "XYZ" spot: one vote cannot establish a side
      "#3 C.Miller rush for 1 yard to the XYZ30",
      "pass complete to Y caught at JSU20, for 5 yards",
      "pass complete to Y caught at XYZ20, for 5 yards"),
    pos_team_id = "2449", def_pos_team_id = "55", home_team_id = "2449",
    home_team_abbreviation = "NDSU", away_team_abbreviation = "JVST",
    yards_to_goal = c(71, 35, 31, 25, 25), yards_to_goal_end = c(70, 55, 30, 20, 20),
    yards_gained = c(1, 5, 1, 5, 5), completion = c(0, 0, 0, 1, 1), stringsAsFactors = FALSE
  ))
  out <- .pbp_add_air_yards_cols(df)
  expect_equal(utils::tail(out$air_yardsToEndzone, 2), c(20L, NA_integer_))
})

test_that("vendor token shapes with a space, a dot or two words all parse", {
  testthat::skip_on_cran()
  df <- data.frame(
    play_text = c("pass complete to X caught at HOM 10, for 2 yards",
                  "pass complete to X caught at AWY.41, for 9 yards",
                  "pass incomplete to X thrown to Sac St10",
                  "pass incomplete to X thrown to NC ST19"),
    pos_team_id = "1", def_pos_team_id = "2", home_team_id = "1",
    home_team_abbreviation = c("HOM", "HOM", "SACST", "NCST"),
    away_team_abbreviation = "AWY",
    yards_to_goal = c(20, 50, 30, 30), yards_gained = c(2, 9, 0, 0),
    completion = c(1, 1, 0, 0), stringsAsFactors = FALSE
  )
  out <- .pbp_add_air_yards_cols(df)
  expect_equal(out$air_yardsToEndzone, c(90L, 41L, 90L, 81L))
})

test_that("a spot at the 50 needs no abbreviation", {
  testthat::skip_on_cran()
  df <- data.frame(
    play_text = c("pass complete to X caught at 50, for 3 yards",
                  "pass complete to X caught at the 50, for 3 yards"),
    pos_team_id = "1", def_pos_team_id = "2", home_team_id = "1",
    home_team_abbreviation = "HOM", away_team_abbreviation = "AWY",
    yards_to_goal = 60, yards_gained = 3, completion = 1, stringsAsFactors = FALSE
  )
  out <- .pbp_add_air_yards_cols(df)
  expect_equal(out$air_yardsToEndzone, c(50L, 50L))
  expect_equal(out$air_yards, c(10L, 10L))
})

test_that("the side map is learned per game, not across the frame", {
  testthat::skip_on_cran()
  # The same text token "ST" means the home team in game A and the away team in
  # game B; a frame-wide vote would blend them.
  a <- data.frame(game_id = "A",
    play_text = c("rush for 5 yards to the ST30", "rush for 4 yards to the ST26", "pass complete caught at ST20, for 5 yards"),
    pos_team_id = "9", def_pos_team_id = "1", home_team_id = "1",
    home_team_abbreviation = "STATE", away_team_abbreviation = "OPP",
    yards_to_goal = c(35, 30, 25), yards_to_goal_end = c(30, 26, 20), yards_gained = c(5, 4, 5),
    completion = c(0, 0, 1), stringsAsFactors = FALSE)
  b <- data.frame(game_id = "B",
    play_text = c("rush for 5 yards to the ST30", "rush for 4 yards to the ST26", "pass complete caught at ST20, for 5 yards"),
    pos_team_id = "7", def_pos_team_id = "8", home_team_id = "7",
    home_team_abbreviation = "HOME", away_team_abbreviation = "AWAY",
    yards_to_goal = c(75, 70, 85), yards_to_goal_end = c(70, 74, 80), yards_gained = c(5, 4, 5),
    completion = c(0, 0, 1), stringsAsFactors = FALSE)
  out <- .pbp_add_air_yards_cols(rbind(a, b))
  # game A: ST is the defending side (end 30 == 30) -> catch at ST20 = 20 to go
  # game B: ST is the possessing side (end 70 == 100-30) -> catch at ST20 = 80 to go
  expect_equal(out$air_yardsToEndzone[c(3, 6)], c(20L, 80L))
})

test_that("a null possessing team yields NA, not a guess", {
  testthat::skip_on_cran()
  # Deliberate divergence from sdv-py (cfb_pbp.py __add_air_yards_cols: a null
  # pos_team collapses both sides to the away abbreviation and emits 65 here).
  # R only sides what it can prove: the defending team's side still resolves,
  # the possessing team's side does not.
  df <- data.frame(
    play_text = c("pass complete caught at AWY35", "pass complete caught at HOM35"),
    pos_team_id = NA_character_, def_pos_team_id = c("2", "2"), home_team_id = "1",
    home_team_abbreviation = "HOM", away_team_abbreviation = "AWY",
    yards_to_goal = 80, yards_gained = 30, completion = 1, stringsAsFactors = FALSE
  )
  out <- .pbp_add_air_yards_cols(df)
  # AWY is still the known DEFENDING side -> 35 (sdv-py says 65); HOM cannot be
  # sided without the possessing team -> NA.
  expect_equal(out$air_yardsToEndzone, c(35L, NA_integer_))
  expect_equal(out$air_yards, c(45L, NA_integer_))
})

test_that("the ESPN v2 pipeline carries the end yardline into the side vote", {
  testthat::skip_on_cran()
  skip_if_offline()
  # NDSU-Jacksonville St 2026: the text says "JSU", the payload says "JVST". Only
  # the game-learned side (fed by end_yards_to_endzone through the v2 adapter)
  # resolves these plays -- the payload-abbreviation fallback alone gets 49%.
  x <- tryCatch(espn_cfb_pbp_v2(game_id = 401864577, epa_wpa = TRUE), error = function(e) NULL)
  if (!is.data.frame(x) || nrow(x) == 0 || !"air_yardsToEndzone" %in% names(x)) {
    skip("espn_cfb_pbp_v2(401864577, epa_wpa = TRUE) not available at test time")
  }
  spot <- grepl("caught at|thrown to", x$play_text, ignore.case = TRUE) & grepl("JSU[0-9]", x$play_text)
  expect_gt(sum(spot), 10L)
  expect_equal(sum(is.na(x$air_yardsToEndzone[spot])), 0L)
})

test_that("pass depth, direction and the hurry flag match sdv-py", {
  testthat::skip_on_cran()
  skip_if_not(file.exists(dir_path), "direction fixture not generated")
  skip_if_not_installed("arrow")
  x <- replay(dir_path, .pbp_add_pass_direction_cols)

  for (nm in c("pass_depth", "pass_direction", "rush_direction", "qb_hurry")) {
    k <- paste0(nm, "__out")
    if (!k %in% names(x$o)) next
    bad <- sum(differs(x$r[[nm]], x$o[[k]][x$r$.row]))
    expect_equal(bad, 0L, info = paste0(nm, ": ", bad, " of ", nrow(x$r)))
  }
})

test_that("depth and direction matching is case-sensitive on purpose", {
  testthat::skip_on_cran()
  # ESPN writes these tokens lowercase mid-sentence. Folding case would let a
  # capitalised player or team name match -- "Wright" contains no whitespace
  # boundary issue, but " Deep " as a proper noun does.
  df <- data.frame(
    play_text = c("A. Smith pass complete deep left to B. Jones",
                  "A. Smith pass complete to Deep Wright"),
    pass = c(1, 1), rush = c(0, 0), stringsAsFactors = FALSE
  )
  out <- .pbp_add_pass_direction_cols(df)
  expect_equal(out$pass_depth, c("deep", NA))
  expect_equal(out$pass_direction, c("left", NA))
})

test_that("the flags gate which direction column is filled", {
  testthat::skip_on_cran()
  # One regex feeds both pass_direction and rush_direction; only the play's own
  # flag decides which one receives it.
  df <- data.frame(
    play_text = c("pass complete short right to B. Jones", "run left for 3 yards"),
    pass = c(1, 0), rush = c(0, 1), stringsAsFactors = FALSE
  )
  out <- .pbp_add_pass_direction_cols(df)
  expect_equal(out$pass_direction, c("right", NA))
  expect_equal(out$rush_direction, c(NA, "left"))
})

test_that("a direction at end-of-string does not match", {
  testthat::skip_on_cran()
  # The pattern requires whitespace on BOTH sides, so a truncated description
  # ending in the direction word yields NA. That is sdv-py's behaviour and it is
  # pinned here because it looks like an off-by-one and is not: real ESPN text
  # always continues past the direction ("short right to B. Jones").
  df <- data.frame(play_text = "pass complete short right",
                   pass = 1, rush = 0, stringsAsFactors = FALSE)
  out <- .pbp_add_pass_direction_cols(df)
  expect_true(is.na(out$pass_direction))
  expect_equal(out$pass_depth, "short")
})

test_that("qb_hurry is FALSE on null text, never NA", {
  testthat::skip_on_cran()
  # It stays a clean boolean so downstream filters and models do not have to
  # special-case a missing description.
  df <- data.frame(play_text = c("QB hurried by #55 T. Jones", "run for 3", NA),
                   pass = c(1, 0, 0), rush = c(0, 1, 0), stringsAsFactors = FALSE)
  out <- .pbp_add_pass_direction_cols(df)
  expect_equal(out$qb_hurry, c(TRUE, FALSE, FALSE))
})
