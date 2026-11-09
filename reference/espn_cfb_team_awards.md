# **ESPN College Football Team Awards**

Get the awards won by a college football team's players in a season –
one row per (award x winning athlete).

## Usage

``` r
espn_cfb_team_awards(team_id = NULL, year = NULL, team_detail = TRUE)
```

## Arguments

- team_id:

  (*Integer* required): ESPN team id.

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 1935

- team_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN team catalog once
  and join friendly team fields next to every team-id column (`team_id`,
  `winner_team_id`) in the output (see *Details*). Set `FALSE` to skip
  the catalog fetch and the join.

## Value

A data frame with one row per award-winner:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Season (4-digit year). |
| team_id | character | ESPN team id. |
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
| award_id | character | ESPN award id. |
| award_name | character | Award display name (e.g. `John Mackey Award`). |
| award_description | character | Short description of the award. |
| athlete_id | character | ESPN athlete id of the winner (parsed from `athlete_ref`). |
| winner_team_id | character | ESPN team id credited with the win (parsed from `winner_team_ref`). |
| winner_team_name | character | Winner team nickname; `team_detail = TRUE` only. |
| winner_team_abbreviation | character | Winner team abbreviation; `team_detail = TRUE` only. |
| winner_team_location | character | Winner team location / school; `team_detail = TRUE` only. |
| winner_team_display_name | character | Winner team full display name; `team_detail = TRUE` only. |
| winner_team_short_display_name | character | Winner team short display name; `team_detail = TRUE` only. |
| winner_team_nickname | character | Winner team nickname label; `team_detail = TRUE` only. |
| winner_team_color | character | Winner team primary color; `team_detail = TRUE` only. |
| winner_team_alternate_color | character | Winner team alternate color; `team_detail = TRUE` only. |
| winner_team_logo_href | character | Winner team default logo URL; `team_detail = TRUE` only. |
| winner_team_logo_dark_href | character | Winner team dark logo URL; `team_detail = TRUE` only. |
| award_ref | character | `$ref` URL to the core-v2 award resource. |
| athlete_ref | character | `$ref` URL to the winning athlete-in-season resource. |
| winner_team_ref | character | `$ref` URL to the winner's team-in-season resource. |

## Details

Wraps the ESPN core-v2 team awards endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/teams/{team_id}/awards`.
The index endpoint returns a `$ref` list of award resources; this
wrapper dereferences each one and returns a row per winning athlete for
the award. Athletes are returned as ESPN athlete ids (parsed from
`athlete_ref`); join to another athlete source for names. Most teams
have only one or two award items in a season.

When `team_detail = TRUE` (the default) the ESPN team catalog
([`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md))
is fetched once and friendly team fields are joined onto every team-id
column the output carries – `team_id` and `winner_team_id`. For each id
column `X_id` the friendly siblings `X_name`, `X_abbreviation`,
`X_location`, `X_display_name`, `X_short_display_name`, `X_nickname`,
`X_color`, `X_alternate_color`, `X_logo_href`, and `X_logo_dark_href`
are inserted immediately after it. A catalog failure degrades to `NA`
rather than erroring the wrapper. Set `team_detail = FALSE` to skip the
catalog fetch and the join.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_team_awards(team_id = 61, year = 2023))
#> ── Team awards from ESPN ───────────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 19:55:45 UTC
#> # A tibble: 2 × 30
#>   season team_id team_name team_abbreviation team_location team_display_name
#>    <int> <chr>   <chr>     <chr>             <chr>         <chr>            
#> 1   2023 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#> 2   2023 61      Bulldogs  UGA               Georgia       Georgia Bulldogs 
#> # ℹ 24 more variables: team_short_display_name <chr>, team_nickname <chr>,
#> #   team_color <chr>, team_alternate_color <chr>, team_logo_href <chr>,
#> #   team_logo_dark_href <chr>, award_id <chr>, award_name <chr>,
#> #   award_description <chr>, athlete_id <chr>, winner_team_id <chr>,
#> #   winner_team_name <chr>, winner_team_abbreviation <chr>,
#> #   winner_team_location <chr>, winner_team_display_name <chr>,
#> #   winner_team_short_display_name <chr>, winner_team_nickname <chr>, …
  try(espn_cfb_team_awards(team_id = 61, year = 2023,
                           team_detail = FALSE))
#> ── Team awards from ESPN ───────────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 19:55:45 UTC
#> # A tibble: 2 × 10
#>   season team_id award_id award_name award_description athlete_id winner_team_id
#>    <int> <chr>   <chr>    <chr>      <chr>             <chr>      <chr>         
#> 1   2023 61      11       John Mack… Outstanding Tigh… 4432665    61            
#> 2   2023 61      158      Wuerffel … Top Community Se… 4612826    61            
#> # ℹ 3 more variables: award_ref <chr>, athlete_ref <chr>, winner_team_ref <chr>
# }
```
