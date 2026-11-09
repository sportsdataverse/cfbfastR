# **Load college football provider player id aliases from the SportsDataverse data repo**

Loads every player id another source uses for an ESPN college football
athlete, with the ESPN team the athlete was on and the seasons the id
held. Use it to map an NCAA (stats.ncaa.org), CBS, Yahoo or Fox player
id onto the ESPN `athlete_id`. stats.ncaa.org roster ids are new every
season, so an NCAA player has one row per season. Unmatched provider ids
are not included. Published to the `cfb_groups` release tag on the
sportsdataverse-data repo.

See
[`load_cfb_team_aliases()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_team_aliases.md)
for team ids and names.

## Usage

``` r
load_cfb_player_aliases(..., dbConnection = NULL, tablename = NULL)
```

## Arguments

- ...:

  Additional arguments passed to an underlying function that writes the
  data into a database.

- dbConnection:

  A `DBIConnection` object, as returned by
  [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html)

- tablename:

  The name of the data table within the database

## Value

Returns a `cfbfastR_data` tibble with one row per player alias, or
`NULL` after appending the rows to `tablename` when `dbConnection` and
`tablename` are both given.

|  |  |  |
|----|----|----|
| col_name | types | description |
| league | character | League key, always `cfb`. |
| athlete_id | character | ESPN athlete id. |
| athlete_id_source | character | Id system of `athlete_id`: `espn`. |
| source | character | Source of the player id: `ncaa`, `cbs`, `yahoo` or `fox`. |
| source_player_id | character | The source's own player id. |
| team_id | character | ESPN team id of the team the athlete was on when matched. |
| source_team_id | character | The source's own team id when it gives one (the season's stats.ncaa.org team id), else `NA`. |
| valid_from | integer | First season (fall year) the id is on that team, inclusive. |
| valid_to | integer | Last season (fall year) the id is on that team, inclusive; a gap or a change of match method splits the window into two rows. |
| match_method | character | How the id was matched: the source leg's own method (NCAA `name_jersey`, `name`, `last_jersey`, `jaro_winkler`; CFB rosters `name`), `crosswalk` (a leg that names none), `propagated` (carried from the same id's match in another season) or `override` (a hand-verified fix). |
| match_confidence | numeric | The leg's own confidence where it gives one (the lowest in the window; NCAA tiers score 1, 0.95, 0.9 and 0.85), else `NA`. |
| evidence | character | The asset or file the row came from. |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_cfb_player_aliases())
#> ── college football provider player id aliases from the SportsDataverse data rep
#> ℹ Data updated: 2026-11-09 19:56:42 UTC
#> # A tibble: 421,766 × 12
#>    league athlete_id athlete_id_source source source_player_id team_id
#>    <chr>  <chr>      <chr>             <chr>  <chr>            <chr>  
#>  1 cfb    100009     espn              ncaa   4242411          12     
#>  2 cfb    100009     espn              ncaa   4555821          12     
#>  3 cfb    100009     espn              ncaa   4948498          12     
#>  4 cfb    102597     espn              cbs    3171029          344    
#>  5 cfb    102597     espn              cbs    3171029          264    
#>  6 cfb    102597     espn              ncaa   7021730          344    
#>  7 cfb    102597     espn              ncaa   7289213          344    
#>  8 cfb    102597     espn              ncaa   7752435          344    
#>  9 cfb    102597     espn              ncaa   8059016          344    
#> 10 cfb    102597     espn              yahoo  ncaaf.p.316907   344    
#> # ℹ 421,756 more rows
#> # ℹ 6 more variables: source_team_id <chr>, valid_from <int>, valid_to <int>,
#> #   match_method <chr>, match_confidence <dbl>, evidence <chr>
# }
```
