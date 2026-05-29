

test_that("ESPN CFB Game Broadcasts", {
  skip_on_cran()

  cols <- c(
    "game_id", "type_id", "type_name", "type_slug", "station", "slug",
    "channel", "priority", "partnered", "market_id", "market_type", "lang",
    "region", "media_id", "media_name", "media_short_name",
    "media_call_letters", "media_slug", "media_group_id", "media_group_name",
    "media_group_slug", "competition_ref", "media_ref"
  )

  x <- espn_cfb_game_broadcasts(game_id = 401628339)

  y <- espn_cfb_game_broadcasts(game_id = 401520375)

  if (is.null(x) || !is.data.frame(x) || nrow(x) == 0) {
    skip("No ESPN game broadcasts data returned at test time")
  }

  expect_in(cols, colnames(x))
  expect_in(cols, colnames(y))
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
})
