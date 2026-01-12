# **Get player returning production**

**Get player returning production**

## Usage

``` r
cfbd_player_returning(
  year = most_recent_cfb_season(),
  team = NULL,
  conference = NULL
)
```

## Arguments

- year:

  (*Integer* required, default most recent season): Year, 4 digit format
  (*YYYY*).

- team:

  (*String* optional): Team - Select a valid team, D1 football

- conference:

  (*String* optional): Conference abbreviation - Select a valid FBS
  conference Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC

## Value

`cfbd_player_returning()` - A data frame with 15 variables:

- `season`:integer.:

  Returning player season.

- `team`:character.:

  Team name.

- `conference`:character.:

  Conference of team.

- `total_ppa`:double.:

  Total predicted points added returning.

- `total_passing_ppa`:double.:

  Total passing predicted points added returning.

- `total_receiving_ppa`:double.:

  Total receiving predicted points added returning.

- `total_rushing_ppa`:double.:

  Total rushing predicted points added returning.

- `percent_ppa`:double.:

  Percentage of prior year's predicted points added returning.

- `percent_passing_ppa`:double.:

  Percentage of prior year's passing predicted points added returning.

- `percent_receiving_ppa`:double.:

  Percentage of prior year's receiving predicted points added returning.

- `percent_rushing_ppa`:double.:

  Percentage of prior year's rushing predicted points added returning.

- `usage`:double.:

  .

- `passing_usage`:double.:

  .

- `receiving_usage`:double.:

  .

- `rushing_usage`:double.:

  .

## See also

Other CFBD Players:
[`cfbd_player_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_info.md),
[`cfbd_player_usage()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_usage.md)

## Examples

``` r
# \donttest{
   try(cfbd_player_returning(year = 2019, team = "Florida State"))
#> ── Returning production data from CollegeFootballData.com ──── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:33:35 UTC
#> # A tibble: 1 × 15
#>   season team         conference total_ppa total_passing_ppa total_receiving_ppa
#>    <int> <chr>        <chr>          <dbl>             <dbl>               <dbl>
#> 1   2019 Florida Sta… ACC             144.              30.2                115.
#> # ℹ 9 more variables: total_rushing_ppa <dbl>, percent_ppa <dbl>,
#> #   percent_passing_ppa <dbl>, percent_receiving_ppa <dbl>,
#> #   percent_rushing_ppa <dbl>, usage <dbl>, passing_usage <dbl>,
#> #   receiving_usage <dbl>, rushing_usage <dbl>
# }
```
