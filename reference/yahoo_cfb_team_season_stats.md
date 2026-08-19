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
#> ℹ Data updated: 2026-08-19 18:03:36 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation offensive_penalties points_allowed
#>    <chr>        <chr>             <chr>               <chr>         
#>  1 Clemson      CLEM              69                  328           
#>  2 Duke         DUKE              67                  318           
#>  3 Florida St.  FSU               67                  336           
#>  4 Georgia Tech GT                69                  333           
#>  5 Maryland     UMD               77                  365           
#>  6 N. Carolina  UNC               98                  365           
#>  7 NC State     NCST              66                  392           
#>  8 Virginia     UVA               62                  345           
#>  9 Wake Forest  WAKE              61                  390           
#> 10 Boston Coll. BC                58                  309           
#> # ℹ 124 more rows
#> # ℹ 97 more variables: passing_completions <chr>, games_rushing <chr>,
#> #   passing_yards_allowed <chr>, rushing_attempts_allowed_per_game <chr>,
#> #   points <chr>, receiving_yards_per_game <chr>,
#> #   total_offensive_yards_rank <chr>, sacks_yards_lost <chr>,
#> #   passing_yards_allowed_per_game <chr>, sacks_taken <chr>,
#> #   points_allowed_per_game_rank <chr>, passing_first_downs_allowed <chr>, …
# }
```
