testthat::test_that(
  "Minimum year map has been updated within last 3 months",{
    skip_on_cran()
    skip_if(!has_cfbd_key(), "CFBD API key not available")

    outdated_mins <- min_year_map_df$last_updated < Sys.Date() - months(3)

    testthat::expect_all_false(outdated_mins)
  })