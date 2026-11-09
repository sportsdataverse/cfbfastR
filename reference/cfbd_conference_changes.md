# **Get conference realignment changes**

**Get conference realignment changes** Teams that changed conference in
a given season.

## Usage

``` r
cfbd_conference_changes(year, proxy = NULL)
```

## Arguments

- year:

  (*Integer* required): Season, 4 digits (YYYY).  
  Minimum value accepted: 1887

- proxy:

  (*List* optional): Per-call proxy override passed to `get_req()`.
  `NULL` (default) falls back to `getOption("cfbfastR.proxy")` and then
  the `http(s)_proxy` environment variables, so a caller can override
  the shared setting for one endpoint.

## Value

`cfbd_conference_changes()` - A tibble with 11 columns:

|  |  |  |
|----|----|----|
| col_name | types | description |
| team_id | integer | Referencing team id. |
| team | character | Team name. |
| from_conference_id | integer | Prior referencing conference id. |
| from_conference | character | Prior conference. |
| from_conference_abbreviation | character | Prior conference abbreviation. |
| from_classification | character | Prior division classification. |
| to_conference_id | integer | New referencing conference id. |
| to_conference | character | New conference. |
| to_conference_abbreviation | character | New conference abbreviation. |
| to_classification | character | New division classification. |
| effective_year | integer | Season the conference change takes effect. |

## See also

Other CFBD Conference Functions:
[`cfbd_conference_affiliations()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_conference_affiliations.md),
[`cfbd_conferences()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_conferences.md)

## Examples

``` r
# \donttest{
  try(cfbd_conference_changes(year = 2024))
#> Waiting 3s for retry backoff ■■■■■■■■■■                      
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 4s for retry backoff ■■■■■■■■■                       
#> Waiting 4s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 8s for retry backoff ■■■■■■■■■■■■                    
#> Waiting 8s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■        
#> Waiting 8s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 14s for retry backoff ■■■                             
#> Waiting 14s for retry backoff ■■■■■■■                         
#> Waiting 14s for retry backoff ■■■■■■■■■■■■■■                  
#> Waiting 14s for retry backoff ■■■■■■■■■■■■■■■■■■■■■           
#> Waiting 14s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■    
#> Waiting 14s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 22s for retry backoff ■■■                             
#> Waiting 22s for retry backoff ■■■■■■■                         
#> Waiting 22s for retry backoff ■■■■■■■■■■■■                    
#> Waiting 22s for retry backoff ■■■■■■■■■■■■■■■■                
#> Waiting 22s for retry backoff ■■■■■■■■■■■■■■■■■■■■            
#> Waiting 22s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■        
#> Waiting 22s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■    
#> Waiting 22s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> 2026-11-09 16:26:48.193906: Invalid arguments or no conferences data available! The CFBD API returned HTTP 429 (Too Many Requests)
#> data frame with 0 columns and 0 rows
# }
```
