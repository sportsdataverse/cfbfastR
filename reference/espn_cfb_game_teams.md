# **ESPN College Football Game Teams**

Get the two teams (home and away teams) for a single college football
game, with team identifiers, home/away designation, winner flag, and the
`$ref` URLs to every per-team sub-resource.

## Usage

``` r
espn_cfb_game_teams(
  game_id = NULL,
  team_detail = TRUE,
  format = c("long", "wide")
)
```

## Arguments

- game_id:

  (*Integer* required): ESPN game identifier.

- team_detail:

  (*Logical*): when `TRUE` (default), fetch the ESPN team catalog once
  and join friendly team fields next to every team-id column (`team_id`,
  `competitor_id`; see *Details*). Set `FALSE` to skip the catalog fetch
  and the join.

- format:

  (*Character*): output shape, one of `"long"` (default, one row per
  competitor) or `"wide"` (one row per game with `home_*` / `away_*`
  columns). See *Details*.

## Value

A data frame. When `format = "long"` (default), one row per team (two
per game):

|  |  |  |
|----|----|----|
| col_name | types | description |
| game_id | character | ESPN game identifier. |
| competitor_id | character | ESPN competitor id (equals the team id). |
| competitor_name | character | Team nickname; `team_detail = TRUE` only. |
| competitor_abbreviation | character | Team abbreviation; `team_detail = TRUE` only. |
| competitor_location | character | Team location / school; `team_detail = TRUE` only. |
| competitor_display_name | character | Full team display name; `team_detail = TRUE` only. |
| competitor_short_display_name | character | Short team display name; `team_detail = TRUE` only. |
| competitor_nickname | character | Team nickname label; `team_detail = TRUE` only. |
| competitor_color | character | Primary team color; `team_detail = TRUE` only. |
| competitor_alternate_color | character | Alternate team color; `team_detail = TRUE` only. |
| competitor_logo_href | character | Default team logo URL; `team_detail = TRUE` only. |
| competitor_logo_dark_href | character | Dark-variant team logo URL; `team_detail = TRUE` only. |
| team_id | character | ESPN team id (parsed from `team_ref`). |
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
| order | integer | Team order within the competition (0 = first). |
| home_away | character | `home` or `away`. |
| winner | logical | `TRUE` if this team won the game. |
| competitor_type | character | Competitor type (e.g. `team`). |
| curated_rank | integer | Curated poll rank at game time (`99` if unranked). |
| uid | character | ESPN universal identifier for the team. |
| team_ref | character | `$ref` URL to the team-in-season resource. |
| score_ref | character | `$ref` URL to the team score resource. |
| linescores_ref | character | `$ref` URL to the team linescores resource. |
| roster_ref | character | `$ref` URL to the team roster resource. |
| statistics_ref | character | `$ref` URL to the team statistics resource. |
| leaders_ref | character | `$ref` URL to the team leaders resource. |
| record_ref | character | `$ref` URL to the team record resource. |
| ranks_ref | character | `$ref` URL to the team week-ranks resource. |
| competitor_ref | character | `$ref` URL to the competitor resource itself. |

When `format = "wide"` the result is a single row per game: `game_id`
stays one key column and every other column above is emitted twice,
prefixed `home_` and `away_` (e.g. `home_team_id`, `home_team_name`,
`home_winner`, `home_curated_rank`, `away_team_id`, `away_team_name`,
...).

## Details

Wraps the ESPN core-v2 endpoint
`events/{game_id}/competitions/{game_id}/competitors`. The competition
id always equals the game id. By default returns one row per team (two
rows per game). Each row carries the `$ref` URLs ESPN publishes for that
team's score, linescores, roster, statistics, leaders, and record
resources – the dedicated `espn_cfb_game_team_*()` wrappers fetch and
flatten those resources for you. `curated_rank` is the AP/Coaches-poll
style rank ESPN attaches to the team at game time.

The `format` argument controls the output shape:

- `"long"` (default) – one row per competitor (two rows per game), with
  the `home_away` column, as shown in the *Value* table.

- `"wide"` – **one row per game**: every per-competitor column is
  pivoted to a `home_*` / `away_*` column keyed off the `home_away`
  value (e.g. `home_team_id`, `home_winner`, `home_curated_rank`,
  `away_team_id`, `away_winner`, ...). `game_id` stays a single key
  column, so a `"wide"` result is directly joinable onto any
  one-row-per-game table.

When `team_detail = TRUE` (the default) the ESPN team catalog
([`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md))
is fetched once and friendly team fields are joined in next to every
team-id column – `team_id` and `competitor_id`. For `team_id` the
siblings are `team_name`, `team_abbreviation`, `team_location`,
`team_display_name`, `team_short_display_name`, `team_nickname`,
`team_color`, `team_alternate_color`, `team_logo_href`,
`team_logo_dark_href`; `competitor_id` gains the parallel
`competitor_name`, `competitor_abbreviation`, .... `team_detail`
composes with `format` – in `"wide"` mode the `home_team_id` /
`away_team_id` columns get `home_team_name` / `away_team_name` / etc.
too. A catalog failure degrades to `NA` rather than erroring the
wrapper. Set `team_detail = FALSE` to skip the catalog fetch and the
join.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_game_teams(game_id = 401628339))
#> ── Game teams data from ESPN ───────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:12:32 UTC
#> # A tibble: 2 × 38
#>   game_id   competitor_id competitor_name competitor_abbreviation
#>   <chr>     <chr>         <chr>           <chr>                  
#> 1 401628339 61            Bulldogs        UGA                    
#> 2 401628339 2635          Golden Eagles   TNTC                   
#> # ℹ 34 more variables: competitor_location <chr>,
#> #   competitor_display_name <chr>, competitor_short_display_name <chr>,
#> #   competitor_nickname <chr>, competitor_color <chr>,
#> #   competitor_alternate_color <chr>, competitor_logo_href <chr>,
#> #   competitor_logo_dark_href <chr>, team_id <chr>, team_name <chr>,
#> #   team_abbreviation <chr>, team_location <chr>, team_display_name <chr>,
#> #   team_short_display_name <chr>, team_nickname <chr>, team_color <chr>, …
  try(espn_cfb_game_teams(game_id = 401628339, format = "wide"))
#> ── Game teams data from ESPN ───────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:12:32 UTC
#> # A tibble: 1 × 73
#>   game_id   home_competitor_id home_competitor_name home_competitor_abbreviation
#>   <chr>     <chr>              <chr>                <chr>                       
#> 1 401628339 61                 Bulldogs             UGA                         
#> # ℹ 69 more variables: home_competitor_location <chr>,
#> #   home_competitor_display_name <chr>,
#> #   home_competitor_short_display_name <chr>, home_competitor_nickname <chr>,
#> #   home_competitor_color <chr>, home_competitor_alternate_color <chr>,
#> #   home_competitor_logo_href <chr>, home_competitor_logo_dark_href <chr>,
#> #   home_team_id <chr>, home_team_name <chr>, home_team_abbreviation <chr>,
#> #   home_team_location <chr>, home_team_display_name <chr>, …
  try(espn_cfb_game_teams(game_id = 401628339, team_detail = FALSE))
#> ── Game teams data from ESPN ───────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:12:32 UTC
#> # A tibble: 2 × 18
#>   game_id   competitor_id team_id order home_away winner competitor_type
#>   <chr>     <chr>         <chr>   <int> <chr>     <lgl>  <chr>          
#> 1 401628339 61            61          0 home      TRUE   team           
#> 2 401628339 2635          2635        1 away      FALSE  team           
#> # ℹ 11 more variables: curated_rank <int>, uid <chr>, team_ref <chr>,
#> #   score_ref <chr>, linescores_ref <chr>, roster_ref <chr>,
#> #   statistics_ref <chr>, leaders_ref <chr>, record_ref <chr>, ranks_ref <chr>,
#> #   competitor_ref <chr>
# }
```
