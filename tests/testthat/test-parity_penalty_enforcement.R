### Parity oracle: sdv-py CFBPlayProcess.__setup_penalty_data -> penalty_enforcement()
###
### The golden fixture is 60 games -- 5 from each of 2004, 2006, 2008, 2010,
### 2013, 2014, 2017, 2019, 2020, 2021, 2023 and 2025 -- spread across each
### season including the postseason, generated OFFLINE from the committed raw
### ESPN JSON in cfbfastR-cfb-raw (zero API calls; see
### tests/testthat/fixtures/parity/fixture_games.json for the ids).
###
### The season list straddles 2014 on purpose: before it ESPN ships no
### structured participants[] array, so the pre-2014 games exercise the
### text-only parsing path the post-2014 games never reach.

fixture_path <- testthat::test_path("fixtures", "parity", "sdvpy_golden.parquet")

skip_if_no_fixture <- function() {
  testthat::skip_if_not(file.exists(fixture_path), "parity golden fixture not generated")
  testthat::skip_if_not_installed("arrow")
}

read_golden <- function() {
  arrow::read_parquet(fixture_path) |> as.data.frame()
}

# The R side takes `play_text`; sdv-py emits the same string as `text`.
#
# `.row` is not decoration. penalty_detection() drops rows with NA play text (4
# of the 9,549 in the oracle), so comparing by position silently comes apart
# from the first dropped row onward and reports a whole-column divergence that
# is really an off-by-four. Join, never zip.
as_r_input <- function(g) {
  data.frame(
    .row      = seq_len(nrow(g)),
    game_id   = g$game_id,
    play_text = g$text,
    play_type = g$play_type,
    period    = g$period,
    down      = g$down,
    stringsAsFactors = FALSE
  )
}

# Run the R side and re-align it to the oracle on `.row`.
paired <- function(g) {
  r <- as_r_input(g) |> penalty_detection() |> penalty_enforcement()
  merge(r, transform(g, .row = seq_len(nrow(g))), by = ".row", suffixes = c(".r", ".py"))
}

expect_col_parity <- function(m, nm) {
  a <- m[[paste0(nm, ".r")]]
  b <- m[[paste0(nm, ".py")]]
  testthat::expect_equal(a, b, info = nm)
}

test_that("penalty flags match sdv-py on the 60-game oracle", {
  skip_if_no_fixture()
  m <- paired(read_golden())

  # These are the flags both sides claim to compute identically. A mismatch here
  # is a parsing divergence, not a modelling choice.
  for (nm in c("penalty_flag", "penalty_declined", "penalty_no_play", "penalty_offset")) {
    expect_col_parity(m, nm)
  }
})

test_that("penalty enforcement classes match sdv-py", {
  skip_if_no_fixture()
  m <- paired(read_golden())

  for (nm in c("penalty_count", "penalty_declined_count", "penalty_all_declined",
               "penalty_enforcement", "penalty_negated_play")) {
    expect_col_parity(m, nm)
  }
})

test_that("an unknown enforcement class stays NA rather than collapsing to FALSE", {
  skip_if_no_fixture()
  m <- paired(read_golden())

  unk <- !is.na(m$penalty_enforcement.r) & m$penalty_enforcement.r == "unknown"
  skip_if(!any(unk), "no unknown-class penalties in the oracle")
  # The whole point of the NA: a caller must not be able to read
  # "we cannot tell" as "the play counted".
  expect_true(all(is.na(m$penalty_negated_play.r[unk])))
})

test_that("every fixture season is represented in the oracle", {
  skip_if_no_fixture()
  g <- read_golden()
  expect_setequal(
    sort(unique(g$season)),
    c(2004, 2006, 2008, 2010, 2013, 2014, 2017, 2019, 2020, 2021, 2023, 2025)
  )
})
