test_that(".espn_play_order() orders plays as sdv-py does", {
  # fixtures/parity/play_order_oracle.csv.gz: raw ESPN plays for 45 games chosen to
  # exercise each repair (late inserts, drive reunite, tries filed after the kickoff,
  # overtime, duplicate ids), with the rank sdv-py's _sort_plays_ot_aware() gives
  # every row. Offline; see fixtures/parity/README.md for the commit.
  oracle <- utils::read.csv(test_path("fixtures", "parity", "play_order_oracle.csv.gz"),
                            colClasses = "character", na.strings = "")
  bad <- Filter(Negate(is.null), lapply(split(oracle, oracle$game_id), function(d) {
    d <- d[order(as.integer(d$row)), ]
    got <- .espn_play_order(d$id, d$sequence, d$period, d$clock, d$drive_id, d$type,
                            d$start_text, d$end_text, d$season, d$home_score, d$away_score)
    want <- order(as.integer(d$sdvpy_rank))
    if (!identical(as.integer(got), want)) d$game_id[1]
  }))
  expect_identical(unlist(bad), NULL)
  # the fixture must be one plain id order gets wrong, or it proves nothing
  moved <- vapply(split(oracle, oracle$game_id), function(d) {
    d <- d[order(as.integer(d$row)), ]
    !identical(order(nchar(d$id), d$id, method = "radix"), order(as.integer(d$sdvpy_rank)))
  }, logical(1))
  expect_gte(sum(moved), 30L)
})

test_that(".pbp_ensure_play_order() falls back to exact id order", {
  # 18-digit ids sit past 2^53, where as.numeric() can no longer tell them apart
  df <- data.frame(game_id = 1, id_play = c("401635534101849911", "401635534101849902", "4016355341018499"))
  expect_identical(.pbp_ensure_play_order(df)$play_order, c(3L, 2L, 1L))
  # numeric ids: as.character(4e17) is "4e+17", which would sort by its length
  num <- data.frame(game_id = 1, id_play = c(4e17, 39e16 + 1))
  expect_identical(.pbp_ensure_play_order(num)$play_order, c(2L, 1L))
  df$play_order <- c(1L, 2L, 3L)
  expect_identical(.pbp_ensure_play_order(df)$play_order, c(1L, 2L, 3L))
})
