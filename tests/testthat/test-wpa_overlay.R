### Gates for .wpa_overlay(), the shared WPA differencing (#138).
###
### The naive WPA block in .pbp_wpa_calcs_naive() is left INLINE and untouched
### because it produces published values. .wpa_overlay() is the extracted
### equivalent that vegas_wpa uses. The first test is what makes that split
### safe: it asserts the helper reproduces the inline result exactly, so the
### two cannot drift into disagreeing about turnovers or half ends.

mk_game <- function() {
  # A small but adversarial game: a possession change, a half end with a
  # trailing timeout, and an end-of-period marker -- the three branches the
  # overlays exist for.
  data.frame(
    pos_team = c("A", "A", "B", "B", "A", "A"),
    lead_pos_team = c("A", "B", "B", "A", "A", NA),
    lead_pos_team2 = c("B", "B", "A", "A", NA, NA),
    home = "A",
    play_type = c("Rush", "Pass", "Rush", "Timeout", "Pass", "End Period"),
    lead_play_type = c("Pass", "Rush", "Timeout", "Pass", "End Period", NA),
    end_of_half = c(0, 0, 0, 1, 0, 0),
    change_of_pos_team = c(0, 1, 0, 1, 0, 0),
    pos_team_receives_2H_kickoff = c(0, 0, 0, 0, 1, 1),
    wp_before = c(0.50, 0.55, 0.40, 0.42, 0.61, 0.65),
    stringsAsFactors = FALSE
  )
}

test_that(".wpa_overlay reproduces the inline naive WPA exactly", {
  df <- mk_game()
  inline <- .pbp_wpa_calcs_naive(df)$wpa
  helper <- round(.wpa_overlay(df, df$wp_before), 7)
  expect_equal(helper, inline)
})

test_that(".wpa_overlay flips perspective on a possession change", {
  df <- mk_game()
  w <- .wpa_overlay(df, df$wp_before)
  # Row 2 hands the ball to B (pos_team A, lead_pos_team B), so the next WP is
  # B's: A's change is (1 - 0.40) - 0.55, not 0.40 - 0.55.
  expect_equal(w[2], (1 - 0.40) - 0.55)
  # Row 1 keeps possession, so it is a plain difference.
  expect_equal(w[1], 0.55 - 0.50)
})

test_that(".wpa_overlay is driven by the column it is handed", {
  df <- mk_game()
  # Same frame, different WP column -> different WPA. If the helper secretly
  # read wp_before instead of its argument, these would be identical.
  alt <- df$wp_before * 0.5 + 0.25
  expect_false(isTRUE(all.equal(.wpa_overlay(df, alt),
                                .wpa_overlay(df, df$wp_before))))
})

test_that("vegas_wpa is derived when vegas_wp is present, and skipped when not", {
  df <- mk_game()
  expect_false("vegas_wpa" %in% names(.pbp_wpa_calcs_naive(df)))

  df$vegas_wp <- c(0.70, 0.74, 0.22, 0.25, 0.80, 0.83)
  out <- .pbp_wpa_calcs_naive(df)
  expect_true(all(c("vegas_wpa", "vegas_wp_after") %in% names(out)))
  expect_equal(out$vegas_wpa, round(.wpa_overlay(df, df$vegas_wp), 7))
  expect_equal(out$vegas_wp_after, round(df$vegas_wp + out$vegas_wpa, 7))
  # The naive columns must be unaffected by vegas_wp being present.
  expect_equal(out$wpa, .pbp_wpa_calcs_naive(mk_game())$wpa)
})

test_that("an all-NA vegas_wp yields an all-NA vegas_wpa, not an error", {
  df <- mk_game()
  df$vegas_wp <- NA_real_
  out <- .pbp_wpa_calcs_naive(df)
  expect_true(all(is.na(out$vegas_wpa)))
})
