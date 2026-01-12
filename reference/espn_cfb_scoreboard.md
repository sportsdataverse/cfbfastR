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

  (int): Used to define different seasons. 2002 is the earliest
  available season.

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

- `matchup`: character.:

  Long matchup description with full team names (Utah Utes at UCLA
  Bruins).

- `matchup_short`: character.:

  Short matchup description with team abbreviations (UTAH @ UCLA).

- `season`: integer.:

  Season of the game.

- `type`: character.:

  Season type of the game in CFBD format.

- `slug`: character.:

  Season type of the game in ESPN format.

- `game_id`: character.:

  Referencing game ID.

- `game_uid`: character.:

- `game_date`: character.:

  Game date.

- `attendance`: integer.:

  Reported attendance at the game.

- `play_by_play_available`: logical:

- `home_team_name`: character.:

  Home team mascot name (Sun Devils).

- `home_team_logo`: character.:

  Home team logo url.

- `home_team_abb`: character.:

  Home team abbreviation (ASU).

- `home_team_id`: character.:

  Home team ID.

- `home_team_location`: character.:

  Home team name (Arizona State).

- `home_team_full`: character.:

  Home team full name (Arizona State Sun Devils).

- `home_team_color`: character.:

  Home team color.

- `home_score`: integer.:

  Home team points.

- `home_win`: integer.:

  1 if home team won, 0 if home team lost, NA if game is unfinished

- `home_record`: character:

  Home team record.

- `away_team_name`: character.:

  Away team mascot name (Sun Devils).

- `away_team_logo`: character.:

  Away team logo url.

- `away_team_abb`: character.:

  Away team abbreviation (ASU).

- `away_team_id`: character.:

  Away team ID.

- `away_team_location`: character.:

  Away team name (Arizona State).

- `away_team_full`: character.:

  Away team full name (Arizona State Sun Devils).

- `away_team_color`: character.:

  Away team color.

- `away_score`: integer.:

  Away team points.

- `away_win`: integer.:

  1 if away team won, 0 if home team lost, NA if game is unfinished

- `away_record`: character:

  Away team record.

- `status_name`: character.:

  Status of the game

- `start_date`: character.:

  Game date.

Unique variables when there are completed games

- `broadcast_market`: character.:

  Broadcast market (typically "national" or NA)

- `broadcast_name`: character.:

  Broadcast channel i.e. ESPN, ABC, FOX

- `passing_leader_yards`: numeric.:

  Passing yards of game's passing leader

- `passing_leader_stat`: character.:

  Stat line of game's passing leader

- `passing_leader_name`: character.:

  Name of game's passing leader

- `passing_leader_shortname`: character.:

  First initial and last name of game's passing leader

- `passing_leader_headshot`: character.:

  Headshot url of game's passing leader

- `passing_leader_team_id`: character.:

  Team ID of game's passing leader

- `passing_leader_pos`: character.:

  Position of game's passing leader

- `rushing_leader_yards`: numeric.:

  Passing yards of game's rushing leader

- `rushing_leader_stat`: character.:

  Stat line of game's rushing leader

- `rushing_leader_name`: character.:

  Name of game's rushing leader

- `rushing_leader_shortname`: character.:

  First initial and last name of game's rushing leader

- `rushing_leader_headshot`: character.:

  Headshot url of game's rushing leader

- `rushing_leader_team_id`: character.:

  Team ID of game's rushing leader

- `rushing_leader_pos`: character.:

  Position of game's rushing leader

- `receiving_leader_yards`: numeric.:

  Passing yards of game's receiving leader

- `receiving_leader_stat`: character.:

  Stat line of game's receiving leader

- `receiving_leader_name`: character.:

  Name of game's receiving leader

- `receiving_leader_shortname`: character.:

  First initial and last name of game's receiving leader

- `receiving_leader_headshot`: character.:

  Headshot url of game's receiving leader

- `receiving_leader_team_id`: character.:

  Team ID of game's receiving leader

- `receiving_leader_pos`: character.:

  Position of game's receiving leader

`espn_cfb_schedule()` - A data frame with 8 variables:

- `matchup`: character.:

  .

- `matchup_short`: character.:

  .

- `season`: integer.:

  .

- `type`: character.:

  .

- `slug`: character.:

  .

- `game_id`: character.:

  .

- `game_uid`: character.:

  .

- `game_date`: Date.:

  .

- `attendance`: integer.:

  .

- `date_valid`: logical.:

  .

- `play_by_play_available`: logical.:

  .

- `home_team_name`: character.:

  .

- `home_team_logo`: character.:

  .

- `home_team_abb`: character.:

  .

- `home_team_id`: character.:

  .

- `home_team_location`: character.:

  .

- `home_team_full`: character.:

  .

- `home_team_color`: character.:

  .

- `home_score`: integer.:

  .

- `home_win`: integer.:

  .

- `home_record`: character.:

  .

- `away_team_name`: character.:

  .

- `away_team_logo`: character.:

  .

- `away_team_abb`: character.:

  .

- `away_team_id`: character.:

  .

- `away_team_location`: character.:

  .

- `away_team_full`: character.:

  .

- `away_team_color`: character.:

  .

- `away_score`: integer.:

  .

- `away_win`: integer.:

  .

- `away_record`: character.:

  .

- `status_name`: character.:

  .

- `start_date`: character.:

  .

- `highlights`: logical.:

  .

- `game_date_time`: datetime.:

  .

## Examples

``` r
# \donttest{
  try(espn_cfb_scoreboard())
#> ── Live Scoreboard Data from ESPN ──────────────────────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:34:15 UTC
#> # A tibble: 47 × 59
#>    matchup          matchup_short season type  slug  game_id game_uid game_date 
#>    <chr>            <chr>          <int> <chr> <chr> <chr>   <chr>    <date>    
#>  1 Army Black Knig… ARMY VS NAVY    2025 post… post… 401762… s:20~l:… 2025-12-13
#>  2 Boise State Bro… BOIS VS WASH    2025 post… post… 401778… s:20~l:… 2025-12-13
#>  3 Troy Trojans at… TROY VS JVST    2025 post… post… 401778… s:20~l:… 2025-12-16
#>  4 Old Dominion Mo… ODU VS USF      2025 post… post… 401778… s:20~l:… 2025-12-17
#>  5 Louisiana Ragin… UL VS DEL       2025 post… post… 401778… s:20~l:… 2025-12-17
#>  6 Missouri State … MOST VS ARST    2025 post… post… 401838… s:20~l:… 2025-12-18
#>  7 Alabama Crimson… ALA @ OU        2025 post… post… 401779… s:20~l:… 2025-12-19
#>  8 Kennesaw State … KENN VS WMU     2025 post… post… 401778… s:20~l:… 2025-12-19
#>  9 Memphis Tigers … MEM VS NCSU     2025 post… post… 401778… s:20~l:… 2025-12-19
#> 10 James Madison D… JMU @ ORE       2025 post… post… 401779… s:20~l:… 2025-12-20
#> # ℹ 37 more rows
#> # ℹ 51 more variables: attendance <int>, date_valid <lgl>,
#> #   play_by_play_available <lgl>, home_team_name <chr>, home_team_logo <chr>,
#> #   home_team_abb <chr>, home_team_id <chr>, home_team_location <chr>,
#> #   home_team_full <chr>, home_team_color <chr>, home_score <int>,
#> #   home_win <int>, home_record <chr>, away_team_name <chr>,
#> #   away_team_logo <chr>, away_team_abb <chr>, away_team_id <chr>, …
# }

# \donttest{
  try(espn_cfb_schedule(2021, week = 8))
#> ── Schedule Data from ESPN ─────────────────────────────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 06:34:16 UTC
#> # A tibble: 54 × 60
#>    matchup          matchup_short season type  slug  game_id game_uid game_date 
#>    <chr>            <chr>          <int> <chr> <chr> <chr>   <chr>    <date>    
#>  1 Coastal Carolin… CCU @ APP       2021 regu… regu… 401309… s:20~l:… 2021-10-20
#>  2 Tulane Green Wa… TULN @ SMU      2021 regu… regu… 401301… s:20~l:… 2021-10-21
#>  3 Florida Atlanti… FAU @ CLT       2021 regu… regu… 401282… s:20~l:… 2021-10-21
#>  4 Louisiana Ragin… UL @ ARST       2021 regu… regu… 401309… s:20~l:… 2021-10-21
#>  5 San José State … SJSU @ UNLV     2021 regu… regu… 401310… s:20~l:… 2021-10-21
#>  6 Middle Tennesse… MTSU @ CONN     2021 regu… regu… 401282… s:20~l:… 2021-10-22
#>  7 Memphis Tigers … MEM @ UCF       2021 regu… regu… 401301… s:20~l:… 2021-10-22
#>  8 Colorado State … CSU @ USU       2021 regu… regu… 401310… s:20~l:… 2021-10-22
#>  9 Washington Husk… WASH @ ARIZ     2021 regu… regu… 401309… s:20~l:… 2021-10-22
#> 10 Cincinnati Bear… CIN @ NAVY      2021 regu… regu… 401301… s:20~l:… 2021-10-23
#> # ℹ 44 more rows
#> # ℹ 52 more variables: attendance <int>, date_valid <lgl>,
#> #   play_by_play_available <lgl>, home_team_name <chr>, home_team_logo <chr>,
#> #   home_team_abb <chr>, home_team_id <chr>, home_team_location <chr>,
#> #   home_team_full <chr>, home_team_color <chr>, home_score <int>,
#> #   home_win <int>, home_record <chr>, away_team_name <chr>,
#> #   away_team_logo <chr>, away_team_abb <chr>, away_team_id <chr>, …
# }
```
