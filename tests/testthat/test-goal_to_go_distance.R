# Some feeds send distance = 0 on goal-to-go downs. The EP model was trained on
# sdv-py's ESPN output, which sets them to yards-to-goal (sportsdataverse-py
# cfb_pbp.py, the "start.distance" goal rewrite). Rows below are real: game
# 401752671 (2025 wk 1, LSU at Clemson) from ESPN and CFBD, plus 2019 ESPN
# kickoff and timeout rows that carry distance 0 but are not goal-to-go.

test_that("ESPN goal-to-go downs sent as distance 0 get the yards to the goal", {
  x <- .goal_to_go_distance(
    distance      = c(0, 0, 0, 0, 7, 0, 0, 0),
    down          = c(1, 2, 3, 1, 2, 1, 3, 1),
    yards_to_goal = c(4, 14, 14, 5, 70, 65, 8, 19),
    text = c("1st & Goal at LSU 4", "2nd & 0 at LSU 14", "3rd & 0 at LSU 14",
             "1st & Goal at CLEM 5", "2nd & 7 at LSU 30", NA, NA, "1st & 0 at WYO 19")
  )
  # "Goal" downs fixed, as sdv-py does. "& 0 at" rows are left for
  # .espn_amp0_distance(), which needs the previous snap; a real 2nd & 7, a
  # kickoff (down 1, no text, at the 65) and a timeout row are untouched.
  expect_identical(x, c(4, 0, 0, 5, 7, 0, 0, 0))
  # An old payload with no text column must not open the gate for kickoffs.
  expect_identical(.goal_to_go_distance(0, 1, 65, text = NA_character_), 0)
})

test_that("games that already send the real distance are unchanged", {
  # 401752677 (Texas at Ohio State) sends goal-to-go distances as-is.
  x <- .goal_to_go_distance(c(6, 4, 2), c(1, 2, 3), c(6, 4, 2),
                            text = c("1st & Goal at TEX 6", "2nd & Goal at TEX 4", "3rd & Goal at TEX 2"))
  expect_identical(x, c(6, 4, 2))
})

test_that("CFBD goal-to-go downs sent as distance 0 are fixed without a text", {
  # CFBD /plays for 401752671: "2nd & Goal at CLEM 4" pass-interference play
  # came as down 2, distance 0, yardsToGoal 4; a normal 1st & 10 alongside.
  # Without a text only the 10 and in qualify: a 1st & 0 at the 25 (an
  # overtime start) is a missing distance, not goal-to-go.
  x <- .goal_to_go_distance(distance = c(0L, 10L, 0L), down = c(2L, 1L, 1L),
                            yards_to_goal = c(4L, 75L, 25L))
  expect_equal(x, c(4, 10, 0))
})

test_that("CFBD and ESPN agree on 401752671's EPA on every play and engine", {
  skip_on_cran()
  skip_if(!has_cfbd_key(), "CFBD API key not available")
  # ESPN sends two "Goal" downs of this game as distance 0, two "& 0 at LSU 14"
  # downs after a sack, and CFBD one "2nd & Goal at CLEM 4" as 0. Scored raw,
  # those plays and the plays before them (whose end state reads the next
  # play's distance) disagreed on EPA between the sources.
  espn_ids <- c("401752671102945901", "401752671102948001", "401752671102948901", "401752671103905201")
  for (eng in c("v2", "legacy")) {
    e  <- suppressWarnings(suppressMessages(espn_cfb_pbp(game_id = 401752671, epa_wpa = TRUE, engine = eng)))
    cf <- suppressWarnings(suppressMessages(cfbd_pbp_data(year = 2025, week = 1, team = "LSU",
                                                          epa_wpa = TRUE, engine = eng)))
    if (!is.data.frame(e) || !nrow(e) || !is.data.frame(cf) || !nrow(cf)) skip("no plays returned")
    g <- e[as.character(e$id_play) %in% espn_ids, ]
    expect_equal(as.numeric(g$distance), as.numeric(g$yards_to_goal), label = paste("ESPN goal downs,", eng))
    expect_equal(as.numeric(cf$distance[as.character(cf$id_play) == "401752671103909201"]), 4,
                 label = paste("CFBD 2nd & Goal at CLEM 4,", eng))
    j <- merge(data.frame(id_play = as.character(cf$id_play), c = cf$EPA),
               data.frame(id_play = as.character(e$id_play), e = e$EPA), by = "id_play")
    expect_gt(nrow(j), 160L)
    expect_equal(j$c, j$e, tolerance = 1e-6, label = paste("CFBD vs ESPN EPA,", eng))
  }
})

# Rows for .espn_amp0_distance(): values from real plays (401752671 LSU @
# Clemson; 400559176 "2nd & 0 at UWA 21" after "2nd & 18"; 400547673 TULN).
amp0 <- function(prev, row) {
  r <- rbind(prev, row)
  .espn_amp0_distance(r$distance, r$down, r$ytg, r$text, r$type, r$end_down, r$end_distance, r$end_text)
}
play <- function(type, down, distance, ytg, text, end_down, end_distance, end_text) {
  data.frame(type = type, down = down, distance = distance, ytg = ytg, text = text,
             end_down = end_down, end_distance = end_distance, end_text = end_text)
}

test_that("ESPN '& 0 at' downs follow the previous snap's end state", {
  sack <- play("Sack", 1, 4, 4, "1st & Goal at LSU 4", 2, 14, "2nd & Goal at LSU 14")
  inc  <- play("Pass Incompletion", 2, 0, 14, "2nd & 0 at LSU 14", 3, 14, "3rd & Goal at LSU 14")
  # goal-to-go after a sack -> yards to the goal; the rows before are untouched
  expect_identical(amp0(sack, inc), c(4, 14))
  # ...also through a timeout, and when ESPN encodes the Goal end as distance 0
  to <- play("Timeout", 2, 14, 14, NA, 2, 14, NA)
  expect_identical(amp0(rbind(sack, to), inc), c(4, 14, 14))
  expect_identical(amp0(transform(sack, end_distance = 0), inc), c(4, 14))
  # a lost distance -> the previous end distance, capped at the yards to go
  rush <- play("Rush", 1, 10, 23, "1st & 10 at UWA 23", 2, 18, "2nd & 18 at UWA 21")
  row  <- play("Rush", 2, 0, 21, "2nd & 0 at UWA 21", 3, 0, NA)
  expect_identical(amp0(rush, row), c(10, 18))
  expect_identical(amp0(transform(rush, end_distance = 48, end_text = "2nd & 48 at UWA 21"), row), c(10, 21))
  # nothing to read: spot differs, down differs, end distance missing, a kickoff
  expect_identical(amp0(transform(rush, end_text = "2nd & 18 at UWA 25"), row), c(10, 0))
  expect_identical(amp0(transform(rush, end_down = 3), row), c(10, 0))
  expect_identical(amp0(transform(rush, end_distance = NA, end_text = "2nd & 0 at UWA 21"), row), c(10, 0))
  expect_identical(amp0(rush, transform(row, type = "Kickoff")), c(10, 0))
  # KNOWN GAP (as in sdv-py): TULN 15 is really goal-to-go, but the penalty
  # before it carries no end state, so there is nothing to read.
  pen <- play("Penalty", 1, 10, 10, "1st & Goal at TULN 10", 1, 0, NA)
  expect_identical(amp0(pen, play("Rush", 1, 0, 15, "1st & 0 at TULN 15", 2, 0, NA)), c(10, 0))
})

test_that("ESPN '& 0 at' rows match sdv-py's oracle, except its id-order misses", {
  skip_on_cran()
  # fixtures/parity/amp0_oracle.csv: every "& 0 at" row sdv-py 01d3c1ad6 (#636)
  # changes in eight games (see fixtures/parity/README.md). R must change
  # exactly those rows to the same distance, plus the rows sdv-py misses
  # because its id sort puts a re-keyed field-goal row after the opponent's
  # next drive (see .espn_amp0_distance()).
  oracle <- utils::read.csv(test_path("fixtures", "parity", "amp0_oracle.csv"),
                            colClasses = c("numeric", "character", "character", "integer"))
  r_only <- data.frame(id_play = c("400548134101886613", "400787459102977201", "400763571101946705"),
                       sdvpy_distance = c(14L, 11L, 14L))
  want <- rbind(oracle[c("id_play", "sdvpy_distance")], r_only)
  games <- c(401752671, 400559176, 400548315, 400787459, 400869264, 400763571, 400548134, 400547673)
  got <- do.call(rbind, lapply(games, function(g) {
    raw <- suppressWarnings(suppressMessages(espn_cfb_pbp(game_id = g, epa_wpa = FALSE)))
    mod <- suppressWarnings(suppressMessages(espn_cfb_pbp(game_id = g, epa_wpa = TRUE)))
    if (!is.data.frame(raw) || !nrow(raw) || !is.data.frame(mod) || !nrow(mod)) skip("ESPN returned no plays")
    amp0 <- raw[raw$start_distance %in% 0 & grepl("& 0 at", raw$start_down_distance_text, fixed = TRUE), ]
    m <- mod[as.character(mod$id_play) %in% as.character(amp0$id_play), c("id_play", "distance")]
    m <- m[m$distance %in% 1:99, ]
    data.frame(id_play = as.character(m$id_play), sdvpy_distance = as.integer(m$distance))
  }))
  key <- function(d) d[order(d$id_play), , drop = FALSE]
  expect_equal(key(got), key(want), ignore_attr = TRUE)
})
