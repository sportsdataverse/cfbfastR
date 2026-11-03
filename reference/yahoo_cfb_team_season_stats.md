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
#> ── Team season stats from Yahoo Sports (shangrila) ─────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-03 12:17:37 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation passing_interceptions receptions_per_game
#>    <chr>        <chr>             <chr>                 <chr>              
#>  1 Clemson      CLEM              7                     23.6               
#>  2 Duke         DUKE              13                    21.5               
#>  3 Florida St.  FSU               13                    14.9               
#>  4 Georgia Tech GT                7                     20.7               
#>  5 Maryland     UMD               14                    26.3               
#>  6 N. Carolina  UNC               9                     17.7               
#>  7 NC State     NCST              13                    19.6               
#>  8 Virginia     UVA               14                    20.5               
#>  9 Wake Forest  WAKE              13                    20.7               
#> 10 Boston Coll. BC                7                     15.9               
#> # ℹ 124 more rows
#> # ℹ 97 more variables: receiving_yards_allowed <chr>,
#> #   total_offensive_yards_rank <chr>, passing_touchdowns <chr>,
#> #   passing_completions <chr>, sacks_rank <chr>,
#> #   points_allowed_per_game_rank <chr>, rushing_yards_allowed <chr>,
#> #   first_downs_per_game <chr>, games_kicking <chr>,
#> #   points_allowed_per_game <chr>, passing_attempts_per_game <chr>, …
# }
```
