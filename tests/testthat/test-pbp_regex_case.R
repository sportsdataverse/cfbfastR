### Play-text literals fold case, as sdv-py's `(?i)` patterns do.
###
### The rows are real ESPN plays (game / play ids given), so a test only goes
### red on text ESPN actually writes. ESPN writes a fumble-return touchdown as
### "N Yd Fumble Return" -- 21-60 such rows a season (2014-2025) that a literal
### "fumble" never flagged.

clean_rows <- function(play_type, play_text, change_of_poss = 0) {
  n <- length(play_type)
  .pbp_clean_pbp_dat(data.frame(
    game_id = 1L, season = 2024L, id_play = as.character(seq_len(n)),
    play_type = play_type, play_text = play_text,
    change_of_poss = change_of_poss, change_of_pos_team = change_of_poss,
    down = 1, distance = 10, yards_to_goal = 75, yards_gained = 0,
    penalty_1st_conv = FALSE,
    stringsAsFactors = FALSE
  ))
}

test_that("a capitalised 'Fumble Return' is a fumble", {
  testthat::skip_on_cran()
  # 400547649 (2014), play 400547649101924501
  out <- clean_rows("Fumble Return Touchdown",
                    "Naim Cheeseboro 0 Yd Fumble Return (Przemyslaw Popek Kick)",
                    change_of_poss = 1)
  expect_equal(out$fumble_vec, 1)
})

test_that("the sack literals fold case (sdv-py C-L16)", {
  testthat::skip_on_cran()
  # 401628334102944601: a sacked-and-recovered fumble. The captures carry no
  # other casing, so this shouts the one word, as sdv-py's own test does.
  txt <- paste(
    "Miller Moss sacked by Sai'vion Jones for a loss of 4 yards to the LSU 24",
    "Miller Moss fumbled, forced by Sai'vion Jones, recovered by USC Emmanuel",
    "Pregnon , return for 0 yards"
  )
  out <- clean_rows("Fumble Recovery (Own)", sub("sacked", "SACKED", txt))
  expect_equal(out$pass, 1)
  expect_equal(out$sack, 1)
  expect_equal(out$completion, 0)
  expect_equal(out$pass_attempt, 0)
  # and a bare "Pass" row reading SACKED becomes a Sack
  expect_equal(clean_rows("Pass", "Jalen Milroe SACKED by Joe Smith for a loss of 5 yards")$play_type,
               "Sack")
})

test_that("the blocked-punt returner matches sdv-py on 'Return of Blocked Punt'", {
  testthat::skip_on_cran()
  skip_if_not_installed("arrow")
  path <- testthat::test_path("fixtures", "parity", "sdvpy_golden.parquet")
  skip_if_not(file.exists(path), "sdv-py golden fixture not present")
  g <- as.data.frame(arrow::read_parquet(path))
  g <- g[grepl("Punt", g[["type.text"]]) & !is.na(g$text), , drop = FALSE]
  r <- add_player_cols(data.frame(
    play_type = g[["type.text"]], play_text = g$text,
    pass = 0, rush = 0, sack = 0, fumble_vec = 0,
    stringsAsFactors = FALSE
  ))
  # The golden carries one such row (2019, "Ale Kaho 0 Yd Return of Blocked
  # Punt"). Only the rows the case fold decides are compared: the lower-case
  # "blocked ... returned" rows parse the same before and after, and one of
  # them (a fumbled block, "recovered by ... returned for 4 yds") already
  # differs from sdv-py for a reason unrelated to case.
  rows <- !(grepl("blocked", g$text) & grepl("return", g$text))
  expect_true(any(grepl("Return of Blocked Punt", g$text[rows])))
  expect_identical(r$punt_block_return_player_name[rows], g$punt_block_return_player_name[rows])
  expect_identical(r$punt_block_return_player_name[grepl("Return of Blocked Punt", g$text)], "Ale Kaho 0 Yd")
})
