## Release summary

This is a minor release that:

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

## R CMD check results

0 errors | 0 warnings | 0 notes

## revdepcheck results

We checked 0 reverse dependencies, comparing R CMD check results across
CRAN and dev versions of this package.

* We saw 0 new problems
* We failed to check 0 packages
