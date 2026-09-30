


cols1 <- c("stat", "team1", "team2")
cols2 <- c(
  "team", "ppa_plays",
  "ppa_overall_total", "ppa_overall_quarter1", "ppa_overall_quarter2", "ppa_overall_quarter3", "ppa_overall_quarter4",
  "ppa_passing_total", "ppa_passing_quarter1", "ppa_passing_quarter2", "ppa_passing_quarter3", "ppa_passing_quarter4",
  "ppa_rushing_total", "ppa_rushing_quarter1", "ppa_rushing_quarter2", "ppa_rushing_quarter3", "ppa_rushing_quarter4",
  "cumulative_ppa_plays", "cumulative_ppa_overall_total", "cumulative_ppa_overall_quarter1", "cumulative_ppa_overall_quarter2",
  "cumulative_ppa_overall_quarter3", "cumulative_ppa_overall_quarter4",
  "cumulative_ppa_passing_total", "cumulative_ppa_passing_quarter1", "cumulative_ppa_passing_quarter2",
  "cumulative_ppa_passing_quarter3", "cumulative_ppa_passing_quarter4", "cumulative_ppa_rushing_total",
  "cumulative_ppa_rushing_quarter1", "cumulative_ppa_rushing_quarter2", "cumulative_ppa_rushing_quarter3",
  "cumulative_ppa_rushing_quarter4", "success_rates_overall_total",
  "success_rates_overall_quarter1", "success_rates_overall_quarter2", "success_rates_overall_quarter3", "success_rates_overall_quarter4",
  "success_rates_standard_downs_total", "success_rates_standard_downs_quarter1", "success_rates_standard_downs_quarter2", "success_rates_standard_downs_quarter3", "success_rates_standard_downs_quarter4",
  "success_rates_passing_downs_total", "success_rates_passing_downs_quarter1", "success_rates_passing_downs_quarter2", "success_rates_passing_downs_quarter3", "success_rates_passing_downs_quarter4",
  "explosiveness_overall_total", "explosiveness_overall_quarter1", "explosiveness_overall_quarter2", "explosiveness_overall_quarter3", "explosiveness_overall_quarter4",
  "rushing_power_success", "rushing_stuff_rate", "rushing_line_yds", "rushing_line_yds_avg", "rushing_second_lvl_yds", "rushing_second_lvl_yds_avg",
  "rushing_open_field_yds", "rushing_open_field_yds_avg", "havoc_total", "havoc_front_seven", "havoc_db", "scoring_opps_opportunities", "scoring_opps_points", "scoring_opps_pts_per_opp", "field_pos_avg_start", "field_pos_avg_starting_predicted_pts")
test_that("CFB Game Box Advanced", {
  skip_on_cran()
  x <- cfbd_game_box_advanced(game_id = 401012356)
  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }

  y <- cfbd_game_box_advanced(game_id = 401110720)
  if (is.null(y) || !is.data.frame(y) || nrow(y) == 0L) {
    skip("CFBD rate-limited or returned no rows")
  }
  expect_equal(nrow(x), 2)
  expect_equal(nrow(y), 2)
  expect_setequal(colnames(x), cols2)
  expect_setequal(colnames(y), cols2)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})

# Serve a captured CFBD response (fixtures/cfbd/README.md) in place of get_req().
local_cfbd_box_fixture <- function(file, env = parent.frame()) {
  local_mocked_bindings(
    validate_api_key = function() invisible(TRUE),
    get_req = function(full_url, proxy = NULL) {
      con <- gzfile(test_path("fixtures", "cfbd", file), "rb")
      on.exit(close(con))
      httr2::response(status_code = 200L, url = full_url,
                      headers = list(`Content-Type` = "application/json"),
                      body = readBin(con, "raw", n = 1e7))
    },
    .env = env
  )
}
box_fixture_json <- function(file) {
  con <- gzfile(test_path("fixtures", "cfbd", file), "rb")
  on.exit(close(con))
  jsonlite::fromJSON(rawToChar(readBin(con, "raw", n = 1e7)), flatten = TRUE)
}

test_that("CFBD - Game Box Advanced pairs every section by team, not position", {
  # CFBD lists `havoc` in the opposite team order to every other section
  # (Georgia | Alabama vs Alabama | Georgia); positional pairing gave each team
  # its opponent's havoc.
  local_cfbd_box_fixture("game_box_advanced_401628374.json.gz")
  x <- cfbd_game_box_advanced(game_id = 401628374)
  raw <- box_fixture_json("game_box_advanced_401628374.json.gz")$teams
  for (tm in c("Alabama", "Georgia")) {
    h <- raw$havoc[raw$havoc$team == tm, ]
    p <- raw$ppa[raw$ppa$team == tm, ]
    expect_equal(x$havoc_total[x$team == tm], h$total)
    expect_equal(x$havoc_front_seven[x$team == tm], h$frontSeven)
    expect_equal(x$havoc_db[x$team == tm], h$db)
    expect_equal(x$ppa_overall_total[x$team == tm], p$overall.total)
  }
  long <- cfbd_game_box_advanced(game_id = 401628374, long = TRUE)
  expect_equal(long$team1[long$stat == "havoc_total"],
               as.character(raw$havoc$total[raw$havoc$team == long$team1[long$stat == "ppa_team"]]))
})

test_that("CFBD - Game Box Advanced keeps its 69 columns when 2025 adds sections", {
  # 2025 payloads fill `passing` and `rushingAdvanced`; they used to land as
  # ~550 raw dotted columns (one mangled to `rushing_dvanced.*`) with coercion
  # warnings.
  local_cfbd_box_fixture("game_box_advanced_401628374.json.gz")
  cols_2024 <- colnames(cfbd_game_box_advanced(game_id = 401628374))
  local_cfbd_box_fixture("game_box_advanced_401752677.json.gz")
  expect_no_warning(x <- cfbd_game_box_advanced(game_id = 401752677))
  expect_equal(ncol(x), 69L)
  expect_identical(colnames(x), cols_2024)
  expect_setequal(x$team, c("Ohio State", "Texas"))
})

# Serve a recorded payload after editing it, to reach the paths CFBD rarely sends.
local_cfbd_box_edited <- function(file, edit, env = parent.frame()) {
  con <- gzfile(test_path("fixtures", "cfbd", file), "rb")
  j <- jsonlite::fromJSON(rawToChar(readBin(con, "raw", n = 1e7)), simplifyVector = FALSE)
  close(con)
  body <- charToRaw(as.character(jsonlite::toJSON(edit(j), auto_unbox = TRUE, null = "null", digits = NA)))
  local_mocked_bindings(
    validate_api_key = function() invisible(TRUE),
    get_req = function(full_url, proxy = NULL) {
      httr2::response(status_code = 200L, url = full_url,
                      headers = list(`Content-Type` = "application/json"), body = body)
    },
    .env = env
  )
}

test_that("CFBD - Game Box Advanced warns instead of guessing when team names do not match", {
  local_cfbd_box_edited("game_box_advanced_401628374.json.gz", function(j) {
    j$teams$havoc[[1]]$team <- "Somebody Else"
    j
  })
  expect_warning(x <- cfbd_game_box_advanced(game_id = 401628374), "havoc")
  expect_equal(nrow(x), 2L)
})

test_that("CFBD - Game Box Advanced without a ppa section keeps the other sections", {
  local_cfbd_box_edited("game_box_advanced_401628374.json.gz", function(j) {
    j$teams$ppa <- list()
    j
  })
  x <- cfbd_game_box_advanced(game_id = 401628374, long = TRUE)
  expect_true("havoc_total" %in% x$stat)
})
