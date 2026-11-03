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
#> ℹ Data updated: 2026-11-03 19:00:20 UTC
#> # A tibble: 134 × 101
#>    team       team_abbreviation rushing_yards_rank sacks_yards_lost longest_pass
#>    <chr>      <chr>             <chr>              <chr>            <chr>       
#>  1 Clemson    CLEM              48                 -170             76          
#>  2 Duke       DUKE              130                -94              86          
#>  3 Florida S… FSU               131                -287             71          
#>  4 Georgia T… GT                31                 -36              60          
#>  5 Maryland   UMD               118                -200             75          
#>  6 N. Caroli… UNC               38                 -225             58          
#>  7 NC State   NCST              84                 -150             75          
#>  8 Virginia   UVA               95                 -303             68          
#>  9 Wake Fore… WAKE              98                 -226             51          
#> 10 Boston Co… BC                60                 -178             72          
#> # ℹ 124 more rows
#> # ℹ 96 more variables: longest_rush <chr>, interceptions_forced <chr>,
#> #   interceptions_forced_rank <chr>, receiving_touchdowns_allowed <chr>,
#> #   games_passing <chr>, passing_yards_per_attempt <chr>, points_allowed <chr>,
#> #   passing_first_downs_allowed <chr>, passing_yards_rank <chr>,
#> #   rushing_yards_per_game_rank <chr>, receiving_first_downs_allowed <chr>,
#> #   passing_yards_allowed <chr>, games_kicking <chr>, …
# }
```
