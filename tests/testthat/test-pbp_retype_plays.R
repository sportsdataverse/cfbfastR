test_that(".espn_retype_plays() retypes plays as sdv-py does", {
  # fixtures/parity/retype_oracle.csv.gz: every play of 22 games as it leaves
  # sdv-py's __helper_cfb_pbp_features (in that order), with the type before its
  # relabel block (orig_play_type) and after it and the later pre-2014 label
  # normalization (sdvpy_type_normalized). Offline; see fixtures/parity/README.md.
  o <- utils::read.csv(test_path("fixtures", "parity", "retype_oracle.csv.gz"),
                       colClasses = "character", na.strings = "")
  got <- do.call(rbind, lapply(split(o, factor(o$game_id, unique(o$game_id))), function(d) {
    rt <- .espn_retype_plays(d$orig_play_type, d$text, d$scoring_type, as.integer(d$period),
                             as.logical(d$scoring_play), d$clock, d$start_team, d$end_team,
                             as.integer(d$start_ytg), as.integer(d$start_down), as.integer(d$start_distance),
                             as.integer(d$end_down), as.integer(d$end_distance), as.integer(d$end_ytg))
    data.frame(type = rt$type, start_ytg = rt$start_ytg, start_down = rt$start_down,
               start_distance = rt$start_distance)
  }))
  expect_identical(got$type, o$sdvpy_type_normalized)
  # blocked field goals keep ESPN's type on both sides since sportsdataverse-py #642
  bfg <- grepl("^Blocked Field Goal", o$orig_play_type)
  expect_true(any(bfg))
  expect_identical(got$type[bfg], o$orig_play_type[bfg])
  moved <- o$orig_play_type %in% c("Extra Point Good", "Extra Point Missed", "2pt Conversion") &
    o$sdvpy_type %in% c("Pass Completion", "Rush")
  expect_identical(got$start_ytg[moved], as.integer(o$sdvpy_start_ytg[moved]))
  # the snap's down and distance, not the try's -1 / -1
  expect_identical(got$start_down[moved], as.integer(o$sdvpy_start_down[moved]))
  expect_identical(got$start_distance[moved], as.integer(o$sdvpy_start_distance[moved]))
  expect_true(all(got$start_down[moved] %in% 1:4))
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
    start_team_id = d$start_team, end_team_id = d$end_team, start_yards_to_endzone = as.integer(d$start_ytg),
    start_down = as.integer(d$start_down), start_distance = as.integer(d$start_distance),
    end_down = as.integer(d$end_down), end_distance = as.integer(d$end_distance),
    end_yards_to_endzone = as.integer(d$end_ytg)
  )
  set.seed(4)
  df <- df[sample(nrow(df)), ]
  out <- .espn_retype_frame(df, 2009)
  expect_identical(out$play_id, df$play_id)
  expect_identical(out$type_text, d$sdvpy_type_normalized[match(out$play_id, d$id)])
  expect_true(any(out$type_text != df$type_text, na.rm = TRUE))
})

test_that(".espn_fill_spots() rebuilds the 2004 feed's start spots as sdv-py does", {
  # the 2004 feed writes start.yardsToEndzone 0 on every play; sdv-py takes the spot
  # from the home-relative start.yardLine (fixture games 243250238, 243582132,
  # 243392572, 242480152). Rows without a start team (period markers, overtime
  # shootout copies) are left out: sdv-py fills their team from earlier rows.
  o <- utils::read.csv(test_path("fixtures", "parity", "retype_oracle.csv.gz"),
                       colClasses = "character", na.strings = "")
  df <- data.frame(home_team_id = o$home_team, start_team_id = o$start_team_feed,
                   start_yard_line = as.integer(o$start_yard_line),
                   start_yards_to_endzone = as.integer(o$start_ytg))
  out <- .espn_fill_spots(df)
  # rows the touchdown + kick rule rewrites take their spot from the text instead
  moved <- o$orig_play_type %in% c("Extra Point Good", "Extra Point Missed", "2pt Conversion") &
    o$sdvpy_type %in% c("Pass Completion", "Rush")
  keep <- !moved & !is.na(o$start_team_feed)
  expect_identical(out$start_yards_to_endzone[keep], as.integer(o$sdvpy_start_ytg[keep]))
  y04 <- keep & startsWith(o$game_id, "24") & !grepl("^(Timeout|End)", o$orig_play_type)
  expect_gt(sum(y04), 500L)
  # the feed's 0 everywhere becomes a field position; the few left at 0 are sdv-py's too
  # (untyped rows at yard line 0 / 100, two-point tries at the goal line)
  expect_gt(mean(out$start_yards_to_endzone[y04] > 0, na.rm = TRUE), 0.95)
})

test_that("v2 rebuilds a 2014+ play whose feed spot is 0", {
  skip_on_cran()
  skip_on_ci()
  # 401628339: "1st & 10 at TNTC 27" (typed Penalty) arrives with yardsToEndzone 0; the
  # yard line puts it at the 27, as sdv-py reads it
  x <- suppressWarnings(suppressMessages(espn_cfb_pbp(401628339, epa_wpa = TRUE)))
  if (!is.data.frame(x) || !nrow(x) || !("yards_to_goal" %in% names(x))) skip("no modeled play-by-play")
  expect_equal(x$yards_to_goal[as.character(x$id_play) == "401628339103875504"], 27)
})

test_that(".espn_type_scored_rows() types the scores ESPN marks as sdv-py does", {
  # fixtures/parity/scored_oracle.csv.gz: every row _type_espn_scored_rows() decides in the 2004-26
  # finals (ESPN scored it, no relabel typed it a score) -- frozen-board pick-sixes, fumble returns
  # with no touchdown word, field goals typed as a snap, the rows it leaves alone -- with the type,
  # text (null kept apart from empty), the start team's margin change and ESPN's touchdown flag,
  # and the type sdv-py returns. The margin itself: score_delta_oracle.csv.gz below.
  o <- utils::read.csv(test_path("fixtures", "parity", "scored_oracle.csv.gz"),
                       colClasses = "character", na.strings = "")
  text <- ifelse(o$text_null == "True", NA_character_, ifelse(is.na(o$text), "", o$text))
  got <- .espn_type_scored_rows(o$type, text, o$scoring_play == "True", as.numeric(o$delta),
                                o$espn_td == "True")
  expect_identical(got, o$sdvpy_type)
  expect_gte(sum(o$type != o$sdvpy_type), 400L)
})

test_that(".espn_score_delta() reproduces sdv-py's margin change on every row", {
  # fixtures/parity/score_delta_oracle.csv.gz: every row sdv-py keeps after its copy rules in 18
  # games -- reversed boards, score glitches, a touchdown snap named for the wrong team, kickoffs
  # -- with the feed's fields and sdv-py's end.pos_score_diff - start.pos_score_diff
  o <- utils::read.csv(test_path("fixtures", "parity", "score_delta_oracle.csv.gz"),
                       colClasses = "character", na.strings = "")
  for (g in unique(o$game_id)) {
    d <- o[o$game_id == g, ]
    got <- .espn_score_delta(d$type, d$feed_type, d$text, d$start_team, d$end_team, d$home, d$away,
                             as.numeric(d$home_score), as.numeric(d$away_score), d$scoring_play == "True",
                             as.numeric(d$home_final[1]), as.numeric(d$away_final[1]))
    expect_identical(got, as.numeric(d$sdvpy_delta), info = g)
  }
})

test_that(".espn_type_scored_rows() takes sdv-py's every branch, not only the ones the corpus decides", {
  # fixtures/parity/scored_grid_oracle.csv.gz: sdv-py's own _type_espn_scored_rows() (a pure
  # function) run on a grid of types x texts x margin changes x ESPN's touchdown flag, null text
  # included: the frozen-board offence, punt-team and missed-field-goal returns, the margin window's
  # edges and the negation, which no 2004-26 game decides
  o <- utils::read.csv(test_path("fixtures", "parity", "scored_grid_oracle.csv.gz"),
                       colClasses = "character", na.strings = "")
  text <- ifelse(o$text_null == "True", NA_character_, ifelse(is.na(o$text), "", o$text))
  got <- .espn_type_scored_rows(o$type, text, o$scoring_play == "True", as.numeric(o$delta),
                                o$espn_td == "True")
  expect_identical(got, o$sdvpy_type)
})
