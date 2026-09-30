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
#> ℹ Data updated: 2026-09-30 19:47:29 UTC
#> # A tibble: 134 × 101
#>    team        team_abbreviation longest_rush games_offense fourth_down_attempts
#>    <chr>       <chr>             <chr>        <chr>         <chr>               
#>  1 Clemson     CLEM              83           14            21                  
#>  2 Duke        DUKE              44           13            18                  
#>  3 Florida St. FSU               42           12            32                  
#>  4 Georgia Te… GT                68           13            29                  
#>  5 Maryland    UMD               75           12            31                  
#>  6 N. Carolina UNC               75           13            27                  
#>  7 NC State    NCST              94           13            20                  
#>  8 Virginia    UVA               75           12            29                  
#>  9 Wake Forest WAKE              60           12            25                  
#> 10 Boston Col… BC                47           13            37                  
#> # ℹ 124 more rows
#> # ℹ 96 more variables: total_yards_allowed_per_game_rank <chr>,
#> #   rushing_yards_per_attempt <chr>, points_allowed_rank <chr>,
#> #   sacks_taken <chr>, rushing_yards_allowed <chr>,
#> #   completion_percentage_allowed <chr>, team_penalties <chr>,
#> #   games_punting <chr>, time_of_possession_per_game <chr>,
#> #   games_defense <chr>, receiving_yards_allowed <chr>, points_rank <chr>, …
# }
```
