## Release summary

This is a major release (2.2.0 -> 3.0.0; the 2.3.0 development version was renumbered and never published) that:

* Adds a large new ESPN college-football API layer — 65 new `espn_cfb_*()`
  wrappers covering players, teams, games, play-by-play, season structure,
  league catalogs, and recruiting — expanding the package's ESPN coverage
  from 8 wrappers to 73.
* Adds `espn_cfb_pbp_v2()`, a faster core-v2-sourced play-by-play function
  that runs the full EPA/WPA model pipeline.
* Adds `cfbd_betting_ats()` and `cfbd_stats_game_havoc()` for
  against-the-spread records and per-game havoc statistics from the
  CollegeFootballData API.
* Fixes a bug in `espn_cfb_pbp()` where a malformed request URL caused
  every call to return an error.
* Adds optional session caching of ESPN reference catalogs (`cachem` /
  `memoise`), controllable via the `cfbfastR.cache` option.
* Migrates the package's internal HTTP layer from `httr` to
  `httr2` (>= 1.0.0); no user-visible behaviour change for existing
  wrapper calls.
* Adds 48 full-season data loaders (`load_espn_cfb_*()`, `load_cfb_*()`
  dataset loaders, `load_ncaa_mfb_*()`) that download pre-built season
  datasets from the sportsdataverse-data GitHub releases; all examples are
  wrapped in `\donttest{try(...)}` and every download failure degrades to a
  zero-row table with a warning rather than an error.
* Documentation migrated to roxygen2 8.1.0; adds a `cph` role to
  `Authors@R` and refreshes the LICENSE year.

## R CMD check results

0 errors | 0 warnings | 0 notes

## revdepcheck results

We checked 0 reverse dependencies, comparing R CMD check results across
CRAN and dev versions of this package.

* We saw 0 new problems
* We failed to check 0 packages

## Behaviour change in this release

`cfbd_pbp_data()` and `espn_cfb_pbp()` now run the v2 play-by-play engine by
default. The previous behaviour remains available via `engine = "legacy"` per
call, or `options(cfbfastR.pbp_engine = "legacy")` for a session, and a
once-per-session message points at it. `tests/testthat/test-pbp_equivalence.R`
asserts the v2 engine reproduces the legacy frames column-for-column against an
explicit allow-list of intentional deltas (1,788 assertions with network).
