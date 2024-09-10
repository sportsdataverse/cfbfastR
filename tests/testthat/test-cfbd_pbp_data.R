test_that("2024 pbp handles completions properly", {
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
