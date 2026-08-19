### ESPN request-header conventions.
###
### Measured 2026-08-19 against the four ESPN hosts this package uses:
###
###   host                       spoofed browser UA        no UA
###   -------------------------  ------------------------  -----------------
###   site.api.espn.com          HTTP 403                  200
###   sports.core.api.espn.com   200                       200
###   site.web.api.espn.com      200                       200
###   cdn.espn.com               200 with a ZERO-BYTE body  200 (477 KB)
###
### The `site.api` 403 is the dangerous one because it is silent: the wrapper
### catches it and returns an empty frame, so `espn_cfb_teams()` shipped zero
### rows and every consumer degraded to NA -- taking `home`/`away`, `pos_team`,
### `def_pos_team`, `offense_play`, `defense_play` and every team abbreviation
### on the play-by-play path with it.
###
### This is a SOURCE check, not a network check, so it runs everywhere and fails
### the moment someone re-adds the header rather than months later in a release.

test_that("no site.api.espn.com caller sends a User-Agent", {
  r_dir <- testthat::test_path("..", "..", "R")
  skip_if_not(dir.exists(r_dir), "package sources not available")

  # Scope each hit to its ENCLOSING FUNCTION. A fixed line window is not good
  # enough: espn_cfb_team.R holds eleven header blocks, and the ten belonging to
  # sports.core.api callers legitimately keep the header, so a +/-25-line window
  # reports the neighbours of an already-clean call site.
  offenders <- character(0)
  for (f in list.files(r_dir, pattern = "[.]R$", full.names = TRUE)) {
    lines <- readLines(f, warn = FALSE)
    hits <- grep("site\\.api\\.espn\\.com", lines)
    hits <- hits[!grepl("^\\s*#", lines[hits])]   # skip roxygen mentions
    if (!length(hits)) next
    starts <- grep("^[A-Za-z._][A-Za-z0-9._]* *<- *function", lines)
    for (h in hits) {
      before <- starts[starts <= h]
      if (!length(before)) next
      from <- max(before)
      after <- starts[starts > h]
      to <- if (length(after)) min(after) - 1L else length(lines)
      body <- lines[from:to]
      body <- body[!grepl("^\\s*#", body)]      # a comment ABOUT the header is not the header
      if (any(grepl("User-Agent", body))) {
        offenders <- c(offenders, paste0(basename(f), ":", h))
      }
    }
  }
  expect_equal(offenders, character(0))
})

test_that("the sidecar fetch does not send a User-Agent either", {
  # cdn.espn.com answers 200 with an EMPTY body when a browser UA is sent, which
  # is worse than a 403: nothing raises, the JSON parse just yields nothing.
  src <- readLines(testthat::test_path("..", "..", "R", "helper_pbp_sidecar.R"),
                   warn = FALSE)
  skip_if(length(src) == 0, "sidecar source not available")
  expect_false(any(grepl("User-Agent", src[!grepl("^\\s*#", src)])))
})
