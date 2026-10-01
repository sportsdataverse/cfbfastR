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

test_that(".espn_drop_play_copies() drops copies from a Core-v2 frame in any row order", {
  # the adapter's wrapper: Core-v2 column names, rows in feed order (shuffled
  # here), copies dropped by play, the frame's own row order kept, a stub echo's
  # type moved with its id and abbreviation. 401752854 carries every copy kind.
  o <- utils::read.csv(test_path("fixtures", "parity", "copies_oracle.csv.gz"),
                       colClasses = "character", na.strings = "")
  d <- o[o$game_id == "401752854", ]
  d <- d[order(as.integer(d$row)), ]
  # replayed in sdv-py's order, or this proves nothing about the wrapper
  expect_identical(as.integer(.espn_play_order(d$id, d$sequence, d$period, d$clock, d$drive_id, d$type,
                                               d$start_text, d$end_text, 2025, d$home_score, d$away_score)),
                   seq_len(nrow(d)))
  df <- data.frame(
    tag = d$row, play_id = d$id, sequence_number = d$sequence, period = as.integer(d$period),
    clock = d$clock, drive_drive_id = d$drive_id, type_text = d$type,
    type_id = paste0("id:", d$type), type_abbreviation = paste0("ab:", d$type),
    start_down_distance_text = d$start_text, end_down_distance_text = d$end_text,
    home_score = d$home_score, away_score = d$away_score, text = d$text,
    start_team_id = d$start_team, start_down = as.integer(d$start_down),
    start_distance = as.integer(d$start_distance), start_yards_to_endzone = as.integer(d$start_ytg)
  )
  set.seed(9)
  df <- df[sample(nrow(df)), ]
  out <- .espn_drop_play_copies(df, 2025)
  dropped <- d$row[d$sdvpy_drop == "True"]
  expect_identical(out$tag, df$tag[!df$tag %in% dropped])
  want <- d$sdvpy_type[match(out$tag, d$row)]
  expect_identical(out$type_text, want)
  expect_identical(out$type_id, paste0("id:", want))
  expect_identical(out$type_abbreviation, paste0("ab:", want))
  expect_true(any(out$type_text != df$type_text[match(out$tag, df$tag)], na.rm = TRUE))
})
