# **ESPN Scoreboard**

**ESPN Scoreboard**

Get live scoreboard data from ESPN or look up the college football
schedule for a given season

ESPN Schedule

## Usage

``` r
espn_cfb_scoreboard(date = NULL)

espn_cfb_schedule(
  year = NULL,
  week = NULL,
  season_type = NULL,
  groups = NULL,
  limit = 500
)
```

## Arguments

- date:

  (*Integer* required - YYYYMMDD): Date to pull

- year:

  (int): Used to define different seasons.  
  Minimum value accepted: 1877

- week:

  (int): Week of the schedule.

- season_type:

  (string): "regular", "postseason", "off-season", or "both".

- groups:

  (string): Used to define different divisions. FBS or FCS.

- limit:

  (int): number of records to return, default: 500.

## Value

`espn_cfb_scoreboard()` & `espn_cfb_schedule()` - A data frame with 33
or 54 variables depending on if there are completed games: shared
variables

- `matchup`: character.: Long matchup description with full team names
  (Utah Utes at UCLA Bruins).

- `matchup_short`: character.: Short matchup description with team
  abbreviations (UTAH @ UCLA).

- `season`: integer.: Season of the game.

- `type`: character.: Season type of the game in CFBD format.

- `slug`: character.: Season type of the game in ESPN format.

- `game_id`: character.: Referencing game ID.

- `game_uid`: character.:

- `game_date`: character.: Game date.

- `attendance`: integer.: Reported attendance at the game.

- `play_by_play_available`: logical:

- `home_team_name`: character.: Home team mascot name (Sun Devils).

- `home_team_logo`: character.: Home team logo url.

- `home_team_abb`: character.: Home team abbreviation (ASU).

- `home_team_id`: character.: Home team ID.

- `home_team_location`: character.: Home team name (Arizona State).

- `home_team_full`: character.: Home team full name (Arizona State Sun
  Devils).

- `home_team_color`: character.: Home team color.

- `home_score`: integer.: Home team points.

- `home_win`: integer.: 1 if home team won, 0 if home team lost, NA if
  game is unfinished

- `home_record`: character: Home team record.

- `away_team_name`: character.: Away team mascot name (Sun Devils).

- `away_team_logo`: character.: Away team logo url.

- `away_team_abb`: character.: Away team abbreviation (ASU).

- `away_team_id`: character.: Away team ID.

- `away_team_location`: character.: Away team name (Arizona State).

- `away_team_full`: character.: Away team full name (Arizona State Sun
  Devils).

- `away_team_color`: character.: Away team color.

- `away_score`: integer.: Away team points.

- `away_win`: integer.: 1 if away team won, 0 if home team lost, NA if
  game is unfinished

- `away_record`: character: Away team record.

- `status_name`: character.: Status of the game

- `start_date`: character.: Game date.

Unique variables when there are completed games

- `broadcast_market`: character.: Broadcast market (typically "national"
  or NA)

- `broadcast_name`: character.: Broadcast channel i.e. ESPN, ABC, FOX

- `passing_leader_yards`: numeric.: Passing yards of game's passing
  leader

- `passing_leader_stat`: character.: Stat line of game's passing leader

- `passing_leader_name`: character.: Name of game's passing leader

- `passing_leader_shortname`: character.: First initial and last name of
  game's passing leader

- `passing_leader_headshot`: character.: Headshot url of game's passing
  leader

- `passing_leader_team_id`: character.: Team ID of game's passing leader

- `passing_leader_pos`: character.: Position of game's passing leader

- `rushing_leader_yards`: numeric.: Passing yards of game's rushing
  leader

- `rushing_leader_stat`: character.: Stat line of game's rushing leader

- `rushing_leader_name`: character.: Name of game's rushing leader

- `rushing_leader_shortname`: character.: First initial and last name of
  game's rushing leader

- `rushing_leader_headshot`: character.: Headshot url of game's rushing
  leader

- `rushing_leader_team_id`: character.: Team ID of game's rushing leader

- `rushing_leader_pos`: character.: Position of game's rushing leader

- `receiving_leader_yards`: numeric.: Passing yards of game's receiving
  leader

- `receiving_leader_stat`: character.: Stat line of game's receiving
  leader

- `receiving_leader_name`: character.: Name of game's receiving leader

- `receiving_leader_shortname`: character.: First initial and last name
  of game's receiving leader

- `receiving_leader_headshot`: character.: Headshot url of game's
  receiving leader

- `receiving_leader_team_id`: character.: Team ID of game's receiving
  leader

- `receiving_leader_pos`: character.: Position of game's receiving
  leader

`espn_cfb_schedule()` - A data frame with 8 variables:

- `matchup`: character.: .

- `matchup_short`: character.: .

- `season`: integer.: .

- `type`: character.: .

- `slug`: character.: .

- `game_id`: character.: .

- `game_uid`: character.: .

- `game_date`: Date.: .

- `attendance`: integer.: .

- `date_valid`: logical.: .

- `play_by_play_available`: logical.: .

- `home_team_name`: character.: .

- `home_team_logo`: character.: .

- `home_team_abb`: character.: .

- `home_team_id`: character.: .

- `home_team_location`: character.: .

- `home_team_full`: character.: .

- `home_team_color`: character.: .

- `home_score`: integer.: .

- `home_win`: integer.: .

- `home_record`: character.: .

- `away_team_name`: character.: .

- `away_team_logo`: character.: .

- `away_team_abb`: character.: .

- `away_team_id`: character.: .

- `away_team_location`: character.: .

- `away_team_full`: character.: .

- `away_team_color`: character.: .

- `away_score`: integer.: .

- `away_win`: integer.: .

- `away_record`: character.: .

- `status_name`: character.: .

- `start_date`: character.: .

- `highlights`: logical.: .

- `game_date_time`: datetime.: .

## Examples

``` r
# \donttest{
  try(espn_cfb_scoreboard())
#> ── Live Scoreboard Data from ESPN ──────────────────────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-27 20:29:12 UTC
#> # A tibble: 99 × 36
#>    matchup          matchup_short season type  slug  game_id game_uid game_date 
#>    <chr>            <chr>          <int> <chr> <chr> <chr>   <chr>    <date>    
#>  1 North Carolina … UNC VS TCU      2026 regu… regu… 401856… s:20~l:… 2026-08-29
#>  2 San José State … SJSU @ USC      2026 regu… regu… 401864… s:20~l:… 2026-08-29
#>  3 NC State Wolfpa… NCSU @ UVA      2026 regu… regu… 401858… s:20~l:… 2026-08-29
#>  4 Jacksonville St… JVST @ NDSU     2026 regu… regu… 401864… s:20~l:… 2026-08-29
#>  5 Sacramento Stat… SAC @ EMU       2026 regu… regu… 401866… s:20~l:… 2026-08-29
#>  6 Hawai'i Rainbow… HAW @ STAN      2026 regu… regu… 401858… s:20~l:… 2026-08-29
#>  7 New Mexico Stat… NMSU @ FSU      2026 regu… regu… 401864… s:20~l:… 2026-08-29
#>  8 Memphis Tigers … MEM @ UNLV      2026 regu… regu… 401862… s:20~l:… 2026-08-29
#>  9 Massachusetts M… MASS @ RUTG     2026 regu… regu… 401858… s:20~l:… 2026-09-03
#> 10 Bethune-Cookman… BCU @ UCF       2026 regu… regu… 401856… s:20~l:… 2026-09-03
#> # ℹ 89 more rows
#> # ℹ 28 more variables: attendance <int>, date_valid <lgl>,
#> #   play_by_play_available <lgl>, home_team_name <chr>, home_team_logo <chr>,
#> #   home_team_abb <chr>, home_team_id <chr>, home_team_location <chr>,
#> #   home_team_full <chr>, home_team_color <chr>, home_score <int>,
#> #   home_win <int>, home_record <chr>, away_team_name <chr>,
#> #   away_team_logo <chr>, away_team_abb <chr>, away_team_id <chr>, …
# }

# \donttest{
  try(espn_cfb_schedule(2021, week = 8))
#> ── Schedule Data from ESPN ─────────────────────────────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-27 20:29:13 UTC
#> # A tibble: 54 × 62
#>    season_type week    matchup matchup_short season type  slug  game_id game_uid
#>    <chr>       <chr>   <chr>   <chr>          <int> <chr> <chr> <chr>   <chr>   
#>  1 ""          &week=8 Coasta… CCU @ APP       2021 regu… regu… 401309… s:20~l:…
#>  2 ""          &week=8 Tulane… TULN @ SMU      2021 regu… regu… 401301… s:20~l:…
#>  3 ""          &week=8 Florid… FAU @ CLT       2021 regu… regu… 401282… s:20~l:…
#>  4 ""          &week=8 Louisi… UL @ ARST       2021 regu… regu… 401309… s:20~l:…
#>  5 ""          &week=8 San Jo… SJSU @ UNLV     2021 regu… regu… 401310… s:20~l:…
#>  6 ""          &week=8 Middle… MTSU @ CONN     2021 regu… regu… 401282… s:20~l:…
#>  7 ""          &week=8 Memphi… MEM @ UCF       2021 regu… regu… 401301… s:20~l:…
#>  8 ""          &week=8 Colora… CSU @ USU       2021 regu… regu… 401310… s:20~l:…
#>  9 ""          &week=8 Washin… WASH @ ARIZ     2021 regu… regu… 401309… s:20~l:…
#> 10 ""          &week=8 Cincin… CIN @ NAVY      2021 regu… regu… 401301… s:20~l:…
#> # ℹ 44 more rows
#> # ℹ 53 more variables: game_date <date>, attendance <int>, date_valid <lgl>,
#> #   play_by_play_available <lgl>, home_team_name <chr>, home_team_logo <chr>,
#> #   home_team_abb <chr>, home_team_id <chr>, home_team_location <chr>,
#> #   home_team_full <chr>, home_team_color <chr>, home_score <int>,
#> #   home_win <int>, home_record <chr>, away_team_name <chr>,
#> #   away_team_logo <chr>, away_team_abb <chr>, away_team_id <chr>, …
# }
```
