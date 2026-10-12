# The ESPN pre-game line, ported from sportsdataverse-py
# CFBPlayProcess.__helper_cfb_pickcenter. Oracle: fixtures/parity/odds_oracle.csv
# (data-raw/parity_odds_oracle.py), cross-checked against CFBD's lines for the
# same eight games (every spread and total equals one CFBD provider's).

oracle <- function() {
  utils::read.csv(testthat::test_path("fixtures", "parity", "odds_oracle.csv"))
}

test_that("the pickcenter line matches sdv-py on the pre-2024 games", {
  o <- oracle()
  o <- o[o$odds_source == "summary_pickcenter", ]
  pc <- jsonlite::fromJSON(testthat::test_path("fixtures", "parity", "odds_pickcenter.json"),
                           simplifyVector = FALSE)
  for (i in seq_len(nrow(o))) {
    line <- .espn_cfb_line_from_pickcenter(pc[[as.character(o$game_id[i])]])
    expect_equal(line$spread, o$spread[i], info = o$game_id[i])
    expect_equal(line$over_under, o$expected_over_under[i], info = o$game_id[i])
  }
})

test_that("the legacy engine's simplified-frame round trip keeps the line", {
  # espn_cfb_pbp() parses the summary with fromJSON() (a data frame with nested
  # data-frame columns) and hands the resolver records rebuilt from it.
  o <- oracle()
  o <- o[o$odds_source == "summary_pickcenter", ]
  pc <- jsonlite::fromJSON(testthat::test_path("fixtures", "parity", "odds_pickcenter.json"),
                           simplifyVector = FALSE)
  for (i in seq_len(nrow(o))) {
    raw <- jsonlite::fromJSON(jsonlite::toJSON(
      list(pickcenter = pc[[as.character(o$game_id[i])]]), auto_unbox = TRUE, digits = NA
    ))
    rt <- jsonlite::fromJSON(jsonlite::toJSON(raw[["pickcenter"]], digits = NA),
                             simplifyVector = FALSE)
    line <- .espn_cfb_line_from_pickcenter(rt)
    expect_equal(line$spread, o$spread[i], info = o$game_id[i])
    expect_equal(line$over_under, o$expected_over_under[i], info = o$game_id[i])
  }
})

test_that("the odds-API line prefers ESPN BET, else the first provider", {
  odds <- data.frame(provider_name = c("DraftKings", "ESPN BET"), spread = c(-3, -2.5),
                     over_under = c(50, 49.5), home_favorite = c(TRUE, TRUE))
  expect_equal(.espn_cfb_line_from_odds(odds), list(spread = -2.5, over_under = 49.5))
  expect_equal(.espn_cfb_line_from_odds(odds[1, ]), list(spread = -3, over_under = 50))
  # an away favourite listed with a negative number still lands on the away side
  odds$home_favorite <- FALSE
  expect_equal(.espn_cfb_line_from_odds(odds)$spread, 2.5)
  expect_null(.espn_cfb_line_from_odds(odds[0, ]))
  odds$spread <- NA_real_
  expect_null(.espn_cfb_line_from_odds(odds))
})

test_that("an empty pickcenter yields no line rather than a default", {
  expect_null(.espn_cfb_line_from_pickcenter(list()))
  # one provider is not enough: sdv-py sends those games to the odds API
  pc <- jsonlite::fromJSON(testthat::test_path("fixtures", "parity", "odds_pickcenter.json"),
                           simplifyVector = FALSE)
  expect_null(.espn_cfb_line_from_pickcenter(pc[["401112080"]][1]))
})

test_that("the home line follows the favourite flag, not the raw sign", {
  expect_equal(.espn_cfb_home_line(7, TRUE), -7)
  expect_equal(.espn_cfb_home_line(-7, FALSE), 7)
  # no flag: ESPN's own spread is already the home line
  expect_equal(.espn_cfb_home_line(-3.5, NA), -3.5)
  expect_true(is.na(.espn_cfb_home_line(NA_real_, TRUE)))
})

test_that("the resolved line matches sdv-py on all eight games (live)", {
  skip_on_cran()
  skip_if_offline("sports.core.api.espn.com")
  o <- oracle()
  pc <- jsonlite::fromJSON(testthat::test_path("fixtures", "parity", "odds_pickcenter.json"),
                           simplifyVector = FALSE)
  for (i in seq_len(nrow(o))) {
    g <- o$game_id[i]
    line <- .espn_cfb_pbp_line(g, pc[[as.character(g)]])
    expect_equal(line$spread, o$spread[i], info = g)
    expect_equal(line$over_under, o$expected_over_under[i], info = g)
  }
})

test_that("a 2025 game models the spread-based win probability (live)", {
  skip_on_cran()
  skip_if_offline("site.api.espn.com")
  skip_if_not_installed("xgboost")
  o <- oracle()
  g <- o$game_id[o$odds_source == "core_odds_api"][1]
  for (pbp in list(espn_cfb_pbp(g, epa_wpa = TRUE),
                   espn_cfb_pbp(g, epa_wpa = TRUE, engine = "v2"))) {
    expect_equal(unique(pbp$spread), o$spread[o$game_id == g])
    expect_false(all(is.na(pbp$vegas_wp)))
  }
})
