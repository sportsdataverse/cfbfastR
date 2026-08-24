# **ESPN College Football Player Endpoint Overview**

- `espn_cfb_player()`: Get the full ESPN record for a single college
  football player in a given season – bio, measurements, position, team,
  status, and `$ref` URLs to nested resources.

- [`espn_cfb_players()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_players.md):
  Get a paginated index of ESPN college football players for a season
  (id + `$ref` rows; dereference with `espn_cfb_player()`).

- [`espn_cfb_player_eventlog()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_eventlog.md):
  Get the per-game event log for a single college football player in a
  season – one row per game, with `$ref` URLs to each game's event,
  competition, and per-game statistics.

- [`espn_cfb_player_gamelog()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_gamelog.md):
  Get a single college football player's game-by-game statistical log
  for a season – stat line joined to opponent, score, and result
  metadata.

- [`espn_cfb_player_overview()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_overview.md):
  Get the season-by-season statistics overview ESPN shows on a college
  football player's page – one row per season, with the headline stat
  line for each.

- [`espn_cfb_player_seasons()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_seasons.md):
  Get the list of seasons a single college football player has a
  statistical record for on ESPN, with `$ref` URLs to each season's
  statistics.

- [`espn_cfb_player_splits()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_splits.md):
  Get a single college football player's statistical splits for a season
  – stat lines broken out by month, quarter, down, field position, and
  more.

- [`espn_cfb_player_career_stats()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_career_stats.md):
  Get a single college football player's full season statistics from
  ESPN – every published stat across every category, in long format (one
  row per stat).

- [`espn_cfb_player_stats()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_stats.md):
  Get ESPN college football player season stats (legacy wide-format
  wrapper covering all categories and athlete / team detail columns).

- [`espn_cfb_recruits()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_recruits.md):
  Get the ESPN recruiting-class catalog for a college football signing
  class – one row per recruit, with identity, position, measurements,
  grade, rankings, and committed school.

Get the full ESPN record for a single college football player in a given
season – biographical fields, physical measurements, position, team,
status, and the `$ref` URLs to the player's nested resources
(statistics, event log, college).

## Usage

``` r
espn_cfb_player(
  athlete_id = NULL,
  year = NULL,
  team_detail = TRUE,
  position_detail = TRUE
)
```

## Arguments

- athlete_id:

  (*Character/Integer* required): ESPN athlete id.

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 2004

- team_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN team catalog once
  and join friendly team fields next to the `team_id` column (see
  *Details*). Set `FALSE` to skip the catalog fetch and the join.

- position_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN position catalog
  once and join it onto `position_id`, appending the
  `position_display_name` / `position_leaf` / `position_parent_id`
  detail columns. A catalog failure degrades to `NA` rather than
  erroring the wrapper. Set `FALSE` to skip the extra fetch and the
  join.

## Value

A one-row data frame describing the player:

|  |  |  |
|----|----|----|
| col_name | types | description |
| athlete_id | character | ESPN athlete id. |
| season | integer | Season (4-digit year). |
| uid | character | ESPN athlete UID. |
| guid | character | ESPN athlete GUID. |
| first_name | character | Player first name. |
| last_name | character | Player last name. |
| full_name | character | Player full name. |
| display_name | character | Player display name. |
| short_name | character | Player short name. |
| weight | numeric | Listed weight (lbs). |
| display_weight | character | Display-formatted weight. |
| height | numeric | Listed height (inches). |
| display_height | character | Display-formatted height. |
| jersey | character | Jersey number. |
| slug | character | ESPN athlete URL slug. |
| active | logical | Whether the player is currently active. |
| date_of_birth | character | Player date of birth (if published). |
| birth_city | character | Birthplace city. |
| birth_state | character | Birthplace state. |
| birth_country | character | Birthplace country. |
| position_id | character | ESPN position id. |
| position_name | character | Position name. |
| position_abbreviation | character | Position abbreviation. |
| position_display_name | character | Human-readable position name; `position_detail = TRUE` only. |
| position_leaf | logical | `TRUE` for a most-specific (leaf) position; `position_detail = TRUE` only. |
| position_parent_id | character | ESPN id of the parent position; `position_detail = TRUE` only. |
| experience_years | integer | Years of experience. |
| status_id | character | ESPN status id. |
| status_name | character | Status name (e.g. `Active`). |
| status_type | character | Status type. |
| headshot_href | character | URL of the player headshot image. |
| team_id | character | ESPN team id for the season (from `team_ref`). |
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
| team_ref | character | `$ref` URL to the team-in-season resource. |
| statistics_ref | character | `$ref` URL to the player statistics resource. |
| eventlog_ref | character | `$ref` URL to the player event log resource. |
| college_ref | character | `$ref` URL to the player college resource. |

## Details

### **ESPN College Football Player Detail**

    espn_cfb_player(athlete_id = 102597, year = 2024)

### **ESPN College Football Players Index**

    espn_cfb_players(year = 2024, page = 1, max_pages = 1)

### **ESPN College Football Player Event Log**

    espn_cfb_player_eventlog(athlete_id = 102597, year = 2024)

### **ESPN College Football Player Game Log**

    espn_cfb_player_gamelog(athlete_id = 102597, year = 2024)

### **ESPN College Football Player Statistics Overview**

    espn_cfb_player_overview(athlete_id = 102597, year = 2024)

### **ESPN College Football Player Seasons**

    espn_cfb_player_seasons(athlete_id = 102597)

### **ESPN College Football Player Statistical Splits**

    espn_cfb_player_splits(athlete_id = 102597, year = 2024)

### **ESPN College Football Player Season Statistics (Long Format)**

    espn_cfb_player_career_stats(athlete_id = 102597, year = 2024)

### **Get ESPN college football player stats data**

    espn_cfb_player_stats(athlete_id = 530308, year = 2013)

### **ESPN College Football Recruits**

    espn_cfb_recruits(year = 2024, max_results = 25)

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/athletes/{athlete_id}`.
The season-scoped path is used so the returned `team_id` reflects the
team the player was on *that* season. The wrapper returns a single-row
tibble: scalar bio fields are flattened inline, nested objects
(`position`, `status`, `birthPlace`, `experience`) are flattened with a
prefix, and the nested `$ref` URLs are surfaced as `*_ref` columns
rather than auto-dereferenced. Harvest athlete ids from
[`espn_cfb_players()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_players.md).

When `team_detail = TRUE` (the default) the ESPN team catalog
([`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md))
is fetched once and friendly team fields are joined in next to the
`team_id` column – `team_name`, `team_abbreviation`, `team_location`,
`team_display_name`, `team_short_display_name`, `team_nickname`,
`team_color`, `team_alternate_color`, `team_logo_href`, and
`team_logo_dark_href`, inserted immediately after `team_id`. A catalog
failure degrades to `NA` rather than erroring the wrapper. Set
`team_detail = FALSE` to skip the catalog fetch and the join.

When `position_detail = TRUE` (the default) the ESPN position catalog
([`espn_cfb_positions()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_positions.md))
is fetched once and joined onto `position_id`, appending
`position_display_name`, `position_leaf`, and `position_parent_id` (the
existing `position_name` / `position_abbreviation` columns are left in
place). A catalog failure degrades to `NA` rather than erroring the
wrapper. Set `position_detail = FALSE` to skip the catalog fetch and the
join.

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
  try(espn_cfb_player(athlete_id = 102597, year = 2024))
#> ── Player detail from ESPN ─────────────────────────────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-24 13:31:35 UTC
#> # A tibble: 1 × 46
#>   athlete_id season uid        guid  first_name last_name full_name display_name
#>   <chr>       <int> <chr>      <chr> <chr>      <chr>     <chr>     <chr>       
#> 1 102597       2024 s:20~l:23… b084… Will       Rogers    Will Rog… Will Rogers 
#> # ℹ 38 more variables: short_name <chr>, weight <dbl>, display_weight <chr>,
#> #   height <dbl>, display_height <chr>, jersey <chr>, slug <chr>, active <lgl>,
#> #   date_of_birth <chr>, birth_city <chr>, birth_state <chr>,
#> #   birth_country <chr>, position_id <chr>, position_name <chr>,
#> #   position_abbreviation <chr>, experience_years <int>, status_id <chr>,
#> #   status_name <chr>, status_type <chr>, headshot_href <chr>, team_id <chr>,
#> #   team_name <chr>, team_abbreviation <chr>, team_location <chr>, …
  try(espn_cfb_player(athlete_id = 102597, year = 2024,
                      team_detail = FALSE, position_detail = FALSE))
#> ── Player detail from ESPN ─────────────────────────────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-24 13:31:35 UTC
#> # A tibble: 1 × 33
#>   athlete_id season uid        guid  first_name last_name full_name display_name
#>   <chr>       <int> <chr>      <chr> <chr>      <chr>     <chr>     <chr>       
#> 1 102597       2024 s:20~l:23… b084… Will       Rogers    Will Rog… Will Rogers 
#> # ℹ 25 more variables: short_name <chr>, weight <dbl>, display_weight <chr>,
#> #   height <dbl>, display_height <chr>, jersey <chr>, slug <chr>, active <lgl>,
#> #   date_of_birth <chr>, birth_city <chr>, birth_state <chr>,
#> #   birth_country <chr>, position_id <chr>, position_name <chr>,
#> #   position_abbreviation <chr>, experience_years <int>, status_id <chr>,
#> #   status_name <chr>, status_type <chr>, headshot_href <chr>, team_id <chr>,
#> #   team_ref <chr>, statistics_ref <chr>, eventlog_ref <chr>, …
# }
```
