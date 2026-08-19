

cols <- c(
  "athlete_id", "team", "name", "first_name", "last_name",
  "weight", "height", "jersey", "position",
  "home_town", "team_color", "team_color_secondary"
)

test_that("CFB Player Info", {
  skip_on_cran()
  x <- cfbd_player_info(search_term = "James", position = "DB", team = "Florida State", year = 2017)
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }

  y <- cfbd_player_info(search_term = "Lawrence", team = "Clemson")
  if (is.null(y) || !is.data.frame(y) || nrow(y) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }

  w <- cfbd_player_info(search_term = "Duggan")
  if (is.null(w) || !is.data.frame(w) || nrow(w) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  # Subset direction (expected subset of actual), per the repo convention:
  # CFBD adds columns over time and an exact set/count assertion turns that
  # into a red build for a change that broke nothing.
  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_in(cols, colnames(w))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_s3_class(w, "data.frame")
})
