test_that("v2 books period boundaries as sdv-py does", {
  skip_on_cran()
  skip_on_ci()
  pbp <- function(g) {
    x <- suppressWarnings(suppressMessages(espn_cfb_pbp(g, epa_wpa = TRUE, output = "full")))
    if (!is.data.frame(x) || !nrow(x) || !("EPA" %in% names(x))) skip(paste("no modeled play-by-play for", g))
    x
  }
  row <- function(x, id) x[as.character(x$id_play) == id, ]
  # the next real play's ep_before, markers and timeouts skipped
  next_ep <- function(x, id) {
    i <- which(as.character(x$id_play) == id)
    j <- i + which(!(x$play_type[-seq_len(i)] %in% c("End Period", "End of Half", "End of Game", "Timeout")))[1]
    x$ep_before[j]
  }

  # 400547699: the game's last play ends it (nothing follows: ep_after 0, EPA -ep_before); the
  # play before it, whose NEXT snap is at 0:00, does not (it was booked -ep_before)
  g <- pbp(400547699)
  last <- row(g, "400547699104999901")
  expect_equal(last$end_of_half, 1)
  expect_equal(last$ep_after, 0)
  expect_equal(last$EPA, -last$ep_before)
  expect_gt(last$ep_before, 0)                       # a 0:00 snap keeps its EP
  prev <- row(g, "400547699104996901")
  expect_equal(prev$end_of_half, 0)
  expect_equal(prev$EPA, prev$ep_after - prev$ep_before)
  expect_true(all(g$EPA[g$play_type %in% "Timeout"] == 0))

  # 400787460: a kickoff with 0:05 left in the first quarter, then "End of 1st Quarter": its
  # result is the receiving team's first snap of the second quarter, not the marker's state
  t <- pbp(400787460)
  ko <- row(t, "400787460101999403")
  expect_equal(ko$ep_after, next_ep(t, "400787460101999403"), tolerance = 1e-6)
  # "on-side kick recovered by TROY", typed a plain Kickoff: the kicking team keeps the ball
  onside <- row(t, "400787460103849901")
  expect_equal(onside$ep_after, -next_ep(t, "400787460103849901"), tolerance = 1e-6)
  # ...and goes to overtime: regulation's last play ends the possession (overtime starts a
  # fresh one), while an overtime snap does not end anything (every one was booked -EP)
  reg_end <- row(t, "400787460104998501")
  expect_equal(c(reg_end$end_of_half, reg_end$ep_after), c(1, 0))
  ot <- t[t$period >= 5 & !(t$play_type %in% c("End Period", "End of Half", "End of Game", "End of Regulation")), ]
  expect_equal(sum(ot$end_of_half), 1)
  expect_equal(ot$end_of_half[nrow(ot)], 1)

  # 400547730: a punt before "End of 3rd Quarter" hands the ball over at the next snap
  u <- pbp(400547730)
  punt <- row(u, "400547730103999901")
  expect_equal(punt$ep_after, -next_ep(u, "400547730103999901"), tolerance = 1e-6)
})
