# **Load college football advanced passing from the SportsDataverse data repo**

Loads season-level advanced passing stats – one row per qualifying
passer with EPA, CPOE, air-yards, and pressure splits. Published to the
`espn_cfb_adv_passing` release tag on the sportsdataverse-data repo.

## Usage

``` r
load_espn_cfb_adv_passing(
  seasons = most_recent_cfb_season(),
  ...,
  dbConnection = NULL,
  tablename = NULL
)
```

## Arguments

- seasons:

  A vector of 4-digit years associated with given college football
  seasons. Published coverage runs 2004 through the most recent season.
  Pass `seasons = TRUE` for every published season. (Min: 2004)

- ...:

  Additional arguments passed to an underlying function that writes the
  season data into a database.

- dbConnection:

  A `DBIConnection` object, as returned by
  [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html)

- tablename:

  The name of the data table within the database

## Value

Returns a `cfbfastR_data` tibble.

|  |  |  |
|----|----|----|
| col_name | types | description |
| pos_team_id | integer | ESPN team id of the team on offense. Present for every season 2004+. |
| pos_team | character |  |
| passer_player_name | character | Display name of the passer – the FIRST participant in that role on the play. |
| Comp | integer | Completed passes recorded in the advanced box score. |
| Att | integer | Pass attempts recorded in the advanced box score. |
| xComp | double | Expected completions, summed from the per-play completion model. |
| Yds | double | Passing yards from the advanced box score. |
| Pass_TD | integer | Passing touchdowns. |
| Int | integer | Interceptions thrown. |
| YPA | double | Yards per pass attempt. |
| EPA | double |  |
| EPA_per_Play | double | EPA per play on the passer's plays. |
| WPA | double |  |
| SR | double | Success rate on the passer's plays. |
| Sck | integer | Times the passer was sacked. |
| CompPct | double | Completion percentage from the advanced box score. |
| xCompPct | double | Expected completion percentage from the per-play completion model. |
| CPOE | double | Completion percentage over expected – actual minus modelled completion rate. |
| qbr_epa | double | EPA variant used as an input to the QBR calculation. |
| sack_epa | double | EPA credited to the player's sacks taken. |
| pass_epa | double | EPA credited to the player's pass plays. |
| rush_epa | double | EPA credited to the player's rush plays. |
| pen_epa | double | EPA attributable to penalties on the player's plays. |
| spread | double |  |
| era0 | integer | Rule-era indicator for the earliest modelled era. |
| era1 | integer | Rule-era indicator for the second modelled era. |
| era2 | integer | Rule-era indicator for the third modelled era. |
| era3 | integer | Rule-era indicator for the most recent modelled era. |
| exp_qbr | double | Expected QBR for the passer. |
| game_id | integer |  |
| season | integer |  |
| week | integer |  |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_espn_cfb_adv_passing(2004))
#> ── college football advanced passing from the SportsDataverse data repo ────────
#> ℹ Data updated: 2026-08-24 11:39:45 UTC
#> # A tibble: 1,234 × 32
#>    pos_team_id pos_team passer_player_name  Comp   Att xComp   Yds Pass_TD   Int
#>          <int> <chr>    <chr>              <int> <int> <dbl> <dbl>   <int> <int>
#>  1          30 USC Tro… Matt Leinart          17    27 16.6     96       3     0
#>  2         259 Virgini… Bryan Randall         12    26 17.5    102       1     0
#>  3         245 Texas A… Reggie McNeal         11    32 16.9    154       0     0
#>  4         254 Utah Ut… Alex Smith            20    28 17.2    218       3     0
#>  5         245 Texas A… Ty Branyon             4     6  2.91    34       0     0
#>  6        2050 Ball St… Joey Lynch            16    30 19.0    109       0     0
#>  7         103 Boston … Paul Peterson         11    21 12.4     97       1     0
#>  8          77 Northwe… Brett Basanez         35    56 29.5    323       4     0
#>  9        2628 TCU Hor… Tye Gunn              19    35 20.6    196       4     0
#> 10        2638 UTEP Mi… Jordan Palmer         16    36 20.3    114       1     1
#> # ℹ 1,224 more rows
#> # ℹ 23 more variables: YPA <dbl>, EPA <dbl>, EPA_per_Play <dbl>, WPA <dbl>,
#> #   SR <dbl>, Sck <int>, CompPct <dbl>, xCompPct <dbl>, CPOE <dbl>,
#> #   qbr_epa <dbl>, sack_epa <lgl>, pass_epa <dbl>, rush_epa <dbl>,
#> #   pen_epa <lgl>, spread <dbl>, era0 <int>, era1 <int>, era2 <int>,
#> #   era3 <int>, exp_qbr <dbl>, game_id <int>, season <int>, week <int>
# }
```
