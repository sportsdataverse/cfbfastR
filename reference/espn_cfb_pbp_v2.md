# **Get ESPN College Football Play-by-Play (core-v2)**

The core-v2-sourced successor to
[`espn_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp.md).
Returns one tidy row per play for a single college football game,
optionally with the full Expected Points Added (EPA) / Win Probability
Added (WPA) modeling attached. It supersedes the legacy site-v2
[`espn_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp.md):
instead of parsing the deeply-nested site-v2 `summary` feed, it sources
the play-by-play from the structured ESPN core-v2 drives endpoint in a
single request via
[`espn_cfb_game_drives()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_drives.md)
– one structured call rather than a sprawling summary parse, so it is
faster and more robust to the site-v2 feed's column drift.

## Usage

``` r
espn_cfb_pbp_v2(
  game_id,
  epa_wpa = FALSE,
  output = "default",
  resolve_names = TRUE
)
```

## Arguments

- game_id:

  (*Integer* required): ESPN game identifier.

- epa_wpa:

  (*Logical*): when `TRUE`, run the full EPA/WPA modeling pipeline and
  return the modeled frame; when `FALSE` (default) return the assembled
  core-v2 play-by-play frame.

- output:

  (*Character*): controls the modeled-output column set when
  `epa_wpa = TRUE`. Ignored when `epa_wpa = FALSE`. Defaults to
  `"default"`. Must be one of:

  - `"default"` (recommended) – drops pipeline lag/lead intermediates,
    redundant alternates (`sack_vec`, `turnover_indicator`, `kick_play`,
    `missing_yard_flag`), and drive-result aliases (`drive_result2`,
    `drive_result_detailed_flag`, `lag_drive_result_detailed`,
    `lead_drive_result_detailed`, `lag_new_drive_pts`). Keeps
    `orig_play_type` and `pts_scored` (they carry useful per-play
    information distinct from the canonical columns) and the per-branch
    WPA scratchpad. ~75 columns lighter than `"full"`.

  - `"lean"` – everything `"default"` drops, plus the WPA computation
    scratchpad. For dashboards / game logs.

  - `"full"` – legacy behavior, drops only the player-name aliases.

- resolve_names:

  (*Logical*): when `TRUE` (default) and `epa_wpa = TRUE`, spend **one
  extra request per game** on ESPN's play-by-play sidecar to (a) render
  participant names in full (`"Jalen Mitchell"` rather than the core-v2
  roster's `"J. Mitchell"`) and (b) add the per-player box score as a
  second identity source, which is the only one available on the large
  share of games where ESPN 404s the roster resource. Memoised per
  `game_id`, so the two uses cost one request between them. Set `FALSE`
  for a bulk sweep that would rather have the short names than the
  requests. Ignored when `epa_wpa = FALSE`.

## Value

A data frame with one row per play. When `epa_wpa = FALSE`, the
assembled core-v2 play-by-play frame:

|           |           |                                                  |
|-----------|-----------|--------------------------------------------------|
| col_name  | types     | description                                      |
| game_id   | character | ESPN game identifier.                            |
| play_id   | character | ESPN play id.                                    |
| type_text | character | Play type label (e.g. `Rush`, `Pass Reception`). |

(plus the full
[`espn_cfb_game_drives()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_drives.md)
`plays = "expand"` column set – play start/end down, distance, yard
line, clock, scores, the `drive_*` drive context, team detail – and the
attached game-metadata columns `season`, `season_type`, `week`,
`neutral_site`, `conference_competition`, `game_date`, `home_team_id`,
`home_team`, `away_team_id`, `away_team`).

When `epa_wpa = TRUE`, every column from the `epa_wpa = FALSE` frame
above (game metadata, `drive_*` context, team detail and the full
[`espn_cfb_game_drives()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_drives.md)
play schema) **plus** the modeled EPA/WPA columns produced by the
existing pipeline – `ep_before`, `ep_after`, `EPA`, `wp_before`,
`wp_after`, `wpa` and the supporting probability and cumulative columns.
The `epa_wpa = TRUE` columns are a strict superset of the
`epa_wpa = FALSE` columns, and the row count is unchanged.

## Details

**Play-by-play assembly (always).** The play rows come from
`espn_cfb_game_drives(game_id, plays = "expand", team_detail = TRUE)` –
one row per play, in the full
[`espn_cfb_game_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_pbp.md)
schema, with each play's drive-level context carried alongside
(`drive_*` columns) and the ESPN team catalog joined onto every team-id
column. Game-level metadata matching the legacy
[`espn_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp.md)
output – `season`, `season_type`, `week`, `neutral_site`,
`conference_competition`, `game_date`, and the `home_team_id` /
`home_team` / `away_team_id` / `away_team` (plus abbreviations) – is
attached from the core-v2 event resource and
[`espn_cfb_game_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_teams.md).

**Game-meta bridge.** Season / season_type / week / neutral_site /
conference_competition / game_date and the full home/away block –
including `*_team_name`, `*_team_color`, `*_team_alternate_color`, and
the week-specific `*_team_rank` – are sourced via
`.espn_pbp_game_meta()`, which queries the core-v2 event resource. This
makes `espn_cfb_pbp_v2()` a strict meta-column superset of legacy
[`espn_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp.md).

**Native participant columns.** This wrapper requests
`participants = "wide"` and `team_participants = "wide"` from
[`espn_cfb_game_drives()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_drives.md),
so the play frame carries type-keyed `{type}_player_id` /
`{type}_player_name` / `{type}_player_position` columns (e.g.
`passer_player_id`, `rusher_player_id`, `tackler_player_id`) and
`{type}_team_*` columns. Wide mode also emits the `{type}_player_ids` /
`{type}_player_names` list-columns; downstream parquet/CSV writers must
drop or stringify these before serialization. One additional roster
fetch + position-catalog fetch per game.

**`epa_wpa` behaviour.** When `epa_wpa = FALSE` (default) the assembled
core-v2 frame is returned as-is. When `epa_wpa = TRUE` the core-v2
columns are mapped into the exact column schema the legacy
[`espn_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp.md)
hands to its EPA/WPA pipeline, and the **same** modeling stack is run
verbatim –
[`penalty_detection()`](https://cfbfastR.sportsdataverse.org/reference/helpers_pbp.md),
[`add_play_counts()`](https://cfbfastR.sportsdataverse.org/reference/helpers_pbp.md),
[`clean_pbp_dat()`](https://cfbfastR.sportsdataverse.org/reference/helpers_pbp.md),
[`clean_drive_dat()`](https://cfbfastR.sportsdataverse.org/reference/helpers_pbp.md),
[`add_yardage()`](https://cfbfastR.sportsdataverse.org/reference/helpers_pbp.md),
[`add_player_cols()`](https://cfbfastR.sportsdataverse.org/reference/helpers_pbp.md),
[`prep_epa_df_after()`](https://cfbfastR.sportsdataverse.org/reference/helpers_pbp.md),
[`create_epa()`](https://cfbfastR.sportsdataverse.org/reference/create_epa.md)
and
[`create_wpa_naive()`](https://cfbfastR.sportsdataverse.org/reference/create_wpa.md).
The statistical models (the `mgcv` GAMs, the multinomial EP model, the
FG model and the WP model shipped with the package) are reused
unchanged; this wrapper only supplies the column adapter between the
core-v2 play schema and the modeling input contract. The modeled EPA/WPA
columns the pipeline emits – `ep_before`, `ep_after`, `EPA`,
`wp_before`, `wp_after`, `wpa`, and the supporting probability and
cumulative columns – are then joined back onto the **full**
`epa_wpa = FALSE` context frame by `play_id`. The `epa_wpa = TRUE`
output is therefore a strict **superset** of the `epa_wpa = FALSE`
output: every game-metadata and drive-context column the default path
produces, plus the EPA/WPA model columns. The join is a left join from
the context frame, so no play row is dropped and the row count is
identical to the `epa_wpa = FALSE` result.

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
  try(espn_cfb_pbp_v2(game_id = 401628339, epa_wpa = TRUE))
#> ── Play-by-play data from ESPN (core-v2) ──────────────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-09-01 11:26:39 UTC
#> # A tibble: 156 × 536
#>    season id_play    game_id game_play_number half_play_number drive_play_number
#>     <int> <chr>      <chr>              <dbl>            <dbl>             <dbl>
#>  1   2024 401628339… 401628…                1                1                 1
#>  2   2024 401628339… 401628…                2                2                 2
#>  3   2024 401628339… 401628…                3                3                 3
#>  4   2024 401628339… 401628…                3                3                 3
#>  5   2024 401628339… 401628…                4                4                 4
#>  6   2024 401628339… 401628…                5                5                 5
#>  7   2024 401628339… 401628…                6                6                 1
#>  8   2024 401628339… 401628…                7                7                 1
#>  9   2024 401628339… 401628…                8                8                 2
#> 10   2024 401628339… 401628…                9                9                 3
#> # ℹ 146 more rows
#> # ℹ 530 more variables: pos_team <chr>, def_pos_team <chr>,
#> #   pos_team_score <int>, def_pos_team_score <int>, half <fct>, period <int>,
#> #   clock_minutes <dbl>, clock_seconds <dbl>, play_type <chr>, play_text <chr>,
#> #   down <dbl>, distance <dbl>, yards_to_goal <dbl>, yards_gained <dbl>,
#> #   EPA <dbl>, ep_before <dbl>, ep_after <dbl>, wpa <dbl>, wp_before <dbl>,
#> #   wp_after <dbl>, def_wp_before <dbl>, def_wp_after <dbl>, …
# }
```
