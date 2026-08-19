# **Get coaching tenures**

**Get coaching tenures** Start and end of each coaching tenure.

## Usage

``` r
cfbd_coaches_tenures(
  coach_id = NULL,
  team = NULL,
  year = NULL,
  active = NULL,
  proxy = NULL
)
```

## Arguments

- coach_id:

  (*Integer* optional): Coach identifier.

- team:

  (*String* optional): Team filter.

- year:

  (*Integer* optional): Season, 4 digits (YYYY).

- active:

  (*Logical* optional): Restrict to currently active tenures.

- proxy:

  (*List* optional): Per-call proxy override passed to `get_req()`.
  `NULL` (default) falls back to `getOption("cfbfastR.proxy")` and then
  the `http(s)_proxy` environment variables, so a caller can override
  the shared setting for one endpoint.

## Value

`cfbd_coaches_tenures()` - A tibble with 20 columns:

|                       |           |                                           |
|-----------------------|-----------|-------------------------------------------|
| col_name              | types     | description                               |
| id                    | integer   | Record identifier.                        |
| hire_date             | character | Hire date of the coach (ISO date string). |
| start_year            | integer   | Start year.                               |
| end_year              | integer   | End year.                                 |
| effective_start       | logical   | Effective start.                          |
| effective_end         | logical   | Effective end.                            |
| is_interim            | logical   | Is interim.                               |
| active                | logical   | Active.                                   |
| seasons               | integer   | Seasons.                                  |
| attribution_complete  | logical   | Attribution complete.                     |
| coach_id              | integer   | Coach identifier.                         |
| coach_first_name      | character | Coach first name.                         |
| coach_last_name       | character | Coach last name.                          |
| team_id               | integer   | Referencing team id.                      |
| team_school           | character | School name of the team.                  |
| record_games          | integer   | Record games.                             |
| record_wins           | integer   | Record wins.                              |
| record_losses         | integer   | Record losses.                            |
| record_ties           | integer   | Record ties.                              |
| record_win_percentage | numeric   | Record win percentage.                    |

## See also

Other CFBD Coaches Functions:
[`cfbd_coaches()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches.md),
[`cfbd_coaches_profile()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches_profile.md),
[`cfbd_coaches_seasons()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches_seasons.md)

## Examples

``` r
# \donttest{
  try(cfbd_coaches_tenures(team = "Georgia"))
#> ── Get coaching tenures from CollegeFootballData.com ───────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-08-19 17:34:58 UTC
#> # A tibble: 20 × 20
#>       id hire_date  start_year end_year effective_start effective_end is_interim
#>    <int> <chr>           <int>    <int> <lgl>           <lgl>         <lgl>     
#>  1  1446 NA               1902     1902 NA              NA            FALSE     
#>  2  1453 NA               1903     1903 NA              NA            FALSE     
#>  3  1447 NA               1904     1904 NA              NA            FALSE     
#>  4  1454 NA               1905     1905 NA              NA            FALSE     
#>  5  1458 NA               1906     1907 NA              NA            FALSE     
#>  6  1441 NA               1908     1908 NA              NA            FALSE     
#>  7  1449 NA               1909     1909 NA              NA            FALSE     
#>  8  1456 NA               1910     1916 NA              NA            FALSE     
#>  9  1457 NA               1919     1919 NA              NA            FALSE     
#> 10  1448 NA               1920     1922 NA              NA            FALSE     
#> 11  1445 NA               1923     1927 NA              NA            FALSE     
#> 12  1444 NA               1928     1937 NA              NA            FALSE     
#> 13  1451 NA               1938     1938 NA              NA            FALSE     
#> 14  1442 NA               1939     1960 NA              NA            FALSE     
#> 15  1452 NA               1961     1963 NA              NA            FALSE     
#> 16  1443 NA               1964     1988 NA              NA            FALSE     
#> 17  1455 NA               1989     1995 NA              NA            FALSE     
#> 18  1450 NA               1996     2000 NA              NA            FALSE     
#> 19  1043 2000-12-26       2001     2015 NA              NA            FALSE     
#> 20   101 2015-12-06       2016       NA NA              NA            FALSE     
#> # ℹ 13 more variables: active <lgl>, seasons <int>, attribution_complete <lgl>,
#> #   coach_id <int>, coach_first_name <chr>, coach_last_name <chr>,
#> #   team_id <int>, team_school <chr>, record_games <int>, record_wins <int>,
#> #   record_losses <int>, record_ties <int>, record_win_percentage <dbl>
# }
```
