

test_that("ESPN CFB Game Plays", {
  skip_on_cran()

  cols <- c(
    "game_id", "play_id", "sequence_number", "type_id", "type_text",
    "type_abbreviation", "text", "short_text", "alternative_text",
    "short_alternative_text", "period", "clock", "clock_seconds",
    "home_score", "away_score", "scoring_play", "score_value", "priority",
    "is_penalty", "is_turnover", "stat_yardage", "scoring_type_name",
    "scoring_type_abbreviation", "point_after_attempt_id",
    "point_after_attempt_text", "start_down", "start_distance",
    "start_yard_line", "start_yards_to_endzone", "start_down_distance_text",
    "start_possession_text", "start_team_id", "end_down", "end_distance",
    "end_yard_line", "end_yards_to_endzone", "end_down_distance_text",
    "end_possession_text", "end_team_id", "team_id", "drive_play_id",
    "wallclock", "modified", "play_ref", "team_ref", "start_team_ref",
    "end_team_ref", "drive_ref", "probability_ref"
  )

  x <- espn_cfb_game_pbp(game_id = 401628339)

  y <- espn_cfb_game_pbp(game_id = 401520375)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game plays data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")

  # team_participants is opt-in (team_participants_list = TRUE) and is not
  # present in the default output.
  expect_false("team_participants" %in% colnames(x))

  # team_detail = TRUE (default) joins friendly team fields next to every
  # team-id column -- team_id, start_team_id, end_team_id.
  expect_in(
    c("team_name", "team_abbreviation", "team_location",
      "team_color", "team_alternate_color", "team_logo_href",
      "team_logo_dark_href",
      "start_team_name", "end_team_name"),
    colnames(x)
  )
  expect_true(any(!is.na(x$team_name)))
  expect_true(any(!is.na(x$team_alternate_color)))
  expect_true(any(!is.na(x$team_logo_href)))
  expect_true(any(!is.na(x$team_logo_dark_href)))
})

test_that("ESPN CFB Game Plays - team_detail = FALSE", {
  skip_on_cran()

  x <- espn_cfb_game_pbp(game_id = 401628339, team_detail = FALSE)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game plays data returned at test time")
  }

  # team_detail = FALSE skips the catalog join.
  expect_false("team_name" %in% colnames(x))
  expect_false("start_team_name" %in% colnames(x))
})

test_that("ESPN CFB Game Plays - participants = wide", {
  skip_on_cran()

  x <- espn_cfb_game_pbp(game_id = 401628339, participants = "wide")

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game plays data returned at test time")
  }

  # Wide mode emits type-keyed columns: for every participant type present
  # in the game, {type}_player_id / _player_name / _player_position /
  # _player_position_name (scalar) and {type}_player_ids / _player_names
  # (list-columns).
  expect_in(c("game_id", "play_id"), colnames(x))
  pid_cols   <- grep("_player_id$", colnames(x), value = TRUE)
  pname_cols <- grep("_player_name$", colnames(x), value = TRUE)
  pids_cols  <- grep("_player_ids$", colnames(x), value = TRUE)
  pnames_cols <- grep("_player_names$", colnames(x), value = TRUE)
  ppos_cols  <- grep("_player_position$", colnames(x), value = TRUE)
  pposn_cols <- grep("_player_position_name$", colnames(x), value = TRUE)
  expect_gt(length(pid_cols), 0)
  expect_equal(length(pid_cols), length(pname_cols))
  expect_equal(length(pid_cols), length(pids_cols))
  expect_equal(length(pid_cols), length(pnames_cols))
  expect_equal(length(pid_cols), length(ppos_cols))
  expect_equal(length(pid_cols), length(pposn_cols))
  # Common CFB participant types should be present.
  expect_true(any(c("passer_player_id", "rusher_player_id",
                     "tackler_player_id") %in% colnames(x)))
  # Scalar id columns are character; list columns are lists.
  expect_type(x[[pid_cols[1]]], "character")
  expect_true(is.list(x[[pids_cols[1]]]))
  expect_true(is.list(x[[pnames_cols[1]]]))
  # position_detail is joined into wide participants -- the position
  # columns are populated for at least some plays.
  expect_type(x[[ppos_cols[1]]], "character")
  expect_true(any(!is.na(unlist(x[ppos_cols]))))
  expect_s3_class(x, "data.frame")
})

test_that("ESPN CFB Game Plays - team_participants", {
  skip_on_cran()

  # Default team_participants = "none" adds no team-participant columns.
  d <- espn_cfb_game_pbp(game_id = 401628339)
  if (is.null(d) || !is.data.frame(d) || nrow(d) == 0) {
    skip("No ESPN game plays data returned at test time")
  }
  expect_equal(
    length(grep("offense_team|defense_team|^team_participants$",
                colnames(d))),
    0
  )

  # team_participants = "wide" emits type-keyed {type}_team_* columns.
  # Note: ESPN supplies `_team_id` and `_team_ref` for ALL participant
  # types it emits (start, end, offense, defense, etc.), but `_team_order`
  # only for the offense/defense pair. We assert the participant pair we
  # control (offense + defense) carries a complete id / order / ref
  # trio; other participant prefixes carry id + ref only.
  x <- espn_cfb_game_pbp(game_id = 401628339, team_participants = "wide")
  tid_cols    <- grep("_team_id$",    colnames(x), value = TRUE)
  torder_cols <- grep("_team_order$", colnames(x), value = TRUE)
  tref_cols   <- grep("_team_ref$",   colnames(x), value = TRUE)
  expect_gt(length(tid_cols), 0)
  # offense + defense participants must have the full id/order/ref trio.
  for (side in c("offense", "defense")) {
    expect_true(paste0(side, "_team_id")    %in% tid_cols)
    expect_true(paste0(side, "_team_order") %in% torder_cols)
    expect_true(paste0(side, "_team_ref")   %in% tref_cols)
  }
  # id / ref counts match (every team participant carries both).
  expect_equal(length(tid_cols), length(tref_cols))
  expect_true(any(c("offense_team_id", "defense_team_id") %in%
                    colnames(x)))
  expect_false("team_participants" %in% colnames(x))

  # team_participants_list = TRUE attaches the nested list-column.
  y <- espn_cfb_game_pbp(game_id = 401628339,
                         team_participants_list = TRUE)
  expect_true("team_participants" %in% colnames(y))
  expect_true(is.list(y$team_participants))
  expect_false(any(vapply(y$team_participants, is.null, logical(1))))
  ne <- which(vapply(
    y$team_participants,
    function(z) is.data.frame(z) && nrow(z) > 0,
    logical(1)
  ))
  if (length(ne) > 0) {
    expect_in(
      c("team_participant_index", "team_id", "team_ref", "order", "type"),
      colnames(y$team_participants[[ne[1]]])
    )
  }

  # The two compose: "wide" + list = TRUE yields both.
  z <- espn_cfb_game_pbp(game_id = 401628339, team_participants = "wide",
                         team_participants_list = TRUE)
  expect_gt(length(grep("_team_id$", colnames(z))), 0)
  expect_true("team_participants" %in% colnames(z))
})

test_that("ESPN CFB Game Plays - participants = long", {
  skip_on_cran()

  x <- espn_cfb_game_pbp(game_id = 401628339, participants = "long")

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game plays data returned at test time")
  }

  cols <- c(
    "game_id", "play_id", "participant_index", "participant_athlete_id",
    "participant_type", "participant_order", "participant_athlete_name",
    "participant_position", "participant_jersey", "participant_team_id"
  )
  expect_in(cols, colnames(x))
  expect_s3_class(x, "data.frame")
})

test_that("ESPN CFB Game Plays - participants_list = TRUE", {
  skip_on_cran()

  # participants_list adds a single `participants` list-column, combinable
  # with the wide expansion.
  x <- espn_cfb_game_pbp(game_id = 401628339, participants = "wide",
                         participants_list = TRUE)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game plays data returned at test time")
  }

  expect_true("participants" %in% colnames(x))
  expect_true(is.list(x$participants))
  # wide expansion still present alongside the list-column.
  expect_gt(length(grep("_player_id$", colnames(x))), 0)
  # A non-empty cell is a data.frame with the documented columns; empty
  # plays carry a 0-row tibble rather than NULL.
  expect_false(any(vapply(x$participants, is.null, logical(1))))
  ne <- which(vapply(
    x$participants,
    function(z) is.data.frame(z) && nrow(z) > 0,
    logical(1)
  ))
  if (length(ne) > 0) {
    cell <- x$participants[[ne[1]]]
    expect_s3_class(cell, "data.frame")
    expect_in(
      c("participant_index", "type", "athlete_id", "athlete_name",
        "order", "position_id"),
      colnames(cell)
    )
  }

  # participants = "none" + participants_list = TRUE: only the list-column.
  y <- espn_cfb_game_pbp(game_id = 401628339, participants = "none",
                         participants_list = TRUE)
  if (!is.null(y) && is.data.frame(y) && nrow(y) > 0) {
    expect_true("participants" %in% colnames(y))
    expect_true(is.list(y$participants))
    expect_equal(length(grep("_player_id$", colnames(y))), 0)
  }
})
