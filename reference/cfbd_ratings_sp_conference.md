# **Get conference level SP historical rating data**

**Get conference level SP historical rating data**

## Usage

``` r
cfbd_ratings_sp_conference(year = NULL, conference = NULL)
```

## Arguments

- year:

  (*Integer* optional): Year, 4 digit format (*YYYY*)

- conference:

  (*String* optional): Conference abbreviation - S&P+ information by
  conference Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC

## Value

`cfbd_ratings_sp_conference()` - A data frame with 25 variables:

- `year`: integer.:

  Season of the conference rating.

- `conference`: character.:

  Conference name.

- `rating`: double.:

  Conference SP+ rating.

- `second_order_wins`: logical.:

  Second-order wins for the conference - Not available for recent
  seasons.

- `sos`: logical.:

  Strength of schedule for the conference - Not available for recent
  seasons..

- `offense_rating`: double.:

  Overall offense rating for the conference.

- `offense_success`: logical.:

  Offense success rating for the conference - Not available for recent
  seasons.

- `offense_explosiveness`: logical.:

  Offense explosiveness rating for the conference - Not available for
  recent seasons.

- `offense_rushing`: logical.:

  Offense rushing rating for the conference - Not available for recent
  seasons.

- `offense_passing`: logical.:

  Offense passing rating for the conference - Not available for recent
  seasons.

- `offense_standard_downs`: logical.:

  Offense standard downs rating for the conference - Not available for
  recent seasons.

- `offense_passing_downs`: logical.:

  Offensive passing downs rating for the conference - Not available for
  recent seasons.

- `offense_run_rate`: logical.:

  Offense rushing rate for the conference - Not available for recent
  seasons.

- `offense_pace`: logical.:

  Offense pace factor for the conference - Not available for recent
  seasons.

- `defense_ranking`: integer.:

  Overall defense ranking for the conference.

- `defense_rating`: double.:

  Overall defense rating for the conference.

- `defense_success`: logical.:

  Defense success rating for the conference - Not available for recent
  seasons.

- `defense_explosiveness`: logical.:

  Defense explosiveness rating for the conference - Not available for
  recent seasons.

- `defense_rushing`: logical.:

  Defense rushing rating for the conference - Not available for recent
  seasons.

- `defense_passing`: logical.:

  Defense passing rating for the conference - Not available for recent
  seasons.

- `defense_standard_downs`: logical.:

  Defense standard downs rating for the conference - Not available for
  recent seasons.

- `defense_passing_downs`: logical.:

  Defensive passing downs rating for the conference - Not available for
  recent seasons.

- `defense_havoc_total`: logical.:

  Total defensive havoc rate for the conference - Not available for
  recent seasons.

- `defense_havoc_front_seven`: logical.:

  Defense havoc rate from front 7 players for the conference - Not
  available for recent seasons.

- `defense_havoc_db`: logical.:

  Defense havoc rate from defensive backs for the conference - Not
  available for recent seasons.

- `special_teams_rating`: double.:

  Special teams rating for the conference.

## See also

Other CFBD Ratings and Rankings:
[`cfbd_rankings()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rankings.md),
[`cfbd_ratings_elo()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_elo.md),
[`cfbd_ratings_fpi()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_fpi.md),
[`cfbd_ratings_sp()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_sp.md),
[`cfbd_ratings_srs()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_srs.md)

## Examples

``` r
# \donttest{
  try(cfbd_ratings_sp_conference(year = 2019))
#> ── Conference SP+ data from CollegeFootballData.com ────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 12:21:22 UTC
#> # A tibble: 11 × 25
#>     year conference        rating second_order_wins sos   offense_rating
#>    <int> <chr>              <dbl> <lgl>             <lgl>          <dbl>
#>  1  2019 ACC                 2.97 NA                NA              28.3
#>  2  2019 American Athletic   1.35 NA                NA              29.1
#>  3  2019 Big 12              7.26 NA                NA              32.6
#>  4  2019 Big Ten             9.49 NA                NA              30.9
#>  5  2019 Conference USA     -9.23 NA                NA              22.1
#>  6  2019 FBS Independents   -7.05 NA                NA              26.1
#>  7  2019 Mid-American      -10.4  NA                NA              24.2
#>  8  2019 Mountain West      -3.91 NA                NA              26.1
#>  9  2019 Pac-12              5.28 NA                NA              32.5
#> 10  2019 SEC                12.2  NA                NA              32.0
#> 11  2019 Sun Belt           -6.14 NA                NA              27.4
#> # ℹ 19 more variables: offense_success <lgl>, offense_explosiveness <lgl>,
#> #   offense_rushing <lgl>, offense_passing <lgl>, offense_standard_downs <lgl>,
#> #   offense_passing_downs <lgl>, offense_run_rate <lgl>, offense_pace <lgl>,
#> #   defense_rating <dbl>, defense_success <lgl>, defense_explosiveness <lgl>,
#> #   defense_rushing <lgl>, defense_passing <lgl>, defense_standard_downs <lgl>,
#> #   defense_passing_downs <lgl>, defense_havoc_total <lgl>,
#> #   defense_havoc_front_seven <lgl>, defense_havoc_db <lgl>, …

  try(cfbd_ratings_sp_conference(year = 2012, conference = "SEC"))
#> ── Conference SP+ data from CollegeFootballData.com ────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 12:21:22 UTC
#> # A tibble: 1 × 25
#>    year conference rating second_order_wins   sos offense_rating offense_success
#>   <int> <chr>       <dbl>             <dbl> <dbl>          <dbl>           <dbl>
#> 1  2012 SEC          15.7              7.85 0.817           34.8            105.
#> # ℹ 18 more variables: offense_explosiveness <dbl>, offense_rushing <dbl>,
#> #   offense_passing <dbl>, offense_standard_downs <dbl>,
#> #   offense_passing_downs <dbl>, offense_run_rate <dbl>, offense_pace <dbl>,
#> #   defense_rating <dbl>, defense_success <dbl>, defense_explosiveness <dbl>,
#> #   defense_rushing <dbl>, defense_passing <dbl>, defense_standard_downs <dbl>,
#> #   defense_passing_downs <dbl>, defense_havoc_total <dbl>,
#> #   defense_havoc_front_seven <dbl>, defense_havoc_db <dbl>, …

  try(cfbd_ratings_sp_conference(year = 2016, conference = "ACC"))
#> ── Conference SP+ data from CollegeFootballData.com ────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 12:21:22 UTC
#> # A tibble: 1 × 25
#>    year conference rating second_order_wins   sos offense_rating offense_success
#>   <int> <chr>       <dbl>             <dbl> <dbl>          <dbl>           <dbl>
#> 1  2016 ACC          10.3              7.57 0.849           33.2            104.
#> # ℹ 18 more variables: offense_explosiveness <dbl>, offense_rushing <dbl>,
#> #   offense_passing <dbl>, offense_standard_downs <dbl>,
#> #   offense_passing_downs <dbl>, offense_run_rate <dbl>, offense_pace <dbl>,
#> #   defense_rating <dbl>, defense_success <dbl>, defense_explosiveness <dbl>,
#> #   defense_rushing <dbl>, defense_passing <dbl>, defense_standard_downs <dbl>,
#> #   defense_passing_downs <dbl>, defense_havoc_total <dbl>,
#> #   defense_havoc_front_seven <dbl>, defense_havoc_db <dbl>, …
# }
```
