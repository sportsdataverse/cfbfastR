test_that(".espn_retype_plays() retypes plays as sdv-py does", {
  # fixtures/parity/retype_oracle.csv.gz: every play of 19 games as it leaves
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
  expect_identical(got$type, o$sdvpy_type_normalized)
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
