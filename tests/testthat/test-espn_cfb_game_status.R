

test_that("ESPN CFB Game Status", {
  skip_on_cran()

  cols <- c(
    "game_id", "clock", "display_clock", "period", "status_id",
    "status_name", "status_state", "completed", "description", "detail",
    "short_detail", "status_ref"
  )

  x <- espn_cfb_game_status(game_id = 401628339)

  y <- espn_cfb_game_status(game_id = 401520375)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game status data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
