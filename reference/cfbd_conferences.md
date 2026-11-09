# **CFBD Conferences Endpoint Overview**

- `cfbd_conferences()`: Get college football conference information.

- [`cfbd_conference_affiliations()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_conference_affiliations.md):
  Get conference affiliations by team and season.

- [`cfbd_conference_changes()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_conference_changes.md):
  Get conference realignment changes for a season.

**Get college football conference information** Pulls all college
football conferences and returns as data frame

## Usage

``` r
cfbd_conferences(year = NULL, division = NULL)
```

## Arguments

- year:

  (*Integer* optional): Season filter, 4 digits (YYYY).  
  Minimum value accepted: 1869

- division:

  (*String* optional): Division/classification filter – one of `fbs`,
  `fcs`, `ii`, `ii/iii`, `iii`. Sent to CFBD as `classification`.

## Value

`cfbd_conferences()` - A data frame with 94 rows and 5 variables:

|                |           |                                                |
|----------------|-----------|------------------------------------------------|
| col_name       | types     | description                                    |
| conference_id  | integer   | Referencing conference id.                     |
| name           | character | Conference name.                               |
| long_name      | character | Long name for Conference.                      |
| abbreviation   | character | Conference abbreviation.                       |
| classification | character | Conference classification (fbs, fcs, ii, iii). |

## Details

### **Get college football conference information**

    cfbd_conferences()

### **Get conference affiliations by team and season**

    cfbd_conference_affiliations(team = "Georgia")

### **Get conference realignment changes**

    cfbd_conference_changes(year = 2024)

## See also

Other CFBD Conference Functions:
[`cfbd_conference_affiliations()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_conference_affiliations.md),
[`cfbd_conference_changes()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_conference_changes.md)

## Examples

``` r
# \donttest{
  try(cfbd_conferences())
#> Waiting 2s for retry backoff ■■■■■■■■■■■■■■■                 
#> Waiting 2s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 6s for retry backoff ■■■■■■■                         
#> Waiting 6s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■       
#> Waiting 6s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 6s for retry backoff ■■■■■■■■■■■                     
#> Waiting 6s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■     
#> Waiting 6s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 20s for retry backoff ■■■■                            
#> Waiting 20s for retry backoff ■■■■■■■■■                       
#> Waiting 20s for retry backoff ■■■■■■■■■■■■■                   
#> Waiting 20s for retry backoff ■■■■■■■■■■■■■■■■■■              
#> Waiting 20s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■         
#> Waiting 20s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■     
#> Waiting 20s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> Waiting 19s for retry backoff ■■                              
#> Waiting 19s for retry backoff ■■■■■■■                         
#> Waiting 19s for retry backoff ■■■■■■■■■■■■                    
#> Waiting 19s for retry backoff ■■■■■■■■■■■■■■■■■               
#> Waiting 19s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■          
#> Waiting 19s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■     
#> Waiting 19s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 
#> 2026-11-09 16:27:39.202518: Invalid arguments or no Conference data available! The CFBD API returned HTTP 429 (Too Many Requests)
#> data frame with 0 columns and 0 rows
# }
```
