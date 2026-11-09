# **Get conference affiliations by team and season**

**Get conference affiliations by team and season** Which conference each
team belonged to, by season.

## Usage

``` r
cfbd_conference_affiliations(
  team = NULL,
  conference = NULL,
  year = NULL,
  min_year = NULL,
  max_year = NULL,
  division = NULL,
  proxy = NULL
)
```

## Arguments

- team:

  (*String* optional): Team filter.

- conference:

  (*String* optional): Conference abbreviation filter.

- year:

  (*Integer* optional): Season, 4 digits (YYYY).  
  Minimum value accepted: 1869

- min_year:

  (*Integer* optional): Earliest season to include.

- max_year:

  (*Integer* optional): Latest season to include.

- division:

  (*String* optional): Division/classification filter – `fbs`, `fcs`,
  `ii`, `ii/iii`, `iii`.

- proxy:

  (*List* optional): Per-call proxy override passed to `get_req()`.
  `NULL` (default) falls back to `getOption("cfbfastR.proxy")` and then
  the `http(s)_proxy` environment variables, so a caller can override
  the shared setting for one endpoint.

## Value

`cfbd_conference_affiliations()` - A tibble with 9 columns:

|  |  |  |
|----|----|----|
| col_name | types | description |
| team_id | integer | Referencing team id. |
| team | character | Team name. |
| conference_id | integer | Referencing conference id. |
| conference | character | Conference name. |
| conference_abbreviation | character | Conference abbreviation. |
| classification | character | Division classification (fbs, fcs, ii, ii/iii, iii). |
| conference_division | character | Conference division. |
| start_year | integer | Start year. |
| end_year | integer | End year. |

## See also

Other CFBD Conference Functions:
[`cfbd_conference_changes()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_conference_changes.md),
[`cfbd_conferences()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_conferences.md)

## Examples

``` r
# \donttest{
  try(cfbd_conference_affiliations(team = "Georgia"))
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■                   
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> Waiting 5s for retry backoff ■■■■■■■                         
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■        
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 5s for retry backoff ■■■■■■■                         
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■       
#> Waiting 5s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 21s for retry backoff ■■■■                            
#> Waiting 21s for retry backoff ■■■■■■■■                        
#> Waiting 21s for retry backoff ■■■■■■■■■■■■■                   
#> Waiting 21s for retry backoff ■■■■■■■■■■■■■■■■■               
#> Waiting 21s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■          
#> Waiting 21s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■      
#> Waiting 21s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 21s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 41s for retry backoff ■■■                             
#> Waiting 41s for retry backoff ■■■■■                           
#> Waiting 41s for retry backoff ■■■■■■■                         
#> Waiting 41s for retry backoff ■■■■■■■■■■                      
#> Waiting 41s for retry backoff ■■■■■■■■■■■■                    
#> Waiting 41s for retry backoff ■■■■■■■■■■■■■■                  
#> Waiting 41s for retry backoff ■■■■■■■■■■■■■■■■                
#> Waiting 41s for retry backoff ■■■■■■■■■■■■■■■■■■              
#> Waiting 41s for retry backoff ■■■■■■■■■■■■■■■■■■■■■           
#> Waiting 41s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■         
#> Waiting 41s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■       
#> Waiting 41s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■     
#> Waiting 41s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> Waiting 41s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> 2026-11-09 16:25:56.694971: Invalid arguments or no conferences data available! The CFBD API returned HTTP 429 (Too Many Requests)
#> data frame with 0 columns and 0 rows
# }
```
