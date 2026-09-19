# **Get team rosters**

Get a teams full roster by year. If team is not selected, API returns
rosters for every team from the selected year.

## Usage

``` r
cfbd_team_roster(year, team = NULL, division = NULL)
```

## Arguments

- year:

  (*Integer* required): Year, 4 digit format (*YYYY*)  
  Minimum value accepted: 2004

- team:

  (*String* optional): Team, select a valid team in D-I football

- division:

  (*String* optional): Division/classification filter – one of `fbs`,
  `fcs`, `ii`, `ii/iii`, `iii`. Sent to CFBD as `classification`.

## Value

`cfbd_team_roster()` - A data frame with 18 variables:

|  |  |  |
|----|----|----|
| col_name | types | description |
| athlete_id | character | Referencing athlete id. |
| first_name | character | Athlete first name. |
| last_name | character | Athlete last name. |
| team | character | Team name. |
| weight | integer | Athlete weight (lbs). |
| height | integer | Athlete height (inches). |
| jersey | integer | Athlete jersey number. |
| year | integer | Athlete class year (0-8; 0 = unknown). `NA` where CFBD returned the season instead of a class year (all pre-2014 rosters, most 2014-2019); use `season` for the roster year. |
| position | character | Athlete position. |
| home_city | character | Hometown of the athlete. |
| home_state | character | Hometown state of the athlete. |
| home_country | character | Hometown country of the athlete. |
| home_latitude | numeric | Hometown latitude. |
| home_longitude | numeric | Hometown longitude. |
| home_county_fips | integer | Hometown FIPS code. |
| recruit_ids | list | 247Sports recruit ids as character strings; a scalar `0L` when the athlete has none. |
| headshot_url | character | Player ESPN headshot url. |
| season | integer | Season the roster was requested for (the `year` argument). |

## See also

Other CFBD Teams:
[`cfbd_team_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_info.md),
[`cfbd_team_matchup()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_matchup.md),
[`cfbd_team_matchup_records()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_matchup_records.md),
[`cfbd_team_talent()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_talent.md)

## Examples

``` r
# \donttest{
  try(cfbd_team_roster(year = 2013, team = "Florida State"))
#> ── Team roster data from CollegeFootballData.com ──────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-09-19 04:09:39 UTC
#> # A tibble: 134 × 18
#>    athlete_id first_name last_name   team    weight height jersey  year position
#>    <chr>      <chr>      <chr>       <chr>    <int>  <int>  <int> <int> <chr>   
#>  1 -1011031   Colton     Woodall     Florid…    190     75     49    NA DB      
#>  2 -1011030   James      Wilder, Jr. Florid…    229     74     32    NA RB      
#>  3 -1011029   Levonte    Whitfield   Florid…    178     67      7    NA WR      
#>  4 -1011028   Jermaine   Washington  Florid…    194     68     36    NA WR      
#>  5 -1011027   Jonathan   Wallace     Florid…    295     79     74    NA OL      
#>  6 -1011026   Donovan    Todd        Florid…    205     71     39    NA DB      
#>  7 -1011025   Bryan      Stork       Florid…    300     76     52    NA OL      
#>  8 -1011024   Nathan     Slater      Florid…    223     74     45    NA LB      
#>  9 -1011023   Garrett    Scott       Florid…    275     75     69    NA OL      
#> 10 -1011022   Michael    Scheerhorn  Florid…    240     76     79    NA OL      
#> # ℹ 124 more rows
#> # ℹ 9 more variables: home_city <chr>, home_state <chr>, home_country <chr>,
#> #   home_latitude <dbl>, home_longitude <dbl>, home_county_fips <chr>,
#> #   recruit_ids <list>, headshot_url <chr>, season <int>
# }
```
