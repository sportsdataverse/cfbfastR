# **Get Football Power Index (FPI) historical rating data**

Acquire the ESPN calculated FPI ratings data by team, year, and
conference

## Usage

``` r
cfbd_ratings_fpi(year = NULL, team = NULL, conference = NULL)
```

## Arguments

- year:

  (*Integer* optional): Year, 4 digit format (*YYYY*). Required if team
  not provided  
  Minimum value accepted: 2005

- team:

  (*String* optional): D-I Team. Required if year not provided

- conference:

  (*String* optional): Conference name - select a valid FBS conference
  Conference names P5: ACC, Big 12, Big Ten, SEC, Pac-12 Conference
  names G5 and FBS Independents: Conference USA, Mid-American, Mountain
  West, FBS Independents, American Athletic

## Value

`cfbd_ratings_fpi()` - A data frame with 14 variables:

|  |  |  |
|----|----|----|
| col_name | types | description |
| year | integer | Four-digit season year (e.g. 2019). |
| team | character | Full team name (e.g. "Texas"). |
| conference | character | Conference affiliation for the team in the given season. |
| fpi | numeric | ESPN Football Power Index rating (projected scoring margin vs. average team). |
| resume_ranks_strength_of_record | integer | National rank of the team's strength of record (1 = best). |
| resume_ranks_fpi | integer | National rank of the team's FPI rating (1 = best). |
| resume_ranks_average_win_probability | integer | National rank of the team's average single-game win probability (1 = best). |
| resume_ranks_strength_of_schedule | integer | National rank of the team's schedule strength to date (1 = toughest). |
| resume_ranks_remaining_strength_of_schedule | integer | National rank of the team's remaining schedule strength (1 = toughest). |
| resume_ranks_game_control | integer | National rank of the team's average in-game win probability (1 = best). |
| efficiencies_overall | numeric | Overall FPI efficiency rating (combined offense, defense, and special teams). |
| efficiencies_offense | numeric | FPI offensive efficiency rating. |
| efficiencies_defense | numeric | FPI defensive efficiency rating. |
| efficiencies_special_teams | numeric | FPI special teams efficiency rating. |

## See also

Other CFBD Ratings and Rankings:
[`cfbd_rankings()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rankings.md),
[`cfbd_ratings_elo()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_elo.md),
[`cfbd_ratings_sp()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_sp.md),
[`cfbd_ratings_sp_conference()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_sp_conference.md),
[`cfbd_ratings_srs()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_srs.md)

## Examples

``` r
# \donttest{
  try(cfbd_ratings_fpi(year = 2019, team = "Texas"))
#> ── ESPN FPI ratings from CollegeFootballData.com ───────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-24 11:35:22 UTC
#> # A tibble: 1 × 14
#>    year team  conference   fpi resume_ranks_strength_of_record resume_ranks_fpi
#>   <int> <chr> <chr>      <dbl>                           <int>            <int>
#> 1  2019 Texas Big 12      13.0                              26               20
#> # ℹ 8 more variables: resume_ranks_average_win_probability <int>,
#> #   resume_ranks_strength_of_schedule <int>,
#> #   resume_ranks_remaining_strength_of_schedule <lgl>,
#> #   resume_ranks_game_control <int>, efficiencies_overall <dbl>,
#> #   efficiencies_offense <dbl>, efficiencies_defense <dbl>,
#> #   efficiencies_special_teams <dbl>

  try(cfbd_ratings_fpi(year = 2018, conference = "SEC"))
#> ── ESPN FPI ratings from CollegeFootballData.com ───────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-24 11:35:22 UTC
#> # A tibble: 14 × 14
#>     year team           conference   fpi resume_ranks_strengt…¹ resume_ranks_fpi
#>    <int> <chr>          <chr>      <dbl>                  <int>            <int>
#>  1  2018 Georgia        SEC        24.9                       7                3
#>  2  2018 Florida        SEC        17.1                      10               11
#>  3  2018 Tennessee      SEC         1.22                     49               65
#>  4  2018 South Carolina SEC         8.26                     36               35
#>  5  2018 Kentucky       SEC        11.4                       8               26
#>  6  2018 Vanderbilt     SEC         4.17                     56               53
#>  7  2018 Auburn         SEC        16.0                      22               12
#>  8  2018 LSU            SEC        14.9                       6               17
#>  9  2018 Alabama        SEC        30.1                       2                2
#> 10  2018 Ole Miss       SEC         2.96                     64               58
#> 11  2018 Mississippi S… SEC        18.4                      26                9
#> 12  2018 Arkansas       SEC        -5.18                    106               91
#> 13  2018 Missouri       SEC        15.3                      28               14
#> 14  2018 Texas A&M      SEC        15.9                      12               13
#> # ℹ abbreviated name: ¹​resume_ranks_strength_of_record
#> # ℹ 8 more variables: resume_ranks_average_win_probability <int>,
#> #   resume_ranks_strength_of_schedule <int>,
#> #   resume_ranks_remaining_strength_of_schedule <lgl>,
#> #   resume_ranks_game_control <int>, efficiencies_overall <dbl>,
#> #   efficiencies_offense <dbl>, efficiencies_defense <dbl>,
#> #   efficiencies_special_teams <dbl>
# }
```
