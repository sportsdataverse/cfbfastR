# **Get SP historical rating data**

At least one of **year** or **team** must be specified for the function
to run

## Usage

``` r
cfbd_ratings_sp(year = NULL, team = NULL)
```

## Arguments

- year:

  (*Integer* optional): Year, 4 digit format (*YYYY*). Required if team
  not provided

- team:

  (*String* optional): D-I Team. Required if year not provided

## Value

`cfbd_ratings_sp()` - A data frame with 26 variables:

|                           |           |
|---------------------------|-----------|
| col_name                  | types     |
| year                      | integer   |
| team                      | character |
| conference                | character |
| rating                    | numeric   |
| ranking                   | integer   |
| second_order_wins         | numeric   |
| sos                       | numeric   |
| offense_ranking           | integer   |
| offense_rating            | numeric   |
| offense_success           | numeric   |
| offense_explosiveness     | numeric   |
| offense_rushing           | numeric   |
| offense_passing           | numeric   |
| offense_standard_downs    | numeric   |
| offense_passing_downs     | numeric   |
| offense_run_rate          | numeric   |
| offense_pace              | numeric   |
| defense_ranking           | integer   |
| defense_rating            | numeric   |
| defense_success           | numeric   |
| defense_explosiveness     | numeric   |
| defense_rushing           | numeric   |
| defense_passing           | numeric   |
| defense_standard_downs    | numeric   |
| defense_passing_downs     | numeric   |
| defense_havoc_total       | numeric   |
| defense_havoc_front_seven | numeric   |
| defense_havoc_db          | numeric   |
| special_teams_rating      | numeric   |

## See also

Other CFBD Ratings and Rankings:
[`cfbd_rankings()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rankings.md),
[`cfbd_ratings_elo()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_elo.md),
[`cfbd_ratings_fpi()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_fpi.md),
[`cfbd_ratings_sp_conference()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_sp_conference.md),
[`cfbd_ratings_srs()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_srs.md)

## Examples

``` r
# \donttest{
  try(cfbd_ratings_sp(year = 2018))
#> ── SP+ data from CollegeFootballData.com ───────────────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:33:42 UTC
#> # A tibble: 131 × 29
#>     year team  conference rating ranking second_order_wins   sos offense_ranking
#>    <int> <chr> <chr>       <dbl>   <int>             <dbl> <dbl>           <int>
#>  1  2018 Alab… SEC          36.3       1              13.8 0.795               2
#>  2  2018 Geor… SEC          32.9       2              11.5 0.794               3
#>  3  2018 Clem… ACC          29.7       3              14   0.912               5
#>  4  2018 Okla… SEC          24.9       4              11.7 0.909               1
#>  5  2018 LSU   SEC          24.2       5               9.1 0.75               30
#>  6  2018 Ohio… Big Ten      24.1       6              10.9 0.899               4
#>  7  2018 Aubu… SEC          23.6       7               8.2 0.761              19
#>  8  2018 Miss… SEC          23.2       8               8.7 0.791              32
#>  9  2018 Flor… SEC          23         9               9.7 0.813              15
#> 10  2018 Mich… Big Ten      22        10              10.3 0.867              25
#> # ℹ 121 more rows
#> # ℹ 21 more variables: offense_rating <dbl>, offense_success <dbl>,
#> #   offense_explosiveness <dbl>, offense_rushing <dbl>, offense_passing <dbl>,
#> #   offense_standard_downs <dbl>, offense_passing_downs <dbl>,
#> #   offense_run_rate <dbl>, offense_pace <dbl>, defense_ranking <int>,
#> #   defense_rating <dbl>, defense_success <dbl>, defense_explosiveness <dbl>,
#> #   defense_rushing <dbl>, defense_passing <dbl>, …

  try(cfbd_ratings_sp(team = "Texas A&M"))
#> ── SP+ data from CollegeFootballData.com ───────────────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:33:42 UTC
#> # A tibble: 112 × 29
#>     year team  conference rating ranking second_order_wins   sos offense_ranking
#>    <int> <chr> <chr>       <dbl>   <int>             <dbl> <dbl>           <int>
#>  1  1970 Texa… SEC          -1.7      52                NA    NA              50
#>  2  1971 Texa… SEC          -3.5      54                NA    NA              56
#>  3  1972 Texa… SEC           3.7      48                NA    NA              53
#>  4  1973 Texa… SEC           8.9      42                NA    NA              37
#>  5  1974 Texa… SEC          14.9      27                NA    NA              49
#>  6  1975 Texa… SEC          19.1      17                NA    NA              44
#>  7  1976 Texa… SEC          20.8      11                NA    NA              23
#>  8  1977 Texa… SEC          11.8      34                NA    NA              11
#>  9  1978 Texa… SEC           8.2      43                NA    NA              45
#> 10  1979 Texa… SEC          21.4       7                NA    NA              39
#> # ℹ 102 more rows
#> # ℹ 21 more variables: offense_rating <dbl>, offense_success <dbl>,
#> #   offense_explosiveness <dbl>, offense_rushing <dbl>, offense_passing <dbl>,
#> #   offense_standard_downs <dbl>, offense_passing_downs <dbl>,
#> #   offense_run_rate <dbl>, offense_pace <dbl>, defense_ranking <int>,
#> #   defense_rating <dbl>, defense_success <dbl>, defense_explosiveness <dbl>,
#> #   defense_rushing <dbl>, defense_passing <dbl>, …

  try(cfbd_ratings_sp(year = 2019, team = "Texas"))
#> ── SP+ data from CollegeFootballData.com ───────────────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:33:43 UTC
#> # A tibble: 2 × 29
#>    year team   conference rating ranking second_order_wins sos   offense_ranking
#>   <int> <chr>  <chr>       <dbl>   <int> <lgl>             <lgl>           <int>
#> 1  2019 Texas  SEC        12           1 NA                NA                  1
#> 2  2019 natio… NA          0.760      NA NA                NA                 NA
#> # ℹ 21 more variables: offense_rating <dbl>, offense_success <lgl>,
#> #   offense_explosiveness <lgl>, offense_rushing <lgl>, offense_passing <lgl>,
#> #   offense_standard_downs <lgl>, offense_passing_downs <lgl>,
#> #   offense_run_rate <lgl>, offense_pace <lgl>, defense_ranking <int>,
#> #   defense_rating <dbl>, defense_success <lgl>, defense_explosiveness <lgl>,
#> #   defense_rushing <lgl>, defense_passing <lgl>, defense_standard_downs <lgl>,
#> #   defense_passing_downs <lgl>, defense_havoc_total <lgl>, …
# }
```
