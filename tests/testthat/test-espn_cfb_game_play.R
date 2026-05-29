

test_that("ESPN CFB Game Play", {
  skip_on_cran()

  cols <- c(
    "game_id", "play_id", "sequence_number", "type_id", "type_text",
    "type_abbreviation", "text", "short_text", "alternative_text",
    "short_alternative_text", "period", "clock", "clock_seconds",
    "home_score", "away_score", "scoring_play", "score_value", "priority",
    "is_penalty", "is_turnover", "stat_yardage", "start_down",
    "start_distance", "start_yard_line", "start_yards_to_endzone",
    "start_down_distance_text", "start_possession_text", "start_team_id",
    "end_down", "end_distance", "end_yard_line", "end_yards_to_endzone",
    "end_down_distance_text", "end_short_down_distance_text",
    "end_possession_text", "end_team_id", "team_id", "drive_play_id",
    "wallclock", "modified", "play_ref", "team_ref", "start_team_ref",
    "end_team_ref", "drive_ref", "probability_ref"
  )

  x <- espn_cfb_game_play(game_id = 401628339,
                          play_id = "401628339101927401")

  y <- espn_cfb_game_play(game_id = 401520375,
                          play_id = "401520375101929201")

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game play data returned at test time")
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
    c("team_name", "team_abbreviation", "team_alternate_color",
      "team_logo_href", "team_logo_dark_href",
      "start_team_name", "end_team_name"),
    colnames(x)
  )
})

test_that("ESPN CFB Game Play - team_detail = FALSE", {
  skip_on_cran()

  x <- espn_cfb_game_play(game_id = 401628339,
                          play_id = "401628339101927401",
                          team_detail = FALSE)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game play data returned at test time")
  }

  expect_false("team_name" %in% colnames(x))
  expect_false("start_team_name" %in% colnames(x))
})

test_that("ESPN CFB Game Play - participants = wide", {
  skip_on_cran()

  x <- espn_cfb_game_play(game_id = 401628339,
                          play_id = "401628339101927401",
                          participants = "wide")

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game play data returned at test time")
  }

  # Wide mode emits type-keyed {type}_player_id / _player_name (scalar)
  # and {type}_player_ids / _player_names (list-columns).
  expect_in(c("game_id", "play_id"), colnames(x))
  pid_cols    <- grep("_player_id$", colnames(x), value = TRUE)
  pname_cols  <- grep("_player_name$", colnames(x), value = TRUE)
  pids_cols   <- grep("_player_ids$", colnames(x), value = TRUE)
  pnames_cols <- grep("_player_names$", colnames(x), value = TRUE)
  expect_gt(length(pid_cols), 0)
  expect_equal(length(pid_cols), length(pname_cols))
  expect_equal(length(pid_cols), length(pids_cols))
  expect_equal(length(pid_cols), length(pnames_cols))
  expect_true(is.list(x[[pids_cols[1]]]))
  expect_s3_class(x, "data.frame")
})

test_that("ESPN CFB Game Play - participants = long", {
  skip_on_cran()

  x <- espn_cfb_game_play(game_id = 401628339,
                          play_id = "401628339101927401",
                          participants = "long")

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game play data returned at test time")
  }

  cols <- c(
    "game_id", "play_id", "participant_index", "participant_athlete_id",
    "participant_type", "participant_order", "participant_athlete_name"
  )
  expect_in(cols, colnames(x))
  expect_s3_class(x, "data.frame")
})

test_that("ESPN CFB Game Play - participants_list = TRUE", {
  skip_on_cran()

  # participants_list adds a single `participants` list-column, combinable
  # with the wide expansion.
  x <- espn_cfb_game_play(game_id = 401628339,
                          play_id = "401628339101927401",
                          participants = "wide",
                          participants_list = TRUE)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game play data returned at test time")
  }

  expect_true("participants" %in% colnames(x))
  expect_true(is.list(x$participants))
  expect_gt(length(grep("_player_id$", colnames(x))), 0)
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
  y <- espn_cfb_game_play(game_id = 401628339,
                          play_id = "401628339101927401",
                          participants = "none",
                          participants_list = TRUE)
  if (!is.null(y) && is.data.frame(y) && nrow(y) > 0) {
    expect_true("participants" %in% colnames(y))
    expect_true(is.list(y$participants))
  }
})

test_that("ESPN CFB Game Play - team_participants", {
  skip_on_cran()

  # Default team_participants = "none" adds no team-participant columns.
  d <- espn_cfb_game_play(game_id = 401628339,
                          play_id = "401628339101927401")
  if (is.null(d) || !is.data.frame(d) || nrow(d) == 0) {
    skip("No ESPN game play data returned at test time")
  }
  expect_equal(
    length(grep("offense_team|defense_team|^team_participants$",
                colnames(d))),
    0
  )

  # team_participants = "wide" emits type-keyed {type}_team_* columns.
  x <- espn_cfb_game_play(game_id = 401628339,
                          play_id = "401628339101927401",
                          team_participants = "wide")
  expect_gt(length(grep("_team_id$", colnames(x))), 0)
  expect_false("team_participants" %in% colnames(x))

  # team_participants_list = TRUE attaches the nested list-column.
  y <- espn_cfb_game_play(game_id = 401628339,
                          play_id = "401628339101927401",
                          team_participants_list = TRUE)
  expect_true("team_participants" %in% colnames(y))
  expect_true(is.list(y$team_participants))

  # The two compose.
  z <- espn_cfb_game_play(game_id = 401628339,
                          play_id = "401628339101927401",
                          team_participants = "wide",
                          team_participants_list = TRUE)
  expect_gt(length(grep("_team_id$", colnames(z))), 0)
  expect_true("team_participants" %in% colnames(z))
})

test_that("ESPN CFB Game Play - participants = wide position detail", {
  skip_on_cran()

  x <- espn_cfb_game_play(game_id = 401628339,
                          play_id = "401628339101849905",
                          participants = "wide")

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game play data returned at test time")
  }

  # Wide participants carry per-type position detail.
  ppos_cols  <- grep("_player_position$", colnames(x), value = TRUE)
  pposn_cols <- grep("_player_position_name$", colnames(x), value = TRUE)
  pid_cols   <- grep("_player_id$", colnames(x), value = TRUE)
  expect_gt(length(ppos_cols), 0)
  expect_equal(length(ppos_cols), length(pid_cols))
  expect_equal(length(pposn_cols), length(pid_cols))
  expect_type(x[[ppos_cols[1]]], "character")
})
