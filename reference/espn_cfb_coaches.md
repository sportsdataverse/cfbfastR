# **ESPN College Football Coaches Index**

Get every head coach ESPN tracks for a college football season, with
their name, ESPN ids, and the team they coached that year.

## Usage

``` r
espn_cfb_coaches(year = NULL, team_detail = TRUE)
```

## Arguments

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 2001

- team_detail:

  (*Logical*): when `TRUE` (default), the ESPN team catalog
  ([`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md))
  is fetched once and friendly team fields are joined in next to the
  `team_id` column. The sibling columns `team_name`,
  `team_abbreviation`, `team_location`, `team_display_name`,
  `team_short_display_name`, `team_nickname`, `team_color`,
  `team_alternate_color`, `team_logo_href`, `team_logo_dark_href` are
  inserted immediately after `team_id`. A catalog failure degrades to
  `NA` rather than erroring the wrapper. Set `FALSE` to skip the catalog
  fetch and the join, reproducing the prior output exactly.

## Value

A data frame with one row per coach:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Season (4-digit year). |
| coach_id | character | ESPN coach id. |
| first_name | character | Coach first name. |
| last_name | character | Coach last name. |
| team_id | character | ESPN id of the team coached that season (parsed from `team_ref`). |
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
| coach_ref | character | `$ref` URL to the season-scoped coach resource. |
| person_ref | character | `$ref` URL to the league-wide coach (person) resource. |
| team_ref | character | `$ref` URL to the per-season team resource. |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/coaches`.
The index is `$ref`-paginated (~268 coaches across three pages); this
wrapper walks every page and dereferences each coach `$ref`, returning
one row per coach. The `coach_id` column is the value
[`espn_cfb_coach()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_coach.md)
accepts for the full per-coach detail (date of birth, birthplace,
career-record / coach-season counts).

## See also

Other ESPN CFB Functions:
[`espn_cfb_award()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_award.md),
[`espn_cfb_awards()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_awards.md),
[`espn_cfb_clear_cache()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_clear_cache.md),
[`espn_cfb_coach()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_coach.md),
[`espn_cfb_coach_record()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_coach_record.md),
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
  try(espn_cfb_coaches(year = 2024))
#> ── Coaches index from ESPN ─────────────────────────────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-24 14:46:12 UTC
#> # A tibble: 266 × 18
#>    season coach_id first_name last_name   team_id team_name  team_abbreviation
#>     <int> <chr>    <chr>      <chr>       <chr>   <chr>      <chr>            
#>  1   2024 5120149  Alex       Golesh      58      Bulls      USF              
#>  2   2024 162030   Alex       Mortensen   NA      NA         NA               
#>  3   2024 4606657  Ryan       Silverfield 235     Tigers     MEM              
#>  4   2024 5119667  Kenny      Dillingham  9       Sun Devils ASU              
#>  5   2024 4077317  Brent      Brennan     12      Wildcats   ARIZ             
#>  6   2024 5218798  Tim        Skipper     278     Bulldogs   FRES             
#>  7   2024 5345545  Alonzo     Carter      NA      NA         NA               
#>  8   2024 156919   Sean       Lewis       21      Aztecs     SDSU             
#>  9   2024 559953   Ken        Niumatalolo 23      Spartans   SJSU             
#> 10   2024 176295   Tavita     Pritchard   NA      NA         NA               
#> # ℹ 256 more rows
#> # ℹ 11 more variables: team_location <chr>, team_display_name <chr>,
#> #   team_short_display_name <chr>, team_nickname <chr>, team_color <chr>,
#> #   team_alternate_color <chr>, team_logo_href <chr>,
#> #   team_logo_dark_href <chr>, coach_ref <chr>, person_ref <chr>,
#> #   team_ref <chr>
  try(espn_cfb_coaches(year = 2024, team_detail = FALSE))
#> ── Coaches index from ESPN ─────────────────────────────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-24 14:46:20 UTC
#> # A tibble: 266 × 8
#>    season coach_id first_name last_name   team_id coach_ref  person_ref team_ref
#>     <int> <chr>    <chr>      <chr>       <chr>   <chr>      <chr>      <chr>   
#>  1   2024 5120149  Alex       Golesh      58      http://sp… http://sp… http://…
#>  2   2024 162030   Alex       Mortensen   NA      http://sp… http://sp… NA      
#>  3   2024 4606657  Ryan       Silverfield 235     http://sp… http://sp… http://…
#>  4   2024 5119667  Kenny      Dillingham  9       http://sp… http://sp… http://…
#>  5   2024 4077317  Brent      Brennan     12      http://sp… http://sp… http://…
#>  6   2024 5218798  Tim        Skipper     278     http://sp… http://sp… http://…
#>  7   2024 5345545  Alonzo     Carter      NA      http://sp… http://sp… NA      
#>  8   2024 156919   Sean       Lewis       21      http://sp… http://sp… http://…
#>  9   2024 559953   Ken        Niumatalolo 23      http://sp… http://sp… http://…
#> 10   2024 176295   Tavita     Pritchard   NA      http://sp… http://sp… NA      
#> # ℹ 256 more rows
# }
```
