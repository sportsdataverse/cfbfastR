## Release summary

This is a minor release that:

* Fixes a bug in `cfbd_pbp_data()` where play-by-play data for some games were not as expected.
* Improves `add_yardage()` where plays with missing yardage values were not being handled correctly.
* Fixes a small bug in an underlying helper function, `validate_week()`, used throughout the package.
* Updates documentation to reflect a handful of default parameter changes made.


## R CMD check results

0 errors | 0 warnings | 0 notes

## revdepcheck results

We checked 0 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

* We saw 0 new problems
* We failed to check 0 packages
