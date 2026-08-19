### pbp-to-boxscore parity gate.
###
### Ported from sdv-py's `tools/validation/checks/boxscore_parity`. The per-play
### parity tests check a play against itself; this checks whether the flags ADD
### UP to ESPN's official team box, which is the only cheap end-to-end judge of
### whether parsing put the right events on the right TEAM. An attribution bug
### leaves every per-play assertion green and shows up here immediately.
###
### Floors are measured from real data, never guessed, and are per-stat because
### parity is strongly era-dependent: modern seasons reconcile above 90% on the
### count stats while 2004 yardage sits near zero. A single pooled threshold
### would be simultaneously too loose for one era and impossible for the other.

pbp_path <- testthat::test_path("fixtures", "parity", "boxparity_pbp.parquet")
box_path <- testthat::test_path("fixtures", "parity", "boxparity_box.parquet")

skip_if_no_fixture <- function() {
  testthat::skip_if_not(file.exists(pbp_path) && file.exists(box_path),
                        "boxscore-parity fixtures not generated")
  testthat::skip_if_not_installed("arrow")
}

measured <- function() {
  p <- as.data.frame(arrow::read_parquet(pbp_path))
  b <- as.data.frame(arrow::read_parquet(box_path))
  # Both frames carry fixture_game_id; the pbp side also carries sdv-py's own
  # game_id with the same value, so drop it rather than colliding the two.
  p$game_id <- as.character(p$fixture_game_id)
  p$fixture_game_id <- NULL
  b$game_id <- as.character(b$fixture_game_id)
  b$fixture_game_id <- NULL
  b$team_key <- as.character(b$team_key)
  .pbp_boxscore_parity(.pbp_boxscore_aggregate(p), b)
}

test_that("the aggregation encodes the three NCAA conventions", {
  # These are the definitions that were PROVEN against the box, and two are the
  # opposite of the NFL's. Getting any of them wrong shifts a whole stat.
  # The last row gives B a possession of its own. That is not padding: the
  # penalty totals are LEFT-joined onto the offensive aggregate (as sdv-py does),
  # so a team with no offensive snaps carries no row to attach its penalties to.
  # Every real game has both teams on offence, so this is the realistic shape.
  pbp <- data.frame(
    game_id = "G1", season = 2024,
    pos_team_id = c("A", "A", "A", "A", "A", "B"),
    def_pos_team_id = c("B", "B", "B", "B", "B", "A"),
    rush = c(1, 0, 0, 0, 0, 0), pass = c(0, 1, 1, 0, 0, 0),
    completion = c(0, 1, 0, 0, 0, 0), sack = c(0, 0, 1, 0, 0, 0),
    int = 0, fumble_lost = 0,
    penalty_flag = c(0, 0, 0, 1, 1, 0),
    penalty_yards_signed = c(0, 0, 0, 15, -5, 0),
    yds_rushed = c(7, 0, 0, 0, 0, 0), yds_receiving = c(0, 12, 0, 0, 0, 0),
    yds_sacked = c(0, 0, -8, 0, 0, 0), stringsAsFactors = FALSE
  )
  a <- .pbp_boxscore_aggregate(pbp)
  ta <- a[a$team_key == "A", ]
  tb <- a[a$team_key == "B", ]

  # NCAA charges a sack to RUSHING -- attempt and yardage both.
  expect_equal(ta$rush_att, 2)
  expect_equal(ta$rush_yds, -1)
  # Pass attempts EXCLUDE sacks.
  expect_equal(ta$pass_att, 1)
  expect_equal(ta$pass_yds, 12)
  # A penalty belongs to the team that COMMITTED it: positive signed yardage
  # means the offence gained, so the defence was flagged.
  expect_equal(tb$penalties, 1)
  expect_equal(tb$penalty_yds, 15)
  expect_equal(ta$penalties, 1)
  expect_equal(ta$penalty_yds, 5)
})

test_that("turnovers are interceptions plus fumbles lost", {
  pbp <- data.frame(
    game_id = "G1", season = 2024, pos_team_id = "A", def_pos_team_id = "B",
    rush = 0, pass = c(1, 1, 0), completion = 0, sack = 0,
    int = c(1, 0, 0), fumble_lost = c(0, 0, 1),
    penalty_flag = 0, penalty_yards_signed = 0,
    yds_rushed = 0, yds_receiving = 0, yds_sacked = 0, stringsAsFactors = FALSE
  )
  a <- .pbp_boxscore_aggregate(pbp)
  expect_equal(a$interceptions, 1)
  expect_equal(a$fumbles_lost, 1)
  expect_equal(a$turnovers, 2)
})

test_that("an empty frame yields the documented schema, not an error", {
  a <- .pbp_boxscore_aggregate(data.frame())
  expect_s3_class(a, "data.frame")
  expect_equal(nrow(a), 0L)
  expect_true(all(c("game_id", "team_key", "turnovers", "penalty_yds") %in% names(a)))
})

test_that("parity against ESPN's own box clears the measured floors", {
  skip_if_no_fixture()
  m <- measured()
  expect_gt(nrow(m), 0L)

  # Floors measured 2026-08-19 over the 60-game fixture corpus (2004-2025, so
  # they are deliberately loose -- the pre-2014 games drag the yardage stats
  # down hard). Raise them only after confirming a parity CHANGE is an
  # improvement; never lower one to silence a regression you have not explained.
  floors <- .pbp_boxscore_parity_floors
  for (i in seq_len(nrow(m))) {
    st <- m$stat[i]
    if (!st %in% names(floors)) next
    expect_gte(m$rate[i], floors[[st]],
               label = paste0(st, " parity ", round(m$rate[i], 3),
                              " (n=", m$n[i], ")"))
  }
})

test_that("the parity measurement is not silently grading a subset", {
  skip_if_no_fixture()
  m <- measured()
  # A null join key is removed by the join, which SHIFTS the measured rate with
  # nothing reported -- the check would quietly grade itself on whatever
  # matched. Every stat must be measured over a comparable number of rows.
  expect_gt(min(m$n), 50L)
  expect_lt(max(m$n) - min(m$n), max(m$n) * 0.5)
})
