# **Get Elo historical rating data**

Acquire the CFBD calculated elo ratings data by team, year, week, and
conference

## Usage

``` r
cfbd_ratings_elo(
  year = NULL,
  week = NULL,
  season_type = "both",
  team = NULL,
  conference = NULL
)
```

## Arguments

- year:

  (*Integer* optional): Year, 4 digit format (*YYYY*)  
  Minimum value accepted: 1890

- week:

  (*Integer* optional): Maximum Week of ratings.

- season_type:

  (*String* default both): Season type - regular, postseason, both,
  allstar, spring_regular, spring_postseason

- team:

  (*String* optional): D-I Team

- conference:

  (*String* optional): Conference abbreviation - Elo information by
  conference Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC

## Value

`cfbd_ratings_elo()` - A data frame with 4 variables:

|  |  |  |
|----|----|----|
| col_name | types | description |
| year | integer | Four-digit season year (e.g. 2019). |
| team | character | Full team name (e.g. "Texas"). |
| conference | character | Conference affiliation for the team in the given season. |
| elo | numeric | CFBD-calculated Elo rating for the team as of the requested week. |

## See also

Other CFBD Ratings and Rankings:
[`cfbd_rankings()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rankings.md),
[`cfbd_ratings_fpi()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_fpi.md),
[`cfbd_ratings_sp()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_sp.md),
[`cfbd_ratings_sp_conference()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_sp_conference.md),
[`cfbd_ratings_srs()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_srs.md)

## Examples

``` r
# \donttest{
  try(cfbd_ratings_elo(year = 2019, team = "Texas"))
#> ── Elo ratings from CollegeFootballData.com ───────────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-09-01 11:23:37 UTC
#> # A tibble: 1 × 4
#>    year team  conference   elo
#>   <int> <chr> <chr>      <dbl>
#> 1  2019 Texas Big 12      1866

  try(cfbd_ratings_elo(year = 2018, conference = "SEC"))
#> ── Elo ratings from CollegeFootballData.com ───────────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-09-01 11:23:38 UTC
#> # A tibble: 14 × 4
#>     year team              conference   elo
#>    <int> <chr>             <chr>      <dbl>
#>  1  2018 Alabama           SEC         2257
#>  2  2018 Arkansas          SEC         1285
#>  3  2018 Auburn            SEC         1958
#>  4  2018 Florida           SEC         1775
#>  5  2018 Georgia           SEC         2006
#>  6  2018 Kentucky          SEC         1672
#>  7  2018 LSU               SEC         1850
#>  8  2018 Mississippi State SEC         1937
#>  9  2018 Missouri          SEC         1851
#> 10  2018 Ole Miss          SEC         1465
#> 11  2018 South Carolina    SEC         1548
#> 12  2018 Tennessee         SEC         1349
#> 13  2018 Texas A&M         SEC         1858
#> 14  2018 Vanderbilt        SEC         1551
# }
```
