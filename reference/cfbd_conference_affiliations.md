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
#> ── Get conference affiliations by team and season from CollegeFootballData.com ─
#> ℹ Data updated: 2026-09-03 22:33:17 UTC
#> # A tibble: 9 × 9
#>   team_id team    conference_id conference conference_abbreviat…¹ classification
#>     <int> <chr>           <int> <chr>      <chr>                  <chr>         
#> 1      61 Georgia            18 FBS Indep… Ind                    fbs           
#> 2      61 Georgia           273 SIAA       SIAA                   fbs           
#> 3      61 Georgia           273 SIAA       SIAA                   fbs           
#> 4      61 Georgia           273 SIAA       SIAA                   fbs           
#> 5      61 Georgia           273 SIAA       SIAA                   fbs           
#> 6      61 Georgia           206 Southern   Southern               fbs           
#> 7      61 Georgia             8 SEC        SEC                    fbs           
#> 8      61 Georgia             8 SEC        SEC                    fbs           
#> 9      61 Georgia             8 SEC        SEC                    fbs           
#> # ℹ abbreviated name: ¹​conference_abbreviation
#> # ℹ 3 more variables: conference_division <chr>, start_year <int>,
#> #   end_year <int>
# }
```
