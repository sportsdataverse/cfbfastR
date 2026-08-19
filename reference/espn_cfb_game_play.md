# **ESPN College Football Game Play (Single Play Detail)**

Get the full detail object for a single play of a college football game
– one row with the play type, text, score, clock, down/distance, and
win-probability delta.

## Usage

``` r
espn_cfb_game_play(
  game_id = NULL,
  play_id = NULL,
  participants = c("none", "wide", "long"),
  participants_list = FALSE,
  team_participants = c("none", "wide"),
  team_participants_list = FALSE,
  team_detail = TRUE
)
```

## Arguments

- game_id:

  (*Integer* required): ESPN game identifier.

- play_id:

  (*Character* required): ESPN play id (from
  [`espn_cfb_game_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_pbp.md)).
  Supply as a character string – the id is too large for an exact
  numeric.

- participants:

  (*Character*): controls whether the play's nested `participants[]`
  array (the athletes credited on the play) is attached. One of:

  - `"none"` (default) – the single-row play frame is returned
    unchanged; no extra HTTP call is made.

  - `"wide"` – the single row gains type-keyed `{type}_player_*` columns
    (see *Details*).

  - `"long"` – the frame is expanded to one row per participant (see
    *Details*).

- participants_list:

  (*Logical*): when `TRUE`, append a single list-column named
  `participants` holding the play's full participant detail – including
  the per-participant `stats[]` that `"wide"` mode drops. Defaults to
  `FALSE`. This is **independent of and combinable with** the
  `participants` argument (see *Details*).

- team_participants:

  (*Character*): controls whether the play's nested `teamParticipants[]`
  array (the team(s) credited on the play) is attached as type-keyed
  columns. One of:

  - `"none"` (default) – no team-participant columns are added.

  - `"wide"` – the single row gains type-keyed `{type}_team_*` columns
    (see *Details*).

- team_participants_list:

  (*Logical*): when `TRUE`, append a single list-column named
  `team_participants` holding the play's full `teamParticipants[]`
  detail as a nested tibble. Defaults to `FALSE`. This is **independent
  of and combinable with** the `team_participants` argument (see
  *Details*).

- team_detail:

  (*Logical*): when `TRUE` (default), the ESPN team catalog
  ([`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md))
  is fetched once and friendly team fields are joined in next to every
  team-id column in the output (`team_id`, `start_team_id`,
  `end_team_id`, plus any optional `{type}_team_id` /
  `{type}_player_team_id` columns). For each id column `X_id` the
  sibling columns `X_name`, `X_abbreviation`, `X_location`,
  `X_display_name`, `X_short_display_name`, `X_nickname`, `X_color`,
  `X_alternate_color`, `X_logo_href`, `X_logo_dark_href` are inserted
  immediately after it. A catalog failure degrades to `NA` rather than
  erroring the wrapper. Set `FALSE` to skip the catalog fetch and the
  join.

## Value

A data frame with one row describing the play:

|  |  |  |
|----|----|----|
| col_name | types | description |
| game_id | character | ESPN game identifier. |
| play_id | character | ESPN play id. |
| sequence_number | character | Play sequence number within the game. |
| type_id | character | Play-type id. |
| type_text | character | Play-type text (e.g. `Pass Reception`). |
| type_abbreviation | character | Play-type abbreviation (e.g. `RUSH`, `TD`). |
| text | character | Full play description. |
| short_text | character | Short play description. |
| alternative_text | character | Alternative play description. |
| short_alternative_text | character | Short alternative play description. |
| period | integer | Period (quarter) number. |
| clock | character | Game clock display value at the play (`MM:SS`). |
| clock_seconds | numeric | Game clock value in seconds at the play. |
| home_score | integer | Home-team score after the play. |
| away_score | integer | Away-team score after the play. |
| scoring_play | logical | `TRUE` if the play resulted in a score. |
| score_value | integer | Points scored on the play. |
| priority | logical | `TRUE` if ESPN flags the play as a priority highlight. |
| is_penalty | logical | `TRUE` if the play was a penalty. |
| is_turnover | logical | `TRUE` if the play was a turnover. |
| stat_yardage | integer | Yards gained or lost on the play. |
| scoring_type_name | character | Scoring-type key on a scoring play (e.g. `touchdown`). |
| scoring_type_display_name | character | Human-readable scoring-type name. |
| scoring_type_abbreviation | character | Scoring-type abbreviation (e.g. `TD`, `FG`). |
| point_after_attempt_id | integer | Point-after-attempt id on a scoring play. |
| point_after_attempt_text | character | Point-after-attempt text (e.g. `Extra Point Good`). |
| point_after_attempt_abbreviation | character | Point-after-attempt abbreviation. |
| point_after_attempt_value | integer | Points added by the point-after attempt. |
| start_down | integer | Down at the start of the play. |
| start_distance | integer | Yards to go at the start of the play. |
| start_yard_line | integer | Yard line at the start of the play. |
| start_yards_to_endzone | integer | Yards to the end zone at the start of the play. |
| start_down_distance_text | character | Down-and-distance text at the start of the play. |
| start_short_down_distance_text | character | Short down-and-distance text at the start of the play. |
| start_possession_text | character | Field-position text at the start of the play. |
| start_team_id | character | ESPN team id in possession at the start of the play. |
| end_down | integer | Down at the end of the play. |
| end_distance | integer | Yards to go at the end of the play. |
| end_yard_line | integer | Yard line at the end of the play. |
| end_yards_to_endzone | integer | Yards to the end zone at the end of the play. |
| end_down_distance_text | character | Down-and-distance text at the end of the play. |
| end_short_down_distance_text | character | Short down-and-distance text at the end of the play. |
| end_possession_text | character | Field-position text at the end of the play. |
| end_team_id | character | ESPN team id in possession at the end of the play. |
| team_id | character | ESPN team id of the offensive team (parsed from `team_ref`). |
| drive_play_id | character | ESPN drive id the play belongs to (parsed from `drive_ref`). |
| wallclock | character | Real-world ISO timestamp of the play. |
| modified | character | ISO timestamp the play record was last modified. |
| play_ref | character | `$ref` URL to the play resource itself. |
| team_ref | character | `$ref` URL to the offensive team resource. |
| start_team_ref | character | `$ref` URL to the team in possession at the play start. |
| end_team_ref | character | `$ref` URL to the team in possession at the play end. |
| drive_ref | character | `$ref` URL to the play's drive resource. |
| probability_ref | character | `$ref` URL to the play's win-probability resource. |

The optional participant and team-participant columns are described in
*Details* – they are added only when the corresponding argument requests
them.

## Details

Wraps the ESPN core-v2 endpoint
`events/{game_id}/competitions/{game_id}/plays/{play_id}`. The
competition id always equals the game id. Returns a single-row data
frame describing one play in full. Harvest the `play_id` from the
competition-level
[`espn_cfb_game_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_pbp.md)
feed (its `play_id` column) or from
[`espn_cfb_game_drive_plays()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_drive_plays.md).
Use this wrapper for play drill-down when you need a single play's
complete object rather than the whole game feed.

ESPN play ids are 18-digit integers that exceed R's exact
double-precision range – **pass `play_id` as a character string** (e.g.
`"401628339101927401"`) so no precision is lost. A bare numeric literal
will be silently rounded and the lookup will 404.

When `participants = "wide"`, the base play schema is kept intact and
six columns are appended for every participant `type` on the play. The
column names are **dynamic** – one set per participant type present
(e.g. `passer`, `rusher`, `receiver`, `tackler`, `sacked_by`,
`pass_defender`). ESPN's camelCase types are snake-cased (`sackedBy` -\>
`sacked_by`). For each type the appended columns are `{type}_player_id`
(scalar character, the first occurrence of that type on the play),
`{type}_player_name` (scalar character, that athlete's roster-joined
name), `{type}_player_position` (scalar character, that athlete's
position abbreviation from the ESPN position catalog),
`{type}_player_position_name` (scalar character, that athlete's position
name), `{type}_player_ids` (a **list-column**: a character vector of
every athlete id of that type, in ESPN order; `character(0)` if none),
and `{type}_player_names` (a **list-column**: the parallel vector of
roster-joined names). Participant `stats[]` are not carried in wide mode
– use `"long"` for the per-participant stats.

When `participants = "long"`, the frame is expanded to one row per
participant with `participant_index`, `participant_athlete_id`,
`participant_type`, `participant_order`, the roster-joined
`participant_athlete_name` / `participant_position` /
`participant_jersey` / `participant_team_id`, and the participant's
stats pivoted to named `pstat_<statname>` columns. A play with zero
participants still yields one row (participant fields `NA`).

When `participants_list = TRUE`, a single list-column named
`participants` is appended. Its one cell is a tibble with one row per
participant on the play and columns `participant_index` (1-based, ESPN
order), `type` (snake_cased, e.g. `sacked_by`, `pass_defender`),
`athlete_id`, `athlete_name` (roster-joined), `order`, `position_id`,
plus one column per participant `stat[]` name
([`dplyr::bind_rows`](https://dplyr.tidyverse.org/reference/bind_rows.html)
NA-fills participants whose stat sets differ). A play with no
participants carries an empty 0-row tibble, never `NULL`. This option is
independent of `participants` and composes with any of its modes – e.g.
`participants = "wide", participants_list = TRUE` yields the type-keyed
`{type}_player_*` columns **and** the `participants` list-column. With
`participants = "long"` the list-column repeats per participant row.

When `team_participants = "wide"`, three columns are appended for every
`teamParticipants[]` `type` on the play (ESPN ships `offense` /
`defense`). The column names are **dynamic** – one set per type,
snake-cased: `{type}_team_id` (scalar character, the first occurrence of
that type on the play), `{type}_team_order` (scalar integer, ESPN's
display order), and `{type}_team_ref` (scalar character, the `$ref` URL
to that team resource). A play with none of a type carries `NA`.

When `team_participants_list = TRUE`, a single list-column named
`team_participants` is appended. Its one cell is a tibble with one row
per team credited on the play and columns `team_participant_index`
(1-based, ESPN order), `team_id`, `team_ref`, `order`, and `type` (e.g.
`offense`, `defense`). A play with no team participants carries an empty
0-row tibble, never `NULL`. This option is independent of
`team_participants` and composes with it – e.g.
`team_participants = "wide", team_participants_list = TRUE` yields both
the type-keyed `{type}_team_*` columns **and** the `team_participants`
list-column, while `team_participants = "none"` adds neither.

When `team_detail = TRUE` (the default), the ESPN team catalog
([`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md))
is fetched once and joined onto **every** team-id column the output
carries – the base `team_id` / `start_team_id` / `end_team_id`, plus any
optional `{type}_team_id` (from `team_participants = "wide"`) and
`{type}_player_team_id` (from `participants = "long"`) columns. For each
id column `X_id` the friendly siblings `X_name`, `X_abbreviation`,
`X_location`, `X_display_name`, `X_short_display_name`, `X_nickname`,
`X_color`, `X_alternate_color`, `X_logo_href`, and `X_logo_dark_href`
are inserted immediately after it (e.g. `team_id` -\> `team_name`,
`team_abbreviation`, ...; `start_team_id` -\> `start_team_name`, ...).
Rows whose id is missing or unmatched receive `NA`, and a catalog-fetch
failure degrades the whole set to `NA` rather than erroring the wrapper.
With `team_detail = FALSE` the friendly columns (and the catalog fetch)
are skipped.

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
  try(espn_cfb_game_play(game_id = 401628339,
                         play_id = "401628339101927401"))
#> ── Game play data from ESPN ────────────────────────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-08-19 12:29:25 UTC
#> # A tibble: 1 × 84
#>   game_id   play_id    sequence_number type_id type_text type_abbreviation text 
#>   <chr>     <chr>      <chr>           <chr>   <chr>     <chr>             <chr>
#> 1 401628339 401628339… 101927401       24      Pass Rec… REC               Cars…
#> # ℹ 77 more variables: short_text <chr>, alternative_text <chr>,
#> #   short_alternative_text <chr>, period <int>, clock <chr>,
#> #   clock_seconds <dbl>, home_score <int>, away_score <int>,
#> #   scoring_play <lgl>, score_value <int>, priority <lgl>, is_penalty <lgl>,
#> #   is_turnover <lgl>, stat_yardage <int>, scoring_type_name <chr>,
#> #   scoring_type_display_name <chr>, scoring_type_abbreviation <chr>,
#> #   point_after_attempt_id <int>, point_after_attempt_text <chr>, …
  try(espn_cfb_game_play(game_id = 401628339,
                         play_id = "401628339101927401",
                         participants = "long"))
#> ── Game play data from ESPN ────────────────────────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-08-19 12:29:25 UTC
#> # A tibble: 4 × 111
#>   game_id   play_id    sequence_number type_id type_text type_abbreviation text 
#>   <chr>     <chr>      <chr>           <chr>   <chr>     <chr>             <chr>
#> 1 401628339 401628339… 101927401       24      Pass Rec… REC               Cars…
#> 2 401628339 401628339… 101927401       24      Pass Rec… REC               Cars…
#> 3 401628339 401628339… 101927401       24      Pass Rec… REC               Cars…
#> 4 401628339 401628339… 101927401       24      Pass Rec… REC               Cars…
#> # ℹ 104 more variables: short_text <chr>, alternative_text <chr>,
#> #   short_alternative_text <chr>, period <int>, clock <chr>,
#> #   clock_seconds <dbl>, home_score <int>, away_score <int>,
#> #   scoring_play <lgl>, score_value <int>, priority <lgl>, is_penalty <lgl>,
#> #   is_turnover <lgl>, stat_yardage <int>, scoring_type_name <chr>,
#> #   scoring_type_display_name <chr>, scoring_type_abbreviation <chr>,
#> #   point_after_attempt_id <int>, point_after_attempt_text <chr>, …
  try(espn_cfb_game_play(game_id = 401628339,
                         play_id = "401628339101927401",
                         participants = "wide",
                         participants_list = TRUE))
#> ── Game play data from ESPN ────────────────────────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-08-19 12:29:25 UTC
#> # A tibble: 1 × 103
#>   game_id   play_id    sequence_number type_id type_text type_abbreviation text 
#>   <chr>     <chr>      <chr>           <chr>   <chr>     <chr>             <chr>
#> 1 401628339 401628339… 101927401       24      Pass Rec… REC               Cars…
#> # ℹ 96 more variables: short_text <chr>, alternative_text <chr>,
#> #   short_alternative_text <chr>, period <int>, clock <chr>,
#> #   clock_seconds <dbl>, home_score <int>, away_score <int>,
#> #   scoring_play <lgl>, score_value <int>, priority <lgl>, is_penalty <lgl>,
#> #   is_turnover <lgl>, stat_yardage <int>, scoring_type_name <chr>,
#> #   scoring_type_display_name <chr>, scoring_type_abbreviation <chr>,
#> #   point_after_attempt_id <int>, point_after_attempt_text <chr>, …
  try(espn_cfb_game_play(game_id = 401628339,
                         play_id = "401628339101927401",
                         team_participants = "wide",
                         team_participants_list = TRUE))
#> ── Game play data from ESPN ────────────────────────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-08-19 12:29:26 UTC
#> # A tibble: 1 × 111
#>   game_id   play_id    sequence_number type_id type_text type_abbreviation text 
#>   <chr>     <chr>      <chr>           <chr>   <chr>     <chr>             <chr>
#> 1 401628339 401628339… 101927401       24      Pass Rec… REC               Cars…
#> # ℹ 104 more variables: short_text <chr>, alternative_text <chr>,
#> #   short_alternative_text <chr>, period <int>, clock <chr>,
#> #   clock_seconds <dbl>, home_score <int>, away_score <int>,
#> #   scoring_play <lgl>, score_value <int>, priority <lgl>, is_penalty <lgl>,
#> #   is_turnover <lgl>, stat_yardage <int>, scoring_type_name <chr>,
#> #   scoring_type_display_name <chr>, scoring_type_abbreviation <chr>,
#> #   point_after_attempt_id <int>, point_after_attempt_text <chr>, …
  try(espn_cfb_game_play(game_id = 401628339,
                         play_id = "401628339101927401",
                         team_detail = FALSE))
#> ── Game play data from ESPN ────────────────────────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-08-19 12:29:26 UTC
#> # A tibble: 1 × 54
#>   game_id   play_id    sequence_number type_id type_text type_abbreviation text 
#>   <chr>     <chr>      <chr>           <chr>   <chr>     <chr>             <chr>
#> 1 401628339 401628339… 101927401       24      Pass Rec… REC               Cars…
#> # ℹ 47 more variables: short_text <chr>, alternative_text <chr>,
#> #   short_alternative_text <chr>, period <int>, clock <chr>,
#> #   clock_seconds <dbl>, home_score <int>, away_score <int>,
#> #   scoring_play <lgl>, score_value <int>, priority <lgl>, is_penalty <lgl>,
#> #   is_turnover <lgl>, stat_yardage <int>, scoring_type_name <chr>,
#> #   scoring_type_display_name <chr>, scoring_type_abbreviation <chr>,
#> #   point_after_attempt_id <int>, point_after_attempt_text <chr>, …
# }
```
