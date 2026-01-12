# **Get Points Added Above Replacement (PAAR) ratings for kickers**

**Get Points Added Above Replacement (PAAR) ratings for kickers**

## Usage

``` r
cfbd_metrics_wepa_players_kicking(year = NULL, team = NULL, conference = NULL)
```

## Arguments

- year:

  (*Integer* required): Year, 4 digit format (*YYYY*)

- team:

  (*String* optional): D-I Team

- conference:

  (*String* optional): Conference abbreviation - Select a valid FBS
  conference Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC

## Value

`cfbd_metrics_wepa_players_kicking()` - A data frame with 7 variables:

|              |           |
|--------------|-----------|
| col_name     | types     |
| year         | integer   |
| athlete_id   | character |
| athlete_name | character |
| team         | character |
| conference   | character |
| paar         | numeric   |
| attempts     | integer   |

## See also

Other CFBD Metrics:
[`cfbd_metrics_fg_ep()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_fg_ep.md),
[`cfbd_metrics_ppa_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_games.md),
[`cfbd_metrics_ppa_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_games.md),
[`cfbd_metrics_ppa_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_season.md),
[`cfbd_metrics_ppa_predicted()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_predicted.md),
[`cfbd_metrics_ppa_teams()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_teams.md),
[`cfbd_metrics_wepa_players_passing()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_passing.md),
[`cfbd_metrics_wepa_players_rushing()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_rushing.md),
[`cfbd_metrics_wepa_team_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_team_season.md),
[`cfbd_metrics_wp()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp.md),
[`cfbd_metrics_wp_pregame()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp_pregame.md)

## Examples

``` r
# \donttest{
  try(cfbd_metrics_wepa_players_kicking(year = 2019, team = "TCU"))
#> ── Points Added Above Replacement (PAAR) ratings for kicking data from CollegeFo
#> ℹ Data updated: 2026-01-12 12:20:45 UTC
#> # A tibble: 2 × 7
#>    year athlete_id athlete_name  team  conference  paar attempts
#>   <int> <chr>      <chr>         <chr> <chr>      <dbl>    <int>
#> 1  2019 3929311    Jonathan Song TCU   Big 12     10.2        24
#> 2  2019 4574573    Griffin Kell  TCU   Big 12      2.85        4
# }
```
