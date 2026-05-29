

test_that("ESPN CFB Standings", {
  skip_on_cran()

  cols <- c(
    "season", "season_type", "group_id", "team_id", "record_type",
    "record_name", "record_summary", "stat_name", "abbreviation",
    "display_name", "value", "display_value", "team_ref"
  )

  x <- espn_cfb_standings(year = 2024)

  y <- espn_cfb_standings(year = 2023)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN standings data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")

  # team_detail = TRUE (default) joins friendly team fields next to team_id.
  expect_in(
    c("team_name", "team_abbreviation", "team_location",
      "team_display_name", "team_alternate_color", "team_logo_href",
      "team_logo_dark_href"),
    colnames(x)
  )
  expect_true(any(!is.na(x$team_name)))
  expect_true(any(!is.na(x$team_logo_href)))
})

test_that("ESPN CFB Standings - team_detail = FALSE", {
  skip_on_cran()

  x <- espn_cfb_standings(year = 2024, team_detail = FALSE)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN standings data returned at test time")
  }

  # team_detail = FALSE skips the catalog join.
  expect_false("team_name" %in% colnames(x))
})
