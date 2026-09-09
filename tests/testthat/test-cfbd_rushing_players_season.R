
identity_cols <- c("season", "player_id", "player", "team", "conference")

test_that("CFB Rushing Players Season", {
  skip_on_cran()
  skip_if_not(has_cfbd_key(), "CFBD_API_KEY not set")
  x <- cfbd_rushing_players_season(year = 2025, team = "Texas")
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_s3_class(x, "data.frame")
  expect_true(all(identity_cols %in% colnames(x)))

  # 5 identity + 24 production + 4 direction buckets x 15. Asserting the shape
  # rather than 89 literal names keeps the test readable and still fails if a
  # bucket or a production column disappears upstream.
  loc <- grep("^directions_", colnames(x), value = TRUE)
  expect_equal(length(loc), 4L * 15L)
  expect_true(all(paste0("directions_",
    c("left", "middle", "right", "unknown"),
    "_carries") %in% colnames(x)))
  expect_equal(ncol(x), 89L)
})

test_that("CFB Rushing Players Season returns empty out of coverage", {
  skip_on_cran()
  skip_if_not(has_cfbd_key(), "CFBD_API_KEY not set")
  # These endpoints carry 2025 onward. Earlier seasons answer HTTP 200 with an
  # empty array, which must surface as a 0-row frame and not a parse error.
  x <- cfbd_rushing_players_season(year = 2024, team = "Texas")
  expect_s3_class(x, "data.frame")
  expect_equal(nrow(x), 0L)
})
