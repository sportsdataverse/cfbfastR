# **Get team rosters**

Get a teams full roster by year. If team is not selected, API returns
rosters for every team from the selected year.

## Usage

``` r
cfbd_team_roster(year, team = NULL)
```

## Arguments

- year:

  (*Integer* required): Year, 4 digit format (*YYYY*)

- team:

  (*String* optional): Team, select a valid team in D-I football

## Value

`cfbd_team_roster()` - A data frame with 12 variables:

- `athlete_id`: character.:

  Referencing athlete id.

- `first_name`: character.:

  Athlete first name.

- `last_name`: character.:

  Athlete last name.

- `team`: character.:

  Team name.

- `weight`: integer.:

  Athlete weight.

- `height`: integer.:

  Athlete height.

- `jersey`: integer.:

  Athlete jersey number.

- `year`: integer.:

  Athlete year.

- `position`: character.:

  Athlete position.

- `home_city`: character.:

  Hometown of the athlete.

- `home_state`: character.:

  Hometown state of the athlete.

- `home_country`: character.:

  Hometown country of the athlete.

- `home_latitude`: numeric.:

  Hometown latitude.

- `home_longitude`: number.:

  Hometown longitude.

- `home_county_fips`: integer.:

  Hometown FIPS code.

- `headshot_url`: character:

  Player ESPN headshot url.

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
#> ── Team roster data from CollegeFootballData.com ───────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:34:04 UTC
#> # A tibble: 134 × 17
#>    athlete_id first_name last_name   team    weight height jersey  year position
#>    <chr>      <chr>      <chr>       <chr>    <int>  <int>  <int> <int> <chr>   
#>  1 -1011031   Colton     Woodall     Florid…    190     75     49  2013 DB      
#>  2 -1011030   James      Wilder, Jr. Florid…    229     74     32  2013 RB      
#>  3 -1011029   Levonte    Whitfield   Florid…    178     67      7  2013 WR      
#>  4 -1011028   Jermaine   Washington  Florid…    194     68     36  2013 WR      
#>  5 -1011027   Jonathan   Wallace     Florid…    295     79     74  2013 OL      
#>  6 -1011026   Donovan    Todd        Florid…    205     71     39  2013 DB      
#>  7 -1011025   Bryan      Stork       Florid…    300     76     52  2013 OL      
#>  8 -1011024   Nathan     Slater      Florid…    223     74     45  2013 LB      
#>  9 -1011023   Garrett    Scott       Florid…    275     75     69  2013 OL      
#> 10 -1011022   Michael    Scheerhorn  Florid…    240     76     79  2013 OL      
#> # ℹ 124 more rows
#> # ℹ 8 more variables: home_city <chr>, home_state <chr>, home_country <chr>,
#> #   home_latitude <dbl>, home_longitude <dbl>, home_county_fips <chr>,
#> #   recruit_ids <list>, headshot_url <chr>
# }
```
