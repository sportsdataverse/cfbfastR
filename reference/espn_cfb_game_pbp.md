# **ESPN College Football Game Plays (Core-v2 Play-by-Play, Drive Plays and Single Play)**

`espn_cfb_game_pbp()` gets the full core-v2 play-by-play feed for a
single college football game – one row per play, with down/distance,
clock, score, and yardage. `espn_cfb_game_drive_plays()` gets the same
plays for a single drive, and `espn_cfb_game_play()` gets the full
detail object for a single play – one row with the play type, text,
score, clock, down/distance, and win-probability delta.

## Usage

``` r
espn_cfb_game_pbp(
  game_id = NULL,
  participants = c("none", "wide", "long"),
  participants_list = FALSE,
  team_participants = c("none", "wide"),
  team_participants_list = FALSE,
  team_detail = TRUE
)

espn_cfb_game_drive_plays(
  game_id = NULL,
  drive_id = NULL,
  participants = c("none", "wide", "long"),
  participants_list = FALSE,
  team_participants = c("none", "wide"),
  team_participants_list = FALSE,
  team_detail = TRUE
)

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

- drive_id:

  (*Integer* required): ESPN drive id (from
  [`espn_cfb_game_drives()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_drives.md)).

- play_id:

  (*Character* required): ESPN play id (from `espn_cfb_game_pbp()`).
  Supply as a character string – the id is too large for an exact
  numeric.

## Value

A data frame with one row per play (one row in all for
`espn_cfb_game_play()`):

|  |  |  |
|----|----|----|
| col_name | types | description |
| game_id | character | ESPN game identifier. |
| drive_id | character | ESPN drive id; `espn_cfb_game_drive_plays()` only. |
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

Wraps the paginated ESPN core-v2 endpoint
`events/{game_id}/competitions/{game_id}/plays`. The endpoint is
paginated; this wrapper loops every page and stacks the results into one
frame – one row per play. Each play carries the start and end
down/distance/yard-line, the play type, period and game clock, the
running score, and the offensive team.

This is the core-v2 play feed, distinct from
[`espn_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp.md),
which parses the site-v2 game-summary feed and (optionally) computes
EPA/WPA. Use this wrapper when you want the raw core-v2 play schema with
stable `$ref`-derived ids; use
[`espn_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp.md)
for the modeled play-by-play.

`espn_cfb_game_drive_plays()` wraps
`events/{game_id}/competitions/{game_id}/drives/{drive_id}/plays`. The
competition id always equals the game id. It returns the same play
schema as `espn_cfb_game_pbp()`, plus `drive_id`, partitioned to a
single drive (typically 5-11 plays). Harvest the `drive_id` from
[`espn_cfb_game_drives()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_drives.md)
– its `drive_id` column lists every drive in the game.

`espn_cfb_game_play()` wraps
`events/{game_id}/competitions/{game_id}/plays/{play_id}` and returns a
single-row data frame describing one play in full. Harvest the `play_id`
from the `play_id` column of `espn_cfb_game_pbp()` or
`espn_cfb_game_drive_plays()`. Use it for play drill-down when you need
a single play's complete object rather than the whole game feed. ESPN
play ids are 18-digit integers that exceed R's exact double-precision
range – **pass `play_id` as a character string** (e.g.
`"401628339101927401"`) so no precision is lost. A bare numeric literal
will be silently rounded and the lookup will 404.

When `participants = "wide"`, the base play schema is kept intact and
six columns are appended for every participant `type` that appears
anywhere in the returned plays. The column names are **dynamic** – one
set per participant type present (e.g. `passer`, `rusher`, `receiver`,
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
`teamParticipants[]` `type` present anywhere in the returned plays (ESPN
ships `offense` / `defense`). The column names are **dynamic** – one set
per type, snake-cased: `{type}_team_id` (scalar character, the first
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

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_game_pbp(game_id = 401628339))
#> ── Game plays data from ESPN ───────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 18:42:28 UTC
#> # A tibble: 157 × 84
#>    game_id   play_id   sequence_number type_id type_text type_abbreviation text 
#>    <chr>     <chr>     <chr>           <chr>   <chr>     <chr>             <chr>
#>  1 401628339 40162833… 101849903       70      Coin Toss NA                Geor…
#>  2 401628339 40162833… 101849905       53      Kickoff   K                 Peyt…
#>  3 401628339 40162833… 101849908       24      Pass Rec… REC               Jord…
#>  4 401628339 40162833… 101857801       5       Rush      RUSH              Jale…
#>  5 401628339 40162833… 101866801       21      Timeout   TO                Time…
#>  6 401628339 40162833… 101866802       5       Rush      RUSH              Jale…
#>  7 401628339 40162833… 101875001       52      Punt      PUNT              Spen…
#>  8 401628339 40162833… 101877201       67      Passing … TD                Cars…
#>  9 401628339 40162833… 101877203       53      Kickoff   K                 Peyt…
#> 10 401628339 40162833… 101877501       5       Rush      RUSH              Jord…
#> # ℹ 147 more rows
#> # ℹ 77 more variables: short_text <chr>, alternative_text <chr>,
#> #   short_alternative_text <chr>, period <int>, clock <chr>,
#> #   clock_seconds <dbl>, home_score <int>, away_score <int>,
#> #   scoring_play <lgl>, score_value <int>, priority <lgl>, is_penalty <lgl>,
#> #   is_turnover <lgl>, stat_yardage <int>, scoring_type_name <chr>,
#> #   scoring_type_display_name <chr>, scoring_type_abbreviation <chr>, …
# }
if (FALSE) { # interactive()
# Adds the game roster and ESPN's position catalog, one request per
# position (about 75), so this takes several seconds.
try(espn_cfb_game_pbp(game_id = 401628339, participants = "wide",
                      participants_list = TRUE))
}
# \donttest{
  try(espn_cfb_game_drive_plays(game_id = 401628339,
                                drive_id = 4016283391))
#> ── Game drive plays data from ESPN ─────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 18:42:28 UTC
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
# }
# \donttest{
  try(espn_cfb_game_play(game_id = 401628339,
                         play_id = "401628339101927401"))
#> ── Game play data from ESPN ────────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 18:42:28 UTC
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
# }
```
