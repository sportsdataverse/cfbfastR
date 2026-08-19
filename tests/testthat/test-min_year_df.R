testthat::test_that("Minimum year map has been updated within last 3 months", {
  skip_on_cran()
  skip_on_ci()
  skip_if(!has_cfbd_key(), "CFBD API key not available")

  # 90 days, matching the same cutoff in data-raw/min_year_map_df.R. Deliberately
  # not `months(3)`: that is lubridate, which cfbfastR does not declare -- it
  # only resolves because a dependency happens to attach it.
  cutoff <- Sys.Date() - 90

  # NA marks a function onboarded by the updater but never probed, which is as
  # out of date as a stale one.
  stale <- min_year_map_df[
    is.na(min_year_map_df$last_updated) | min_year_map_df$last_updated < cutoff,
  ]

  testthat::expect_equal(
    nrow(stale), 0L,
    info = paste0(
      nrow(stale), " minimum(s) not verified since ", cutoff, ": ",
      paste(stale$function_name, collapse = ", "),
      " -- re-run data-raw/min_year_map_df.R"
    )
  )
})

testthat::test_that("every year-taking export has a documented minimum", {
  skip_on_cran()

  # Offline structural check: guards the gap the updater used to have, where a
  # newly-added wrapper was silently absent from the map forever.
  has_year <- Filter(
    function(f) {
      o <- tryCatch(getExportedValue("cfbfastR", f), error = function(e) NULL)
      is.function(o) && "year" %in% names(formals(o))
    },
    getNamespaceExports("cfbfastR")
  )

  missing <- sort(setdiff(has_year, min_year_map_df$function_name))
  testthat::expect_equal(
    length(missing), 0L,
    info = paste0(
      length(missing), " year-taking export(s) missing from min_year_map_df: ",
      paste(missing, collapse = ", "),
      " -- re-run data-raw/min_year_map_df.R to onboard them"
    )
  )
})
