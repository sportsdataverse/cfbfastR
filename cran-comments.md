## Release summary

This is a major release that:

* Addresses the noted documentation issues which caused the previous release to be archived by CRAN.
* Updates the `cfbd_*()` functions to use the new College Football Data API v2. 

The following functions were added:
  * `cfbd_metrics_fg_ep()`
  * `cfbd_metrics_wepa_team_season()`
  * `cfbd_metrics_wepa_players_passing()`
  * `cfbd_metrics_wepa_players_rushing()`
  * `cfbd_metrics_wepa_players_kicking()`
  * `cfbd_ratings_fpi()`
  * `cfbd_live_scoreboard()`
  * `cfbd_live_plays()`
  * `cfbd_api_key_info()`

There are minor changes to the existing `cfbd_*()` functions under the hood. See `NEWS.md` for more details.

While I believe I updated all twitter links in the `README.md` to non-redirecting links, they do give status 403
when you try to access them without authentication. If this behavior is too problematic and against policy, please let me know and I will
make the changes to the `README.md`.

## R CMD check results

0 errors | 0 warnings | 0 notes

## revdepcheck results

We checked 0 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

* We saw 0 new problems
* We failed to check 0 packages
