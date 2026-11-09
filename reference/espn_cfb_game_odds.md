# **ESPN College Football Game Odds**

Get the sportsbook betting lines (spread, over/under, moneyline) for a
single college football game – one row per provider.

## Usage

``` r
espn_cfb_game_odds(game_id = NULL, line_history = FALSE)
```

## Arguments

- game_id:

  (*Integer* required): ESPN game identifier.

- line_history:

  (*Logical*): controls the output shape. One of:

  - `FALSE` (default) – the summary output, one row per odds provider,
    with the columns shown in the *Value* table below.

  - `TRUE` – a long frame capturing the `open` / `close` / `current`
    line snapshots, one row per (provider x snapshot x market) (see
    *Details*).

## Value

A data frame with one row per odds provider (when
`line_history = FALSE`):

|  |  |  |
|----|----|----|
| col_name | types | description |
| game_id | character | ESPN game identifier. |
| provider_id | character | ESPN odds-provider (sportsbook) id. |
| provider_name | character | Odds-provider name (e.g. `ESPN BET`). |
| provider_priority | integer | ESPN display priority of the odds provider. |
| details | character | ESPN's headline line string (e.g. `UGA -54.5`). |
| over_under | numeric | Game total (over/under) points line. |
| spread | numeric | Point spread (negative favors the home team). |
| over_odds | numeric | American odds price on the over. |
| under_odds | numeric | American odds price on the under. |
| home_favorite | logical | `TRUE` if the home team is the favorite. |
| home_underdog | logical | `TRUE` if the home team is the underdog. |
| away_favorite | logical | `TRUE` if the away team is the favorite. |
| away_underdog | logical | `TRUE` if the away team is the underdog. |
| home_spread_odds | numeric | American odds price on the home-team spread. |
| away_spread_odds | numeric | American odds price on the away-team spread. |
| home_money_line | character | Home-team moneyline (American odds). |
| away_money_line | character | Away-team moneyline (American odds). |
| moneyline_winner | logical | `TRUE` if the moneyline favorite won. |
| spread_winner | logical | `TRUE` if the spread favorite covered. |

## Details

Wraps the ESPN core-v2 endpoint
`events/{game_id}/competitions/{game_id}/odds`. Returns one row per odds
provider (sportsbook). `details` is ESPN's headline line string (e.g.
`"UGA -54.5"`); `spread` and `over_under` are the numeric spread and
total. Home/away spread odds and moneylines are pulled from the nested
`homeTeamOdds` / `awayTeamOdds` blocks. The `over_odds` and `under_odds`
are the American-odds prices on the game total. With
`line_history = TRUE` the per-provider `open` / `close` / `current` line
snapshots are expanded instead (see *Details*).

When `line_history = TRUE` the returned frame is in long format, one row
per (provider x snapshot x market), with columns: `game_id`,
`provider_id`, `provider_name`, `snapshot` (one of `open`, `close`,
`current`), `market` (e.g. `over`, `under`, `total`, `pointSpread`,
`spread`, `moneyLine`), `side` (`game`, `home`, or `away`), `american`
(the American-odds string), `value` (the numeric/decimal value), and
`display_value`.

## See also

[family_espn_cfb](https://cfbfastR.sportsdataverse.org/reference/family_espn_cfb.md)
lists every function in this family.

## Examples

``` r
# \donttest{
  try(espn_cfb_game_odds(game_id = 401628339))
#> ── Game odds data from ESPN ────────────────────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 18:42:27 UTC
#> # A tibble: 2 × 19
#>   game_id  provider_id provider_name provider_priority details over_under spread
#>   <chr>    <chr>       <chr>                     <int> <chr>        <dbl>  <dbl>
#> 1 4016283… 58          ESPN BET                      0 UGA -5…       68.5  -54.5
#> 2 4016283… 59          ESPN Bet - L…                 0 UGA -5…       51.5  -54.5
#> # ℹ 12 more variables: over_odds <dbl>, under_odds <dbl>, home_favorite <lgl>,
#> #   home_underdog <lgl>, away_favorite <lgl>, away_underdog <lgl>,
#> #   home_spread_odds <dbl>, away_spread_odds <dbl>, home_money_line <chr>,
#> #   away_money_line <chr>, moneyline_winner <lgl>, spread_winner <lgl>
  try(espn_cfb_game_odds(game_id = 401628339, line_history = TRUE))
#> ── Game odds line history data from ESPN ───────────────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 18:42:28 UTC
#> # A tibble: 37 × 9
#>    game_id   provider_id provider_name snapshot market      side  american value
#>    <chr>     <chr>       <chr>         <chr>    <chr>       <chr> <chr>    <dbl>
#>  1 401628339 58          ESPN BET      open     over        game  -110      1.91
#>  2 401628339 58          ESPN BET      open     under       game  -110      1.91
#>  3 401628339 58          ESPN BET      open     total       game  62.5      1.91
#>  4 401628339 58          ESPN BET      open     pointSpread home  -54.5     1.95
#>  5 401628339 58          ESPN BET      open     spread      home  -105      1.95
#>  6 401628339 58          ESPN BET      open     pointSpread away  +54.5    NA   
#>  7 401628339 58          ESPN BET      open     spread      away  -115      1.87
#>  8 401628339 58          ESPN BET      close    over        game  +105      2.05
#>  9 401628339 58          ESPN BET      close    under       game  -125      1.8 
#> 10 401628339 58          ESPN BET      close    total       game  68.5     NA   
#> # ℹ 27 more rows
#> # ℹ 1 more variable: display_value <chr>
# }
```
