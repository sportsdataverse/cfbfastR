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
#> ℹ Data updated: 2026-06-12 03:22:08 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation passing_yards_allowed_per_game games_punting
#>    <chr>        <chr>             <chr>                          <chr>        
#>  1 Clemson      CLEM              213.5                          14           
#>  2 Duke         DUKE              213.5                          13           
#>  3 Florida St.  FSU               201.3                          12           
#>  4 Georgia Tech GT                220.7                          13           
#>  5 Maryland     UMD               241.3                          12           
#>  6 N. Carolina  UNC               226.3                          13           
#>  7 NC State     NCST              233.8                          13           
#>  8 Virginia     UVA               263.1                          12           
#>  9 Wake Forest  WAKE              277.8                          12           
#> 10 Boston Coll. BC                245.8                          13           
#> # ℹ 124 more rows
#> # ℹ 97 more variables: passing_completions_allowed_per_game <chr>,
#> #   team_penalties <chr>, receiving_touchdowns_allowed <chr>,
#> #   completion_percentage_allowed <chr>, third_down_attempts <chr>,
#> #   total_yards_allowed_per_game <chr>, passing_first_downs <chr>,
#> #   offensive_penalty_yards_lost <chr>,
#> #   total_offensive_yards_per_game_rank <chr>, fourth_down_attempts <chr>, …
# }
```
