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
#> ℹ Data updated: 2026-10-12 09:47:39 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation third_down_conversions rushing_first_downs
#>    <chr>        <chr>             <chr>                  <chr>              
#>  1 Clemson      CLEM              87                     139                
#>  2 Duke         DUKE              52                     60                 
#>  3 Florida St.  FSU               46                     64                 
#>  4 Georgia Tech GT                69                     127                
#>  5 Maryland     UMD               72                     75                 
#>  6 N. Carolina  UNC               66                     124                
#>  7 NC State     NCST              58                     96                 
#>  8 Virginia     UVA               62                     99                 
#>  9 Wake Forest  WAKE              67                     93                 
#> 10 Boston Coll. BC                78                     115                
#> # ℹ 124 more rows
#> # ℹ 97 more variables: total_offensive_yards_per_game <chr>,
#> #   time_of_possession_per_game_rank <chr>,
#> #   fourth_down_conversion_percentage <chr>, passing_yards_allowed <chr>,
#> #   longest_rush <chr>, total_yards_allowed_per_game <chr>,
#> #   games_offense <chr>, passing_first_downs <chr>,
#> #   rushing_yards_allowed_per_game <chr>, …
# }
```
