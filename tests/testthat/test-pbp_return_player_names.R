# Real return plays from game 401752677 (2025 week 1, Texas at Ohio State).
# add_player_cols() extracted the returner into `*_returner_player_name` but left
# the canonical `*_return_player_name` twins -- the names sdv-py, the output
# schema and the id matcher all key on -- as NA on every play.

test_that("add_player_cols() fills the canonical return-player name columns", {
  plays <- data.frame(
    play_type = c("Punt", "Punt", "Kickoff Return (Offense)"),
    play_text = c(
      "Jack Bouwmeester punt for 39 yds, fair catch by Brandon Inniss at the OSU 8",
      "Joe McGuire punt for 43 yds , Ryan Niblett returns for 3 yds to the TEX 29",
      "Jayden Fielding kickoff for 65 yds , Quintrevion Wisner return for 15 yds to the TEX 15"
    ),
    pass = 0, rush = 0, sack = 0, fumble_vec = 0,
    stringsAsFactors = FALSE
  )
  x <- add_player_cols(plays)
  expect_identical(x$punt_return_player_name, c("Brandon Inniss", "Ryan Niblett", NA))
  expect_identical(x$kickoff_return_player_name, c(NA, NA, "Quintrevion Wisner"))
  # the older names stay as they were
  expect_identical(x$punt_returner_player_name, x$punt_return_player_name)
  expect_identical(x$kickoff_returner_player_name, x$kickoff_return_player_name)
})
