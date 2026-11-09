## Release summary

This is a minor release (3.0.0 -> 3.1.0). It:

* Moves the expected points, win probability and decision models to XGBoost
  boosters published in one shared release asset bundle (`cfb_model_artifacts`),
  scored identically by this package and its Python counterpart. EPA and WPA
  values therefore change from 3.0.0. `xgboost` is in Suggests; without it the
  package falls back to the previous models.
* Scores the win probability boosters on the second-half kickoff flag they were
  trained on, so `wp_before`, `wp_after`, `wpa`, `vegas_wp` and the decision
  surfaces' win probabilities also change from 3.0.0 (they now match the Python
  counterpart on real games). The published `pos_team_receives_2H_kickoff`
  column is unchanged.
* Brings the play-by-play engine's timeout counting and 2018+ fair-catch
  kickoff touchbacks in line with the Python counterpart, and its text parsing
  closer to it (fumble player names still differ), so some
  player names and ids, timeouts remaining and kickoff columns change from
  3.0.0, and with them EPA on fair-caught kickoffs and win probability.
  `yds_punted` now reads a punt for a loss as negative yards on both engines.
* Fixes the release loaders: model play-by-play is read as published, play ids
  stay exact, and every published season is accepted.
* Adds ten `calculate_*()` functions that score a data frame with those models,
  validated against each model's published card, and `cfb_model_card()`,
  `cfb_card_features()`, `cfb_card_era_contract()` and `cfb_card_reset_cache()`
  to read those cards.
* `cfbd_team_roster()` (and `load_cfb_rosters()`) returns `year` as the
  player's class year (`NA` where CFBD filled it with the season), with the
  roster year in a new `season` column.
* CFBD requests retry HTTP 502 and 504 as well as 429 and 503, up to 6 times
  within 120 seconds. `cfbd_ratings_sp()` now checks for an API key before
  sending a request, like every other `cfbd_*()` function.
* Adds ten `cfbd_*()` wrappers for the CollegeFootballData passing and rushing
  endpoints, plus schedule, preview and team-overview endpoints.
* Adds five `cfbd_punting_*()` wrappers for the CollegeFootballData punting
  endpoints, so the package now wraps all 93 endpoints in the current CFBD
  specification.
* Adds loaders for season-by-season conference and division membership.
* No longer downloads anything when the package is loaded: the models are fetched
  the first time a function scores a play.
* Raises the httr2 floor to 1.1.0 and the purrr floor to 1.0.0 (the versions that
  provide functions the package imports), declares `stats` and `utils` in
  Imports, and drops the unused Rcpp and RcppParallel imports. This fixes the
  r-devel NOTE on the 3.0.0 check page about `stats` being imported but only
  suggested.
* Adds `cfb_clear_model_cache()` and documents where the downloaded models are
  cached.
* Shrinks the installed help: the 67 ESPN functions link to one family index
  page instead of listing each other under "See also", and closely related
  functions share a help page.

## Test environments

* local Windows 10 x64 (build 19045), R 4.6.0 ucrt, 2026-11-09:
  `R CMD check --as-cran --run-donttest --timings` with the PDF manual,
  `_R_CHECK_CRAN_INCOMING_REMOTE_=true`, and no CollegeFootballData API key set
  (`R_ENVIRON_USER` pointing at an empty file)
* local Windows 10 x64, R 4.6.0 ucrt, 2026-11-09: `R CMD check --run-donttest
  --no-tests --no-manual` with the network blocked (dead proxy) and no API key
* GitHub Actions (R-CMD-check on main): windows-latest (release), ubuntu-latest
  (devel, release, oldrel-1); the R-devel job fails on any NOTE. Last completed
  run green on 2026-11-06 at commit f8c0212; the runs on the later commits had
  not finished when this was written.
* R-hub v2, 2026-11-06, at the earlier commit f8c0212 (before the help-size
  changes and the `cfbd_ratings_sp()` key check): linux, macos, macos-arm64
  and windows, all R-devel, all passed
* win-builder (devel and release): to be run before submission

## R CMD check results

0 errors | 0 warnings | 0 notes

`--run-donttest` runs the `\donttest` code inside the timed examples step; the
examples outside `\donttest` are all offline. Every example took under 5 s of
CPU and under 5 s elapsed. The slowest, `espn_cfb_futures`, took 0.75 s CPU and
4.14 s elapsed, nearly all of it network wait; the most CPU, 3.45 s, went to
`espn_cfb_powerindex`. All 247 examples took 103 s elapsed (36 s CPU) in total
with no API key, where the CollegeFootballData examples stop with an
informative error before sending a request.

An earlier check of this release listed three examples over 5 s. Two now
parse faster: name cleaning in the ESPN participant and Yahoo stat parsers is
memoised, with identical output. Whole-season downloads and examples that make
one request per row now run only in an interactive session (listed below).
Timed in that check (before) and in the check above (after):

```
                               before (CPU / elapsed)   after (CPU / elapsed)
espn_cfb_game_pbp                     5.61 / 9.54          0.82 / 1.05
load_espn_cfb_pbp                     2.39 / 5.16          interactive only
yahoo_cfb_player_season_stats         3.43 / 4.02 (*)      0.82 / 1.78
```

(*) timed on its own; inside checks it went over 5 s. The participant-column
call of `espn_cfb_game_pbp` (now interactive only) fetched ESPN's position
catalog, one request per position. The examples of `espn_cfb_player()`,
`espn_cfb_game_team_roster()` and `espn_cfb_game_player_statistics()` now pass
`position_detail = FALSE`, so no example run under `R CMD check` fetches that
catalog.

Elapsed time on these examples is mostly network wait, and it varies from run
to run. Checks run while other jobs loaded this machine listed a few
low-CPU examples over 5 s elapsed (for example `espn_cfb_franchises`, 0.20 s
CPU); each took under 5 s when re-timed on its own with
`system.time(example(fn, package = "cfbfastR", run.donttest = TRUE))`.

Examples that would take much longer run only in an interactive session
(`@examplesIf interactive()`):

* `load_cfb_pbp()`, `update_cfb_db()`, `load_espn_cfb_pbp()` and
  `load_ncaa_mfb_pbp_cfbfastr()` download whole seasons of play-by-play.
* `espn_cfb_seasons()`, `espn_cfb_coaches()`, `espn_cfb_team_roster()`,
  `espn_cfb_game_player_box()`, `espn_cfb_groups()`, `espn_cfb_awards()` and
  `espn_cfb_positions()` make one request per row (season, coach, player,
  conference or division, award, position), as does the second
  `espn_cfb_game_pbp()` call, which adds participant columns.
* `espn_cfb_pbp()` and `espn_cfb_pbp_v2()` spend several seconds of CPU
  parsing a game.
* Eight `calculate_*()` functions (`?calculate_cfb_models`) download a model
  on first use. `calculate_epa()` and `calculate_wpa()` run theirs offline,
  outside `\donttest`.

With the network blocked, Status: OK; every network example fails inside
`try()` with an informative message.

Under `R CMD check` the model bundle that examples download is cached in
`tempdir()`, so the check leaves nothing in the user's file space.

## Tests on CRAN

Tests that need the network (the CollegeFootballData API, which also needs an API
key; ESPN; the GitHub release assets) or the downloaded model bundle call
`skip_on_cran()`. The remaining tests run on CRAN and are offline: they use mocked
HTTP responses and small committed fixtures. In the check above, with no key:
`[ FAIL 0 | WARN 0 | SKIP 432 | PASS 989 ]`, with 419 tests skipped on CRAN and
13 skipped because no CollegeFootballData key was set.

## Internet resources

Functions that access internet resources (the CollegeFootballData, ESPN, Fox
Sports and Yahoo Sports APIs, and the pre-built season datasets on GitHub release
assets) fail with an informative message when the resource is unavailable. Most
return an empty table; a few raise an error instead (for example
`cfbd_pbp_data(engine = "legacy")` on a non-200 response) and
`yahoo_cfb_boxscore()` returns `NULL`. Every example that touches the network is
wrapped in `try()`, and in `\donttest{}` or behind `interactive()` (listed
above). Every `cfbd_*()` function needs a CollegeFootballData API key; when no
key is set, its example stops with an informative error before sending any
request.

## Reverse dependencies

cfbseedR 0.2.0 (Suggests cfbfastR) is the only reverse dependency on CRAN
(`tools::package_dependencies("cfbfastR", reverse = TRUE)`, 2026-11-09). Its
`R CMD check` against cfbfastR 3.1.0 on 2026-11-06: Status: OK.
