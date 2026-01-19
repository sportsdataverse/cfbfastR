# **CFBD Coaches Endpoint Overview**

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

- min_year:

  (*Integer* optional): Minimum Year filter (inclusive), 4 digit format
  (*YYYY*).

- max_year:

  (*Integer* optional): Maximum Year filter (inclusive), 4 digit format
  (*YYYY*)

## Value

- first_name:character.:

  First name of coach.

- last_name:character.:

  Last name of coach.

- hire_date:character.:

  Hire date of coach.

- school:character.:

  School of coach.

- year:integer.:

  Season of record.

- games:integer.:

  Games as coach.

- wins:integer.:

  Wins for the season.

- losses:integer.:

  Losses for the season.

- ties:integer.:

  Ties for the season.

- preseason_rank:integer.:

  Preseason rank for the school of coach.

- postseason_rank:integer.:

  Postseason rank for the school of coach.

- srs:character.:

  Simple Rating System adjustment for team.

- sp_overall:character.:

  Bill Connelly's SP+ overall for team.

- sp_offense:character.:

  Bill Connelly's SP+ offense for team.

- sp_defense:character.:

  Bill Connelly's SP+ defense for team.

## Examples

``` r
# \donttest{
  try(cfbd_coaches(first = "Nick", last = "Saban", team = "alabama"))
#> ── Coaches data from CollegeFootballData.com ───────────────── cfbfastR 2.2.1 ──
#> ℹ Data updated: 2026-01-19 16:21:46 UTC
#> # A tibble: 125 × 15
#>    first_name last_name   hire_date school   year games  wins losses  ties
#>    <chr>      <chr>       <chr>     <chr>   <int> <int> <int>  <int> <int>
#>  1 M.         Griffin     NA        Alabama  1900     5     2      3     0
#>  2 G.H.       Harvey      NA        Alabama  1901     5     2      1     2
#>  3 Eli        Abbott      NA        Alabama  1902     8     4      4     0
#>  4 J.O.       Heyworth    NA        Alabama  1902     8     4      4     0
#>  5 W.B.       Blount      NA        Alabama  1903     7     3      4     0
#>  6 W.B.       Blount      NA        Alabama  1904    10     7      3     0
#>  7 Jack       Leavenworth NA        Alabama  1905    10     6      4     0
#>  8 J.W.H.     Pollard     NA        Alabama  1906     6     5      1     0
#>  9 J.W.H.     Pollard     NA        Alabama  1907     8     5      1     2
#> 10 J.W.H.     Pollard     NA        Alabama  1908     8     6      1     1
#> # ℹ 115 more rows
#> # ℹ 6 more variables: preseason_rank <int>, postseason_rank <int>, srs <dbl>,
#> #   sp_overall <dbl>, sp_offense <dbl>, sp_defense <dbl>
# }
```
