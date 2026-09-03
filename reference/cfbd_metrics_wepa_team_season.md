# **Get opponent-adjusted team season statistics for predicted points added (PPA)**

**Get opponent-adjusted team season statistics for predicted points
added (PPA)**

## Usage

``` r
cfbd_metrics_wepa_team_season(year = NULL, team = NULL, conference = NULL)
```

## Arguments

- year:

  (*Integer* required): Year, 4 digit format (*YYYY*)  
  Minimum value accepted: 2008

- team:

  (*String* optional): D-I Team

- conference:

  (*String* optional): Conference abbreviation - Select a valid FBS
  conference Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC

## Value

`cfbd_metrics_wepa_team_season()` - A data frame with 26 variables:

|  |  |  |
|----|----|----|
| col_name | types | description |
| year | integer | Four-digit season year (e.g. 2019). |
| team_id | integer | CFBD internal team identifier. |
| team | character | Full team name (e.g. "TCU"). |
| conference | character | Team conference name (e.g. "Big 12"). |
| explosiveness | numeric | Offensive opponent-adjusted explosiveness rate (higher = more big plays). |
| explosiveness_allowed | numeric | Defensive opponent-adjusted explosiveness rate allowed. |
| epa_total | numeric | Opponent-adjusted total offensive EPA per play (predicted points added). |
| epa_passing | numeric | Opponent-adjusted offensive passing EPA per play. |
| epa_rushing | numeric | Opponent-adjusted offensive rushing EPA per play. |
| epa_allowed_total | numeric | Opponent-adjusted total defensive EPA per play allowed. |
| epa_allowed_passing | numeric | Opponent-adjusted defensive passing EPA per play allowed. |
| epa_allowed_rushing | numeric | Opponent-adjusted defensive rushing EPA per play allowed. |
| success_rate_total | numeric | Opponent-adjusted offensive success rate across all plays (proportion 0-1). |
| success_rate_standard_downs | numeric | Opponent-adjusted offensive success rate on standard downs (proportion 0-1). |
| success_rate_passing_downs | numeric | Opponent-adjusted offensive success rate on passing downs (proportion 0-1). |
| success_rate_allowed_total | numeric | Opponent-adjusted defensive success rate allowed across all plays (proportion 0-1). |
| success_rate_allowed_standard_downs | numeric | Opponent-adjusted defensive success rate allowed on standard downs (proportion 0-1). |
| success_rate_allowed_passing_downs | numeric | Opponent-adjusted defensive success rate allowed on passing downs (proportion 0-1). |
| rushing_line_yards | numeric | Opponent-adjusted offensive line yards per rush (Football Outsiders methodology). |
| rushing_second_level_yards | numeric | Opponent-adjusted offensive second-level yards per rush (5-10 yards past line of scrimmage). |
| rushing_open_field_yards | numeric | Opponent-adjusted offensive open-field yards per rush (10+ yards past line of scrimmage). |
| rushing_highlight_yards | numeric | Opponent-adjusted offensive highlight yards per opportunity rush. |
| rushing_allowed_line_yards | numeric | Opponent-adjusted defensive line yards per rush allowed. |
| rushing_allowed_second_level_yards | numeric | Opponent-adjusted defensive second-level yards per rush allowed. |
| rushing_allowed_open_field_yards | numeric | Opponent-adjusted defensive open-field yards per rush allowed. |
| rushing_allowed_highlight_yards | numeric | Opponent-adjusted defensive highlight yards per opportunity rush allowed. |

## See also

Other CFBD Metrics:
[`cfbd_metrics_fg_ep()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_fg_ep.md),
[`cfbd_metrics_ppa_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_games.md),
[`cfbd_metrics_ppa_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_games.md),
[`cfbd_metrics_ppa_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_season.md),
[`cfbd_metrics_ppa_predicted()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_predicted.md),
[`cfbd_metrics_ppa_teams()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_teams.md),
[`cfbd_metrics_wepa_players_kicking()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_kicking.md),
[`cfbd_metrics_wepa_players_passing()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_passing.md),
[`cfbd_metrics_wepa_players_rushing()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_rushing.md),
[`cfbd_metrics_wp()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp.md),
[`cfbd_metrics_wp_pregame()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp_pregame.md)

## Examples

``` r
# \donttest{
  try(cfbd_metrics_wepa_team_season(year = 2019, team = "TCU"))
#> ── Opponent-adjusted team season PPA data from CollegeFootballData.com ─────────
#> ℹ Data updated: 2026-09-03 22:33:44 UTC
#> # A tibble: 1 × 26
#>    year team_id team  conference explosiveness explosiveness_allowed epa_total
#>   <int>   <int> <chr> <chr>              <dbl>                 <dbl>     <dbl>
#> 1  2019    2628 TCU   B12                 1.01                 0.987     0.158
#> # ℹ 19 more variables: epa_passing <dbl>, epa_rushing <dbl>,
#> #   epa_allowed_total <dbl>, epa_allowed_passing <dbl>,
#> #   epa_allowed_rushing <dbl>, success_rate_total <dbl>,
#> #   success_rate_standard_downs <dbl>, success_rate_passing_downs <dbl>,
#> #   success_rate_allowed_total <dbl>,
#> #   success_rate_allowed_standard_downs <dbl>,
#> #   success_rate_allowed_passing_downs <dbl>, rushing_line_yards <dbl>, …
# }
```
