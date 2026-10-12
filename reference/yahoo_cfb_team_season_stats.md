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
#> ℹ Data updated: 2026-10-12 10:13:13 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation fourth_down_conversio…¹ team_penalty_yards_l…²
#>    <chr>        <chr>             <chr>                   <chr>                 
#>  1 Clemson      CLEM              57.1                    667                   
#>  2 Duke         DUKE              38.9                    651                   
#>  3 Florida St.  FSU               62.5                    575                   
#>  4 Georgia Tech GT                55.2                    558                   
#>  5 Maryland     UMD               45.2                    703                   
#>  6 N. Carolina  UNC               48.1                    832                   
#>  7 NC State     NCST              55.0                    621                   
#>  8 Virginia     UVA               51.7                    544                   
#>  9 Wake Forest  WAKE              64.0                    551                   
#> 10 Boston Coll. BC                45.9                    560                   
#> # ℹ 124 more rows
#> # ℹ abbreviated names: ¹​fourth_down_conversion_percentage,
#> #   ²​team_penalty_yards_lost
#> # ℹ 97 more variables: games_defense <chr>, points_allowed_per_game_rank <chr>,
#> #   passing_first_downs_allowed <chr>, games_punting <chr>,
#> #   completion_percentage_allowed <chr>, games_receiving <chr>,
#> #   receiving_yards_allowed_per_game <chr>, rushing_touchdowns_allowed <chr>, …
# }
```
