# **ESPN College Football Game Team Roster**

Get the game-day roster for both teams in a single college football
game, including each player's jersey number, starter flag, and
active/did-not-play status.

## Usage

``` r
espn_cfb_game_team_roster(
  game_id = NULL,
  position_detail = TRUE,
  team_detail = TRUE
)
```

## Arguments

- game_id:

  (*Integer* required): ESPN game identifier.

- position_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN position catalog
  once and join it onto `position_id`, appending the five `position_*`
  detail columns shown in the *Value* table. A catalog failure degrades
  to `NA` rather than erroring the wrapper. Set `FALSE` to skip the
  extra fetch and return the original column set.

- team_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN team catalog
  ([`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md))
  once and join friendly team fields next to the `team_id` column –
  `team_name`, `team_abbreviation`, `team_location`,
  `team_display_name`, `team_short_display_name`, `team_nickname`,
  `team_color`, `team_alternate_color`, `team_logo_href`, and
  `team_logo_dark_href`, inserted immediately after `team_id`. A catalog
  failure degrades to `NA` rather than erroring the wrapper. Set `FALSE`
  to skip the catalog fetch and the join.

## Value

A data frame with one row per rostered player:

|  |  |  |
|----|----|----|
| col_name | types | description |
| game_id | character | ESPN game identifier. |
| team_id | character | ESPN team id for the team. |
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
| home_away | character | `home` or `away`. |
| athlete_id | character | ESPN athlete id (parsed from `athlete_ref`). |
| player_id | character | ESPN player id from the roster entry. |
| display_name | character | Player display name as shown by ESPN. |
| jersey | character | Jersey number. |
| position_id | character | ESPN position id (parsed from `position_ref`). |
| period | integer | Period the player entered the game (0 if none). |
| starter | logical | `TRUE` if the player started the game. |
| active | logical | `TRUE` if the player was active for the game. |
| did_not_play | logical | `TRUE` if the player did not play. |
| valid | logical | `TRUE` if the roster entry is flagged valid by ESPN. |
| athlete_ref | character | `$ref` URL to the athlete-in-season resource. |
| position_ref | character | `$ref` URL to the position resource. |
| position_name | character | Position name (e.g. `Quarterback`); `position_detail = TRUE` only. |
| position_display_name | character | Human-readable position name; `position_detail = TRUE` only. |
| position_abbreviation | character | Position abbreviation (e.g. `QB`); `position_detail = TRUE` only. |
| position_leaf | logical | `TRUE` for a most-specific (leaf) position; `position_detail = TRUE` only. |
| position_parent_id | character | ESPN id of the parent position; `position_detail = TRUE` only. |

## Details

Wraps the ESPN core-v2 endpoint
`events/{game_id}/competitions/{game_id}/competitors/{team_id}/roster`.
This wrapper reads the teams list for the game and fetches the roster
resource for **both** teams, stacking the `entries` arrays into one long
frame – one row per (team x rostered player). `home_away` identifies
which team a row belongs to. Players are returned as ESPN athlete ids;
join to another athlete source for names.

When `position_detail = TRUE` (the default) the ESPN position catalog
([`espn_cfb_positions()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_positions.md))
is fetched once and joined onto `position_id`, so the output carries the
full position name / abbreviation rather than the bare id (see
*Details*).

When `position_detail = TRUE` (the default), five columns are appended
by joining the ESPN position catalog
([`espn_cfb_positions()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_positions.md))
on `position_id`: `position_name`, `position_display_name`,
`position_abbreviation`, `position_leaf`, and `position_parent_id`. The
catalog is fetched once per call. A roster entry whose `position_id` is
missing or unmatched receives `NA` for all five, and a catalog-fetch
failure degrades the whole set to `NA` rather than erroring the wrapper.
With `position_detail = FALSE` the five columns are omitted and the
original roster schema is returned unchanged.

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
  try(espn_cfb_game_team_roster(game_id = 401628339))
#> ── Game team roster data from ESPN ────────────────────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-08-29 13:14:28 UTC
#> # A tibble: 242 × 30
#>    game_id   team_id team_name team_abbreviation team_location team_display_name
#>    <chr>     <chr>   <chr>     <chr>             <chr>         <chr>            
#>  1 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  2 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  3 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  4 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  5 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  6 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  7 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  8 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  9 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#> 10 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#> # ℹ 232 more rows
#> # ℹ 24 more variables: team_short_display_name <chr>, team_nickname <chr>,
#> #   team_color <chr>, team_alternate_color <chr>, team_logo_href <chr>,
#> #   team_logo_dark_href <chr>, home_away <chr>, athlete_id <chr>,
#> #   player_id <chr>, display_name <chr>, jersey <chr>, position_id <chr>,
#> #   period <int>, starter <lgl>, active <lgl>, did_not_play <lgl>, valid <lgl>,
#> #   athlete_ref <chr>, position_ref <chr>, position_name <chr>, …
  try(espn_cfb_game_team_roster(game_id = 401628339,
                                position_detail = FALSE))
#> ── Game team roster data from ESPN ────────────────────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-08-29 13:14:28 UTC
#> # A tibble: 242 × 25
#>    game_id   team_id team_name team_abbreviation team_location team_display_name
#>    <chr>     <chr>   <chr>     <chr>             <chr>         <chr>            
#>  1 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  2 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  3 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  4 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  5 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  6 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  7 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  8 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  9 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#> 10 401628339 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#> # ℹ 232 more rows
#> # ℹ 19 more variables: team_short_display_name <chr>, team_nickname <chr>,
#> #   team_color <chr>, team_alternate_color <chr>, team_logo_href <chr>,
#> #   team_logo_dark_href <chr>, home_away <chr>, athlete_id <chr>,
#> #   player_id <chr>, display_name <chr>, jersey <chr>, position_id <chr>,
#> #   period <int>, starter <lgl>, active <lgl>, did_not_play <lgl>, valid <lgl>,
#> #   athlete_ref <chr>, position_ref <chr>
  try(espn_cfb_game_team_roster(game_id = 401628339,
                                team_detail = FALSE))
#> ── Game team roster data from ESPN ────────────────────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-08-29 13:14:28 UTC
#> # A tibble: 242 × 20
#>    game_id   team_id home_away athlete_id player_id display_name  jersey
#>    <chr>     <chr>   <chr>     <chr>      <chr>     <chr>         <chr> 
#>  1 401628339 61      home      4369935    4369935   I. Reeves     37    
#>  2 401628339 61      home      4427080    4427080   X. Truss      73    
#>  3 401628339 61      home      4429035    4429035   T. Ratledge   69    
#>  4 401628339 61      home      4429105    4429105   A. Smith      11    
#>  5 401628339 61      home      4429136    4429136   W. Brinson    97    
#>  6 401628339 61      home      4429142    4429142   N. Stackhouse 78    
#>  7 401628339 61      home      4429736    4429736   C. Ham        95    
#>  8 401628339 61      home      4430841    4430841   C. Beck       15    
#>  9 401628339 61      home      4431520    4431520   C. Chambliss  32    
#> 10 401628339 61      home      4431573    4431573   S. Mondon Jr. 2     
#> # ℹ 232 more rows
#> # ℹ 13 more variables: position_id <chr>, period <int>, starter <lgl>,
#> #   active <lgl>, did_not_play <lgl>, valid <lgl>, athlete_ref <chr>,
#> #   position_ref <chr>, position_name <chr>, position_display_name <chr>,
#> #   position_abbreviation <chr>, position_leaf <lgl>, position_parent_id <chr>
# }
```
