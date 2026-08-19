

test_that("ESPN CFB Team Coaches", {
  skip_on_cran()

  cols <- c(
    "season", "team_id", "coach_id", "first_name", "last_name",
    "date_of_birth", "birth_city", "birth_state", "birth_country",
    "experience", "coach_ref"
  )

  team_detail_cols <- c(
    "team_name", "team_abbreviation", "team_location", "team_display_name",
    "team_short_display_name", "team_nickname", "team_color",
    "team_alternate_color", "team_logo_href", "team_logo_dark_href"
  )

  # The endpoint serves only the current season, so the happy path must not
  # pin a year -- a hard-coded season would emit the deprecation warning.
  x <- espn_cfb_team_coaches(team_id = 61)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN team coaches data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_s3_class(x, "data.frame")

  # team_detail = TRUE (default) attaches the friendly team columns.
  expect_in(team_detail_cols, colnames(x))

  # team_detail = FALSE reproduces the un-enriched output.
  z <- espn_cfb_team_coaches(team_id = 61, team_detail = FALSE)
  expect_in(cols, colnames(z))
  expect_false(any(team_detail_cols %in% colnames(z)))
})

test_that("a historical year warns and is coerced to the current season", {
  skip_on_cran()

  # ESPN returns the CURRENT coach whatever season is requested -- the `$ref`
  # merely echoes the year back, which is what made the bug look like real
  # historical data (see issue #125). Callers must be told, not silently served
  # the wrong coach.
  expect_warning(
    old <- espn_cfb_team_coaches(team_id = 61, year = 2013, team_detail = FALSE),
    "only supports current season"
  )

  if (is.null(old) || !is.data.frame(old) || nrow(old) == 0) {
    skip("No ESPN team coaches data returned at test time")
  }

  # Coerced, not merely warned about: the returned season is the current one.
  expect_equal(unique(old$season), most_recent_cfb_season())

  # And the deprecated call yields the same coach as the undeprecated one, which
  # is the whole reason `year` cannot be honoured.
  cur <- espn_cfb_team_coaches(team_id = 61, team_detail = FALSE)
  expect_equal(old$coach_id, cur$coach_id)
})

test_that("the current season does not warn", {
  skip_on_cran()
  expect_no_warning(
    espn_cfb_team_coaches(
      team_id = 61,
      year = most_recent_cfb_season(),
      team_detail = FALSE
    )
  )
})

test_that("year is validated before it is compared", {
  # Offline: these abort during validation, so no network call is made.
  # `year != most_recent_cfb_season()` yields NA for NA and length > 1 for a
  # vector; either makes `if` raise a raw R error rather than a cli message, so
  # validation has to run first.
  expect_error(
    espn_cfb_team_coaches(team_id = 61, year = NA),
    "valid"
  )
  expect_error(
    espn_cfb_team_coaches(team_id = 61, year = c(2024, 2025)),
    "single season"
  )
  expect_error(espn_cfb_team_coaches(team_id = 61, year = NULL), "required")
  expect_error(espn_cfb_team_coaches(), "team_id")
})
