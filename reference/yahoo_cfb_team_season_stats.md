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
#> ℹ Data updated: 2026-09-30 13:22:56 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation passing_attempts_allo…¹ rushing_yards_per_at…²
#>    <chr>        <chr>             <chr>                   <chr>                 
#>  1 Clemson      CLEM              33.4                    5.1                   
#>  2 Duke         DUKE              32.6                    3.2                   
#>  3 Florida St.  FSU               27.2                    2.9                   
#>  4 Georgia Tech GT                30.8                    5.0                   
#>  5 Maryland     UMD               32.0                    3.6                   
#>  6 N. Carolina  UNC               28.8                    4.8                   
#>  7 NC State     NCST              32.8                    4.5                   
#>  8 Virginia     UVA               32.7                    3.7                   
#>  9 Wake Forest  WAKE              37.9                    3.5                   
#> 10 Boston Coll. BC                33.9                    4.1                   
#> # ℹ 124 more rows
#> # ℹ abbreviated names: ¹​passing_attempts_allowed_per_game,
#> #   ²​rushing_yards_per_attempt
#> # ℹ 97 more variables: sacks_yards_lost <chr>,
#> #   passing_touchdowns_allowed_per_game <chr>, passing_yards_per_game <chr>,
#> #   third_down_conversion_percentage <chr>, passing_completions <chr>,
#> #   rushing_yards_allowed_per_attempt <chr>, …
# }
```
