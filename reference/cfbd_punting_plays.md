# **Get individual punt plays with yardage, field position and outcome**

**Get individual punt plays with yardage, field position and outcome**

## Usage

``` r
cfbd_punting_plays(
  year = NULL,
  game_id = NULL,
  week = NULL,
  season_type = NULL,
  team = NULL,
  punting_team = NULL,
  receiving_team = NULL,
  conference = NULL,
  punter_id = NULL,
  returner_id = NULL,
  classification = NULL,
  proxy = NULL
)
```

## Arguments

- year:

  (*Integer* optional): Year, 4 digit format (*YYYY*). Required unless
  `game_id` is given.  
  Minimum value accepted: 2015

- game_id:

  (*Integer* optional): Game ID filter for querying a single game

- week:

  (*Integer* optional): Week - values range from 1-15, 1-14 for seasons
  pre-playoff (i.e. 2013 or earlier). With `year`, CFBD also needs one
  of `week`, a team filter, `punter_id` or `returner_id`.

- season_type:

  (*String* optional): Season type - regular, postseason, both, allstar,
  spring_regular, spring_postseason

- team:

  (*String* optional): Team on either side of the punt

- punting_team:

  (*String* optional): Punting team filter

- receiving_team:

  (*String* optional): Receiving team filter

- conference:

  (*String* optional): Conference name or abbreviation on either side of
  the punt

- punter_id:

  (*String* optional): CFBD athlete id of the punter to filter on.

- returner_id:

  (*String* optional): CFBD athlete id of the returner to filter on.

- classification:

  (*String* optional): Division classification - fbs, fcs, ii,
  ii/iii, iii. CFBD defaults to fbs.

- proxy:

  (*List* optional): Per-call proxy override passed to `get_req()`.
  `NULL` (default) falls back to `getOption("cfbfastR.proxy")` and then
  the `http(s)_proxy` environment variables, so a caller can override
  the shared setting for one endpoint.

## Value

`cfbd_punting_plays()` - A data frame with 46 variables:

|  |  |  |
|----|----|----|
| col_name | type | description |
| game_id | integer | Unique game identifier - `game_id`. |
| play_id | character | Unique play identifier - `play_id`. |
| drive_id | character | Unique drive identifier - `drive_id`. |
| season | integer | Four-digit season year (e.g. 2025). |
| week | integer | Week of the season. |
| season_type | character | Season type (regular, postseason, ...). |
| punting_team_id | integer | Punting team id. |
| punting_team | character | Punting team name. |
| punting_conference | character | Punting team conference name. |
| receiving_team_id | integer | Receiving team id. |
| receiving_team | character | Receiving team name. |
| receiving_conference | character | Receiving team conference name. |
| period | integer | Quarter of the play. |
| down | integer | Down of the play. |
| distance | integer | Yards to gain for a first down. |
| play_type | character | CFBD play type (e.g. Punt, Blocked Punt, Punt Return Touchdown). |
| play_text | character | Play description text as published by the source. |
| punter_id | character | CFBD athlete id of the punter. |
| punter | character | Punter full name. |
| receiver_id | character | CFBD athlete id of the player who fielded the punt. |
| receiver | character | Full name of the player who fielded the punt. |
| returner_id | character | CFBD athlete id of the returner. |
| returner | character | Returner full name. |
| blocker_id | character | CFBD athlete id of the player who blocked the punt. |
| blocker | character | Full name of the player who blocked the punt. |
| counts_as_punt | logical | TRUE when the play counts as a punt (`NA` when unknown). |
| counts_as_return | logical | TRUE when the play counts as a punt return (`NA` when unknown). |
| start_yards_to_goal | integer | Punting team's yards from the opponent's end zone at the snap. |
| punt_yards | integer | Gross punt yards. |
| return_yards | integer | Return yards for the receiving team. |
| returner_yards | integer | Return yards credited to the returner (`NA` when not credited individually). |
| net_punt_yards | integer | Gross punt yards minus return yards, less 20 yards for a touchback. |
| kick_end_yardline | integer | Where the kick ended, from the punting team's goal line (0) to the receiving team's (100). |
| end_yardline | integer | Where the play ended, on the same scale as `kick_end_yardline`. |
| is_touchback | logical | TRUE when the punt ended in a touchback. |
| is_fair_catch | logical | TRUE when the punt was fair caught. |
| is_out_of_bounds | logical | TRUE when the punt went out of bounds. |
| is_downed | logical | TRUE when the punt was downed by the kicking team. |
| is_blocked | logical | TRUE when the punt was blocked. |
| is_muffed | logical | TRUE when the receiving team muffed the punt. |
| is_return_touchdown | logical | TRUE when the return went for a touchdown. |
| is_receiving_team_turnover | logical | TRUE when the receiving team lost possession, such as on a muff or fumble. |
| has_penalty | logical | TRUE when a penalty was called on the play. |
| parse_status | character | How completely CFBD parsed the play text - complete or partial. |
| clock_minutes | integer | Minutes remaining on the game clock at the snap. |
| clock_seconds | integer | Seconds remaining on the game clock at the snap. |

Columns that are `NA` on every row of a response are typed `logical` by
R: CFBD does not fill `blocker_id` or `blocker`, even when the play text
names the blocker, so both are usually all `NA` and typed `logical`.
Return yardage is `NA`, not 0, on a punt with no return.

## See also

Other CFBD Punting:
[`cfbd_punting_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting_players_games.md),
[`cfbd_punting_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting_players_season.md),
[`cfbd_punting_teams_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting_teams_games.md),
[`cfbd_punting_teams_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting_teams_season.md)

## Examples

``` r
# \donttest{
  try(cfbd_punting_plays(year = 2025, week = 1, team = "Texas"))
#> ── Punting plays data from CollegeFootballData.com ─────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 19:53:04 UTC
#> # A tibble: 17 × 46
#>      game_id play_id           drive_id season  week season_type punting_team_id
#>        <int> <chr>             <chr>     <int> <int> <chr>                 <int>
#>  1 401752677 4017526771019365… 4017526…   2025     1 regular                 251
#>  2 401752677 4017526771019664… 4017526…   2025     1 regular                 194
#>  3 401752677 4017526771019841… 4017526…   2025     1 regular                 251
#>  4 401752677 4017526771029494… 4017526…   2025     1 regular                 251
#>  5 401752677 4017526771029845… 4017526…   2025     1 regular                 194
#>  6 401752677 4017526771029964… 4017526…   2025     1 regular                 251
#>  7 401752677 4017526771038665… 4017526…   2025     1 regular                 194
#>  8 401752677 4017526771039641… 4017526…   2025     1 regular                 194
#>  9 401752677 4017526771049589… 4017526…   2025     1 regular                 194
#> 10 401752677 4017526771049773… 4017526…   2025     1 regular                 194
#> 11 401778330 40177833079       4017783…   2025     1 postseason              130
#> 12 401778330 40177833097       4017783…   2025     1 postseason              251
#> 13 401778330 401778330339      4017783…   2025     1 postseason              130
#> 14 401778330 401778330371      4017783…   2025     1 postseason              251
#> 15 401778330 401778330388      4017783…   2025     1 postseason              130
#> 16 401778330 401778330423      4017783…   2025     1 postseason              251
#> 17 401778330 401778330658      4017783…   2025     1 postseason              251
#> # ℹ 39 more variables: punting_team <chr>, punting_conference <chr>,
#> #   receiving_team_id <int>, receiving_team <chr>, receiving_conference <chr>,
#> #   period <int>, down <int>, distance <int>, play_type <chr>, play_text <chr>,
#> #   punter_id <chr>, punter <chr>, receiver_id <chr>, receiver <chr>,
#> #   returner_id <chr>, returner <chr>, blocker_id <lgl>, blocker <lgl>,
#> #   counts_as_punt <lgl>, counts_as_return <lgl>, start_yards_to_goal <int>,
#> #   punt_yards <int>, return_yards <int>, returner_yards <int>, …
# }
```
