# **Get college football recruiting team rankings information.**

**Get college football recruiting team rankings information.**

## Usage

``` r
cfbd_recruiting_team(year = NULL, team = NULL)
```

## Arguments

- year:

  (*Integer* optional): Recruiting Class Year, 4 digit format (*YYYY*) -
  Minimum: 2000. Required if team not provided.

- team:

  (*String* optional): Team - Select a valid team, D1 football. Required
  if year not provided.

## Value

`cfbd_recruiting_team()` - A data frame with 4 variables:

- `year`: integer.:

  Recruiting class year.

- `rank`: integer.:

  Team Recruiting rank.

- `team`: character.:

  Recruiting Team.

- `points`: character.:

  Team talent points.

## See also

Other CFBD Recruiting:
[`cfbd_recruiting_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_player.md),
[`cfbd_recruiting_position()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_position.md),
[`cfbd_recruiting_transfer_portal()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_transfer_portal.md)

## Examples

``` r
# \donttest{
  try(cfbd_recruiting_team(2018, team = "Texas"))
#> ── Recruiting team rankings from CollegeFootballData.com ───── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:33:48 UTC
#> # A tibble: 1 × 4
#>    year team   rank points
#>   <int> <chr> <int>  <dbl>
#> 1  2018 Texas     3   300.

  try(cfbd_recruiting_team(2016, team = "Virginia"))
#> ── Recruiting team rankings from CollegeFootballData.com ───── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:33:48 UTC
#> # A tibble: 1 × 4
#>    year team      rank points
#>   <int> <chr>    <int>  <dbl>
#> 1  2016 Virginia    63   165.

  try(cfbd_recruiting_team(2016, team = "Texas A&M"))
#> ── Recruiting team rankings from CollegeFootballData.com ───── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:33:48 UTC
#> # A tibble: 1 × 4
#>    year team       rank points
#>   <int> <chr>     <int>  <dbl>
#> 1  2016 Texas A&M    18   239.

  try(cfbd_recruiting_team(2011))
#> ── Recruiting team rankings from CollegeFootballData.com ───── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:33:48 UTC
#> # A tibble: 137 × 4
#>     year team           rank points
#>    <int> <chr>         <int>  <dbl>
#>  1  2011 Alabama           1   298.
#>  2  2011 Florida State     2   297.
#>  3  2011 USC               3   287.
#>  4  2011 Texas             4   284.
#>  5  2011 Auburn            5   281.
#>  6  2011 Ohio State        6   278.
#>  7  2011 Georgia           7   278.
#>  8  2011 LSU               8   273.
#>  9  2011 Notre Dame        9   271.
#> 10  2011 Clemson          10   270.
#> # ℹ 127 more rows
# }
```
