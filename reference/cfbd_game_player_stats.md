# **Get player statistics by game**

**Get player statistics by game**

## Usage

``` r
cfbd_game_player_stats(
  year,
  week = NULL,
  season_type = "regular",
  team = NULL,
  conference = NULL,
  category = NULL,
  game_id = NULL,
  division = NULL
)
```

## Arguments

- year:

  (*Integer* required): Year, 4 digit format(*YYYY*)  
  Minimum value accepted: 2004

- week:

  (*Integer* optional): Week - values from 1-15, 1-14 for seasons
  pre-playoff (i.e. 2013 or earlier)

- season_type:

  (*String* default regular): Select Season Type: regular, postseason,
  both, allstar, spring_regular, spring_postseason

- team:

  (*String* optional): D-I Team

- conference:

  (*String* optional): Conference abbreviation - Select a valid FBS
  conference Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC

- category:

  (*String* optional): Category filter (e.g defensive) Offense: passing,
  receiving, rushing Defense: defensive, fumbles, interceptions Special
  Teams: punting, puntReturns, kicking, kickReturns

- game_id:

  (*Integer* optional): Game ID filter for querying a single game Can be
  found using the
  [`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md)
  function

- division:

  (*String* optional): Division/classification filter – one of `fbs`,
  `fcs`, `ii`, `ii/iii`, `iii`. Sent to CFBD as `classification`.

## Value

`cfbd_game_player_stats()` - A data frame with 32 variables:

|  |  |  |
|----|----|----|
| col_name | types | description |
| game_id | integer | CFBD-internal game id; join key to other CFBD endpoints. |
| team | character | Full team name (e.g. "Alabama") for the player's team. |
| conference | character | Conference name of the player's team (e.g. "SEC"). |
| home_away | character | Whether the player's team played at home or away ("home"/"away"). |
| team_points | integer | Total points scored by the player's team in this game. |
| athlete_id | integer | CFBD-internal athlete id for the player. |
| athlete_name | character | Player's display name as reported by CFBD. |
| defensive_td | numeric | Defensive touchdowns scored by the player. |
| defensive_qb_hur | numeric | Quarterback hurries credited to the player. |
| defensive_pd | numeric | Passes defended (pass breakups) by the player. |
| defensive_tfl | numeric | Tackles for loss credited to the player. |
| defensive_sacks | numeric | Sacks credited to the player. |
| defensive_solo | numeric | Solo (unassisted) tackles by the player. |
| defensive_tot | numeric | Total tackles (solo plus assisted) by the player. |
| fumbles_rec | numeric | Fumbles recovered by the player. |
| fumbles_lost | numeric | Fumbles by the player that were lost to the opposing team. |
| fumbles_fum | numeric | Fumbles committed by the player. |
| punting_long | numeric | Longest punt by the player, in yards. |
| punting_in_20 | numeric | Punts downed inside the opponent 20-yard line. |
| punting_tb | numeric | Punts resulting in a touchback. |
| punting_avg | numeric | Average yards per punt. |
| punting_yds | numeric | Total punting yards (gross). |
| punting_no | numeric | Number of punts attempted. |
| kicking_pts | numeric | Total points scored by the kicker (FGs + XPs). |
| kicking_long | numeric | Longest made field goal, in yards. |
| kicking_pct | numeric | Field-goal percentage (made / attempted), 0-100. |
| punt_returns_td | numeric | Touchdowns scored on punt returns. |
| punt_returns_long | numeric | Longest punt return, in yards. |
| punt_returns_avg | numeric | Average yards per punt return. |
| punt_returns_yds | numeric | Total punt-return yards. |
| punt_returns_no | numeric | Number of punt returns. |
| kick_returns_td | numeric | Touchdowns scored on kickoff returns. |
| kick_returns_long | numeric | Longest kickoff return, in yards. |
| kick_returns_avg | numeric | Average yards per kickoff return. |
| kick_returns_yds | numeric | Total kickoff-return yards. |
| kick_returns_no | numeric | Number of kickoff returns. |
| interceptions_td | numeric | Touchdowns scored on interception returns (pick-sixes). |
| interceptions_yds | numeric | Interception-return yards. |
| interceptions_int | numeric | Number of interceptions made by the player. |
| receiving_long | numeric | Longest reception by the player, in yards. |
| receiving_td | numeric | Receiving touchdowns. |
| receiving_avg | numeric | Average yards per reception. |
| receiving_yds | numeric | Total receiving yards. |
| receiving_rec | numeric | Number of receptions (catches). |
| rushing_long | numeric | Longest rush by the player, in yards. |
| rushing_td | numeric | Rushing touchdowns. |
| rushing_avg | numeric | Average yards per rushing attempt. |
| rushing_yds | numeric | Total rushing yards. |
| rushing_car | numeric | Rushing carries (attempts). |
| passing_int | numeric | Interceptions thrown by the passer. |
| passing_td | numeric | Passing touchdowns thrown. |
| passing_avg | numeric | Yards per pass attempt. |
| passing_yds | numeric | Total passing yards. |
| passing_completions | numeric | Pass completions (split from CFBD's `C/ATT` field). |
| passing_attempts | numeric | Pass attempts (split from CFBD's `C/ATT` field). |
| passing_qbr | numeric | ESPN Quarterback Rating (QBR) for the player in this game. |
| kicking_xpm | numeric | Extra points made (split from CFBD's `XP` field). |
| kicking_xpa | numeric | Extra points attempted (split from CFBD's `XP` field). |
| kicking_fgm | numeric | Field goals made (split from CFBD's `FG` field). |
| kicking_fga | numeric | Field goals attempted (split from CFBD's `FG` field). |

## See also

Other CFBD Games:
[`cfbd_calendar()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_calendar.md),
[`cfbd_game_box_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_box_advanced.md),
[`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md),
[`cfbd_game_media()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_media.md),
[`cfbd_game_records()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_records.md),
[`cfbd_game_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.md),
[`cfbd_game_weather()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_weather.md),
[`cfbd_live_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_scoreboard.md)

## Examples

``` r
# \donttest{
  try(cfbd_game_player_stats(year = 2020, week = 15, team = "Alabama"))
#> ── Game player stats data from CollegeFootballData.com ─────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-27 16:36:44 UTC
#> # A tibble: 48 × 60
#>      game_id team     conference home_away team_points athlete_id athlete_name  
#>        <int> <chr>    <chr>      <chr>           <int>      <int> <chr>         
#>  1 401267164 Arkansas SEC        home                3    4034948 Feleipe Franks
#>  2 401267164 Arkansas SEC        home                3    4567149 KJ Jefferson  
#>  3 401267164 Arkansas SEC        home                3    4567156 Treylon Burks 
#>  4 401267164 Arkansas SEC        home                3    4242881 Trelon Smith  
#>  5 401267164 Arkansas SEC        home                3    4035576 T.J. Hammonds 
#>  6 401267164 Arkansas SEC        home                3    4360174 Michael Woods 
#>  7 401267164 Arkansas SEC        home                3    4079623 Blake Kern    
#>  8 401267164 Arkansas SEC        home                3    4567151 Trey Knox     
#>  9 401267164 Arkansas SEC        home                3    4372007 Nathan Parodi 
#> 10 401267164 Arkansas SEC        home                3    4391568 M Phillips    
#> # ℹ 38 more rows
#> # ℹ 53 more variables: defensive_td <dbl>, defensive_qb_hur <dbl>,
#> #   defensive_pd <dbl>, defensive_tfl <dbl>, defensive_sacks <dbl>,
#> #   defensive_solo <dbl>, defensive_tot <dbl>, fumbles_rec <dbl>,
#> #   fumbles_lost <dbl>, fumbles_fum <dbl>, punting_long <dbl>,
#> #   punting_in_20 <dbl>, punting_tb <dbl>, punting_avg <dbl>,
#> #   punting_yds <dbl>, punting_no <dbl>, kicking_pts <dbl>, …

  try(cfbd_game_player_stats(2013, week = 1, team = "Florida State", category = "passing"))
#> ── Game player stats data from CollegeFootballData.com ─────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-27 16:36:44 UTC
#> # A tibble: 3 × 60
#>     game_id team        conference home_away team_points athlete_id athlete_name
#>       <int> <chr>       <chr>      <chr>           <int>      <int> <chr>       
#> 1 332450221 Pittsburgh  ACC        home               13     514116 Tom Savage  
#> 2 332450221 Florida St… ACC        away               41     530308 Jameis Wins…
#> 3 332450221 Florida St… ACC        away               41     514124 Jake Coker  
#> # ℹ 53 more variables: defensive_td <dbl>, defensive_qb_hur <dbl>,
#> #   defensive_pd <dbl>, defensive_tfl <dbl>, defensive_sacks <dbl>,
#> #   defensive_solo <dbl>, defensive_tot <dbl>, fumbles_rec <dbl>,
#> #   fumbles_lost <dbl>, fumbles_fum <dbl>, punting_long <dbl>,
#> #   punting_in_20 <dbl>, punting_tb <dbl>, punting_avg <dbl>,
#> #   punting_yds <dbl>, punting_no <dbl>, kicking_pts <dbl>, kicking_long <dbl>,
#> #   kicking_pct <dbl>, punt_returns_td <dbl>, punt_returns_long <dbl>, …
# }
```
