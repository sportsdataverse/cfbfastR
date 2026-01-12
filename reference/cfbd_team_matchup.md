# **Get matchup history between two teams.**

**Get matchup history between two teams.**

## Usage

``` r
cfbd_team_matchup(team1, team2, min_year = NULL, max_year = NULL)
```

## Arguments

- team1:

  (*String* required): D-I Team 1

- team2:

  (*String* required): D-I Team 2

- min_year:

  (*Integer* optional): Minimum of year range, 4 digit format (*YYYY*)

- max_year:

  (*Integer* optional): Maximum of year range, 4 digit format (*YYYY*)

## Value

cfbd_team_matchup - A data frame with 11 variables:

- `season`: integer.:

  Season the game took place.

- `week`: integer.:

  Game week of the season.

- `season_type`: character.:

  Season type of the game.

- `date`: character.:

  Game date.

- `neutral_site`: logical.:

  TRUE/FALSE flag for if the game took place at a neutral site.

- `venue`: character.:

  Stadium name.

- `home_team`: character.:

  Home team of the game.

- `home_score`: integer.:

  Home score in the game.

- `away_team`: character.:

  Away team of the game.

- `away_score`: integer.:

  Away score in the game.

- `winner`: character.:

  Winner of the matchup.

## See also

Other CFBD Teams:
[`cfbd_team_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_info.md),
[`cfbd_team_matchup_records()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_matchup_records.md),
[`cfbd_team_roster()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_roster.md),
[`cfbd_team_talent()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_talent.md)

## Examples

``` r
# \donttest{
  try(cfbd_team_matchup("Texas", "Oklahoma"))
#> ── Team matchup history from CollegeFootballData.com ───────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:34:01 UTC
#> # A tibble: 118 × 11
#>    season  week season_type date         neutral_site venue home_team home_score
#>     <int> <int> <chr>       <chr>        <lgl>        <chr> <chr>          <int>
#>  1   1902     4 regular     1902-10-04T… FALSE        NA    Texas             22
#>  2   1903     6 regular     1903-10-17T… FALSE        NA    Oklahoma           6
#>  3   1903    10 regular     1903-11-13T… FALSE        NA    Oklahoma           5
#>  4   1904    10 regular     1904-11-16T… FALSE        NA    Texas             40
#>  5   1905     8 regular     1905-11-03T… FALSE        NA    Oklahoma           2
#>  6   1906     7 regular     1906-11-02T… FALSE        NA    Oklahoma           9
#>  7   1907     9 regular     1907-11-15T… FALSE        NA    Texas             29
#>  8   1908     9 regular     1908-11-13T… FALSE        NA    Oklahoma          50
#>  9   1909    10 regular     1909-11-19T… FALSE        NA    Texas             30
#> 10   1910    11 regular     1910-11-24T… FALSE        NA    Texas              0
#> # ℹ 108 more rows
#> # ℹ 3 more variables: away_team <chr>, away_score <int>, winner <chr>

  try(cfbd_team_matchup("Texas A&M", "TCU"))
#> ── Team matchup history from CollegeFootballData.com ───────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:34:02 UTC
#> # A tibble: 89 × 11
#>    season  week season_type date         neutral_site venue home_team home_score
#>     <int> <int> <chr>       <chr>        <lgl>        <lgl> <chr>          <int>
#>  1   1903    10 regular     1903-11-14T… FALSE        NA    Texas A&M         16
#>  2   1903     5 regular     1903-10-10T… FALSE        NA    Texas A&M         11
#>  3   1903    12 regular     1903-11-28T… FALSE        NA    Texas A&M         14
#>  4   1904     6 regular     1904-10-22T… FALSE        NA    Texas A&M         29
#>  5   1905     8 regular     1905-11-04T… FALSE        NA    Texas A&M         24
#>  6   1905     3 regular     1905-09-30T… FALSE        NA    Texas A&M         20
#>  7   1906     6 regular     1906-10-27T… FALSE        NA    Texas A&M         42
#>  8   1906     8 regular     1906-11-10T… FALSE        NA    Texas A&M         22
#>  9   1907     8 regular     1907-11-05T… FALSE        NA    Texas A&M         32
#> 10   1908     7 regular     1908-10-31T… FALSE        NA    Texas A&M         13
#> # ℹ 79 more rows
#> # ℹ 3 more variables: away_team <chr>, away_score <int>, winner <chr>

  try(cfbd_team_matchup("Texas A&M", "TCU", min_year = 1975))
#> ── Team matchup history from CollegeFootballData.com ───────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:34:02 UTC
#> # A tibble: 22 × 11
#>    season  week season_type date         neutral_site venue home_team home_score
#>     <int> <int> <chr>       <chr>        <lgl>        <lgl> <chr>          <int>
#>  1   1975     7 regular     1975-10-18T… FALSE        NA    TCU                6
#>  2   1976    12 regular     1976-11-20T… FALSE        NA    Texas A&M         59
#>  3   1977    12 regular     1977-11-19T… FALSE        NA    TCU               23
#>  4   1978    13 regular     1978-11-25T… FALSE        NA    Texas A&M         15
#>  5   1979    13 regular     1979-11-24T… FALSE        NA    TCU                7
#>  6   1980    13 regular     1980-11-22T… FALSE        NA    Texas A&M         13
#>  7   1981    12 regular     1981-11-21T… FALSE        NA    TCU                7
#>  8   1982    12 regular     1982-11-20T… FALSE        NA    Texas A&M         34
#>  9   1983    13 regular     1983-11-19T… FALSE        NA    TCU               10
#> 10   1984    14 regular     1984-11-24T… FALSE        NA    Texas A&M         35
#> # ℹ 12 more rows
#> # ℹ 3 more variables: away_team <chr>, away_score <int>, winner <chr>

  try(cfbd_team_matchup("Florida State", "Florida", min_year = 1975))
#> ── Team matchup history from CollegeFootballData.com ───────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:34:02 UTC
#> # A tibble: 52 × 11
#>    season  week season_type date         neutral_site venue home_team home_score
#>     <int> <int> <chr>       <chr>        <lgl>        <chr> <chr>          <int>
#>  1   1975     7 regular     1975-10-18T… FALSE        NA    Florida           34
#>  2   1976     7 regular     1976-10-16T… FALSE        NA    Florida …         26
#>  3   1977    14 regular     1977-12-03T… FALSE        NA    Florida            9
#>  4   1978    13 regular     1978-11-25T… FALSE        NA    Florida …         38
#>  5   1979    13 regular     1979-11-24T… FALSE        NA    Florida           16
#>  6   1980    15 regular     1980-12-06T… FALSE        NA    Florida …         17
#>  7   1981    13 regular     1981-11-28T… FALSE        NA    Florida           35
#>  8   1982    14 regular     1982-12-04T… FALSE        NA    Florida …         10
#>  9   1983    15 regular     1983-12-03T… FALSE        NA    Florida           53
#> 10   1984    15 regular     1984-12-01T… FALSE        NA    Florida …         17
#> # ℹ 42 more rows
#> # ℹ 3 more variables: away_team <chr>, away_score <int>, winner <chr>
# }
```
