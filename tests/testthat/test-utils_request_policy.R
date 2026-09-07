test_that("build_req() carries a retry budget that survives sustained CFBD throttling", {
  # Offline by design: build_req() only constructs the request, and cfbd_key()
  # returns NA rather than erroring when CFBD_API_KEY is unset, so this needs
  # neither network nor credentials.
  req <- cfbfastR:::build_req("https://api.collegefootballdata.com/games")

  # httr2 already retries 429/503 (retry_is_transient) and honours a
  # Retry-After header; what this package controls is the budget. The previous
  # 3 tries / ~1-9s of backoff covered an incidental 429 but not the sustained
  # throttling a parallel caller produces -- when it ran out, check_status()
  # turned the surviving 429 into an error that every cfbd_*() tryCatch reports
  # as "no data available", making a throttle indistinguishable from an empty
  # result.
  expect_gte(req$policies$retry_max_tries, 6L)
  expect_gte(req$policies$retry_max_wait, 120)

  # A backoff must still exist for servers that send no Retry-After header.
  expect_type(req$policies$retry_backoff, "closure")
  expect_true(is.finite(req$policies$retry_backoff(1)))
})

test_that("build_req() leaves HTTP status handling to check_status()", {
  req <- cfbfastR:::build_req("https://api.collegefootballdata.com/games")

  # req_error(is_error = ~FALSE) is deliberate: the response is handed back so
  # check_status() can raise the "The CFBD API returned HTTP ..." message the
  # cfbd_*() family reports. If this ever flips to TRUE, httr2 would abort
  # first and that message would never be produced.
  expect_type(req$policies$error_is_error, "closure")
  expect_false(req$policies$error_is_error(
    structure(list(status_code = 429L), class = "httr2_response")
  ))
})

# No test asserts that get_req() delegates to build_req(): setup-cfbd-throttle.R
# hot-swaps get_req() in the cfbfastR namespace for the whole test session, so
# anything inspecting it here sees the throttle wrapper rather than the package
# function. build_req() is not swapped, which is why the policy assertions above
# target it directly.
