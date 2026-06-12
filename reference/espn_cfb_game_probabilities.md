# **ESPN College Football Game Win Probabilities**

Get ESPN's play-by-play win-probability series for a single college
football game – one row per play.

## Usage

``` r
espn_cfb_game_probabilities(game_id = NULL, team_detail = TRUE)
```

## Arguments

- game_id:

  (*Integer* required): ESPN game identifier for a completed game.

- team_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN team catalog once
  and join friendly team fields next to the `home_team_id` /
  `away_team_id` columns (see *Details*). Set `FALSE` to skip the
  catalog fetch and the join.

## Value

A data frame with one row per play:

|  |  |  |
|----|----|----|
| col_name | types | description |
| game_id | character | ESPN game identifier. |
| play_id | character | ESPN play id (parsed from the play `$ref`). |
| sequence_number | character | Play sequence number within the game. |
| home_team_id | character | ESPN home team id (parsed from `home_team_ref`). |
| home_team_name | character | Home team nickname; `team_detail = TRUE` only. |
| home_team_abbreviation | character | Home team abbreviation; `team_detail = TRUE` only. |
| home_team_location | character | Home team location / school; `team_detail = TRUE` only. |
| home_team_display_name | character | Home team full display name; `team_detail = TRUE` only. |
| home_team_short_display_name | character | Home team short display name; `team_detail = TRUE` only. |
| home_team_nickname | character | Home team nickname label; `team_detail = TRUE` only. |
| home_team_color | character | Home team primary color; `team_detail = TRUE` only. |
| home_team_alternate_color | character | Home team alternate color; `team_detail = TRUE` only. |
| home_team_logo_href | character | Home team default logo URL; `team_detail = TRUE` only. |
| home_team_logo_dark_href | character | Home team dark logo URL; `team_detail = TRUE` only. |
| away_team_id | character | ESPN away team id (parsed from `away_team_ref`). |
| away_team_name | character | Away team nickname; `team_detail = TRUE` only. |
| away_team_abbreviation | character | Away team abbreviation; `team_detail = TRUE` only. |
| away_team_location | character | Away team location / school; `team_detail = TRUE` only. |
| away_team_display_name | character | Away team full display name; `team_detail = TRUE` only. |
| away_team_short_display_name | character | Away team short display name; `team_detail = TRUE` only. |
| away_team_nickname | character | Away team nickname label; `team_detail = TRUE` only. |
| away_team_color | character | Away team primary color; `team_detail = TRUE` only. |
| away_team_alternate_color | character | Away team alternate color; `team_detail = TRUE` only. |
| away_team_logo_href | character | Away team default logo URL; `team_detail = TRUE` only. |
| away_team_logo_dark_href | character | Away team dark logo URL; `team_detail = TRUE` only. |
| home_win_percentage | numeric | Home-team win probability after the play (0-1). |
| away_win_percentage | numeric | Away-team win probability after the play (0-1). |
| tie_percentage | numeric | Tie probability after the play (0-1). |
| seconds_left | integer | Seconds left in the game at the play. |
| spread_cover_prob_home | numeric | Probability the home team covers the spread. |
| spread_push_prob | numeric | Probability of a spread push. |
| total_over_prob | numeric | Probability the game total goes over. |
| total_push_prob | numeric | Probability of a total push. |
| source_id | character | ESPN data-source id for the probability row. |
| source_description | character | ESPN data-source description (e.g. `feed`). |
| source_state | character | ESPN data-source state (e.g. `full`). |
| last_modified | character | ISO timestamp the probability row was last modified. |
| play_ref | character | `$ref` URL to the play resource for the row. |
| competition_ref | character | `$ref` URL to the competition resource. |
| home_team_ref | character | `$ref` URL to the home team resource. |
| away_team_ref | character | `$ref` URL to the away team resource. |

## Details

Wraps the paginated ESPN core-v2 endpoint
`events/{game_id}/competitions/{game_id}/probabilities`. The endpoint is
paginated; this wrapper loops every page and stacks the results into one
frame – one row per play, each carrying the home / away / tie win
percentages at that point in the game, plus spread-cover and total
(over/under) probabilities. `play_id` is parsed from each row's play
`$ref` so the series can be joined to
[`espn_cfb_game_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_pbp.md).

This endpoint responds `HTTP 400` for future / not-yet-played games and
is only populated for **completed** games. The `@examples` use a
finished game; pass `game_id` values for completed games.

When `team_detail = TRUE` (the default) the ESPN team catalog
([`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md))
is fetched once and friendly team fields are joined in next to both the
`home_team_id` and `away_team_id` columns – e.g. `home_team_name`,
`home_team_abbreviation`, ..., `away_team_name`,
`away_team_abbreviation`, .... A catalog failure degrades to `NA` rather
than erroring the wrapper. Set `team_detail = FALSE` to skip the catalog
fetch and the join.

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
  try(espn_cfb_game_probabilities(game_id = 401628339))
#> ── Game win probabilities data from ESPN ───────────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-06-12 13:47:50 UTC
#> # A tibble: 157 × 41
#>    game_id   play_id            sequence_number home_team_id home_team_name
#>    <chr>     <chr>              <chr>           <chr>        <chr>         
#>  1 401628339 401628339101849903 101849903       61           Bulldogs      
#>  2 401628339 401628339101849905 101849905       61           Bulldogs      
#>  3 401628339 401628339101849908 101849908       61           Bulldogs      
#>  4 401628339 401628339101857801 101857801       61           Bulldogs      
#>  5 401628339 401628339101866801 101866801       61           Bulldogs      
#>  6 401628339 401628339101866802 101866802       61           Bulldogs      
#>  7 401628339 401628339101875001 101875001       61           Bulldogs      
#>  8 401628339 401628339101877201 101877201       61           Bulldogs      
#>  9 401628339 401628339101877203 101877203       61           Bulldogs      
#> 10 401628339 401628339101877501 101877501       61           Bulldogs      
#> # ℹ 147 more rows
#> # ℹ 36 more variables: home_team_abbreviation <chr>, home_team_location <chr>,
#> #   home_team_display_name <chr>, home_team_short_display_name <chr>,
#> #   home_team_nickname <chr>, home_team_color <chr>,
#> #   home_team_alternate_color <chr>, home_team_logo_href <chr>,
#> #   home_team_logo_dark_href <chr>, away_team_id <chr>, away_team_name <chr>,
#> #   away_team_abbreviation <chr>, away_team_location <chr>, …
  try(espn_cfb_game_probabilities(game_id = 401628339,
                                  team_detail = FALSE))
#> ── Game win probabilities data from ESPN ───────────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-06-12 13:47:50 UTC
#> # A tibble: 157 × 21
#>    game_id play_id sequence_number home_team_id away_team_id home_win_percentage
#>    <chr>   <chr>   <chr>           <chr>        <chr>                      <dbl>
#>  1 401628… 401628… 101849903       61           2635                       0.999
#>  2 401628… 401628… 101849905       61           2635                       0.999
#>  3 401628… 401628… 101849908       61           2635                       0.999
#>  4 401628… 401628… 101857801       61           2635                       0.999
#>  5 401628… 401628… 101866801       61           2635                       0.999
#>  6 401628… 401628… 101866802       61           2635                       0.999
#>  7 401628… 401628… 101875001       61           2635                       0.999
#>  8 401628… 401628… 101877201       61           2635                       0.999
#>  9 401628… 401628… 101877203       61           2635                       0.999
#> 10 401628… 401628… 101877501       61           2635                       0.999
#> # ℹ 147 more rows
#> # ℹ 15 more variables: away_win_percentage <dbl>, tie_percentage <dbl>,
#> #   seconds_left <int>, spread_cover_prob_home <dbl>, spread_push_prob <dbl>,
#> #   total_over_prob <dbl>, total_push_prob <dbl>, source_id <chr>,
#> #   source_description <chr>, source_state <chr>, last_modified <chr>,
#> #   play_ref <chr>, competition_ref <chr>, home_team_ref <chr>,
#> #   away_team_ref <chr>
# }
```
