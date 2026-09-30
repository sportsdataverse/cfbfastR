# **Get Yahoo Sports college football team season stats (modern)**

Flattens the shangrila `leagueStatsByTeam` response into one wide tibble
with one row per team (all stat groups in one call).

## Usage

``` r
yahoo_cfb_team_season_stats(
  season = most_recent_cfb_season(),
  league_structure = "ncaaf.struct.div.1",
  count = 200
)
```

## Arguments

- season:

  (integer): Season year. Defaults to `most_recent_cfb_season()`.

- league_structure:

  (character): Division filter. Defaults to `"ncaaf.struct.div.1"`.

- count:

  (integer): Max teams. Defaults to `200`.

## Value

A `cfbfastR`-tagged tibble with one row per team: `team`,
`team_abbreviation`, `season`, plus one column per `statId`.

## See also

Other Yahoo CFB Functions:
[`yahoo_cfb_boxscore()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_boxscore.md),
[`yahoo_cfb_player_season_stats()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_player_season_stats.md),
[`yahoo_cfb_player_season_stats_legacy()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_player_season_stats_legacy.md),
[`yahoo_cfb_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_scoreboard.md),
[`yahoo_cfb_team_season_stats_legacy()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_team_season_stats_legacy.md)

## Examples

``` r
# \donttest{
  try(yahoo_cfb_team_season_stats(season = 2024))
#> ── Team season stats from Yahoo Sports (shangrila) ────── cfbfastR 3.0.0.9000 ──
#> ℹ Data updated: 2026-09-30 09:49:27 UTC
#> # A tibble: 134 × 101
#>    team        team_abbreviation games_defense receptions third_down_conversio…¹
#>    <chr>       <chr>             <chr>         <chr>      <chr>                 
#>  1 Clemson     CLEM              14            331        44.2                  
#>  2 Duke        DUKE              13            280        29.5                  
#>  3 Florida St. FSU               12            179        28.8                  
#>  4 Georgia Te… GT                13            269        40.6                  
#>  5 Maryland    UMD               12            315        40.0                  
#>  6 N. Carolina UNC               13            230        37.5                  
#>  7 NC State    NCST              13            255        37.4                  
#>  8 Virginia    UVA               12            246        34.1                  
#>  9 Wake Forest WAKE              12            248        39.2                  
#> 10 Boston Col… BC                13            207        43.6                  
#> # ℹ 124 more rows
#> # ℹ abbreviated name: ¹​third_down_conversion_percentage
#> # ℹ 96 more variables: games_passing <chr>, passing_attempts_per_game <chr>,
#> #   points_per_game_rank <chr>, rushing_first_downs <chr>,
#> #   rushing_touchdowns <chr>, fourth_down_conversion_percentage <chr>,
#> #   passing_yards_allowed <chr>, fourth_down_conversions <chr>,
#> #   points_per_game <chr>, receptions_per_game <chr>, …
# }
```
