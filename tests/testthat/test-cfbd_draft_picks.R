

cols <- c(
  "college_athlete_id", "nfl_athlete_id",
  "college_id","college_team","college_conference",
  "nfl_team_id", "nfl_team","year","overall","round","pick","name", "position",
  "height", "weight",
  "pre_draft_ranking", "pre_draft_position_ranking", "pre_draft_grade",
  "hometown_info_city", "hometown_info_state", "hometown_info_country","hometown_info_latitude",
  "hometown_info_longitude", "hometown_info_county_fips"
)

test_that("NFL Draft Picks", {
  skip_on_cran()
  x <- cfbd_draft_picks(2018)
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  y <- cfbd_draft_picks(year = 2016, position = "PK")
  if (is.null(y) || !is.data.frame(y) || nrow(y) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_setequal(colnames(x), cols)
  expect_setequal(colnames(y), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
