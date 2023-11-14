
test_that("ESPN CFB Scoreboard", {
  skip_on_cran()

  cols <- c(
    "matchup",
    "matchup_short",
    "season",
    "type",
    "slug",
    "game_id",
    "game_uid",
    "game_date",
    "game_date_time",
    "attendance",
    "play_by_play_available",
    "home_team_name",
    "home_team_logo",
    "home_team_abb",
    "home_team_id",
    "home_team_location",
    "home_team_full",
    "home_team_color",
    "home_score",
    "home_win",
    "home_record",
    "away_team_name",
    "away_team_logo",
    "away_team_abb",
    "away_team_id",
    "away_team_location",
    "away_team_full",
    "away_team_color",
    "away_score",
    "away_win",
    "away_record",
    "status_name",
    "start_date"
  )

  x <- espn_cfb_scoreboard() %>%
    dplyr::select(
      -dplyr::any_of(dplyr::starts_with("geo_")),
      -dplyr::any_of(dplyr::starts_with("broadcast")),
      -dplyr::any_of(dplyr::starts_with("passing")),
      -dplyr::any_of(dplyr::starts_with("rushing")),
      -dplyr::any_of(dplyr::starts_with("receiving")),
      -dplyr::any_of(c("notes"))
    )

  y <- espn_cfb_scoreboard(date = 20210101) %>%
    dplyr::select(
      -dplyr::any_of(dplyr::starts_with("geo_")),
      -dplyr::any_of(dplyr::starts_with("broadcast")),
      -dplyr::any_of(dplyr::starts_with("passing")),
      -dplyr::any_of(dplyr::starts_with("rushing")),
      -dplyr::any_of(dplyr::starts_with("receiving")),
      -dplyr::any_of(c("notes"))
    )

  expect_equal(sort(colnames(x)), sort(cols))
  expect_equal(sort(colnames(y)), sort(cols))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
