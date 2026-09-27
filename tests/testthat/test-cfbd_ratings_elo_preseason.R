test_that("CFBD - Elo preseason rejects the combinations the API documents", {
  # Offline: `preseason = TRUE` cannot be combined with `week`, and season_type
  # must be regular or both. Both must abort locally, never reach get_req().
  local_mocked_bindings(
    validate_api_key = function() invisible(TRUE),
    get_req = function(full_url, proxy = NULL) stop("get_req() must not be called")
  )
  expect_error(cfbd_ratings_elo(year = 2024, week = 1, preseason = TRUE), "cannot be combined")
  expect_error(cfbd_ratings_elo(year = 2024, season_type = "postseason", preseason = TRUE), "must be")
  # a truthy non-logical used to slip past validate_list() and reach the API as a 400
  expect_error(cfbd_ratings_elo(year = 2024, week = 1, preseason = "TRUE"), "single")
  expect_error(cfbd_ratings_elo(year = 2024, preseason = 1), "single")
  expect_error(cfbd_ratings_elo(year = 2024, preseason = c(TRUE, FALSE)), "single")
})

test_that("CFBD - Elo preseason returns opening ratings", {
  skip_on_cran()
  skip_if(!has_cfbd_key(), "CFBD API key not available")
  x <- cfbd_ratings_elo(year = 2024, preseason = TRUE)
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) skip("CFBD rate-limited or returned no rows")
  expect_in(c("year", "team", "conference", "elo"), colnames(x))
  expect_s3_class(x, "data.frame")
})
