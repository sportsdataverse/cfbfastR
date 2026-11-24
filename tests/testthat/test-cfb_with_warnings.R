test_that(".cfb_with_warnings() names the wrapper and keeps the result", {
  f <- function() {
    df <- data.frame()
    tryCatch(
      expr = .cfb_with_warnings("my_wrapper", {
        x <- as.integer("not a number") # warns: NAs introduced by coercion
        df <- data.frame(x = x, y = 1L)
      }),
      error = function(e) NULL
    )
    df
  }
  expect_warning(out <- f(), class = "cfbfastR_warning", regexp = "my_wrapper\\(\\): .*coercion")
  expect_equal(nrow(out), 1L)
  expect_identical(out$y, 1L)
})

test_that("nested .cfb_with_warnings() raises one warning, named by the inner wrapper", {
  w <- testthat::capture_warnings(
    .cfb_with_warnings("outer", .cfb_with_warnings("inner", warning("boom")))
  )
  expect_length(w, 1L)
  expect_match(w, "inner\\(\\): boom")
})
