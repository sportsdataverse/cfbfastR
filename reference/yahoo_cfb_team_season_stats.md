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
#> ── Team season stats from Yahoo Sports (shangrila) ─────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-27 04:25:15 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation longest_rush time_of_possession_per_game
#>    <chr>        <chr>             <chr>        <chr>                      
#>  1 Clemson      CLEM              83           30:31                      
#>  2 Duke         DUKE              44           27:05                      
#>  3 Florida St.  FSU               42           27:11                      
#>  4 Georgia Tech GT                68           30:51                      
#>  5 Maryland     UMD               75           30:07                      
#>  6 N. Carolina  UNC               75           29:39                      
#>  7 NC State     NCST              94           31:45                      
#>  8 Virginia     UVA               75           29:54                      
#>  9 Wake Forest  WAKE              60           28:59                      
#> 10 Boston Coll. BC                47           31:43                      
#> # ℹ 124 more rows
#> # ℹ 97 more variables: fourth_down_attempts <chr>,
#> #   rushing_yards_per_attempt <chr>, points_allowed_per_game_rank <chr>,
#> #   sacks_taken <chr>, rushing_yards_allowed_per_attempt <chr>,
#> #   passing_touchdowns_allowed <chr>, team_penalties <chr>,
#> #   games_punting <chr>, time_of_possession_per_game_rank <chr>,
#> #   games_defense <chr>, receiving_yards_allowed_per_game <chr>, …
# }
```
