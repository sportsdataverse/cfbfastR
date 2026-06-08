# Throttle CFBD requests during the test run.
#
# Back-to-back `cfbd_*()` calls inside `devtools::test()` / `R CMD check`
# reliably trip the CFBD rate limit (HTTP 429), which turns a green run
# into a sea of skip-if-empty guards. The CFBD layer routes every
# request through the internal `cfbfastR:::get_req()` helper, so the
# cleanest place to slow things down is to wrap that one helper for the
# duration of the test session -- the package code itself stays
# untouched.
#
# testthat sources every `setup-*.R` file once, before any test file
# runs. We hot-swap `get_req()` in the cfbfastR namespace with a copy
# that sleeps `cfbfastR.test_request_delay` seconds (default 1) before
# delegating to the original. Override per session with
# `options(cfbfastR.test_request_delay = 0)` for a quick local run, or
# `options(cfbfastR.test_request_delay = 2)` if 1s isn't enough.
#
# `withr::defer(..., teardown_env())` restores the original at the end
# of the test session so the patch doesn't leak into anything that
# loads cfbfastR afterwards in the same R process.
local({
  ns <- asNamespace("cfbfastR")
  if (!exists("get_req", envir = ns, inherits = FALSE)) return()
  original_get_req <- get("get_req", envir = ns, inherits = FALSE)

  throttled_get_req <- function(full_url, proxy = NULL) {
    Sys.sleep(getOption("cfbfastR.test_request_delay", default = 1))
    original_get_req(full_url, proxy = proxy)
  }

  utils::assignInNamespace("get_req", throttled_get_req, ns = "cfbfastR")
  withr::defer(
    utils::assignInNamespace("get_req", original_get_req, ns = "cfbfastR"),
    envir = testthat::teardown_env()
  )
})
