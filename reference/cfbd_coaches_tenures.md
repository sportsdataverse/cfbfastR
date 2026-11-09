# **Get coaching tenures**

**Get coaching tenures** Start and end of each coaching tenure.

## Usage

``` r
cfbd_coaches_tenures(
  coach_id = NULL,
  team = NULL,
  year = NULL,
  active = NULL,
  proxy = NULL
)
```

## Arguments

- coach_id:

  (*Integer* optional): Coach identifier.

- team:

  (*String* optional): Team filter.

- year:

  (*Integer* optional): Season, 4 digits (YYYY).  
  Minimum value accepted: 1886

- active:

  (*Logical* optional): Restrict to currently active tenures.

- proxy:

  (*List* optional): Per-call proxy override passed to `get_req()`.
  `NULL` (default) falls back to `getOption("cfbfastR.proxy")` and then
  the `http(s)_proxy` environment variables, so a caller can override
  the shared setting for one endpoint.

## Value

`cfbd_coaches_tenures()` - A tibble with 20 columns:

|                       |           |                                           |
|-----------------------|-----------|-------------------------------------------|
| col_name              | types     | description                               |
| id                    | integer   | Record identifier.                        |
| hire_date             | character | Hire date of the coach (ISO date string). |
| start_year            | integer   | Start year.                               |
| end_year              | integer   | End year.                                 |
| effective_start       | logical   | Effective start.                          |
| effective_end         | logical   | Effective end.                            |
| is_interim            | logical   | Is interim.                               |
| active                | logical   | Active.                                   |
| seasons               | integer   | Seasons.                                  |
| attribution_complete  | logical   | Attribution complete.                     |
| coach_id              | integer   | Coach identifier.                         |
| coach_first_name      | character | Coach first name.                         |
| coach_last_name       | character | Coach last name.                          |
| team_id               | integer   | Referencing team id.                      |
| team_school           | character | School name of the team.                  |
| record_games          | integer   | Record games.                             |
| record_wins           | integer   | Record wins.                              |
| record_losses         | integer   | Record losses.                            |
| record_ties           | integer   | Record ties.                              |
| record_win_percentage | numeric   | Record win percentage.                    |

## See also

Other CFBD Coaches Functions:
[`cfbd_coaches()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches.md),
[`cfbd_coaches_profile()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches_profile.md),
[`cfbd_coaches_seasons()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches_seasons.md)

## Examples

``` r
# \donttest{
  try(cfbd_coaches_tenures(team = "Georgia"))
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■■■■                
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 6s for retry backoff ■■■■■■■■■■                      
#> Waiting 6s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■       
#> Waiting 6s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 6s for retry backoff ■■■■■■■■■■■                     
#> Waiting 6s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■    
#> Waiting 6s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 12s for retry backoff ■■■■■■■                         
#> Waiting 12s for retry backoff ■■■■■■■■■■■■■■■                 
#> Waiting 12s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■         
#> Waiting 12s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> Waiting 12s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 38s for retry backoff ■■■                             
#> Waiting 38s for retry backoff ■■■■■■                          
#> Waiting 38s for retry backoff ■■■■■■■■                        
#> Waiting 38s for retry backoff ■■■■■■■■■■                      
#> Waiting 38s for retry backoff ■■■■■■■■■■■■■                   
#> Waiting 38s for retry backoff ■■■■■■■■■■■■■■■                 
#> Waiting 38s for retry backoff ■■■■■■■■■■■■■■■■■               
#> Waiting 38s for retry backoff ■■■■■■■■■■■■■■■■■■■■            
#> Waiting 38s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■          
#> Waiting 38s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■       
#> Waiting 38s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■     
#> Waiting 38s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   
#> Waiting 38s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> 2026-11-09 16:24:41.728084: Invalid arguments or no coaches data available! The CFBD API returned HTTP 429 (Too Many Requests)
#> data frame with 0 columns and 0 rows
# }
```
