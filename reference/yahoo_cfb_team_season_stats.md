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
#> ℹ Data updated: 2026-09-07 02:16:18 UTC
#> # A tibble: 134 × 101
#>    team        team_abbreviation receptions points_allowed_per_g…¹ games_kicking
#>    <chr>       <chr>             <chr>      <chr>                  <chr>        
#>  1 Clemson     CLEM              331        96                     14           
#>  2 Duke        DUKE              280        121                    13           
#>  3 Florida St. FSU               179        175                    12           
#>  4 Georgia Te… GT                269        143                    13           
#>  5 Maryland    UMD               315        213                    12           
#>  6 N. Carolina UNC               230        180                    13           
#>  7 NC State    NCST              255        209                    13           
#>  8 Virginia    UVA               246        191                    12           
#>  9 Wake Forest WAKE              248        234                    12           
#> 10 Boston Col… BC                207        102                    13           
#> # ℹ 124 more rows
#> # ℹ abbreviated name: ¹​points_allowed_per_game_rank
#> # ℹ 96 more variables: rushing_first_downs <chr>,
#> #   rushing_touchdowns_allowed_per_game <chr>,
#> #   receiving_touchdowns_allowed_per_game <chr>,
#> #   total_yards_allowed_per_game_rank <chr>, passing_first_downs_allowed <chr>,
#> #   fourth_down_conversion_percentage <chr>, rushing_attempts_allowed <chr>, …
# }
```
