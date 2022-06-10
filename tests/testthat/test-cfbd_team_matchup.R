#
# x <- cfbd_team_matchup('Texas','Oklahoma')
#
# y <- cfbd_team_matchup('Texas A&M','TCU', min_year = 1975)
#
# cols <- c('season', 'week', 'season_type', 'date',   'neutral_site',
#           'venue', 'home_team','home_score','away_team','away_score','winner')
#
# test_that("CFB Team Matchup", {
#   expect_equal(colnames(x), cols)
#   expect_equal(colnames(y), cols)
#   expect_s3_class(x, "data.frame")
#   expect_s3_class(y, "data.frame")
# })
