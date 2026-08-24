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
#> ── Team season stats from Yahoo Sports (shangrila) ─────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-24 13:35:21 UTC
#> # A tibble: 134 × 101
#>    team        team_abbreviation passing_yards sacks_rank passing_first_downs_…¹
#>    <chr>       <chr>             <chr>         <chr>      <chr>                 
#>  1 Clemson     CLEM              3899          36         133                   
#>  2 Duke        DUKE              3176          5          123                   
#>  3 Florida St. FSU               2164          93         110                   
#>  4 Georgia Te… GT                3088          208        125                   
#>  5 Maryland    UMD               3308          243        126                   
#>  6 N. Carolina UNC               2917          11         112                   
#>  7 NC State    NCST              3024          140        133                   
#>  8 Virginia    UVA               2748          197        123                   
#>  9 Wake Forest WAKE              2881          178        170                   
#> 10 Boston Col… BC                2591          64         153                   
#> # ℹ 124 more rows
#> # ℹ abbreviated name: ¹​passing_first_downs_allowed
#> # ℹ 96 more variables: first_downs <chr>, rushing_first_downs <chr>,
#> #   rushing_attempts_per_game <chr>, rushing_attempts_allowed_per_game <chr>,
#> #   passing_completions <chr>, passing_interceptions <chr>,
#> #   completion_percentage <chr>, games_offense <chr>, games_rushing <chr>,
#> #   passing_yards_per_attempt <chr>, rushing_first_downs_allowed <chr>, …
# }
```
