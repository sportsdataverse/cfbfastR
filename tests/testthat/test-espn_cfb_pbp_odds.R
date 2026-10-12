# The ESPN pre-game line, ported from sportsdataverse-py
# CFBPlayProcess.__helper_cfb_pickcenter. Oracle: fixtures/parity/odds_oracle.csv
# (data-raw/parity_odds_oracle.py), cross-checked against CFBD's lines for the
# same eight games (every spread and total equals one CFBD provider's).

oracle <- function() {
  utils::read.csv(testthat::test_path("fixtures", "parity", "odds_oracle.csv"))
}
pickcenters <- function() {
  jsonlite::fromJSON(testthat::test_path("fixtures", "parity", "odds_pickcenter.json"),
                     simplifyVector = FALSE)
}
item <- function(name, spread, ou, fav) {
  list(provider = list(name = name), spread = spread, overUnder = ou,
       homeTeamOdds = list(favorite = fav))
}

test_that("the pickcenter line matches sdv-py on the pre-2024 games", {
  o <- oracle()
  o <- o[o$odds_source == "summary_pickcenter", ]
  pc <- pickcenters()
  for (i in seq_len(nrow(o))) {
    line <- .espn_cfb_line_from_pickcenter(pc[[as.character(o$game_id[i])]])
    expect_equal(line$spread, o$spread[i], info = o$game_id[i])
    expect_equal(line$over_under, o$expected_over_under[i], info = o$game_id[i])
  }
})

test_that("a short or spread-less pickcenter yields no line", {
  expect_null(.espn_cfb_line_from_pickcenter(list()))
  expect_null(.espn_cfb_line_from_pickcenter(NULL))
  # one provider is not enough: sdv-py sends those games to the odds API
  expect_null(.espn_cfb_line_from_pickcenter(pickcenters()[["401112080"]][1]))
  expect_null(.espn_cfb_line_from_pickcenter(list(item("a", NULL, 50, TRUE), item("b", NULL, 51, TRUE))))
})

test_that("the odds-API line prefers ESPN BET, else the first provider", {
  items <- list(item("DraftKings", -3, 50, TRUE), item("ESPN BET", -2.5, 49.5, TRUE))
  expect_equal(.espn_cfb_line_from_odds(items), list(spread = -2.5, over_under = 49.5))
  expect_equal(.espn_cfb_line_from_odds(items[1]), list(spread = -3, over_under = 50))
  # the side comes from the flag: an away favourite listed as -2.5 is +2.5
  items[[2]]$homeTeamOdds$favorite <- FALSE
  expect_equal(.espn_cfb_line_from_odds(items)$spread, 2.5)
  # an ESPN BET item with no spread is no line, as in sdv-py
  items[[2]]$spread <- NULL
  expect_null(.espn_cfb_line_from_odds(items))
  expect_null(.espn_cfb_line_from_odds(list()))
})

test_that("the home line follows the favourite flag, not the raw sign", {
  expect_equal(.espn_cfb_home_line(7, TRUE), -7)
  expect_equal(.espn_cfb_home_line(-7, FALSE), 7)
  # no flag: ESPN's own spread is already the home line
  expect_equal(.espn_cfb_home_line(-3.5, NA), -3.5)
  expect_true(is.na(.espn_cfb_home_line(NA_real_, TRUE)))
})

test_that("a failed request warns instead of passing for an unlined game", {
  local_mocked_bindings(.espn_cfb_json = function(url) stop("HTTP 503 Service Unavailable"))
  expect_warning(line <- .espn_cfb_pbp_line(401752776, 2025), "odds.*503")
  expect_true(is.na(line$spread))
  # before 2024 both the summary and the odds request are attempted
  expect_warning(expect_warning(.espn_cfb_pbp_line(401112080, 2019), "summary"), "odds")
})

test_that("the resolved line matches sdv-py on all eight games (live)", {
  skip_on_cran()
  skip_if_offline("sports.core.api.espn.com")
  o <- oracle()
  for (i in seq_len(nrow(o))) {
    line <- .espn_cfb_pbp_line(o$game_id[i], o$season[i])
    expect_equal(line$spread, o$spread[i], info = o$game_id[i])
    expect_equal(line$over_under, o$expected_over_under[i], info = o$game_id[i])
  }
})

test_that("the v2 engine models the spread-based WP in both eras (live)", {
  skip_on_cran()
  skip_if_offline("site.api.espn.com")
  skip_if_not_installed("xgboost")
  o <- oracle()
  for (src in c("summary_pickcenter", "core_odds_api")) {
    g <- o[o$odds_source == src, ][1, ]
    pbp <- espn_cfb_pbp(g$game_id, epa_wpa = TRUE, engine = "v2")
    expect_equal(unique(pbp$spread), g$spread, info = src)
    expect_false(all(is.na(pbp$vegas_wp)), info = src)
  }
})
