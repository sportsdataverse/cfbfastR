# **ESPN College Football Awards**

Get ESPN's college football awards for a season – the Heisman, position
and player-of-the-year honors, and the athlete (and team) that won each.

## Usage

``` r
espn_cfb_awards(year = NULL, team_detail = TRUE)
```

## Arguments

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 1935

- team_detail:

  (*Logical*): when `TRUE` (default), the ESPN team catalog
  ([`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md))
  is fetched once and friendly team fields are joined in next to the
  `team_id` column. The sibling columns `team_name`,
  `team_abbreviation`, `team_location`, `team_display_name`,
  `team_short_display_name`, `team_nickname`, `team_color`,
  `team_alternate_color`, `team_logo_href`, `team_logo_dark_href` are
  inserted immediately after `team_id`. A catalog failure degrades to
  `NA` rather than erroring the wrapper. Set `FALSE` to skip the catalog
  fetch and the join, reproducing the prior output exactly.

## Value

A data frame with one row per award-winner:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Season (4-digit year). |
| award_id | character | ESPN award id. |
| name | character | Award name (e.g. `Heisman Trophy`). |
| description | character | ESPN's description of the award. |
| athlete_id | character | ESPN id of the winning athlete (parsed from `athlete_ref`); `NA` if none. |
| team_id | character | ESPN id of the winner's team (parsed from `team_ref`); `NA` if none. |
| team_name | character | Team nickname; `team_detail = TRUE` only. |
| team_abbreviation | character | Team abbreviation; `team_detail = TRUE` only. |
| team_location | character | Team location / school name; `team_detail = TRUE` only. |
| team_display_name | character | Full team display name; `team_detail = TRUE` only. |
| team_short_display_name | character | Short team display name; `team_detail = TRUE` only. |
| team_nickname | character | Team nickname label; `team_detail = TRUE` only. |
| team_color | character | Primary team color; `team_detail = TRUE` only. |
| team_alternate_color | character | Alternate team color; `team_detail = TRUE` only. |
| team_logo_href | character | Default team logo URL; `team_detail = TRUE` only. |
| team_logo_dark_href | character | Dark-variant team logo URL; `team_detail = TRUE` only. |
| award_ref | character | `$ref` URL to the award resource. |
| athlete_ref | character | `$ref` URL to the winning athlete resource (may be `NA`). |
| team_ref | character | `$ref` URL to the winner's team resource (may be `NA`). |

## Details

Wraps the ESPN core-v2 endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/awards`.
The index returns one `$ref` per award (~32); this wrapper dereferences
each and returns one row per (award x winner). Most awards have a single
winner, so the table is roughly one row per award. Winners are returned
as ESPN athlete ids (and team ids) only – join to an athlete source for
names. An award with no winner recorded yet still contributes one row
with `athlete_id`/`team_id` left `NA`.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# One request per award (about 35), so this takes several seconds.
try(espn_cfb_awards(year = 2024))
#> ── Awards data from ESPN ───────────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:11:43 UTC
#> # A tibble: 34 × 19
#>    season award_id name                 description athlete_id team_id team_name
#>     <int> <chr>    <chr>                <chr>       <chr>      <chr>   <chr>    
#>  1   2024 1        Buck Buchanan Award  I-AA Defen… 5085355    2110    Bears    
#>  2   2024 2        Chuck Bednarik Award Defensive … 4685415    38      Buffaloes
#>  3   2024 3        Davey O'Brien Award  National Q… 4688380    2390    Hurrican…
#>  4   2024 4        Dick Butkus Award    Outstandin… 4685597    61      Bulldogs 
#>  5   2024 5        Doak Walker Award    National R… 4890973    68      Broncos  
#>  6   2024 6        Fred Biletnikoff Aw… Outstandin… 4685415    38      Buffaloes
#>  7   2024 7        Gagliardi Trophy     NCAA Divis… 4911584    3071    Cardinals
#>  8   2024 8        Harlon Hill Trophy   NCAA Divis… 4572712    2118    Mules    
#>  9   2024 9        Heisman Memorial Tr… Outstandin… 4685415    38      Buffaloes
#> 10   2024 10       Jim Thorpe Award     Outstandin… 4430925    251     Longhorns
#> # ℹ 24 more rows
#> # ℹ 12 more variables: team_abbreviation <chr>, team_location <chr>,
#> #   team_display_name <chr>, team_short_display_name <chr>,
#> #   team_nickname <chr>, team_color <chr>, team_alternate_color <chr>,
#> #   team_logo_href <chr>, team_logo_dark_href <chr>, award_ref <chr>,
#> #   athlete_ref <chr>, team_ref <chr>
```
