# **ESPN College Football Power Index (Long Format)**

Get ESPN's College Football Power Index (FPI) ratings for a season,
including the full set of predictive metrics and efficiency components
ESPN publishes alongside the headline FPI number.

## Usage

``` r
espn_cfb_powerindex(year = NULL)
```

## Arguments

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 2005

## Value

A data frame with one row per team-metric:

|               |           |                                                    |
|---------------|-----------|----------------------------------------------------|
| col_name      | types     | description                                        |
| season        | integer   | Season (4-digit year).                             |
| team_id       | character | ESPN team id (parsed from `team_ref`).             |
| team_ref      | character | `$ref` URL to the team-in-season resource.         |
| metric_group  | character | `predictive` or `efficiency`.                      |
| stat_name     | character | Internal metric key (e.g. `fpi`, `offefficiency`). |
| abbreviation  | character | Metric abbreviation.                               |
| display_name  | character | Human-readable metric name.                        |
| value         | numeric   | Metric value.                                      |
| display_value | character | Display-formatted metric value as shown on ESPN.   |
| description   | character | ESPN's description of the metric.                  |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/powerindex`.
Returns one row per team-metric in long format: each team contributes
one row for every predictive metric (FPI, projected wins, strength of
record, ...) and every efficiency component (offensive, defensive, and
special-teams efficiency, ...). The long shape is deliberate – ESPN adds
and retires metrics across seasons, and a long frame absorbs that drift
without breaking column expectations. Pivot wider with
[`tidyr::pivot_wider()`](https://tidyr.tidyverse.org/reference/pivot_wider.html)
keyed on `stat_name` when a wide table is wanted.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_powerindex(year = 2024))
#> ── Power Index data from ESPN ──────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 17:03:57 UTC
#> # A tibble: 5,762 × 10
#>    season team_id team_ref      metric_group stat_name abbreviation display_name
#>     <int> <chr>   <chr>         <chr>        <chr>     <chr>        <chr>       
#>  1   2024 194     http://sport… predictive   fpi       FPI          FPI         
#>  2   2024 194     http://sport… predictive   fpirank   FPI          FPI RK      
#>  3   2024 194     http://sport… predictive   projecte… PROJ W       Projected W 
#>  4   2024 194     http://sport… predictive   projecte… PROJ L       Projected L 
#>  5   2024 194     http://sport… predictive   projecte… PROJ TIE     ProjectedT  
#>  6   2024 194     http://sport… predictive   projecte… PROJ WIN% R… ProjectedWP…
#>  7   2024 194     http://sport… predictive   probwino… WIN OUT%     Prob Win Out
#>  8   2024 194     http://sport… predictive   probwinc… WIN CONF%    Prob Win Co…
#>  9   2024 194     http://sport… predictive   sosremai… REM SOS RNK  SOS Remaini…
#> 10   2024 194     http://sport… predictive   accompli… SOR          Accomplishm…
#> # ℹ 5,752 more rows
#> # ℹ 3 more variables: value <dbl>, display_value <chr>, description <chr>
# }
```
