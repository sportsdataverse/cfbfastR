test_that("validate_year accepts a four-digit year", {
  expect_silent(cfbfastR:::validate_year(2025))
  expect_silent(cfbfastR:::validate_year(NULL))
})

test_that("validate_year reports NA with a cli message, not a base R error", {
  # nchar(NA_integer_) is NA, so `checks` carried an NA, `all()` returned NA and
  # `if (!NA)` raised "missing value where TRUE/FALSE needed" -- a base R error
  # from the function whose whole job is to produce a readable one. Reached via
  # any of the 24 files that call validate_year().
  for (bad in list(NA_integer_, NA_real_, c(2025, NA))) {
    expect_error(cfbfastR:::validate_year(bad), regexp = "Enter valid .* as a number")
  }
})

test_that("validate_year still rejects malformed years", {
  expect_error(cfbfastR:::validate_year("twenty"), regexp = "Enter valid .* as a number")
  expect_error(cfbfastR:::validate_year(25), regexp = "Enter valid .* as a number")
})
