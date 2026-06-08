

test_that("ESPN CFB Teams Index", {
  skip_on_cran()

  cols <- c(
    "team_id", "uid", "slug", "abbreviation", "display_name",
    "short_display_name", "name", "nickname", "location", "color",
    "alternate_color", "is_active", "is_all_star", "logo_href",
    "logo_dark_href"
  )

  x <- espn_cfb_teams()

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN teams data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_s3_class(x, "data.frame")
  expect_true(any(x$team_id == "61"))
})
