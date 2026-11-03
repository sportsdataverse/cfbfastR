# A "data.table" class after "tbl_df" sends tail() to data.table's method,
# whose x[i] then hits tibble's `[`, a column selector: "Can't subset columns
# past the end" (hoopR #88). cfbfastR_data objects must not carry it.

test_that("make_cfbfastR_data() output supports head()/tail()/print()", {
  out <- make_cfbfastR_data(data.frame(a = 1:10, b = letters[1:10]), "unit test data", Sys.time())

  expect_s3_class(out, "cfbfastR_data")
  expect_false(inherits(out, "data.table"))
  expect_equal(tail(out)$a, 5:10)
  expect_equal(head(out, 3)$a, 1:3)
  expect_no_error(capture.output(print(out)))
})

test_that("every exported load_*() result supports head()/tail() (offline)", {
  fake <- function(...) data.table::data.table(a = 1:10, b = letters[1:10])
  local_mocked_bindings(
    rds_from_url = fake, parquet_from_url = fake, csv_from_url = fake,
    # load_cfb_schedules() / _rosters() / _teams() wrap the CFBD API
    cfbd_game_info = fake, cfbd_team_roster = fake, cfbd_team_info = fake
  )

  loaders <- grep("^load_", getNamespaceExports("cfbfastR"), value = TRUE)
  expect_gt(length(loaders), 50)
  for (f in loaders) {
    x <- suppressMessages(getExportedValue("cfbfastR", f)())
    expect_s3_class(x, "cfbfastR_data")
    expect_false(inherits(x, "data.table"), label = f)
    expect_equal(nrow(tail(x)), 6L, label = f)
    expect_equal(nrow(head(x, 3)), 3L, label = f)
  }
})
