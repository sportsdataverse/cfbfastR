# **ESPN College Football Standings (Long Format)**

Get ESPN's standings for a college football group – the full set of
record splits (overall, home, away, conference, ...) and every standings
statistic (wins, losses, point differential, streak, ...) for every team
in the group.

## Usage

``` r
espn_cfb_standings(
  year = NULL,
  group_id = 90,
  season_type = 2,
  team_detail = TRUE
)
```

## Arguments

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).

- group_id:

  (*Integer* default 90): ESPN group id. `90` = NCAA Division I (all D-I
  teams). Conference group ids also work.

- season_type:

  (*Integer* default 2): ESPN season type id. `2` = regular season.

- team_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN team catalog once
  and join friendly team fields next to the `team_id` column (see
  *Details*). Set `FALSE` to skip the catalog fetch and the join.

## Value

A data frame with one row per team-record-statistic:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Season (4-digit year). |
| season_type | integer | ESPN season type id queried. |
| group_id | character | ESPN group id queried. |
| team_id | character | ESPN team id (parsed from `team_ref`). |
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
| record_type | character | Record split type code (e.g. `total`, `homerecord`). |
| record_name | character | Record split name (e.g. `Overall`, `Home`). |
| record_summary | character | Record split summary (e.g. `14-0`). |
| stat_name | character | Standings statistic key (e.g. `wins`, `streak`). |
| abbreviation | character | Statistic abbreviation. |
| display_name | character | Human-readable statistic name. |
| value | numeric | Statistic value. |
| display_value | character | Display-formatted statistic value. |
| team_ref | character | `$ref` URL to the per-season team resource. |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/types/{season_type}/groups/{group_id}/standings`.
The standings resource nests three levels deep – team -\> record split
-\> statistic – so this wrapper returns long format: one row per (team x
record split x statistic). The long shape absorbs ESPN's habit of adding
standings stats across seasons. Pivot wider keyed on `stat_name` (within
a `record_type`) when a wide table is wanted.

`group_id = 90` (NCAA Division I) is the sensible default and yields
every D-I team in one call. Conference-level `group_id`s – enumerate
them with
[`espn_cfb_groups()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_groups.md)
– restrict the table to that conference.

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
  try(espn_cfb_standings(year = 2024))
#> ── Standings data from ESPN ────────────────────────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-06-24 02:07:44 UTC
#> # A tibble: 36,892 × 23
#>    season season_type group_id team_id team_name team_abbreviation team_location
#>     <int>       <int> <chr>    <chr>   <chr>     <chr>             <chr>        
#>  1   2024           2 90       147     Bobcats   MTST              Montana State
#>  2   2024           2 90       147     Bobcats   MTST              Montana State
#>  3   2024           2 90       147     Bobcats   MTST              Montana State
#>  4   2024           2 90       147     Bobcats   MTST              Montana State
#>  5   2024           2 90       147     Bobcats   MTST              Montana State
#>  6   2024           2 90       147     Bobcats   MTST              Montana State
#>  7   2024           2 90       147     Bobcats   MTST              Montana State
#>  8   2024           2 90       147     Bobcats   MTST              Montana State
#>  9   2024           2 90       147     Bobcats   MTST              Montana State
#> 10   2024           2 90       147     Bobcats   MTST              Montana State
#> # ℹ 36,882 more rows
#> # ℹ 16 more variables: team_display_name <chr>, team_short_display_name <chr>,
#> #   team_nickname <chr>, team_color <chr>, team_alternate_color <chr>,
#> #   team_logo_href <chr>, team_logo_dark_href <chr>, record_type <chr>,
#> #   record_name <chr>, record_summary <chr>, stat_name <chr>,
#> #   abbreviation <chr>, display_name <chr>, value <dbl>, display_value <chr>,
#> #   team_ref <chr>
  try(espn_cfb_standings(year = 2024, team_detail = FALSE))
#> ── Standings data from ESPN ────────────────────────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-06-24 02:08:07 UTC
#> # A tibble: 36,892 × 13
#>    season season_type group_id team_id record_type record_name record_summary
#>     <int>       <int> <chr>    <chr>   <chr>       <chr>       <chr>         
#>  1   2024           2 90       147     total       overall     14-0          
#>  2   2024           2 90       147     total       overall     14-0          
#>  3   2024           2 90       147     total       overall     14-0          
#>  4   2024           2 90       147     total       overall     14-0          
#>  5   2024           2 90       147     total       overall     14-0          
#>  6   2024           2 90       147     total       overall     14-0          
#>  7   2024           2 90       147     total       overall     14-0          
#>  8   2024           2 90       147     total       overall     14-0          
#>  9   2024           2 90       147     total       overall     14-0          
#> 10   2024           2 90       147     total       overall     14-0          
#> # ℹ 36,882 more rows
#> # ℹ 6 more variables: stat_name <chr>, abbreviation <chr>, display_name <chr>,
#> #   value <dbl>, display_value <chr>, team_ref <chr>
# }
```
