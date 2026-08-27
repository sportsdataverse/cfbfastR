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
#> ℹ Data updated: 2026-08-27 11:04:55 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation first_downs receiving_yards_per_game
#>    <chr>        <chr>             <chr>       <chr>                   
#>  1 Clemson      CLEM              337         279.1                   
#>  2 Duke         DUKE              229         244.6                   
#>  3 Florida St.  FSU               182         180.3                   
#>  4 Georgia Tech GT                282         237.5                   
#>  5 Maryland     UMD               259         276.7                   
#>  6 N. Carolina  UNC               272         224.5                   
#>  7 NC State     NCST              263         233.2                   
#>  8 Virginia     UVA               234         229.0                   
#>  9 Wake Forest  WAKE              262         240.1                   
#> 10 Boston Coll. BC                251         199.3                   
#> # ℹ 124 more rows
#> # ℹ 97 more variables: passing_yards_allowed_per_game_rank <chr>,
#> #   total_offensive_yards <chr>, receiving_yards <chr>,
#> #   receiving_yards_allowed <chr>, first_downs_per_game <chr>,
#> #   passing_attempts_allowed_per_game <chr>, sacks_rank <chr>,
#> #   rushing_yards_allowed_per_attempt <chr>, third_down_conversions <chr>,
#> #   team_penalties <chr>, rushing_touchdowns_allowed <chr>, …
# }
```
