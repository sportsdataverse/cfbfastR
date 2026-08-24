
test_that("release-dataset loaders return tagged data (rds seasonal path)", {
  skip_on_cran()
  skip_if_offline("github.com")

  x <- load_cfb_ratings(2024)
  expect_s3_class(x, "cfbfastR_data")
  expect_gt(nrow(x), 100)
  expect_contains(colnames(x), c("team_id", "season"))

  y <- load_espn_cfb_adv_team(2024)
  expect_s3_class(y, "cfbfastR_data")
  expect_gt(nrow(y), 1000)
})

test_that("release-dataset loaders return tagged data (parquet path)", {
  skip_on_cran()
  skip_if_offline("github.com")
  skip_if_not_installed("arrow")

  x <- load_cfb_teams_crosswalk(2024)
  expect_s3_class(x, "cfbfastR_data")
  expect_gt(nrow(x), 500)

  y <- load_espn_cfb_linescores(2024)
  expect_s3_class(y, "cfbfastR_data")
  expect_gt(nrow(y), 1000)

  z <- load_cfb_rosters_crosswalk()
  expect_s3_class(z, "cfbfastR_data")
  expect_gt(nrow(z), 10000)
})

test_that("ncaa_mfb family loaders return tagged data", {
  skip_on_cran()
  skip_if_offline("github.com")

  x <- load_ncaa_mfb_teams(2023)
  expect_s3_class(x, "cfbfastR_data")
  expect_gt(nrow(x), 200)

  y <- load_ncaa_mfb_schedule(2023)
  expect_s3_class(y, "cfbfastR_data")
  expect_gt(nrow(y), 2000)
})

test_that("seasonal loaders validate the seasons argument", {
  skip_on_cran()

  expect_error(load_cfb_ratings(1999))
  expect_error(load_espn_cfb_play_participants(2010))
})
