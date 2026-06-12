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
#> ℹ Data updated: 2026-06-12 13:51:46 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation games_defense passing_interceptions
#>    <chr>        <chr>             <chr>         <chr>                
#>  1 Clemson      CLEM              14            7                    
#>  2 Duke         DUKE              13            13                   
#>  3 Florida St.  FSU               12            13                   
#>  4 Georgia Tech GT                13            7                    
#>  5 Maryland     UMD               12            14                   
#>  6 N. Carolina  UNC               13            9                    
#>  7 NC State     NCST              13            13                   
#>  8 Virginia     UVA               12            14                   
#>  9 Wake Forest  WAKE              12            13                   
#> 10 Boston Coll. BC                13            7                    
#> # ℹ 124 more rows
#> # ℹ 97 more variables: rushing_touchdowns_allowed <chr>,
#> #   passing_yards_per_game_rank <chr>, receptions_allowed <chr>,
#> #   total_offensive_yards_per_game <chr>, fourth_down_conversions <chr>,
#> #   receptions_allowed_per_game <chr>, games_passing <chr>,
#> #   rushing_yards_allowed <chr>, passing_yards_per_game <chr>,
#> #   passing_first_downs <chr>, passing_yards_allowed_per_game <chr>, …
# }
```
