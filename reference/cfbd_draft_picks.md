# **Get list of NFL draft picks**

**Get list of NFL draft picks**

## Usage

``` r
cfbd_draft_picks(
  year = NULL,
  nfl_team = NULL,
  college = NULL,
  conference = NULL,
  position = NULL
)
```

## Arguments

- year:

  (*Integer* required): NFL draft class, 4 digit format (*YYYY*)  
  Minimum value accepted: 1967

- nfl_team:

  (*String*): NFL drafting team, see
  [`cfbd_draft_teams()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft_teams.md)
  for valid selections.

- college:

  (*String*): NFL draftee college team, see
  [`cfbd_team_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_info.md)
  for valid selections.

- conference:

  (*String*): NFL draftee college team conference, see
  [`cfbd_conferences()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_conferences.md)
  for valid selections.

- position:

  (*String*): NFL position abbreviation, see
  [`cfbd_draft_positions()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft_positions.md)
  for valid selections.

## Value

`cfbd_draft_picks()` - A data frame with 24 variables:

|  |  |  |
|----|----|----|
| col_name | types | description |
| college_athlete_id | integer | College athlete referencing id. |
| nfl_athlete_id | integer | NFL athlete referencing id. |
| college_id | integer | College team referencing id. |
| college_team | character | College team name. |
| college_conference | character | Conference of college team. |
| nfl_team_id | integer | NFL team ID. |
| nfl_team | character | NFL team name of drafted player. |
| year | integer | NFL draft class year. |
| overall | integer | Overall draft pick number. |
| round | integer | Round of NFL draft the draftee was picked in. |
| pick | integer | Pick number of the NFL draftee within the round they were picked in. |
| name | character | NFL draftee name. |
| position | character | NFL draftee position. |
| height | numeric | NFL draftee height. |
| weight | integer | NFL draftee weight. |
| pre_draft_ranking | integer | Pre-draft ranking (ESPN). |
| pre_draft_position_ranking | integer | Pre-draft position ranking (ESPN). |
| pre_draft_grade | numeric | Pre-draft scouts grade (ESPN). |
| hometown_info_city | character | Hometown of the NFL draftee. |
| hometown_info_state_province | character | Hometown state of the NFL draftee. |
| hometown_info_country | character | Hometown country of the NFL draftee. |
| hometown_info_latitude | character | Hometown latitude of the NFL draftee. |
| hometown_info_longitude | character | Hometown longitude of the NFL draftee. |
| hometown_info_county_fips | character | Hometown FIPS code of the NFL draftee. |

## See also

Other CFBD Draft:
[`cfbd_draft_positions()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft_positions.md),
[`cfbd_draft_teams()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft_teams.md)

## Examples

``` r
# \donttest{
  try(cfbd_draft_picks(year = 2020))
#> Waiting 3s for retry backoff ■■■■■■■■■■■                     
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 4s for retry backoff ■■■■■■■■■■                      
#> Waiting 4s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> Waiting 9s for retry backoff ■■■■■■■■■■■                     
#> Waiting 9s for retry backoff ■■■■■■■■■■■■■■■■■■■■■           
#> Waiting 9s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 14s for retry backoff ■■■                             
#> Waiting 14s for retry backoff ■■■■■■■■                        
#> Waiting 14s for retry backoff ■■■■■■■■■■■■■■■                 
#> Waiting 14s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■          
#> Waiting 14s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■    
#> Waiting 14s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 36s for retry backoff ■■■                             
#> Waiting 36s for retry backoff ■■■■■                           
#> Waiting 36s for retry backoff ■■■■■■■■                        
#> Waiting 36s for retry backoff ■■■■■■■■■■                      
#> Waiting 36s for retry backoff ■■■■■■■■■■■■■                   
#> Waiting 36s for retry backoff ■■■■■■■■■■■■■■■                 
#> Waiting 36s for retry backoff ■■■■■■■■■■■■■■■■■■              
#> Waiting 36s for retry backoff ■■■■■■■■■■■■■■■■■■■■            
#> Waiting 36s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■         
#> Waiting 36s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■      
#> Waiting 36s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■    
#> Waiting 36s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 36s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> 2026-11-09 16:28:43.005733: Invalid arguments or no NFL draft data available! The CFBD API returned HTTP 429 (Too Many Requests)
#> data frame with 0 columns and 0 rows

  try(cfbd_draft_picks(year = 2016, position = "PK"))
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■     
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■             
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 9s for retry backoff ■■■■■■                          
#> Waiting 9s for retry backoff ■■■■■■■■■■■■■■■■■               
#> Waiting 9s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■     
#> Waiting 9s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 13s for retry backoff ■■■■■                           
#> Waiting 13s for retry backoff ■■■■■■■■■■■■                    
#> Waiting 13s for retry backoff ■■■■■■■■■■■■■■■■■■■             
#> Waiting 13s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■     
#> Waiting 13s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 31s for retry backoff ■■                              
#> Waiting 31s for retry backoff ■■■■■                           
#> Waiting 31s for retry backoff ■■■■■■■■                        
#> Waiting 31s for retry backoff ■■■■■■■■■■■                     
#> Waiting 31s for retry backoff ■■■■■■■■■■■■■■                  
#> Waiting 31s for retry backoff ■■■■■■■■■■■■■■■■■               
#> Waiting 31s for retry backoff ■■■■■■■■■■■■■■■■■■■■            
#> Waiting 31s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■         
#> Waiting 31s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■      
#> Waiting 31s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   
#> Waiting 31s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> 2026-11-09 16:29:42.135883: Invalid arguments or no NFL draft data available! The CFBD API returned HTTP 429 (Too Many Requests)
#> data frame with 0 columns and 0 rows
# }
```
