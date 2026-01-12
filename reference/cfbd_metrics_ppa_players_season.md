# **Get player season averages for predicted points added (PPA)**

**Get player season averages for predicted points added (PPA)**

## Usage

``` r
cfbd_metrics_ppa_players_season(
  year = NULL,
  team = NULL,
  conference = NULL,
  position = NULL,
  athlete_id = NULL,
  threshold = NULL,
  excl_garbage_time = FALSE
)
```

## Arguments

- year:

  (*Integer* optional): Year, 4 digit format (*YYYY*). Required if
  athlete_id not provided

- team:

  (*String* optional): D-I Team.

- conference:

  (*String* optional): Conference abbreviation - S&P+ information by
  conference Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC

- position:

  (*string* optional): Position abbreviation of the player you are
  searching for. Position Group - options include:

  - Offense: QB, RB, FB, TE, OL, G, OT, C, WR

  - Defense: DB, CB, S, LB, DE, DT, NT, DL

  - Special Teams: K, P, LS, PK

- athlete_id:

  (*Integer* optional): Athlete ID filter for querying a single athlete.
  Required if year not provided Can be found using the
  [`cfbd_player_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_info.md)
  function.

- threshold:

  (*Integer* optional): Minimum threshold of plays.

- excl_garbage_time:

  (*Logical* default FALSE): Select whether to exclude Garbage Time
  (TRUE or FALSE)

## Value

`cfbd_metrics_ppa_players_season()` - A data frame with 23 variables:

- `season`: integer.:

  Season.

- `athlete_id`: character.:

  Athlete referencing id.

- `name`: character.:

  Athlete name.

- `position`: character.:

  Athlete Position.

- `team`: character.:

  Team name.

- `conference`: character.:

  Team conference.

- `countable_plays`: integer.:

  DEPRECATED Number of plays which can be counted.

- `avg_PPA_all`: double.:

  Average overall predicted points added (PPA).

- `avg_PPA_pass`: double.:

  Average passing predicted points added (PPA).

- `avg_PPA_rush`: double.:

  Average rushing predicted points added (PPA).

- `avg_PPA_first_down`: double.:

  Average 1st down predicted points added (PPA).

- `avg_PPA_second_down`: double.:

  Average 2nd down predicted points added (PPA).

- `avg_PPA_third_down`: double.:

  Average 3rd down predicted points added (PPA).

- `avg_PPA_standard_downs`: double.:

  Average standard down predicted points added (PPA).

- `avg_PPA_passing_downs`: double.:

  Average passing down predicted points added (PPA).

- `total_PPA_all`: double.:

  Total overall predicted points added (PPA).

- `total_PPA_pass`: double.:

  Total passing predicted points added (PPA).

- `total_PPA_rush`: double.:

  Total rushing predicted points added (PPA).

- `total_PPA_first_down`: double.:

  Total 1st down predicted points added (PPA).

- `total_PPA_second_down`: double.:

  Total 2nd down predicted points added (PPA).

- `total_PPA_third_down`: double.:

  Total 3rd down predicted points added (PPA).

- `total_PPA_standard_downs`: double.:

  Total standard down predicted points added (PPA).

- `total_PPA_passing_downs`: double.:

  Total passing down predicted points added (PPA).

## See also

Other CFBD Metrics:
[`cfbd_metrics_fg_ep()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_fg_ep.md),
[`cfbd_metrics_ppa_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_games.md),
[`cfbd_metrics_ppa_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_games.md),
[`cfbd_metrics_ppa_predicted()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_predicted.md),
[`cfbd_metrics_ppa_teams()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_teams.md),
[`cfbd_metrics_wepa_players_kicking()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_kicking.md),
[`cfbd_metrics_wepa_players_passing()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_passing.md),
[`cfbd_metrics_wepa_players_rushing()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_rushing.md),
[`cfbd_metrics_wepa_team_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_team_season.md),
[`cfbd_metrics_wp()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp.md),
[`cfbd_metrics_wp_pregame()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp_pregame.md)

## Examples

``` r
# \donttest{
  try(cfbd_metrics_ppa_players_season(year = 2019, team = "TCU"))
#> ── Player season PPA data from CollegeFootballData.com ─────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:33:05 UTC
#> # A tibble: 19 × 23
#>    season athlete_id name     position team  conference avg_PPA_all avg_PPA_pass
#>     <int> <chr>      <chr>    <chr>    <chr> <chr>            <dbl>        <dbl>
#>  1   2019 3676818    TreVont… WR       TCU   B12              0.117        0.462
#>  2   2019 3886634    Alex De… QB       TCU   B12             -0.023       -0.124
#>  3   2019 4038533    Darius … RB       TCU   B12              0.076       -0.144
#>  4   2019 4038536    Dylan T… WR       TCU   B12              1.18         1.18 
#>  5   2019 4038539    Sewo Ol… RB       TCU   B12              0.157       -0.104
#>  6   2019 4038556    Artayvi… TE       TCU   B12              0.506        0.506
#>  7   2019 4241795    Al'Dont… WR       TCU   B12              3.18         3.18 
#>  8   2019 4241802    Jalen R… WR       TCU   B12              0.299        0.347
#>  9   2019 4259331    Carter … TE       TCU   B12              0.808        0.808
#> 10   2019 4362430    Taye Ba… WR       TCU   B12              0.591        0.55 
#> 11   2019 4362442    Pro Wel… TE       TCU   B12              0.642        0.642
#> 12   2019 4362477    Derius … WR       TCU   B12              0.243        0.296
#> 13   2019 4362478    Emari D… RB       TCU   B12             -0.149       NA    
#> 14   2019 4362483    Tevaila… WR       TCU   B12              0.385        0.385
#> 15   2019 4362489    John St… WR       TCU   B12              0.421        0.726
#> 16   2019 4426635    Darwin … RB       TCU   B12              0.166       -0.881
#> 17   2019 4426965    Blair C… WR       TCU   B12              1.07         1.07 
#> 18   2019 4427105    Max Dug… QB       TCU   B12              0.176        0.092
#> 19   2019 4427217    Daimarq… RB       TCU   B12              0.365       NA    
#> # ℹ 15 more variables: avg_PPA_rush <dbl>, avg_PPA_first_down <dbl>,
#> #   avg_PPA_second_down <dbl>, avg_PPA_third_down <dbl>,
#> #   avg_PPA_standard_downs <dbl>, avg_PPA_passing_downs <dbl>,
#> #   total_PPA_all <dbl>, total_PPA_pass <dbl>, total_PPA_rush <dbl>,
#> #   total_PPA_first_down <dbl>, total_PPA_second_down <dbl>,
#> #   total_PPA_third_down <dbl>, total_PPA_standard_downs <dbl>,
#> #   total_PPA_passing_downs <dbl>, countable_plays <int>
# }
```
