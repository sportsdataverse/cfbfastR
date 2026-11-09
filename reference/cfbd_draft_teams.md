# **Get list of NFL teams**

**Get list of NFL teams**

## Usage

``` r
cfbd_draft_teams()
```

## Value

`cfbd_draft_teams()` - A data frame with 4 variables:

|  |  |  |
|----|----|----|
| col_name | types | description |
| nfl_location | character | NFL team location (city). |
| nfl_nickname | character | NFL team nickname (mascot). |
| nfl_display_name | character | NFL team display name (usually more neat/complete). |
| nfl_logo | character | URL for NFL team logo. |

## See also

Other CFBD Draft:
[`cfbd_draft_picks()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft_picks.md),
[`cfbd_draft_positions()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft_positions.md)

## Examples

``` r
# \donttest{
  try(cfbd_draft_teams())
#> Waiting 3s for retry backoff ■■■■■■■■■■■                     
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> Waiting 4s for retry backoff ■■■■■■■■■■■■■■■■■               
#> Waiting 4s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 9s for retry backoff ■■■■■                           
#> Waiting 9s for retry backoff ■■■■■■■■■■■■■■■■                
#> Waiting 9s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■     
#> Waiting 9s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 18s for retry backoff ■■■■                            
#> Waiting 18s for retry backoff ■■■■■■■■■                       
#> Waiting 18s for retry backoff ■■■■■■■■■■■■■■                  
#> Waiting 18s for retry backoff ■■■■■■■■■■■■■■■■■■■             
#> Waiting 18s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■       
#> Waiting 18s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> Waiting 18s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 25s for retry backoff ■■■                             
#> Waiting 25s for retry backoff ■■■■■■■                         
#> Waiting 25s for retry backoff ■■■■■■■■■■■                     
#> Waiting 25s for retry backoff ■■■■■■■■■■■■■■                  
#> Waiting 25s for retry backoff ■■■■■■■■■■■■■■■■■■              
#> Waiting 25s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■          
#> Waiting 25s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■       
#> Waiting 25s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   
#> Waiting 25s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> 2026-11-09 16:31:38.123246: Invalid arguments or no NFL teams data available! The CFBD API returned HTTP 429 (Too Many Requests)
#> data frame with 0 columns and 0 rows
# }
```
