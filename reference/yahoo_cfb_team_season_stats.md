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
#> ℹ Data updated: 2026-09-30 22:03:16 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation points_per_game_rank total_offensive_yards_r…¹
#>    <chr>        <chr>             <chr>                <chr>                    
#>  1 Clemson      CLEM              32                   12                       
#>  2 Duke         DUKE              137                  110                      
#>  3 Florida St.  FSU               269                  134                      
#>  4 Georgia Tech GT                99                   36                       
#>  5 Maryland     UMD               178                  68                       
#>  6 N. Carolina  UNC               72                   49                       
#>  7 NC State     NCST              108                  77                       
#>  8 Virginia     UVA               197                  94                       
#>  9 Wake Forest  WAKE              148                  86                       
#> 10 Boston Coll. BC                116                  91                       
#> # ℹ 124 more rows
#> # ℹ abbreviated name: ¹​total_offensive_yards_rank
#> # ℹ 97 more variables: passing_completions <chr>, passing_yards_rank <chr>,
#> #   rushing_yards_allowed_per_attempt <chr>, games_passing <chr>, points <chr>,
#> #   third_down_conversion_percentage <chr>, games_rushing <chr>,
#> #   total_yards_allowed_per_game_rank <chr>, points_per_game <chr>,
#> #   rushing_touchdowns_allowed <chr>, points_rank <chr>, …
# }
```
