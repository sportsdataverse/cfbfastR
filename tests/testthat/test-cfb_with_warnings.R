test_that(".cfb_with_warnings() names the wrapper and keeps the result", {
  f <- function() {
    df <- data.frame()
    tryCatch(
      expr = .cfb_with_warnings("my_wrapper", {
        x <- as.integer("not a number") # warns: NAs introduced by coercion
        df <- data.frame(x = x, y = 1L)
      }),
      error = function(e) NULL
    )
    df
  }
  expect_warning(out <- f(), class = "cfbfastR_warning", regexp = "my_wrapper\\(\\): .*coercion")
  expect_equal(nrow(out), 1L)
  expect_identical(out$y, 1L)
})

test_that("nested .cfb_with_warnings() raises one warning, named by the inner wrapper", {
  w <- testthat::capture_warnings(
    .cfb_with_warnings("outer", .cfb_with_warnings("inner", warning("boom")))
  )
  expect_length(w, 1L)
  expect_match(w, "inner\\(\\): boom")
})

test_that(".cfb_with_warnings() keeps return(), error handling and the original class", {
  early <- function() {
    tryCatch(expr = .cfb_with_warnings("early", {
      return("returned")
      "not reached"
    }), error = function(e) "error")
  }
  expect_identical(early(), "returned")

  expect_warning(caught <- tryCatch(
    expr = .cfb_with_warnings("caught", {
      warning("first")
      stop("then failed")
    }),
    error = function(e) conditionMessage(e)
  ), class = "cfbfastR_warning")
  expect_identical(caught, "then failed")

  custom <- function() warning(warningCondition("deprecated thing", class = "my_deprecation"))
  expect_no_warning(suppressWarnings(.cfb_with_warnings("cls", custom()), classes = "my_deprecation"))
})

test_that("a CFBD wrapper returns its rows when parsing warns", {
  # Before 3.1.0 an empty tryCatch(warning =) handler stopped the parse at the
  # first warning and returned an empty frame. clean_names() warns here, ahead
  # of the first assignment, so the old behaviour returns 0 rows.
  body <- '[{"location":"Arizona","nickname":"Cardinals","displayName":"Arizona Cardinals","logo":"x.png"}]'
  local_mocked_bindings(
    get_req = function(...) {
      httr2::response(
        status_code = 200L,
        headers = list(`Content-Type` = "application/json"),
        body = charToRaw(body)
      )
    },
    validate_api_key = function(...) invisible(TRUE)
  )
  local_mocked_bindings(
    clean_names = function(dat, ...) {
      warning("synthetic parse warning")
      names(dat) <- c("location", "nickname", "display_name", "logo")
      dat
    },
    .package = "janitor"
  )
  expect_warning(out <- cfbd_draft_teams(), class = "cfbfastR_warning",
                 regexp = "cfbd_draft_teams\\(\\): synthetic parse warning")
  expect_equal(nrow(out), 1L)
  expect_identical(out$nfl_location, "Arizona")
})
