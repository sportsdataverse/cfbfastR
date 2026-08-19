### The ESPN play-by-play sidecar: full athlete names + the box-score identity
### source. Ports sdv-py's `_download_athlete_lookup` and
### `CFBPlayProcess.__boxscore_records`.
###
### Everything here is offline. The one network path (`.espn_cfb_pbp_sidecar()`
### against a real game) is covered by test-espn_cfb_pbp_v2.R, which is already
### gated; what matters here is that the parsing and the degradation are right.

test_that("a missing sidecar degrades to empty frames, never an error", {
  s <- .espn_cfb_pbp_sidecar(NULL)
  # An unavailable sidecar must mean "no extra identity source", so a game whose
  # payload 404s still returns play-by-play instead of aborting the call.
  expect_named(s, c("names", "records"))
  expect_equal(nrow(s$names), 0L)
  expect_equal(nrow(s$records), 0L)
  expect_equal(names(s$records), c("athlete_id", "display_name", "team_id"))
})

test_that("participant names expand from short to full form by id", {
  parts <- data.frame(
    play_id                = c("1", "2", "3"),
    rusher_player_name     = c("J. Mitchell", "K. Cumby", "Z. Unknown"),
    rusher_player_id       = c("4428030", "4427003", "9999999"),
    receiver_player_name   = c("Tr. Jones", NA_character_, NA_character_),
    receiver_player_id     = c("4428961", NA_character_, NA_character_),
    stringsAsFactors = FALSE
  )
  lookup <- data.frame(
    athlete_id   = c("4428030", "4427003", "4428961"),
    display_name = c("Jalen Mitchell", "Kyron Cumby", "Tremel Jones"),
    stringsAsFactors = FALSE
  )
  out <- .espn_cfb_expand_participant_names(parts, lookup)

  expect_equal(out$rusher_player_name,
               c("Jalen Mitchell", "Kyron Cumby", "Z. Unknown"))
  expect_equal(out$receiver_player_name, c("Tremel Jones", NA, NA))
  # An id the lookup misses keeps its short name. Nulling it would trade a
  # usable key for none at all.
  expect_equal(out$rusher_player_name[3], "Z. Unknown")
})

test_that("expansion is a no-op without a lookup or without id columns", {
  parts <- data.frame(play_id = "1", rusher_player_name = "J. Mitchell",
                      stringsAsFactors = FALSE)
  empty <- data.frame(athlete_id = character(0), display_name = character(0),
                      stringsAsFactors = FALSE)

  expect_equal(.espn_cfb_expand_participant_names(parts, empty), parts)
  # No `rusher_player_id` to key on -- the name must survive untouched rather
  # than being matched by position against an unrelated lookup.
  expect_equal(
    .espn_cfb_expand_participant_names(
      parts,
      data.frame(athlete_id = "1", display_name = "Someone Else",
                 stringsAsFactors = FALSE)
    ),
    parts
  )
})

test_that("the box-score records are shaped for the id resolver", {
  # `.pbp_attach_player_ids()` reads a roster by these three column names, so a
  # rename upstream would silently disable the second identity source rather
  # than fail.
  s <- .espn_cfb_pbp_sidecar(NULL)
  expect_true(all(c("athlete_id", "display_name", "team_id") %in%
                    names(s$records)))
})

test_that("the sidecar helper is registered for caching", {
  # It is fetched twice per espn_cfb_pbp_v2() call (names, then identity
  # records) and once per game in a season sweep. Falling out of this list turns
  # one request into many without failing anything.
  expect_true(".espn_cfb_pbp_sidecar" %in% .espn_memoised_helpers)
  # And every entry must be a real function, or .onLoad()'s get() aborts load.
  for (fn in .espn_memoised_helpers) {
    expect_true(is.function(get(fn, envir = rlang::ns_env("cfbfastR"))))
  }
})

test_that("resolve_names rejects a non-scalar-logical", {
  expect_error(espn_cfb_pbp_v2(1, resolve_names = "yes"), "must be a single")
  expect_error(espn_cfb_pbp_v2(1, resolve_names = NA), "must be a single")
  expect_error(espn_cfb_pbp_v2(1, resolve_names = c(TRUE, TRUE)),
               "must be a single")
})

### corrupt_pbp_check -- ported from sdv-py's CFBPlayProcess.corrupt_pbp_check.

test_that("an empty play feed is always rejected", {
  # Zero plays is malformed at any point in a game, so this rule does not wait
  # for the completed flag.
  empty <- data.frame(type_text = character(0), stringsAsFactors = FALSE)
  expect_true(.pbp_corrupt_check(empty, completed = TRUE))
  expect_true(.pbp_corrupt_check(empty, completed = FALSE))
  expect_true(.pbp_corrupt_check(empty, completed = NA))
  expect_true(.pbp_corrupt_check(NULL))
})

test_that("the count rules only apply to a completed game", {
  short <- data.frame(x = seq_len(12))
  long  <- data.frame(x = seq_len(600))
  ok    <- data.frame(x = seq_len(160))

  # A game in progress legitimately has few plays; rejecting it would turn a
  # live feed into an error.
  expect_false(.pbp_corrupt_check(short, completed = FALSE))
  expect_false(.pbp_corrupt_check(short, completed = NA))
  expect_true(.pbp_corrupt_check(short, completed = TRUE))
  expect_true(.pbp_corrupt_check(long, completed = TRUE))
  expect_false(.pbp_corrupt_check(ok, completed = TRUE))
})

test_that("the boundaries are exactly 50 and 500", {
  # A truncated game models cleanly and looks reasonable, so the thresholds are
  # the only thing standing between a broken feed and a published one.
  expect_true(.pbp_corrupt_check(data.frame(x = seq_len(49)), completed = TRUE))
  expect_false(.pbp_corrupt_check(data.frame(x = seq_len(50)), completed = TRUE))
  expect_false(.pbp_corrupt_check(data.frame(x = seq_len(500)), completed = TRUE))
  expect_true(.pbp_corrupt_check(data.frame(x = seq_len(501)), completed = TRUE))
})
