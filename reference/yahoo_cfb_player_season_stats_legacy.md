# **Get Yahoo Sports CFB legacy per-category player leaders**

Flattens a legacy `seasonStatsFootball{Category}Ncaaf` query (one
category per call) into a wide player tibble.

## Usage

``` r
yahoo_cfb_player_season_stats_legacy(
  season = most_recent_cfb_season(),
  category = "Passing",
  sort_stat = "PASSING_YARDS",
  league_structure = "ncaaf.struct.div.1",
  count = 200
)
```

## Arguments

- season:

  (integer): Season year. Defaults to `most_recent_cfb_season()`.

- category:

  (character): One of `Passing`, `Rushing`, `Receiving`, `Defense`,
  `Kicking`, `Punting`, `Returns`. Defaults to `"Passing"`.

- sort_stat:

  (character): Required sort stat id (a `FootballStatId`, e.g.
  `"PASSING_YARDS"`). Defaults to `"PASSING_YARDS"`.

- league_structure:

  (character): Defaults to `"ncaaf.struct.div.1"`.

- count:

  (integer): Defaults to `200`.

## Value

A `cfbfastR`-tagged tibble: `player_id`, `display_name`, `team`,
`team_abbreviation`, `season`, `category`, plus one column per `statId`.

## See also

Other Yahoo CFB Functions:
[`yahoo_cfb_boxscore()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_boxscore.md),
[`yahoo_cfb_player_season_stats()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_player_season_stats.md),
[`yahoo_cfb_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_scoreboard.md),
[`yahoo_cfb_team_season_stats()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_team_season_stats.md),
[`yahoo_cfb_team_season_stats_legacy()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_team_season_stats_legacy.md)

## Examples

``` r
# \donttest{
  try(yahoo_cfb_player_season_stats_legacy(season = 2024, category = "Rushing",
                                           sort_stat = "RUSHING_YARDS"))
#> ── Legacy player season stats from Yahoo Sports (shangrila) ── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-27 20:33:22 UTC
#> # A tibble: 200 × 13
#>    player_id display_name team  team_abbreviation games_rushing rushing_attempts
#>    <chr>     <chr>        <chr> <chr>             <chr>         <chr>           
#>  1 ncaaf.p.… Ashton Jean… Bois… BSU               14            374             
#>  2 ncaaf.p.… Cam Skattebo Ariz… ASU               13            293             
#>  3 ncaaf.p.… Omarion Ham… N. C… UNC               12            281             
#>  4 ncaaf.p.… Bryson Daily Army  ARMY              13            310             
#>  5 ncaaf.p.… Tre Stewart  Jack… JVST              14            278             
#>  6 ncaaf.p.… RJ Harvey    UCF   UCF               12            232             
#>  7 ncaaf.p.… Kaleb Johns… Iowa  IOWA              12            240             
#>  8 ncaaf.p.… Tahj Brooks  Texa… TTU               11            286             
#>  9 ncaaf.p.… Dylan Samps… Tenn… TENN              13            258             
#> 10 ncaaf.p.… Makhi Hughes Hous… HOU               14            265             
#> # ℹ 190 more rows
#> # ℹ 7 more variables: rushing_yards <chr>, rushing_yards_per_game <chr>,
#> #   rushing_yards_per_attempt <chr>, rushing_touchdowns <chr>,
#> #   longest_rush <chr>, season <dbl>, category <chr>
# }
```
