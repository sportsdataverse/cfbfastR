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

`cfbd_team_season_overview()` - A named list of tibbles: `overview`,
`record`, `ratings`, `advanced`, `passing`, `rushing`, `players`. Nested
objects are flattened into prefixed columns. A section CFBD did not fill
(`passing` and `rushing` start in 2025) is a 0-column tibble.

**overview** - one row: `season` (integer), `team_id` (integer), `team`
(character).

**record** - one row: completed games for the requested season,
including postseason: `games`, `wins`, `losses`, `ties` (integer).

**ratings** - one row: current available ratings for the requested
season; unavailable systems are `NA`. `elo` (numeric, latest postgame
Elo from a completed game this season), then a `<system>_<unit>_rating`
(numeric, rounded to two decimals) and `<system>_<unit>_rank` (integer,
rank within the season and division) pair for `srs` (no unit), `sp_*`
and `fpi_*` (`overall`, `offense`, `defense`, `special_teams`; FPI
values are efficiencies, higher is better) and `core_*` (`overall`,
`offense`, `defense`).

**advanced** - one row: `season` (integer), `team`, `conference`
(character), then for each of `offense_` and `defense_`:

|  |  |
|----|----|
| col_name (after the side prefix) | types |
| plays, drives | integer |
| ppa, total_ppa, success_rate, explosiveness | numeric |
| power_success, stuff_rate | numeric |
| line_yards, line_yards_total | numeric, integer |
| second_level_yards, second_level_yards_total | numeric, integer |
| open_field_yards, open_field_yards_total | numeric, integer |
| total_opportunies, points_per_opportunity | integer, numeric (upstream spelling kept) |
| field_position_average_start, field_position_average_predicted_points | numeric |
| havoc_total, havoc_front_seven, havoc_db | numeric |
| `standard_downs_*`, `passing_downs_*` | numeric: `rate`, `ppa`, `success_rate`, `explosiveness` (`total_ppa` too on defense passing downs) |
| `passing_plays_*`, `rushing_plays_*` | numeric: `rate`, `ppa`, `total_ppa`, `success_rate`, `explosiveness` |

**passing** - one row: `season` (integer), `team`, `conference`
(character), then `offense_*` and `defense_*`, each the passing
production block (with `locations_<bucket>_*`) documented in
[`cfbd_passing_teams_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_teams_season.md).

**rushing** - one row: `season` (integer), `team`, `conference`
(character), then `offense_*` and `defense_*`, each the rushing
production block (with `directions_<direction>_*`) documented in
[`cfbd_rushing_teams_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_teams_season.md).

**players** - one row per player per `category` (`usage` or `ppa`):

|  |  |  |
|----|----|----|
| col_name | types | description |
| category | character | usage or ppa: which player list the row comes from. |
| season | integer | Season. |
| id | character | Player id. |
| name | character | Player name. |
| position | character | Player position. |
| team | character | Team name. |
| conference | character | Conference. |
| usage\_\* | numeric | Usage rows: `overall`, `pass`, `rush`, `first_down`, `second_down`, `third_down`, `standard_downs`, `passing_downs`. |
| average_ppa\_\* | numeric | PPA rows: average PPA for `all`, `pass`, `rush`, `first_down`, `second_down`, `third_down`, `standard_downs`, `passing_downs`. |
| total_ppa\_\* | numeric | PPA rows: total PPA for the same splits. |

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
#> ℹ Data updated: 2026-09-27 11:04:37 UTC
#> # A tibble: 1 × 3
#>   season team_id team 
#>    <int>   <int> <chr>
#> 1   2024     251 Texas
#> 
#> $record
#> ── Team season overview data from CollegeFootballData.com ──────────────────────
#> ℹ Data updated: 2026-09-27 11:04:37 UTC
#> # A tibble: 1 × 4
#>   games  wins losses  ties
#>   <int> <int>  <int> <int>
#> 1    16    13      3     0
#> 
#> $ratings
#> ── Team season overview data from CollegeFootballData.com ──────────────────────
#> ℹ Data updated: 2026-09-27 11:04:37 UTC
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
#> ℹ Data updated: 2026-09-27 11:04:37 UTC
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
#> ℹ Data updated: 2026-09-27 11:04:37 UTC
#> # A tibble: 0 × 0
#> 
#> $rushing
#> ── Team season overview data from CollegeFootballData.com ──────────────────────
#> ℹ Data updated: 2026-09-27 11:04:37 UTC
#> # A tibble: 0 × 0
#> 
#> $players
#> ── Team season overview data from CollegeFootballData.com ──────────────────────
#> ℹ Data updated: 2026-09-27 11:04:37 UTC
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
