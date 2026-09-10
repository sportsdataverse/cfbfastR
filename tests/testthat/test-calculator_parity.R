test_that("R and Python calculators agree on the committed fixture", {
  # Both languages read the SAME model cards, so a divergence here means one of
  # them derives features differently -- the class of bug the card contract
  # exists to prevent, and the reason cfbfastR-cfb-data#70 went unnoticed across
  # two consumers. Regenerate the fixture only from the sdv-py commit recorded
  # in fixtures/calculators/README.md.
  skip_on_cran()
  dir <- testthat::test_path("fixtures", "calculators")
  skip_if_not(file.exists(file.path(dir, "python_outputs.csv")))

  inputs <- utils::read.csv(file.path(dir, "inputs.csv"))
  expected <- utils::read.csv(file.path(dir, "python_outputs.csv"))

  got <- calculate_field_goal_probability(inputs)
  got <- calculate_xpass(got)
  got <- calculate_two_point_probability(got)
  got <- calculate_completion_probability(got)
  got <- calculate_fourth_down(got)
  got <- calculate_qbr(got)
  got <- calculate_expected_points(got)

  # Every output column the fixture carries, not a chosen few: an omitted one
  # can diverge silently, which is the failure this test exists to prevent.
  cols <- setdiff(names(expected), "season")
  expect_gt(length(cols), 10L)
  for (col in cols) {
    expect_equal(
      as.numeric(got[[col]]), as.numeric(expected[[col]]),
      tolerance = 1e-5, info = paste("calculator output column:", col)
    )
  }
})
