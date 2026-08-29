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
#> ── 247sports team talent ratings from CollegeFootballData.com ──────────────────
#> ℹ Data updated: 2026-08-29 13:13:04 UTC
#> # A tibble: 138 × 3
#>     year school     talent
#>    <int> <chr>       <dbl>
#>  1  2026 Georgia     1004.
#>  2  2026 Texas        985.
#>  3  2026 Oregon       984.
#>  4  2026 Alabama      974.
#>  5  2026 Ohio State   964.
#>  6  2026 Notre Dame   953.
#>  7  2026 Texas A&M    933 
#>  8  2026 LSU          932.
#>  9  2026 USC          899 
#> 10  2026 Florida      891.
#> # ℹ 128 more rows

  try(cfbd_team_talent(year = 2018))
#> ── 247sports team talent ratings from CollegeFootballData.com ──────────────────
#> ℹ Data updated: 2026-08-29 13:13:04 UTC
#> # A tibble: 236 × 3
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
#> # ℹ 226 more rows
# }
```
