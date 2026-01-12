test_that("2024 pbp handles completions properly", {
  skip_on_cran()
  # skip("working post-fix") # should fail without it
  p = cfbd_pbp_data(
    year = 2024,
    season_type = "regular",
    week = 1,
    team = "NC State",
    play_type = "pass reception",
    epa_wpa = T
  )

  completions = p %>%
    dplyr::filter(game_id == 401634299 & play_type == "Pass Reception" & pos_team == "NC State") %>%
    dplyr::mutate(
      same_same = (yards_gained == yds_receiving)
    ) %>%
    dplyr::select(yards_gained, yds_receiving, same_same)

  testthat::expect_equal(sum(completions$same_same), nrow(completions))
})

test_that("base case 2023 pbp are already properly handled", {
  skip_on_cran()
  p = cfbd_pbp_data(
    year = 2023,
    season_type = "regular",
    week = 2,
    team = "Georgia Tech",
    play_type = "pass reception",
    epa_wpa = T
  )

  completions = p %>%
    dplyr::filter(game_id == 401525494 & play_type == "Pass Reception" & pos_team == "Georgia Tech") %>%
    dplyr::mutate(
      same_same = (yards_gained == yds_receiving)
    ) %>%
    dplyr::select(yards_gained, yds_receiving, same_same)

  testthat::expect_equal(sum(completions$same_same), nrow(completions))
})


patrick::with_parameters_test_that(
  "[2025 new PBP] Yardage is successfully calculated",
  {
    skip_on_cran()
    plays = cfbd_pbp_data(
      year = year,
      season_type = season_type,
      week = week,
      team = team,
      epa_wpa = T,
    )

    target_plays = plays[which(plays$play_text == play_text), ]
    testthat::expect_equal(nrow(target_plays), 1)
    testthat::expect_equal(target_plays[1, yards_field][[1]], expected_yards)
  },
  patrick::cases(
    "401754571-yds_receiving-1" = list(year = 2025, season_type = "regular", week = 9, team = "Georgia Tech", play_text = "(14:46) Shotgun #10 H.King pass complete short right to #1 J.Haynes caught at GT27, for 15 yards to the GT40 (#13 G.Bryant III), 1ST DOWN", yards_field = "yds_receiving", expected_yards = 15),
    "401754571-yds_receiving-2" = list(year = 2025, season_type = "regular", week = 9, team = "Georgia Tech", play_text = "(14:17) No Huddle-Shotgun #10 H.King pass complete short right to #4 I.Canion caught at GT46, for 2 yards to the GT42 fumbled by #4 I.Canion at GT46 forced by #16 C.Peal recovered by SU #8 D.Reese at GT42, End Of Play", yards_field = "yds_receiving", expected_yards = 2),
    "401754571-yds_receiving-3" = list(year = 2025, season_type = "regular", week = 9, team = "Georgia Tech", play_text = "(06:15) Shotgun #10 H.King pass incomplete short left to #17 J.Beetham thrown to SU01", yards_field = "yds_receiving", expected_yards = NA_integer_),
    "401754571-yds_rushed-1" = list(year = 2025, season_type = "regular", week = 9, team = "Georgia Tech", play_text = "(13:31) Shotgun #10 H.King rush right for 7 yards gain to the SU30, out of bounds at SU30, 1ST DOWN", yards_field = "yds_rushed", expected_yards = 7),
    "401754571-yds_rushed-2" = list(year = 2025, season_type = "regular", week = 9, team = "Georgia Tech", play_text = "(07:16) No Huddle-Shotgun #1 J.Haynes rush left for 4 yards loss to the SU35 (#6 J.Heard Jr.; #3 K.Singleton)", yards_field = "yds_rushed", expected_yards = -4),
    "401754571-yds_receiving-4" = list(year = 2025, season_type = "regular", week = 9, team = "Syracuse", play_text = "(15:00) No Huddle-Shotgun #10 R.Collins pass complete deep right to #2 J.Cook II caught at GT37, for 41 yards to the GT34 (#6 R.Shelley), 1ST DOWN", yards_field = "yds_receiving", expected_yards = 41),
    "401754571-yds_receiving-5" = list(year = 2025, season_type = "regular", week = 9, team = "Syracuse", play_text = "(15:00) No Huddle-Shotgun #10 R.Collins pass complete deep right to #2 J.Cook II caught at GT37, for 41 yards to the GT34 (#6 R.Shelley), 1ST DOWN", yards_field = "yds_receiving", expected_yards = 41),
    "401754571-yds_receiving-6" = list(year = 2025, season_type = "regular", week = 9, team = "Syracuse", play_text = "(09:25) No Huddle-Shotgun #10 R.Collins pass complete short left to #2 J.Cook II caught at SU31, for 4 yards to the SU34 (#2 E.Lightsey)", yards_field = "yds_receiving", expected_yards = 4),
    "401754571-yds_receiving-7" = list(year = 2025, season_type = "regular", week = 9, team = "Georgia Tech", play_text = "(05:49) Shotgun #10 H.King pass complete short middle to #85 J.Allen caught at SU33, for 19 yards to the SU09 (#0 B.Long Jr.)", yards_field = "yds_receiving", expected_yards = 19),
    "401777353-yds_receiving-1" = list(year = 2025, season_type = "regular", week = 15, team = "Ohio State", play_text = "(07:37) Shotgun #10 J.Sayin pass complete short left to #4 J.Smith caught at OSU29, for 5 yards loss to the OSU32 (#12 D.Boykin)", yards_field = "yds_receiving", expected_yards = -5),
    "401778302-yds_receiving-1" = list(year = 2025, season_type = "postseason", week = 1, team = "Boise State", play_text = "Shotgun #14 M.Cutforth pass complete deep middle to #3 L.Caples caught at WAS06, for 22 yards to the WAS06 (#18 R.Dillard-Allen), 1ST DOWN", yards_field = "yds_receiving", expected_yards = 22),
    "401634169-base-case-old-pbp-yds_receiving" = list(year = 2024, season_type = "regular", week = 1, team = "Purdue", play_text = "Hudson Card pass complete to Drew Biber for 2 yds fumbled, forced by Maddix Blackwell, recovered by INST Garret Ollendieck G. Ollendieck return for 0 yds", yards_field = "yds_receiving", expected_yards = 2),
    "401634169-base-case-old-pbp-yds_rushed" = list(year = 2024, season_type = "regular", week = 1, team = "Purdue", play_text = "Devin Mockobee run for 11 yds to the INST 21 for a 1ST down", yards_field = "yds_rushed", expected_yards = 11)
  )
)
