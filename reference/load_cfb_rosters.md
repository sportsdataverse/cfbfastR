# Load College Football Rosters

Loads team rosters for specified seasons. This function wraps the
[`cfbd_team_roster()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_roster.md)
function sourced from the College Football Data API.

## Usage

``` r
load_cfb_rosters(seasons = most_recent_cfb_season())
```

## Arguments

- seasons:

  a numeric vector of seasons to return, defaults to returning this
  year's data if it is September or later. If set to `TRUE`, will return
  all available data.

## Value

A tibble of season-level roster data.

## See also

[`cfbd_team_roster()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_roster.md)

Issues with this data should be filed here:
<https://github.com/sportsdataverse/cfbfastR-data>

Other loaders:
[`load_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_pbp.md),
[`load_cfb_schedules()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_schedules.md),
[`load_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_teams.md),
[`update_cfb_db()`](https://cfbfastR.sportsdataverse.org/reference/update_cfb_db.md)

## Examples

``` r
# \donttest{
  try(load_cfb_rosters(2024))
#> ── Team roster data from CollegeFootballData.com ───────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:34:24 UTC
#> # A tibble: 22,843 × 17
#>    athlete_id first_name last_name team      weight height jersey  year position
#>    <chr>      <chr>      <chr>     <chr>      <int>  <int>  <int> <int> <chr>   
#>  1 102597     Will       Rogers    Washingt…    216     74      7     4 QB      
#>  2 107494     Trey       Sanders   TCU          215     72      2     4 RB      
#>  3 146583     John       Adams     Temple       190     74     17     3 WR      
#>  4 160900     Will       Johnson   Michigan      NA     NA     NA  2024 NA      
#>  5 184812     Calvin     Moore     Cal Poly     180     70      4     2 CB      
#>  6 233186     Josh       Jenkins   Holy Cro…    190     73      9     3 QB      
#>  7 245322     Marcus     Patterson Western …    260     75      6     3 DL      
#>  8 383510     John       Williams  Cincinna…    320     77     75     4 OL      
#>  9 385738     Jacob      Johnson   Southern…    200     74     48     2 LB      
#> 10 484303     Patrick    Ryan      Georgeto…    204     74     89     2 P       
#> # ℹ 22,833 more rows
#> # ℹ 8 more variables: home_city <chr>, home_state <chr>, home_country <chr>,
#> #   home_latitude <dbl>, home_longitude <dbl>, home_county_fips <chr>,
#> #   recruit_ids <list>, headshot_url <chr>
# }
```
