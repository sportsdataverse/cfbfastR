

test_that("ESPN CFB Game Drives", {
  skip_on_cran()

  cols <- c(
    "game_id", "drive_id", "sequence_number", "description", "team_id",
    "end_team_id", "start_period", "start_period_type", "start_clock",
    "start_clock_seconds", "start_yard_line", "start_text", "end_period",
    "end_period_type", "end_clock", "end_clock_seconds", "end_yard_line",
    "end_text", "time_elapsed", "time_elapsed_seconds", "yards",
    "offensive_plays", "is_score", "result", "short_display_result",
    "display_result", "source_id", "source_description", "drive_ref",
    "team_ref", "end_team_ref", "plays_ref"
  )

  x <- espn_cfb_game_drives(game_id = 401628339)

  y <- espn_cfb_game_drives(game_id = 401520375)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game drives data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")

  # plays = "none" (default) must not append a `plays` column.
  expect_false("plays" %in% colnames(x))

  # team_detail = TRUE (default) joins friendly team fields next to the
  # drive-level team-id columns -- team_id and end_team_id.
  expect_in(
    c("team_name", "team_abbreviation", "team_alternate_color",
      "team_logo_href", "team_logo_dark_href",
      "end_team_name", "end_team_abbreviation"),
    colnames(x)
  )
})

test_that("ESPN CFB Game Drives - team_detail = FALSE", {
  skip_on_cran()

  x <- espn_cfb_game_drives(game_id = 401628339, team_detail = FALSE)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game drives data returned at test time")
  }

  expect_false("team_name" %in% colnames(x))
  expect_false("end_team_name" %in% colnames(x))
})

test_that("ESPN CFB Game Drives - plays = list", {
  skip_on_cran()

  # plays = "list" appends a `plays` list-column; each cell is that drive's
  # plays as a tibble in the full espn_cfb_game_pbp schema.
  d0 <- espn_cfb_game_drives(game_id = 401628339)
  dl <- espn_cfb_game_drives(game_id = 401628339, plays = "list")

  if (is.null(dl) || !is.data.frame(dl) || nrow(dl) == 0) {
    skip("No ESPN game drives data returned at test time")
  }

  # plays = "none" output is unchanged apart from the appended list-column.
  expect_in(colnames(d0), colnames(dl))
  expect_true("plays" %in% colnames(dl))
  expect_true(is.list(dl$plays))
  # no drive cell is NULL -- empties are 0-row tibbles.
  expect_false(any(vapply(dl$plays, is.null, logical(1))))

  ne <- which(vapply(
    dl$plays,
    function(z) is.data.frame(z) && nrow(z) > 0,
    logical(1)
  ))
  if (length(ne) > 0) {
    cell <- dl$plays[[ne[1]]]
    expect_s3_class(cell, "data.frame")
    # The embedded plays carry the full espn_cfb_game_pbp schema.
    play_cols <- c(
      "game_id", "play_id", "sequence_number", "type_id", "type_text",
      "period", "clock", "home_score", "away_score", "start_down",
      "start_distance", "end_down", "team_id", "play_ref", "drive_ref"
    )
    expect_in(play_cols, colnames(cell))
  }
})

test_that("ESPN CFB Game Drives - plays = expand", {
  skip_on_cran()

  # plays = "expand" returns the flat one-row-per-play table with the
  # drive-level columns carried alongside, prefixed `drive_`.
  de <- espn_cfb_game_drives(game_id = 401628339, plays = "expand")

  if (is.null(de) || !is.data.frame(de) || nrow(de) == 0) {
    skip("No ESPN game drives data returned at test time")
  }

  expect_s3_class(de, "data.frame")
  # Drive-level columns are prefixed `drive_`.
  expect_true(any(grepl("^drive_", colnames(de))))
  # The unnest flattens nested `drive.X` JSON into `drive_X` columns,
  # so the actual identifiers are the doubled-prefix forms.
  expect_in(c("drive_drive_id", "drive_description", "drive_team_id"),
            colnames(de))
  # Play-level columns from the espn_cfb_game_pbp schema are present.
  expect_in(c("game_id", "play_id", "type_text", "start_down"),
            colnames(de))
  # team_detail composes with plays = "expand" -- the drive_-prefixed
  # drive team-id columns get friendly fields. The embedded play columns
  # keep the base espn_cfb_game_pbp schema (not team-enriched).
  expect_in(c("drive_team_name", "drive_end_team_name"), colnames(de))
})

test_that("ESPN CFB Game Drives - expand matches unnest of list", {
  skip_on_cran()

  dl <- espn_cfb_game_drives(game_id = 401628339, plays = "list")
  de <- espn_cfb_game_drives(game_id = 401628339, plays = "expand")

  if (is.null(de) || !is.data.frame(de) || nrow(de) == 0) {
    skip("No ESPN game drives data returned at test time")
  }

  u <- espn_cfb_unnest_plays(dl)
  # plays = "expand" and unnest of plays = "list" yield the same flat
  # table. Row count must match exactly; column sets must overlap on
  # the shared schema. Subset direction so an ESPN-side column added
  # to one path but not the other doesn't break the test.
  expect_equal(dim(u)[[1]], dim(de)[[1]])
  shared <- intersect(colnames(u), colnames(de))
  expect_true(length(shared) > 0L)
})

test_that("ESPN CFB Game Drives - participant pass-through to embedded plays", {
  skip_on_cran()

  # participants = "wide" reaches the embedded plays in list mode.
  dlw <- espn_cfb_game_drives(game_id = 401628339, plays = "list",
                              participants = "wide")
  if (is.null(dlw) || !is.data.frame(dlw) || nrow(dlw) == 0) {
    skip("No ESPN game drives data returned at test time")
  }
  ne <- which(vapply(
    dlw$plays,
    function(z) is.data.frame(z) && nrow(z) > 0,
    logical(1)
  ))
  if (length(ne) > 0) {
    expect_true(any(grepl("_player_id$", colnames(dlw$plays[[ne[1]]]))))
  }

  # participants = "wide" reaches the embedded plays in expand mode too.
  dew <- espn_cfb_game_drives(game_id = 401628339, plays = "expand",
                              participants = "wide")
  if (!is.null(dew) && is.data.frame(dew) && nrow(dew) > 0) {
    expect_true(any(grepl("_player_id$", colnames(dew))))
    expect_true(any(grepl("^drive_", colnames(dew))))
  }
})
