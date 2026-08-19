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
#> ── Team season stats from Yahoo Sports (shangrila) ─────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-08-19 12:33:51 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation receiving_yards_rank receptions_allowed_per_…¹
#>    <chr>        <chr>             <chr>                <chr>                    
#>  1 Clemson      CLEM              15                   18.8                     
#>  2 Duke         DUKE              46                   18.9                     
#>  3 Florida St.  FSU               118                  17.0                     
#>  4 Georgia Tech GT                56                   19.5                     
#>  5 Maryland     UMD               17                   20.0                     
#>  6 N. Carolina  UNC               74                   16.7                     
#>  7 NC State     NCST              60                   20.1                     
#>  8 Virginia     UVA               66                   20.3                     
#>  9 Wake Forest  WAKE              51                   26.7                     
#> 10 Boston Coll. BC                100                  20.8                     
#> # ℹ 124 more rows
#> # ℹ abbreviated name: ¹​receptions_allowed_per_game
#> # ℹ 97 more variables: time_of_possession_per_game_rank <chr>,
#> #   receiving_first_downs <chr>, rushing_attempts <chr>,
#> #   total_offensive_yards_per_game_rank <chr>, passing_first_downs <chr>,
#> #   interceptions_forced_rank <chr>, passing_attempts <chr>,
#> #   points_allowed_rank <chr>, receiving_yards <chr>, …
# }
```
