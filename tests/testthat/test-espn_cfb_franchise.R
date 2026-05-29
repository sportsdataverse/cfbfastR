

test_that("ESPN CFB Franchise Detail", {
  skip_on_cran()

  cols <- c(
    "franchise_id", "uid", "slug", "location", "name", "nickname",
    "abbreviation", "display_name", "short_display_name", "color",
    "is_active", "venue_id", "venue_name", "team_id", "team_ref",
    "franchise_ref"
  )

  team_cols <- c(
    "team_name", "team_abbreviation", "team_location", "team_display_name",
    "team_short_display_name", "team_nickname", "team_color",
    "team_alternate_color", "team_logo_href", "team_logo_dark_href"
  )

  x <- espn_cfb_franchise(franchise_id = 2)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN franchise data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(team_cols, colnames(x))
  expect_s3_class(x, "data.frame")

  # team_detail = FALSE reproduces the prior (non-enriched) output.
  x_plain <- espn_cfb_franchise(franchise_id = 2, team_detail = FALSE)
  expect_in(cols, colnames(x_plain))
  expect_false(any(team_cols %in% colnames(x_plain)))
})
