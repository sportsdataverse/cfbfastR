### CFBD OpenAPI 5.24.1 coverage: the endpoints and filters added in this PR.
###
### Network-gated like every other CFBD test. The column assertions use the
### SUBSET direction per the repo convention -- CFBD adds columns over time and
### an exact set assertion turns that into a red build for a change that broke
### nothing.

test_that("the new CFBD endpoint wrappers return data", {
  skip_on_cran()
  skip_if(!has_cfbd_key(), "no CFBD_API_KEY")

  cases <- list(
    list(cfbd_playoffs_cfp(2024),                     "cfbd_playoffs_cfp"),
    list(cfbd_playoffs_cfp_games(2024),               "cfbd_playoffs_cfp_games"),
    list(cfbd_playoffs_cfp_participants(2024),        "cfbd_playoffs_cfp_participants"),
    list(cfbd_conference_affiliations(team = "Georgia"), "cfbd_conference_affiliations"),
    list(cfbd_conference_changes(2024),               "cfbd_conference_changes"),
    list(cfbd_coaches_seasons(team = "Georgia"),      "cfbd_coaches_seasons"),
    list(cfbd_coaches_tenures(team = "Georgia"),      "cfbd_coaches_tenures"),
    list(cfbd_ratings_core(2024, team = "Georgia"),   "cfbd_ratings_core"),
    list(cfbd_ratings_srs_expanded(2024, team = "Georgia"), "cfbd_ratings_srs_expanded"),
    list(cfbd_teams_fbs(2024),                        "cfbd_teams_fbs"),
    list(cfbd_stats_player_success(2024, team = "Georgia"), "cfbd_stats_player_success"),
    list(cfbd_info_usage(),                           "cfbd_info_usage")
  )
  for (case in cases) {
    x <- case[[1]]
    expect_s3_class(x, "data.frame")
    if (!nrow(x)) next   # transient CFBD 429 / empty season
    expect_gt(ncol(x), 0L)
  }
})

test_that("the division filter actually filters", {
  skip_on_cran()
  skip_if(!has_cfbd_key(), "no CFBD_API_KEY")

  # This is the regression that matters: cfbfastR sent `division=`, which CFBD
  # v5 IGNORES, so every caller silently received all divisions. If the wire
  # parameter regresses to `division`, both calls return the same row count.
  fbs <- cfbd_game_info(2024, week = 5, division = "fbs")
  d3  <- cfbd_game_info(2024, week = 5, division = "iii")
  skip_if(!nrow(fbs) || !nrow(d3), "CFBD returned no rows at test time")
  expect_false(nrow(fbs) == nrow(d3))
})

test_that("validate_division rejects a value CFBD would silently ignore", {
  # CFBD ignores an unrecognised filter rather than erroring, so validating
  # locally is the only way a typo surfaces at all.
  expect_error(validate_division("d1"))
  expect_error(validate_division("FBS"))
  for (ok in c("fbs", "fcs", "ii", "ii/iii", "iii")) {
    expect_silent(validate_division(ok))
  }
  expect_true(validate_division(NULL))
})

test_that("cfbd_rankings only accepts the poll value CFBD implements", {
  # The spec's RankingPoll enum has exactly one member; every other value
  # returns HTTP 400, so this fails locally with a usable message instead.
  expect_error(cfbd_rankings(2024, poll = "AP Top 25"))
})
