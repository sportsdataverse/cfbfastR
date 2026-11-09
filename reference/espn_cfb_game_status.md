# **ESPN College Football Game Status**

Get the competition status for a single college football game – clock,
period, and the status type/state (scheduled, in-progress, final).

## Usage

``` r
espn_cfb_game_status(game_id = NULL)
```

## Arguments

- game_id:

  (*Integer* required): ESPN game identifier.

## Value

A data frame with one row describing the game status:

|               |           |                                           |
|---------------|-----------|-------------------------------------------|
| col_name      | types     | description                               |
| game_id       | character | ESPN game identifier.                     |
| clock         | numeric   | Game clock value in seconds.              |
| display_clock | character | Game clock display value (`MM:SS`).       |
| period        | integer   | Period (quarter) number.                  |
| status_id     | character | ESPN status-type id.                      |
| status_name   | character | Status-type key (e.g. `STATUS_FINAL`).    |
| status_state  | character | Status state (`pre`, `in`, or `post`).    |
| completed     | logical   | `TRUE` if the game is complete.           |
| description   | character | Status description (e.g. `Final`).        |
| detail        | character | Detailed status text.                     |
| short_detail  | character | Short status text.                        |
| status_ref    | character | `$ref` URL to the status resource itself. |

## Details

Wraps the ESPN core-v2 endpoint
`events/{game_id}/competitions/{game_id}/status`. The competition id
always equals the game id. Returns a single-row data frame describing
the game's status. For a completed game `state` is `post` and
`completed` is `TRUE`; for an in-progress game the `clock` and `period`
reflect live game time.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_game_status(game_id = 401628339))
#> ── Game status data from ESPN ──────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 18:42:33 UTC
#> # A tibble: 1 × 12
#>   game_id   clock display_clock period status_id status_name  status_state
#>   <chr>     <dbl> <chr>          <int> <chr>     <chr>        <chr>       
#> 1 401628339     0 0:00               4 3         STATUS_FINAL post        
#> # ℹ 5 more variables: completed <lgl>, description <chr>, detail <chr>,
#> #   short_detail <chr>, status_ref <chr>
# }
```
