# **ESPN College Football Team Endpoint Overview**

- `espn_cfb_team()`: Get ESPN's detailed record for a single college
  football team in a given season – identifiers, branding, conference
  grouping, and home venue.

- [`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md):
  Get the full ESPN directory of college football teams – one row per
  team with identifiers, branding, conference grouping, and logo URLs.

- [`espn_cfb_team_ats()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_ats.md):
  Get a college football team's against-the-spread (ATS) records for a
  season – the 6-7 betting split rows ESPN tracks (overall, as favorite,
  as underdog, home, away, ...).

- [`espn_cfb_team_awards()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_awards.md):
  Get the awards won by a college football team's players in a season –
  one row per (award x winning athlete).

- [`espn_cfb_team_coaches()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_coaches.md):
  Get the coaches associated with a college football team for a season –
  one row per coach, with name, birth detail, and experience.

- [`espn_cfb_team_events()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_events.md):
  Get a college football team's full season event log – every game
  (regular season and postseason) ESPN lists for the team-season.

- [`espn_cfb_team_leaders()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_leaders.md):
  Get a college football team's season statistical leaders – the top
  athletes in each ESPN leader category (passing, rushing, receiving,
  tackles, ...).

- [`espn_cfb_team_powerindex()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_powerindex.md):
  Get ESPN's College Football Power Index (FPI) detail for a single
  team-season – the full set of predictive metrics and efficiency
  components ESPN attaches to one team.

- [`espn_cfb_team_ranks()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_ranks.md):
  Get a college football team's poll-rank history for a season – one row
  per poll (AP, Coaches, CFP Committee, ...) the team appeared in.

- [`espn_cfb_team_record()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_record.md):
  Get a college football team's season records – overall, home, away,
  and conference splits – with the full set of summary stats ESPN
  attaches to each.

- [`espn_cfb_team_roster()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_roster.md):
  Get the season roster for a single college football team – one row per
  athlete with biographical detail, position, jersey number, and
  class/experience.

- [`espn_cfb_team_schedule()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_schedule.md):
  Get a single college football team's full-season schedule – one row
  per game with opponent, venue, broadcast, score, and result.

- [`espn_cfb_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_stats.md):
  Get ESPN college football team season statistics – a wide tibble of
  team identifiers and per-category statistical totals.

Get ESPN's detailed record for a single college football team in a given
season – identifiers, branding, conference grouping, and home venue.

## Usage

``` r
espn_cfb_team(team_id = NULL, year = NULL, team_detail = TRUE)
```

## Arguments

- team_id:

  (*Integer* required): ESPN team id.

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 1869

- team_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN team catalog once
  and join friendly team fields next to the `team_id` column (see
  *Details*). Set `FALSE` to skip the catalog fetch and the join.

## Value

A one-row data frame:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Season (4-digit year). |
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
| guid | character | ESPN team GUID. |
| uid | character | ESPN global unique identifier. |
| slug | character | URL slug for the team. |
| abbreviation | character | Team abbreviation. |
| display_name | character | Full team display name. |
| short_display_name | character | Short team display name. |
| name | character | Team nickname (e.g. `Bulldogs`). |
| nickname | character | Team nickname / location label. |
| location | character | Team location / school name. |
| color | character | Primary team color (hex, no `#`). |
| alternate_color | character | Alternate team color (hex, no `#`). |
| is_active | logical | Whether the team is currently active. |
| is_all_star | logical | Whether the team is an all-star team. |
| group_id | character | ESPN group (conference) id for the season. |
| venue_id | character | ESPN id of the team's home venue. |
| venue_name | character | Name of the team's home venue. |
| venue_city | character | Home venue city. |
| venue_state | character | Home venue state. |
| venue_indoor | logical | Whether the home venue is indoors. |
| venue_grass | logical | Whether the home venue has a grass surface. |

## Details

### **ESPN College Football Team Detail (Season-Scoped)**

    espn_cfb_team(team_id = 61, year = 2024)

### **ESPN College Football Teams Index**

    espn_cfb_teams()

### **ESPN College Football Team Against-the-Spread Records**

    espn_cfb_team_ats(team_id = 61, year = 2024)

### **ESPN College Football Team Awards**

    espn_cfb_team_awards(team_id = 61, year = 2023)

### **ESPN College Football Team Coaches**

    espn_cfb_team_coaches(team_id = 61, year = 2024)

### **ESPN College Football Team Season Event Log**

    espn_cfb_team_events(team_id = 61, year = 2024)

### **ESPN College Football Team Statistical Leaders**

    espn_cfb_team_leaders(team_id = 61, year = 2024)

### **ESPN College Football Single-Team Power Index (Long Format)**

    espn_cfb_team_powerindex(team_id = 61, year = 2024)

### **ESPN College Football Team Poll Rank History**

    espn_cfb_team_ranks(team_id = 61, year = 2024)

### **ESPN College Football Team Record (Long Format)**

    espn_cfb_team_record(team_id = 61, year = 2024)

### **ESPN College Football Team Roster (Season-Scoped)**

    espn_cfb_team_roster(team_id = 61, year = 2024)

### **ESPN College Football Team Schedule**

    espn_cfb_team_schedule(team_id = 61, year = 2024)

### **Get ESPN college football team stats data**

    espn_cfb_team_stats(team_id = 52, year = 2020)

Wraps the ESPN core-v2 team-in-season endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/teams/{team_id}`.
Unlike the site-v2 team payload, the core-v2 resource is season-scoped,
so a team's conference grouping is resolved for the requested `year`.
The result is a single-row data frame. Team ids are ESPN team
identifiers – enumerate them with
[`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md).

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
  try(espn_cfb_team(team_id = 61, year = 2024))
#> ── Team detail from ESPN ───────────────────────────────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-27 20:30:12 UTC
#> # A tibble: 1 × 32
#>   season team_id team_name team_abbreviation team_location team_display_name
#>    <int> <chr>   <chr>     <chr>             <chr>         <chr>            
#> 1   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#> # ℹ 26 more variables: team_short_display_name <chr>, team_nickname <chr>,
#> #   team_color <chr>, team_alternate_color <chr>, team_logo_href <chr>,
#> #   team_logo_dark_href <chr>, guid <chr>, uid <chr>, slug <chr>,
#> #   abbreviation <chr>, display_name <chr>, short_display_name <chr>,
#> #   name <chr>, nickname <chr>, location <chr>, color <chr>,
#> #   alternate_color <chr>, is_active <lgl>, is_all_star <lgl>, group_id <chr>,
#> #   venue_id <chr>, venue_name <chr>, venue_city <chr>, venue_state <chr>, …
  try(espn_cfb_team(team_id = 61, year = 2024, team_detail = FALSE))
#> ── Team detail from ESPN ───────────────────────────────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-27 20:30:12 UTC
#> # A tibble: 1 × 22
#>   season team_id guid   uid   slug  abbreviation display_name short_display_name
#>    <int> <chr>   <chr>  <chr> <chr> <chr>        <chr>        <chr>             
#> 1   2024 61      4351f… s:20… geor… UGA          Georgia Bul… Georgia           
#> # ℹ 14 more variables: name <chr>, nickname <chr>, location <chr>, color <chr>,
#> #   alternate_color <chr>, is_active <lgl>, is_all_star <lgl>, group_id <chr>,
#> #   venue_id <chr>, venue_name <chr>, venue_city <chr>, venue_state <chr>,
#> #   venue_indoor <lgl>, venue_grass <lgl>
# }
```
