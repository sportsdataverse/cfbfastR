test_that("alias loaders read the cfb_groups release assets (offline)", {
  urls <- character()
  local_mocked_bindings(parquet_from_url = function(url) {
    urls <<- c(urls, url)
    data.table::data.table(league = "cfb", team_id = "194")
  })

  expect_s3_class(load_cfb_team_aliases(), "cfbfastR_data")
  expect_s3_class(load_cfb_player_aliases(), "cfbfastR_data")

  expect_equal(urls, paste0(
    "https://github.com/sportsdataverse/sportsdataverse-data/releases/download/cfb_groups/",
    c("cfb_team_aliases.parquet", "cfb_player_aliases.parquet")
  ))
})

test_that("alias loaders return the published cfb_groups tables", {
  skip_on_cran()
  skip_if_offline("github.com")
  skip_if_not_installed("arrow")

  t <- load_cfb_team_aliases()
  expect_s3_class(t, "cfbfastR_data")
  expect_gt(nrow(t), 0)
  expect_in(c("team_id", "source", "source_id", "id_kind", "name_kind", "value",
              "valid_from", "valid_to", "match_method"), colnames(t))
  expect_type(t$team_id, "character")
  # CFBD team ids are ESPN ids: CFBD 194 is Ohio State, ESPN 194.
  expect_equal(unique(t$team_id[t$source == "cfbd" & t$source_id == "194"]), "194")

  p <- load_cfb_player_aliases()
  expect_s3_class(p, "cfbfastR_data")
  expect_gt(nrow(p), 0)
  expect_in(c("athlete_id", "source", "source_player_id", "team_id",
              "valid_from", "valid_to", "match_method", "match_confidence"), colnames(p))
  expect_type(p$athlete_id, "character")
  expect_in("ncaa", p$source)
})
