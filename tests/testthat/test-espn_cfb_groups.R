

test_that("ESPN CFB Groups", {
  skip_on_cran()

  cols <- c(
    "season", "season_type", "group_id", "name", "abbreviation",
    "short_name", "is_conference", "parent_group_id", "slug", "group_ref",
    "standings_ref", "teams_ref"
  )

  x <- espn_cfb_groups(year = 2024)

  y <- espn_cfb_groups(year = 2023)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN groups data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_true(any(x$is_conference))
})
