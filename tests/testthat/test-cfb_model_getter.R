test_that(".cfb_model() loads on first use, keeps a model, and retries after a failed load", {
  rm(list = ls(.cfb_models), envir = .cfb_models)
  withr::defer(rm(list = ls(.cfb_models), envir = .cfb_models))

  calls <- 0L
  result <- NULL
  local_mocked_bindings(load_ep_model = function() {
    calls <<- calls + 1L
    result
  })

  expect_null(.cfb_model("ep_model"))
  expect_null(.cfb_model("ep_model"))
  expect_identical(calls, 2L)

  result <- structure(list(), class = "fake_booster")
  expect_s3_class(.cfb_model("ep_model"), "fake_booster")
  expect_s3_class(.cfb_model("ep_model"), "fake_booster")
  expect_identical(calls, 3L)

  expect_error(.cfb_model("qbr_model"), "Unknown model")
})
