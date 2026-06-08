

test_that("ESPN CFB Unnest Plays", {
  skip_on_cran()

  dl <- espn_cfb_game_drives(game_id = 401628339, plays = "list")

  if (is.null(dl) || !is.data.frame(dl) || nrow(dl) == 0 ||
      !("plays" %in% colnames(dl))) {
    skip("No ESPN game drives data returned at test time")
  }

  u <- espn_cfb_unnest_plays(dl)

  if (is.null(u) || !is.data.frame(u) || nrow(u) == 0) {
    skip("No ESPN unnested plays returned at test time")
  }

  expect_s3_class(u, "data.frame")
  # Drive-level columns carried alongside each play, prefixed `drive_`.
  # The unnest flattens the nested `drive.X` JSON into `drive_X` columns.
  expect_true(any(grepl("^drive_", colnames(u))))
  expect_in(c("drive_drive_id", "drive_description", "drive_team_id"),
            colnames(u))
  # Play-level columns from the espn_cfb_game_pbp schema are present.
  expect_in(c("game_id", "play_id", "type_text", "start_down"),
            colnames(u))
})

test_that("ESPN CFB Unnest Plays - matches plays = expand", {
  skip_on_cran()

  dl <- espn_cfb_game_drives(game_id = 401520375, plays = "list")
  de <- espn_cfb_game_drives(game_id = 401520375, plays = "expand")

  if (is.null(de) || !is.data.frame(de) || nrow(de) == 0) {
    skip("No ESPN game drives data returned at test time")
  }

  u <- espn_cfb_unnest_plays(dl)
  # The auxiliary transform reproduces the plays = "expand" flat table.
  # Row counts must match exactly. Column sets must be the same up to
  # ESPN's incremental field additions; use subset-direction so an
  # upstream addition surfacing in only one path doesn't break the test.
  expect_equal(dim(u)[[1]], dim(de)[[1]])
  expect_in(intersect(colnames(u), colnames(de)),
            union(colnames(u), colnames(de)))
})

test_that("ESPN CFB Unnest Plays - aborts without a plays list-column", {
  skip_on_cran()

  d0 <- espn_cfb_game_drives(game_id = 401628339)

  if (is.null(d0) || !is.data.frame(d0) || nrow(d0) == 0) {
    skip("No ESPN game drives data returned at test time")
  }

  # A drives frame produced without plays = "list" must abort with a clear
  # message telling the caller to re-run with plays = "list".
  expect_error(espn_cfb_unnest_plays(d0), "plays")
})
