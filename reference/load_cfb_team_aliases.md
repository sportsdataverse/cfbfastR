# **Load college football provider team id and name aliases from the SportsDataverse data repo**

Loads every team id and name another source uses for an ESPN college
football team, with the seasons the source shows it on that team. Use it
to map a Fox, Yahoo, CBS, CFBD, 247Sports or On3 team id or name onto
the ESPN `team_id`. A source id means something only within its source
(Fox 25 is Ohio State, ESPN 25 is California), so always join on
`source` as well. Published to the `cfb_groups` release tag on the
sportsdataverse-data repo.

See
[`load_cfb_player_aliases()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_player_aliases.md)
for player ids and
[`load_cfb_group_aliases()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_group_aliases.md)
for conference and division aliases.

## Usage

``` r
load_cfb_team_aliases(..., dbConnection = NULL, tablename = NULL)
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

Returns a `cfbfastR_data` tibble with one row per team alias, or `NULL`
after appending the rows to `tablename` when `dbConnection` and
`tablename` are both given.

|  |  |  |
|----|----|----|
| col_name | types | description |
| league | character | League key, always `cfb`. |
| team_id | character | ESPN team id. |
| team_id_source | character | Id system of `team_id`: `espn`. |
| source | character | Source that uses the alias: `fox`, `yahoo`, `cbs`, `cfbd`, `sports247` (247Sports) or `on3`. |
| source_id | character | The source's own team id (CFBD team ids are ESPN ids). |
| id_kind | character | `team` (the source's id for this sport's team) or `school` (one id for every sport of a school: 247Sports `institutionKey`, On3 `orgKey`). |
| name_kind | character | `name` or `abbreviation` when the source gives its own spelling, else `NA`. An id with a name and an abbreviation is two rows. |
| value | character | The source's own spelling of the name or abbreviation; `NA` when `name_kind` is `NA`. |
| valid_from | integer | First season (fall year) the source shows this id or name on the team, inclusive; `NA` for an undated curated map (CBS). |
| valid_to | integer | Last season (fall year) the source shows this id or name on the team, inclusive; `NA` for an undated curated map (CBS). A gap in the source splits the window into two rows. |
| match_method | character | How the row was matched: `deterministic` (a shared key: CFBD ids are ESPN ids), `crosswalk` (carried from a published crosswalk), `curated` (a cited hand-made map); for a captured team directory, `alias`, `exact_name` (normalized name) or `dict` (curated name dictionary). |
| evidence | character | The asset or file the row came from. |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_cfb_team_aliases())
#> ── college football provider team id and name aliases from the SportsDataverse d
#> ℹ Data updated: 2026-11-06 08:26:29 UTC
#> # A tibble: 4,165 × 12
#>    league team_id team_id_source source source_id id_kind name_kind    value    
#>    <chr>  <chr>   <chr>          <chr>  <chr>     <chr>   <chr>        <chr>    
#>  1 cfb    101     espn           cfbd   101       team    NA           NA       
#>  2 cfb    101161  espn           cfbd   101161    team    NA           NA       
#>  3 cfb    101442  espn           cfbd   101442    team    NA           NA       
#>  4 cfb    101784  espn           cbs    3159236   team    NA           NA       
#>  5 cfb    101784  espn           cfbd   101784    team    NA           NA       
#>  6 cfb    101784  espn           fox    798       team    abbreviation ERSK     
#>  7 cfb    101784  espn           fox    798       team    name         ERSKINE …
#>  8 cfb    103     espn           cbs    493       team    NA           NA       
#>  9 cfb    103     espn           cfbd   103       team    NA           NA       
#> 10 cfb    103     espn           fox    10        team    abbreviation BC       
#> # ℹ 4,155 more rows
#> # ℹ 4 more variables: valid_from <int>, valid_to <int>, match_method <chr>,
#> #   evidence <chr>
# }
```
