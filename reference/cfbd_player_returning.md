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

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Four-digit season year for returning production. |
| team | character | Team name. |
| conference | character | Conference of team. |
| total_ppa | numeric | Total predicted points added (PPA) returning. |
| total_passing_ppa | numeric | Total passing predicted points added returning. |
| total_receiving_ppa | numeric | Total receiving predicted points added returning. |
| total_rushing_ppa | numeric | Total rushing predicted points added returning. |
| percent_ppa | numeric | Percentage of prior year's predicted points added returning. |
| percent_passing_ppa | numeric | Percentage of prior year's passing predicted points added returning. |
| percent_receiving_ppa | numeric | Percentage of prior year's receiving predicted points added returning. |
| percent_rushing_ppa | numeric | Percentage of prior year's rushing predicted points added returning. |
| usage | numeric | Share of prior year's overall offensive usage returning. |
| passing_usage | numeric | Share of prior year's passing usage returning. |
| receiving_usage | numeric | Share of prior year's receiving usage returning. |
| rushing_usage | numeric | Share of prior year's rushing usage returning. |

## See also

Other CFBD Players:
[`cfbd_player_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_info.md),
[`cfbd_player_usage()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_usage.md)

## Examples

``` r
# \donttest{
   try(cfbd_player_returning(year = 2019, team = "Florida State"))
#> ── Returning production data from CollegeFootballData.com ──── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-06-12 13:11:25 UTC
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
