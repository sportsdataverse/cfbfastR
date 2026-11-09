# **Get a coach profile**

**Get a coach profile** Biographical profile for a single coach.

## Usage

``` r
cfbd_coaches_profile(coach_id, proxy = NULL)
```

## Arguments

- coach_id:

  (*Integer* required): Coach identifier.

- proxy:

  (*List* optional): Per-call proxy override passed to `get_req()`.
  `NULL` (default) falls back to `getOption("cfbfastR.proxy")` and then
  the `http(s)_proxy` environment variables, so a caller can override
  the shared setting for one endpoint.

## Value

`cfbd_coaches_profile()` - A tibble with 19 columns:

|                       |           |                                      |
|-----------------------|-----------|--------------------------------------|
| col_name              | types     | description                          |
| id                    | integer   | Record identifier.                   |
| first_name            | character | First name.                          |
| last_name             | character | Last name.                           |
| display_name          | logical   | Display name.                        |
| current_team          | logical   | Current team.                        |
| birth_date            | logical   | Birth date and time (ISO 8601).      |
| alma_mater            | logical   | Alma mater.                          |
| graduation_year       | logical   | Graduation year.                     |
| wikidata_id           | logical   | Wikidata identifier.                 |
| hall_of_fame_year     | logical   | Hall of fame year.                   |
| career_seasons        | integer   | Seasons coached across the career.   |
| career_teams          | integer   | Distinct teams coached.              |
| career_first_year     | integer   | First season of the coaching career. |
| career_last_year      | integer   | Most recent season coached.          |
| career_games          | integer   | Career games coached.                |
| career_wins           | integer   | Career wins.                         |
| career_losses         | integer   | Career losses.                       |
| career_ties           | integer   | Career ties.                         |
| career_win_percentage | numeric   | Career winning percentage.           |

## See also

Other CFBD Coaches Functions:
[`cfbd_coaches()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches.md),
[`cfbd_coaches_seasons()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches_seasons.md),
[`cfbd_coaches_tenures()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches_tenures.md)

## Examples

``` r
# \donttest{
  try(cfbd_coaches_profile(coach_id = 1))
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■■■■■■■■            
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 5s for retry backoff ■■■■■■■■■■■                     
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■             
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> Waiting 17s for retry backoff ■■■                             
#> Waiting 17s for retry backoff ■■■■■■■■                        
#> Waiting 17s for retry backoff ■■■■■■■■■■■■■■                  
#> Waiting 17s for retry backoff ■■■■■■■■■■■■■■■■■■■             
#> Waiting 17s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■       
#> Waiting 17s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> Waiting 17s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 39s for retry backoff ■■■                             
#> Waiting 39s for retry backoff ■■■■■                           
#> Waiting 39s for retry backoff ■■■■■■■■                        
#> Waiting 39s for retry backoff ■■■■■■■■■■                      
#> Waiting 39s for retry backoff ■■■■■■■■■■■■                    
#> Waiting 39s for retry backoff ■■■■■■■■■■■■■■■                 
#> Waiting 39s for retry backoff ■■■■■■■■■■■■■■■■■               
#> Waiting 39s for retry backoff ■■■■■■■■■■■■■■■■■■■             
#> Waiting 39s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■          
#> Waiting 39s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■        
#> Waiting 39s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■     
#> Waiting 39s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■   
#> Waiting 39s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> 2026-11-09 16:22:36.424872: Invalid arguments or no coaches data available! The CFBD API returned HTTP 429 (Too Many Requests)
#> data frame with 0 columns and 0 rows
# }
```
