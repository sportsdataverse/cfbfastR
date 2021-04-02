context("CFB Team Info")

x <- cfbd_team_info(year = 2019)

cols <- c("team_id","school","mascot","abbreviation","alt_name1","alt_name2",
          "alt_name3","conference","division",
          "color","alt_color","logos")

test_that("CFB Team Info", {
  expect_equal(nrow(x), 130)
  expect_equal(ncol(x), 12)
  expect_equal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})
