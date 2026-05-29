

test_that("ESPN CFB Seasons Index", {
  skip_on_cran()

  cols <- c(
    "season", "display_name", "start_date", "end_date", "season_ref"
  )

  x <- espn_cfb_seasons()

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN seasons data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_s3_class(x, "data.frame")
  expect_true(is.integer(x$season))
})
