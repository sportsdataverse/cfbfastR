skip_on_cran()

# fixtures/parity/play_order_oracle.csv.gz holds, among its games, all 17 2004-26 games
# where sdv-py's _place_out_of_scheme_plays fires: a play filed under a 10-digit
# <game_id>0 id among the feed's 18-digit ids, which the id sort makes the game's first row.
stray_games <- c("400547832", "400548110", "400763412", "400869342", "401128715", "401234599",
                 "401282633", "401403861", "401403866", "401403981", "401415210", "401420836",
                 "401425418", "401426533", "401426536", "401426538", "401525858")
oracle <- utils::read.csv(test_path("fixtures", "parity", "play_order_oracle.csv.gz"),
                          colClasses = "character", na.strings = "")
oracle <- oracle[oracle$game_id %in% stray_games, ]
games <- lapply(split(oracle, oracle$game_id), function(d) d[order(as.integer(d$row)), ])
r_order <- function(d) {
  d$id[.espn_play_order(d$id, d$sequence, d$period, d$clock, d$drive_id, d$type,
                        d$start_text, d$end_text, d$season, d$home_score, d$away_score)]
}

test_that("a play id outside the feed's numbering goes where sdv-py puts it", {
  expect_setequal(names(games), stray_games)
  bad <- Filter(Negate(is.null), lapply(games, function(d) {
    if (!identical(r_order(d), d$id[order(as.integer(d$sdvpy_rank))])) d$game_id[1]
  }))
  expect_identical(unlist(bad), NULL)
})

test_that("the stray follows the last play before it, the feed breaking a clock tie", {
  around <- function(g, id) {
    o <- r_order(games[[g]])
    o[match(id, o) + c(-1L, 1L)]
  }
  # 400548110: WMU's 9:41 personal foul is filed after the 9:41 touchdown pass and before
  # Idaho's 9:41 rush; on the clock tie the feed decides
  expect_identical(around("400548110", "4005481100"), c("400548110102905801", "400548110102905804"))
  # 401420836: the 11:58 rush (ending at the Drake 47) follows the 13:23 pass to the Drake 47,
  # not a count of the plays clocked before it -- its 11:58 twin sits among the 14:43 plays
  expect_identical(around("401420836", "4014208360"), c("401420836102867603", "401420836102886901"))
})
