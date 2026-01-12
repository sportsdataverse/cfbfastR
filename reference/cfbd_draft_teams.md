# **Get list of NFL teams**

**Get list of NFL teams**

## Usage

``` r
cfbd_draft_teams()
```

## Value

`cfbd_draft_teams()` - A data frame with 4 variables:

- `nfl_location`: character.:

  NFL team location (city).

- `nfl_nickname`: integer:

  NFL team nickname (mascot).

- `nfl_display_name`: integer:

  NFL team display name (usually more neat/complete).

- `nfl_logo`: character:

  URL for NFL team logo.

## See also

Other CFBD Draft:
[`cfbd_draft_picks()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft_picks.md),
[`cfbd_draft_positions()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft_positions.md)

## Examples

``` r
# \donttest{
  try(cfbd_draft_teams())
#> ── NFL teams data from CollegeFootballData.com ─────────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:32:51 UTC
#> # A tibble: 32 × 4
#>    nfl_location nfl_nickname nfl_display_name     nfl_logo                      
#>    <chr>        <chr>        <chr>                <chr>                         
#>  1 Cincinnati   Bengals      Cincinnati Bengals   https://a.espncdn.com/i/teaml…
#>  2 Tennessee    Titans       Tennessee Titans     https://a.espncdn.com/i/teaml…
#>  3 New York     Jets         New York Jets        https://a.espncdn.com/i/teaml…
#>  4 Buffalo      Bills        Buffalo Bills        https://a.espncdn.com/i/teaml…
#>  5 New Orleans  Saints       New Orleans Saints   https://a.espncdn.com/i/teaml…
#>  6 Denver       Broncos      Denver Broncos       https://a.espncdn.com/i/teaml…
#>  7 Arizona      Cardinals    Arizona Cardinals    https://a.espncdn.com/i/teaml…
#>  8 Jacksonville Jaguars      Jacksonville Jaguars https://a.espncdn.com/i/teaml…
#>  9 Indianapolis Colts        Indianapolis Colts   https://a.espncdn.com/i/teaml…
#> 10 Las Vegas    Raiders      Las Vegas Raiders    https://a.espncdn.com/i/teaml…
#> # ℹ 22 more rows
# }
```
