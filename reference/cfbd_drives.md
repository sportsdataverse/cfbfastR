# **CFBD Drives Endpoint Overview**

- `cfbd_drives()`: Get college football game drives.

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
  Minimum value accepted: 2001

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

`cfbd_drives()` - A data frame with 28 variables:

|  |  |  |
|----|----|----|
| col_name | types | description |
| offense | character | Drive offense team name. |
| offense_conference | character | Drive offense team's conference. |
| defense | character | Drive defense team name. |
| defense_conference | character | Drive defense team's conference. |
| game_id | integer | Unique CFBD game identifier. |
| drive_id | character | Unique CFBD drive identifier. |
| drive_number | integer | Drive number within the game. |
| scoring | logical | Flag indicating whether the drive ended in a score. |
| start_period | integer | Period (quarter) in which the drive starts. |
| start_yardline | integer | Yard line at the drive start. |
| start_yards_to_goal | integer | Yards-to-goal at the drive start. |
| end_period | integer | Period (quarter) in which the drive ends. |
| end_yardline | integer | Yard line at drive end. |
| end_yards_to_goal | integer | Yards-to-goal at drive end. |
| plays | integer | Number of plays in the drive. |
| yards | integer | Total yards gained on the drive. |
| drive_result | character | Result of the drive (e.g. TD, FG, PUNT). |
| is_home_offense | logical | Flag indicating whether the offense on the field is the home team. |
| start_offense_score | numeric | Offense score at the start of the drive. |
| start_defense_score | numeric | Defense score at the start of the drive. |
| end_offense_score | numeric | Offense score at the end of the drive. |
| end_defense_score | numeric | Defense score at the end of the drive. |
| time_minutes_start | integer | Game clock minutes at drive start. |
| time_seconds_start | integer | Game clock seconds at drive start. |
| time_minutes_end | integer | Game clock minutes at drive end. |
| time_seconds_end | integer | Game clock seconds at drive end. |
| time_minutes_elapsed | numeric | Minutes elapsed during the drive. |
| time_seconds_elapsed | integer | Seconds elapsed during the drive. |

## Details

### **Get college football game drives**

    cfbd_drives(year = 2018, week = 1, team = "TCU")

    cfbd_drives(2018, team = "Texas A&M", defense_conference = "SEC")

## Examples

``` r
# \donttest{
  try(cfbd_drives(year=2018, week = 1, team = "TCU"))
#> Waiting 6s for retry backoff ■■■■■■                          
#> Waiting 6s for retry backoff ■■■■■■■■■■■■                    
#> Waiting 6s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■    
#> Waiting 6s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 8s for retry backoff ■■■■■■■■■■■                     
#> Waiting 8s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■        
#> Waiting 8s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 12s for retry backoff ■■■■                            
#> Waiting 12s for retry backoff ■■■■■■■■■■■■                    
#> Waiting 12s for retry backoff ■■■■■■■■■■■■■■■■■■■■            
#> Waiting 12s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■    
#> Waiting 12s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 38s for retry backoff ■■                              
#> Waiting 38s for retry backoff ■■■■■                           
#> Waiting 38s for retry backoff ■■■■■■■                         
#> Waiting 38s for retry backoff ■■■■■■■■■■                      
#> Waiting 38s for retry backoff ■■■■■■■■■■■■                    
#> Waiting 38s for retry backoff ■■■■■■■■■■■■■■                  
#> Waiting 38s for retry backoff ■■■■■■■■■■■■■■■■■               
#> Waiting 38s for retry backoff ■■■■■■■■■■■■■■■■■■■             
#> Waiting 38s for retry backoff ■■■■■■■■■■■■■■■■■■■■■           
#> Waiting 38s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■        
#> Waiting 38s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■      
#> Waiting 38s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   
#> Waiting 38s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> 2026-11-09 16:32:42.544256: Invalid arguments or no drives data available! The CFBD API returned HTTP 429 (Too Many Requests)
#> data frame with 0 columns and 0 rows

  try(cfbd_drives(2018, team = "Texas A&M", defense_conference = "SEC"))
#> Waiting 3s for retry backoff ■■■■■■■■■■                      
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> Waiting 3s for retry backoff ■■■■■■■■■■■                     
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> Waiting 9s for retry backoff ■■■■                            
#> Waiting 9s for retry backoff ■■■■■■■■■■■■■                   
#> Waiting 9s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■        
#> Waiting 9s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 22s for retry backoff ■■■                             
#> Waiting 22s for retry backoff ■■■■■■■                         
#> Waiting 22s for retry backoff ■■■■■■■■■■■                     
#> Waiting 22s for retry backoff ■■■■■■■■■■■■■■■                 
#> Waiting 22s for retry backoff ■■■■■■■■■■■■■■■■■■■             
#> Waiting 22s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■         
#> Waiting 22s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■    
#> Waiting 22s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 39s for retry backoff ■■                              
#> Waiting 39s for retry backoff ■■■■                            
#> Waiting 39s for retry backoff ■■■■■■                          
#> Waiting 39s for retry backoff ■■■■■■■■                        
#> Waiting 39s for retry backoff ■■■■■■■■■■■                     
#> Waiting 39s for retry backoff ■■■■■■■■■■■■■                   
#> Waiting 39s for retry backoff ■■■■■■■■■■■■■■■                 
#> Waiting 39s for retry backoff ■■■■■■■■■■■■■■■■■■              
#> Waiting 39s for retry backoff ■■■■■■■■■■■■■■■■■■■■            
#> Waiting 39s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■          
#> Waiting 39s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■        
#> Waiting 39s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■     
#> Waiting 39s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   
#> Waiting 39s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> 2026-11-09 16:33:57.209801: Invalid arguments or no drives data available! The CFBD API returned HTTP 429 (Too Many Requests)
#> data frame with 0 columns and 0 rows
# }
```
