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

0 errors | 0 warnings | 1 note

```
* checking examples ... [146s] NOTE
Examples with CPU (user + system) or elapsed time > 5s
                  user system elapsed
espn_cfb_game_pbp 4.73   0.88    9.54
load_espn_cfb_pbp 1.89   0.50    5.16
```

This NOTE comes only from passing `--run-donttest` explicitly, which runs the
`\donttest` code inside the timed examples step. The examples outside
`\donttest` are all offline. Both examples are in `\donttest{}` and call a
public source over the network: `espn_cfb_game_pbp` makes four ESPN calls
(two for one game's plays, one for a drive and one for a single play), and
`load_espn_cfb_pbp` downloads one season file from a public GitHub release.
Re-timed on their own from the installed build, with
`system.time(example(fn, package = "cfbfastR", run.donttest = TRUE))`:

```
                  CPU (user + system)  elapsed
espn_cfb_game_pbp               4.50     8.81
load_espn_cfb_pbp               2.29     5.30
```

The rest of the elapsed time is network wait (CPU < 5 s in both). Run to run
the list varies around the 5 s line: an earlier check the same day listed
`yahoo_cfb_player_season_stats` instead of `load_espn_cfb_pbp`, which took
3.43 s CPU and 4.02 s elapsed on its own. All 247 examples took 118 s elapsed
(49 s CPU) in total with no API key, where the CollegeFootballData examples
stop with an informative error before sending a request.

Examples that would take much longer run only in an interactive session
(`@examplesIf interactive()`):

* `load_cfb_pbp()` and `update_cfb_db()` download whole seasons of
  play-by-play.
* `espn_cfb_seasons()`, `espn_cfb_coaches()`, `espn_cfb_team_roster()`,
  `espn_cfb_game_player_box()` and `espn_cfb_groups()` make one request per
  row (season, coach, player, conference or division).
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
`[ FAIL 0 | WARN 0 | SKIP 432 | PASS 986 ]`, with 419 tests skipped on CRAN and
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
