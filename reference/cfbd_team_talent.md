# **Get composite team talent rankings for all teams in a given year**

Extracts team talent composite as sourced from 247 rankings

## Usage

``` r
cfbd_team_talent(year = most_recent_cfb_season())
```

## Arguments

- year:

  (*Integer* optional): Year 4 digit format (*YYYY*)  
  Minimum value accepted: 2015

## Value

`cfbd_team_talent()` - A data frame with 3 variables:

|  |  |  |
|----|----|----|
| col_name | types | description |
| year | integer | Season for the talent rating. |
| school | character | Team name. |
| talent | numeric | Overall roster talent points (as determined by 247Sports). |

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
#> 2026-08-27 11:48:50.838805:Invalid arguments or no team talent data available! ℹ In argument: `talent = as.numeric(.data$talent)`.
#> Caused by error in `.data$talent`:
#> ! Column `talent` not found in `.data`.
#> data frame with 0 columns and 0 rows

  try(cfbd_team_talent(year = 2018))
#> ── 247sports team talent ratings from CollegeFootballData.com ──────────────────
#> ℹ Data updated: 2026-08-27 11:48:50 UTC
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
