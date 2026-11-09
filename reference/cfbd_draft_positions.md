# **Get list of NFL positions**

**Get list of NFL positions**

## Usage

``` r
cfbd_draft_positions()
```

## Value

`cfbd_draft_positions()` - A data frame with 2 variables:

|                       |           |                                  |
|-----------------------|-----------|----------------------------------|
| col_name              | types     | description                      |
| position_name         | character | NFL Position group name.         |
| position_abbreviation | character | NFL position group abbreviation. |

## See also

Other CFBD Draft:
[`cfbd_draft_picks()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft_picks.md),
[`cfbd_draft_teams()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft_teams.md)

## Examples

``` r
# \donttest{
  try(cfbd_draft_positions())
#> Waiting 4s for retry backoff ■■■■■■■■                        
#> Waiting 4s for retry backoff ■■■■■■■■■■■■■■                  
#> Waiting 4s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 8s for retry backoff ■■■■■                           
#> Waiting 8s for retry backoff ■■■■■■■■■■■■■■■■■               
#> Waiting 8s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   
#> Waiting 8s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 9s for retry backoff ■■■■■■■■■■                      
#> Waiting 9s for retry backoff ■■■■■■■■■■■■■■■■■■■■■           
#> Waiting 9s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 29s for retry backoff ■■                              
#> Waiting 29s for retry backoff ■■                              
#> Waiting 29s for retry backoff ■■■■■■                          
#> Waiting 29s for retry backoff ■■■■■■■■■                       
#> Waiting 29s for retry backoff ■■■■■■■■■■■■                    
#> Waiting 29s for retry backoff ■■■■■■■■■■■■■■■                 
#> Waiting 29s for retry backoff ■■■■■■■■■■■■■■■■■■              
#> Waiting 29s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■          
#> Waiting 29s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■       
#> Waiting 29s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■    
#> Waiting 29s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> 2026-11-09 16:30:37.985766: Invalid arguments or no NFL positions data available! The CFBD API returned HTTP 429 (Too Many Requests)
#> data frame with 0 columns and 0 rows
# }
```
