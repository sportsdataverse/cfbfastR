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
#> ℹ Data updated: 2026-11-01 03:20:59 UTC
#> # A tibble: 134 × 101
#>    team         team_abbreviation third_down_attempts interceptions_forced_rank
#>    <chr>        <chr>             <chr>               <chr>                    
#>  1 Clemson      CLEM              197                 24                       
#>  2 Duke         DUKE              176                 65                       
#>  3 Florida St.  FSU               160                 238                      
#>  4 Georgia Tech GT                170                 226                      
#>  5 Maryland     UMD               180                 148                      
#>  6 N. Carolina  UNC               176                 148                      
#>  7 NC State     NCST              155                 124                      
#>  8 Virginia     UVA               182                 148                      
#>  9 Wake Forest  WAKE              171                 102                      
#> 10 Boston Coll. BC                179                 14                       
#> # ℹ 124 more rows
#> # ℹ 97 more variables: receiving_yards_per_game <chr>, games_kicking <chr>,
#> #   passing_attempts <chr>, receiving_yards_allowed_per_game <chr>,
#> #   time_of_possession_per_game <chr>,
#> #   passing_completions_allowed_per_game <chr>,
#> #   passing_attempts_allowed_per_game <chr>,
#> #   rushing_yards_allowed_per_game <chr>, fourth_down_attempts <chr>, …
# }
```
