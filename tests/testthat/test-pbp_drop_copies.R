test_that(".espn_play_copies() drops ESPN's play copies as sdv-py does", {
  # fixtures/parity/copies_oracle.csv.gz: the frame sdv-py hands
  # _drop_espn_play_copies() for 17 games (in that order), whether sdv-py drops
  # each row there or in the adjacent-copy rule after it, and the type a stub
  # echo leaves on the play it repeats. Offline; see fixtures/parity/README.md.
  o <- utils::read.csv(test_path("fixtures", "parity", "copies_oracle.csv.gz"),
                       colClasses = "character", na.strings = "")
  got <- do.call(rbind, lapply(split(o, factor(o$game_id, unique(o$game_id))), function(d) {
    d <- d[order(as.integer(d$row)), ]
    cp <- .espn_play_copies(d$type, d$text, d$drive_id, as.integer(d$period), d$start_team,
                            as.integer(d$start_down), as.integer(d$start_distance),
                            as.integer(d$start_ytg), d$clock, d$id)
    type <- d$type
    type[cp$retype] <- type[which(cp$retype) + 1L]
    data.frame(drop = cp$drop, type = type)
  }))
  expect_identical(got$drop, o$sdvpy_drop == "True")
  kept <- o$sdvpy_drop != "True"
  expect_identical(got$type[kept], o$sdvpy_type[kept])
  expect_gte(sum(o$sdvpy_drop == "True"), 100L)
})
