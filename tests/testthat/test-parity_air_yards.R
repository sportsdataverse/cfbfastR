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

# sdv-py's catch-point pattern is `(?:caught at|thrown to) ([A-Za-z]+)\\d{1,2}`
# with no article, so it matches "caught at OU35" and MISSES "thrown to the
# ARK30". Both forms occur in ESPN's own text. This port accepts the article, so
# it is a DELIBERATE divergence, not a parity failure -- and the assertions are
# partitioned to say exactly that rather than bug-matching a pattern that drops
# real plays. Measured 2026-08-19: 137 oracle rows use the bare form, 7 more use
# the article form.
py_form <- function(txt) {
  grepl("(?:caught at|thrown to) [A-Za-z]+[0-9]{1,2}", txt, perl = TRUE)
}

test_that("air yards match sdv-py on every row sdv-py resolves", {
  skip_if_not(file.exists(air_path), "air-yards fixture not generated")
  skip_if_not_installed("arrow")
  x <- replay(air_path, .pbp_add_air_yards_cols)
  keep <- py_form(x$o$text[x$r$.row])

  for (nm in c("air_yardsToEndzone", "air_yards", "yards_after_catch")) {
    bad <- sum(differs(x$r[[nm]][keep], x$o[[paste0(nm, "__out")]][x$r$.row][keep]))
    expect_equal(bad, 0L, info = paste0(nm, ": ", bad, " of ", sum(keep)))
  }
})

test_that("the article form recovers catch points sdv-py drops", {
  skip_if_not(file.exists(air_path), "air-yards fixture not generated")
  skip_if_not_installed("arrow")
  x <- replay(air_path, .pbp_add_air_yards_cols)
  txt <- x$o$text[x$r$.row]
  extra <- !py_form(txt) &
    grepl("(?:caught at|thrown to) the [A-Za-z]+[0-9]{1,2}", txt, perl = TRUE)

  expect_gt(sum(extra), 0L)
  # sdv-py resolves none of these; this port resolves at least some. The rest
  # fail on the team abbreviation, not the pattern -- ESPN writes "TTU" in the
  # text where the payload carries "TNTC", which no prefix match can bridge.
  expect_true(all(is.na(x$o$air_yardsToEndzone__out[x$r$.row][extra])))
  expect_gt(sum(!is.na(x$r$air_yardsToEndzone[extra])), 0L)
})

test_that("the air-yards oracle is not degenerate", {
  skip_if_not(file.exists(air_path), "air-yards fixture not generated")
  skip_if_not_installed("arrow")
  o <- as.data.frame(arrow::read_parquet(air_path))

  # A column that is all-NA in the oracle cannot fail a comparison, so the test
  # above would pass on a stub. Both sides of the field must be represented too
  # -- the whole point of the stage is siding the catch abbreviation, and an
  # oracle with only one side would not test it.
  # Measured 2026-08-19 over 9,545 plays: 137 air_yards, 95 yards_after_catch,
  # 69 distinct catch points. Thin because ESPN only annotates the catch point
  # ("caught at OU35") on recent seasons -- most of the 2004-2013 fixture games
  # contribute nothing here, which is a property of the source, not a gap in
  # the port.
  expect_gt(sum(!is.na(o$air_yards__out)), 100L)
  expect_gt(sum(!is.na(o$yards_after_catch__out)), 50L)
  expect_gt(length(unique(stats::na.omit(o$air_yardsToEndzone__out))), 20L)
})

test_that("the catch point is sided against the right team", {
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

test_that("pass depth, direction and the hurry flag match sdv-py", {
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
  # It stays a clean boolean so downstream filters and models do not have to
  # special-case a missing description.
  df <- data.frame(play_text = c("QB hurried by #55 T. Jones", "run for 3", NA),
                   pass = c(1, 0, 0), rush = c(0, 1, 0), stringsAsFactors = FALSE)
  out <- .pbp_add_pass_direction_cols(df)
  expect_equal(out$qb_hurry, c(TRUE, FALSE, FALSE))
})
