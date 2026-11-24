
splits_cols <- c(
  "athlete_id", "season", "category", "category_display",
  "split_name", "split_abbr"
)

# athlete_detail = TRUE (default) -- friendly athlete name columns
# appended from one cheap athlete fetch.
athlete_cols <- c(
  "athlete_display_name", "athlete_first_name", "athlete_last_name",
  "athlete_jersey", "athlete_position", "athlete_position_abbreviation"
)

# A transient ESPN failure is caught by the function, which then returns only the
# query columns (2026-11-20: the 2023 call did, on both CI jobs). That is "no data
# at test time", not a schema regression; a non-data-frame result still fails.
splits_unavailable <- function(d) {
  nrow(d) == 0 || length(setdiff(colnames(d), c("season", "athlete_id"))) == 0
}

test_that("ESPN CFB Player Statistical Splits (2024, athlete detail)", {
  skip_on_cran()

  x <- espn_cfb_player_splits(athlete_id = 102597, year = 2024)
  expect_s3_class(x, "data.frame")
  if (splits_unavailable(x)) {
    skip("No ESPN player splits data returned for 2024 at test time")
  }

  expect_in(splits_cols, colnames(x))
  expect_in(athlete_cols, colnames(x))
  expect_true(all(!is.na(x$category)))

  # athlete_detail = FALSE -- the name columns and the fetch are skipped;
  # the base schema is unchanged.
  z <- espn_cfb_player_splits(athlete_id = 102597, year = 2024,
                              athlete_detail = FALSE)
  expect_s3_class(z, "data.frame")
  if (!splits_unavailable(z)) {
    expect_in(splits_cols, colnames(z))
    expect_false(any(athlete_cols %in% colnames(z)))
  }
})

test_that("ESPN CFB Player Statistical Splits (2023)", {
  skip_on_cran()

  y <- espn_cfb_player_splits(athlete_id = 102597, year = 2023)
  expect_s3_class(y, "data.frame")
  if (splits_unavailable(y)) {
    skip("No ESPN player splits data returned for 2023 at test time")
  }

  expect_in(splits_cols, colnames(y))
})
