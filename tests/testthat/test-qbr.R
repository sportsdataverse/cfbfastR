### Gates for QBR (#140).
###
### Like the fourth-down surfaces this has no cross-language oracle -- sdv-py's
### QBR lives inside CFBPlayProcess's box-score builder, which cfbfastR has no
### equivalent of. The gates below pin the arithmetic that defines the feature
### set: the leverage bands, the EPA clip, the weighted means, and the fact that
### an absent play category is missing rather than zero.

mk_pbp <- function() {
  data.frame(
    game_id = c(rep("1", 8), rep("2", 3)),
    season = 2021,
    pos_team = "Texas", home = "Texas", spread = -7,
    home_wp_before = c(0.5, 0.5, 0.05, 0.85, 0.5, 0.95, 0.5, 0.5, 0.5, 0.5, 0.5),
    EPA = c(1.0, -0.5, 2.0, -9.0, 0.4, 1.5, -1.0, 0.2, 0.7, -0.3, 0.1),
    pass = c(1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0),
    rush = c(0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1),
    sack_vec = c(0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    fumble_vec = c(0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0),
    penalty_flag = c(0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0),
    passer_player_name = c("QB One", "QB One", "QB One", "QB One", NA, "QB Two",
                           NA, "QB One", "QB One", "QB One", NA),
    rusher_player_name = c(NA, NA, NA, NA, "QB One", NA, "RB Guy", NA, NA, NA,
                           "QB One"),
    stringsAsFactors = FALSE
  )
}

test_that("the leverage weight discounts garbage time on both ends", {
  expect_equal(.qbr_weight(c(0.05, 0.15, 0.5, 0.85, 0.95)),
               c(0.6, 0.9, 1, 0.9, 0.6))
  # 0.9 exactly falls through to a full weight: the lower band stops short of it
  # and the upper band starts past it. That asymmetry is the reference
  # implementation's, and matching it is the point.
  expect_equal(.qbr_weight(0.9), 1)
  expect_equal(.qbr_weight(NA), 1)
})

test_that("EPA is clipped at -5 before the fumble charge, not after", {
  df <- data.frame(EPA = c(-9, -6, -3, 1), fumble_vec = c(0, 1, 1, 0))
  # -6 with a fumble is -5, not -3.5: the clip is tested first, so a disastrous
  # fumble keeps its full weight instead of being softened to the flat charge.
  expect_equal(.qbr_epa(df), c(-5, -5, -3.5, 1))
})

test_that("a category with no plays is missing, not zero", {
  expect_true(is.na(.qbr_weighted_mean(c(NA, NA), c(NA, NA))))
  expect_true(is.na(.qbr_weighted_mean(numeric(0), numeric(0))))
  # Zero would assert the quarterback was sacked for exactly nothing; NA is what
  # the training frame carried and what xgboost routes down its missing branch.
  expect_equal(.qbr_weighted_mean(c(2, 4, NA), c(1, 3, NA)), 3.5)
})

test_that("create_qbr aggregates per quarterback per game", {
  out <- create_qbr(mk_pbp(), qbr_model = NA)
  expect_equal(nrow(out), 3L)
  expect_equal(out$athlete_name, c("QB One", "QB Two", "QB One"))
  # Two games, not one pooled row -- merging them would be a wrong number rather
  # than a missing one.
  expect_equal(out$game_id, c("1", "1", "2"))
  expect_equal(out$plays, c(6L, 1L, 3L))
})

test_that("create_qbr computes the weighted means the model was trained on", {
  out <- create_qbr(mk_pbp(), qbr_model = NA)
  qb1 <- out[out$game_id == "1" & out$athlete_name == "QB One", ]
  # clipped EPA 1.0, -0.5, 2.0, -5.0, 0.4, 0.2 against weights 1, 1, .6, .9, 1, 1
  expect_equal(qb1$qbr_epa, -2.2 / 5.5)
  expect_equal(qb1$pass_epa, -2.6 / 4.5)
  expect_equal(qb1$sack_epa, -0.5)      # the one sack that was not a fumble
  expect_equal(qb1$rush_epa, 0.4)
  expect_true(is.na(qb1$pen_epa))       # the only penalty belongs to a non-QB
})

test_that("only players who threw a pass appear, carries and all", {
  out <- create_qbr(mk_pbp(), qbr_model = NA)
  # A running back's carry never becomes a QBR row...
  expect_false("RB Guy" %in% out$athlete_name)
  # ...but a quarterback's own carry is folded into his.
  expect_false(is.na(out$rush_epa[1]))
})

test_that("create_qbr sides the spread to the team with the ball", {
  out <- create_qbr(mk_pbp(), qbr_model = NA)
  # CFBD ships spread from the HOME team's perspective, negative when home is
  # favoured. Texas is home and favoured by 7, so the possessing team's spread
  # is +7. The unnegated form would report the favourite as a 7-point underdog.
  expect_true(all(out$spread == 7))
})

test_that("create_qbr uses the ONE-HOT era, not the ordinal one", {
  out <- create_qbr(mk_pbp(), qbr_model = NA)
  expect_equal(unname(unlist(out[1, c("era0", "era1", "era2", "era3")])),
               c(0, 0, 0, 1))
  pbp <- mk_pbp(); pbp$season <- 2018
  # 2018 is exactly the season that separates the two encodings: era2 one-hot
  # (2020 cut) but the ordinal era's post-2017 bucket.
  out18 <- create_qbr(pbp, qbr_model = NA)
  expect_equal(unname(unlist(out18[1, c("era0", "era1", "era2", "era3")])),
               c(0, 0, 1, 0))
})

test_that("create_qbr degrades rather than fabricating a rating", {
  out <- create_qbr(mk_pbp(), qbr_model = NA)
  expect_true(all(is.na(out$exp_qbr)))
  expect_identical(nrow(create_qbr(mk_pbp()[0, , drop = FALSE])), 0L)
  no_qb <- mk_pbp(); no_qb$passer_player_name <- NA_character_
  expect_identical(nrow(create_qbr(no_qb)), 0L)
  # An unmodeled frame is a caller error worth naming, not a silent empty table.
  expect_error(create_qbr(data.frame(x = 1)), "modeled play-by-play")
})

test_that("create_qbr scores the bundled model onto a plausible scale", {
  skip_on_cran(); skip_if_offline(); skip_if_not_installed("xgboost")
  skip_if(is.null(.cfb_qbr_model()), "bundled qbr_model unavailable")
  out <- create_qbr(mk_pbp())
  expect_equal(nrow(out), 3L)
  expect_true(all(out$exp_qbr >= 0 & out$exp_qbr <= 100))
  # The quarterback whose game was one big play must outrate the one who fumbled
  # and took a sack. A feature-order mismatch scrambles this without erroring.
  expect_gt(out$exp_qbr[out$athlete_name == "QB Two"],
            out$exp_qbr[out$game_id == "1" & out$athlete_name == "QB One"])
})

test_that("pass eligibility is scoped to the game and team, not the name", {
  # A quarterback who threw in game 1 but only carried in game 2 must not get a
  # game-2 QBR row: a name-only eligibility set produced one whose pass_epa was
  # NA, i.e. a quarterback line for a game with no pass attempt in it.
  pbp <- data.frame(
    game_id = c("1", "1", "2"), season = 2021,
    pos_team = "Texas", home = "Texas", spread = -7, home_wp_before = 0.5,
    EPA = c(1, -0.5, 0.4), pass = c(1, 1, 0), rush = c(0, 0, 1),
    sack_vec = 0, fumble_vec = 0, penalty_flag = 0,
    passer_player_name = c("QB One", "QB One", NA),
    rusher_player_name = c(NA, NA, "QB One"), stringsAsFactors = FALSE
  )
  out <- create_qbr(pbp, qbr_model = NA)
  expect_equal(nrow(out), 1L)
  expect_equal(out$game_id, "1")

  # Same name, two teams, one game: two players, not one merged line.
  two <- pbp[c(1, 1), ]
  two$game_id <- "1"
  two$pos_team <- c("Texas", "Oklahoma")
  two$home <- "Texas"
  expect_equal(nrow(create_qbr(two, qbr_model = NA)), 2L)
})

test_that("a frame with no game_id is one game, not an error", {
  # `split()` DROPS rows whose grouping level is NA rather than grouping them,
  # so keying on game_id directly made this documented fallback throw
  # "incorrect number of dimensions" instead of returning a table.
  pbp <- data.frame(
    season = 2021, pos_team = "Texas", home = "Texas", spread = -7,
    home_wp_before = 0.5, EPA = c(1, -0.5, 0.4),
    pass = c(1, 1, 0), rush = c(0, 0, 1),
    sack_vec = 0, fumble_vec = 0, penalty_flag = 0,
    passer_player_name = c("QB One", "QB One", NA),
    rusher_player_name = c(NA, NA, "QB One"), stringsAsFactors = FALSE
  )
  out <- create_qbr(pbp, qbr_model = NA)
  expect_equal(nrow(out), 1L)
  expect_equal(out$plays, 3L)
  expect_true(is.na(out$game_id))   # the sentinel is internal only
})

test_that("create_qbr returns a finalized cfbfastR_data frame on every path", {
  expect_s3_class(create_qbr(mk_pbp(), qbr_model = NA), "cfbfastR_data")
  expect_s3_class(create_qbr(mk_pbp()[0, , drop = FALSE]), "cfbfastR_data")
  no_qb <- mk_pbp(); no_qb$passer_player_name <- NA_character_
  expect_s3_class(create_qbr(no_qb), "cfbfastR_data")
})
