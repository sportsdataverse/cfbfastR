# **Load college football advanced turnover from the SportsDataverse data repo**

Loads season-level turnover aggregates – one row per team with turnovers
won/lost, expected turnovers, and turnover luck. Published to the
`espn_cfb_adv_turnover` release tag on the sportsdataverse-data repo.

## Usage

``` r
load_espn_cfb_adv_turnover(
  seasons = most_recent_cfb_season(),
  ...,
  dbConnection = NULL,
  tablename = NULL
)
```

## Arguments

- seasons:

  A vector of 4-digit years associated with given college football
  seasons. Published coverage runs 2004 through the most recent season.
  Pass `seasons = TRUE` for every published season. (Min: 2004)

- ...:

  Additional arguments passed to an underlying function that writes the
  season data into a database.

- dbConnection:

  A `DBIConnection` object, as returned by
  [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html)

- tablename:

  The name of the data table within the database

## Value

Returns a `cfbfastR_data` tibble.

|  |  |  |
|----|----|----|
| col_name | types | description |
| pos_team_id | integer | ESPN team id of the team on offense. Present for every season 2004+. |
| pos_team | character |  |
| turnovers | integer |  |
| st_turnovers_lost | integer | Turnovers the team lost on special-teams plays. |
| Int | integer | Interceptions thrown. |
| fumbles_lost | integer | Fumbles this team lost to the opponent on every play, special teams included: ESPN's team box fumblesLost where the game has one, else the play-by-play count (fumbles_lost_pbp). |
| pass_breakups | integer | Passes thrown by this offense that the opposing defense broke up; it equals the opponent's row in the advanced defensive table exactly. |
| total_fumbles | integer | Fumbles by this team on every play, special teams included, charged to the team that fumbled (a returner's muffed punt counts against the return team): the same plays fumbles_lost counts. |
| fumbles_recovered | integer | Of total_fumbles, the ones this team recovered itself. |
| team_id | integer |  |
| turnovers_pbp | integer | Turnover count derived from the play-by-play, retained unchanged so it can be reconciled against the ESPN-sourced turnovers total. |
| Int_pbp | integer | Interception count derived from the play-by-play, kept alongside the ESPN-sourced Int for reconciliation. |
| fumbles_lost_pbp | integer | Fumbles-lost count derived from the play-by-play, kept alongside the ESPN-sourced fumbles_lost for reconciliation. |
| espn_sourced | logical | CONSTANT: true on every published row. It records that the row was built from the ESPN feed rather than an alternate provider, and no other provider is currently used. |
| passes_defended | integer | Passes thrown by this offense that the opposing defense defended, from ESPN's box score (the defense's passesDefended, which excludes interceptions, plus Int). Null where ESPN's box has no passesDefended, mostly before 2023. |
| expected_turnovers | double | Turnover expectation for this team, computed as `0.5 * total_fumbles + 0.22 * passes_defended` where passes_defended is present, otherwise `0.5 * total_fumbles + 0.22 * (pass_breakups + Int)`. |
| expected_turnover_margin | double | The opponent's expected_turnovers minus this team's, so positive means the team was expected to win the turnover battle. |
| turnover_margin | integer | The opponent's turnovers minus this team's turnovers, positive when the team gained more possessions than it gave away. |
| turnover_luck | double | Points of scoring luck attributed to turnovers, five points per turnover times the gap between turnover_margin and expected_turnover_margin. |
| takeaways | integer |  |
| st_turnovers_gained | integer | Special-teams turnovers this team recovered, taken as the opponent's st_turnovers_lost. |
| fumble_recoveries_gained | integer | Opponent fumbles this team recovered, taken as the opponent's fumbles_lost. |
| game_id | integer |  |
| season | integer |  |
| week | integer |  |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_espn_cfb_adv_turnover(2004))
#> ── college football advanced turnover from the SportsDataverse data repo ───────
#> ℹ Data updated: 2026-10-12 09:45:48 UTC
#> # A tibble: 926 × 25
#>    pos_team_id pos_team           turnovers st_turnovers_lost   Int fumbles_lost
#>          <int> <chr>                  <int>             <int> <int>        <int>
#>  1         259 Virginia Tech Hok…         3                 0     1            2
#>  2          30 USC Trojans                0                 0     0            0
#>  3         254 Utah Utes                  0                 0     0            0
#>  4         245 Texas A&M Aggies           0                 0     0            0
#>  5        2050 Ball State Cardin…         0                 0     0            0
#>  6         103 Boston College Ea…         2                 0     1            1
#>  7        2628 TCU Horned Frogs           2                 0     1            1
#>  8          77 Northwestern Wild…         1                 0     1            0
#>  9           9 Arizona State Sun…         1                 0     1            0
#> 10        2638 UTEP Miners                5                 0     4            1
#> # ℹ 916 more rows
#> # ℹ 19 more variables: pass_breakups <int>, total_fumbles <int>,
#> #   fumbles_recovered <int>, team_id <int>, turnovers_pbp <int>, Int_pbp <int>,
#> #   fumbles_lost_pbp <int>, espn_sourced <lgl>, passes_defended <lgl>,
#> #   expected_turnovers <dbl>, expected_turnover_margin <dbl>,
#> #   turnover_margin <int>, turnover_luck <dbl>, takeaways <int>,
#> #   st_turnovers_gained <int>, fumble_recoveries_gained <int>, game_id <int>, …
# }
```
