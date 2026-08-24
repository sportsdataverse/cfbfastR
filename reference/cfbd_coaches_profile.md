# **Get a coach profile**

**Get a coach profile** Biographical profile for a single coach.

## Usage

``` r
cfbd_coaches_profile(coach_id, proxy = NULL)
```

## Arguments

- coach_id:

  (*Integer* required): Coach identifier.

- proxy:

  (*List* optional): Per-call proxy override passed to `get_req()`.
  `NULL` (default) falls back to `getOption("cfbfastR.proxy")` and then
  the `http(s)_proxy` environment variables, so a caller can override
  the shared setting for one endpoint.

## Value

`cfbd_coaches_profile()` - A tibble with 19 columns:

|                       |           |                                      |
|-----------------------|-----------|--------------------------------------|
| col_name              | types     | description                          |
| id                    | integer   | Record identifier.                   |
| first_name            | character | First name.                          |
| last_name             | character | Last name.                           |
| display_name          | logical   | Display name.                        |
| current_team          | logical   | Current team.                        |
| birth_date            | logical   | Birth date and time (ISO 8601).      |
| alma_mater            | logical   | Alma mater.                          |
| graduation_year       | logical   | Graduation year.                     |
| wikidata_id           | logical   | Wikidata identifier.                 |
| hall_of_fame_year     | logical   | Hall of fame year.                   |
| career_seasons        | integer   | Seasons coached across the career.   |
| career_teams          | integer   | Distinct teams coached.              |
| career_first_year     | integer   | First season of the coaching career. |
| career_last_year      | integer   | Most recent season coached.          |
| career_games          | integer   | Career games coached.                |
| career_wins           | integer   | Career wins.                         |
| career_losses         | integer   | Career losses.                       |
| career_ties           | integer   | Career ties.                         |
| career_win_percentage | numeric   | Career winning percentage.           |

## See also

Other CFBD Coaches Functions:
[`cfbd_coaches()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches.md),
[`cfbd_coaches_seasons()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches_seasons.md),
[`cfbd_coaches_tenures()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches_tenures.md)

## Examples

``` r
# \donttest{
  try(cfbd_coaches_profile(coach_id = 1))
#> ── Get a coach profile from CollegeFootballData.com ────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-24 11:32:09 UTC
#> # A tibble: 1 × 20
#>      id first_name last_name display_name  current_team birth_date alma_mater_id
#>   <int> <chr>      <chr>     <chr>         <lgl>        <chr>              <int>
#> 1     1 Steve      Addazio   Steve Addazio NA           1959-06-01          2115
#> # ℹ 13 more variables: alma_mater_school <chr>, graduation_year <int>,
#> #   wikidata_id <chr>, hall_of_fame_year <lgl>, career_seasons <int>,
#> #   career_teams <int>, career_first_year <int>, career_last_year <int>,
#> #   career_games <int>, career_wins <int>, career_losses <int>,
#> #   career_ties <int>, career_win_percentage <dbl>
# }
```
