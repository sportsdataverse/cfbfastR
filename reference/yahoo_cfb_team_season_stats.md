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
#> ── Team season stats from Yahoo Sports (shangrila) ─────────── cfbfastR 3.1.0 ──
#> ℹ Data updated: 2026-11-03 10:16:52 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation sacks_taken receiving_yards_allowed_per_game
#>    <chr>        <chr>             <chr>       <chr>                           
#>  1 Clemson      CLEM              25          213.5                           
#>  2 Duke         DUKE              12          213.5                           
#>  3 Florida St.  FSU               49          201.3                           
#>  4 Georgia Tech GT                9           220.7                           
#>  5 Maryland     UMD               26          241.3                           
#>  6 N. Carolina  UNC               33          226.3                           
#>  7 NC State     NCST              28          233.8                           
#>  8 Virginia     UVA               47          263.1                           
#>  9 Wake Forest  WAKE              41          277.8                           
#> 10 Boston Coll. BC                32          245.8                           
#> # ℹ 124 more rows
#> # ℹ 97 more variables: total_yards_allowed_per_game_rank <chr>,
#> #   passing_interceptions <chr>, total_offensive_yards_rank <chr>,
#> #   games_punting <chr>, fourth_down_attempts <chr>,
#> #   receiving_yards_rank <chr>, passing_touchdowns_allowed_per_game <chr>,
#> #   sacks_yards_lost <chr>, offensive_penalties <chr>,
#> #   receiving_first_downs <chr>, passing_first_downs <chr>, …
# }
```
