# **ESPN College Football Players Index**

Get a paginated index of ESPN college football players for a season.
Each row is one player reference (id + `$ref` URL); dereference a row
with
[`espn_cfb_player()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player.md)
to retrieve the full player record.

## Usage

``` r
espn_cfb_players(
  year = NULL,
  page = 1,
  max_pages = 1,
  limit = 100,
  athlete_detail = FALSE
)
```

## Arguments

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).

- page:

  (*Integer* optional, default 1): First page of the index to fetch.

- max_pages:

  (*Integer* optional, default 1): Number of consecutive pages to fetch
  starting at `page`. Each page holds `limit` players.

- limit:

  (*Integer* optional, default 100): Players per page (ESPN page size).

- athlete_detail:

  (*Logical*): when `TRUE`, dereference each player returned and append
  the `athlete_*` name columns (see *Details*). This costs one HTTP call
  per player, so it defaults to `FALSE`; setting it `FALSE` reproduces
  the prior output exactly.

## Value

A data frame with one row per player reference:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Season (4-digit year). |
| athlete_id | character | ESPN athlete id (parsed from `athlete_ref`). |
| athlete_ref | character | `$ref` URL to the athlete-in-season resource. |
| page | integer | Index page this player was returned on. |
| page_count | integer | Total number of pages in the season index. |
| count | integer | Total number of players in the season index. |
| athlete_display_name | character | Player display name; `athlete_detail = TRUE` only. |
| athlete_first_name | character | Player first name; `athlete_detail = TRUE` only. |
| athlete_last_name | character | Player last name; `athlete_detail = TRUE` only. |
| athlete_jersey | character | Player jersey number; `athlete_detail = TRUE` only. |
| athlete_position | character | Player position name; `athlete_detail = TRUE` only. |
| athlete_position_abbreviation | character | Player position abbreviation; `athlete_detail = TRUE` only. |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/athletes`.
The season-scoped index contains roughly 99,500 players, returned in
fixed-size pages – this wrapper deliberately returns *id + `$ref` rows
only* and never dereferences the individual player records, because a
full crawl would be tens of thousands of HTTP calls. Walk the index a
page at a time with `page`, and cap how far a single call goes with
`max_pages`. The total page count for the season is reported in the
`page_count` column so a caller can drive its own pagination loop. To
resolve an individual player to a full record, pass its `athlete_id` to
[`espn_cfb_player()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player.md).

When `athlete_detail = TRUE` the index is enriched with the
human-readable name columns `athlete_display_name`,
`athlete_first_name`, `athlete_last_name`, `athlete_jersey`,
`athlete_position`, and `athlete_position_abbreviation`. There is no
bulk athlete-name catalog, so resolving names here costs **one HTTP call
per player returned** – with the default `limit = 100` that is 100 extra
requests per page. It therefore defaults to `FALSE`. A per-athlete fetch
failure leaves that player's name columns `NA` rather than erroring the
wrapper. Keep `limit` small (or `athlete_detail = FALSE`) when walking
many pages.

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
  try(espn_cfb_players(year = 2024, page = 1, max_pages = 1))
#> ── Players index from ESPN ─────────────────────────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-06-08 01:46:33 UTC
#> # A tibble: 100 × 6
#>    season athlete_id athlete_ref                           page page_count count
#>     <int> <chr>      <chr>                                <int>      <int> <int>
#>  1   2024 2027901    http://sports.core.api.espn.com/v2/…     1        996 99524
#>  2   2024 2488274    http://sports.core.api.espn.com/v2/…     1        996 99524
#>  3   2024 2586732    http://sports.core.api.espn.com/v2/…     1        996 99524
#>  4   2024 2586749    http://sports.core.api.espn.com/v2/…     1        996 99524
#>  5   2024 2586765    http://sports.core.api.espn.com/v2/…     1        996 99524
#>  6   2024 2586812    http://sports.core.api.espn.com/v2/…     1        996 99524
#>  7   2024 2988219    http://sports.core.api.espn.com/v2/…     1        996 99524
#>  8   2024 2988246    http://sports.core.api.espn.com/v2/…     1        996 99524
#>  9   2024 539758     http://sports.core.api.espn.com/v2/…     1        996 99524
#> 10   2024 3145545    http://sports.core.api.espn.com/v2/…     1        996 99524
#> # ℹ 90 more rows
  try(espn_cfb_players(year = 2024, page = 1, max_pages = 1, limit = 5,
                       athlete_detail = TRUE))
#> ── Players index from ESPN ─────────────────────────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-06-08 01:46:33 UTC
#> # A tibble: 5 × 12
#>   season athlete_id athlete_ref       page page_count count athlete_display_name
#>    <int> <chr>      <chr>            <int>      <int> <int> <chr>               
#> 1   2024 2027901    http://sports.c…     1      19905 99524 NA                  
#> 2   2024 2488274    http://sports.c…     1      19905 99524 NA                  
#> 3   2024 2586732    http://sports.c…     1      19905 99524 NA                  
#> 4   2024 2586749    http://sports.c…     1      19905 99524 NA                  
#> 5   2024 2586765    http://sports.c…     1      19905 99524 NA                  
#> # ℹ 5 more variables: athlete_first_name <chr>, athlete_last_name <chr>,
#> #   athlete_jersey <chr>, athlete_position <chr>,
#> #   athlete_position_abbreviation <chr>
# }
```
