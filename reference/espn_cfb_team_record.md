# **ESPN College Football Team Record (Long Format)**

Get a college football team's season records – overall, home, away, and
conference splits – with the full set of summary stats ESPN attaches to
each.

## Usage

``` r
espn_cfb_team_record(
  team_id = NULL,
  year = NULL,
  season_type = 2,
  team_detail = TRUE
)
```

## Arguments

- team_id:

  (*Integer* required): ESPN team id.

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 2000

- season_type:

  (*Integer* default 2): ESPN season type. `2` = regular season, `3` =
  postseason.

- team_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN team catalog once
  and join friendly team fields next to the `team_id` column (see
  *Details*). Set `FALSE` to skip the catalog fetch and the join.

## Value

A data frame with one row per record-stat:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Season (4-digit year). |
| season_type | integer | ESPN season type (2 = regular, 3 = postseason). |
| team_id | character | ESPN team id. |
| team_name | character | Team nickname; `team_detail = TRUE` only. |
| team_abbreviation | character | Team abbreviation; `team_detail = TRUE` only. |
| team_location | character | Team location / school name; `team_detail = TRUE` only. |
| team_display_name | character | Full team display name; `team_detail = TRUE` only. |
| team_short_display_name | character | Short team display name; `team_detail = TRUE` only. |
| team_nickname | character | Team nickname label; `team_detail = TRUE` only. |
| team_color | character | Primary team color; `team_detail = TRUE` only. |
| team_alternate_color | character | Alternate team color; `team_detail = TRUE` only. |
| team_logo_href | character | Default team logo URL; `team_detail = TRUE` only. |
| team_logo_dark_href | character | Dark-variant team logo URL; `team_detail = TRUE` only. |
| record_type | character | Record type code (e.g. `total`, `homerecord`). |
| record_name | character | Record display name (e.g. `overall`, `Home`). |
| record_summary | character | Win-loss summary string (e.g. `13-1`). |
| stat_name | character | Stat key (e.g. `wins`, `avgPointsFor`). |
| stat_value | numeric | Numeric stat value. |
| stat_display | character | Display-formatted stat value. |

## Details

Wraps the ESPN core-v2 team record endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/types/{season_type}/teams/{team_id}/record`.
ESPN returns several record items per team (overall, home record, away
record, vs. conference), each carrying ~20 summary stats. This wrapper
flattens that to long format: one row per (record-item x stat). The long
shape absorbs ESPN adding or retiring stat keys across seasons. Pivot
wider with
[`tidyr::pivot_wider()`](https://tidyr.tidyverse.org/reference/pivot_wider.html)
keyed on `stat_name` for a wide table.

When `team_detail = TRUE` (the default) the ESPN team catalog
([`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md))
is fetched once and friendly team fields are joined in next to the
`team_id` column – `team_name`, `team_abbreviation`, `team_location`,
`team_display_name`, `team_short_display_name`, `team_nickname`,
`team_color`, `team_alternate_color`, `team_logo_href`, and
`team_logo_dark_href`, inserted immediately after `team_id`. A catalog
failure degrades to `NA` rather than erroring the wrapper. Set
`team_detail = FALSE` to skip the catalog fetch and the join.

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
[`espn_cfb_game_odds()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_odds.md),
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
  try(espn_cfb_team_record(team_id = 61, year = 2024))
#> ── Team record from ESPN ───────────────────────────────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-24 13:05:18 UTC
#> # A tibble: 92 × 19
#>    season season_type team_id team_name team_abbreviation team_location
#>     <int>       <int> <chr>   <chr>     <chr>             <chr>        
#>  1   2024           2 61      Bulldogs  UGA               Georgia      
#>  2   2024           2 61      Bulldogs  UGA               Georgia      
#>  3   2024           2 61      Bulldogs  UGA               Georgia      
#>  4   2024           2 61      Bulldogs  UGA               Georgia      
#>  5   2024           2 61      Bulldogs  UGA               Georgia      
#>  6   2024           2 61      Bulldogs  UGA               Georgia      
#>  7   2024           2 61      Bulldogs  UGA               Georgia      
#>  8   2024           2 61      Bulldogs  UGA               Georgia      
#>  9   2024           2 61      Bulldogs  UGA               Georgia      
#> 10   2024           2 61      Bulldogs  UGA               Georgia      
#> # ℹ 82 more rows
#> # ℹ 13 more variables: team_display_name <chr>, team_short_display_name <chr>,
#> #   team_nickname <chr>, team_color <chr>, team_alternate_color <chr>,
#> #   team_logo_href <chr>, team_logo_dark_href <chr>, record_type <chr>,
#> #   record_name <chr>, record_summary <chr>, stat_name <chr>, stat_value <dbl>,
#> #   stat_display <chr>
  try(espn_cfb_team_record(team_id = 61, year = 2024,
                           team_detail = FALSE))
#> ── Team record from ESPN ───────────────────────────────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-24 13:05:18 UTC
#> # A tibble: 92 × 9
#>    season season_type team_id record_type record_name record_summary stat_name  
#>     <int>       <int> <chr>   <chr>       <chr>       <chr>          <chr>      
#>  1   2024           2 61      total       overall     11-2           OTLosses   
#>  2   2024           2 61      total       overall     11-2           OTWins     
#>  3   2024           2 61      total       overall     11-2           avgPointsA…
#>  4   2024           2 61      total       overall     11-2           avgPointsF…
#>  5   2024           2 61      total       overall     11-2           differenti…
#>  6   2024           2 61      total       overall     11-2           divisionWi…
#>  7   2024           2 61      total       overall     11-2           gamesBehind
#>  8   2024           2 61      total       overall     11-2           gamesPlayed
#>  9   2024           2 61      total       overall     11-2           leagueWinP…
#> 10   2024           2 61      total       overall     11-2           losses     
#> # ℹ 82 more rows
#> # ℹ 2 more variables: stat_value <dbl>, stat_display <chr>
# }
```
