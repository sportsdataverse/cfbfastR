test_that(".espn_retype_plays() retypes plays as sdv-py does", {
  # fixtures/parity/retype_oracle.csv.gz: every play of 21 games as it leaves
  # sdv-py's __helper_cfb_pbp_features (in that order), with the type before its
  # relabel block (orig_play_type) and after it and the later pre-2014 label
  # normalization (sdvpy_type_normalized). Offline; see fixtures/parity/README.md.
  o <- utils::read.csv(test_path("fixtures", "parity", "retype_oracle.csv.gz"),
                       colClasses = "character", na.strings = "")
  got <- do.call(rbind, lapply(split(o, factor(o$game_id, unique(o$game_id))), function(d) {
    rt <- .espn_retype_plays(d$orig_play_type, d$text, d$scoring_type, as.integer(d$period),
                             as.logical(d$scoring_play), d$clock, d$start_team, d$end_team,
                             as.integer(d$start_ytg))
    data.frame(type = rt$type, start_ytg = rt$start_ytg)
  }))
  # documented divergence: sdv-py's unported "Extra Point Missed" string rules
  # relabel ESPN's blocked field goals and mistype them; R keeps ESPN's type
  bfg <- grepl("^Blocked Field Goal", o$orig_play_type)
  expect_identical(got$type[!bfg], o$sdvpy_type_normalized[!bfg])
  expect_identical(got$type[bfg], o$orig_play_type[bfg])
  expect_true(any(o$sdvpy_type[bfg] != o$orig_play_type[bfg]))
  moved <- o$orig_play_type %in% c("Extra Point Good", "Extra Point Missed", "2pt Conversion") &
    o$sdvpy_type %in% c("Pass Completion", "Rush")
  expect_identical(got$start_ytg[moved], as.integer(o$sdvpy_start_ytg[moved]))
  # the fixture must hold rows each rule changes, or it proves nothing
  was <- ifelse(is.na(o$orig_play_type), "Unknown", o$orig_play_type)
  changed <- unique(paste(was, "->", o$sdvpy_type_normalized)[o$sdvpy_type_normalized != was])
  expect_true(all(c("Unknown -> Field Goal Good", "Unknown -> Extra Point Good",
                    "Extra Point Missed -> Defensive 2pt Conversion", "Unknown -> Two-Point Conversion Missed",
                    "Extra Point Good -> Pass Completion", "Extra Point Good -> Rush",
                    "Extra Point Missed -> Kickoff", "2pt Conversion -> Two-Point Conversion Good",
                    "2pt Conversion -> Two-Point Conversion Missed", "Unknown -> End Period",
                    "Kickoff Return (Defense) -> Kickoff") %in% changed))
})

test_that(".espn_retype_frame() retypes a Core-v2 frame by play, in any row order", {
  # the adapter's wrapper: Core-v2 column names, rows in feed order (shuffled
  # here), results written back to each play. 292832449 (2009): pass and rush
  # touchdowns filed as their own extra point.
  o <- utils::read.csv(test_path("fixtures", "parity", "retype_oracle.csv.gz"),
                       colClasses = "character", na.strings = "")
  d <- o[o$game_id == "292832449", ]
  df <- data.frame(
    play_id = d$id, sequence_number = seq_len(nrow(d)), period = as.integer(d$period),
    clock = d$clock, drive_drive_id = NA_character_, type_text = d$orig_play_type,
    start_down_distance_text = NA_character_, end_down_distance_text = NA_character_,
    home_score = NA_integer_, away_score = NA_integer_, text = d$text,
    scoring_type_display_name = d$scoring_type, scoring_play = as.logical(d$scoring_play),
    start_team_id = d$start_team, end_team_id = d$end_team, start_yards_to_endzone = as.integer(d$start_ytg)
  )
  set.seed(4)
  df <- df[sample(nrow(df)), ]
  out <- .espn_retype_frame(df, 2009)
  expect_identical(out$play_id, df$play_id)
  expect_identical(out$type_text, d$sdvpy_type_normalized[match(out$play_id, d$id)])
  expect_true(any(out$type_text != df$type_text, na.rm = TRUE))
})
