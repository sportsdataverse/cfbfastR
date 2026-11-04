# pos_score_pts is the points scored on the play, signed for the possessing team
# (cfbfastR-data#15, mirroring sportsdataverse-py#1089), not the running margin's move.

test_that(".pos_score_pts counts offensive, defensive and safety scores per play", {
  # home TD + PAT across two rows, away pick-six while home has the ball, home safety
  # while away has the ball
  home <- c(0, 6, 7, 7, 7, 9)
  away <- c(0, 0, 0, 0, 6, 6)
  pos_home <- c(TRUE, TRUE, TRUE, TRUE, TRUE, FALSE)
  expect_identical(.pos_score_pts(home, away, pos_home), c(0, 6, 1, 0, -6, -2))
})

test_that(".pos_score_pts ignores a feed score that drops to 0 and comes back", {
  # the -70 of cfbfastR-data#15: the running margin moved 35 -> 0 -> 35
  home <- c(35, 0, 0, 35, 42)
  away <- c(0, 0, 0, 0, 0)
  got <- .pos_score_pts(home, away, rep(FALSE, 5))
  expect_identical(got, c(-35, 0, 0, 0, -7))
  expect_true(all(abs(got[-1]) <= 8))
})

test_that(".pos_score_pts treats a missing score as unchanged and NA possession as away", {
  expect_identical(.pos_score_pts(c(NA, 3, NA, 3), c(0, 0, 0, 7), c(NA, TRUE, TRUE, NA)),
                   c(0, 3, 0, 7))
})
