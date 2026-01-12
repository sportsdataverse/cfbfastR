# **CFBD Drives Endpoint**

**Get college football game drives**

## Usage

``` r
cfbd_drives(
  year,
  season_type = "regular",
  week = NULL,
  team = NULL,
  offense_team = NULL,
  defense_team = NULL,
  conference = NULL,
  offense_conference = NULL,
  defense_conference = NULL,
  division = "fbs"
)
```

## Arguments

- year:

  (*Integer* required): Year, 4 digit format (*YYYY*)

- season_type:

  (*String* default regular): Season type - regular, postseason, both,
  allstar, spring_regular, spring_postseason

- week:

  (*Integer* optional): Week - values from 1-15, 1-14 for seasons
  pre-playoff, i.e. 2013 or earlier

- team:

  (*String* optional): D-I Team

- offense_team:

  (*String* optional): Offense D-I Team

- defense_team:

  (*String* optional): Defense D-I Team

- conference:

  (*String* optional): DI Conference abbreviation - Select a valid FBS
  conference Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC

- offense_conference:

  (*String* optional): Offense DI Conference abbreviation - Select a
  valid FBS conference Conference abbreviations P5: ACC, B12, B1G, SEC,
  PAC Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC,
  Ind, SBC, AAC

- defense_conference:

  (*String* optional): Defense DI Conference abbreviation - Select a
  valid FBS conference Conference abbreviations P5: ACC, B12, B1G, SEC,
  PAC Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC,
  Ind, SBC, AAC

- division:

  (*String* optional): Division abbreviation - Select a valid division:
  fbs/fcs/ii/iii

## Value

`cfbd_drives()` - A data frame with variables as follows:

- `offense`:character.:

  Drive offense.

- `offense_conference`:character.:

  Drive offense's conference.

- `defense`:character.:

  Drive defense.

- `defense_conference`:character.:

  Drive defense's conference.

- `game_id`:integer.:

  Unique game identifier - `game_id`.

- `drive_id`:character.:

  Unique drive identifier - `drive_id`.

- `drive_number`:integer.:

  Drive number in game.

- `scoring`:logical.:

  Drive ends in a score.

- `start_period`:integer.:

  Period (or Quarter) in which the drive starts.

- `start_yardline`:integer.:

  Yard line at the drive start.

- `start_yards_to_goal`:integer.:

  Yards-to-Goal at the drive start.

- `end_period`:integer.:

  Period (or Quarter) in which the drive ends.

- `end_yardline`:integer.:

  Yard line at drive end.

- `end_yards_to_goal`:integer.:

  Yards-to-Goal at drive end.

- `plays`:integer.:

  Number of drive plays.

- `yards`:integer.:

  Total drive yards.

- `drive_result`:character.:

  Result of the drive description.

- `is_home_offense`:logical.:

  Flag for if the offense on the field is the home offense

- `start_offense_score`:numeric.:

  Offense score at the start of the drive.

- `start_defense_score`:numeric.:

  Defense score at the start of the drive.

- `end_offense_score`:numeric.:

  Offense score at the end of the drive.

- `end_defense_score`:numeric.:

  Defense score at the end of the drive.

- `time_minutes_start`:integer.:

  Minutes at drive start.

- `time_seconds_start`:integer.:

  Seconds at drive start.

- `time_minutes_end`:integer.:

  Minutes at drive end.

- `time_seconds_end`:integer.:

  Seconds at drive end.

- `time_minutes_elapsed`:double.:

  Minutes elapsed during drive.

- `time_seconds_elapsed`:integer.:

  Seconds elapsed during drive.

## Examples

``` r
# \donttest{
  try(cfbd_drives(year=2018, week = 1, team = "TCU"))
#> ── Drives data from CollegeFootballData.com ────────────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 12:20:31 UTC
#> # A tibble: 25 × 28
#>    drive_id      game_id offense  offense_conference defense  defense_conference
#>    <chr>           <int> <chr>    <chr>              <chr>    <chr>             
#>  1 4010130721  401013072 TCU      Big 12             Southern SWAC              
#>  2 4010130722  401013072 Southern SWAC               TCU      Big 12            
#>  3 4010130723  401013072 TCU      Big 12             Southern SWAC              
#>  4 4010130724  401013072 Southern SWAC               TCU      Big 12            
#>  5 4010130725  401013072 TCU      Big 12             Southern SWAC              
#>  6 4010130726  401013072 Southern SWAC               TCU      Big 12            
#>  7 4010130727  401013072 TCU      Big 12             Southern SWAC              
#>  8 4010130728  401013072 Southern SWAC               TCU      Big 12            
#>  9 4010130729  401013072 TCU      Big 12             Southern SWAC              
#> 10 40101307210 401013072 Southern SWAC               TCU      Big 12            
#> # ℹ 15 more rows
#> # ℹ 22 more variables: drive_number <int>, scoring <lgl>, start_period <int>,
#> #   start_yardline <int>, start_yards_to_goal <int>, end_period <int>,
#> #   end_yardline <int>, end_yards_to_goal <int>, plays <int>, yards <int>,
#> #   drive_result <chr>, is_home_offense <lgl>, start_offense_score <int>,
#> #   start_defense_score <int>, end_offense_score <int>,
#> #   end_defense_score <int>, time_minutes_start <int>, …

  try(cfbd_drives(2018, team = "Texas A&M", defense_conference = "SEC"))
#> ── Drives data from CollegeFootballData.com ────────────────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 12:20:32 UTC
#> # A tibble: 259 × 28
#>    drive_id      game_id offense   offense_conference defense defense_conference
#>    <chr>           <int> <chr>     <chr>              <chr>   <chr>             
#>  1 4010122581  401012258 Northwes… Southland          Texas … SEC               
#>  2 4010122583  401012258 Northwes… Southland          Texas … SEC               
#>  3 4010122585  401012258 Northwes… Southland          Texas … SEC               
#>  4 4010122587  401012258 Northwes… Southland          Texas … SEC               
#>  5 4010122589  401012258 Northwes… Southland          Texas … SEC               
#>  6 40101225811 401012258 Northwes… Southland          Texas … SEC               
#>  7 40101225813 401012258 Northwes… Southland          Texas … SEC               
#>  8 40101225815 401012258 Northwes… Southland          Texas … SEC               
#>  9 40101225817 401012258 Northwes… Southland          Texas … SEC               
#> 10 40101225819 401012258 Northwes… Southland          Texas … SEC               
#> # ℹ 249 more rows
#> # ℹ 22 more variables: drive_number <int>, scoring <lgl>, start_period <int>,
#> #   start_yardline <int>, start_yards_to_goal <int>, end_period <int>,
#> #   end_yardline <int>, end_yards_to_goal <int>, plays <int>, yards <int>,
#> #   drive_result <chr>, is_home_offense <lgl>, start_offense_score <int>,
#> #   start_defense_score <int>, end_offense_score <int>,
#> #   end_defense_score <int>, time_minutes_start <int>, …
# }
```
