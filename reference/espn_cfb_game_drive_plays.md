# **ESPN College Football Game Drive Plays**

Get the play-by-play for a single drive of a college football game – one
row per play, scoped to one drive.

## Usage

``` r
espn_cfb_game_drive_plays(
  game_id = NULL,
  drive_id = NULL,
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

- drive_id:

  (*Integer* required): ESPN drive id (from
  [`espn_cfb_game_drives()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_drives.md)).

- participants:

  (*Character*): controls whether each play's nested `participants[]`
  array (the athletes credited on the play) is attached. One of:

  - `"none"` (default) – the play frame is returned unchanged; no extra
    HTTP call is made.

  - `"wide"` – one row per play, with type-keyed `{type}_player_*`
    columns appended (see *Details*).

  - `"long"` – one row per play x participant (see *Details*).

- participants_list:

  (*Logical*): when `TRUE`, append a single list-column named
  `participants` holding each play's full participant detail – including
  the per-participant `stats[]` that `"wide"` mode drops. Defaults to
  `FALSE`. This is **independent of and combinable with** the
  `participants` argument (see *Details*).

- team_participants:

  (*Character*): controls whether each play's nested
  `teamParticipants[]` array (the team(s) credited on the play) is
  attached as type-keyed columns. One of:

  - `"none"` (default) – no team-participant columns are added.

  - `"wide"` – one row per play, with type-keyed `{type}_team_*` columns
    appended (see *Details*).

- team_participants_list:

  (*Logical*): when `TRUE`, append a single list-column named
  `team_participants` holding each play's full `teamParticipants[]`
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

A data frame with one row per play in the drive:

|  |  |  |
|----|----|----|
| col_name | types | description |
| game_id | character | ESPN game identifier. |
| drive_id | character | ESPN drive id (the requested drive). |
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
`events/{game_id}/competitions/{game_id}/drives/{drive_id}/plays`. The
competition id always equals the game id. Returns the same play schema
as the competition-level
[`espn_cfb_game_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_pbp.md)
feed, but partitioned to a single drive (typically 5-11 plays). Harvest
the `drive_id` from
[`espn_cfb_game_drives()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_drives.md)
– its `drive_id` column lists every drive in the game.

When `participants = "wide"`, the base play schema is kept intact and
six columns are appended for every participant `type` that appears
anywhere in the drive. The column names are **dynamic** – one set per
participant type present (e.g. `passer`, `rusher`, `receiver`,
`tackler`, `sacked_by`, `pass_defender`, `kicker`, `returner`). ESPN's
camelCase types are snake-cased (`sackedBy` -\> `sacked_by`). For each
type the appended columns are:

- `{type}_player_id` – scalar character, the **first** occurrence of
  that type on the play (`NA` if none).

- `{type}_player_name` – scalar character, that athlete's roster-joined
  name (`NA` if none or unmatched).

- `{type}_player_position` – scalar character, the first athlete's
  position abbreviation (joined from the ESPN position catalog; `NA` if
  unmatched).

- `{type}_player_position_name` – scalar character, the first athlete's
  position name.

- `{type}_player_ids` – a **list-column**: a character vector of
  **every** athlete id of that type on the play, in ESPN order. Plays
  with none carry `character(0)`.

- `{type}_player_names` – a **list-column**: the parallel vector of
  roster-joined names.

Participant `stats[]` are not carried in wide mode – use `"long"` for
the per-participant stat lines.

When `participants = "long"`, the frame is expanded to one row per play
x participant with `participant_index`, `participant_athlete_id`,
`participant_type`, `participant_order`, the roster-joined
`participant_athlete_name` / `participant_position` /
`participant_jersey` / `participant_team_id`, and the participant's
stats pivoted to named `pstat_<statname>` columns. Plays with zero
participants still yield one row (participant fields `NA`).

When `participants_list = TRUE`, a single list-column named
`participants` is appended. Each cell is a tibble with one row per
participant on that play and columns `participant_index` (1-based, ESPN
order), `type` (snake_cased, e.g. `sacked_by`, `pass_defender`),
`athlete_id`, `athlete_name` (roster-joined), `order`, `position_id`,
plus one column per participant `stat[]` name
([`dplyr::bind_rows`](https://dplyr.tidyverse.org/reference/bind_rows.html)
NA-fills participants whose stat sets differ). Plays with no
participants carry an empty 0-row tibble, never `NULL`. This option is
independent of `participants` and composes with any of its modes – e.g.
`participants = "wide", participants_list = TRUE` yields the type-keyed
`{type}_player_*` columns **and** the `participants` list-column, while
`participants = "none", participants_list = TRUE` adds only the
list-column. With `participants = "long"` the list-column repeats per
play x participant row. The raw plays are fetched only once even when
both options are active.

When `team_participants = "wide"`, three columns are appended for every
`teamParticipants[]` `type` present anywhere in the drive (ESPN ships
`offense` / `defense`). The column names are **dynamic** – one set per
type, snake-cased: `{type}_team_id` (scalar character, the first
occurrence of that type on the play), `{type}_team_order` (scalar
integer, ESPN's display order), and `{type}_team_ref` (scalar character,
the `$ref` URL to that team resource). Plays with none of a type carry
`NA`.

When `team_participants_list = TRUE`, a single list-column named
`team_participants` is appended. Each cell is a tibble with one row per
team credited on the play and columns `team_participant_index` (1-based,
ESPN order), `team_id`, `team_ref`, `order`, and `type` (e.g. `offense`,
`defense`). A play with no team participants carries an empty 0-row
tibble, never `NULL`. This option is independent of `team_participants`
and composes with it – e.g.
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
  try(espn_cfb_game_drive_plays(game_id = 401628339,
                                drive_id = 4016283391))
#> ── Game drive plays data from ESPN ────────────────────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-08-29 13:13:38 UTC
#> # A tibble: 6 × 85
#>   game_id   drive_id play_id sequence_number type_id type_text type_abbreviation
#>   <chr>     <chr>    <chr>   <chr>           <chr>   <chr>     <chr>            
#> 1 401628339 4016283… 401628… 101849905       53      Kickoff   K                
#> 2 401628339 4016283… 401628… 101849908       24      Pass Rec… REC              
#> 3 401628339 4016283… 401628… 101857801       5       Rush      RUSH             
#> 4 401628339 4016283… 401628… 101866801       21      Timeout   TO               
#> 5 401628339 4016283… 401628… 101866802       5       Rush      RUSH             
#> 6 401628339 4016283… 401628… 101875001       52      Punt      PUNT             
#> # ℹ 78 more variables: text <chr>, short_text <chr>, alternative_text <chr>,
#> #   short_alternative_text <chr>, period <int>, clock <chr>,
#> #   clock_seconds <dbl>, home_score <int>, away_score <int>,
#> #   scoring_play <lgl>, score_value <int>, priority <lgl>, is_penalty <lgl>,
#> #   is_turnover <lgl>, stat_yardage <int>, scoring_type_name <chr>,
#> #   scoring_type_display_name <chr>, scoring_type_abbreviation <chr>,
#> #   point_after_attempt_id <int>, point_after_attempt_text <chr>, …
  try(espn_cfb_game_drive_plays(game_id = 401628339,
                                drive_id = 4016283391,
                                participants = "long"))
#> ── Game drive plays data from ESPN ────────────────────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-08-29 13:13:38 UTC
#> # A tibble: 14 × 126
#>    game_id  drive_id play_id sequence_number type_id type_text type_abbreviation
#>    <chr>    <chr>    <chr>   <chr>           <chr>   <chr>     <chr>            
#>  1 4016283… 4016283… 401628… 101849905       53      Kickoff   K                
#>  2 4016283… 4016283… 401628… 101849908       24      Pass Rec… REC              
#>  3 4016283… 4016283… 401628… 101849908       24      Pass Rec… REC              
#>  4 4016283… 4016283… 401628… 101849908       24      Pass Rec… REC              
#>  5 4016283… 4016283… 401628… 101857801       5       Rush      RUSH             
#>  6 4016283… 4016283… 401628… 101857801       5       Rush      RUSH             
#>  7 4016283… 4016283… 401628… 101857801       5       Rush      RUSH             
#>  8 4016283… 4016283… 401628… 101866801       21      Timeout   TO               
#>  9 4016283… 4016283… 401628… 101866802       5       Rush      RUSH             
#> 10 4016283… 4016283… 401628… 101866802       5       Rush      RUSH             
#> 11 4016283… 4016283… 401628… 101875001       52      Punt      PUNT             
#> 12 4016283… 4016283… 401628… 101875001       52      Punt      PUNT             
#> 13 4016283… 4016283… 401628… 101875001       52      Punt      PUNT             
#> 14 4016283… 4016283… 401628… 101875001       52      Punt      PUNT             
#> # ℹ 119 more variables: text <chr>, short_text <chr>, alternative_text <chr>,
#> #   short_alternative_text <chr>, period <int>, clock <chr>,
#> #   clock_seconds <dbl>, home_score <int>, away_score <int>,
#> #   scoring_play <lgl>, score_value <int>, priority <lgl>, is_penalty <lgl>,
#> #   is_turnover <lgl>, stat_yardage <int>, scoring_type_name <chr>,
#> #   scoring_type_display_name <chr>, scoring_type_abbreviation <chr>,
#> #   point_after_attempt_id <int>, point_after_attempt_text <chr>, …
  try(espn_cfb_game_drive_plays(game_id = 401628339,
                                drive_id = 4016283391,
                                participants = "wide",
                                participants_list = TRUE))
#> ── Game drive plays data from ESPN ────────────────────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-08-29 13:13:40 UTC
#> # A tibble: 6 × 134
#>   game_id   drive_id play_id sequence_number type_id type_text type_abbreviation
#>   <chr>     <chr>    <chr>   <chr>           <chr>   <chr>     <chr>            
#> 1 401628339 4016283… 401628… 101849905       53      Kickoff   K                
#> 2 401628339 4016283… 401628… 101849908       24      Pass Rec… REC              
#> 3 401628339 4016283… 401628… 101857801       5       Rush      RUSH             
#> 4 401628339 4016283… 401628… 101866801       21      Timeout   TO               
#> 5 401628339 4016283… 401628… 101866802       5       Rush      RUSH             
#> 6 401628339 4016283… 401628… 101875001       52      Punt      PUNT             
#> # ℹ 127 more variables: text <chr>, short_text <chr>, alternative_text <chr>,
#> #   short_alternative_text <chr>, period <int>, clock <chr>,
#> #   clock_seconds <dbl>, home_score <int>, away_score <int>,
#> #   scoring_play <lgl>, score_value <int>, priority <lgl>, is_penalty <lgl>,
#> #   is_turnover <lgl>, stat_yardage <int>, scoring_type_name <chr>,
#> #   scoring_type_display_name <chr>, scoring_type_abbreviation <chr>,
#> #   point_after_attempt_id <int>, point_after_attempt_text <chr>, …
  try(espn_cfb_game_drive_plays(game_id = 401628339,
                                drive_id = 4016283391,
                                team_participants = "wide",
                                team_participants_list = TRUE))
#> ── Game drive plays data from ESPN ────────────────────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-08-29 13:13:40 UTC
#> # A tibble: 6 × 112
#>   game_id   drive_id play_id sequence_number type_id type_text type_abbreviation
#>   <chr>     <chr>    <chr>   <chr>           <chr>   <chr>     <chr>            
#> 1 401628339 4016283… 401628… 101849905       53      Kickoff   K                
#> 2 401628339 4016283… 401628… 101849908       24      Pass Rec… REC              
#> 3 401628339 4016283… 401628… 101857801       5       Rush      RUSH             
#> 4 401628339 4016283… 401628… 101866801       21      Timeout   TO               
#> 5 401628339 4016283… 401628… 101866802       5       Rush      RUSH             
#> 6 401628339 4016283… 401628… 101875001       52      Punt      PUNT             
#> # ℹ 105 more variables: text <chr>, short_text <chr>, alternative_text <chr>,
#> #   short_alternative_text <chr>, period <int>, clock <chr>,
#> #   clock_seconds <dbl>, home_score <int>, away_score <int>,
#> #   scoring_play <lgl>, score_value <int>, priority <lgl>, is_penalty <lgl>,
#> #   is_turnover <lgl>, stat_yardage <int>, scoring_type_name <chr>,
#> #   scoring_type_display_name <chr>, scoring_type_abbreviation <chr>,
#> #   point_after_attempt_id <int>, point_after_attempt_text <chr>, …
  try(espn_cfb_game_drive_plays(game_id = 401628339,
                                drive_id = 4016283391,
                                team_detail = FALSE))
#> ── Game drive plays data from ESPN ────────────────────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-08-29 13:13:41 UTC
#> # A tibble: 6 × 55
#>   game_id   drive_id play_id sequence_number type_id type_text type_abbreviation
#>   <chr>     <chr>    <chr>   <chr>           <chr>   <chr>     <chr>            
#> 1 401628339 4016283… 401628… 101849905       53      Kickoff   K                
#> 2 401628339 4016283… 401628… 101849908       24      Pass Rec… REC              
#> 3 401628339 4016283… 401628… 101857801       5       Rush      RUSH             
#> 4 401628339 4016283… 401628… 101866801       21      Timeout   TO               
#> 5 401628339 4016283… 401628… 101866802       5       Rush      RUSH             
#> 6 401628339 4016283… 401628… 101875001       52      Punt      PUNT             
#> # ℹ 48 more variables: text <chr>, short_text <chr>, alternative_text <chr>,
#> #   short_alternative_text <chr>, period <int>, clock <chr>,
#> #   clock_seconds <dbl>, home_score <int>, away_score <int>,
#> #   scoring_play <lgl>, score_value <int>, priority <lgl>, is_penalty <lgl>,
#> #   is_turnover <lgl>, stat_yardage <int>, scoring_type_name <chr>,
#> #   scoring_type_display_name <chr>, scoring_type_abbreviation <chr>,
#> #   point_after_attempt_id <int>, point_after_attempt_text <chr>, …
# }
```
