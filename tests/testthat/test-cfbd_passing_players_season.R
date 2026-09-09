
identity_cols <- c("season", "player_id", "player", "team", "conference")

test_that("CFB Passing Players Season", {
  skip_on_cran()
  x <- cfbd_passing_players_season(year = 2025, team = "Texas")
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_s3_class(x, "data.frame")
  expect_true(all(identity_cols %in% colnames(x)))

  # 5 identity + 23 production + 7 location buckets x 23. Asserting the shape
  # rather than 189 literal names keeps the test readable and still fails if a
  # bucket or a production column disappears upstream.
  loc <- grep("^locations_", colnames(x), value = TRUE)
  expect_equal(length(loc), 7L * 23L)
  expect_true(all(paste0("locations_",
    c("short_left", "short_middle", "short_right",
      "deep_left", "deep_middle", "deep_right", "unknown"),
    "_attempts") %in% colnames(x)))
  expect_equal(ncol(x), 189L)
})

test_that("CFB Passing Players Season returns empty out of coverage", {
  skip_on_cran()
  # These endpoints carry 2025 onward. Earlier seasons answer HTTP 200 with an
  # empty array, which must surface as a 0-row frame and not a parse error.
  x <- cfbd_passing_players_season(year = 2024, team = "Texas")
  expect_s3_class(x, "data.frame")
  expect_equal(nrow(x), 0L)
})
