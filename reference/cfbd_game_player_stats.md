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
  game_id = NULL
)
```

## Arguments

- year:

  (*Integer* required): Year, 4 digit format(*YYYY*)

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

## Value

`cfbd_game_player_stats()` - A data frame with 32 variables:

|                     |           |
|---------------------|-----------|
| col_name            | types     |
| game_id             | integer   |
| team                | character |
| conference          | character |
| home_away           | character |
| team_points         | integer   |
| athlete_id          | integer   |
| athlete_name        | character |
| defensive_td        | numeric   |
| defensive_qb_hur    | numeric   |
| defensive_pd        | numeric   |
| defensive_tfl       | numeric   |
| defensive_sacks     | numeric   |
| defensive_solo      | numeric   |
| defensive_tot       | numeric   |
| fumbles_rec         | numeric   |
| fumbles_lost        | numeric   |
| fumbles_fum         | numeric   |
| punting_long        | numeric   |
| punting_in_20       | numeric   |
| punting_tb          | numeric   |
| punting_avg         | numeric   |
| punting_yds         | numeric   |
| punting_no          | numeric   |
| kicking_pts         | numeric   |
| kicking_long        | numeric   |
| kicking_pct         | numeric   |
| punt_returns_td     | numeric   |
| punt_returns_long   | numeric   |
| punt_returns_avg    | numeric   |
| punt_returns_yds    | numeric   |
| punt_returns_no     | numeric   |
| kick_returns_td     | numeric   |
| kick_returns_long   | numeric   |
| kick_returns_avg    | numeric   |
| kick_returns_yds    | numeric   |
| kick_returns_no     | numeric   |
| interceptions_td    | numeric   |
| interceptions_yds   | numeric   |
| interceptions_int   | numeric   |
| receiving_long      | numeric   |
| receiving_td        | numeric   |
| receiving_avg       | numeric   |
| receiving_yds       | numeric   |
| receiving_rec       | numeric   |
| rushing_long        | numeric   |
| rushing_td          | numeric   |
| rushing_avg         | numeric   |
| rushing_yds         | numeric   |
| rushing_car         | numeric   |
| passing_int         | numeric   |
| passing_td          | numeric   |
| passing_avg         | numeric   |
| passing_yds         | numeric   |
| passing_completions | numeric   |
| passing_attempts    | numeric   |
| passing_qbr         | numeric   |
| kicking_xpm         | numeric   |
| kicking_xpa         | numeric   |
| kicking_fgm         | numeric   |
| kicking_fga         | numeric   |

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
#> ── Game player stats data from CollegeFootballData.com ─────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 12:20:35 UTC
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
#> ── Game player stats data from CollegeFootballData.com ─────── cfbfastR 2.2.0 ──
#> ℹ Data updated: 2026-01-12 12:20:35 UTC
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
