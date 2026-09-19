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
#> ℹ Data updated: 2026-09-19 03:05:09 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation fourth_down_attempts offensive_penalty_yards…¹
#>    <chr>        <chr>             <chr>                <chr>                    
#>  1 Clemson      CLEM              21                   667                      
#>  2 Duke         DUKE              18                   651                      
#>  3 Florida St.  FSU               32                   575                      
#>  4 Georgia Tech GT                29                   558                      
#>  5 Maryland     UMD               31                   703                      
#>  6 N. Carolina  UNC               27                   832                      
#>  7 NC State     NCST              20                   621                      
#>  8 Virginia     UVA               29                   544                      
#>  9 Wake Forest  WAKE              25                   551                      
#> 10 Boston Coll. BC                37                   560                      
#> # ℹ 124 more rows
#> # ℹ abbreviated name: ¹​offensive_penalty_yards_lost
#> # ℹ 97 more variables: points_allowed_per_game <chr>,
#> #   passing_touchdowns_allowed <chr>, receiving_yards_per_reception <chr>,
#> #   passing_attempts_allowed_per_game <chr>, rushing_touchdowns <chr>,
#> #   receptions_allowed_per_game <chr>, rushing_yards_allowed_per_game <chr>,
#> #   points_per_game_rank <chr>, points_allowed_rank <chr>, …
# }
```
