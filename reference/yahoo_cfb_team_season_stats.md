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
#> ℹ Data updated: 2026-08-19 17:43:53 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation third_down_conversion_…¹ completion_percentage
#>    <chr>        <chr>             <chr>                    <chr>                
#>  1 Clemson      CLEM              44.2                     62.1                 
#>  2 Duke         DUKE              29.5                     60.0                 
#>  3 Florida St.  FSU               28.8                     50.4                 
#>  4 Georgia Tech GT                40.6                     65.3                 
#>  5 Maryland     UMD               40.0                     63.8                 
#>  6 N. Carolina  UNC               37.5                     58.7                 
#>  7 NC State     NCST              37.4                     65.2                 
#>  8 Virginia     UVA               34.1                     61.3                 
#>  9 Wake Forest  WAKE              39.2                     61.4                 
#> 10 Boston Coll. BC                43.6                     62.7                 
#> # ℹ 124 more rows
#> # ℹ abbreviated name: ¹​third_down_conversion_percentage
#> # ℹ 97 more variables: passing_completions_per_game <chr>,
#> #   passing_yards_allowed_per_game_rank <chr>, receiving_yards_per_game <chr>,
#> #   rushing_touchdowns_allowed <chr>, rushing_yards <chr>,
#> #   passing_completions <chr>, passing_attempts_per_game <chr>,
#> #   interceptions_forced <chr>, receiving_first_downs_allowed <chr>, …
# }
```
