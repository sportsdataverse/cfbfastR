# **ESPN College Football Player Event Log**

Get the per-game event log for a single college football player in a
season – one row per game, with the `$ref` URLs to each game's event,
competition, and the player's per-game statistics.

## Usage

``` r
espn_cfb_player_eventlog(
  athlete_id = NULL,
  year = NULL,
  team_detail = TRUE,
  athlete_detail = TRUE
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

- athlete_detail:

  (*Logical*): when `TRUE` (default), fetch the requested athlete's ESPN
  record once and append the `athlete_*` name columns (see *Details*).
  Set `FALSE` to skip the fetch, reproducing the prior output exactly.

## Value

A data frame with one row per game:

|  |  |  |
|----|----|----|
| col_name | types | description |
| athlete_id | character | ESPN athlete id. |
| season | integer | Season (4-digit year). |
| game_id | character | ESPN event (game) id (parsed from `event_ref`). |
| team_id | character | ESPN team id the player played for in the game. |
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
| played | logical | Whether the player played in the game. |
| event_ref | character | `$ref` URL to the event resource. |
| competition_ref | character | `$ref` URL to the competition resource. |
| statistics_ref | character | `$ref` URL to the player's per-game statistics. |
| athlete_display_name | character | Player display name; `athlete_detail = TRUE` only. |
| athlete_first_name | character | Player first name; `athlete_detail = TRUE` only. |
| athlete_last_name | character | Player last name; `athlete_detail = TRUE` only. |
| athlete_jersey | character | Player jersey number; `athlete_detail = TRUE` only. |
| athlete_position | character | Player position name; `athlete_detail = TRUE` only. |
| athlete_position_abbreviation | character | Player position abbreviation; `athlete_detail = TRUE` only. |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/athletes/{athlete_id}/eventlog`.
The event log lists every game the player appeared on a roster for in
the requested season. Per-game statistics are referenced by a
`statistics_ref` URL rather than being inlined – they are not
auto-dereferenced, since one fetch per game would be costly; resolve a
particular game with a direct request to that URL when needed. If the
player did not play in the requested season ESPN returns an empty
payload and this wrapper returns an empty data frame.

When `team_detail = TRUE` (the default) the ESPN team catalog
([`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md))
is fetched once and friendly team fields are joined in next to the
`team_id` column – `team_name`, `team_abbreviation`, `team_location`,
`team_display_name`, `team_short_display_name`, `team_nickname`,
`team_color`, `team_alternate_color`, `team_logo_href`, and
`team_logo_dark_href`, inserted immediately after `team_id`. A catalog
failure degrades to `NA` rather than erroring the wrapper. Set
`team_detail = FALSE` to skip the catalog fetch and the join.

When `athlete_detail = TRUE` (the default) the requested athlete's ESPN
record is fetched once and the human-readable name columns
`athlete_display_name`, `athlete_first_name`, `athlete_last_name`,
`athlete_jersey`, `athlete_position`, and
`athlete_position_abbreviation` are appended to every row. This is a
single cheap fetch – the wrapper already takes one `athlete_id`. A fetch
failure degrades the name columns to `NA` rather than erroring the
wrapper. Set `athlete_detail = FALSE` to skip the fetch and reproduce
the prior output exactly.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_player_eventlog(athlete_id = 102597, year = 2024))
#> ── Player event log from ESPN ──────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:12:44 UTC
#> # A tibble: 12 × 24
#>    athlete_id season game_id   team_id team_name team_abbreviation team_location
#>    <chr>       <int> <chr>     <chr>   <chr>     <chr>             <chr>        
#>  1 102597       2024 401628460 264     Huskies   WASH              Washington   
#>  2 102597       2024 401628473 264     Huskies   WASH              Washington   
#>  3 102597       2024 401628484 264     Huskies   WASH              Washington   
#>  4 102597       2024 401628491 264     Huskies   WASH              Washington   
#>  5 102597       2024 401628501 264     Huskies   WASH              Washington   
#>  6 102597       2024 401628505 264     Huskies   WASH              Washington   
#>  7 102597       2024 401628512 264     Huskies   WASH              Washington   
#>  8 102597       2024 401628526 264     Huskies   WASH              Washington   
#>  9 102597       2024 401628540 264     Huskies   WASH              Washington   
#> 10 102597       2024 401628546 264     Huskies   WASH              Washington   
#> 11 102597       2024 401628553 264     Huskies   WASH              Washington   
#> 12 102597       2024 401628569 264     Huskies   WASH              Washington   
#> # ℹ 17 more variables: team_display_name <chr>, team_short_display_name <chr>,
#> #   team_nickname <chr>, team_color <chr>, team_alternate_color <chr>,
#> #   team_logo_href <chr>, team_logo_dark_href <chr>, played <lgl>,
#> #   event_ref <chr>, competition_ref <chr>, statistics_ref <chr>,
#> #   athlete_display_name <chr>, athlete_first_name <chr>,
#> #   athlete_last_name <chr>, athlete_jersey <chr>, athlete_position <chr>,
#> #   athlete_position_abbreviation <chr>
  try(espn_cfb_player_eventlog(athlete_id = 102597, year = 2024,
                               team_detail = FALSE,
                               athlete_detail = FALSE))
#> ── Player event log from ESPN ──────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:12:44 UTC
#> # A tibble: 12 × 8
#>    athlete_id season game_id   team_id played event_ref          competition_ref
#>    <chr>       <int> <chr>     <chr>   <lgl>  <chr>              <chr>          
#>  1 102597       2024 401628460 264     TRUE   http://sports.cor… http://sports.…
#>  2 102597       2024 401628473 264     TRUE   http://sports.cor… http://sports.…
#>  3 102597       2024 401628484 264     TRUE   http://sports.cor… http://sports.…
#>  4 102597       2024 401628491 264     TRUE   http://sports.cor… http://sports.…
#>  5 102597       2024 401628501 264     TRUE   http://sports.cor… http://sports.…
#>  6 102597       2024 401628505 264     TRUE   http://sports.cor… http://sports.…
#>  7 102597       2024 401628512 264     TRUE   http://sports.cor… http://sports.…
#>  8 102597       2024 401628526 264     TRUE   http://sports.cor… http://sports.…
#>  9 102597       2024 401628540 264     TRUE   http://sports.cor… http://sports.…
#> 10 102597       2024 401628546 264     TRUE   http://sports.cor… http://sports.…
#> 11 102597       2024 401628553 264     TRUE   http://sports.cor… http://sports.…
#> 12 102597       2024 401628569 264     FALSE  http://sports.cor… http://sports.…
#> # ℹ 1 more variable: statistics_ref <chr>
# }
```
