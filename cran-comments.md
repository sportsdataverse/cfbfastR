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
  within 120 seconds.
* Adds ten `cfbd_*()` wrappers for the CollegeFootballData passing and rushing
  endpoints, plus schedule, preview and team-overview endpoints.
* Adds loaders for season-by-season conference and division membership.
* No longer downloads anything when the package is loaded: the models are fetched
  the first time a function scores a play.
* Raises the httr2 floor to 1.1.0 and the purrr floor to 1.0.0 (the versions that
  provide functions the package imports), declares `stats` and `utils` in
  Imports, and drops the unused Rcpp and RcppParallel imports. This fixes the
  r-devel NOTE on the 3.0.0 check page about `stats` being imported but only
  suggested.

## Test environments

* local Windows 10, R 4.6.1, `R CMD check --as-cran` with `--run-donttest`
* GitHub Actions: windows-latest (release), ubuntu-latest (release, oldrel-1)
* win-builder: R-devel, R-release (TO RUN before submission)
* R-hub: linux, windows, macOS (R-devel) (TO RUN before submission)

## R CMD check results

0 errors | 0 warnings | 1 note

* checking for non-standard things in the check directory: `''NULL''`. This is
  created by the local Windows R startup, not by the package; it does not appear
  on GitHub Actions.

Under `R CMD check` the model bundle that examples download is cached in
`tempdir()`, so the check leaves nothing in the user's file space.

## Tests on CRAN

Tests that need the network (the CollegeFootballData API, which also needs an API
key; ESPN; the GitHub release assets) or the downloaded model bundle call
`skip_on_cran()`. The remaining tests run on CRAN and are offline: they use mocked
HTTP responses and small committed fixtures.

## Internet resources

Functions that access internet resources (the CollegeFootballData, ESPN, Fox
Sports and Yahoo Sports APIs, and the pre-built season datasets on GitHub release
assets) fail with an informative message when the resource is unavailable. Most
return an empty table; a few raise an error instead (for example
`cfbd_pbp_data(engine = "legacy")` on a non-200 response) and
`yahoo_cfb_boxscore()` returns `NULL`. Every example that touches the network is
wrapped in `\donttest{try(...)}`, and the CollegeFootballData examples stop
before sending any request when no API key is set.

## Reverse dependencies

cfbseedR (Suggests cfbfastR). `R CMD check` on its CRAN release (0.2.0) against
this version: Status OK.
