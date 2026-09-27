# **CFBD Coaches Endpoint Overview**

- `cfbd_coaches()`: A coach search function which provides coaching
  records and school history for a given coach.

- [`cfbd_coaches_profile()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches_profile.md):
  Get a single coach's biographical profile.

- [`cfbd_coaches_seasons()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches_seasons.md):
  Get season-by-season coaching records.

- [`cfbd_coaches_tenures()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches_tenures.md):
  Get the start and end of each coaching tenure.

**Coach information search** A coach search function which provides
coaching records and school history for a given coach

## Usage

``` r
cfbd_coaches(
  first = NULL,
  last = NULL,
  team = NULL,
  year = NULL,
  min_year = NULL,
  max_year = NULL
)
```

## Arguments

- first:

  (*String* optional): First name for the coach you are trying to look
  up

- last:

  (*String* optional): Last name for the coach you are trying to look up

- team:

  (*String* optional): Team - Select a valid team, D1 football

- year:

  (*Integer* optional): Year, 4 digit format (*YYYY*).  
  Minimum value accepted: 1886

- min_year:

  (*Integer* optional): Minimum Year filter (inclusive), 4 digit format
  (*YYYY*).

- max_year:

  (*Integer* optional): Maximum Year filter (inclusive), 4 digit format
  (*YYYY*)

## Value

Returns a tibble with 15 variables:

|  |  |  |
|----|----|----|
| col_name | types | description |
| first_name | character | First name of coach. |
| last_name | character | Last name of coach. |
| hire_date | character | Hire date of coach (ISO date string from CFBD). |
| school | character | School of coach for the listed season. |
| year | integer | Four-digit season year of record. |
| games | integer | Games coached during the season. |
| wins | integer | Wins for the season. |
| losses | integer | Losses for the season. |
| ties | integer | Ties for the season. |
| preseason_rank | integer | Preseason AP rank for the school of coach (NA if unranked). |
| postseason_rank | integer | Postseason AP rank for the school of coach (NA if unranked). |
| srs | character | Simple Rating System adjustment for team. |
| sp_overall | character | Bill Connelly's SP+ overall rating for team. |
| sp_offense | character | Bill Connelly's SP+ offense rating for team. |
| sp_defense | character | Bill Connelly's SP+ defense rating for team. |

## Details

### **Coach information search**

    cfbd_coaches(first = "Nick", last = "Saban", team = "alabama")

### **Get a coach profile**

    cfbd_coaches_profile(coach_id = 1)

### **Get coaching seasons**

    cfbd_coaches_seasons(team = "Georgia")

### **Get coaching tenures**

    cfbd_coaches_tenures(team = "Georgia")

## See also

Other CFBD Coaches Functions:
[`cfbd_coaches_profile()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches_profile.md),
[`cfbd_coaches_seasons()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches_seasons.md),
[`cfbd_coaches_tenures()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches_tenures.md)

## Examples

``` r
# \donttest{
  try(cfbd_coaches(first = "Nick", last = "Saban", team = "alabama"))
#> ── Coaches data from CollegeFootballData.com ──────────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-09-27 10:57:52 UTC
#> # A tibble: 17 × 19
#>       id first_name last_name hire_date    team_id school conference  year games
#>    <int> <chr>      <chr>     <chr>          <int> <chr>  <chr>      <int> <int>
#>  1   406 Nick       Saban     2007-01-03T…     333 Alaba… SEC         2007    13
#>  2   406 Nick       Saban     2007-01-03T…     333 Alaba… SEC         2008    14
#>  3   406 Nick       Saban     2007-01-03T…     333 Alaba… SEC         2009    14
#>  4   406 Nick       Saban     2007-01-03T…     333 Alaba… SEC         2010    13
#>  5   406 Nick       Saban     2007-01-03T…     333 Alaba… SEC         2011    13
#>  6   406 Nick       Saban     2007-01-03T…     333 Alaba… SEC         2012    14
#>  7   406 Nick       Saban     2007-01-03T…     333 Alaba… SEC         2013    13
#>  8   406 Nick       Saban     2007-01-03T…     333 Alaba… SEC         2014    14
#>  9   406 Nick       Saban     2007-01-03T…     333 Alaba… SEC         2015    15
#> 10   406 Nick       Saban     2007-01-03T…     333 Alaba… SEC         2016    15
#> 11   406 Nick       Saban     2007-01-03T…     333 Alaba… SEC         2017    14
#> 12   406 Nick       Saban     2007-01-03T…     333 Alaba… SEC         2018    15
#> 13   406 Nick       Saban     2007-01-03T…     333 Alaba… SEC         2019    13
#> 14   406 Nick       Saban     2007-01-03T…     333 Alaba… SEC         2020    13
#> 15   406 Nick       Saban     2007-01-03T…     333 Alaba… SEC         2021    15
#> 16   406 Nick       Saban     2007-01-03T…     333 Alaba… SEC         2022    13
#> 17   406 Nick       Saban     2007-01-03T…     333 Alaba… SEC         2023    14
#> # ℹ 10 more variables: wins <int>, losses <int>, ties <int>,
#> #   win_percentage <dbl>, preseason_rank <int>, postseason_rank <int>,
#> #   srs <dbl>, sp_overall <dbl>, sp_offense <dbl>, sp_defense <dbl>
# }
```
