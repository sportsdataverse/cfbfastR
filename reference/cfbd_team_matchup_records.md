# **Get matchup history records between two teams.**

**Get matchup history records between two teams.**

## Usage

``` r
cfbd_team_matchup_records(team1, team2, min_year = NULL, max_year = NULL)
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

`cfbd_team_matchup_records()` - A data frame with 7 variables:

- `start_year`: character.:

  Span starting year.

- `end_year`: character.:

  Span ending year.

- `team1`: character.:

  First team selected in query.

- `team1_wins`: character.:

  First team wins in series against `team2`.

- `team2`: character.:

  Second team selected in query.

- `team2_wins`: character.:

  Second team wins in series against `team1`.

- `ties`: character.:

  Number of ties in the series.

## See also

Other CFBD Teams:
[`cfbd_team_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_info.md),
[`cfbd_team_matchup()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_matchup.md),
[`cfbd_team_roster()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_roster.md),
[`cfbd_team_talent()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_talent.md)

## Examples

``` r
# \donttest{
  try(cfbd_team_matchup_records("Texas", "Oklahoma"))
#> ── Team matchup record from CollegeFootballData.com ────────── cfbfastR 2.2.1 ──
#> ℹ Data updated: 2026-01-19 16:23:04 UTC
#> # A tibble: 1 × 7
#>   start_year end_year team1 team1_wins team2    team2_wins  ties
#>        <int>    <int> <chr>      <int> <chr>         <int> <int>
#> 1       1902     2025 Texas         62 Oklahoma         51     5

  try(cfbd_team_matchup_records("Texas A&M", "TCU", min_year = 1975))
#> ── Team matchup record from CollegeFootballData.com ────────── cfbfastR 2.2.1 ──
#> ℹ Data updated: 2026-01-19 16:23:04 UTC
#> # A tibble: 1 × 7
#>   start_year end_year team1     team1_wins team2 team2_wins  ties
#>        <int>    <int> <chr>          <int> <chr>      <int> <int>
#> 1       1975     2001 Texas A&M         22 TCU            0     0
# }
```
