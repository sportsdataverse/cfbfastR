# **ESPN College Football Team Roster (Season-Scoped)**

Get the season roster for a single college football team – one row per
athlete with biographical detail, position, jersey number, and
class/experience.

## Usage

``` r
espn_cfb_team_roster(
  team_id = NULL,
  year = NULL,
  position_detail = TRUE,
  team_detail = TRUE
)
```

## Arguments

- team_id:

  (*Integer* required): ESPN team id.

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 2004

- position_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN position catalog
  once and join it onto `position_id`, appending the five `position_*`
  detail columns shown in the *Value* table. A catalog failure degrades
  to `NA` rather than erroring the wrapper. Set `FALSE` to skip the
  extra fetch and the join.

- team_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN team catalog once
  and join friendly team fields next to the `team_id` column (see
  *Details*). Set `FALSE` to skip the catalog fetch and the join.

## Value

A data frame with one row per athlete:

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
| athlete_id | character | ESPN athlete id. |
| first_name | character | Athlete first name. |
| last_name | character | Athlete last name. |
| full_name | character | Athlete full name. |
| display_name | character | Athlete display name. |
| jersey | character | Jersey number. |
| position | character | Position display name. |
| position_abbr | character | Position abbreviation. |
| height | numeric | Height in inches. |
| display_height | character | Human-readable height (e.g. `6' 1"`). |
| weight | numeric | Weight in pounds. |
| display_weight | character | Human-readable weight (e.g. `205 lbs`). |
| experience | integer | Years of experience. |
| class | character | Class / experience label (e.g. `Junior`). |
| birth_city | character | Birth city. |
| birth_state | character | Birth state. |
| birth_country | character | Birth country. |
| status | character | Athlete status (e.g. `Active`). |
| active | logical | Whether the athlete is active. |
| headshot_href | character | URL of the athlete headshot image. |
| position_id | character | ESPN position id; `position_detail = TRUE` only. |
| position_name | character | Position name (e.g. `Quarterback`); `position_detail = TRUE` only. |
| position_display_name | character | Human-readable position name; `position_detail = TRUE` only. |
| position_abbreviation | character | Position abbreviation (e.g. `QB`); `position_detail = TRUE` only. |
| position_leaf | logical | `TRUE` for a most-specific (leaf) position; `position_detail = TRUE` only. |
| position_parent_id | character | ESPN id of the parent position; `position_detail = TRUE` only. |

## Details

Wraps the ESPN core-v2 season athlete index
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/teams/{team_id}/athletes`.
The index returns one `$ref` per athlete; this wrapper dereferences each
athlete resource and flattens it into a row. The site-v2 roster endpoint
is deliberately **not** used: it returns only the team's *current*
roster and silently ignores a `season` query parameter, so it cannot
deliver historical rosters. The core-v2 path used here is genuinely
season-scoped.

Because each athlete is dereferenced individually, a full roster is
roughly 150-220 HTTP requests; allow a few seconds per call.

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
is fetched once and joined onto the `position_id` column, appending the
five `position_*` detail columns (`position_name`,
`position_display_name`, `position_abbreviation`, `position_leaf`,
`position_parent_id`). A catalog failure degrades to `NA` rather than
erroring the wrapper. Set `position_detail = FALSE` to skip the extra
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
[`espn_cfb_team_schedule()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_schedule.md),
[`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md),
[`espn_cfb_unnest_plays()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_unnest_plays.md),
[`espn_cfb_venue()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_venue.md),
[`espn_cfb_venues()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_venues.md),
[`espn_cfb_week_rankings()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_week_rankings.md)

## Examples

``` r
# \donttest{
  try(espn_cfb_team_roster(team_id = 61, year = 2024))
#> ── Team roster from ESPN ───────────────────────────────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-27 15:30:04 UTC
#> # A tibble: 177 × 38
#>    season team_id team_name team_abbreviation team_location team_display_name
#>     <int> <chr>   <chr>     <chr>             <chr>         <chr>            
#>  1   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  2   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  3   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  4   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  5   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  6   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  7   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  8   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  9   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#> 10   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#> # ℹ 167 more rows
#> # ℹ 32 more variables: team_short_display_name <chr>, team_nickname <chr>,
#> #   team_color <chr>, team_alternate_color <chr>, team_logo_href <chr>,
#> #   team_logo_dark_href <chr>, athlete_id <chr>, first_name <chr>,
#> #   last_name <chr>, full_name <chr>, display_name <chr>, jersey <chr>,
#> #   position <chr>, position_abbr <chr>, height <dbl>, display_height <chr>,
#> #   weight <dbl>, display_weight <chr>, experience <int>, class <chr>, …
  try(espn_cfb_team_roster(team_id = 61, year = 2024,
                           position_detail = FALSE))
#> ── Team roster from ESPN ───────────────────────────────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-27 15:30:09 UTC
#> # A tibble: 177 × 32
#>    season team_id team_name team_abbreviation team_location team_display_name
#>     <int> <chr>   <chr>     <chr>             <chr>         <chr>            
#>  1   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  2   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  3   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  4   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  5   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  6   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  7   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  8   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#>  9   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#> 10   2024 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#> # ℹ 167 more rows
#> # ℹ 26 more variables: team_short_display_name <chr>, team_nickname <chr>,
#> #   team_color <chr>, team_alternate_color <chr>, team_logo_href <chr>,
#> #   team_logo_dark_href <chr>, athlete_id <chr>, first_name <chr>,
#> #   last_name <chr>, full_name <chr>, display_name <chr>, jersey <chr>,
#> #   position <chr>, position_abbr <chr>, height <dbl>, display_height <chr>,
#> #   weight <dbl>, display_weight <chr>, experience <int>, class <chr>, …
  try(espn_cfb_team_roster(team_id = 61, year = 2024,
                           team_detail = FALSE))
#> ── Team roster from ESPN ───────────────────────────────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-27 15:30:14 UTC
#> # A tibble: 177 × 28
#>    season team_id athlete_id first_name last_name full_name  display_name jersey
#>     <int> <chr>   <chr>      <chr>      <chr>     <chr>      <chr>        <chr> 
#>  1   2024 61      4870588    Joenel     Aguero    Joenel Ag… Joenel Ague… 6     
#>  2   2024 61      4870598    CJ         Allen     CJ Allen   CJ Allen     3     
#>  3   2024 61      5150384    Liam       Badger    Liam Badg… Liam Badger  96    
#>  4   2024 61      4691816    Aliou      Bah       Aliou Bah  Aliou Bah    55    
#>  5   2024 61      5160178    Clinton    Barlow    Clinton B… Clinton Bar… 67    
#>  6   2024 61      4914220    Henry      Bates     Henry Bat… Henry Bates  94    
#>  7   2024 61      4430841    Carson     Beck      Carson Be… Carson Beck  11    
#>  8   2024 61      4712579    Dillon     Bell      Dillon Be… Dillon Bell  86    
#>  9   2024 61      5150831    Jeremy     Bell      Jeremy Be… Jeremy Bell  11    
#> 10   2024 61      5081059    Luke       Bennett   Luke Benn… Luke Bennett 29    
#> # ℹ 167 more rows
#> # ℹ 20 more variables: position <chr>, position_abbr <chr>, height <dbl>,
#> #   display_height <chr>, weight <dbl>, display_weight <chr>, experience <int>,
#> #   class <chr>, birth_city <chr>, birth_state <chr>, birth_country <chr>,
#> #   status <chr>, active <lgl>, headshot_href <chr>, position_id <chr>,
#> #   position_name <chr>, position_display_name <chr>,
#> #   position_abbreviation <chr>, position_leaf <lgl>, …
# }
```
