# **Get composite team talent rankings for all teams in a given year**

Extracts team talent composite as sourced from 247 rankings

## Usage

``` r
cfbd_team_talent(year = most_recent_cfb_season())
```

## Arguments

- year:

  (*Integer* optional): Year 4 digit format (*YYYY*)

## Value

`cfbd_team_talent()` - A data frame with 3 variables:

- `year`: integer.:

  Season for the talent rating.

- `school`: character.:

  Team name.

- `talent`: double.:

  Overall roster talent points (as determined by 247Sports).

## See also

Other CFBD Teams:
[`cfbd_team_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_info.md),
[`cfbd_team_matchup()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_matchup.md),
[`cfbd_team_matchup_records()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_matchup_records.md),
[`cfbd_team_roster()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_roster.md)

## Examples

``` r
# \donttest{
  try(cfbd_team_talent())
#> ── 247sports team talent ratings from CollegeFootballData.com ──────────────────
#> ℹ Data updated: 2026-01-19 16:23:06 UTC
#> # A tibble: 134 × 3
#>     year school     talent
#>    <int> <chr>       <dbl>
#>  1  2025 Georgia     1003.
#>  2  2025 Alabama      994.
#>  3  2025 Ohio State   974.
#>  4  2025 Texas        974.
#>  5  2025 Oregon       941.
#>  6  2025 LSU          920.
#>  7  2025 Clemson      918.
#>  8  2025 Texas A&M    917.
#>  9  2025 Notre Dame   912.
#> 10  2025 Penn State   910.
#> # ℹ 124 more rows

  try(cfbd_team_talent(year = 2018))
#> ── 247sports team talent ratings from CollegeFootballData.com ──────────────────
#> ℹ Data updated: 2026-01-19 16:23:06 UTC
#> # A tibble: 237 × 3
#>     year school        talent
#>    <int> <chr>          <dbl>
#>  1  2018 Ohio State      984.
#>  2  2018 Alabama         979.
#>  3  2018 Georgia         964 
#>  4  2018 USC             934.
#>  5  2018 Clemson         893.
#>  6  2018 LSU             890.
#>  7  2018 Florida State   889.
#>  8  2018 Michigan        862.
#>  9  2018 Texas           861.
#> 10  2018 Notre Dame      848.
#> # ℹ 227 more rows
# }
```
