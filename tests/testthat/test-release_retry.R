# A slow release download used to hit R's default 60 s timeout, and the
# loader returned the other seasons with only a vague warning.

# A reader that fails `fails` times, then returns `value`; records each call.
flaky <- function(fails, value = data.frame(x = 1)) {
  calls <- 0L
  timeouts <- numeric()
  f <- function(url) {
    calls <<- calls + 1L
    timeouts <<- c(timeouts, getOption("timeout"))
    if (calls <= fails) stop("Timeout of 60 seconds was reached")
    value
  }
  list(read = f, calls = function() calls, timeouts = function() timeouts)
}

test_that("a transient failure is retried with a raised timeout, then restored", {
  withr::local_options(timeout = 60)
  r <- flaky(2)
  expect_no_warning(out <- .read_release_asset("https://x/a_2024.rds", r$read))
  expect_equal(out, data.frame(x = 1))
  expect_equal(r$calls(), 3L)
  expect_equal(r$timeouts(), rep(150, 3))
  expect_equal(getOption("timeout"), 60)
})

test_that("a larger user timeout is kept", {
  withr::local_options(timeout = 3600)
  r <- flaky(0)
  .read_release_asset("https://x/a_2024.rds", r$read)
  expect_equal(r$timeouts(), 3600)
  expect_equal(getOption("timeout"), 3600)
})

test_that("a persistent failure warns with the url and returns a try-error", {
  withr::local_options(timeout = 60)
  r <- flaky(Inf)
  expect_warning(
    out <- .read_release_asset("https://x/a_2024.rds", r$read),
    "a_2024.rds.*incomplete"
  )
  expect_s3_class(out, "try-error")
  expect_equal(r$calls(), 3L)
  expect_equal(getOption("timeout"), 60)
})

test_that("a 404 is not retried", {
  calls <- 0L
  read <- function(url) {
    calls <<- calls + 1L
    warning("cannot open URL 'u': HTTP status was '404 Not Found'")
    stop("cannot open the connection")
  }
  expect_warning(.read_release_asset("https://x/a_1800.rds", read), "a_1800.rds")
  expect_equal(calls, 1L)
})

test_that("a loader keeps the seasons that load and names the one that failed", {
  withr::local_options(timeout = 60)
  calls <- 0L
  local_mocked_bindings(.read_rds_url = function(url) {
    calls <<- calls + 1L
    if (endsWith(url, "_2022.rds")) stop("Timeout of 60 seconds was reached")
    data.frame(season = 2021L, game_id = 1L)
  })
  expect_warning(
    out <- load_cfb_pbp(2021:2022),
    "play_by_play_2022.rds", fixed = TRUE
  )
  expect_equal(nrow(out), 1L)
  expect_equal(out$season, 2021L)
  expect_equal(calls, 4L)
  expect_s3_class(out, "cfbfastR_data")
  expect_false("data.table" %in% class(out))
  expect_equal(getOption("timeout"), 60)
})

test_that("parquet_from_url retries a download that does not parse", {
  skip_if_not_installed("arrow")
  src <- withr::local_tempfile(fileext = ".parquet")
  arrow::write_parquet(data.frame(x = 1:2), src)
  calls <- 0L
  local_mocked_bindings(.download_url = function(url, dest) {
    calls <<- calls + 1L
    if (calls == 1L) return(writeBin(charToRaw("truncated"), dest))
    file.copy(src, dest, overwrite = TRUE)
  })
  expect_no_warning(out <- parquet_from_url("https://x/a.parquet"))
  expect_equal(out$x, 1:2)
  expect_equal(calls, 2L)
})

test_that("the low-level readers read a local file and reject an empty one", {
  withr::local_options(download.file.method = "auto")
  file_url <- function(path) {
    path <- normalizePath(path, winslash = "/")
    paste0("file://", if (!startsWith(path, "/")) "/", path)
  }
  src <- withr::local_tempfile(fileext = ".rds")
  saveRDS(data.frame(x = 1:2), src, compress = FALSE)
  expect_equal(.read_rds_url(file_url(src)), data.frame(x = 1:2))
  expect_equal(rds_from_url(file_url(src))$x, 1:2)

  dest <- withr::local_tempfile()
  .download_url(file_url(src), dest)
  expect_equal(readRDS(dest), data.frame(x = 1:2))

  empty <- withr::local_tempfile()
  file.create(empty)
  expect_error(.download_url(file_url(empty), withr::local_tempfile()), "empty")
})

test_that("warnings from a read that succeeds are passed on", {
  read <- function(url) {
    warning("a note from the reader")
    1
  }
  expect_warning(out <- .read_release_asset("https://x/a_2024.rds", read), "a note from the reader")
  expect_equal(out, 1)
})

test_that("parquet_from_url returns an empty table when the download keeps failing", {
  skip_if_not_installed("arrow")
  local_mocked_bindings(.download_url = function(url, dest) stop("Timeout of 150 seconds was reached"))
  expect_warning(out <- parquet_from_url("https://x/b_2024.parquet"), "b_2024.parquet", fixed = TRUE)
  expect_equal(nrow(out), 0L)
})

# A fake download that writes `lines` as the csv.
fake_download <- function(lines) {
  function(url, dest, ...) {
    expect_equal(list(...), list(method = "libcurl"))
    writeLines(lines, dest)
  }
}

test_that("the games csv read is retried and passes its arguments on", {
  withr::local_options(timeout = 60)
  calls <- 0L
  urls <- character()
  local_mocked_bindings(
    .download_url = function(url, dest, ...) {
      urls <<- c(urls, url)
      expect_equal(list(...), list(method = "libcurl"))
      writeLines("x", dest)
    },
    csv_from_url = function(file, ...) {
      calls <<- calls + 1L
      expect_equal(getOption("timeout"), 150)
      if (calls == 1L) stop("Timeout of 60 seconds was reached")
      data.table::data.table(file = file, ...)
    }
  )
  expect_no_warning(out <- load_games())
  expect_equal(calls, 2L)
  expect_match(urls, "games_in_data_repo.csv", fixed = TRUE)
  # fread() reads the downloaded copy, which is deleted afterwards.
  expect_false(file.exists(out$file))
  expect_equal(.release_csv_from_url("https://x/a.csv", sep = ",")$sep, ",")
  expect_equal(getOption("timeout"), 60)
})

test_that("a games csv that keeps failing warns with the url, then raises", {
  calls <- 0L
  local_mocked_bindings(.download_url = function(url, dest, ...) {
    calls <<- calls + 1L
    stop("Timeout of 150 seconds was reached")
  })
  expect_error(
    expect_warning(load_games(), "games_in_data_repo.csv", fixed = TRUE),
    "Timeout of 150 seconds"
  )
  expect_equal(calls, 3L)
})

test_that("a release csv is read from a local file with libcurl, whatever the option says", {
  # "curl" would shell out to the curl binary; the helper must not.
  withr::local_options(download.file.method = "curl")
  src <- withr::local_tempfile(fileext = ".csv")
  data.table::fwrite(data.frame(season = 2024L, game_id = 1:2), src)
  path <- normalizePath(src, winslash = "/")
  out <- .release_csv_from_url(paste0("file://", if (!startsWith(path, "/")) "/", path))
  expect_equal(out$game_id, 1:2)
})

# fread() stops at a row with too many fields and returns the rows above it,
# with only a warning.
partial_csv <- c("season,game_id", "2014,1", "2015,2,3", "2016,4")

test_that("a strict release csv read turns a fread() warning into an error", {
  local_mocked_bindings(.download_url = fake_download(partial_csv))
  expect_warning(out <- .release_csv_from_url("https://x/g.csv"), "Stopped early")
  expect_equal(nrow(out), 1L)
  expect_error(
    suppressWarnings(.release_csv_from_url("https://x/g.csv", strict = TRUE)),
    "may be partial.*Stopped early"
  )
})

test_that("build_cfb_db(rebuild = TRUE) keeps the table when the games index read fails", {
  skip_if_not_installed("RSQLite")
  con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
  withr::defer(DBI::dbDisconnect(con))
  DBI::dbWriteTable(con, "cfbfastR_pbp", data.frame(season = c(2014L, 2015L), game_id = 1:2))
  local_mocked_bindings(
    .download_url = fake_download(partial_csv),
    load_cfb_pbp = function(...) stop("load_cfb_pbp() must not run")
  )
  expect_error(
    suppressWarnings(build_cfb_db("cfbfastR_pbp", con, rebuild = TRUE)),
    "games_in_data_repo.csv"
  )
  expect_true(DBI::dbExistsTable(con, "cfbfastR_pbp"))
  expect_equal(DBI::dbGetQuery(con, "SELECT season, game_id FROM cfbfastR_pbp")$game_id, 1:2)

  # A download that fails outright aborts the same way.
  local_mocked_bindings(.download_url = function(url, dest, ...) stop("HTTP 503"))
  expect_error(
    suppressWarnings(build_cfb_db("cfbfastR_pbp", con, rebuild = TRUE)),
    "left unchanged"
  )
  expect_equal(nrow(DBI::dbReadTable(con, "cfbfastR_pbp")), 2L)
})
