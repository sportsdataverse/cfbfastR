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
#> ℹ Data updated: 2026-09-30 15:21:37 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation team_penalties games_punting games_passing
#>    <chr>        <chr>             <chr>          <chr>         <chr>        
#>  1 Clemson      CLEM              69             14            14           
#>  2 Duke         DUKE              67             13            13           
#>  3 Florida St.  FSU               67             12            12           
#>  4 Georgia Tech GT                69             13            13           
#>  5 Maryland     UMD               77             12            12           
#>  6 N. Carolina  UNC               98             13            13           
#>  7 NC State     NCST              66             13            13           
#>  8 Virginia     UVA               62             12            12           
#>  9 Wake Forest  WAKE              61             12            12           
#> 10 Boston Coll. BC                58             13            13           
#> # ℹ 124 more rows
#> # ℹ 96 more variables: passing_completions <chr>, games_kicking <chr>,
#> #   passing_yards_allowed_per_game <chr>, rushing_yards_allowed <chr>,
#> #   receiving_yards_per_reception <chr>, receptions_allowed <chr>,
#> #   passing_completions_per_game <chr>,
#> #   passing_yards_allowed_per_game_rank <chr>, offensive_penalties <chr>,
#> #   sacks_yards_lost <chr>, offensive_penalty_yards_lost <chr>, …
# }
```
