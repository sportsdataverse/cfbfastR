### "punt for a loss of N" is a punt of -N yards (#156), as sdv-py reads it
### (cfb_pbp.py, both `yds_punted` assignments). Every text is a real ESPN punt
### row; 252460252 is Boston College @ BYU, 2005, the game sdv-py's own test uses.

loss_text <- "Johnny Ayers punt for a loss of 12 yards."
gain_text <- "Johnny Ayers punt for 43 yards, downed at the BC 20."

punt_rows <- function(text) {
  data.frame(
    game_id = 1L, id_play = as.character(seq_along(text)),
    play_type = "Punt", play_text = text,
    change_of_poss = 1, change_of_pos_team = 1,
    down = 4, distance = 10, yards_to_goal = 70, yards_gained = 0,
    penalty_1st_conv = FALSE,
    stringsAsFactors = FALSE
  )
}

test_that(".punt_yards signs the loss clause and leaves other punts alone", {
  expect_identical(.punt_yards(c(loss_text, gain_text)), c(-12, 43))
  expect_identical(.punt_yards(toupper(loss_text)), -12) # case-insensitive, as sdv-py
  expect_identical(.punt_yards(NA_character_), NA_real_)
  # edge cases (constructed): the distance must follow "punt for" directly, and
  # a loss on the return must not sign the punt
  expect_identical(.punt_yards("Johnny Ayers Punt for no gain to the BC 20."), NA_real_)
  expect_identical(.punt_yards("A punt for 43 yards, B returned punt for a loss of 5 yards."), 43)
  expect_identical(.punt_yards("A punt for no gain, B returned punt for a loss of 5 yards."), NA_real_)
})

test_that("both engines' clean stage store a punt for a loss as negative", {
  rows <- punt_rows(c(loss_text, gain_text))
  expect_identical(.pbp_clean_pbp_dat(rows, season = 2005)$yds_punted, c(-12, 43))
  expect_identical(clean_pbp_dat(rows)$yds_punted, c(-12, 43))
})

test_that("ESPN game 252460252 publishes the punt for a loss as -12 on both engines", {
  testthat::skip_on_cran()
  testthat::skip_on_ci()
  testthat::skip_if_offline()
  for (eng in c("v2", "legacy")) {
    pbp <- tryCatch(
      suppressWarnings(suppressMessages(
        espn_cfb_pbp(game_id = 252460252, epa_wpa = TRUE, engine = eng)
      )),
      # skip only when the request itself failed; a processing error fails
      error = function(e) {
        if (inherits(e, c("httr2_failure", "httr2_http", "curl_error"))) {
          testthat::skip(paste("ESPN request failed:", conditionMessage(e)))
        }
        stop(e)
      }
    )
    expect_true(is.data.frame(pbp) && nrow(pbp) > 0, label = paste("plays returned,", eng))
    row <- pbp[grepl("punt for a loss of 12", pbp$play_text, fixed = TRUE), ]
    expect_identical(nrow(row), 1L, label = paste("loss row,", eng))
    expect_equal(as.numeric(row$yds_punted), -12, label = paste("yds_punted,", eng))
  }
})
