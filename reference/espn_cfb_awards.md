# **ESPN College Football Awards**

Get ESPN's college football awards for a season – the Heisman, position
and player-of-the-year honors, and the athlete (and team) that won each.

## Usage

``` r
espn_cfb_awards(year = NULL, team_detail = TRUE)
```

## Arguments

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).

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

A data frame with one row per award-winner:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Season (4-digit year). |
| award_id | character | ESPN award id. |
| name | character | Award name (e.g. `Heisman Trophy`). |
| description | character | ESPN's description of the award. |
| athlete_id | character | ESPN id of the winning athlete (parsed from `athlete_ref`); `NA` if none. |
| team_id | character | ESPN id of the winner's team (parsed from `team_ref`); `NA` if none. |
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
| award_ref | character | `$ref` URL to the award resource. |
| athlete_ref | character | `$ref` URL to the winning athlete resource (may be `NA`). |
| team_ref | character | `$ref` URL to the winner's team resource (may be `NA`). |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/awards`.
The index returns one `$ref` per award (~32); this wrapper dereferences
each and returns one row per (award x winner). Most awards have a single
winner, so the table is roughly one row per award. Winners are returned
as ESPN athlete ids (and team ids) only – join to an athlete source for
names. An award with no winner recorded yet still contributes one row
with `athlete_id`/`team_id` left `NA`.

## See also

Other ESPN CFB Functions:
[`espn_cfb_award()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_award.md),
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
  try(espn_cfb_awards(year = 2024))
#> ── Awards data from ESPN ───────────────────────────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-06-13 04:20:22 UTC
#> # A tibble: 34 × 19
#>    season award_id name                 description athlete_id team_id team_name
#>     <int> <chr>    <chr>                <chr>       <chr>      <chr>   <chr>    
#>  1   2024 1        Buck Buchanan Award  I-AA Defen… 5085355    2110    Bears    
#>  2   2024 2        Chuck Bednarik Award Defensive … 4685415    38      Buffaloes
#>  3   2024 3        Davey O'Brien Award  National Q… 4688380    2390    Hurrican…
#>  4   2024 4        Dick Butkus Award    Outstandin… 4685597    61      Bulldogs 
#>  5   2024 5        Doak Walker Award    National R… 4890973    68      Broncos  
#>  6   2024 6        Fred Biletnikoff Aw… Outstandin… 4685415    38      Buffaloes
#>  7   2024 7        Gagliardi Trophy     NCAA Divis… 4911584    3071    Cardinals
#>  8   2024 8        Harlon Hill Trophy   NCAA Divis… 4572712    2118    Mules    
#>  9   2024 9        Heisman Memorial Tr… Outstandin… 4685415    38      Buffaloes
#> 10   2024 10       Jim Thorpe Award     Outstandin… 4430925    251     Longhorns
#> # ℹ 24 more rows
#> # ℹ 12 more variables: team_abbreviation <chr>, team_location <chr>,
#> #   team_display_name <chr>, team_short_display_name <chr>,
#> #   team_nickname <chr>, team_color <chr>, team_alternate_color <chr>,
#> #   team_logo_href <chr>, team_logo_dark_href <chr>, award_ref <chr>,
#> #   athlete_ref <chr>, team_ref <chr>
  try(espn_cfb_awards(year = 2024, team_detail = FALSE))
#> ── Awards data from ESPN ───────────────────────────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-06-13 04:20:24 UTC
#> # A tibble: 34 × 9
#>    season award_id name     description athlete_id team_id award_ref athlete_ref
#>     <int> <chr>    <chr>    <chr>       <chr>      <chr>   <chr>     <chr>      
#>  1   2024 1        Buck Bu… I-AA Defen… 5085355    2110    http://s… http://spo…
#>  2   2024 2        Chuck B… Defensive … 4685415    38      http://s… http://spo…
#>  3   2024 3        Davey O… National Q… 4688380    2390    http://s… http://spo…
#>  4   2024 4        Dick Bu… Outstandin… 4685597    61      http://s… http://spo…
#>  5   2024 5        Doak Wa… National R… 4890973    68      http://s… http://spo…
#>  6   2024 6        Fred Bi… Outstandin… 4685415    38      http://s… http://spo…
#>  7   2024 7        Gagliar… NCAA Divis… 4911584    3071    http://s… http://spo…
#>  8   2024 8        Harlon … NCAA Divis… 4572712    2118    http://s… http://spo…
#>  9   2024 9        Heisman… Outstandin… 4685415    38      http://s… http://spo…
#> 10   2024 10       Jim Tho… Outstandin… 4430925    251     http://s… http://spo…
#> # ℹ 24 more rows
#> # ℹ 1 more variable: team_ref <chr>
# }
```
