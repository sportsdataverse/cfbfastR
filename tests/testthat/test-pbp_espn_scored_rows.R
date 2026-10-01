test_that("v2 books the scores ESPN marks and drops its copies and admin rows, as sdv-py does", {
  skip_on_cran()
  skip_on_ci()
  pbp <- function(g) {
    x <- suppressWarnings(suppressMessages(espn_cfb_pbp(g, epa_wpa = TRUE, output = "full")))
    if (!is.data.frame(x) || !nrow(x) || !("EPA" %in% names(x))) skip(paste("no modeled play-by-play for", g))
    x
  }
  row <- function(x, id) x[as.character(x$id_play) == id, ]

  # a pick-six on a scoreboard frozen at 28-20, and a 2014+ fumble return closed by the kick:
  # the defence's touchdown, not the model's end state
  r <- row(pbp(282640084), "282640084110")
  expect_equal(c(r$play_type, r$ep_after), c("Interception Return Touchdown", "-7"))
  r <- row(pbp(401234617), "401234617102878701")
  expect_equal(r$play_type, "Fumble Recovery (Opponent) Touchdown")
  expect_equal(r$EPA, -7 - r$ep_before)

  # a kickoff return touchdown is the receiver's 7 (the taxonomy filed it on both sides, and
  # the defence's -7 won), at the end of a game too (Miami's eight-lateral return at Duke)
  r <- row(pbp(401403859), "401403859103855202")
  expect_equal(c(r$play_type, r$ep_after), c("Kickoff Return Touchdown", "7"))
  r <- row(pbp(400756970), "400756970104999901")
  expect_equal(c(r$play_type, r$ep_after), c("Kickoff Return Touchdown", "7"))

  # textless copies of eleven punts and sacks go; the plays stay
  g <- pbp(401403886)
  expect_equal(nrow(row(g, "401403886101928402")), 0)
  expect_equal(nrow(row(g, "401403886101929001")), 1)

  # "(Sean O'Haire Kick)" alone and untyped is not a play, and its touchdown stays before its kickoff
  g <- pbp(401752914)
  expect_equal(nrow(row(g, "401752914786")), 0)
  i <- which(as.character(g$id_play) == "401752914787")
  expect_equal(as.character(g$id_play[i + 1]), "401752914738")
})
