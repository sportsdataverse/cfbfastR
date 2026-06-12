# **Get game havoc statistics**

Get havoc-rate statistics aggregated by game. Havoc measures defensive
disruption – the share of plays that end in a tackle for loss, a forced
fumble, a pass defensed, or an interception – split into front-seven and
defensive-back contributions. Each row carries both the team's own
defensive havoc (`def_*`) and the havoc the team's offense allowed
(`off_*`) in that game.

## Usage

``` r
cfbd_stats_game_havoc(
  year = NULL,
  team = NULL,
  week = NULL,
  opponent = NULL,
  season_type = NULL
)
```

## Arguments

- year:

  (*Integer* optional): Year, 4 digit format (*YYYY*). Required if
  `team` is not specified.

- team:

  (*String* optional): D-I Team. Required if `year` is not specified.

- week:

  (*Integer* optional): Week - values from 1-15, 1-14 for seasons
  pre-playoff (i.e. 2013 or earlier).

- opponent:

  (*String* optional): Opponent D-I Team.

- season_type:

  (*String* optional): Season type - regular, postseason, both, allstar,
  spring_regular, spring_postseason.

## Value

`cfbd_stats_game_havoc()` - A data frame with 22 variables:

|  |  |  |
|----|----|----|
| col_name | types | description |
| game_id | integer | Referencing game id. |
| season | integer | Season of the game. |
| season_type | character | Season type of the game. |
| week | integer | Game week of the season. |
| team | character | Team name. |
| conference | character | Conference of the team. |
| opponent | character | Opponent team name. |
| opponent_conference | character | Conference of the opponent. |
| off_total_plays | integer | Offense plays in the game. |
| off_total_havoc_events | integer | Total havoc events allowed by the offense. |
| off_front_seven_havoc_events | integer | Front-seven havoc events allowed by the offense. |
| off_db_havoc_events | integer | Defensive-back havoc events allowed by the offense. |
| off_havoc_rate | double | Total havoc rate allowed by the offense. |
| off_front_seven_havoc_rate | double | Front-seven havoc rate allowed by the offense. |
| off_db_havoc_rate | double | Defensive-back havoc rate allowed by the offense. |
| def_total_plays | integer | Defense plays in the game. |
| def_total_havoc_events | integer | Total havoc events created by the defense. |
| def_front_seven_havoc_events | integer | Front-seven havoc events created by the defense. |
| def_db_havoc_events | integer | Defensive-back havoc events created by the defense. |
| def_havoc_rate | double | Total havoc rate created by the defense. |
| def_front_seven_havoc_rate | double | Front-seven havoc rate created by the defense. |
| def_db_havoc_rate | double | Defensive-back havoc rate created by the defense. |

## See also

Other CFBD Stats:
[`cfbd_stats_categories()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_categories.md),
[`cfbd_stats_game_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_game_advanced.md),
[`cfbd_stats_season_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_advanced.md),
[`cfbd_stats_season_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_player.md),
[`cfbd_stats_season_team()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_team.md)

## Examples

``` r
# \donttest{
   try(cfbd_stats_game_havoc(year = 2023, team = "Georgia"))
#> ── Game havoc stats from CollegeFootballData.com ───────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-06-12 13:46:41 UTC
#> # A tibble: 14 × 22
#>      game_id season season_type  week team    conference opponent      
#>        <int>  <int> <chr>       <int> <chr>   <chr>      <chr>         
#>  1 401520154   2023 regular         1 Georgia SEC        UT Martin     
#>  2 401520191   2023 regular         2 Georgia SEC        Ball State    
#>  3 401520225   2023 regular         3 Georgia SEC        South Carolina
#>  4 401520252   2023 regular         4 Georgia SEC        UAB           
#>  5 401520280   2023 regular         5 Georgia SEC        Auburn        
#>  6 401520300   2023 regular         6 Georgia SEC        Kentucky      
#>  7 401520327   2023 regular         7 Georgia SEC        Vanderbilt    
#>  8 401520352   2023 regular         9 Georgia SEC        Florida       
#>  9 401520364   2023 regular        10 Georgia SEC        Missouri      
#> 10 401520382   2023 regular        11 Georgia SEC        Ole Miss      
#> 11 401520419   2023 regular        12 Georgia SEC        Tennessee     
#> 12 401520430   2023 regular        13 Georgia SEC        Georgia Tech  
#> 13 401539483   2023 regular        14 Georgia SEC        Alabama       
#> 14 401551773   2023 postseason      1 Georgia SEC        Florida State 
#> # ℹ 15 more variables: opponent_conference <chr>, off_total_plays <int>,
#> #   off_total_havoc_events <int>, off_front_seven_havoc_events <int>,
#> #   off_db_havoc_events <int>, off_havoc_rate <dbl>,
#> #   off_front_seven_havoc_rate <dbl>, off_db_havoc_rate <dbl>,
#> #   def_total_plays <int>, def_total_havoc_events <int>,
#> #   def_front_seven_havoc_events <int>, def_db_havoc_events <int>,
#> #   def_havoc_rate <dbl>, def_front_seven_havoc_rate <dbl>, …

   try(cfbd_stats_game_havoc(2022, week = 1))
#> ── Game havoc stats from CollegeFootballData.com ───────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-06-12 13:46:41 UTC
#> # A tibble: 273 × 22
#>      game_id season season_type  week team       conference opponent  
#>        <int>  <int> <chr>       <int> <chr>      <chr>      <chr>     
#>  1 401403853   2022 regular         1 Hawai'i    MWC        Vanderbilt
#>  2 401403853   2022 regular         1 Vanderbilt SEC        Hawai'i   
#>  3 401403854   2022 regular         1 Utah State MWC        Alabama   
#>  4 401403854   2022 regular         1 Alabama    SEC        Utah State
#>  5 401403855   2022 regular         1 Arkansas   SEC        Cincinnati
#>  6 401403855   2022 regular         1 Cincinnati AAC        Arkansas  
#>  7 401403856   2022 regular         1 Auburn     SEC        Mercer    
#>  8 401403856   2022 regular         1 Mercer     NA         Auburn    
#>  9 401403857   2022 regular         1 Florida    SEC        Utah      
#> 10 401403857   2022 regular         1 Utah       PAC        Florida   
#> # ℹ 263 more rows
#> # ℹ 15 more variables: opponent_conference <chr>, off_total_plays <int>,
#> #   off_total_havoc_events <dbl>, off_front_seven_havoc_events <dbl>,
#> #   off_db_havoc_events <int>, off_havoc_rate <dbl>,
#> #   off_front_seven_havoc_rate <dbl>, off_db_havoc_rate <dbl>,
#> #   def_total_plays <int>, def_total_havoc_events <dbl>,
#> #   def_front_seven_havoc_events <dbl>, def_db_havoc_events <int>, …
# }
```
