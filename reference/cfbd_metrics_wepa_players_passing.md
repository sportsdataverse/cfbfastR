# **Get opponent-adjusted player passing statistics for predicted points added (PPA)**

**Get opponent-adjusted player passing statistics for predicted points
added (PPA)**

## Usage

``` r
cfbd_metrics_wepa_players_passing(
  year = NULL,
  team = NULL,
  conference = NULL,
  position = NULL
)
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

- position:

  (*string* optional): Position abbreviation of the player you are
  searching for. Position Group - options include:

  - Offense: QB, RB, FB, TE, OL, G, OT, C, WR

  - Defense: DB, CB, S, LB, DE, DT, NT, DL

  - Special Teams: K, P, LS, PK

## Value

`cfbd_metrics_wepa_players_passing()` - A data frame with 8 variables:

|              |           |
|--------------|-----------|
| col_name     | types     |
| year         | integer   |
| athlete_id   | character |
| athlete_name | character |
| position     | character |
| team         | character |
| conference   | character |
| wepa         | numeric   |
| plays        | integer   |

## See also

Other CFBD Metrics:
[`cfbd_metrics_fg_ep()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_fg_ep.md),
[`cfbd_metrics_ppa_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_games.md),
[`cfbd_metrics_ppa_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_games.md),
[`cfbd_metrics_ppa_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_season.md),
[`cfbd_metrics_ppa_predicted()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_predicted.md),
[`cfbd_metrics_ppa_teams()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_teams.md),
[`cfbd_metrics_wepa_players_kicking()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_kicking.md),
[`cfbd_metrics_wepa_players_rushing()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_rushing.md),
[`cfbd_metrics_wepa_team_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_team_season.md),
[`cfbd_metrics_wp()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp.md),
[`cfbd_metrics_wp_pregame()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp_pregame.md)

## Examples

``` r
# \donttest{
  try(cfbd_metrics_wepa_players_passing(year = 2019, team = "TCU"))
#> ── Opponent-adjusted players passing PPA data from CollegeFootballData.com ─────
#> ℹ Data updated: 2026-01-19 16:22:03 UTC
#> # A tibble: 1 × 8
#>    year athlete_id athlete_name position team  conference  wepa plays
#>   <int> <chr>      <chr>        <chr>    <chr> <chr>      <dbl> <int>
#> 1  2019 4427105    Max Duggan   QB       TCU   Big 12      0.24   355
# }
```
