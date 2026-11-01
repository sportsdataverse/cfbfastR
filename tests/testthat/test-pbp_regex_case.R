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

test_that("the blocked-punt returner is sdv-py's name and athlete id", {
  testthat::skip_on_cran()
  skip_if_not_installed("arrow")
  path <- testthat::test_path("fixtures", "parity", "game_rosters.parquet")
  skip_if_not(file.exists(path), "game roster fixture not present")
  ros <- as.data.frame(arrow::read_parquet(path))
  ros <- ros[ros$fixture_game_id == 401110806, , drop = FALSE]
  # 401110806 (2019), play 401110806103947001. sdv-py 4b78a45a3d emits
  # punt_block_return_player_name "Ale Kaho" and id 4361090: the capture is
  # "Ale Kaho 0 Yd", and __attach_player_ids cuts the "N Yd" clause before the
  # roster join (the older golden, captured before that cut, says "Ale Kaho 0 Yd").
  r <- add_player_cols(data.frame(
    play_type = "Blocked Punt Touchdown",
    play_text = "Ale Kaho 0 Yd Return of Blocked Punt (Joseph Bulovas Kick)",
    pass = 0, rush = 0, sack = 0, fumble_vec = 0,
    stringsAsFactors = FALSE
  ))
  r$return_team <- "333"
  out <- .pbp_attach_player_ids(r, roster = data.frame(
    athlete_id = as.character(ros$athlete_id), display_name = ros$athlete_display_name,
    team_id = as.character(ros$team_id), stringsAsFactors = FALSE
  ))
  expect_identical(out$punt_block_return_player_name, "Ale Kaho")
  expect_identical(out$punt_block_return_player_id, "4361090")
})

test_that("the clause cut matches sdv-py's _PLAYER_NAME_CLAUSE_CUT on captured names", {
  testthat::skip_on_cran()
  cut <- function(x) .pbp_attach_player_ids(data.frame(fumble_player_name = x,
                                                       stringsAsFactors = FALSE))$fumble_player_name
  # the fragments sdv-py's own comment cites, and the "N Yd" tail
  expect_identical(cut(c("Tommylee Lewistackled b", "Kevonte Martin-Manley for",
                         "Ale Kaho 0 Yd", "to the MiaOh 21", "WAS30", "Russell Wilson")),
                   c("Tommylee Lewis", "Kevonte Martin-Manley", "Ale Kaho", NA, NA, "Russell Wilson"))
})
