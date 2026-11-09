# **CFBD Against-the-Spread (ATS) Records**

**Get against-the-spread (ATS) summary records by team**

Retrieves a season-level against-the-spread summary for each team: how
often the team covered, failed to cover, or pushed relative to the
closing spread, plus the average margin by which it beat the spread.
Complements
[`cfbd_betting_lines()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_betting_lines.md),
which returns the per-game lines themselves.

## Usage

``` r
cfbd_betting_ats(year = NULL, team = NULL, conference = NULL)
```

## Arguments

- year:

  (*Integer* required): Year, 4 digit format (*YYYY*).  
  Minimum value accepted: 2019

- team:

  (*String* optional): D-I Team

- conference:

  (*String* optional): Conference abbreviation - Select a valid FBS
  conference  
  Conference abbreviations P5: ACC, B12, B1G, SEC, PAC  
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC  

## Value

Against-the-spread records with the following 9 columns:

|  |  |  |
|----|----|----|
| col_name | types | description |
| year | integer | Four-digit season year. |
| team_id | integer | Unique CFBD team identifier. |
| team | character | D-I team name. |
| conference | character | Team conference name. |
| games | integer | Number of games included in the ATS summary. |
| ats_wins | integer | Games the team covered the spread. |
| ats_losses | integer | Games the team failed to cover the spread. |
| ats_pushes | integer | Games that pushed against the spread. |
| avg_cover_margin | numeric | Average margin by which the team beat the spread. |

## See also

Other CFBD Betting Functions:
[`cfbd_betting_lines()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_betting_lines.md)

## Examples

``` r
# \donttest{
   try(cfbd_betting_ats(year = 2023, team = "Michigan"))
#> Waiting 6s for retry backoff ■■■■■■                          
#> Waiting 6s for retry backoff ■■■■■■■■■■                      
#> Waiting 6s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■     
#> Waiting 6s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 9s for retry backoff ■■■■■■■■■                       
#> Waiting 9s for retry backoff ■■■■■■■■■■■■■■■■■■■             
#> Waiting 9s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   
#> Waiting 9s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 11s for retry backoff ■■■■■■■■                        
#> Waiting 11s for retry backoff ■■■■■■■■■■■■■■■■                
#> Waiting 11s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■       
#> Waiting 11s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 17s for retry backoff ■■■                             
#> Waiting 17s for retry backoff ■■■■■■■                         
#> Waiting 17s for retry backoff ■■■■■■■■■■■■■                   
#> Waiting 17s for retry backoff ■■■■■■■■■■■■■■■■■■■             
#> Waiting 17s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■        
#> Waiting 17s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> Waiting 17s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> 2026-11-09 16:18:01.404359: Invalid arguments or no ATS data available! The CFBD API returned HTTP 429 (Too Many Requests)
#> data frame with 0 columns and 0 rows
# }
```
