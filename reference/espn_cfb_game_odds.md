# **ESPN College Football Game Odds**

Get the sportsbook betting lines (spread, over/under, moneyline) for a
single college football game – one row per provider.

## Usage

``` r
espn_cfb_game_odds(game_id = NULL, line_history = FALSE)
```

## Arguments

- game_id:

  (*Integer* required): ESPN game identifier.

- line_history:

  (*Logical*): controls the output shape. One of:

  - `FALSE` (default) – the summary output, one row per odds provider,
    with the columns shown in the *Value* table below.

  - `TRUE` – a long frame capturing the `open` / `close` / `current`
    line snapshots, one row per (provider x snapshot x market) (see
    *Details*).

## Value

A data frame with one row per odds provider (when
`line_history = FALSE`):

|  |  |  |
|----|----|----|
| col_name | types | description |
| game_id | character | ESPN game identifier. |
| provider_id | character | ESPN odds-provider (sportsbook) id. |
| provider_name | character | Odds-provider name (e.g. `ESPN BET`). |
| provider_priority | integer | ESPN display priority of the odds provider. |
| details | character | ESPN's headline line string (e.g. `UGA -54.5`). |
| over_under | numeric | Game total (over/under) points line. |
| spread | numeric | Point spread (negative favors the home team). |
| over_odds | numeric | American odds price on the over. |
| under_odds | numeric | American odds price on the under. |
| home_favorite | logical | `TRUE` if the home team is the favorite. |
| home_underdog | logical | `TRUE` if the home team is the underdog. |
| away_favorite | logical | `TRUE` if the away team is the favorite. |
| away_underdog | logical | `TRUE` if the away team is the underdog. |
| home_spread_odds | numeric | American odds price on the home-team spread. |
| away_spread_odds | numeric | American odds price on the away-team spread. |
| home_money_line | character | Home-team moneyline (American odds). |
| away_money_line | character | Away-team moneyline (American odds). |
| moneyline_winner | logical | `TRUE` if the moneyline favorite won. |
| spread_winner | logical | `TRUE` if the spread favorite covered. |

## Details

Wraps the ESPN core-v2 endpoint
`events/{game_id}/competitions/{game_id}/odds`. Returns one row per odds
provider (sportsbook). `details` is ESPN's headline line string (e.g.
`"UGA -54.5"`); `spread` and `over_under` are the numeric spread and
total. Home/away spread odds and moneylines are pulled from the nested
`homeTeamOdds` / `awayTeamOdds` blocks. The `over_odds` and `under_odds`
are the American-odds prices on the game total. With
`line_history = TRUE` the per-provider `open` / `close` / `current` line
snapshots are expanded instead (see *Details*).

When `line_history = TRUE` the returned frame is in long format, one row
per (provider x snapshot x market), with columns: `game_id`,
`provider_id`, `provider_name`, `snapshot` (one of `open`, `close`,
`current`), `market` (e.g. `over`, `under`, `total`, `pointSpread`,
`spread`, `moneyLine`), `side` (`game`, `home`, or `away`), `american`
(the American-odds string), `value` (the numeric/decimal value), and
`display_value`.

## See also

Other ESPN CFB Functions:
[`espn_cfb_award()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_award.md),
[`espn_cfb_awards()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_awards.md),
[`espn_cfb_clear_cache()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_clear_cache.md),
[`espn_cfb_coach()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_coach.md),
[`espn_cfb_coach_record()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_coach_record.md),
[`espn_cfb_coaches()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_coaches.md),
[`espn_cfb_franchise()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_franchise.md),
[`espn_cfb_franchises()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_franchises.md),
[`espn_cfb_futures()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_futures.md),
[`espn_cfb_game_broadcasts()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_broadcasts.md),
[`espn_cfb_game_drive_plays()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_drive_plays.md),
[`espn_cfb_game_drives()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_drives.md),
[`espn_cfb_game_leaders()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_leaders.md),
[`espn_cfb_game_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_pbp.md),
[`espn_cfb_game_play()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_play.md),
[`espn_cfb_game_player_box()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_player_box.md),
[`espn_cfb_game_player_statistics()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_player_statistics.md),
[`espn_cfb_game_powerindex()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_powerindex.md),
[`espn_cfb_game_predictor()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_predictor.md),
[`espn_cfb_game_probabilities()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_probabilities.md),
[`espn_cfb_game_situation()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_situation.md),
[`espn_cfb_game_status()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_status.md),
[`espn_cfb_game_team_leaders()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_leaders.md),
[`espn_cfb_game_team_linescores()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_linescores.md),
[`espn_cfb_game_team_records()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_records.md),
[`espn_cfb_game_team_roster()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_roster.md),
[`espn_cfb_game_team_statistics()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_statistics.md),
[`espn_cfb_game_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_teams.md),
[`espn_cfb_groups()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_groups.md),
[`espn_cfb_pbp_v2()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp_v2.md),
[`espn_cfb_player()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player.md),
[`espn_cfb_player_career_stats()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_career_stats.md),
[`espn_cfb_player_eventlog()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_eventlog.md),
[`espn_cfb_player_gamelog()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_gamelog.md),
[`espn_cfb_player_overview()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_overview.md),
[`espn_cfb_player_seasons()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_seasons.md),
[`espn_cfb_player_splits()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_splits.md),
[`espn_cfb_player_stats_v3()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_stats_v3.md),
[`espn_cfb_players()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_players.md),
[`espn_cfb_position()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_position.md),
[`espn_cfb_positions()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_positions.md),
[`espn_cfb_powerindex()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_powerindex.md),
[`espn_cfb_qbr()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_qbr.md),
[`espn_cfb_rankings()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_rankings.md),
[`espn_cfb_recruits()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_recruits.md),
[`espn_cfb_season_info()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_season_info.md),
[`espn_cfb_season_types()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_season_types.md),
[`espn_cfb_season_weeks()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_season_weeks.md),
[`espn_cfb_seasons()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_seasons.md),
[`espn_cfb_standings()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_standings.md),
[`espn_cfb_team()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team.md),
[`espn_cfb_team_ats()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_ats.md),
[`espn_cfb_team_awards()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_awards.md),
[`espn_cfb_team_coaches()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_coaches.md),
[`espn_cfb_team_events()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_events.md),
[`espn_cfb_team_leaders()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_leaders.md),
[`espn_cfb_team_powerindex()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_powerindex.md),
[`espn_cfb_team_ranks()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_ranks.md),
[`espn_cfb_team_record()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_record.md),
[`espn_cfb_team_roster()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_roster.md),
[`espn_cfb_team_schedule()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_schedule.md),
[`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md),
[`espn_cfb_unnest_plays()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_unnest_plays.md),
[`espn_cfb_venue()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_venue.md),
[`espn_cfb_venues()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_venues.md),
[`espn_cfb_week_rankings()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_week_rankings.md)

## Examples

``` r
# \donttest{
  try(espn_cfb_game_odds(game_id = 401628339))
#> ── Game odds data from ESPN ────────────────────────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-06-12 02:22:50 UTC
#> # A tibble: 2 × 19
#>   game_id  provider_id provider_name provider_priority details over_under spread
#>   <chr>    <chr>       <chr>                     <int> <chr>        <dbl>  <dbl>
#> 1 4016283… 58          ESPN BET                      0 UGA -5…       68.5  -54.5
#> 2 4016283… 59          ESPN Bet - L…                 0 UGA -5…       51.5  -54.5
#> # ℹ 12 more variables: over_odds <dbl>, under_odds <dbl>, home_favorite <lgl>,
#> #   home_underdog <lgl>, away_favorite <lgl>, away_underdog <lgl>,
#> #   home_spread_odds <dbl>, away_spread_odds <dbl>, home_money_line <chr>,
#> #   away_money_line <chr>, moneyline_winner <lgl>, spread_winner <lgl>
  try(espn_cfb_game_odds(game_id = 401628339, line_history = TRUE))
#> ── Game odds line history data from ESPN ───────────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-06-12 02:22:50 UTC
#> # A tibble: 37 × 9
#>    game_id   provider_id provider_name snapshot market      side  american value
#>    <chr>     <chr>       <chr>         <chr>    <chr>       <chr> <chr>    <dbl>
#>  1 401628339 58          ESPN BET      open     over        game  -110      1.91
#>  2 401628339 58          ESPN BET      open     under       game  -110      1.91
#>  3 401628339 58          ESPN BET      open     total       game  62.5      1.91
#>  4 401628339 58          ESPN BET      open     pointSpread home  -54.5     1.95
#>  5 401628339 58          ESPN BET      open     spread      home  -105      1.95
#>  6 401628339 58          ESPN BET      open     pointSpread away  +54.5    NA   
#>  7 401628339 58          ESPN BET      open     spread      away  -115      1.87
#>  8 401628339 58          ESPN BET      close    over        game  +105      2.05
#>  9 401628339 58          ESPN BET      close    under       game  -125      1.8 
#> 10 401628339 58          ESPN BET      close    total       game  68.5     NA   
#> # ℹ 27 more rows
#> # ℹ 1 more variable: display_value <chr>
# }
```
