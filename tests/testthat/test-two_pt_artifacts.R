### Gates for the two-point conversion probability (#140, model-scoring half).
###
### Two traps live in the state construction rather than the model:
###   1. The PAT shares the touchdown's row, so pos_score_diff_start is the
###      PRE-TD margin and must gain 6 -- but only on OFFENSIVE touchdowns,
###      since pass_td also fires on pick-sixes.
###   2. posteam_total is an implied TEAM total split out of the over/under by
###      the spread, and CFBD's spread sign is the negation of the
###      homeTeamSpread the formula is written against.

test_that(".TWO_PT_FEATURES matches the bundle contract and uses ordinal era", {
  expect_identical(.TWO_PT_FEATURES,
                   c("posteam_spread", "posteam_total", "pos_score_diff", "era"))
  # Ordinal era (2017 cut), like xpass -- not the FG model's one-hot set.
  expect_equal(.cfb_era_ordinal(2018, 1), 3)
})

test_that(".cfb_posteam_total splits the over/under by the spread", {
  # Home favoured by 7 (CFBD spread -7), total 50 -> home 28.5, away 21.5.
  df <- data.frame(spread = c(-7, -7), over_under = c(50, 50),
                   pos_team = c("H", "A"), home = c("H", "H"))
  tot <- .cfb_posteam_total(df)
  expect_equal(tot[1], 28.5)
  expect_equal(tot[2], 21.5)
  # The two implied totals must reconstruct the over/under.
  expect_equal(tot[1] + tot[2], 50)
  # And the favourite must carry the larger share.
  expect_gt(tot[1], tot[2])
})

test_that(".cfb_posteam_total handles an away favourite", {
  # CFBD spread +10 means the AWAY team is favoured.
  df <- data.frame(spread = c(10, 10), over_under = c(60, 60),
                   pos_team = c("H", "A"), home = c("H", "H"))
  tot <- .cfb_posteam_total(df)
  expect_equal(tot[1], 25)   # home underdog
  expect_equal(tot[2], 35)   # away favourite
  expect_equal(tot[1] + tot[2], 60)
  expect_gt(tot[2], tot[1])
})

test_that(".cfb_posteam_total returns NULL without a line", {
  expect_null(.cfb_posteam_total(data.frame(pos_team = "A", home = "A")))
  expect_null(.cfb_posteam_total(data.frame(spread = NA_real_, over_under = NA_real_,
                                            pos_team = "A", home = "A")))
})

test_that("the two-point score diff adds 6 on offensive touchdowns only", {
  df <- data.frame(
    pos_score_diff_start = c(-3, -3, -3, -3),
    pass_td            = c(1, 0, 1, 0),
    rush_td            = c(0, 1, 0, 0),
    offense_score_play = c(1, 1, 0, 0)   # row 3 is a pick-six: pass_td but not offensive
  )
  expect_equal(.two_pt_score_diff(df), c(3, 3, -3, -3))
})

test_that("decision rows are offensive touchdowns only", {
  df <- data.frame(
    pass_td            = c(1, 0, 1, 0),
    rush_td            = c(0, 1, 0, 0),
    offense_score_play = c(1, 1, 0, 0)
  )
  expect_equal(.two_pt_decision_rows(df), c(TRUE, TRUE, FALSE, FALSE))
})

test_that("a standalone PAT row is never a decision row (pre-2014 shape)", {
  # Before 2014 the extra point / two-point try is its OWN row rather than
  # sharing the touchdown's. Those rows are already POST-touchdown, so the +6 in
  # .two_pt_score_diff() must never reach them -- it would score the decision six
  # points further ahead than the game actually was.
  #
  # Today that holds only BY CONSTRUCTION: pass_td/rush_td are assigned from an
  # exact play_type match ("Passing Touchdown" / "Rushing Touchdown") in
  # clean_pbp_dat(), so a standalone PAT scores 0 on both and cannot qualify.
  # Nothing else enforces it. Broaden that assignment -- a regex, or folding in
  # "Two-Point Conversion Good" -- and the +6 silently starts firing on already-
  # post-TD rows. This is the test that would notice.
  df <- data.frame(
    play_type          = c("Extra Point Good", "Two-Point Conversion Good",
                           "Extra Point Missed", "Passing Touchdown"),
    pass_td            = c(0, 0, 0, 1),
    rush_td            = c(0, 0, 0, 0),
    # a PAT IS an offensive scoring play, so offense_score_play alone cannot
    # exclude it -- the TD flags are what carry the exclusion
    offense_score_play = c(1, 1, 0, 1)
  )
  expect_equal(.two_pt_decision_rows(df), c(FALSE, FALSE, FALSE, TRUE))
})

test_that("the production TD derivation classifies no PAT play type as a touchdown", {
  # The test above holds only because clean_pbp_dat() assigns pass_td/rush_td from
  # an EXACT play_type match. Comparing PAT literals against touchdown literals
  # here would be tautological -- it would pass no matter what production does.
  # So read the rule out of the SHIPPED function and evaluate PAT types against it:
  # broaden the rule (another play_type, or a switch to a regex) and this fails.
  src <- paste(deparse(body(cfbfastR:::.pbp_clean_pbp_dat)), collapse = " ")

  td_set <- function(flag) {
    i <- regexpr(paste0(flag, " = ifelse"), src, fixed = TRUE)
    expect_true(i > 0,
                info = paste0("no ", flag, " assignment found; if it was restructured",
                              " this guard must be UPDATED, not deleted"))
    rest <- substring(src, i)
    j <- regexpr("%in% ", rest, fixed = TRUE)
    rest <- substring(rest, j + 5L)
    eval(parse(text = substring(rest, 1L, regexpr(")", rest, fixed = TRUE))))
  }

  pat_types <- c("Extra Point Good", "Extra Point Missed",
                 "Two-Point Conversion Good", "Two-Point Conversion Missed")
  for (flag in c("pass_td", "rush_td")) {
    s <- td_set(flag)
    expect_gt(length(s), 0)
    expect_false(any(pat_types %in% s),
                 info = paste(flag, "now treats a PAT play type as a touchdown;",
                              "the +6 in .two_pt_score_diff() would fire on an",
                              "already-post-TD row"))
  }
})

test_that(".pbp_add_two_pt_prob degrades to NA rather than raising", {
  df <- data.frame(pos_score_diff_start = 0, pass_td = 1, rush_td = 0,
                   offense_score_play = 1)
  out <- .pbp_add_two_pt_prob(df, season = 2021)   # no spread/over_under
  expect_true("prob_2pt" %in% names(out))
  expect_true(is.na(out$prob_2pt))
})

test_that(".pbp_add_two_pt_prob needs a season for the era feature", {
  df <- data.frame(pos_score_diff_start = 0, pass_td = 1, rush_td = 0,
                   offense_score_play = 1, spread = -7, over_under = 50,
                   pos_team = "H", home = "H")
  expect_true(is.na(.pbp_add_two_pt_prob(df, season = NULL)$prob_2pt))
})

test_that(".pbp_add_two_pt_prob handles a zero-row frame", {
  df <- data.frame(pos_score_diff_start = numeric(0))
  out <- .pbp_add_two_pt_prob(df, season = 2021)
  expect_equal(nrow(out), 0L)
  expect_true("prob_2pt" %in% names(out))
})

test_that("the published manifest agrees with the two-point contract", {
  skip_on_cran()
  skip_if_offline()
  man <- .cfb_model_manifest()
  skip_if(is.null(man), "cfb_model_artifacts MANIFEST.json unavailable")
  expect_identical(unlist(man$assets$two_pt_model.ubj$features), .TWO_PT_FEATURES)
})

test_that("prob_2pt is a probability, on scoring rows only", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not_installed("xgboost")
  skip_if(is.null(.cfb_two_pt_model()), "bundled two_pt model unavailable")

  df <- data.frame(
    pos_score_diff_start = c(-8, -8, 0),
    pass_td            = c(1, 0, 0),
    rush_td            = c(0, 1, 0),
    offense_score_play = c(1, 1, 0),     # third row is not a score
    spread = -7, over_under = 55,
    pos_team = "H", home = "H"
  )
  out <- .pbp_add_two_pt_prob(df, season = 2021)
  expect_false(is.na(out$prob_2pt[1]))
  expect_false(is.na(out$prob_2pt[2]))
  expect_true(is.na(out$prob_2pt[3]))
  p <- out$prob_2pt[1:2]
  expect_true(all(p >= 0 & p <= 1))
  # CFB two-point conversions succeed well under half the time.
  expect_lt(max(p), 0.75)
})
