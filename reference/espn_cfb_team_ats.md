# **ESPN College Football Team Against-the-Spread Records**

Get a college football team's against-the-spread (ATS) records for a
season – the 6-7 betting split rows ESPN tracks (overall, as favorite,
as underdog, home, away, ...).

## Usage

``` r
espn_cfb_team_ats(
  team_id = NULL,
  year = NULL,
  season_type = 2,
  team_detail = TRUE
)
```

## Arguments

- team_id:

  (*Integer* required): ESPN team id.

- year:

  (*Integer* required): Season, 4 digit format (*YYYY*).  
  Minimum value accepted: 2007

- season_type:

  (*Integer* default 2): ESPN season type. `2` = regular season, `3` =
  postseason.

- team_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN team catalog once
  and join friendly team fields next to the `team_id` column (see
  *Details*). Set `FALSE` to skip the catalog fetch and the join.

## Value

A data frame with one row per ATS split:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Season (4-digit year). |
| season_type | integer | ESPN season type (2 = regular, 3 = postseason). |
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
| ats_type_id | character | ATS split type id (e.g. `0`, `1`, `2`). |
| ats_type_name | character | ATS split type key (e.g. `atsOverall`, `atsFavorite`). |
| ats_description | character | ESPN's description of the ATS split. |
| wins | integer | Wins against the spread in the split. |
| losses | integer | Losses against the spread in the split. |
| pushes | integer | Pushes (no cover, no loss) in the split. |

## Details

Wraps the ESPN core-v2 team ATS endpoint
`sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/{year}/types/{season_type}/teams/{team_id}/ats`.
ESPN returns one item per ATS split, each carrying a `wins`/`losses`/
`pushes` triple and a `type` block (id, name, description). This wrapper
returns one row per split. The ATS records are populated only for
completed games, so an in-progress or future season may return an empty
frame.

When `team_detail = TRUE` (the default) the ESPN team catalog
([`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md))
is fetched once and friendly team fields are joined in next to the
`team_id` column – `team_name`, `team_abbreviation`, `team_location`,
`team_display_name`, `team_short_display_name`, `team_nickname`,
`team_color`, `team_alternate_color`, `team_logo_href`, and
`team_logo_dark_href`, inserted immediately after `team_id`. A catalog
failure degrades to `NA` rather than erroring the wrapper. Set
`team_detail = FALSE` to skip the catalog fetch and the join.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_team_ats(team_id = 61, year = 2024))
#> ── Team against-the-spread records from ESPN ───────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 17:04:07 UTC
#> # A tibble: 7 × 19
#>   season season_type team_id team_name team_abbreviation team_location
#>    <int>       <int> <chr>   <chr>     <chr>             <chr>        
#> 1   2024           2 61      Bulldogs  UGA               Georgia      
#> 2   2024           2 61      Bulldogs  UGA               Georgia      
#> 3   2024           2 61      Bulldogs  UGA               Georgia      
#> 4   2024           2 61      Bulldogs  UGA               Georgia      
#> 5   2024           2 61      Bulldogs  UGA               Georgia      
#> 6   2024           2 61      Bulldogs  UGA               Georgia      
#> 7   2024           2 61      Bulldogs  UGA               Georgia      
#> # ℹ 13 more variables: team_display_name <chr>, team_short_display_name <chr>,
#> #   team_nickname <chr>, team_color <chr>, team_alternate_color <chr>,
#> #   team_logo_href <chr>, team_logo_dark_href <chr>, ats_type_id <chr>,
#> #   ats_type_name <chr>, ats_description <chr>, wins <int>, losses <int>,
#> #   pushes <int>
  try(espn_cfb_team_ats(team_id = 61, year = 2024, team_detail = FALSE))
#> ── Team against-the-spread records from ESPN ───────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 17:04:07 UTC
#> # A tibble: 7 × 9
#>   season season_type team_id ats_type_id ats_type_name   ats_description    wins
#>    <int>       <int> <chr>   <chr>       <chr>           <chr>             <int>
#> 1   2024           2 61      0           atsOverall      Overall team sea…     2
#> 2   2024           2 61      1           atsFavorite     Team season reco…     1
#> 3   2024           2 61      2           atsUnderdog     Team season reco…     1
#> 4   2024           2 61      3           atsAway         Team season reco…     1
#> 5   2024           2 61      4           atsHome         Team season reco…     1
#> 6   2024           2 61      5           atsAwayFavorite Team season reco…     1
#> 7   2024           2 61      8           atsHomeUnderdog Team season reco…     1
#> # ℹ 2 more variables: losses <int>, pushes <int>
# }
```
