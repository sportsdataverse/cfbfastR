# **Get SRS historical rating data**

At least one of **year** or **team** must be specified for the function
to run

## Usage

``` r
cfbd_ratings_srs(year = NULL, team = NULL, conference = NULL)
```

## Arguments

- year:

  (*Integer* optional): Year, 4 digit format (*YYYY*). Required if team
  not provided

- team:

  (*String* optional): D-I Team. Required if year not provided

- conference:

  (*String* optional): Conference abbreviation - SRS information by
  conference Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC

## Value

`cfbd_ratings_srs()` - A data frame with 6 variables:

- `year`: integer.:

  Season of the SRS rating.

- `team`: character.:

  Team name.

- `conference`: character.:

  Conference of the team.

- `division`: logical.:

  Division in the conference for the team.

- `rating`: double.:

  Simple Rating System (SRS) rating.

- `ranking`: integer.:

  Simple Rating System ranking within the group returned.

## See also

Other CFBD Ratings and Rankings:
[`cfbd_rankings()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rankings.md),
[`cfbd_ratings_elo()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_elo.md),
[`cfbd_ratings_fpi()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_fpi.md),
[`cfbd_ratings_sp()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_sp.md),
[`cfbd_ratings_sp_conference()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_sp_conference.md)

## Examples

``` r
# \donttest{
  try(cfbd_ratings_srs(year = 2019, team = "Texas"))
#> ── SRS data from CollegeFootballData.com ───────────────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 12:21:23 UTC
#> # A tibble: 1 × 6
#>    year team  conference division ranking rating
#>   <int> <chr> <chr>      <lgl>      <int>  <dbl>
#> 1  2019 Texas Big 12     NA             1   16.0

  try(cfbd_ratings_srs(year = 2018, conference = "SEC"))
#> ── SRS data from CollegeFootballData.com ───────────────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 12:21:23 UTC
#> # A tibble: 14 × 6
#>     year team              conference division ranking rating
#>    <int> <chr>             <chr>      <chr>      <int>  <dbl>
#>  1  2018 Alabama           SEC        West           1 33.5  
#>  2  2018 Georgia           SEC        East           2 26.3  
#>  3  2018 Mississippi State SEC        West           3 19.8  
#>  4  2018 Florida           SEC        East           4 19.3  
#>  5  2018 Missouri          SEC        East           5 18.9  
#>  6  2018 LSU               SEC        West           6 18.3  
#>  7  2018 Texas A&M         SEC        West           7 17.9  
#>  8  2018 Auburn            SEC        West           8 15.0  
#>  9  2018 Kentucky          SEC        East           9 14.7  
#> 10  2018 Vanderbilt        SEC        East          10  9.93 
#> 11  2018 South Carolina    SEC        East          11  9.65 
#> 12  2018 Ole Miss          SEC        West          12  3.46 
#> 13  2018 Tennessee         SEC        East          13  0.934
#> 14  2018 Arkansas          SEC        West          14 -7.16 
# }
```
