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
#> ℹ Data updated: 2026-11-09 17:05:44 UTC
#> # A tibble: 10 × 101
#>    team         team_abbreviation games_offense points_per_game_rank
#>    <chr>        <chr>             <chr>         <chr>               
#>  1 Clemson      CLEM              14            32                  
#>  2 Duke         DUKE              13            137                 
#>  3 Florida St.  FSU               12            269                 
#>  4 Georgia Tech GT                13            99                  
#>  5 Maryland     UMD               12            178                 
#>  6 N. Carolina  UNC               13            72                  
#>  7 NC State     NCST              13            108                 
#>  8 Virginia     UVA               12            197                 
#>  9 Wake Forest  WAKE              12            148                 
#> 10 Boston Coll. BC                13            116                 
#> # ℹ 97 more variables: completion_percentage <chr>,
#> #   time_of_possession_per_game <chr>, passing_first_downs_allowed <chr>,
#> #   total_offensive_yards <chr>, rushing_yards_per_game_rank <chr>,
#> #   interception_return_touchdowns <chr>, rushing_attempts_allowed <chr>,
#> #   receptions_allowed <chr>, team_penalties <chr>,
#> #   total_offensive_yards_per_game_rank <chr>,
#> #   receiving_yards_allowed_per_game <chr>, games_rushing <chr>, …
# }
```
