cols <- c("season", "id", "name", "team", "usage_overall")

test_that("CFB Player Season Overview", {
  skip_on_cran()
  x <- cfbd_player_season_overview(year = 2024, athlete_id = 4429105)
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_in(cols, colnames(x))
  expect_s3_class(x, "data.frame")
  # `usage` and `ppa` arrive as nested blocks of differing lengths -- an
  # unflattened frame raises "columns must have compatible sizes", so this
  # asserts the flattening survives.
  expect_true(all(vapply(x, is.atomic, logical(1))))
})
