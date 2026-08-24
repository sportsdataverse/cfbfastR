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
#> ── Conference data from CollegeFootballData.com ────────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-24 14:41:42 UTC
#> # A tibble: 256 × 6
#>    conference_id name         long_name abbreviation classification member_count
#>            <int> <chr>        <chr>     <chr>        <chr>                 <int>
#>  1           213 AAWU         Athletic… AAWU         fbs                       0
#>  2             1 ACC          Atlantic… ACC          fbs                      17
#>  3           151 American At… American… AAC          fbs                      14
#>  4           114 American Ri… American… NA           iii                       8
#>  5           100 American So… American… NA           iii                       6
#>  6           302 American We… American… AWC          ii                        0
#>  7           224 American We… American… AWC          fcs                       0
#>  8           225 Arkansas In… Arkansas… AIC          ii                        0
#>  9           226 Athletic Le… Athletic… NA           ii/iii                    0
#> 10            19 Atlantic 10  Atlantic… A10          fcs                       0
#> # ℹ 246 more rows
# }
```
