# **Get player season rushing production, split by run direction**

**Get player season rushing production, split by run direction**

## Usage

``` r
cfbd_rushing_players_season(
  year = NULL,
  season_type = NULL,
  team = NULL,
  conference = NULL,
  rusher_id = NULL,
  classification = NULL
)
```

## Arguments

- year:

  (*Integer* optional): Year, 4 digit format (*YYYY*)  
  Minimum value accepted: 2025

- season_type:

  (*String* optional): Season type - regular, postseason, both, allstar,
  spring_regular, spring_postseason

- team:

  (*String* optional): D-I Team

- conference:

  (*String* optional): Conference abbreviation - Select a valid FBS
  conference Conference abbreviations P5: ACC, B12, B1G, SEC, PAC
  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind,
  SBC, AAC

- rusher_id:

  (*String* optional): CFBD athlete id of the rusher to filter on.

- classification:

  (*String* optional): Division classification - fbs, fcs, ii, ii/iii,
  iii

## Value

`cfbd_rushing_players_season()` - A data frame with 89 variables:

|  |  |  |
|----|----|----|
| col_name | types | description |
| season | integer | Four-digit season year (e.g. 2025). |
| player_id | character | CFBD athlete identifier (use with [`cfbd_player_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_info.md)). |
| player | character | Player full name. |
| team | character | Team name. |
| conference | character | Team conference name. |

plus the 24-column rushing production block and its four `directions_*`
repeats – both described under **The rushing production block** and
**Direction splits** in
[cfbd_rushing](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing.md).

## See also

Other CFBD Rushing:
[`cfbd_rushing_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_players_games.md),
[`cfbd_rushing_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_plays.md),
[`cfbd_rushing_teams_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_teams_games.md),
[`cfbd_rushing_teams_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rushing_teams_season.md)

## Examples

``` r
# \donttest{
  try(cfbd_rushing_players_season(year = 2025, team = "Texas"))
#> ── Player season rushing data from CollegeFootballData.com ─────────────────────
#> ℹ Data updated: 2026-09-10 05:44:29 UTC
#> # A tibble: 11 × 89
#>    season player_id player      team  conference attempts rushing_yards_availa…¹
#>     <int> <chr>     <chr>       <chr> <chr>         <int>                  <int>
#>  1   2025 4870906   Arch Manni… Texas SEC              88                     88
#>  2   2025 5127724   Christian … Texas SEC              26                     26
#>  3   2025 4870609   CJ Baxter … Texas SEC              24                     24
#>  4   2025 5141686   James Simon Texas SEC              25                     25
#>  5   2025 5079410   Jerrick Gi… Texas SEC              33                     33
#>  6   2025 4877717   Matthew Ca… Texas SEC               1                      1
#>  7   2025 5141729   Michael Te… Texas SEC               1                      1
#>  8   2025 5195299   Nick Towns… Texas SEC               2                      2
#>  9   2025 4899367   Ryan Nible… Texas SEC               5                      5
#> 10   2025 5218633   Ryan Wingo  Texas SEC               7                      7
#> 11   2025 4871076   Tre Wisner  Texas SEC             130                    130
#> # ℹ abbreviated name: ¹​rushing_yards_available
#> # ℹ 82 more variables: total_rushing_yards <int>, yards_per_carry <dbl>,
#> #   individual_attempts <int>, unattributed_attempts <int>, sacks <int>,
#> #   kneels <int>, team_rushes <int>, multi_carrier_attempts <int>,
#> #   direction_eligible_attempts <int>, direction_available_attempts <int>,
#> #   success_rate <dbl>, ppa <dbl>, total_ppa <dbl>, line_yards <dbl>,
#> #   line_yards_total <dbl>, second_level_yards <dbl>, …
# }
```
