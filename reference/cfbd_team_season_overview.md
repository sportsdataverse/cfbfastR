# **Get a full-season team overview**

**Returns a stored full-season team overview, including postseason and
garbage time.**

## Usage

``` r
cfbd_team_season_overview(year, team, proxy = NULL)
```

## Arguments

- year:

  (*Integer* required): Season year, 4 digit format (*YYYY*). Minimum
  value accepted: 2014

- team:

  (*String* required): Team name.

- proxy:

  (*List* optional): Per-call proxy override passed to `get_req()`.
  `NULL` (default) falls back to `getOption("cfbfastR.proxy")` and then
  the `http(s)_proxy` environment variables.

## Value

A named list of data frames: `overview`, `record`, `ratings`,
`advanced`, `passing`, `rushing`, `players`. The sections have different
row grains, so they are not joined. A section CFBD did not fill is a
0-column tibble (`passing` and `rushing` start in 2025). Nested objects
are flattened into prefixed columns. An empty list is returned if the
request fails.

**overview** - one row:

|          |           |                         |
|----------|-----------|-------------------------|
| col_name | type      | description             |
| season   | integer   | Season of the overview. |
| team_id  | integer   | CFBD team id.           |
| team     | character | Team name.              |

**record** - one row, completed games for the requested season,
including postseason:

|          |         |                  |
|----------|---------|------------------|
| col_name | type    | description      |
| games    | integer | Completed games. |
| wins     | integer | Wins.            |
| losses   | integer | Losses.          |
| ties     | integer | Ties.            |

**ratings** - one row, the ratings currently available for the season.
All 25 columns are always present and typed; a system CFBD has no value
for is NA, and any rating CFBD adds later follows them. Ratings are
rounded to two decimals; each rank is the competition rank within the
season and division (1 = best), computed on unrounded values:

|  |  |  |
|----|----|----|
| col_name | type | description |
| elo | double | Latest postgame Elo rating from a completed game this season. |
| srs_rating | double | Simple Rating System (SRS) rating; higher is better. |
| srs_rank | integer | Rank of `srs_rating`. |
| sp_overall_rating | double | SP+ overall rating; higher is better. |
| sp_overall_rank | integer | Rank of `sp_overall_rating`. |
| sp_offense_rating | double | SP+ offense rating; higher is better. |
| sp_offense_rank | integer | Rank of `sp_offense_rating`. |
| sp_defense_rating | double | SP+ defense rating; lower is better. |
| sp_defense_rank | integer | Rank of `sp_defense_rating`. |
| sp_special_teams_rating | double | SP+ special teams rating; higher is better. |
| sp_special_teams_rank | integer | Rank of `sp_special_teams_rating`. |
| fpi_overall_rating | double | FPI overall efficiency (not the FPI points rating); higher is better. |
| fpi_overall_rank | integer | Rank of `fpi_overall_rating`. |
| fpi_offense_rating | double | FPI offense efficiency; higher is better. |
| fpi_offense_rank | integer | Rank of `fpi_offense_rating`. |
| fpi_defense_rating | double | FPI defense efficiency; higher is better. |
| fpi_defense_rank | integer | Rank of `fpi_defense_rating`. |
| fpi_special_teams_rating | double | FPI special teams efficiency; higher is better. |
| fpi_special_teams_rank | integer | Rank of `fpi_special_teams_rating`. |
| core_overall_rating | double | CFBD CORE overall rating, `core_offense_rating` minus `core_defense_rating`; higher is better. See [`cfbd_ratings_core()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_core.md). |
| core_overall_rank | integer | Rank of `core_overall_rating`. |
| core_offense_rating | double | CFBD CORE offense rating: points created above average per 100 qualifying plays; higher is better. |
| core_offense_rank | integer | Rank of `core_offense_rating`. |
| core_defense_rating | double | CFBD CORE defense rating: points allowed above average per 100 qualifying plays; lower is better. |
| core_defense_rank | integer | Rank of `core_defense_rating`. |

**advanced** - one row. After `team` and `season`, each base column
below appears twice, first prefixed `defense_` (what opponents did
against the team) and then prefixed `offense_`, in the order shown;
`conference` comes last. The one exception is `passing_downs_total_ppa`,
which CFBD sends for the defense only
(`defense_passing_downs_total_ppa`). Rates are proportions 0-1 and PPA
is predicted points added. A double that happens to be a whole number
parses as integer in this one-row frame (e.g. `offense_open_field_yards`
in the 2025 Texas sample):

|  |  |  |
|----|----|----|
| col_name | type | description |
| team | character | Team name. |
| season | integer | Season of the statistics. |
| ppa | double | Average PPA per play. |
| havoc_total | double | Havoc rate: proportion of plays with a tackle for loss, forced fumble, interception or pass breakup. |
| havoc_front_seven | double | Havoc rate from front-seven defenders. |
| havoc_db | double | Havoc rate from defensive backs. |
| plays | integer | Plays. |
| drives | integer | Drives. |
| total_ppa | double | Total PPA over all plays. |
| line_yards | double | Offensive line yards per rush (Football Outsiders line-yards method). |
| stuff_rate | double | Proportion of rushes stopped at or behind the line of scrimmage. |
| success_rate | double | Proportion of plays that were successful. |
| passing_downs_ppa | double | Average PPA per play on passing downs. |
| passing_downs_rate | double | Proportion of plays that came on passing downs. |
| passing_downs_total_ppa | double | Labelled by CFBD as total PPA on passing downs; defense only (`defense_passing_downs_total_ppa`). In every sampled season (2023-2025) it equals `passing_plays_total_ppa`, so it looks like an upstream copy. |
| passing_downs_success_rate | double | Success rate on passing downs. |
| passing_downs_explosiveness | double | Explosiveness (average PPA on successful plays) on passing downs. |
| passing_plays_ppa | double | Average PPA per pass play. |
| passing_plays_rate | double | Proportion of plays that were passes. |
| passing_plays_total_ppa | double | Total PPA on pass plays. |
| passing_plays_success_rate | double | Success rate on pass plays. |
| passing_plays_explosiveness | double | Explosiveness on pass plays. |
| power_success | double | Proportion of short-yardage runs (third or fourth down, 2 yards or fewer to go) that gained a first down or touchdown. |
| rushing_plays_ppa | double | Average PPA per rush. |
| rushing_plays_rate | double | Proportion of plays that were rushes. |
| rushing_plays_total_ppa | double | Total PPA on rushes. |
| rushing_plays_success_rate | double | Success rate on rushes. |
| rushing_plays_explosiveness | double | Explosiveness on rushes. |
| explosiveness | double | Explosiveness: average PPA on successful plays. |
| field_position_average_start | double | Average drive start, in yards to the end zone being attacked (70 = own 30). |
| field_position_average_predicted_points | double | Average predicted points of the drive start, from this side's view: the defense value is negative when opponents start with positive expected points. |
| standard_downs_ppa | double | Average PPA per play on standard downs. |
| standard_downs_rate | double | Proportion of plays that came on standard downs. |
| standard_downs_success_rate | double | Success rate on standard downs. |
| standard_downs_explosiveness | double | Explosiveness on standard downs. |
| line_yards_total | integer | Total offensive line yards. |
| open_field_yards | double | Open-field yards per rush: rushing yards gained more than 10 yards past the line of scrimmage, averaged over all rushes. |
| second_level_yards | double | Second-level yards per rush: rushing yards gained 5 to 10 yards past the line of scrimmage, averaged over all rushes. |
| total_opportunies | integer | Scoring opportunities: drives with a first down inside the opponent 40 (CFBD spelling kept). |
| open_field_yards_total | integer | Total open-field yards. |
| points_per_opportunity | double | Points per scoring opportunity. |
| second_level_yards_total | integer | Total second-level yards. |
| conference | character | Team conference. |

**passing** - one row, 0 columns before 2025:

|  |  |  |
|----|----|----|
| col_name | type | description |
| \* | varies | The same columns, names and types, as [`cfbd_passing_teams_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_teams_season.md) for this team and season, in CFBD key order: `team`, `season`, the `defense_` block, the `offense_` block, then `conference`; each column is defined there, see [cfbd_passing](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing.md). |

**rushing** - one row, 0 columns before 2025:

|  |  |  |
|----|----|----|
| col_name | type | description |
| \* | varies | The same columns, names and types, as [`cfbd_rushing_teams_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_teams_season.md) for this team and season, in CFBD key order: `team`, `season`, the `defense_` block, the `offense_` block, then `conference`; each column is defined there, see [cfbd_rushing](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing.md). |

**players** - one row per player per `category`; a player in both CFBD
lists has two rows, and the other list's columns are NA on each:

|  |  |  |
|----|----|----|
| col_name | type | description |
| category | character | Which CFBD player list the row comes from: ppa or usage. |
| id | character | CFBD athlete id. |
| name | character | Player name. |
| team | character | Team name. |
| season | integer | Season. |
| position | character | Position abbreviation (e.g. QB, RB, WR). |
| conference | character | Team conference. |
| total_ppa_all | double | Total PPA on all of the player's plays; NA on usage rows. |
| total_ppa_pass | double | Total PPA on pass plays; NA on usage rows. |
| total_ppa_rush | double | Total PPA on rushes; NA on usage rows. |
| total_ppa_first_down | double | Total PPA on first downs; NA on usage rows. |
| total_ppa_third_down | double | Total PPA on third downs; NA on usage rows. |
| total_ppa_second_down | double | Total PPA on second downs; NA on usage rows. |
| total_ppa_passing_downs | double | Total PPA on passing downs; NA on usage rows. |
| total_ppa_standard_downs | double | Total PPA on standard downs; NA on usage rows. |
| average_ppa_all | double | Average PPA per play on all of the player's plays; NA on usage rows. |
| average_ppa_pass | double | Average PPA per pass play; NA on usage rows. |
| average_ppa_rush | double | Average PPA per rush; NA on usage rows. |
| average_ppa_first_down | double | Average PPA per first-down play; NA on usage rows. |
| average_ppa_third_down | double | Average PPA per third-down play; NA on usage rows. |
| average_ppa_second_down | double | Average PPA per second-down play; NA on usage rows. |
| average_ppa_passing_downs | double | Average PPA per passing-down play; NA on usage rows. |
| average_ppa_standard_downs | double | Average PPA per standard-down play; NA on usage rows. |
| usage_pass | double | Player share of team passing usage (proportion 0-1); NA on ppa rows. |
| usage_rush | double | Player share of team rushing usage (proportion 0-1); NA on ppa rows. |
| usage_overall | double | Player share of overall offensive usage (proportion 0-1); NA on ppa rows. |
| usage_first_down | double | Player share of team usage on first downs; NA on ppa rows. |
| usage_third_down | double | Player share of team usage on third downs; NA on ppa rows. |
| usage_second_down | double | Player share of team usage on second downs; NA on ppa rows. |
| usage_passing_downs | double | Player share of team usage on passing downs; NA on ppa rows. |
| usage_standard_downs | double | Player share of team usage on standard downs; NA on ppa rows. |

## See also

Other CFBD Teams:
[`cfbd_team_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_info.md),
[`cfbd_team_matchup()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_matchup.md),
[`cfbd_team_matchup_records()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_matchup_records.md),
[`cfbd_team_roster()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_roster.md),
[`cfbd_team_talent()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_talent.md)

## Examples

``` r
# \donttest{
  try(cfbd_team_season_overview(year = 2024, team = "Texas"))
#> $overview
#> ── Team season overview data from CollegeFootballData.com ──────────────────────
#> ℹ Data updated: 2026-10-01 05:28:39 UTC
#> # A tibble: 1 × 3
#>   season team_id team 
#>    <int>   <int> <chr>
#> 1   2024     251 Texas
#> 
#> $record
#> ── Team season overview data from CollegeFootballData.com ──────────────────────
#> ℹ Data updated: 2026-10-01 05:28:39 UTC
#> # A tibble: 1 × 4
#>   games  wins losses  ties
#>   <int> <int>  <int> <int>
#> 1    16    13      3     0
#> 
#> $ratings
#> ── Team season overview data from CollegeFootballData.com ──────────────────────
#> ℹ Data updated: 2026-10-01 05:28:39 UTC
#> # A tibble: 1 × 25
#>     elo srs_rating srs_rank sp_overall_rating sp_overall_rank sp_offense_rating
#>   <dbl>      <dbl>    <int>             <dbl>           <int>             <dbl>
#> 1  2042       19.4        3              24.1               7              36.6
#> # ℹ 19 more variables: sp_offense_rank <int>, sp_defense_rating <dbl>,
#> #   sp_defense_rank <int>, sp_special_teams_rating <dbl>,
#> #   sp_special_teams_rank <int>, fpi_overall_rating <dbl>,
#> #   fpi_overall_rank <int>, fpi_offense_rating <dbl>, fpi_offense_rank <int>,
#> #   fpi_defense_rating <dbl>, fpi_defense_rank <int>,
#> #   fpi_special_teams_rating <dbl>, fpi_special_teams_rank <int>,
#> #   core_overall_rating <dbl>, core_overall_rank <int>, …
#> 
#> $advanced
#> ── Team season overview data from CollegeFootballData.com ──────────────────────
#> ℹ Data updated: 2026-10-01 05:28:39 UTC
#> # A tibble: 1 × 82
#>   team  season defense_ppa defense_havoc_total defense_havoc_front_seven
#>   <chr>  <int>       <dbl>               <dbl>                     <dbl>
#> 1 Texas   2024      -0.089               0.211                      0.13
#> # ℹ 77 more variables: defense_havoc_db <dbl>, defense_plays <int>,
#> #   defense_drives <int>, defense_total_ppa <dbl>, defense_line_yards <dbl>,
#> #   defense_stuff_rate <dbl>, defense_success_rate <dbl>,
#> #   defense_passing_downs_ppa <dbl>, defense_passing_downs_rate <dbl>,
#> #   defense_passing_downs_total_ppa <dbl>,
#> #   defense_passing_downs_success_rate <dbl>,
#> #   defense_passing_downs_explosiveness <dbl>, …
#> 
#> $passing
#> ── Team season overview data from CollegeFootballData.com ──────────────────────
#> ℹ Data updated: 2026-10-01 05:28:39 UTC
#> # A tibble: 0 × 0
#> 
#> $rushing
#> ── Team season overview data from CollegeFootballData.com ──────────────────────
#> ℹ Data updated: 2026-10-01 05:28:39 UTC
#> # A tibble: 0 × 0
#> 
#> $players
#> ── Team season overview data from CollegeFootballData.com ──────────────────────
#> ℹ Data updated: 2026-10-01 05:28:39 UTC
#> # A tibble: 36 × 31
#>    category id      name          team  season position conference total_ppa_all
#>    <chr>    <chr>   <chr>         <chr>  <int> <chr>    <chr>              <dbl>
#>  1 ppa      4427251 Velton Gardn… Texas   2024 RB       SEC               -1.17 
#>  2 ppa      4568075 Juan Davis    Texas   2024 TE       SEC                1.99 
#>  3 ppa      4590532 Silas Bolden  Texas   2024 WR       SEC               23.1  
#>  4 ppa      4685279 Jaydon Blue   Texas   2024 RB       SEC               41.2  
#>  5 ppa      4686728 Gunnar Helm   Texas   2024 TE       SEC               64.5  
#>  6 ppa      4701936 Matthew Gold… Texas   2024 WR       SEC               78.7  
#>  7 ppa      4808839 Isaiah Bond   Texas   2024 WR       SEC               57.1  
#>  8 ppa      4869534 Amari Niblack Texas   2024 TE       SEC               -0.597
#>  9 ppa      4870656 Johntay Cook… Texas   2024 WR       SEC                9.23 
#> 10 ppa      4870860 DeAndre Moor… Texas   2024 WR       SEC               36.4  
#> # ℹ 26 more rows
#> # ℹ 23 more variables: total_ppa_pass <dbl>, total_ppa_rush <dbl>,
#> #   total_ppa_first_down <dbl>, total_ppa_third_down <dbl>,
#> #   total_ppa_second_down <dbl>, total_ppa_passing_downs <dbl>,
#> #   total_ppa_standard_downs <dbl>, average_ppa_all <dbl>,
#> #   average_ppa_pass <dbl>, average_ppa_rush <dbl>,
#> #   average_ppa_first_down <dbl>, average_ppa_third_down <dbl>, …
#> 
# }
```
