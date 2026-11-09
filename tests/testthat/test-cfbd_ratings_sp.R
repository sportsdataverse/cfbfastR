
cols <- c(
  "year", "team",
  "conference", "rating", "ranking", "second_order_wins", "sos", "offense_ranking",
  "offense_rating", "offense_success", "offense_explosiveness",
  "offense_rushing", "offense_passing", "offense_standard_downs",
  "offense_passing_downs", "offense_run_rate",
  "offense_pace", "defense_ranking", "defense_rating", "defense_success", "defense_explosiveness",
  "defense_rushing", "defense_passing", "defense_standard_downs",
  "defense_passing_downs", "defense_havoc_total", "defense_havoc_front_seven",
  "defense_havoc_db", "special_teams_rating"
)

test_that("CFB Ratings - Bill C.'s SP+", {
  skip_on_cran()
  x <- cfbd_ratings_sp(year = 2019)
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }

  y <- cfbd_ratings_sp(team = "Texas A&M")
  if (is.null(y) || !is.data.frame(y) || nrow(y) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }

  z <- cfbd_ratings_sp(year = 2019, team = "LSU")
  if (is.null(z) || !is.data.frame(z) || nrow(z) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }

  expect_setequal(colnames(x), cols)
  expect_setequal(colnames(y), cols)
  expect_setequal(colnames(z), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_s3_class(z, "data.frame")
})

test_that("CFB Ratings - SP+ stops before sending a request when no key is set", {
  # Offline: every other cfbd_*() checks the key first; SP+ used to send the
  # request anyway and get HTTP 401 back.
  sent <- FALSE
  local_mocked_bindings(
    has_cfbd_key = function() FALSE,
    get_req = function(full_url, proxy = NULL) {
      sent <<- TRUE
      httr2::response(status_code = 401)
    }
  )
  expect_error(cfbd_ratings_sp(year = 2019), "requires an API key")
  expect_false(sent)
})
