

test_that("ESPN CFB Position Detail", {
  skip_on_cran()

  cols <- c(
    "position_id", "name", "display_name", "abbreviation", "leaf",
    "parent_id", "position_ref"
  )

  x <- espn_cfb_position(position_id = 8)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN position data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_s3_class(x, "data.frame")
})
