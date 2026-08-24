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
#> ℹ Data updated: 2026-08-24 14:52:51 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation receiving_yards_per_g…¹ receiving_first_down…²
#>    <chr>        <chr>             <chr>                   <chr>                 
#>  1 Clemson      CLEM              279.1                   133                   
#>  2 Duke         DUKE              244.6                   123                   
#>  3 Florida St.  FSU               180.3                   110                   
#>  4 Georgia Tech GT                237.5                   125                   
#>  5 Maryland     UMD               276.7                   126                   
#>  6 N. Carolina  UNC               224.5                   112                   
#>  7 NC State     NCST              233.2                   133                   
#>  8 Virginia     UVA               229.0                   123                   
#>  9 Wake Forest  WAKE              240.1                   170                   
#> 10 Boston Coll. BC                199.3                   153                   
#> # ℹ 124 more rows
#> # ℹ abbreviated names: ¹​receiving_yards_per_game,
#> #   ²​receiving_first_downs_allowed
#> # ℹ 97 more variables: games_defense <chr>, points_rank <chr>,
#> #   interceptions_forced <chr>, receiving_yards_per_reception <chr>,
#> #   rushing_yards_per_game <chr>, completion_percentage <chr>,
#> #   fourth_down_attempts <chr>, passing_completions <chr>, …
# }
```
