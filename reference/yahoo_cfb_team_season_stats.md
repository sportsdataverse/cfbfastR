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
  try(yahoo_cfb_team_season_stats(season = 2024, count = 10))
#> ── Team season stats from Yahoo Sports (shangrila) ─────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-09 21:18:41 UTC
#> # A tibble: 10 × 101
#>    team         team_abbreviation third_down_conversion…¹ passing_attempts_per…²
#>    <chr>        <chr>             <chr>                   <chr>                 
#>  1 Clemson      CLEM              44.2                    38.1                  
#>  2 Duke         DUKE              29.5                    35.9                  
#>  3 Florida St.  FSU               28.8                    29.6                  
#>  4 Georgia Tech GT                40.6                    31.7                  
#>  5 Maryland     UMD               40.0                    41.2                  
#>  6 N. Carolina  UNC               37.5                    30.2                  
#>  7 NC State     NCST              37.4                    30.1                  
#>  8 Virginia     UVA               34.1                    33.4                  
#>  9 Wake Forest  WAKE              39.2                    33.7                  
#> 10 Boston Coll. BC                43.6                    25.4                  
#> # ℹ abbreviated names: ¹​third_down_conversion_percentage,
#> #   ²​passing_attempts_per_game
#> # ℹ 97 more variables: points_allowed_rank <chr>, completion_percentage <chr>,
#> #   rushing_attempts_per_game <chr>, receptions_allowed <chr>,
#> #   passing_completions <chr>, receiving_yards_rank <chr>,
#> #   team_penalties <chr>, rushing_first_downs <chr>,
#> #   passing_completions_allowed_per_game <chr>, …
# }
```
