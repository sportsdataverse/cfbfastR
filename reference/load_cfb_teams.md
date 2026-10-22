# Load CFB team info from the data repo

Loads team information including colors and logos - useful for plots!
This function wraps the
[`cfbd_team_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_info.md)
function sourced from the College Football Data API.

## Usage

``` r
load_cfb_teams(fbs_only = TRUE)
```

## Arguments

- fbs_only:

  if TRUE, returns only FBS teams, otherwise returns all teams in the
  dataset

## Value

A tibble of team-level image URLs and hex color codes.

## See also

[`cfbd_team_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_info.md)

Issues with this data should be filed here:
<https://github.com/sportsdataverse/cfbfastR-data>

Other loaders:
[`load_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_pbp.md),
[`load_cfb_rosters()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_rosters.md),
[`load_cfb_schedules()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_schedules.md),
[`update_cfb_db()`](https://cfbfastR.sportsdataverse.org/reference/update_cfb_db.md)

## Examples

``` r
# \donttest{
  try(load_cfb_teams())
#> 2026-10-22 17:19:47.944053:Invalid arguments or no team data available! The CFBD API returned HTTP 502 (Bad Gateway)
#> ── Team information from CollegeFootballData.com ──────── cfbfastR 3.0.0.9000 ──
#> # A tibble: 0 × 0
# }
```
