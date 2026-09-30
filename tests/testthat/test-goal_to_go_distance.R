# Some feeds send distance = 0 on goal-to-go downs. The EP model was trained on
# sdv-py's ESPN output, which sets them to yards-to-goal (sportsdataverse-py
# cfb_pbp.py, the "start.distance" goal rewrite). Rows below are real: game
# 401752671 (2025 wk 1, LSU at Clemson) from ESPN and CFBD, plus 2019 ESPN
# kickoff and timeout rows that carry distance 0 but are not goal-to-go.

test_that("ESPN goal-to-go downs sent as distance 0 get the yards to the goal", {
  x <- .goal_to_go_distance(
    distance      = c(0, 0, 0, 0, 7, 0, 0, 0),
    down          = c(1, 2, 3, 1, 2, 1, 3, 1),
    yards_to_goal = c(4, 14, 14, 5, 70, 65, 8, 19),
    text = c("1st & Goal at LSU 4", "2nd & 0 at LSU 14", "3rd & 0 at LSU 14",
             "1st & Goal at CLEM 5", "2nd & 7 at LSU 30", NA, NA, "1st & 0 at WYO 19")
  )
  # "Goal" downs fixed, as sdv-py does for the training data. "& 0 at" is
  # ESPN's missing-distance text (a 1st & 0 at the 19 is no goal-to-go), so it
  # stays as sent, matching training; a real 2nd & 7, a kickoff (down 1, no
  # text, at the 65) and a timeout row are untouched.
  expect_identical(x, c(4, 0, 0, 5, 7, 0, 0, 0))
  # An old payload with no text column must not open the gate for kickoffs.
  expect_identical(.goal_to_go_distance(0, 1, 65, text = NA_character_), 0)
})

test_that("games that already send the real distance are unchanged", {
  # 401752677 (Texas at Ohio State) sends goal-to-go distances as-is.
  x <- .goal_to_go_distance(c(6, 4, 2), c(1, 2, 3), c(6, 4, 2),
                            text = c("1st & Goal at TEX 6", "2nd & Goal at TEX 4", "3rd & Goal at TEX 2"))
  expect_identical(x, c(6, 4, 2))
})

test_that("CFBD goal-to-go downs sent as distance 0 are fixed without a text", {
  # CFBD /plays for 401752671: "2nd & Goal at CLEM 4" pass-interference play
  # came as down 2, distance 0, yardsToGoal 4; a normal 1st & 10 alongside.
  # Without a text only the 10 and in qualify: a 1st & 0 at the 25 (an
  # overtime start) is a missing distance, not goal-to-go.
  x <- .goal_to_go_distance(distance = c(0L, 10L, 0L), down = c(2L, 1L, 1L),
                            yards_to_goal = c(4L, 75L, 25L))
  expect_equal(x, c(4, 10, 0))
})

test_that("CFBD and ESPN agree on 401752671's EPA wherever their distances agree", {
  skip_on_cran()
  skip_if(!has_cfbd_key(), "CFBD API key not available")
  # ESPN sends two "Goal" downs of this game as distance 0 and CFBD one; scored
  # raw, those plays and the plays before them (whose end state reads the next
  # play's distance) disagreed on EPA between the sources. ESPN's two "2nd/3rd
  # & 0 at LSU 14" rows stay at 0 by design (see .goal_to_go_distance()), so
  # the comparison keeps plays whose own and next distance match across feeds.
  goal_ids <- c("401752671102945901", "401752671103905201")
  k <- function(d) data.frame(id_play = as.character(d$id_play), EPA = d$EPA,
                              dist = as.numeric(d$distance), nxt = dplyr::lead(as.numeric(d$distance)))
  for (eng in c("v2", "legacy")) {
    e  <- suppressWarnings(suppressMessages(espn_cfb_pbp(game_id = 401752671, epa_wpa = TRUE, engine = eng)))
    cf <- suppressWarnings(suppressMessages(cfbd_pbp_data(year = 2025, week = 1, team = "LSU",
                                                          epa_wpa = TRUE, engine = eng)))
    if (!is.data.frame(e) || !nrow(e) || !is.data.frame(cf) || !nrow(cf)) skip("no plays returned")
    g <- e[as.character(e$id_play) %in% goal_ids, ]
    expect_equal(as.numeric(g$distance), as.numeric(g$yards_to_goal), label = paste("ESPN goal downs,", eng))
    expect_equal(as.numeric(cf$distance[as.character(cf$id_play) == "401752671103909201"]), 4,
                 label = paste("CFBD 2nd & Goal at CLEM 4,", eng))
    j <- merge(k(cf[as.character(cf$game_id) == "401752671", ]), k(e), by = "id_play", suffixes = c(".c", ".e"))
    same <- (j$dist.c == j$dist.e) %in% TRUE &
      ((j$nxt.c == j$nxt.e) %in% TRUE | (is.na(j$nxt.c) & is.na(j$nxt.e)))
    expect_gt(sum(same), 160L)
    expect_equal(j$EPA.c[same], j$EPA.e[same], tolerance = 1e-6, label = paste("CFBD vs ESPN EPA,", eng))
  }
})
