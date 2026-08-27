# **Get a player season overview**

**Get a player season overview** Season overview for a single player.

## Usage

``` r
cfbd_player_season_overview(year, athlete_id, proxy = NULL)
```

## Arguments

- year:

  (*Integer* required): Season, 4 digits (YYYY).  
  Minimum value accepted: 2004

- athlete_id:

  (*Integer* required): Player identifier.

- proxy:

  (*List* optional): Per-call proxy override passed to `get_req()`.
  `NULL` (default) falls back to `getOption("cfbfastR.proxy")` and then
  the `http(s)_proxy` environment variables, so a caller can override
  the shared setting for one endpoint.

## Value

`cfbd_player_season_overview()` - A tibble with 31 columns:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Four-digit season year. |
| id | character | Record identifier. |
| name | character | Display name. |
| position | character | Listed position. |
| team | character | Team name. |
| conference | character | Conference name. |
| games | integer | Games played in the season. |
| usage_overall | numeric | Share of team plays the player was involved in. |
| usage_pass | numeric | Share of team pass plays involving the player. |
| usage_rush | numeric | Share of team rush plays involving the player. |
| usage_first_down | numeric | Usage share on first down. |
| usage_second_down | numeric | Usage share on second down. |
| usage_third_down | numeric | Usage share on third down. |
| usage_standard_downs | numeric | Usage share on standard downs. |
| usage_passing_downs | numeric | Usage share on passing downs. |
| ppa_average_all | numeric | Ppa average all. |
| ppa_average_pass | numeric | Ppa average pass. |
| ppa_average_rush | numeric | Ppa average rush. |
| ppa_average_first_down | numeric | Ppa average first down. |
| ppa_average_second_down | numeric | Ppa average second down. |
| ppa_average_third_down | numeric | Ppa average third down. |
| ppa_average_standard_downs | numeric | Ppa average standard downs. |
| ppa_average_passing_downs | numeric | Ppa average passing downs. |
| ppa_total_all | numeric | Ppa total all. |
| ppa_total_pass | numeric | Ppa total pass. |
| ppa_total_rush | numeric | Ppa total rush. |
| ppa_total_first_down | numeric | Ppa total first down. |
| ppa_total_second_down | numeric | Ppa total second down. |
| ppa_total_third_down | numeric | Ppa total third down. |
| ppa_total_standard_downs | numeric | Ppa total standard downs. |
| ppa_total_passing_downs | numeric | Ppa total passing downs. |

## Examples

``` r
# \donttest{
  try(cfbd_player_season_overview(year = 2024, athlete_id = 4429105))
#> ── Get a player season overview from CollegeFootballData.com ───────────────────
#> ℹ Data updated: 2026-08-27 10:57:10 UTC
#> # A tibble: 1 × 31
#>   season id      name   position team  conference games usage_overall usage_pass
#>    <int> <chr>   <chr>  <chr>    <chr> <chr>      <int>         <dbl>      <dbl>
#> 1   2024 4429105 Arian… WR       Geor… SEC           14         0.065      0.107
#> # ℹ 22 more variables: usage_rush <dbl>, usage_first_down <dbl>,
#> #   usage_second_down <dbl>, usage_third_down <dbl>,
#> #   usage_standard_downs <dbl>, usage_passing_downs <dbl>,
#> #   ppa_average_all <dbl>, ppa_average_pass <dbl>, ppa_average_rush <dbl>,
#> #   ppa_average_first_down <dbl>, ppa_average_second_down <dbl>,
#> #   ppa_average_third_down <dbl>, ppa_average_standard_downs <dbl>,
#> #   ppa_average_passing_downs <dbl>, ppa_total_all <dbl>, …
# }
```
