context("CFB Player Info")

x <- cfbd_player_info(search_term = 'James', position = 'DB', team = 'Florida State', year = 2017)

y <- cfbd_player_info(search_term = 'Lawrence', team = "Clemson")

w <- cfbd_player_info(search_term = 'Duggan')

cols <- c("athlete_id","team","name","first_name","last_name",
          "weight","height","jersey","position",
          "home_town","team_color","team_color_secondary")

test_that("CFB Player Info", {
  expect_equal(colnames(x), cols)
  expect_equal(colnames(y), cols)
  expect_equal(colnames(w), cols)
  expect_s3_class(x, "data.frame")
  expect_s3_class(y, "data.frame")
  expect_s3_class(w, "data.frame")
})
