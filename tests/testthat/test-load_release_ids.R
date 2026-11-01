# Offline: every release read is mocked or served from a local parquet file.

# 18-digit ESPN play ids; above 2^53 these two collide as doubles.
play_ids <- c("401767509101849920", "401767509101849921")

write_play_fixture <- function(id_col = "id", null_flag = FALSE) {
  path <- withr::local_tempfile(fileext = ".parquet", .local_envir = parent.frame())
  flag <- if (null_flag) {
    arrow::Array$create(c(NA, NA), type = arrow::null())
  } else {
    arrow::Array$create(c(TRUE, FALSE))
  }
  cols <- list(game_id = c(401767509L, 401767509L), bit64::as.integer64(play_ids), flag)
  names(cols) <- c("game_id", id_col, "overUnderAvailable")
  arrow::write_parquet(do.call(arrow::arrow_table, cols), path)
  path
}

file_url <- function(path) paste0("file:///", normalizePath(path, winslash = "/"))

test_that("parquet ids stay exact and unique as character", {
  skip_if_not_installed("arrow")
  skip_if_not_installed("bit64")

  expect_length(unique(as.double(play_ids)), 1L)

  x <- parquet_from_url(file_url(write_play_fixture(null_flag = TRUE)))
  expect_s3_class(x$id, "integer64")
  expect_type(x$overUnderAvailable, "logical")
  expect_false(inherits(x$overUnderAvailable, "vctrs_unspecified"))

  x <- ids_to_character(x, "id")
  expect_type(x$id, "character")
  expect_identical(x$id, play_ids)
  expect_type(x$game_id, "integer")
})

test_that("pbp, play_participants and model_pbp loaders read parquet and return character play ids", {
  skip_if_not_installed("arrow")
  skip_if_not_installed("bit64")

  cases <- list(
    list(fn = load_espn_cfb_pbp, col = "id", url = "espn_cfb_pbp/play_by_play_"),
    list(fn = load_espn_cfb_play_participants, col = "play_id",
         url = "espn_cfb_play_participants/play_participants_"),
    list(fn = load_espn_cfb_model_pbp, col = "id", url = "espn_cfb_model_pbp/model_pbp_")
  )
  real_parquet_from_url <- parquet_from_url

  for (case in cases) {
    # one season with an all-null column, one with it populated: must still bind
    files <- c(write_play_fixture(case$col, null_flag = TRUE),
               write_play_fixture(case$col, null_flag = FALSE))
    urls <- character()
    local_mocked_bindings(parquet_from_url = function(url) {
      urls <<- c(urls, url)
      real_parquet_from_url(file_url(files[length(urls)]))
    })

    out <- case$fn(c(2024, 2025))
    expect_s3_class(out, "cfbfastR_data")
    expect_equal(basename(urls), paste0(basename(case$url), c(2024, 2025), ".parquet"))
    expect_true(all(grepl(case$url, urls, fixed = TRUE)))
    expect_type(out[[case$col]], "character")
    expect_identical(out[[case$col]], rep(play_ids, 2))
    expect_length(unique(out[[case$col]]), 2L)
    expect_type(out$overUnderAvailable, "logical")
  }
})

test_that("load_ncaa_mfb_pbp_cfbfastr returns character id_play", {
  skip_if_not_installed("bit64")

  local_mocked_bindings(rds_from_url = function(url) {
    data.table::data.table(id_play = bit64::as.integer64(play_ids))
  })
  out <- load_ncaa_mfb_pbp_cfbfastr(2025)
  expect_identical(out$id_play, play_ids)
})

test_that("season floors match the published release files", {
  urls <- character()
  local_mocked_bindings(
    rds_from_url = function(url) {
      urls <<- c(urls, url)
      data.table::data.table(season = 1L)
    },
    parquet_from_url = function(url) {
      urls <<- c(urls, url)
      data.table::data.table(season = 1L)
    }
  )

  load_espn_cfb_power_index(2005)
  load_cfb_returning_production(2004)
  load_cfb_schedule_crosswalk(c(2004, 2010, 2013))
  load_cfb_teams_crosswalk(2004)
  expect_equal(basename(urls), c(
    "power_index_2005.rds", "cfb_returning_production_2004.parquet",
    "cfb_schedule_crosswalk_2004.parquet", "cfb_schedule_crosswalk_2010.parquet",
    "cfb_schedule_crosswalk_2013.parquet", "cfb_teams_crosswalk_2004.parquet"
  ))

  expect_error(load_espn_cfb_power_index(2004))
  expect_error(load_cfb_returning_production(2003))
  # the crosswalk tag has no files for 2005-2009 or 2011-2012
  expect_error(load_cfb_schedule_crosswalk(2005))
  expect_error(load_cfb_teams_crosswalk(2011))
  expect_error(load_cfb_schedule_crosswalk(2003))

  urls <- character()
  load_cfb_teams_crosswalk(TRUE)
  expect_equal(
    basename(urls),
    paste0("cfb_teams_crosswalk_", c(2004, 2010, 2013:most_recent_cfb_season()), ".parquet")
  )
})
