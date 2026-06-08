

test_that("ESPN CFB Franchises Index", {
  skip_on_cran()

  cols <- c("franchise_id", "franchise_ref")

  x <- espn_cfb_franchises()

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN franchises data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_s3_class(x, "data.frame")
})
