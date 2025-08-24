## Release summary

This is a major release that updates the `cfbd_*()` functions to use the new College Football Data API v2. 
The following functions were added:
* `cfbd_metrics_fg_ep()`
* `cfbd_metrics_wepa_team_season()`
* `cfbd_metrics_wepa_players_passing()`
* `cfbd_metrics_wepa_players_rushing()`
* `cfbd_metrics_wepa_players_kicking()`
* `cfbd_ratings_fpi()`
* `cfbd_live_scoreboard()`
* `cfbd_live_plays()`

There are minor changes to the existing `cfbd_*()` functions under the hood. See NEWS.md for more details.


## R CMD check results

0 errors | 0 warnings | 0 notes

## revdepcheck results

We checked 0 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * We saw 0 new problems
 * We failed to check 0 packages
