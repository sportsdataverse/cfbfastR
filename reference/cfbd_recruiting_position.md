# **Get college football position group recruiting information.**

**Get college football position group recruiting information.**

## Usage

``` r
cfbd_recruiting_position(
  start_year = NULL,
  end_year = NULL,
  team = NULL,
  conference = NULL
)
```

## Arguments

- start_year:

  (*Integer* optional): Start Year, 4 digit format (*YYYY*). *Note: 2000
  is the minimum value*

- end_year:

  (*Integer* optional): End Year, 4 digit format (*YYYY*). *Note: 2020
  is the maximum value currently*

- team:

  (*String* optional): Team - Select a valid team, D-I football

- conference:

  (*String* optional): Conference abbreviation - Select a valid FBS
  conference Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC

## Value

`cfbd_recruiting_position()` - A data frame with 7 variables:

- `team`: character.:

  Recruiting team.

- `conference`: character.:

  Recruiting team conference.

- `position_group`: character.:

  Position group of the recruits.

- `avg_rating`: double.:

  Average rating of the recruits in the position group.

- `total_rating`: double.:

  Sum of the ratings of the recruits in the position group.

- `commits`: integer.:

  Number of commits in the position group.

- `avg_stars`: double.:

  Average stars of the recruits in the position group.

## See also

Other CFBD Recruiting:
[`cfbd_recruiting_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_player.md),
[`cfbd_recruiting_team()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_team.md),
[`cfbd_recruiting_transfer_portal()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_transfer_portal.md)

## Examples

``` r
# \donttest{
  try(cfbd_recruiting_position(2018, team = "Texas"))
#> ── Recruiting position group info from CollegeFootballData.com ─────────────────
#> ℹ Data updated: 2026-01-19 16:22:45 UTC
#> # A tibble: 16 × 7
#>    team  conference position_group avg_rating total_rating commits avg_stars    
#>    <chr> <chr>      <chr>               <dbl>        <dbl> <chr>   <chr>        
#>  1 Texas SEC        Defensive Back      0.939         34.7 37      4.0810810810…
#>  2 Texas SEC        Defensive Line      0.923         35.1 38      3.8947368421…
#>  3 Texas SEC        Linebacker          0.902         18.9 21      3.6190476190…
#>  4 Texas SEC        Offensive Line      0.914         26.5 29      3.8965517241…
#>  5 Texas SEC        Quarterback         0.933         10.3 11      4.0909090909…
#>  6 Texas SEC        Receiver            0.927         27.8 30      3.8333333333…
#>  7 Texas SEC        Running Back        0.930         11.2 12      4.0833333333…
#>  8 Texas SEC        Special Teams       0.878         17.6 20      3.4500000000…
#>  9 Texas SEC        All Positions       0.939         34.7 37      4.0810810810…
#> 10 Texas SEC        All Positions       0.923         35.1 38      3.8947368421…
#> 11 Texas SEC        All Positions       0.902         18.9 21      3.6190476190…
#> 12 Texas SEC        All Positions       0.914         26.5 29      3.8965517241…
#> 13 Texas SEC        All Positions       0.933         10.3 11      4.0909090909…
#> 14 Texas SEC        All Positions       0.927         27.8 30      3.8333333333…
#> 15 Texas SEC        All Positions       0.930         11.2 12      4.0833333333…
#> 16 Texas SEC        All Positions       0.878         17.6 20      3.4500000000…

  try(cfbd_recruiting_position(2016, 2020, team = "Virginia"))
#> ── Recruiting position group info from CollegeFootballData.com ─────────────────
#> ℹ Data updated: 2026-01-19 16:22:45 UTC
#> # A tibble: 16 × 7
#>    team     conference position_group avg_rating total_rating commits avg_stars 
#>    <chr>    <chr>      <chr>               <dbl>        <dbl> <chr>   <chr>     
#>  1 Virginia ACC        Defensive Back      0.831         9.15 11      2.8181818…
#>  2 Virginia ACC        Defensive Line      0.851         7.66 9       3.2222222…
#>  3 Virginia ACC        Linebacker          0.848         7.63 9       3.0000000…
#>  4 Virginia ACC        Offensive Line      0.827         7.44 9       2.8888888…
#>  5 Virginia ACC        Quarterback         0.853         1.71 2       3.0000000…
#>  6 Virginia ACC        Receiver            0.835        10.0  12      2.9166666…
#>  7 Virginia ACC        Running Back        0.836         3.35 4       3.0000000…
#>  8 Virginia ACC        Special Teams       0.839         7.55 9       2.8888888…
#>  9 Virginia ACC        All Positions       0.831         9.15 11      2.8181818…
#> 10 Virginia ACC        All Positions       0.851         7.66 9       3.2222222…
#> 11 Virginia ACC        All Positions       0.848         7.63 9       3.0000000…
#> 12 Virginia ACC        All Positions       0.827         7.44 9       2.8888888…
#> 13 Virginia ACC        All Positions       0.853         1.71 2       3.0000000…
#> 14 Virginia ACC        All Positions       0.835        10.0  12      2.9166666…
#> 15 Virginia ACC        All Positions       0.836         3.35 4       3.0000000…
#> 16 Virginia ACC        All Positions       0.839         7.55 9       2.8888888…

  try(cfbd_recruiting_position(2015, 2020, conference = "SEC"))
#> ── Recruiting position group info from CollegeFootballData.com ─────────────────
#> ℹ Data updated: 2026-01-19 16:22:45 UTC
#> # A tibble: 224 × 7
#>    team     conference position_group avg_rating total_rating commits avg_stars 
#>    <chr>    <chr>      <chr>               <dbl>        <dbl> <chr>   <chr>     
#>  1 Alabama  SEC        Defensive Back      0.950        20.9  22      4.0454545…
#>  2 Alabama  SEC        Defensive Line      0.951        27.6  29      4.1724137…
#>  3 Alabama  SEC        Linebacker          0.941        15.1  16      4.0000000…
#>  4 Alabama  SEC        Offensive Line      0.939        19.7  21      4.0476190…
#>  5 Alabama  SEC        Quarterback         0.894         8.94 10      3.7000000…
#>  6 Alabama  SEC        Receiver            0.923        19.4  21      3.8571428…
#>  7 Alabama  SEC        Running Back        0.919        13.8  15      3.8000000…
#>  8 Alabama  SEC        Special Teams       0.892         7.13 8       3.6250000…
#>  9 Arkansas SEC        Defensive Back      0.861        13.8  16      3.2500000…
#> 10 Arkansas SEC        Defensive Line      0.891        14.3  16      3.5000000…
#> # ℹ 214 more rows
# }
```
