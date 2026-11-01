### kickoff_tb follows sdv-py's three rules (cfb_pbp.py, the `kickoff_tb` block):
### the text says touchback; from 2018 a fair catch (the NCAA's fair-caught
### kickoff is spotted at the 25, `CFB_KICKOFF_FAIR_CATCH_TOUCHBACK_FROM`); or
### the row is a bare "X kickoff" with no result. Every text is a real ESPN
### kickoff row (game ids given).

kickoff_tb <- function(text, season) {
  .pbp_clean_pbp_dat(data.frame(
    game_id = 1L, id_play = as.character(seq_along(text)),
    play_type = "Kickoff", play_text = text,
    change_of_poss = 0, change_of_pos_team = 0,
    down = 1, distance = 10, yards_to_goal = 65, yards_gained = 0,
    penalty_1st_conv = FALSE,
    stringsAsFactors = FALSE
  ), season = season)$kickoff_tb
}

test_that("the fair-catch rule is sdv-py's season constant", {
  expect_identical(.KICKOFF_FAIR_CATCH_TOUCHBACK_FROM, 2018)
  expect_false(.kickoff_fair_catch_touchback(2017))
  expect_true(.kickoff_fair_catch_touchback(2018))
  expect_true(.kickoff_fair_catch_touchback(NA))
})

test_that("a fair-caught kickoff is a touchback from 2018, not before", {
  testthat::skip_on_cran()
  # 401752773 (2025)
  modern <- "(15:00) #31 C.Talty kickoff 61 yards to the EIU04 fair catch by #1 J.Pearson at EIU04"
  # 262692116 (2006)
  old <- "Britt Barefoot kickoff for 41 yards fair catch by Shane Smith at the UCF 24."
  expect_equal(kickoff_tb(modern, 2025), 1)
  expect_equal(kickoff_tb(old, 2006), 0)
  # the season, not the text, decides
  expect_equal(kickoff_tb(old, 2018), 1)
  expect_equal(kickoff_tb(modern, 2017), 0)
  # the season column is read when no season is passed
  df <- data.frame(game_id = 1L, season = 2006L, id_play = "1", play_type = "Kickoff",
                   play_text = old, change_of_poss = 0, change_of_pos_team = 0,
                   down = 1, distance = 10, yards_to_goal = 65, yards_gained = 0,
                   penalty_1st_conv = FALSE, stringsAsFactors = FALSE)
  expect_equal(.pbp_clean_pbp_dat(df)$kickoff_tb, 0)
})

test_that("a bare 'X kickoff' row is a touchback; a returned kick is not", {
  testthat::skip_on_cran()
  # 400547961 (2014), 401762464 (2025)
  expect_equal(kickoff_tb(c("Cody Clark kickoff", "Byron McCann kickoff"), 2014), c(1, 1))
  # 401752665 (2025): a return
  expect_equal(kickoff_tb("Conor Talty kickoff for 65 yds , Samuel Singleton Jr. return for 15 yds to the FSU 15", 2025), 0)
  # 262692116 (2006): a return
  expect_equal(kickoff_tb("Britt Barefoot kickoff for 65 yards returned by Curtis Francis for 41 yards to the UCF 41.", 2006), 0)
  # 401752665 (2025): an explicit touchback
  expect_equal(kickoff_tb("Jake Weinberg kickoff for 65 yds for a touchback", 2025), 1)
})
