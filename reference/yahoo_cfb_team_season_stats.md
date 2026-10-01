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
#> ℹ Data updated: 2026-10-01 10:24:47 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation completion_percentage rushing_yards_per_atte…¹
#>    <chr>        <chr>             <chr>                 <chr>                   
#>  1 Clemson      CLEM              62.1                  5.1                     
#>  2 Duke         DUKE              60.0                  3.2                     
#>  3 Florida St.  FSU               50.4                  2.9                     
#>  4 Georgia Tech GT                65.3                  5.0                     
#>  5 Maryland     UMD               63.8                  3.6                     
#>  6 N. Carolina  UNC               58.7                  4.8                     
#>  7 NC State     NCST              65.2                  4.5                     
#>  8 Virginia     UVA               61.3                  3.7                     
#>  9 Wake Forest  WAKE              61.4                  3.5                     
#> 10 Boston Coll. BC                62.7                  4.1                     
#> # ℹ 124 more rows
#> # ℹ abbreviated name: ¹​rushing_yards_per_attempt
#> # ℹ 97 more variables: interceptions_forced <chr>, team_penalties <chr>,
#> #   rushing_touchdowns_allowed <chr>, points_rank <chr>,
#> #   passing_completions <chr>, total_yards_allowed_per_game <chr>,
#> #   passing_attempts_per_game <chr>, receiving_yards_per_game <chr>,
#> #   total_offensive_yards_per_game <chr>, passing_touchdowns_allowed <chr>, …
# }
```
