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
#> ℹ Data updated: 2026-08-27 16:47:15 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation rushing_yards_per_atte…¹ receiving_first_downs
#>    <chr>        <chr>             <chr>                    <chr>                
#>  1 Clemson      CLEM              5.1                      170                  
#>  2 Duke         DUKE              3.2                      141                  
#>  3 Florida St.  FSU               2.9                      103                  
#>  4 Georgia Tech GT                5.0                      138                  
#>  5 Maryland     UMD               3.6                      157                  
#>  6 N. Carolina  UNC               4.8                      122                  
#>  7 NC State     NCST              4.5                      137                  
#>  8 Virginia     UVA               3.7                      116                  
#>  9 Wake Forest  WAKE              3.5                      137                  
#> 10 Boston Coll. BC                4.1                      112                  
#> # ℹ 124 more rows
#> # ℹ abbreviated name: ¹​rushing_yards_per_attempt
#> # ℹ 97 more variables: games_defense <chr>,
#> #   total_offensive_yards_per_game_rank <chr>, third_down_conversions <chr>,
#> #   total_yards_allowed_per_game <chr>, rushing_attempts_per_game <chr>,
#> #   points_allowed_per_game <chr>, passing_interceptions <chr>,
#> #   rushing_attempts_allowed_per_game <chr>, …
# }
```
