test_that("group loaders read the cfb_groups release assets (offline)", {
  urls <- character()
  local_mocked_bindings(parquet_from_url = function(url) {
    urls <<- c(urls, url)
    data.table::data.table(league = "cfb", group_id = "cfb:sec")
  })

  x <- load_cfb_team_group_seasons(c(2023, 2024))
  expect_s3_class(x, "cfbfastR_data")
  expect_equal(nrow(x), 2L)
  expect_s3_class(load_cfb_groups(), "cfbfastR_data")
  expect_s3_class(load_cfb_group_seasons(), "cfbfastR_data")
  expect_s3_class(load_cfb_group_aliases(), "cfbfastR_data")

  expect_true(all(startsWith(
    urls, "https://github.com/sportsdataverse/sportsdataverse-data/releases/download/cfb_groups/"
  )))
  expect_equal(basename(urls), c(
    "cfb_team_group_seasons_2023.parquet", "cfb_team_group_seasons_2024.parquet",
    "cfb_groups.parquet", "cfb_group_seasons.parquet", "cfb_group_aliases.parquet"
  ))

  urls <- character()
  load_cfb_team_group_seasons(TRUE)
  expect_equal(basename(urls), "cfb_team_group_seasons.parquet")

  urls <- character()
  load_cfb_team_group_seasons(c(2024, 2024))
  expect_equal(basename(urls), "cfb_team_group_seasons_2024.parquet")
})

test_that("load_cfb_team_group_seasons validates the seasons argument", {
  expect_error(load_cfb_team_group_seasons(1868))
  expect_error(load_cfb_team_group_seasons("2024"))
  expect_error(load_cfb_team_group_seasons(2024.5))
})

test_that("group loaders return the published cfb_groups tables", {
  skip_on_cran()
  skip_if_offline("github.com")
  skip_if_not_installed("arrow")

  x <- load_cfb_team_group_seasons(2024)
  expect_gt(nrow(x), 0)

  expect_s3_class(x, "cfbfastR_data")
  expect_in(c("season", "team_id", "team_name", "conference_id", "sources_agree"), colnames(x))
  expect_type(x$team_id, "character")
  # Texas and Oklahoma joined the SEC for the 2024 season.
  expect_setequal(x$conference_id[x$team_id %in% c("251", "201")], "cfb:sec")

  g <- load_cfb_groups()
  expect_s3_class(g, "cfbfastR_data")
  expect_in(unique(x$conference_id), g$group_id)
})
