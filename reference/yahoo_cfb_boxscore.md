# **Get Yahoo Sports college football boxscore (SCAFFOLD)**

Returns the raw editorial `boxscore/{game_id}` JSON (as a nested list).
The boxscore uses a normalized decoder-dictionary schema
(`player_stats[playerId][variation][stat_type]` joined against
`stat_types` / `stat_categories`); full decoding is a follow-up.

## Usage

``` r
yahoo_cfb_boxscore(game_id)
```

## Arguments

- game_id:

  (character, required): Dotted game id (e.g. `"ncaaf.g.202509200023"`).

## Value

The raw parsed JSON list (`service$boxscore`). TODO: decode to tibbles.

## See also

Other Yahoo CFB Functions:
[`yahoo_cfb_player_season_stats()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_player_season_stats.md),
[`yahoo_cfb_player_season_stats_legacy()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_player_season_stats_legacy.md),
[`yahoo_cfb_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_scoreboard.md),
[`yahoo_cfb_team_season_stats()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_team_season_stats.md),
[`yahoo_cfb_team_season_stats_legacy()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_team_season_stats_legacy.md)

## Examples

``` r
# \donttest{
  try(yahoo_cfb_boxscore(game_id = "ncaaf.g.202509200023"))
#> $service
#> $service$`xml:lang`
#> [1] "en-US"
#> 
#> $service$boxscore
#> $service$boxscore$player_stats
#> $service$boxscore$player_stats$ncaaf.p.457863
#> $service$boxscore$player_stats$ncaaf.p.457863$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.457863$ncaaf.stat_variation.2$ncaaf.stat_type.102
#> [1] "30"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457863$ncaaf.stat_variation.2$ncaaf.stat_type.103
#> [1] "41"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457863$ncaaf.stat_variation.2$ncaaf.stat_type.105
#> [1] "308"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457863$ncaaf.stat_variation.2$ncaaf.stat_type.104
#> [1] "73.2"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457863$ncaaf.stat_variation.2$ncaaf.stat_type.106
#> [1] "7.5"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457863$ncaaf.stat_variation.2$ncaaf.stat_type.111
#> [1] "7"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457863$ncaaf.stat_variation.2$ncaaf.stat_type.112
#> [1] "49"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457863$ncaaf.stat_variation.2$ncaaf.stat_type.108
#> [1] "3"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457863$ncaaf.stat_variation.2$ncaaf.stat_type.109
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457863$ncaaf.stat_variation.2$ncaaf.stat_type.113
#> [1] "155.5"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457863$ncaaf.stat_variation.2$ncaaf.stat_type.202
#> [1] "7"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457863$ncaaf.stat_variation.2$ncaaf.stat_type.203
#> [1] "-49"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457863$ncaaf.stat_variation.2$ncaaf.stat_type.205
#> [1] "-7.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457863$ncaaf.stat_variation.2$ncaaf.stat_type.206
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457863$ncaaf.stat_variation.2$ncaaf.stat_type.207
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.469436
#> $service$boxscore$player_stats$ncaaf.p.469436$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.469436$ncaaf.stat_variation.2$ncaaf.stat_type.102
#> [1] "12"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469436$ncaaf.stat_variation.2$ncaaf.stat_type.103
#> [1] "22"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469436$ncaaf.stat_variation.2$ncaaf.stat_type.105
#> [1] "105"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469436$ncaaf.stat_variation.2$ncaaf.stat_type.104
#> [1] "54.5"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469436$ncaaf.stat_variation.2$ncaaf.stat_type.106
#> [1] "4.8"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469436$ncaaf.stat_variation.2$ncaaf.stat_type.111
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469436$ncaaf.stat_variation.2$ncaaf.stat_type.112
#> [1] "6"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469436$ncaaf.stat_variation.2$ncaaf.stat_type.108
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469436$ncaaf.stat_variation.2$ncaaf.stat_type.109
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469436$ncaaf.stat_variation.2$ncaaf.stat_type.113
#> [1] "94.6"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469436$ncaaf.stat_variation.2$ncaaf.stat_type.202
#> [1] "8"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469436$ncaaf.stat_variation.2$ncaaf.stat_type.203
#> [1] "61"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469436$ncaaf.stat_variation.2$ncaaf.stat_type.205
#> [1] "7.6"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469436$ncaaf.stat_variation.2$ncaaf.stat_type.206
#> [1] "37"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469436$ncaaf.stat_variation.2$ncaaf.stat_type.207
#> [1] "1"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.403962
#> $service$boxscore$player_stats$ncaaf.p.403962$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.403962$ncaaf.stat_variation.2$ncaaf.stat_type.102
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403962$ncaaf.stat_variation.2$ncaaf.stat_type.103
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403962$ncaaf.stat_variation.2$ncaaf.stat_type.105
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403962$ncaaf.stat_variation.2$ncaaf.stat_type.104
#> [1] "0.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403962$ncaaf.stat_variation.2$ncaaf.stat_type.106
#> [1] "0.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403962$ncaaf.stat_variation.2$ncaaf.stat_type.111
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403962$ncaaf.stat_variation.2$ncaaf.stat_type.112
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403962$ncaaf.stat_variation.2$ncaaf.stat_type.108
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403962$ncaaf.stat_variation.2$ncaaf.stat_type.109
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403962$ncaaf.stat_variation.2$ncaaf.stat_type.113
#> [1] "0.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403962$ncaaf.stat_variation.2$ncaaf.stat_type.302
#> [1] "2"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403962$ncaaf.stat_variation.2$ncaaf.stat_type.303
#> [1] "22"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403962$ncaaf.stat_variation.2$ncaaf.stat_type.305
#> [1] "11.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403962$ncaaf.stat_variation.2$ncaaf.stat_type.306
#> [1] "16"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403962$ncaaf.stat_variation.2$ncaaf.stat_type.309
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403962$ncaaf.stat_variation.2$ncaaf.stat_type.502
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403962$ncaaf.stat_variation.2$ncaaf.stat_type.503
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403962$ncaaf.stat_variation.2$ncaaf.stat_type.505
#> [1] "0.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403962$ncaaf.stat_variation.2$ncaaf.stat_type.506
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403962$ncaaf.stat_variation.2$ncaaf.stat_type.507
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403962$ncaaf.stat_variation.2$ncaaf.stat_type.508
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403962$ncaaf.stat_variation.2$ncaaf.stat_type.509
#> [1] "-1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403962$ncaaf.stat_variation.2$ncaaf.stat_type.511
#> [1] "-1.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403962$ncaaf.stat_variation.2$ncaaf.stat_type.512
#> [1] "-1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403962$ncaaf.stat_variation.2$ncaaf.stat_type.513
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.404392
#> $service$boxscore$player_stats$ncaaf.p.404392$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.404392$ncaaf.stat_variation.2$ncaaf.stat_type.202
#> [1] "17"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404392$ncaaf.stat_variation.2$ncaaf.stat_type.203
#> [1] "149"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404392$ncaaf.stat_variation.2$ncaaf.stat_type.205
#> [1] "8.8"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404392$ncaaf.stat_variation.2$ncaaf.stat_type.206
#> [1] "75"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404392$ncaaf.stat_variation.2$ncaaf.stat_type.207
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404392$ncaaf.stat_variation.2$ncaaf.stat_type.302
#> [1] "3"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404392$ncaaf.stat_variation.2$ncaaf.stat_type.303
#> [1] "12"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404392$ncaaf.stat_variation.2$ncaaf.stat_type.305
#> [1] "4.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404392$ncaaf.stat_variation.2$ncaaf.stat_type.306
#> [1] "16"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404392$ncaaf.stat_variation.2$ncaaf.stat_type.309
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.457591
#> $service$boxscore$player_stats$ncaaf.p.457591$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.457591$ncaaf.stat_variation.2$ncaaf.stat_type.202
#> [1] "6"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457591$ncaaf.stat_variation.2$ncaaf.stat_type.203
#> [1] "80"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457591$ncaaf.stat_variation.2$ncaaf.stat_type.205
#> [1] "13.3"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457591$ncaaf.stat_variation.2$ncaaf.stat_type.206
#> [1] "54"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457591$ncaaf.stat_variation.2$ncaaf.stat_type.207
#> [1] "1"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.333433
#> $service$boxscore$player_stats$ncaaf.p.333433$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.333433$ncaaf.stat_variation.2$ncaaf.stat_type.202
#> [1] "19"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333433$ncaaf.stat_variation.2$ncaaf.stat_type.203
#> [1] "65"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333433$ncaaf.stat_variation.2$ncaaf.stat_type.205
#> [1] "3.4"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333433$ncaaf.stat_variation.2$ncaaf.stat_type.206
#> [1] "14"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333433$ncaaf.stat_variation.2$ncaaf.stat_type.207
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333433$ncaaf.stat_variation.2$ncaaf.stat_type.302
#> [1] "5"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333433$ncaaf.stat_variation.2$ncaaf.stat_type.303
#> [1] "32"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333433$ncaaf.stat_variation.2$ncaaf.stat_type.305
#> [1] "6.4"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333433$ncaaf.stat_variation.2$ncaaf.stat_type.306
#> [1] "8"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333433$ncaaf.stat_variation.2$ncaaf.stat_type.309
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.461405
#> $service$boxscore$player_stats$ncaaf.p.461405$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.461405$ncaaf.stat_variation.2$ncaaf.stat_type.202
#> [1] "3"
#> 
#> $service$boxscore$player_stats$ncaaf.p.461405$ncaaf.stat_variation.2$ncaaf.stat_type.203
#> [1] "19"
#> 
#> $service$boxscore$player_stats$ncaaf.p.461405$ncaaf.stat_variation.2$ncaaf.stat_type.205
#> [1] "6.3"
#> 
#> $service$boxscore$player_stats$ncaaf.p.461405$ncaaf.stat_variation.2$ncaaf.stat_type.206
#> [1] "11"
#> 
#> $service$boxscore$player_stats$ncaaf.p.461405$ncaaf.stat_variation.2$ncaaf.stat_type.207
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.461405$ncaaf.stat_variation.2$ncaaf.stat_type.302
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.461405$ncaaf.stat_variation.2$ncaaf.stat_type.303
#> [1] "-4"
#> 
#> $service$boxscore$player_stats$ncaaf.p.461405$ncaaf.stat_variation.2$ncaaf.stat_type.305
#> [1] "-4.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.461405$ncaaf.stat_variation.2$ncaaf.stat_type.306
#> [1] "-4"
#> 
#> $service$boxscore$player_stats$ncaaf.p.461405$ncaaf.stat_variation.2$ncaaf.stat_type.309
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.457834
#> $service$boxscore$player_stats$ncaaf.p.457834$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.457834$ncaaf.stat_variation.2$ncaaf.stat_type.202
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457834$ncaaf.stat_variation.2$ncaaf.stat_type.203
#> [1] "7"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457834$ncaaf.stat_variation.2$ncaaf.stat_type.205
#> [1] "7.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457834$ncaaf.stat_variation.2$ncaaf.stat_type.206
#> [1] "7"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457834$ncaaf.stat_variation.2$ncaaf.stat_type.207
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457834$ncaaf.stat_variation.2$ncaaf.stat_type.302
#> [1] "6"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457834$ncaaf.stat_variation.2$ncaaf.stat_type.303
#> [1] "120"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457834$ncaaf.stat_variation.2$ncaaf.stat_type.305
#> [1] "20.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457834$ncaaf.stat_variation.2$ncaaf.stat_type.306
#> [1] "52"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457834$ncaaf.stat_variation.2$ncaaf.stat_type.309
#> [1] "2"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457834$ncaaf.stat_variation.2$ncaaf.stat_type.502
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457834$ncaaf.stat_variation.2$ncaaf.stat_type.503
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457834$ncaaf.stat_variation.2$ncaaf.stat_type.505
#> [1] "0.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457834$ncaaf.stat_variation.2$ncaaf.stat_type.506
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457834$ncaaf.stat_variation.2$ncaaf.stat_type.507
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457834$ncaaf.stat_variation.2$ncaaf.stat_type.508
#> [1] "3"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457834$ncaaf.stat_variation.2$ncaaf.stat_type.509
#> [1] "21"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457834$ncaaf.stat_variation.2$ncaaf.stat_type.511
#> [1] "7.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457834$ncaaf.stat_variation.2$ncaaf.stat_type.512
#> [1] "20"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457834$ncaaf.stat_variation.2$ncaaf.stat_type.513
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.469568
#> $service$boxscore$player_stats$ncaaf.p.469568$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.469568$ncaaf.stat_variation.2$ncaaf.stat_type.202
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469568$ncaaf.stat_variation.2$ncaaf.stat_type.203
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469568$ncaaf.stat_variation.2$ncaaf.stat_type.205
#> [1] "1.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469568$ncaaf.stat_variation.2$ncaaf.stat_type.206
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469568$ncaaf.stat_variation.2$ncaaf.stat_type.207
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469568$ncaaf.stat_variation.2$ncaaf.stat_type.502
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469568$ncaaf.stat_variation.2$ncaaf.stat_type.503
#> [1] "23"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469568$ncaaf.stat_variation.2$ncaaf.stat_type.505
#> [1] "23.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469568$ncaaf.stat_variation.2$ncaaf.stat_type.506
#> [1] "23"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469568$ncaaf.stat_variation.2$ncaaf.stat_type.507
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469568$ncaaf.stat_variation.2$ncaaf.stat_type.508
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469568$ncaaf.stat_variation.2$ncaaf.stat_type.509
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469568$ncaaf.stat_variation.2$ncaaf.stat_type.511
#> [1] "0.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469568$ncaaf.stat_variation.2$ncaaf.stat_type.512
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469568$ncaaf.stat_variation.2$ncaaf.stat_type.513
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.333434
#> $service$boxscore$player_stats$ncaaf.p.333434$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.333434$ncaaf.stat_variation.2$ncaaf.stat_type.302
#> [1] "7"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333434$ncaaf.stat_variation.2$ncaaf.stat_type.303
#> [1] "60"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333434$ncaaf.stat_variation.2$ncaaf.stat_type.305
#> [1] "8.6"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333434$ncaaf.stat_variation.2$ncaaf.stat_type.306
#> [1] "23"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333434$ncaaf.stat_variation.2$ncaaf.stat_type.309
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.323602
#> $service$boxscore$player_stats$ncaaf.p.323602$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.323602$ncaaf.stat_variation.2$ncaaf.stat_type.302
#> [1] "3"
#> 
#> $service$boxscore$player_stats$ncaaf.p.323602$ncaaf.stat_variation.2$ncaaf.stat_type.303
#> [1] "39"
#> 
#> $service$boxscore$player_stats$ncaaf.p.323602$ncaaf.stat_variation.2$ncaaf.stat_type.305
#> [1] "13.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.323602$ncaaf.stat_variation.2$ncaaf.stat_type.306
#> [1] "16"
#> 
#> $service$boxscore$player_stats$ncaaf.p.323602$ncaaf.stat_variation.2$ncaaf.stat_type.309
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.333286
#> $service$boxscore$player_stats$ncaaf.p.333286$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.333286$ncaaf.stat_variation.2$ncaaf.stat_type.302
#> [1] "3"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333286$ncaaf.stat_variation.2$ncaaf.stat_type.303
#> [1] "36"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333286$ncaaf.stat_variation.2$ncaaf.stat_type.305
#> [1] "12.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333286$ncaaf.stat_variation.2$ncaaf.stat_type.306
#> [1] "21"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333286$ncaaf.stat_variation.2$ncaaf.stat_type.309
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.404124
#> $service$boxscore$player_stats$ncaaf.p.404124$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.404124$ncaaf.stat_variation.2$ncaaf.stat_type.302
#> [1] "2"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404124$ncaaf.stat_variation.2$ncaaf.stat_type.303
#> [1] "34"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404124$ncaaf.stat_variation.2$ncaaf.stat_type.305
#> [1] "17.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404124$ncaaf.stat_variation.2$ncaaf.stat_type.306
#> [1] "21"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404124$ncaaf.stat_variation.2$ncaaf.stat_type.309
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.340496
#> $service$boxscore$player_stats$ncaaf.p.340496$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.340496$ncaaf.stat_variation.2$ncaaf.stat_type.302
#> [1] "2"
#> 
#> $service$boxscore$player_stats$ncaaf.p.340496$ncaaf.stat_variation.2$ncaaf.stat_type.303
#> [1] "21"
#> 
#> $service$boxscore$player_stats$ncaaf.p.340496$ncaaf.stat_variation.2$ncaaf.stat_type.305
#> [1] "10.5"
#> 
#> $service$boxscore$player_stats$ncaaf.p.340496$ncaaf.stat_variation.2$ncaaf.stat_type.306
#> [1] "16"
#> 
#> $service$boxscore$player_stats$ncaaf.p.340496$ncaaf.stat_variation.2$ncaaf.stat_type.309
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.322801
#> $service$boxscore$player_stats$ncaaf.p.322801$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.322801$ncaaf.stat_variation.2$ncaaf.stat_type.302
#> [1] "3"
#> 
#> $service$boxscore$player_stats$ncaaf.p.322801$ncaaf.stat_variation.2$ncaaf.stat_type.303
#> [1] "18"
#> 
#> $service$boxscore$player_stats$ncaaf.p.322801$ncaaf.stat_variation.2$ncaaf.stat_type.305
#> [1] "6.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.322801$ncaaf.stat_variation.2$ncaaf.stat_type.306
#> [1] "9"
#> 
#> $service$boxscore$player_stats$ncaaf.p.322801$ncaaf.stat_variation.2$ncaaf.stat_type.309
#> [1] "1"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.457875
#> $service$boxscore$player_stats$ncaaf.p.457875$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.457875$ncaaf.stat_variation.2$ncaaf.stat_type.302
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457875$ncaaf.stat_variation.2$ncaaf.stat_type.303
#> [1] "14"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457875$ncaaf.stat_variation.2$ncaaf.stat_type.305
#> [1] "14.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457875$ncaaf.stat_variation.2$ncaaf.stat_type.306
#> [1] "14"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457875$ncaaf.stat_variation.2$ncaaf.stat_type.309
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.469559
#> $service$boxscore$player_stats$ncaaf.p.469559$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.469559$ncaaf.stat_variation.2$ncaaf.stat_type.302
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469559$ncaaf.stat_variation.2$ncaaf.stat_type.303
#> [1] "10"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469559$ncaaf.stat_variation.2$ncaaf.stat_type.305
#> [1] "10.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469559$ncaaf.stat_variation.2$ncaaf.stat_type.306
#> [1] "10"
#> 
#> $service$boxscore$player_stats$ncaaf.p.469559$ncaaf.stat_variation.2$ncaaf.stat_type.309
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.403924
#> $service$boxscore$player_stats$ncaaf.p.403924$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.403924$ncaaf.stat_variation.2$ncaaf.stat_type.302
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403924$ncaaf.stat_variation.2$ncaaf.stat_type.303
#> [1] "6"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403924$ncaaf.stat_variation.2$ncaaf.stat_type.305
#> [1] "6.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403924$ncaaf.stat_variation.2$ncaaf.stat_type.306
#> [1] "6"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403924$ncaaf.stat_variation.2$ncaaf.stat_type.309
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.457613
#> $service$boxscore$player_stats$ncaaf.p.457613$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.457613$ncaaf.stat_variation.2$ncaaf.stat_type.302
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457613$ncaaf.stat_variation.2$ncaaf.stat_type.303
#> [1] "5"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457613$ncaaf.stat_variation.2$ncaaf.stat_type.305
#> [1] "5.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457613$ncaaf.stat_variation.2$ncaaf.stat_type.306
#> [1] "5"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457613$ncaaf.stat_variation.2$ncaaf.stat_type.309
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.322827
#> $service$boxscore$player_stats$ncaaf.p.322827$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.322827$ncaaf.stat_variation.2$ncaaf.stat_type.302
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.322827$ncaaf.stat_variation.2$ncaaf.stat_type.303
#> [1] "-12"
#> 
#> $service$boxscore$player_stats$ncaaf.p.322827$ncaaf.stat_variation.2$ncaaf.stat_type.305
#> [1] "-12.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.322827$ncaaf.stat_variation.2$ncaaf.stat_type.306
#> [1] "-12"
#> 
#> $service$boxscore$player_stats$ncaaf.p.322827$ncaaf.stat_variation.2$ncaaf.stat_type.309
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.333922
#> $service$boxscore$player_stats$ncaaf.p.333922$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.333922$ncaaf.stat_variation.2$ncaaf.stat_type.411
#> [1] "3"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333922$ncaaf.stat_variation.2$ncaaf.stat_type.412
#> [1] "3"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333922$ncaaf.stat_variation.2$ncaaf.stat_type.407
#> [1] "3"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333922$ncaaf.stat_variation.2$ncaaf.stat_type.408
#> [1] "3"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333922$ncaaf.stat_variation.2$ncaaf.stat_type.410
#> [1] "56"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333922$ncaaf.stat_variation.2$ncaaf.stat_type.409
#> [1] "100.0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.451229
#> $service$boxscore$player_stats$ncaaf.p.451229$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.451229$ncaaf.stat_variation.2$ncaaf.stat_type.411
#> [1] "3"
#> 
#> $service$boxscore$player_stats$ncaaf.p.451229$ncaaf.stat_variation.2$ncaaf.stat_type.412
#> [1] "3"
#> 
#> $service$boxscore$player_stats$ncaaf.p.451229$ncaaf.stat_variation.2$ncaaf.stat_type.407
#> [1] "2"
#> 
#> $service$boxscore$player_stats$ncaaf.p.451229$ncaaf.stat_variation.2$ncaaf.stat_type.408
#> [1] "3"
#> 
#> $service$boxscore$player_stats$ncaaf.p.451229$ncaaf.stat_variation.2$ncaaf.stat_type.410
#> [1] "39"
#> 
#> $service$boxscore$player_stats$ncaaf.p.451229$ncaaf.stat_variation.2$ncaaf.stat_type.409
#> [1] "66.7"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.404008
#> $service$boxscore$player_stats$ncaaf.p.404008$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.404008$ncaaf.stat_variation.2$ncaaf.stat_type.502
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404008$ncaaf.stat_variation.2$ncaaf.stat_type.503
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404008$ncaaf.stat_variation.2$ncaaf.stat_type.505
#> [1] "1.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404008$ncaaf.stat_variation.2$ncaaf.stat_type.506
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404008$ncaaf.stat_variation.2$ncaaf.stat_type.507
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404008$ncaaf.stat_variation.2$ncaaf.stat_type.508
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404008$ncaaf.stat_variation.2$ncaaf.stat_type.509
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404008$ncaaf.stat_variation.2$ncaaf.stat_type.511
#> [1] "0.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404008$ncaaf.stat_variation.2$ncaaf.stat_type.512
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404008$ncaaf.stat_variation.2$ncaaf.stat_type.513
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.338368
#> $service$boxscore$player_stats$ncaaf.p.338368$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.338368$ncaaf.stat_variation.2$ncaaf.stat_type.602
#> [1] "4"
#> 
#> $service$boxscore$player_stats$ncaaf.p.338368$ncaaf.stat_variation.2$ncaaf.stat_type.604
#> [1] "41.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.338368$ncaaf.stat_variation.2$ncaaf.stat_type.608
#> [1] "49"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.471801
#> $service$boxscore$player_stats$ncaaf.p.471801$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.471801$ncaaf.stat_variation.2$ncaaf.stat_type.602
#> [1] "4"
#> 
#> $service$boxscore$player_stats$ncaaf.p.471801$ncaaf.stat_variation.2$ncaaf.stat_type.604
#> [1] "49.3"
#> 
#> $service$boxscore$player_stats$ncaaf.p.471801$ncaaf.stat_variation.2$ncaaf.stat_type.608
#> [1] "56"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.457602
#> $service$boxscore$player_stats$ncaaf.p.457602$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.457602$ncaaf.stat_variation.2$ncaaf.stat_type.702
#> [1] "3"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457602$ncaaf.stat_variation.2$ncaaf.stat_type.703
#> [1] "2"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457602$ncaaf.stat_variation.2$ncaaf.stat_type.705
#> [1] "0.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457602$ncaaf.stat_variation.2$ncaaf.stat_type.706
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457602$ncaaf.stat_variation.2$ncaaf.stat_type.710
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457602$ncaaf.stat_variation.2$ncaaf.stat_type.707
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457602$ncaaf.stat_variation.2$ncaaf.stat_type.708
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457602$ncaaf.stat_variation.2$ncaaf.stat_type.709
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.299700
#> $service$boxscore$player_stats$ncaaf.p.299700$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.299700$ncaaf.stat_variation.2$ncaaf.stat_type.702
#> [1] "4"
#> 
#> $service$boxscore$player_stats$ncaaf.p.299700$ncaaf.stat_variation.2$ncaaf.stat_type.703
#> [1] "6"
#> 
#> $service$boxscore$player_stats$ncaaf.p.299700$ncaaf.stat_variation.2$ncaaf.stat_type.705
#> [1] "0.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.299700$ncaaf.stat_variation.2$ncaaf.stat_type.706
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.299700$ncaaf.stat_variation.2$ncaaf.stat_type.710
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.299700$ncaaf.stat_variation.2$ncaaf.stat_type.707
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.299700$ncaaf.stat_variation.2$ncaaf.stat_type.708
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.299700$ncaaf.stat_variation.2$ncaaf.stat_type.709
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.322308
#> $service$boxscore$player_stats$ncaaf.p.322308$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.322308$ncaaf.stat_variation.2$ncaaf.stat_type.702
#> [1] "2"
#> 
#> $service$boxscore$player_stats$ncaaf.p.322308$ncaaf.stat_variation.2$ncaaf.stat_type.703
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.322308$ncaaf.stat_variation.2$ncaaf.stat_type.705
#> [1] "0.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.322308$ncaaf.stat_variation.2$ncaaf.stat_type.706
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.322308$ncaaf.stat_variation.2$ncaaf.stat_type.710
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.322308$ncaaf.stat_variation.2$ncaaf.stat_type.707
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.322308$ncaaf.stat_variation.2$ncaaf.stat_type.708
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.322308$ncaaf.stat_variation.2$ncaaf.stat_type.709
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.322802
#> $service$boxscore$player_stats$ncaaf.p.322802$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.322802$ncaaf.stat_variation.2$ncaaf.stat_type.702
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.322802$ncaaf.stat_variation.2$ncaaf.stat_type.703
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.322802$ncaaf.stat_variation.2$ncaaf.stat_type.705
#> [1] "0.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.322802$ncaaf.stat_variation.2$ncaaf.stat_type.706
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.322802$ncaaf.stat_variation.2$ncaaf.stat_type.710
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.322802$ncaaf.stat_variation.2$ncaaf.stat_type.707
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.322802$ncaaf.stat_variation.2$ncaaf.stat_type.708
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.322802$ncaaf.stat_variation.2$ncaaf.stat_type.709
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.327406
#> $service$boxscore$player_stats$ncaaf.p.327406$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.327406$ncaaf.stat_variation.2$ncaaf.stat_type.702
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.327406$ncaaf.stat_variation.2$ncaaf.stat_type.703
#> [1] "2"
#> 
#> $service$boxscore$player_stats$ncaaf.p.327406$ncaaf.stat_variation.2$ncaaf.stat_type.705
#> [1] "1.5"
#> 
#> $service$boxscore$player_stats$ncaaf.p.327406$ncaaf.stat_variation.2$ncaaf.stat_type.706
#> [1] "15"
#> 
#> $service$boxscore$player_stats$ncaaf.p.327406$ncaaf.stat_variation.2$ncaaf.stat_type.710
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.327406$ncaaf.stat_variation.2$ncaaf.stat_type.707
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.327406$ncaaf.stat_variation.2$ncaaf.stat_type.708
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.327406$ncaaf.stat_variation.2$ncaaf.stat_type.709
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.327412
#> $service$boxscore$player_stats$ncaaf.p.327412$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.327412$ncaaf.stat_variation.2$ncaaf.stat_type.702
#> [1] "2"
#> 
#> $service$boxscore$player_stats$ncaaf.p.327412$ncaaf.stat_variation.2$ncaaf.stat_type.703
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.327412$ncaaf.stat_variation.2$ncaaf.stat_type.705
#> [1] "0.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.327412$ncaaf.stat_variation.2$ncaaf.stat_type.706
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.327412$ncaaf.stat_variation.2$ncaaf.stat_type.710
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.327412$ncaaf.stat_variation.2$ncaaf.stat_type.707
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.327412$ncaaf.stat_variation.2$ncaaf.stat_type.708
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.327412$ncaaf.stat_variation.2$ncaaf.stat_type.709
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.327421
#> $service$boxscore$player_stats$ncaaf.p.327421$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.327421$ncaaf.stat_variation.2$ncaaf.stat_type.702
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.327421$ncaaf.stat_variation.2$ncaaf.stat_type.703
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.327421$ncaaf.stat_variation.2$ncaaf.stat_type.705
#> [1] "0.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.327421$ncaaf.stat_variation.2$ncaaf.stat_type.706
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.327421$ncaaf.stat_variation.2$ncaaf.stat_type.710
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.327421$ncaaf.stat_variation.2$ncaaf.stat_type.707
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.327421$ncaaf.stat_variation.2$ncaaf.stat_type.708
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.327421$ncaaf.stat_variation.2$ncaaf.stat_type.709
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.333312
#> $service$boxscore$player_stats$ncaaf.p.333312$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.333312$ncaaf.stat_variation.2$ncaaf.stat_type.702
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333312$ncaaf.stat_variation.2$ncaaf.stat_type.703
#> [1] "2"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333312$ncaaf.stat_variation.2$ncaaf.stat_type.705
#> [1] "1.5"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333312$ncaaf.stat_variation.2$ncaaf.stat_type.706
#> [1] "9"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333312$ncaaf.stat_variation.2$ncaaf.stat_type.710
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333312$ncaaf.stat_variation.2$ncaaf.stat_type.707
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333312$ncaaf.stat_variation.2$ncaaf.stat_type.708
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333312$ncaaf.stat_variation.2$ncaaf.stat_type.709
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.333324
#> $service$boxscore$player_stats$ncaaf.p.333324$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.333324$ncaaf.stat_variation.2$ncaaf.stat_type.702
#> [1] "2"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333324$ncaaf.stat_variation.2$ncaaf.stat_type.703
#> [1] "2"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333324$ncaaf.stat_variation.2$ncaaf.stat_type.705
#> [1] "1.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333324$ncaaf.stat_variation.2$ncaaf.stat_type.706
#> [1] "5"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333324$ncaaf.stat_variation.2$ncaaf.stat_type.710
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333324$ncaaf.stat_variation.2$ncaaf.stat_type.707
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333324$ncaaf.stat_variation.2$ncaaf.stat_type.708
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333324$ncaaf.stat_variation.2$ncaaf.stat_type.709
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.333347
#> $service$boxscore$player_stats$ncaaf.p.333347$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.333347$ncaaf.stat_variation.2$ncaaf.stat_type.702
#> [1] "2"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333347$ncaaf.stat_variation.2$ncaaf.stat_type.703
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333347$ncaaf.stat_variation.2$ncaaf.stat_type.705
#> [1] "1.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333347$ncaaf.stat_variation.2$ncaaf.stat_type.706
#> [1] "6"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333347$ncaaf.stat_variation.2$ncaaf.stat_type.710
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333347$ncaaf.stat_variation.2$ncaaf.stat_type.707
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333347$ncaaf.stat_variation.2$ncaaf.stat_type.708
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333347$ncaaf.stat_variation.2$ncaaf.stat_type.709
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.333423
#> $service$boxscore$player_stats$ncaaf.p.333423$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.333423$ncaaf.stat_variation.2$ncaaf.stat_type.702
#> [1] "6"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333423$ncaaf.stat_variation.2$ncaaf.stat_type.703
#> [1] "3"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333423$ncaaf.stat_variation.2$ncaaf.stat_type.705
#> [1] "1.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333423$ncaaf.stat_variation.2$ncaaf.stat_type.706
#> [1] "7"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333423$ncaaf.stat_variation.2$ncaaf.stat_type.710
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333423$ncaaf.stat_variation.2$ncaaf.stat_type.707
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333423$ncaaf.stat_variation.2$ncaaf.stat_type.708
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.333423$ncaaf.stat_variation.2$ncaaf.stat_type.709
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.334637
#> $service$boxscore$player_stats$ncaaf.p.334637$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.334637$ncaaf.stat_variation.2$ncaaf.stat_type.702
#> [1] "2"
#> 
#> $service$boxscore$player_stats$ncaaf.p.334637$ncaaf.stat_variation.2$ncaaf.stat_type.703
#> [1] "3"
#> 
#> $service$boxscore$player_stats$ncaaf.p.334637$ncaaf.stat_variation.2$ncaaf.stat_type.705
#> [1] "0.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.334637$ncaaf.stat_variation.2$ncaaf.stat_type.706
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.334637$ncaaf.stat_variation.2$ncaaf.stat_type.710
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.334637$ncaaf.stat_variation.2$ncaaf.stat_type.707
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.334637$ncaaf.stat_variation.2$ncaaf.stat_type.708
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.334637$ncaaf.stat_variation.2$ncaaf.stat_type.709
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.340505
#> $service$boxscore$player_stats$ncaaf.p.340505$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.340505$ncaaf.stat_variation.2$ncaaf.stat_type.702
#> [1] "2"
#> 
#> $service$boxscore$player_stats$ncaaf.p.340505$ncaaf.stat_variation.2$ncaaf.stat_type.703
#> [1] "3"
#> 
#> $service$boxscore$player_stats$ncaaf.p.340505$ncaaf.stat_variation.2$ncaaf.stat_type.705
#> [1] "1.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.340505$ncaaf.stat_variation.2$ncaaf.stat_type.706
#> [1] "9"
#> 
#> $service$boxscore$player_stats$ncaaf.p.340505$ncaaf.stat_variation.2$ncaaf.stat_type.710
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.340505$ncaaf.stat_variation.2$ncaaf.stat_type.707
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.340505$ncaaf.stat_variation.2$ncaaf.stat_type.708
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.340505$ncaaf.stat_variation.2$ncaaf.stat_type.709
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.403634
#> $service$boxscore$player_stats$ncaaf.p.403634$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.403634$ncaaf.stat_variation.2$ncaaf.stat_type.702
#> [1] "5"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403634$ncaaf.stat_variation.2$ncaaf.stat_type.703
#> [1] "2"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403634$ncaaf.stat_variation.2$ncaaf.stat_type.705
#> [1] "0.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403634$ncaaf.stat_variation.2$ncaaf.stat_type.706
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403634$ncaaf.stat_variation.2$ncaaf.stat_type.710
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403634$ncaaf.stat_variation.2$ncaaf.stat_type.707
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403634$ncaaf.stat_variation.2$ncaaf.stat_type.708
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403634$ncaaf.stat_variation.2$ncaaf.stat_type.709
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.403958
#> $service$boxscore$player_stats$ncaaf.p.403958$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.403958$ncaaf.stat_variation.2$ncaaf.stat_type.702
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403958$ncaaf.stat_variation.2$ncaaf.stat_type.703
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403958$ncaaf.stat_variation.2$ncaaf.stat_type.705
#> [1] "0.5"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403958$ncaaf.stat_variation.2$ncaaf.stat_type.706
#> [1] "2"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403958$ncaaf.stat_variation.2$ncaaf.stat_type.710
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403958$ncaaf.stat_variation.2$ncaaf.stat_type.707
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403958$ncaaf.stat_variation.2$ncaaf.stat_type.708
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.403958$ncaaf.stat_variation.2$ncaaf.stat_type.709
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.404052
#> $service$boxscore$player_stats$ncaaf.p.404052$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.404052$ncaaf.stat_variation.2$ncaaf.stat_type.702
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404052$ncaaf.stat_variation.2$ncaaf.stat_type.703
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404052$ncaaf.stat_variation.2$ncaaf.stat_type.705
#> [1] "0.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404052$ncaaf.stat_variation.2$ncaaf.stat_type.706
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404052$ncaaf.stat_variation.2$ncaaf.stat_type.710
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404052$ncaaf.stat_variation.2$ncaaf.stat_type.707
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404052$ncaaf.stat_variation.2$ncaaf.stat_type.708
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404052$ncaaf.stat_variation.2$ncaaf.stat_type.709
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.404304
#> $service$boxscore$player_stats$ncaaf.p.404304$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.404304$ncaaf.stat_variation.2$ncaaf.stat_type.702
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404304$ncaaf.stat_variation.2$ncaaf.stat_type.703
#> [1] "2"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404304$ncaaf.stat_variation.2$ncaaf.stat_type.705
#> [1] "0.5"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404304$ncaaf.stat_variation.2$ncaaf.stat_type.706
#> [1] "4"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404304$ncaaf.stat_variation.2$ncaaf.stat_type.710
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404304$ncaaf.stat_variation.2$ncaaf.stat_type.707
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404304$ncaaf.stat_variation.2$ncaaf.stat_type.708
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.404304$ncaaf.stat_variation.2$ncaaf.stat_type.709
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.405415
#> $service$boxscore$player_stats$ncaaf.p.405415$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.405415$ncaaf.stat_variation.2$ncaaf.stat_type.702
#> [1] "2"
#> 
#> $service$boxscore$player_stats$ncaaf.p.405415$ncaaf.stat_variation.2$ncaaf.stat_type.703
#> [1] "2"
#> 
#> $service$boxscore$player_stats$ncaaf.p.405415$ncaaf.stat_variation.2$ncaaf.stat_type.705
#> [1] "0.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.405415$ncaaf.stat_variation.2$ncaaf.stat_type.706
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.405415$ncaaf.stat_variation.2$ncaaf.stat_type.710
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.405415$ncaaf.stat_variation.2$ncaaf.stat_type.707
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.405415$ncaaf.stat_variation.2$ncaaf.stat_type.708
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.405415$ncaaf.stat_variation.2$ncaaf.stat_type.709
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.405652
#> $service$boxscore$player_stats$ncaaf.p.405652$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.405652$ncaaf.stat_variation.2$ncaaf.stat_type.702
#> [1] "2"
#> 
#> $service$boxscore$player_stats$ncaaf.p.405652$ncaaf.stat_variation.2$ncaaf.stat_type.703
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.405652$ncaaf.stat_variation.2$ncaaf.stat_type.705
#> [1] "0.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.405652$ncaaf.stat_variation.2$ncaaf.stat_type.706
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.405652$ncaaf.stat_variation.2$ncaaf.stat_type.710
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.405652$ncaaf.stat_variation.2$ncaaf.stat_type.707
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.405652$ncaaf.stat_variation.2$ncaaf.stat_type.708
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.405652$ncaaf.stat_variation.2$ncaaf.stat_type.709
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.406379
#> $service$boxscore$player_stats$ncaaf.p.406379$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.406379$ncaaf.stat_variation.2$ncaaf.stat_type.702
#> [1] "2"
#> 
#> $service$boxscore$player_stats$ncaaf.p.406379$ncaaf.stat_variation.2$ncaaf.stat_type.703
#> [1] "2"
#> 
#> $service$boxscore$player_stats$ncaaf.p.406379$ncaaf.stat_variation.2$ncaaf.stat_type.705
#> [1] "0.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.406379$ncaaf.stat_variation.2$ncaaf.stat_type.706
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.406379$ncaaf.stat_variation.2$ncaaf.stat_type.710
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.406379$ncaaf.stat_variation.2$ncaaf.stat_type.707
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.406379$ncaaf.stat_variation.2$ncaaf.stat_type.708
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.406379$ncaaf.stat_variation.2$ncaaf.stat_type.709
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.451303
#> $service$boxscore$player_stats$ncaaf.p.451303$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.451303$ncaaf.stat_variation.2$ncaaf.stat_type.702
#> [1] "3"
#> 
#> $service$boxscore$player_stats$ncaaf.p.451303$ncaaf.stat_variation.2$ncaaf.stat_type.703
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.451303$ncaaf.stat_variation.2$ncaaf.stat_type.705
#> [1] "0.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.451303$ncaaf.stat_variation.2$ncaaf.stat_type.706
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.451303$ncaaf.stat_variation.2$ncaaf.stat_type.710
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.451303$ncaaf.stat_variation.2$ncaaf.stat_type.707
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.451303$ncaaf.stat_variation.2$ncaaf.stat_type.708
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.451303$ncaaf.stat_variation.2$ncaaf.stat_type.709
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.457606
#> $service$boxscore$player_stats$ncaaf.p.457606$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.457606$ncaaf.stat_variation.2$ncaaf.stat_type.702
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457606$ncaaf.stat_variation.2$ncaaf.stat_type.703
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457606$ncaaf.stat_variation.2$ncaaf.stat_type.705
#> [1] "0.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457606$ncaaf.stat_variation.2$ncaaf.stat_type.706
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457606$ncaaf.stat_variation.2$ncaaf.stat_type.710
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457606$ncaaf.stat_variation.2$ncaaf.stat_type.707
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457606$ncaaf.stat_variation.2$ncaaf.stat_type.708
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457606$ncaaf.stat_variation.2$ncaaf.stat_type.709
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.457838
#> $service$boxscore$player_stats$ncaaf.p.457838$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.457838$ncaaf.stat_variation.2$ncaaf.stat_type.702
#> [1] "3"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457838$ncaaf.stat_variation.2$ncaaf.stat_type.703
#> [1] "4"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457838$ncaaf.stat_variation.2$ncaaf.stat_type.705
#> [1] "0.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457838$ncaaf.stat_variation.2$ncaaf.stat_type.706
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457838$ncaaf.stat_variation.2$ncaaf.stat_type.710
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457838$ncaaf.stat_variation.2$ncaaf.stat_type.707
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457838$ncaaf.stat_variation.2$ncaaf.stat_type.708
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457838$ncaaf.stat_variation.2$ncaaf.stat_type.709
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.457853
#> $service$boxscore$player_stats$ncaaf.p.457853$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.457853$ncaaf.stat_variation.2$ncaaf.stat_type.702
#> [1] "4"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457853$ncaaf.stat_variation.2$ncaaf.stat_type.703
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457853$ncaaf.stat_variation.2$ncaaf.stat_type.705
#> [1] "0.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457853$ncaaf.stat_variation.2$ncaaf.stat_type.706
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457853$ncaaf.stat_variation.2$ncaaf.stat_type.710
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457853$ncaaf.stat_variation.2$ncaaf.stat_type.707
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457853$ncaaf.stat_variation.2$ncaaf.stat_type.708
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457853$ncaaf.stat_variation.2$ncaaf.stat_type.709
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.457880
#> $service$boxscore$player_stats$ncaaf.p.457880$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.457880$ncaaf.stat_variation.2$ncaaf.stat_type.702
#> [1] "4"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457880$ncaaf.stat_variation.2$ncaaf.stat_type.703
#> [1] "2"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457880$ncaaf.stat_variation.2$ncaaf.stat_type.705
#> [1] "0.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457880$ncaaf.stat_variation.2$ncaaf.stat_type.706
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457880$ncaaf.stat_variation.2$ncaaf.stat_type.710
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457880$ncaaf.stat_variation.2$ncaaf.stat_type.707
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457880$ncaaf.stat_variation.2$ncaaf.stat_type.708
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.457880$ncaaf.stat_variation.2$ncaaf.stat_type.709
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.461399
#> $service$boxscore$player_stats$ncaaf.p.461399$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.461399$ncaaf.stat_variation.2$ncaaf.stat_type.702
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.461399$ncaaf.stat_variation.2$ncaaf.stat_type.703
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.461399$ncaaf.stat_variation.2$ncaaf.stat_type.705
#> [1] "0.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.461399$ncaaf.stat_variation.2$ncaaf.stat_type.706
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.461399$ncaaf.stat_variation.2$ncaaf.stat_type.710
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.461399$ncaaf.stat_variation.2$ncaaf.stat_type.707
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.461399$ncaaf.stat_variation.2$ncaaf.stat_type.708
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.461399$ncaaf.stat_variation.2$ncaaf.stat_type.709
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.474363
#> $service$boxscore$player_stats$ncaaf.p.474363$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.474363$ncaaf.stat_variation.2$ncaaf.stat_type.702
#> [1] "2"
#> 
#> $service$boxscore$player_stats$ncaaf.p.474363$ncaaf.stat_variation.2$ncaaf.stat_type.703
#> [1] "2"
#> 
#> $service$boxscore$player_stats$ncaaf.p.474363$ncaaf.stat_variation.2$ncaaf.stat_type.705
#> [1] "0.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.474363$ncaaf.stat_variation.2$ncaaf.stat_type.706
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.474363$ncaaf.stat_variation.2$ncaaf.stat_type.710
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.474363$ncaaf.stat_variation.2$ncaaf.stat_type.707
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.474363$ncaaf.stat_variation.2$ncaaf.stat_type.708
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.474363$ncaaf.stat_variation.2$ncaaf.stat_type.709
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$player_stats$ncaaf.p.474366
#> $service$boxscore$player_stats$ncaaf.p.474366$ncaaf.stat_variation.2
#> $service$boxscore$player_stats$ncaaf.p.474366$ncaaf.stat_variation.2$ncaaf.stat_type.702
#> [1] "5"
#> 
#> $service$boxscore$player_stats$ncaaf.p.474366$ncaaf.stat_variation.2$ncaaf.stat_type.703
#> [1] "3"
#> 
#> $service$boxscore$player_stats$ncaaf.p.474366$ncaaf.stat_variation.2$ncaaf.stat_type.705
#> [1] "0.0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.474366$ncaaf.stat_variation.2$ncaaf.stat_type.706
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.474366$ncaaf.stat_variation.2$ncaaf.stat_type.710
#> [1] "1"
#> 
#> $service$boxscore$player_stats$ncaaf.p.474366$ncaaf.stat_variation.2$ncaaf.stat_type.707
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.474366$ncaaf.stat_variation.2$ncaaf.stat_type.708
#> [1] "0"
#> 
#> $service$boxscore$player_stats$ncaaf.p.474366$ncaaf.stat_variation.2$ncaaf.stat_type.709
#> [1] "0"
#> 
#> 
#> 
#> 
#> $service$boxscore$team_stats
#> $service$boxscore$team_stats$ncaaf.t.23
#> $service$boxscore$team_stats$ncaaf.t.23$ncaaf.stat_variation.2
#> $service$boxscore$team_stats$ncaaf.t.23$ncaaf.stat_variation.2$ncaaf.stat_type.919
#> [1] "23"
#> 
#> $service$boxscore$team_stats$ncaaf.t.23$ncaaf.stat_variation.2$ncaaf.stat_type.945
#> [1] "351"
#> 
#> $service$boxscore$team_stats$ncaaf.t.23$ncaaf.stat_variation.2$ncaaf.stat_type.950
#> [1] "1"
#> 
#> $service$boxscore$team_stats$ncaaf.t.23$ncaaf.stat_variation.2$ncaaf.stat_type.937
#> [1] "15"
#> 
#> $service$boxscore$team_stats$ncaaf.t.23$ncaaf.stat_variation.2$ncaaf.stat_type.936
#> [1] "5"
#> 
#> $service$boxscore$team_stats$ncaaf.t.23$ncaaf.stat_variation.2$ncaaf.stat_type.938
#> [1] "3"
#> 
#> $service$boxscore$team_stats$ncaaf.t.23$ncaaf.stat_variation.2$ncaaf.stat_type.941
#> [1] "2-13"
#> 
#> $service$boxscore$team_stats$ncaaf.t.23$ncaaf.stat_variation.2$ncaaf.stat_type.944
#> [1] "2-3"
#> 
#> $service$boxscore$team_stats$ncaaf.t.23$ncaaf.stat_variation.2$ncaaf.stat_type.946
#> [1] "72"
#> 
#> $service$boxscore$team_stats$ncaaf.t.23$ncaaf.stat_variation.2$ncaaf.stat_type.952
#> [1] "4.9"
#> 
#> $service$boxscore$team_stats$ncaaf.t.23$ncaaf.stat_variation.2$ncaaf.stat_type.921
#> [1] "43"
#> 
#> $service$boxscore$team_stats$ncaaf.t.23$ncaaf.stat_variation.2$ncaaf.stat_type.920
#> [1] "31"
#> 
#> $service$boxscore$team_stats$ncaaf.t.23$ncaaf.stat_variation.2$ncaaf.stat_type.949
#> [1] "1.4"
#> 
#> $service$boxscore$team_stats$ncaaf.t.23$ncaaf.stat_variation.2$ncaaf.stat_type.947
#> [1] "308"
#> 
#> $service$boxscore$team_stats$ncaaf.t.23$ncaaf.stat_variation.2$ncaaf.stat_type.951
#> [1] "30-41"
#> 
#> $service$boxscore$team_stats$ncaaf.t.23$ncaaf.stat_variation.2$ncaaf.stat_type.948
#> [1] "7.5"
#> 
#> $service$boxscore$team_stats$ncaaf.t.23$ncaaf.stat_variation.2$ncaaf.stat_type.927
#> [1] "7"
#> 
#> $service$boxscore$team_stats$ncaaf.t.23$ncaaf.stat_variation.2$ncaaf.stat_type.928
#> [1] "-49"
#> 
#> $service$boxscore$team_stats$ncaaf.t.23$ncaaf.stat_variation.2$ncaaf.stat_type.926
#> [1] "1"
#> 
#> $service$boxscore$team_stats$ncaaf.t.23$ncaaf.stat_variation.2$ncaaf.stat_type.929
#> [1] "4"
#> 
#> $service$boxscore$team_stats$ncaaf.t.23$ncaaf.stat_variation.2$ncaaf.stat_type.930
#> [1] "49.3"
#> 
#> $service$boxscore$team_stats$ncaaf.t.23$ncaaf.stat_variation.2$ncaaf.stat_type.933
#> [1] "3"
#> 
#> $service$boxscore$team_stats$ncaaf.t.23$ncaaf.stat_variation.2$ncaaf.stat_type.934
#> [1] "9"
#> 
#> $service$boxscore$team_stats$ncaaf.t.23$ncaaf.stat_variation.2$ncaaf.stat_type.931
#> [1] "0"
#> 
#> $service$boxscore$team_stats$ncaaf.t.23$ncaaf.stat_variation.2$ncaaf.stat_type.932
#> [1] "0"
#> 
#> 
#> 
#> $service$boxscore$team_stats$ncaaf.t.29
#> $service$boxscore$team_stats$ncaaf.t.29$ncaaf.stat_variation.2
#> $service$boxscore$team_stats$ncaaf.t.29$ncaaf.stat_variation.2$ncaaf.stat_type.919
#> [1] "16"
#> 
#> $service$boxscore$team_stats$ncaaf.t.29$ncaaf.stat_variation.2$ncaaf.stat_type.945
#> [1] "391"
#> 
#> $service$boxscore$team_stats$ncaaf.t.29$ncaaf.stat_variation.2$ncaaf.stat_type.950
#> [1] "1"
#> 
#> $service$boxscore$team_stats$ncaaf.t.29$ncaaf.stat_variation.2$ncaaf.stat_type.937
#> [1] "7"
#> 
#> $service$boxscore$team_stats$ncaaf.t.29$ncaaf.stat_variation.2$ncaaf.stat_type.936
#> [1] "9"
#> 
#> $service$boxscore$team_stats$ncaaf.t.29$ncaaf.stat_variation.2$ncaaf.stat_type.938
#> [1] "0"
#> 
#> $service$boxscore$team_stats$ncaaf.t.29$ncaaf.stat_variation.2$ncaaf.stat_type.941
#> [1] "4-12"
#> 
#> $service$boxscore$team_stats$ncaaf.t.29$ncaaf.stat_variation.2$ncaaf.stat_type.944
#> [1] "0-0"
#> 
#> $service$boxscore$team_stats$ncaaf.t.29$ncaaf.stat_variation.2$ncaaf.stat_type.946
#> [1] "56"
#> 
#> $service$boxscore$team_stats$ncaaf.t.29$ncaaf.stat_variation.2$ncaaf.stat_type.952
#> [1] "7.0"
#> 
#> $service$boxscore$team_stats$ncaaf.t.29$ncaaf.stat_variation.2$ncaaf.stat_type.921
#> [1] "286"
#> 
#> $service$boxscore$team_stats$ncaaf.t.29$ncaaf.stat_variation.2$ncaaf.stat_type.920
#> [1] "33"
#> 
#> $service$boxscore$team_stats$ncaaf.t.29$ncaaf.stat_variation.2$ncaaf.stat_type.949
#> [1] "8.7"
#> 
#> $service$boxscore$team_stats$ncaaf.t.29$ncaaf.stat_variation.2$ncaaf.stat_type.947
#> [1] "105"
#> 
#> $service$boxscore$team_stats$ncaaf.t.29$ncaaf.stat_variation.2$ncaaf.stat_type.951
#> [1] "12-23"
#> 
#> $service$boxscore$team_stats$ncaaf.t.29$ncaaf.stat_variation.2$ncaaf.stat_type.948
#> [1] "4.6"
#> 
#> $service$boxscore$team_stats$ncaaf.t.29$ncaaf.stat_variation.2$ncaaf.stat_type.927
#> [1] "1"
#> 
#> $service$boxscore$team_stats$ncaaf.t.29$ncaaf.stat_variation.2$ncaaf.stat_type.928
#> [1] "-6"
#> 
#> $service$boxscore$team_stats$ncaaf.t.29$ncaaf.stat_variation.2$ncaaf.stat_type.926
#> [1] "0"
#> 
#> $service$boxscore$team_stats$ncaaf.t.29$ncaaf.stat_variation.2$ncaaf.stat_type.929
#> [1] "4"
#> 
#> $service$boxscore$team_stats$ncaaf.t.29$ncaaf.stat_variation.2$ncaaf.stat_type.930
#> [1] "41.0"
#> 
#> $service$boxscore$team_stats$ncaaf.t.29$ncaaf.stat_variation.2$ncaaf.stat_type.933
#> [1] "4"
#> 
#> $service$boxscore$team_stats$ncaaf.t.29$ncaaf.stat_variation.2$ncaaf.stat_type.934
#> [1] "39"
#> 
#> $service$boxscore$team_stats$ncaaf.t.29$ncaaf.stat_variation.2$ncaaf.stat_type.931
#> [1] "1"
#> 
#> $service$boxscore$team_stats$ncaaf.t.29$ncaaf.stat_variation.2$ncaaf.stat_type.932
#> [1] "1"
#> 
#> 
#> 
#> 
#> $service$boxscore$aliases
#> $service$boxscore$aliases$match
#> $service$boxscore$aliases$match$stats
#> $service$boxscore$aliases$match$stats[[1]]
#> $service$boxscore$aliases$match$stats[[1]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[1]]$type
#> [1] "ncaaf.stat_type.102"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[2]]
#> $service$boxscore$aliases$match$stats[[2]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[2]]$type
#> [1] "ncaaf.stat_type.103"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[3]]
#> $service$boxscore$aliases$match$stats[[3]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[3]]$type
#> [1] "ncaaf.stat_type.105"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[4]]
#> $service$boxscore$aliases$match$stats[[4]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[4]]$type
#> [1] "ncaaf.stat_type.104"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[5]]
#> $service$boxscore$aliases$match$stats[[5]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[5]]$type
#> [1] "ncaaf.stat_type.106"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[6]]
#> $service$boxscore$aliases$match$stats[[6]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[6]]$type
#> [1] "ncaaf.stat_type.111"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[7]]
#> $service$boxscore$aliases$match$stats[[7]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[7]]$type
#> [1] "ncaaf.stat_type.112"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[8]]
#> $service$boxscore$aliases$match$stats[[8]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[8]]$type
#> [1] "ncaaf.stat_type.108"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[9]]
#> $service$boxscore$aliases$match$stats[[9]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[9]]$type
#> [1] "ncaaf.stat_type.109"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[10]]
#> $service$boxscore$aliases$match$stats[[10]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[10]]$type
#> [1] "ncaaf.stat_type.113"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[11]]
#> $service$boxscore$aliases$match$stats[[11]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[11]]$type
#> [1] "ncaaf.stat_type.202"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[12]]
#> $service$boxscore$aliases$match$stats[[12]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[12]]$type
#> [1] "ncaaf.stat_type.203"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[13]]
#> $service$boxscore$aliases$match$stats[[13]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[13]]$type
#> [1] "ncaaf.stat_type.205"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[14]]
#> $service$boxscore$aliases$match$stats[[14]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[14]]$type
#> [1] "ncaaf.stat_type.206"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[15]]
#> $service$boxscore$aliases$match$stats[[15]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[15]]$type
#> [1] "ncaaf.stat_type.207"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[16]]
#> $service$boxscore$aliases$match$stats[[16]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[16]]$type
#> [1] "ncaaf.stat_type.302"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[17]]
#> $service$boxscore$aliases$match$stats[[17]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[17]]$type
#> [1] "ncaaf.stat_type.303"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[18]]
#> $service$boxscore$aliases$match$stats[[18]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[18]]$type
#> [1] "ncaaf.stat_type.305"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[19]]
#> $service$boxscore$aliases$match$stats[[19]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[19]]$type
#> [1] "ncaaf.stat_type.306"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[20]]
#> $service$boxscore$aliases$match$stats[[20]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[20]]$type
#> [1] "ncaaf.stat_type.309"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[21]]
#> $service$boxscore$aliases$match$stats[[21]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[21]]$type
#> [1] "ncaaf.stat_type.411"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[22]]
#> $service$boxscore$aliases$match$stats[[22]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[22]]$type
#> [1] "ncaaf.stat_type.412"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[23]]
#> $service$boxscore$aliases$match$stats[[23]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[23]]$type
#> [1] "ncaaf.stat_type.407"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[24]]
#> $service$boxscore$aliases$match$stats[[24]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[24]]$type
#> [1] "ncaaf.stat_type.408"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[25]]
#> $service$boxscore$aliases$match$stats[[25]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[25]]$type
#> [1] "ncaaf.stat_type.410"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[26]]
#> $service$boxscore$aliases$match$stats[[26]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[26]]$type
#> [1] "ncaaf.stat_type.409"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[27]]
#> $service$boxscore$aliases$match$stats[[27]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[27]]$type
#> [1] "ncaaf.stat_type.502"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[28]]
#> $service$boxscore$aliases$match$stats[[28]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[28]]$type
#> [1] "ncaaf.stat_type.503"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[29]]
#> $service$boxscore$aliases$match$stats[[29]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[29]]$type
#> [1] "ncaaf.stat_type.505"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[30]]
#> $service$boxscore$aliases$match$stats[[30]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[30]]$type
#> [1] "ncaaf.stat_type.506"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[31]]
#> $service$boxscore$aliases$match$stats[[31]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[31]]$type
#> [1] "ncaaf.stat_type.507"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[32]]
#> $service$boxscore$aliases$match$stats[[32]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[32]]$type
#> [1] "ncaaf.stat_type.508"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[33]]
#> $service$boxscore$aliases$match$stats[[33]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[33]]$type
#> [1] "ncaaf.stat_type.509"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[34]]
#> $service$boxscore$aliases$match$stats[[34]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[34]]$type
#> [1] "ncaaf.stat_type.511"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[35]]
#> $service$boxscore$aliases$match$stats[[35]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[35]]$type
#> [1] "ncaaf.stat_type.512"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[36]]
#> $service$boxscore$aliases$match$stats[[36]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[36]]$type
#> [1] "ncaaf.stat_type.513"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[37]]
#> $service$boxscore$aliases$match$stats[[37]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[37]]$type
#> [1] "ncaaf.stat_type.602"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[38]]
#> $service$boxscore$aliases$match$stats[[38]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[38]]$type
#> [1] "ncaaf.stat_type.604"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[39]]
#> $service$boxscore$aliases$match$stats[[39]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[39]]$type
#> [1] "ncaaf.stat_type.608"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[40]]
#> $service$boxscore$aliases$match$stats[[40]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[40]]$type
#> [1] "ncaaf.stat_type.702"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[41]]
#> $service$boxscore$aliases$match$stats[[41]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[41]]$type
#> [1] "ncaaf.stat_type.703"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[42]]
#> $service$boxscore$aliases$match$stats[[42]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[42]]$type
#> [1] "ncaaf.stat_type.705"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[43]]
#> $service$boxscore$aliases$match$stats[[43]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[43]]$type
#> [1] "ncaaf.stat_type.706"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[44]]
#> $service$boxscore$aliases$match$stats[[44]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[44]]$type
#> [1] "ncaaf.stat_type.710"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[45]]
#> $service$boxscore$aliases$match$stats[[45]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[45]]$type
#> [1] "ncaaf.stat_type.707"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[46]]
#> $service$boxscore$aliases$match$stats[[46]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[46]]$type
#> [1] "ncaaf.stat_type.708"
#> 
#> 
#> $service$boxscore$aliases$match$stats[[47]]
#> $service$boxscore$aliases$match$stats[[47]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match$stats[[47]]$type
#> [1] "ncaaf.stat_type.709"
#> 
#> 
#> 
#> 
#> $service$boxscore$aliases$match_team
#> $service$boxscore$aliases$match_team$stats
#> $service$boxscore$aliases$match_team$stats[[1]]
#> $service$boxscore$aliases$match_team$stats[[1]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match_team$stats[[1]]$type
#> [1] "ncaaf.stat_type.919"
#> 
#> 
#> $service$boxscore$aliases$match_team$stats[[2]]
#> $service$boxscore$aliases$match_team$stats[[2]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match_team$stats[[2]]$type
#> [1] "ncaaf.stat_type.945"
#> 
#> 
#> $service$boxscore$aliases$match_team$stats[[3]]
#> $service$boxscore$aliases$match_team$stats[[3]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match_team$stats[[3]]$type
#> [1] "ncaaf.stat_type.950"
#> 
#> 
#> $service$boxscore$aliases$match_team$stats[[4]]
#> $service$boxscore$aliases$match_team$stats[[4]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match_team$stats[[4]]$type
#> [1] "ncaaf.stat_type.937"
#> 
#> 
#> $service$boxscore$aliases$match_team$stats[[5]]
#> $service$boxscore$aliases$match_team$stats[[5]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match_team$stats[[5]]$type
#> [1] "ncaaf.stat_type.936"
#> 
#> 
#> $service$boxscore$aliases$match_team$stats[[6]]
#> $service$boxscore$aliases$match_team$stats[[6]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match_team$stats[[6]]$type
#> [1] "ncaaf.stat_type.938"
#> 
#> 
#> $service$boxscore$aliases$match_team$stats[[7]]
#> $service$boxscore$aliases$match_team$stats[[7]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match_team$stats[[7]]$type
#> [1] "ncaaf.stat_type.941"
#> 
#> 
#> $service$boxscore$aliases$match_team$stats[[8]]
#> $service$boxscore$aliases$match_team$stats[[8]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match_team$stats[[8]]$type
#> [1] "ncaaf.stat_type.944"
#> 
#> 
#> $service$boxscore$aliases$match_team$stats[[9]]
#> $service$boxscore$aliases$match_team$stats[[9]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match_team$stats[[9]]$type
#> [1] "ncaaf.stat_type.946"
#> 
#> 
#> $service$boxscore$aliases$match_team$stats[[10]]
#> $service$boxscore$aliases$match_team$stats[[10]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match_team$stats[[10]]$type
#> [1] "ncaaf.stat_type.952"
#> 
#> 
#> $service$boxscore$aliases$match_team$stats[[11]]
#> $service$boxscore$aliases$match_team$stats[[11]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match_team$stats[[11]]$type
#> [1] "ncaaf.stat_type.921"
#> 
#> 
#> $service$boxscore$aliases$match_team$stats[[12]]
#> $service$boxscore$aliases$match_team$stats[[12]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match_team$stats[[12]]$type
#> [1] "ncaaf.stat_type.920"
#> 
#> 
#> $service$boxscore$aliases$match_team$stats[[13]]
#> $service$boxscore$aliases$match_team$stats[[13]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match_team$stats[[13]]$type
#> [1] "ncaaf.stat_type.949"
#> 
#> 
#> $service$boxscore$aliases$match_team$stats[[14]]
#> $service$boxscore$aliases$match_team$stats[[14]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match_team$stats[[14]]$type
#> [1] "ncaaf.stat_type.947"
#> 
#> 
#> $service$boxscore$aliases$match_team$stats[[15]]
#> $service$boxscore$aliases$match_team$stats[[15]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match_team$stats[[15]]$type
#> [1] "ncaaf.stat_type.951"
#> 
#> 
#> $service$boxscore$aliases$match_team$stats[[16]]
#> $service$boxscore$aliases$match_team$stats[[16]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match_team$stats[[16]]$type
#> [1] "ncaaf.stat_type.948"
#> 
#> 
#> $service$boxscore$aliases$match_team$stats[[17]]
#> $service$boxscore$aliases$match_team$stats[[17]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match_team$stats[[17]]$type
#> [1] "ncaaf.stat_type.927"
#> 
#> 
#> $service$boxscore$aliases$match_team$stats[[18]]
#> $service$boxscore$aliases$match_team$stats[[18]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match_team$stats[[18]]$type
#> [1] "ncaaf.stat_type.928"
#> 
#> 
#> $service$boxscore$aliases$match_team$stats[[19]]
#> $service$boxscore$aliases$match_team$stats[[19]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match_team$stats[[19]]$type
#> [1] "ncaaf.stat_type.926"
#> 
#> 
#> $service$boxscore$aliases$match_team$stats[[20]]
#> $service$boxscore$aliases$match_team$stats[[20]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match_team$stats[[20]]$type
#> [1] "ncaaf.stat_type.929"
#> 
#> 
#> $service$boxscore$aliases$match_team$stats[[21]]
#> $service$boxscore$aliases$match_team$stats[[21]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match_team$stats[[21]]$type
#> [1] "ncaaf.stat_type.930"
#> 
#> 
#> $service$boxscore$aliases$match_team$stats[[22]]
#> $service$boxscore$aliases$match_team$stats[[22]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match_team$stats[[22]]$type
#> [1] "ncaaf.stat_type.933"
#> 
#> 
#> $service$boxscore$aliases$match_team$stats[[23]]
#> $service$boxscore$aliases$match_team$stats[[23]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match_team$stats[[23]]$type
#> [1] "ncaaf.stat_type.934"
#> 
#> 
#> $service$boxscore$aliases$match_team$stats[[24]]
#> $service$boxscore$aliases$match_team$stats[[24]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match_team$stats[[24]]$type
#> [1] "ncaaf.stat_type.931"
#> 
#> 
#> $service$boxscore$aliases$match_team$stats[[25]]
#> $service$boxscore$aliases$match_team$stats[[25]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$match_team$stats[[25]]$type
#> [1] "ncaaf.stat_type.932"
#> 
#> 
#> 
#> 
#> $service$boxscore$aliases$game_stat_leaders
#> $service$boxscore$aliases$game_stat_leaders$stats
#> $service$boxscore$aliases$game_stat_leaders$stats[[1]]
#> $service$boxscore$aliases$game_stat_leaders$stats[[1]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$game_stat_leaders$stats[[1]]$type
#> [1] "ncaaf.stat_type.105"
#> 
#> 
#> $service$boxscore$aliases$game_stat_leaders$stats[[2]]
#> $service$boxscore$aliases$game_stat_leaders$stats[[2]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$game_stat_leaders$stats[[2]]$type
#> [1] "ncaaf.stat_type.108"
#> 
#> 
#> $service$boxscore$aliases$game_stat_leaders$stats[[3]]
#> $service$boxscore$aliases$game_stat_leaders$stats[[3]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$game_stat_leaders$stats[[3]]$type
#> [1] "ncaaf.stat_type.109"
#> 
#> 
#> $service$boxscore$aliases$game_stat_leaders$stats[[4]]
#> $service$boxscore$aliases$game_stat_leaders$stats[[4]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$game_stat_leaders$stats[[4]]$type
#> [1] "ncaaf.stat_type.203"
#> 
#> 
#> $service$boxscore$aliases$game_stat_leaders$stats[[5]]
#> $service$boxscore$aliases$game_stat_leaders$stats[[5]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$game_stat_leaders$stats[[5]]$type
#> [1] "ncaaf.stat_type.207"
#> 
#> 
#> $service$boxscore$aliases$game_stat_leaders$stats[[6]]
#> $service$boxscore$aliases$game_stat_leaders$stats[[6]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$game_stat_leaders$stats[[6]]$type
#> [1] "ncaaf.stat_type.302"
#> 
#> 
#> $service$boxscore$aliases$game_stat_leaders$stats[[7]]
#> $service$boxscore$aliases$game_stat_leaders$stats[[7]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$game_stat_leaders$stats[[7]]$type
#> [1] "ncaaf.stat_type.303"
#> 
#> 
#> $service$boxscore$aliases$game_stat_leaders$stats[[8]]
#> $service$boxscore$aliases$game_stat_leaders$stats[[8]]$variation
#> [1] "ncaaf.stat_variation.2"
#> 
#> $service$boxscore$aliases$game_stat_leaders$stats[[8]]$type
#> [1] "ncaaf.stat_type.309"
#> 
#> 
#> 
#> 
#> $service$boxscore$aliases$team_game_totals
#> $service$boxscore$aliases$team_game_totals$stats
#> list()
#> 
#> 
#> 
#> $service$boxscore$stat_categories
#> $service$boxscore$stat_categories$ncaaf.stat_category.1
#> $service$boxscore$stat_categories$ncaaf.stat_category.1$name
#> [1] "Passing"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.1$sort
#> [1] "ncaaf.stat_type.105"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.1$stats
#> $service$boxscore$stat_categories$ncaaf.stat_category.1$stats[[1]]
#> [1] "ncaaf.stat_type.102"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.1$stats[[2]]
#> [1] "ncaaf.stat_type.103"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.1$stats[[3]]
#> [1] "ncaaf.stat_type.104"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.1$stats[[4]]
#> [1] "ncaaf.stat_type.105"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.1$stats[[5]]
#> [1] "ncaaf.stat_type.106"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.1$stats[[6]]
#> [1] "ncaaf.stat_type.108"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.1$stats[[7]]
#> [1] "ncaaf.stat_type.109"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.1$stats[[8]]
#> [1] "ncaaf.stat_type.111"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.1$stats[[9]]
#> [1] "ncaaf.stat_type.112"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.1$stats[[10]]
#> [1] "ncaaf.stat_type.113"
#> 
#> 
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.2
#> $service$boxscore$stat_categories$ncaaf.stat_category.2$name
#> [1] "Rushing"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.2$sort
#> [1] "ncaaf.stat_type.203"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.2$stats
#> $service$boxscore$stat_categories$ncaaf.stat_category.2$stats[[1]]
#> [1] "ncaaf.stat_type.202"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.2$stats[[2]]
#> [1] "ncaaf.stat_type.203"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.2$stats[[3]]
#> [1] "ncaaf.stat_type.205"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.2$stats[[4]]
#> [1] "ncaaf.stat_type.206"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.2$stats[[5]]
#> [1] "ncaaf.stat_type.207"
#> 
#> 
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.3
#> $service$boxscore$stat_categories$ncaaf.stat_category.3$name
#> [1] "Receiving"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.3$sort
#> [1] "ncaaf.stat_type.303"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.3$stats
#> $service$boxscore$stat_categories$ncaaf.stat_category.3$stats[[1]]
#> [1] "ncaaf.stat_type.302"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.3$stats[[2]]
#> [1] "ncaaf.stat_type.303"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.3$stats[[3]]
#> [1] "ncaaf.stat_type.305"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.3$stats[[4]]
#> [1] "ncaaf.stat_type.306"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.3$stats[[5]]
#> [1] "ncaaf.stat_type.309"
#> 
#> 
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.4
#> $service$boxscore$stat_categories$ncaaf.stat_category.4$name
#> [1] "Kicking"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.4$sort
#> [1] "ncaaf.stat_type.403"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.4$stats
#> $service$boxscore$stat_categories$ncaaf.stat_category.4$stats[[1]]
#> [1] "ncaaf.stat_type.407"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.4$stats[[2]]
#> [1] "ncaaf.stat_type.408"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.4$stats[[3]]
#> [1] "ncaaf.stat_type.409"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.4$stats[[4]]
#> [1] "ncaaf.stat_type.410"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.4$stats[[5]]
#> [1] "ncaaf.stat_type.411"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.4$stats[[6]]
#> [1] "ncaaf.stat_type.412"
#> 
#> 
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.5
#> $service$boxscore$stat_categories$ncaaf.stat_category.5$name
#> [1] "Returns"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.5$sort
#> [1] "ncaaf.stat_type.503"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.5$stats
#> $service$boxscore$stat_categories$ncaaf.stat_category.5$stats[[1]]
#> [1] "ncaaf.stat_type.502"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.5$stats[[2]]
#> [1] "ncaaf.stat_type.503"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.5$stats[[3]]
#> [1] "ncaaf.stat_type.505"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.5$stats[[4]]
#> [1] "ncaaf.stat_type.506"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.5$stats[[5]]
#> [1] "ncaaf.stat_type.507"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.5$stats[[6]]
#> [1] "ncaaf.stat_type.508"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.5$stats[[7]]
#> [1] "ncaaf.stat_type.509"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.5$stats[[8]]
#> [1] "ncaaf.stat_type.511"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.5$stats[[9]]
#> [1] "ncaaf.stat_type.512"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.5$stats[[10]]
#> [1] "ncaaf.stat_type.513"
#> 
#> 
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.6
#> $service$boxscore$stat_categories$ncaaf.stat_category.6$name
#> [1] "Punting"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.6$sort
#> [1] "ncaaf.stat_type.603"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.6$stats
#> $service$boxscore$stat_categories$ncaaf.stat_category.6$stats[[1]]
#> [1] "ncaaf.stat_type.602"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.6$stats[[2]]
#> [1] "ncaaf.stat_type.604"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.6$stats[[3]]
#> [1] "ncaaf.stat_type.608"
#> 
#> 
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.7
#> $service$boxscore$stat_categories$ncaaf.stat_category.7$name
#> [1] "Defense"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.7$sort
#> [1] "ncaaf.stat_type.707"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.7$stats
#> $service$boxscore$stat_categories$ncaaf.stat_category.7$stats[[1]]
#> [1] "ncaaf.stat_type.702"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.7$stats[[2]]
#> [1] "ncaaf.stat_type.703"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.7$stats[[3]]
#> [1] "ncaaf.stat_type.705"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.7$stats[[4]]
#> [1] "ncaaf.stat_type.706"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.7$stats[[5]]
#> [1] "ncaaf.stat_type.707"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.7$stats[[6]]
#> [1] "ncaaf.stat_type.708"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.7$stats[[7]]
#> [1] "ncaaf.stat_type.709"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.7$stats[[8]]
#> [1] "ncaaf.stat_type.710"
#> 
#> 
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.9
#> $service$boxscore$stat_categories$ncaaf.stat_category.9$name
#> [1] "Team"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.9$sort
#> [1] "ncaaf.stat_type.901"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.9$stats
#> $service$boxscore$stat_categories$ncaaf.stat_category.9$stats[[1]]
#> [1] "ncaaf.stat_type.919"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.9$stats[[2]]
#> [1] "ncaaf.stat_type.920"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.9$stats[[3]]
#> [1] "ncaaf.stat_type.921"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.9$stats[[4]]
#> [1] "ncaaf.stat_type.926"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.9$stats[[5]]
#> [1] "ncaaf.stat_type.927"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.9$stats[[6]]
#> [1] "ncaaf.stat_type.928"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.9$stats[[7]]
#> [1] "ncaaf.stat_type.929"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.9$stats[[8]]
#> [1] "ncaaf.stat_type.930"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.9$stats[[9]]
#> [1] "ncaaf.stat_type.931"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.9$stats[[10]]
#> [1] "ncaaf.stat_type.932"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.9$stats[[11]]
#> [1] "ncaaf.stat_type.933"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.9$stats[[12]]
#> [1] "ncaaf.stat_type.934"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.9$stats[[13]]
#> [1] "ncaaf.stat_type.936"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.9$stats[[14]]
#> [1] "ncaaf.stat_type.937"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.9$stats[[15]]
#> [1] "ncaaf.stat_type.938"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.9$stats[[16]]
#> [1] "ncaaf.stat_type.941"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.9$stats[[17]]
#> [1] "ncaaf.stat_type.944"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.9$stats[[18]]
#> [1] "ncaaf.stat_type.945"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.9$stats[[19]]
#> [1] "ncaaf.stat_type.946"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.9$stats[[20]]
#> [1] "ncaaf.stat_type.947"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.9$stats[[21]]
#> [1] "ncaaf.stat_type.948"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.9$stats[[22]]
#> [1] "ncaaf.stat_type.949"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.9$stats[[23]]
#> [1] "ncaaf.stat_type.950"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.9$stats[[24]]
#> [1] "ncaaf.stat_type.951"
#> 
#> $service$boxscore$stat_categories$ncaaf.stat_category.9$stats[[25]]
#> [1] "ncaaf.stat_type.952"
#> 
#> 
#> 
#> 
#> $service$boxscore$stat_variations
#> $service$boxscore$stat_variations$ncaaf.stat_variation.2
#> $service$boxscore$stat_variations$ncaaf.stat_variation.2$name
#> [1] "Game"
#> 
#> 
#> 
#> $service$boxscore$stat_types
#> $service$boxscore$stat_types$ncaaf.stat_type.102
#> $service$boxscore$stat_types$ncaaf.stat_type.102$name
#> [1] "Completions"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.102$short_name
#> [1] "Comp"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.103
#> $service$boxscore$stat_types$ncaaf.stat_type.103$name
#> [1] "Attempts"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.103$short_name
#> [1] "Att"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.105
#> $service$boxscore$stat_types$ncaaf.stat_type.105$name
#> [1] "Yards"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.105$short_name
#> [1] "Yds"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.104
#> $service$boxscore$stat_types$ncaaf.stat_type.104$name
#> [1] "Completion Percentage"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.104$short_name
#> [1] "Pct"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.106
#> $service$boxscore$stat_types$ncaaf.stat_type.106$name
#> [1] "Yards per Attempt"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.106$short_name
#> [1] "Y/A"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.111
#> $service$boxscore$stat_types$ncaaf.stat_type.111$name
#> [1] "Sacks"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.111$short_name
#> [1] "Sack"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.112
#> $service$boxscore$stat_types$ncaaf.stat_type.112$name
#> [1] "Yards Lost"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.112$short_name
#> [1] "YdsL"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.108
#> $service$boxscore$stat_types$ncaaf.stat_type.108$name
#> [1] "Touchdowns"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.108$short_name
#> [1] "TD"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.109
#> $service$boxscore$stat_types$ncaaf.stat_type.109$name
#> [1] "Interceptions"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.109$short_name
#> [1] "Int"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.113
#> $service$boxscore$stat_types$ncaaf.stat_type.113$name
#> [1] "QB Rating"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.113$short_name
#> [1] "QBRat"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.202
#> $service$boxscore$stat_types$ncaaf.stat_type.202$name
#> [1] "Rushes"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.202$short_name
#> [1] "Rush"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.203
#> $service$boxscore$stat_types$ncaaf.stat_type.203$name
#> [1] "Yards"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.203$short_name
#> [1] "Yds"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.205
#> $service$boxscore$stat_types$ncaaf.stat_type.205$name
#> [1] "Average"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.205$short_name
#> [1] "Avg"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.206
#> $service$boxscore$stat_types$ncaaf.stat_type.206$name
#> [1] "Longest"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.206$short_name
#> [1] "Long"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.207
#> $service$boxscore$stat_types$ncaaf.stat_type.207$name
#> [1] "Touchdowns"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.207$short_name
#> [1] "TD"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.302
#> $service$boxscore$stat_types$ncaaf.stat_type.302$name
#> [1] "Receptions"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.302$short_name
#> [1] "Rec"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.303
#> $service$boxscore$stat_types$ncaaf.stat_type.303$name
#> [1] "Yards"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.303$short_name
#> [1] "Yds"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.305
#> $service$boxscore$stat_types$ncaaf.stat_type.305$name
#> [1] "Average"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.305$short_name
#> [1] "Avg"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.306
#> $service$boxscore$stat_types$ncaaf.stat_type.306$name
#> [1] "Longest"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.306$short_name
#> [1] "Long"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.309
#> $service$boxscore$stat_types$ncaaf.stat_type.309$name
#> [1] "Touchdowns"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.309$short_name
#> [1] "TD"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.411
#> $service$boxscore$stat_types$ncaaf.stat_type.411$name
#> [1] "Extra Points Made"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.411$short_name
#> [1] "XPM"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.412
#> $service$boxscore$stat_types$ncaaf.stat_type.412$name
#> [1] "Extra Points Attempted"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.412$short_name
#> [1] "XPA"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.407
#> $service$boxscore$stat_types$ncaaf.stat_type.407$name
#> [1] "Total Made"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.407$short_name
#> [1] "FGM"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.408
#> $service$boxscore$stat_types$ncaaf.stat_type.408$name
#> [1] "Total Attempted"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.408$short_name
#> [1] "FGA"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.410
#> $service$boxscore$stat_types$ncaaf.stat_type.410$name
#> [1] "Long"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.410$short_name
#> [1] "Long"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.409
#> $service$boxscore$stat_types$ncaaf.stat_type.409$name
#> [1] "Percent"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.409$short_name
#> [1] "Pct"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.502
#> $service$boxscore$stat_types$ncaaf.stat_type.502$name
#> [1] "Kickoff Returns"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.502$short_name
#> [1] "KR"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.503
#> $service$boxscore$stat_types$ncaaf.stat_type.503$name
#> [1] "Yards"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.503$short_name
#> [1] "Yds"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.505
#> $service$boxscore$stat_types$ncaaf.stat_type.505$name
#> [1] "Average"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.505$short_name
#> [1] "Avg"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.506
#> $service$boxscore$stat_types$ncaaf.stat_type.506$name
#> [1] "Longest"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.506$short_name
#> [1] "Long"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.507
#> $service$boxscore$stat_types$ncaaf.stat_type.507$name
#> [1] "Touchdowns"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.507$short_name
#> [1] "TD"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.508
#> $service$boxscore$stat_types$ncaaf.stat_type.508$name
#> [1] "Punt Returns"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.508$short_name
#> [1] "PR"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.509
#> $service$boxscore$stat_types$ncaaf.stat_type.509$name
#> [1] "Yards"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.509$short_name
#> [1] "Yds"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.511
#> $service$boxscore$stat_types$ncaaf.stat_type.511$name
#> [1] "Average"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.511$short_name
#> [1] "Avg"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.512
#> $service$boxscore$stat_types$ncaaf.stat_type.512$name
#> [1] "Longest"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.512$short_name
#> [1] "Long"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.513
#> $service$boxscore$stat_types$ncaaf.stat_type.513$name
#> [1] "Touchdowns"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.513$short_name
#> [1] "TD"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.602
#> $service$boxscore$stat_types$ncaaf.stat_type.602$name
#> [1] "Punts"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.602$short_name
#> [1] "Punt"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.604
#> $service$boxscore$stat_types$ncaaf.stat_type.604$name
#> [1] "Average"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.604$short_name
#> [1] "Avg"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.608
#> $service$boxscore$stat_types$ncaaf.stat_type.608$name
#> [1] "Longest"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.608$short_name
#> [1] "Long"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.702
#> $service$boxscore$stat_types$ncaaf.stat_type.702$name
#> [1] "Solo Tackles"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.702$short_name
#> [1] "Solo"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.703
#> $service$boxscore$stat_types$ncaaf.stat_type.703$name
#> [1] "Tackle Assists"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.703$short_name
#> [1] "Ast"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.705
#> $service$boxscore$stat_types$ncaaf.stat_type.705$name
#> [1] "Sacks"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.705$short_name
#> [1] "Sack"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.706
#> $service$boxscore$stat_types$ncaaf.stat_type.706$name
#> [1] "Yards Lost"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.706$short_name
#> [1] "YdsL"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.710
#> $service$boxscore$stat_types$ncaaf.stat_type.710$name
#> [1] "Passes Defended"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.710$short_name
#> [1] "PD"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.707
#> $service$boxscore$stat_types$ncaaf.stat_type.707$name
#> [1] "Interceptions"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.707$short_name
#> [1] "Int"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.708
#> $service$boxscore$stat_types$ncaaf.stat_type.708$name
#> [1] "Yards"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.708$short_name
#> [1] "Yds"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.709
#> $service$boxscore$stat_types$ncaaf.stat_type.709$name
#> [1] "Interception Touchdowns"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.709$short_name
#> [1] "IntTD"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.919
#> $service$boxscore$stat_types$ncaaf.stat_type.919$name
#> [1] "First Downs"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.919$short_name
#> [1] "Firsts"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.945
#> $service$boxscore$stat_types$ncaaf.stat_type.945$name
#> [1] "Total Yards"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.945$short_name
#> [1] "TOTYDS"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.950
#> $service$boxscore$stat_types$ncaaf.stat_type.950$name
#> [1] "Turnovers"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.950$short_name
#> [1] "TO"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.937
#> $service$boxscore$stat_types$ncaaf.stat_type.937$name
#> [1] "Passes for First"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.937$short_name
#> [1] "PASSF"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.936
#> $service$boxscore$stat_types$ncaaf.stat_type.936$name
#> [1] "Rushes for First"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.936$short_name
#> [1] "RUSHF"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.938
#> $service$boxscore$stat_types$ncaaf.stat_type.938$name
#> [1] "Penalties for First"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.938$short_name
#> [1] "PENF"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.941
#> $service$boxscore$stat_types$ncaaf.stat_type.941$name
#> [1] "Third Down Efficiency"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.941$short_name
#> [1] "3DE"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.944
#> $service$boxscore$stat_types$ncaaf.stat_type.944$name
#> [1] "Fourth Down Efficiency"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.944$short_name
#> [1] "4DE"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.946
#> $service$boxscore$stat_types$ncaaf.stat_type.946$name
#> [1] "Total Plays"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.946$short_name
#> [1] "TOTPLAYS"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.952
#> $service$boxscore$stat_types$ncaaf.stat_type.952$name
#> [1] "Avg Gain Per Play"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.952$short_name
#> [1] "AVGPYDS"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.921
#> $service$boxscore$stat_types$ncaaf.stat_type.921$name
#> [1] "Net Yards Rushing"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.921$short_name
#> [1] "RYDS"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.920
#> $service$boxscore$stat_types$ncaaf.stat_type.920$name
#> [1] "Rushes"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.920$short_name
#> [1] "Rushes"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.949
#> $service$boxscore$stat_types$ncaaf.stat_type.949$name
#> [1] "Yards Per Rush"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.949$short_name
#> [1] "AVGRYDS"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.947
#> $service$boxscore$stat_types$ncaaf.stat_type.947$name
#> [1] "Net Yards Passing"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.947$short_name
#> [1] "NETPYDS"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.951
#> $service$boxscore$stat_types$ncaaf.stat_type.951$name
#> [1] "Comp-Att"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.951$short_name
#> [1] "PASSEFF"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.948
#> $service$boxscore$stat_types$ncaaf.stat_type.948$name
#> [1] "Yards Per Pass"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.948$short_name
#> [1] "AVGPYDS"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.927
#> $service$boxscore$stat_types$ncaaf.stat_type.927$name
#> [1] "Times Sacked"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.927$short_name
#> [1] "SACKS"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.928
#> $service$boxscore$stat_types$ncaaf.stat_type.928$name
#> [1] "Yds Lost To Sacks"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.928$short_name
#> [1] "SACKYD"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.926
#> $service$boxscore$stat_types$ncaaf.stat_type.926$name
#> [1] "Interceptions"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.926$short_name
#> [1] "INTS"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.929
#> $service$boxscore$stat_types$ncaaf.stat_type.929$name
#> [1] "Punts"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.929$short_name
#> [1] "PUNTS"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.930
#> $service$boxscore$stat_types$ncaaf.stat_type.930$name
#> [1] "Punt Average"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.930$short_name
#> [1] "PUNTAVG"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.933
#> $service$boxscore$stat_types$ncaaf.stat_type.933$name
#> [1] "Penalties"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.933$short_name
#> [1] "PEN"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.934
#> $service$boxscore$stat_types$ncaaf.stat_type.934$name
#> [1] "Penalty Yards"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.934$short_name
#> [1] "PENYD"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.931
#> $service$boxscore$stat_types$ncaaf.stat_type.931$name
#> [1] "Fumbles"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.931$short_name
#> [1] "FUMB"
#> 
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.932
#> $service$boxscore$stat_types$ncaaf.stat_type.932$name
#> [1] "Fumbles Lost"
#> 
#> $service$boxscore$stat_types$ncaaf.stat_type.932$short_name
#> [1] "FUMBLOST"
#> 
#> 
#> 
#> $service$boxscore$stat_cut_types
#> $service$boxscore$stat_cut_types$ncaaf.cut_type.0
#> $service$boxscore$stat_cut_types$ncaaf.cut_type.0$name
#> [1] "Any"
#> 
#> 
#> 
#> $service$boxscore$games
#> $service$boxscore$games$ncaaf.g.202509200023
#> $service$boxscore$games$ncaaf.g.202509200023$gameid
#> [1] "ncaaf.g.202509200023"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$global_gameid
#> [1] "ncaaf.g.13556882"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$start_time
#> [1] "Sat, 20 Sep 2025 19:30:00 +0000"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$is_time_tba
#> [1] FALSE
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$season_phase_id
#> [1] "season.phase.season"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_type
#> NULL
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$winning_team_id
#> [1] "ncaaf.t.29"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$is_rank_upset
#> NULL
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$is_spread_upset
#> [1] FALSE
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$outcome_type
#> [1] "outcome.type.won"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$home_team_id
#> [1] "ncaaf.t.23"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$away_team_id
#> [1] "ncaaf.t.29"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$week_number
#> [1] "4"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$navigation_links
#> $service$boxscore$games$ncaaf.g.202509200023$navigation_links$tickets
#> $service$boxscore$games$ncaaf.g.202509200023$navigation_links$tickets$url
#> [1] "https://seatgeek.com/nebraska-cornhuskers-football-tickets?aid=14&date=2025-09-20"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$navigation_links$boxscore
#> $service$boxscore$games$ncaaf.g.202509200023$navigation_links$boxscore$url
#> [1] "/ncaaf/michigan-wolverines-nebraska-cornhuskers-202509200023/"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$navigation_links$match_page
#> $service$boxscore$games$ncaaf.g.202509200023$navigation_links$match_page$url
#> [1] "/ncaaf/michigan-wolverines-nebraska-cornhuskers-202509200023/"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$navigation_links$recap
#> $service$boxscore$games$ncaaf.g.202509200023$navigation_links$recap$url
#> [1] "/no-21-michigan-uses-3-232307623.html"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$navigation_links$league_home
#> $service$boxscore$games$ncaaf.g.202509200023$navigation_links$league_home$url
#> [1] "/ncaa/football"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$navigation_links$league_scores
#> $service$boxscore$games$ncaaf.g.202509200023$navigation_links$league_scores$url
#> [1] "/ncaa/football/scoreboard"
#> 
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$sportacular_url
#> [1] "ysportacular://v2/scores/details?gameId=ncaaf.g.202509200023&sport=ncaaf"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$status_display_name
#> [1] "Final"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$status_description
#> [1] "Final"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$status_type
#> [1] "status.type.final"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$total_away_points
#> [1] "30"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$current_period_id
#> [1] "4"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$total_home_points
#> [1] "27"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$total_away_shootout_points
#> NULL
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$total_home_shootout_points
#> NULL
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$home_team_stats
#> NULL
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$away_team_stats
#> NULL
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_period_balls
#> NULL
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_period_strikes
#> NULL
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_period_outs
#> NULL
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$yards_to_endzone
#> NULL
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$start_yardline
#> NULL
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$distance
#> NULL
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$down
#> NULL
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$team_in_possession
#> NULL
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$power_play_strength_home
#> NULL
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$power_play_strength_away
#> NULL
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_time_elapsed
#> NULL
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_time_elapsed_display
#> NULL
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$inning_status
#> NULL
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$away_timeouts
#> NULL
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$home_timeouts
#> NULL
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$is_halftime
#> [1] "false"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$minimum_periods
#> [1] 4
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods[[1]]
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods[[1]]$period_id
#> [1] 1
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods[[1]]$display_name
#> [1] "1st"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods[[1]]$short_name
#> [1] 1
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods[[1]]$full_name
#> [1] "1st Quarter"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods[[1]]$away_points
#> [1] "10"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods[[1]]$home_points
#> [1] "0"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods[[2]]
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods[[2]]$period_id
#> [1] 2
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods[[2]]$display_name
#> [1] "2nd"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods[[2]]$short_name
#> [1] 2
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods[[2]]$full_name
#> [1] "2nd Quarter"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods[[2]]$away_points
#> [1] "7"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods[[2]]$home_points
#> [1] "17"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods[[3]]
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods[[3]]$period_id
#> [1] 3
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods[[3]]$display_name
#> [1] "3rd"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods[[3]]$short_name
#> [1] 3
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods[[3]]$full_name
#> [1] "3rd Quarter"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods[[3]]$away_points
#> [1] "10"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods[[3]]$home_points
#> [1] "0"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods[[4]]
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods[[4]]$period_id
#> [1] 4
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods[[4]]$display_name
#> [1] "4th"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods[[4]]$short_name
#> [1] 4
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods[[4]]$full_name
#> [1] "4th Quarter"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods[[4]]$away_points
#> [1] "3"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_periods[[4]]$home_points
#> [1] "10"
#> 
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$baserunners
#> NULL
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$season
#> [1] "2025"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$subleague
#> NULL
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$subleague_display_name
#> NULL
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$agg_score
#> NULL
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$leg_number
#> NULL
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$tv_coverage
#> [1] "CBS"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$provider_coverage
#> $service$boxscore$games$ncaaf.g.202509200023$provider_coverage$score_update_frequency_in_minutes
#> [1] "5"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$provider_coverage$has_plays
#> [1] "true"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$provider_coverage$has_stats
#> [1] "true"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$provider_coverage$has_extended_stats
#> [1] "true"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$provider_coverage$has_final_stats
#> [1] "true"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$seatgeek_id
#> NULL
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$last_updated
#> [1] "2025-09-20 17:40:29"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$teams
#> $service$boxscore$games$ncaaf.g.202509200023$teams[[1]]
#> [1] "dataIslandPaths"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$teams[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$teams[[3]]
#> [1] "teams"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$play_by_play
#> $service$boxscore$games$ncaaf.g.202509200023$play_by_play[[1]]
#> [1] "gameplay_by_play"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$play_by_play[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$pitches
#> $service$boxscore$games$ncaaf.g.202509200023$pitches[[1]]
#> [1] "gamepitches"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$pitches[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$at_bat
#> $service$boxscore$games$ncaaf.g.202509200023$at_bat[[1]]
#> [1] "gameat_bat"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$at_bat[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$penalty_summary
#> $service$boxscore$games$ncaaf.g.202509200023$penalty_summary[[1]]
#> [1] "gamepenalty_summary"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$penalty_summary[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$scoring_summary
#> $service$boxscore$games$ncaaf.g.202509200023$scoring_summary[[1]]
#> [1] "gamescoring_summary"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$scoring_summary[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$stat_categories
#> $service$boxscore$games$ncaaf.g.202509200023$stat_categories[[1]]
#> [1] "game_stat_leaders"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$stadium
#> $service$boxscore$games$ncaaf.g.202509200023$stadium[[1]]
#> [1] "gamestadium"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$stadium[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$stadium_id
#> $service$boxscore$games$ncaaf.g.202509200023$stadium_id[[1]]
#> [1] "gamestadium_id"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$stadium_id[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$stadium_image
#> $service$boxscore$games$ncaaf.g.202509200023$stadium_image[[1]]
#> [1] "gamestadium_image"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$stadium_image[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$attendance
#> $service$boxscore$games$ncaaf.g.202509200023$attendance[[1]]
#> [1] "gameattendance"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$attendance[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$lineups
#> $service$boxscore$games$ncaaf.g.202509200023$lineups[[1]]
#> [1] "gamelineups"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$lineups[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$top_performer
#> $service$boxscore$games$ncaaf.g.202509200023$top_performer[[1]]
#> [1] "gametop_performer"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$top_performer[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$players
#> $service$boxscore$games$ncaaf.g.202509200023$players[[1]]
#> [1] "dataIslandPaths"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$players[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$players[[3]]
#> [1] "players"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$byline
#> $service$boxscore$games$ncaaf.g.202509200023$byline[[1]]
#> [1] "gamebyline"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$byline[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$highlight
#> $service$boxscore$games$ncaaf.g.202509200023$highlight[[1]]
#> [1] "gamehighlight"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$highlight[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$highlights
#> $service$boxscore$games$ncaaf.g.202509200023$highlights[[1]]
#> [1] "gamehighlights"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$highlights[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$live_video
#> $service$boxscore$games$ncaaf.g.202509200023$live_video[[1]]
#> [1] "gamelive_video"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$live_video[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$odds
#> $service$boxscore$games$ncaaf.g.202509200023$odds[[1]]
#> [1] "gameodds"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$odds[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$current_players
#> $service$boxscore$games$ncaaf.g.202509200023$current_players[[1]]
#> [1] "gamecurrent_players"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$current_players[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$last_play
#> $service$boxscore$games$ncaaf.g.202509200023$last_play[[1]]
#> [1] "gamelast_play"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$last_play[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$series_type
#> $service$boxscore$games$ncaaf.g.202509200023$series_type[[1]]
#> [1] "gameseries_type"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$series_type[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$series_status
#> $service$boxscore$games$ncaaf.g.202509200023$series_status[[1]]
#> [1] "gameseries_status"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$series_status[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$games
#> $service$boxscore$games$ncaaf.g.202509200023$games[[1]]
#> [1] "dataIslandPaths"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$games[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$games[[3]]
#> [1] "games"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$series_games
#> $service$boxscore$games$ncaaf.g.202509200023$series_games[[1]]
#> [1] "gameseries_games"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$series_games[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_details
#> $service$boxscore$games$ncaaf.g.202509200023$game_details[[1]]
#> [1] "gamegame_details"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$game_details[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$section_notes
#> $service$boxscore$games$ncaaf.g.202509200023$section_notes[[1]]
#> [1] "gamesection_notes"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$section_notes[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$articles
#> $service$boxscore$games$ncaaf.g.202509200023$articles[[1]]
#> [1] "dataIslandPaths"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$articles[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$articles[[3]]
#> [1] "gamearticles"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$tweets
#> $service$boxscore$games$ncaaf.g.202509200023$tweets[[1]]
#> [1] "gametweets"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$tweets[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$playoff_round
#> $service$boxscore$games$ncaaf.g.202509200023$playoff_round[[1]]
#> [1] "gameplayoff_round"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$playoff_round[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$media_stream
#> $service$boxscore$games$ncaaf.g.202509200023$media_stream[[1]]
#> [1] "gamemedia_stream"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$media_stream[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$playoff_series_status
#> $service$boxscore$games$ncaaf.g.202509200023$playoff_series_status[[1]]
#> [1] "gameplayoff_series_status"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$playoff_series_status[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$playoff_series_details
#> $service$boxscore$games$ncaaf.g.202509200023$playoff_series_details[[1]]
#> [1] "gameplayoff_series_details"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$playoff_series_details[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$drives
#> $service$boxscore$games$ncaaf.g.202509200023$drives[[1]]
#> [1] "gamedrives"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$drives[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$user_teams_game
#> $service$boxscore$games$ncaaf.g.202509200023$user_teams_game[[1]]
#> [1] "gameuser_teams_game"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$user_teams_game[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$page_metadata
#> $service$boxscore$games$ncaaf.g.202509200023$page_metadata[[1]]
#> [1] "gamepage_metadata"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$page_metadata[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$penalty_box
#> $service$boxscore$games$ncaaf.g.202509200023$penalty_box[[1]]
#> [1] "gamepenalty_box"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$penalty_box[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$starting_pitchers
#> $service$boxscore$games$ncaaf.g.202509200023$starting_pitchers[[1]]
#> [1] "gamestarting_pitchers"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$starting_pitchers[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$unrestricted_streams
#> $service$boxscore$games$ncaaf.g.202509200023$unrestricted_streams[[1]]
#> [1] "gameunrestricted_streams"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$unrestricted_streams[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$tv_details
#> $service$boxscore$games$ncaaf.g.202509200023$tv_details[[1]]
#> [1] "gametv_details"
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$tv_details[[2]]
#> [1] "ncaaf.g.202509200023"
#> 
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$away_seed
#> NULL
#> 
#> $service$boxscore$games$ncaaf.g.202509200023$home_seed
#> NULL
#> 
#> 
#> 
#> $service$boxscore$gameplayoff_round
#> $service$boxscore$gameplayoff_round$ncaaf.g.202509200023
#> NULL
#> 
#> 
#> $service$boxscore$gameplayoff_series_status
#> $service$boxscore$gameplayoff_series_status$ncaaf.g.202509200023
#> NULL
#> 
#> 
#> $service$boxscore$gameplayoff_series_details
#> $service$boxscore$gameplayoff_series_details$ncaaf.g.202509200023
#> NULL
#> 
#> 
#> $service$boxscore$gamescore
#> $service$boxscore$gamescore$ncaaf.g.202509200023
#> [1] "Michigan Wolverines 30 - Nebraska Cornhuskers 27: Final"
#> 
#> 
#> $service$boxscore$gamecurrent_players
#> $service$boxscore$gamecurrent_players$ncaaf.g.202509200023
#> $service$boxscore$gamecurrent_players$ncaaf.g.202509200023$current_batter
#> NULL
#> 
#> $service$boxscore$gamecurrent_players$ncaaf.g.202509200023$current_pitcher
#> NULL
#> 
#> $service$boxscore$gamecurrent_players$ncaaf.g.202509200023$base_runners
#> list()
#> 
#> $service$boxscore$gamecurrent_players$ncaaf.g.202509200023$due_ups
#> list()
#> 
#> 
#> 
#> $service$boxscore$gamelast_play
#> $service$boxscore$gamelast_play$ncaaf.g.202509200023
#> $service$boxscore$gamelast_play$ncaaf.g.202509200023$play_id
#> [1] "184"
#> 
#> $service$boxscore$gamelast_play$ncaaf.g.202509200023$play_type
#> [1] "25"
#> 
#> $service$boxscore$gamelast_play$ncaaf.g.202509200023$play_text
#> [1] "End of Game"
#> 
#> $service$boxscore$gamelast_play$ncaaf.g.202509200023$period
#> [1] "4"
#> 
#> $service$boxscore$gamelast_play$ncaaf.g.202509200023$clock
#> [1] "0:00"
#> 
#> $service$boxscore$gamelast_play$ncaaf.g.202509200023$team
#> [1] "29"
#> 
#> $service$boxscore$gamelast_play$ncaaf.g.202509200023$is_scoring_play
#> [1] 0
#> 
#> 
#> 
#> $service$boxscore$gamepenalty_summary
#> $service$boxscore$gamepenalty_summary$ncaaf.g.202509200023
#> list()
#> 
#> 
#> $service$boxscore$gamepenalty_box
#> $service$boxscore$gamepenalty_box$ncaaf.g.202509200023
#> NULL
#> 
#> 
#> $service$boxscore$gameplay_by_play
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`2`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`2`$play_id
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`2`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`2`$clock
#> [1] "15:00"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`2`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`2`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`2`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`2`$yardline
#> [1] "MICH 35"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`2`$yards_to_endzone
#> [1] "65"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`2`$type
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`2`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`2`$text
#> [1] "Michigan kicked off, touchback"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`2`$play_time
#> [1] "1758397266"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`3`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`3`$play_id
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`3`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`3`$clock
#> [1] "15:00"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`3`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`3`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`3`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`3`$yardline
#> [1] "NEB 25"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`3`$yards_to_endzone
#> [1] "75"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`3`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`3`$yards
#> [1] "14"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`3`$text
#> [1] "[ncaaf.p.333433] rushed to the left for 14 yard gain, tackled by [ncaaf.p.333423]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`3`$play_time
#> [1] "1758397318"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`4`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`4`$play_id
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`4`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`4`$clock
#> [1] "14:33"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`4`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`4`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`4`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`4`$yardline
#> [1] "NEB 39"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`4`$yards_to_endzone
#> [1] "61"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`4`$type
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`4`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`4`$text
#> [1] "[ncaaf.p.457863] incomplete pass to the left intended for [ncaaf.p.333433]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`4`$play_time
#> [1] "1758397343"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`5`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`5`$play_id
#> [1] "5"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`5`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`5`$clock
#> [1] "14:25"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`5`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`5`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`5`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`5`$yardline
#> [1] "NEB 39"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`5`$yards_to_endzone
#> [1] "61"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`5`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`5`$yards
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`5`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.333434] to the right for 23 yard gain, tackled by [ncaaf.p.333839]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`5`$play_time
#> [1] "1758397391"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`6`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`6`$play_id
#> [1] "6"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`6`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`6`$clock
#> [1] "13:37"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`6`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`6`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`6`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`6`$yardline
#> [1] "MICH 38"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`6`$yards_to_endzone
#> [1] "38"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`6`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`6`$yards
#> [1] "11"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`6`$text
#> [1] "[ncaaf.p.461405] rushed to the right for 11 yard gain, tackled by [ncaaf.p.403634]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`6`$play_time
#> [1] "1758397430"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`7`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`7`$play_id
#> [1] "7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`7`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`7`$clock
#> [1] "13:25"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`7`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`7`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`7`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`7`$yardline
#> [1] "MICH 27"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`7`$yards_to_endzone
#> [1] "27"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`7`$type
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`7`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`7`$text
#> [1] "[ncaaf.p.457863] incomplete pass down the middle intended for [ncaaf.p.404124]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`7`$play_time
#> [1] "1758397456"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`8`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`8`$play_id
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`8`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`8`$clock
#> [1] "13:06"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`8`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`8`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`8`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`8`$yardline
#> [1] "MICH 27"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`8`$yards_to_endzone
#> [1] "27"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`8`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`8`$yards
#> [1] "13"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`8`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.404124] to the left for 13 yard gain, tackled by [ncaaf.p.403634]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`8`$play_time
#> [1] "1758397491"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`9`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`9`$play_id
#> [1] "9"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`9`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`9`$clock
#> [1] "12:33"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`9`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`9`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`9`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`9`$yardline
#> [1] "MICH 14"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`9`$yards_to_endzone
#> [1] "14"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`9`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`9`$yards
#> [1] "7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`9`$text
#> [1] "[ncaaf.p.457834] rushed to the left for 7 yard gain, tackled by [ncaaf.p.474363]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`9`$play_time
#> [1] "1758397529"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`10`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`10`$play_id
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`10`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`10`$clock
#> [1] "12:00"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`10`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`10`$distance
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`10`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`10`$yardline
#> [1] "MICH 7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`10`$yards_to_endzone
#> [1] "7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`10`$type
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`10`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`10`$text
#> [1] "[ncaaf.p.457863] incomplete pass to the right intended for [ncaaf.p.457834]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`10`$play_time
#> [1] "1758397555"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`11`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`11`$play_id
#> [1] "11"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`11`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`11`$clock
#> [1] "11:55"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`11`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`11`$distance
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`11`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`11`$yardline
#> [1] "MICH 7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`11`$yards_to_endzone
#> [1] "7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`11`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`11`$yards
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`11`$text
#> [1] "[ncaaf.p.333433] rushed up the middle for 1 yard gain, tackled by [ncaaf.p.327406]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`11`$play_time
#> [1] "1758397601"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`12`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`12`$play_id
#> [1] "12"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`12`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`12`$clock
#> [1] "11:16"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`12`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`12`$distance
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`12`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`12`$yardline
#> [1] "MICH 6"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`12`$yards_to_endzone
#> [1] "6"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`12`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`12`$yards
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`12`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.333434] down the middle for 1 yard gain, tackled by [ncaaf.p.451303]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`12`$play_time
#> [1] "1758397635"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`13`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`13`$play_id
#> [1] "13"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`13`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`13`$clock
#> [1] "11:10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`13`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`13`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`13`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`13`$yardline
#> [1] "MICH 5"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`13`$yards_to_endzone
#> [1] "95"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`13`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`13`$yards
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`13`$text
#> [1] "[ncaaf.p.404392] rushed up the middle for 2 yard gain, tackled by [ncaaf.p.299700]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`13`$play_time
#> [1] "1758397857"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`14`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`14`$play_id
#> [1] "14"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`14`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`14`$clock
#> [1] "10:37"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`14`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`14`$distance
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`14`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`14`$yardline
#> [1] "MICH 7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`14`$yards_to_endzone
#> [1] "93"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`14`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`14`$yards
#> [1] "5"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`14`$text
#> [1] "[ncaaf.p.469436] passed to [ncaaf.p.457613] to the left for 5 yard gain, tackled by [ncaaf.p.299700]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`14`$play_time
#> [1] "1758397893"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`15`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`15`$play_id
#> [1] "15"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`15`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`15`$clock
#> [1] "9:49"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`15`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`15`$distance
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`15`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`15`$yardline
#> [1] "MICH 12"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`15`$yards_to_endzone
#> [1] "88"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`15`$type
#> [1] "20"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`15`$yards
#> [1] "-5"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`15`$text
#> [1] "Michigan committed 5 yard penalty (False Start)"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`15`$play_time
#> [1] "1758397940"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`16`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`16`$play_id
#> [1] "16"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`16`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`16`$clock
#> [1] "9:35"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`16`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`16`$distance
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`16`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`16`$yardline
#> [1] "MICH 7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`16`$yards_to_endzone
#> [1] "93"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`16`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`16`$yards
#> [1] "6"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`16`$text
#> [1] "[ncaaf.p.469436] rushed up the middle for 6 yard gain, tackled by [ncaaf.p.322802]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`16`$play_time
#> [1] "1758397981"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`17`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`17`$play_id
#> [1] "17"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`17`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`17`$clock
#> [1] "8:55"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`17`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`17`$distance
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`17`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`17`$yardline
#> [1] "MICH 13"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`17`$yards_to_endzone
#> [1] "87"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`17`$type
#> [1] "7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`17`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`17`$text
#> [1] "[ncaaf.p.338368] punted for 24 yards, no return"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`17`$play_time
#> [1] "1758398024"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`18`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`18`$play_id
#> [1] "18"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`18`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`18`$clock
#> [1] "8:44"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`18`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`18`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`18`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`18`$yardline
#> [1] "MICH 37"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`18`$yards_to_endzone
#> [1] "37"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`18`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`18`$yards
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`18`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.333433] to the right for 8 yard gain, tackled by [ncaaf.p.333423]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`18`$play_time
#> [1] "1758398218"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`19`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`19`$play_id
#> [1] "19"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`19`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`19`$clock
#> [1] "8:13"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`19`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`19`$distance
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`19`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`19`$yardline
#> [1] "MICH 29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`19`$yards_to_endzone
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`19`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`19`$yards
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`19`$text
#> [1] "[ncaaf.p.333433] rushed to the left for 1 yard gain, tackled by [ncaaf.p.451303]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`19`$play_time
#> [1] "1758398252"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`20`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`20`$play_id
#> [1] "20"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`20`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`20`$clock
#> [1] "7:39"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`20`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`20`$distance
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`20`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`20`$yardline
#> [1] "MICH 28"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`20`$yards_to_endzone
#> [1] "28"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`20`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`20`$yards
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`20`$text
#> [1] "[ncaaf.p.333433] rushed to the right for 4 yard gain, tackled by [ncaaf.p.333423]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`20`$play_time
#> [1] "1758398290"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`21`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`21`$play_id
#> [1] "21"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`21`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`21`$clock
#> [1] "7:06"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`21`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`21`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`21`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`21`$yardline
#> [1] "MICH 24"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`21`$yards_to_endzone
#> [1] "24"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`21`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`21`$yards
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`21`$text
#> [1] "[ncaaf.p.469568] rushed to the left for 1 yard gain, tackled by [ncaaf.p.405415]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`21`$play_time
#> [1] "1758398329"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`22`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`22`$play_id
#> [1] "22"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`22`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`22`$clock
#> [1] "6:29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`22`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`22`$distance
#> [1] "9"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`22`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`22`$yardline
#> [1] "MICH 23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`22`$yards_to_endzone
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`22`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`22`$yards
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`22`$text
#> [1] "[ncaaf.p.333433] rushed up the middle for 2 yard gain, tackled by [ncaaf.p.457602]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`22`$play_time
#> [1] "1758398360"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`23`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`23`$play_id
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`23`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`23`$clock
#> [1] "5:49"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`23`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`23`$distance
#> [1] "7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`23`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`23`$yardline
#> [1] "MICH 21"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`23`$yards_to_endzone
#> [1] "21"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`23`$type
#> [1] "21"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`23`$yards
#> [1] "-5"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`23`$text
#> [1] "[ncaaf.p.457863] sacked by [ncaaf.p.333324] for 5 yard loss"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`23`$play_time
#> [1] "1758398405"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`24`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`24`$play_id
#> [1] "24"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`24`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`24`$clock
#> [1] "5:09"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`24`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`24`$distance
#> [1] "12"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`24`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`24`$yardline
#> [1] "MICH 26"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`24`$yards_to_endzone
#> [1] "26"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`24`$type
#> [1] "9"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`24`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`24`$text
#> [1] "[ncaaf.p.451229] missed a 44-yard field goal"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`24`$play_time
#> [1] "1758398444"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`25`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`25`$play_id
#> [1] "25"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`25`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`25`$clock
#> [1] "5:00"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`25`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`25`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`25`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`25`$yardline
#> [1] "MICH 26"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`25`$yards_to_endzone
#> [1] "74"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`25`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`25`$yards
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`25`$text
#> [1] "[ncaaf.p.404392] rushed to the right for 3 yard gain, tackled by [ncaaf.p.457880]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`25`$play_time
#> [1] "1758398642"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`26`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`26`$play_id
#> [1] "26"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`26`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`26`$clock
#> [1] "4:29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`26`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`26`$distance
#> [1] "7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`26`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`26`$yardline
#> [1] "MICH 29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`26`$yards_to_endzone
#> [1] "71"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`26`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`26`$yards
#> [1] "12"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`26`$text
#> [1] "[ncaaf.p.469436] passed to [ncaaf.p.323602] to the left for 12 yard gain, tackled by [ncaaf.p.457880]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`26`$play_time
#> [1] "1758398680"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`27`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`27`$play_id
#> [1] "27"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`27`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`27`$clock
#> [1] "4:06"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`27`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`27`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`27`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`27`$yardline
#> [1] "MICH 41"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`27`$yards_to_endzone
#> [1] "59"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`27`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`27`$yards
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`27`$text
#> [1] "[ncaaf.p.404392] rushed to the left for 4 yard gain, tackled by [ncaaf.p.457880]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`27`$play_time
#> [1] "1758398699"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`28`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`28`$play_id
#> [1] "28"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`28`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`28`$clock
#> [1] "3:37"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`28`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`28`$distance
#> [1] "6"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`28`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`28`$yardline
#> [1] "MICH 45"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`28`$yards_to_endzone
#> [1] "55"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`28`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`28`$yards
#> [1] "16"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`28`$text
#> [1] "[ncaaf.p.469436] passed to [ncaaf.p.403962] to the right for 16 yard gain, tackled by [ncaaf.p.406379]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`28`$play_time
#> [1] "1758398735"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`29`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`29`$play_id
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`29`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`29`$clock
#> [1] "3:08"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`29`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`29`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`29`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`29`$yardline
#> [1] "NEB 39"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`29`$yards_to_endzone
#> [1] "39"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`29`$type
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`29`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`29`$text
#> [1] "[ncaaf.p.469436] incomplete pass to the left intended for [ncaaf.p.457613]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`29`$play_time
#> [1] "1758398766"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`30`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`30`$play_id
#> [1] "30"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`30`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`30`$clock
#> [1] "2:57"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`30`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`30`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`30`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`30`$yardline
#> [1] "NEB 39"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`30`$yards_to_endzone
#> [1] "39"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`30`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`30`$yards
#> [1] "11"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`30`$text
#> [1] "[ncaaf.p.469436] passed to [ncaaf.p.323602] to the left for 11 yard gain, tackled by [ncaaf.p.334637]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`30`$play_time
#> [1] "1758398818"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`31`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`31`$play_id
#> [1] "31"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`31`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`31`$clock
#> [1] "2:32"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`31`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`31`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`31`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`31`$yardline
#> [1] "NEB 28"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`31`$yards_to_endzone
#> [1] "28"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`31`$type
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`31`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`31`$text
#> [1] "[ncaaf.p.403962] incomplete pass to the right intended for [ncaaf.p.323602]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`31`$play_time
#> [1] "1758398881"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`32`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`32`$play_id
#> [1] "32"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`32`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`32`$clock
#> [1] "2:24"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`32`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`32`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`32`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`32`$yardline
#> [1] "NEB 28"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`32`$yards_to_endzone
#> [1] "28"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`32`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`32`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`32`$text
#> [1] "[ncaaf.p.404392] rushed up the middle for no gain, tackled by [ncaaf.p.322308]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`32`$play_time
#> [1] "1758398921"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`33`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`33`$play_id
#> [1] "33"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`33`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`33`$clock
#> [1] "1:48"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`33`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`33`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`33`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`33`$yardline
#> [1] "NEB 28"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`33`$yards_to_endzone
#> [1] "28"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`33`$type
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`33`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`33`$text
#> [1] "[ncaaf.p.469436] incomplete pass to the right intended for [ncaaf.p.457613]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`33`$play_time
#> [1] "1758398960"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`34`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`34`$play_id
#> [1] "34"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`34`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`34`$clock
#> [1] "1:42"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`34`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`34`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`34`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`34`$yardline
#> [1] "NEB 28"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`34`$yards_to_endzone
#> [1] "28"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`34`$type
#> [1] "9"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`34`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`34`$text
#> [1] "[ncaaf.p.333922] kicked a 46-yard field goal"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`34`$play_time
#> [1] "1758399001"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`35`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`35`$play_id
#> [1] "35"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`35`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`35`$clock
#> [1] "1:38"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`35`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`35`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`35`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`35`$yardline
#> [1] "NEB 28"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`35`$yards_to_endzone
#> [1] "28"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`35`$type
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`35`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`35`$text
#> [1] "Michigan kicked off for 65 yards, [ncaaf.p.469568] returned kickoff for 23 yards"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`35`$play_time
#> [1] "1758399208"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`36`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`36`$play_id
#> [1] "36"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`36`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`36`$clock
#> [1] "1:33"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`36`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`36`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`36`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`36`$yardline
#> [1] "NEB 23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`36`$yards_to_endzone
#> [1] "77"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`36`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`36`$yards
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`36`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.333433] to the right for 8 yard gain, tackled by [ncaaf.p.327412]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`36`$play_time
#> [1] "1758399252"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`37`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`37`$play_id
#> [1] "37"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`37`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`37`$clock
#> [1] "1:00"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`37`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`37`$distance
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`37`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`37`$yardline
#> [1] "NEB 31"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`37`$yards_to_endzone
#> [1] "69"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`37`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`37`$yards
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`37`$text
#> [1] "[ncaaf.p.333433] rushed up the middle for 3 yard gain, tackled by [ncaaf.p.333423]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`37`$play_time
#> [1] "1758399285"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`38`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`38`$play_id
#> [1] "38"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`38`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`38`$clock
#> [1] "0:24"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`38`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`38`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`38`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`38`$yardline
#> [1] "NEB 34"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`38`$yards_to_endzone
#> [1] "66"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`38`$type
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`38`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`38`$text
#> [1] "[ncaaf.p.457863] pass intercepted to the right. [ncaaf.p.457602] intercepted [ncaaf.p.457863] for no gain"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`38`$play_time
#> [1] "1758399346"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`39`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`39`$play_id
#> [1] "39"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`39`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`39`$clock
#> [1] "0:17"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`39`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`39`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`39`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`39`$yardline
#> [1] "NEB 37"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`39`$yards_to_endzone
#> [1] "37"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`39`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`39`$yards
#> [1] "37"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`39`$text
#> [1] "[ncaaf.p.469436] rushed up the middle for 37 yard touchdown"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`39`$play_time
#> [1] "1758399429"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`40`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`40`$play_id
#> [1] "40"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`40`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`40`$clock
#> [1] "0:11"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`40`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`40`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`40`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`40`$yardline
#> [1] "NEB 1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`40`$yards_to_endzone
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`40`$type
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`40`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`40`$text
#> [1] "[ncaaf.p.333922] made PAT"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`40`$play_time
#> [1] "1758399451"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`41`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`41`$play_id
#> [1] "41"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`41`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`41`$clock
#> [1] "0:11"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`41`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`41`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`41`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`41`$yardline
#> [1] "NEB 1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`41`$yards_to_endzone
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`41`$type
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`41`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`41`$text
#> [1] "Michigan kicked off, touchback"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`41`$play_time
#> [1] "1758399500"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`42`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`42`$play_id
#> [1] "42"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`42`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`42`$clock
#> [1] "0:11"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`42`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`42`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`42`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`42`$yardline
#> [1] "NEB 25"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`42`$yards_to_endzone
#> [1] "75"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`42`$type
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`42`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`42`$text
#> [1] "[ncaaf.p.457863] incomplete pass to the right intended for [ncaaf.p.333434]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`42`$play_time
#> [1] "1758399542"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`43`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`43`$play_id
#> [1] "43"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`43`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`43`$clock
#> [1] "0:07"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`43`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`43`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`43`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`43`$yardline
#> [1] "NEB 25"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`43`$yards_to_endzone
#> [1] "75"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`43`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`43`$yards
#> [1] "7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`43`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.457834] to the right for 7 yard gain, tackled by [ncaaf.p.327421]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`43`$play_time
#> [1] "1758399593"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`44`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`44`$play_id
#> [1] "44"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`44`$period
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`44`$clock
#> [1] "0:00"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`44`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`44`$distance
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`44`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`44`$yardline
#> [1] "NEB 32"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`44`$yards_to_endzone
#> [1] "68"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`44`$type
#> [1] "25"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`44`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`44`$text
#> [1] "End of 1st Quarter"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`44`$play_time
#> [1] "1758399593"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`46`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`46`$play_id
#> [1] "46"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`46`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`46`$clock
#> [1] "15:00"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`46`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`46`$distance
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`46`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`46`$yardline
#> [1] "NEB 32"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`46`$yards_to_endzone
#> [1] "68"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`46`$type
#> [1] "20"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`46`$yards
#> [1] "-5"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`46`$text
#> [1] "Nebraska committed 5 yard penalty (False Start)"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`46`$play_time
#> [1] "1758399862"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`47`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`47`$play_id
#> [1] "47"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`47`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`47`$clock
#> [1] "15:00"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`47`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`47`$distance
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`47`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`47`$yardline
#> [1] "NEB 27"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`47`$yards_to_endzone
#> [1] "73"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`47`$type
#> [1] "21"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`47`$yards
#> [1] "-11"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`47`$text
#> [1] "[ncaaf.p.457863] sacked by [ncaaf.p.327406] for 11 yard loss"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`47`$play_time
#> [1] "1758399906"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`48`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`48`$play_id
#> [1] "48"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`48`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`48`$clock
#> [1] "14:15"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`48`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`48`$distance
#> [1] "19"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`48`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`48`$yardline
#> [1] "NEB 16"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`48`$yards_to_endzone
#> [1] "84"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`48`$type
#> [1] "7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`48`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`48`$text
#> [1] "[ncaaf.p.471801] punted for 47 yards. [ncaaf.p.403962] returned punt for no gain"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`48`$play_time
#> [1] "1758399956"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`49`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`49`$play_id
#> [1] "49"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`49`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`49`$clock
#> [1] "14:06"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`49`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`49`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`49`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`49`$yardline
#> [1] "MICH 37"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`49`$yards_to_endzone
#> [1] "63"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`49`$type
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`49`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`49`$text
#> [1] "[ncaaf.p.469436] incomplete pass to the right intended for [ncaaf.p.323602]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`49`$play_time
#> [1] "1758400147"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`50`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`50`$play_id
#> [1] "50"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`50`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`50`$clock
#> [1] "14:00"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`50`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`50`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`50`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`50`$yardline
#> [1] "MICH 37"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`50`$yards_to_endzone
#> [1] "63"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`50`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`50`$yards
#> [1] "7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`50`$text
#> [1] "[ncaaf.p.457591] rushed up the middle for 7 yard gain, tackled by [ncaaf.p.299700]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`50`$play_time
#> [1] "1758400186"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`51`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`51`$play_id
#> [1] "51"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`51`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`51`$clock
#> [1] "13:19"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`51`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`51`$distance
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`51`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`51`$yardline
#> [1] "MICH 44"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`51`$yards_to_endzone
#> [1] "56"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`51`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`51`$yards
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`51`$text
#> [1] "[ncaaf.p.469436] rushed for 8 yard gain. [ncaaf.p.469436] fumbled. [ncaaf.p.334637] recovered fumble for no gain"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`51`$play_time
#> [1] "1758400256"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`52`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`52`$play_id
#> [1] "52"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`52`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`52`$clock
#> [1] "13:08"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`52`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`52`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`52`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`52`$yardline
#> [1] "NEB 48"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`52`$yards_to_endzone
#> [1] "52"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`52`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`52`$yards
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`52`$text
#> [1] "[ncaaf.p.333433] rushed to the left for 4 yard gain, tackled by [ncaaf.p.403634]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`52`$play_time
#> [1] "1758400312"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`53`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`53`$play_id
#> [1] "53"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`53`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`53`$clock
#> [1] "12:30"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`53`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`53`$distance
#> [1] "6"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`53`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`53`$yardline
#> [1] "MICH 48"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`53`$yards_to_endzone
#> [1] "48"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`53`$type
#> [1] "20"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`53`$yards
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`53`$text
#> [1] "Michigan committed 4 yard penalty (Pass Interference)"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`53`$play_time
#> [1] "1758400366"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`54`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`54`$play_id
#> [1] "54"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`54`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`54`$clock
#> [1] "12:26"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`54`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`54`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`54`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`54`$yardline
#> [1] "MICH 44"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`54`$yards_to_endzone
#> [1] "44"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`54`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`54`$yards
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`54`$text
#> [1] "[ncaaf.p.461405] rushed to the left for 2 yard gain, tackled by [ncaaf.p.333324]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`54`$play_time
#> [1] "1758400396"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`55`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`55`$play_id
#> [1] "55"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`55`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`55`$clock
#> [1] "11:50"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`55`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`55`$distance
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`55`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`55`$yardline
#> [1] "MICH 42"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`55`$yards_to_endzone
#> [1] "42"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`55`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`55`$yards
#> [1] "21"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`55`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.333286] to the left for 21 yard gain, tackled by [ncaaf.p.457602]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`55`$play_time
#> [1] "1758400434"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`56`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`56`$play_id
#> [1] "56"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`56`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`56`$clock
#> [1] "11:12"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`56`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`56`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`56`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`56`$yardline
#> [1] "MICH 21"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`56`$yards_to_endzone
#> [1] "21"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`56`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`56`$yards
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`56`$text
#> [1] "[ncaaf.p.333433] rushed up the middle for 3 yard gain, tackled by [ncaaf.p.405415]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`56`$play_time
#> [1] "1758400468"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`57`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`57`$play_id
#> [1] "57"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`57`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`57`$clock
#> [1] "10:24"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`57`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`57`$distance
#> [1] "7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`57`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`57`$yardline
#> [1] "MICH 18"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`57`$yards_to_endzone
#> [1] "18"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`57`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`57`$yards
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`57`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.333434] to the left for 4 yard gain, tackled by [ncaaf.p.333423]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`57`$play_time
#> [1] "1758400513"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`58`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`58`$play_id
#> [1] "58"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`58`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`58`$clock
#> [1] "9:46"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`58`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`58`$distance
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`58`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`58`$yardline
#> [1] "MICH 14"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`58`$yards_to_endzone
#> [1] "14"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`58`$type
#> [1] "21"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`58`$yards
#> [1] "-7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`58`$text
#> [1] "[ncaaf.p.457863] sacked by [ncaaf.p.327406] and [ncaaf.p.404304] for 7 yard loss"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`58`$play_time
#> [1] "1758400552"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`59`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`59`$play_id
#> [1] "59"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`59`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`59`$clock
#> [1] "9:05"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`59`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`59`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`59`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`59`$yardline
#> [1] "MICH 21"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`59`$yards_to_endzone
#> [1] "21"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`59`$type
#> [1] "9"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`59`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`59`$text
#> [1] "[ncaaf.p.451229] kicked a 39-yard field goal"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`59`$play_time
#> [1] "1758400591"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`60`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`60`$play_id
#> [1] "60"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`60`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`60`$clock
#> [1] "8:58"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`60`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`60`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`60`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`60`$yardline
#> [1] "MICH 21"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`60`$yards_to_endzone
#> [1] "21"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`60`$type
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`60`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`60`$text
#> [1] "Nebraska kicked off for 54 yards, [ncaaf.p.327425] returned kickoff for no gain"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`60`$play_time
#> [1] "1758400786"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`61`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`61`$play_id
#> [1] "61"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`61`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`61`$clock
#> [1] "8:58"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`61`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`61`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`61`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`61`$yardline
#> [1] "MICH 25"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`61`$yards_to_endzone
#> [1] "75"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`61`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`61`$yards
#> [1] "11"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`61`$text
#> [1] "[ncaaf.p.404392] rushed to the left for 11 yard gain, tackled by [ncaaf.p.322802]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`61`$play_time
#> [1] "1758400838"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`62`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`62`$play_id
#> [1] "62"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`62`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`62`$clock
#> [1] "8:21"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`62`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`62`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`62`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`62`$yardline
#> [1] "MICH 36"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`62`$yards_to_endzone
#> [1] "64"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`62`$type
#> [1] "21"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`62`$yards
#> [1] "-6"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`62`$text
#> [1] "[ncaaf.p.469436] sacked by [ncaaf.p.333347] for 6 yard loss"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`62`$play_time
#> [1] "1758400873"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`63`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`63`$play_id
#> [1] "63"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`63`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`63`$clock
#> [1] "7:37"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`63`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`63`$distance
#> [1] "16"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`63`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`63`$yardline
#> [1] "MICH 30"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`63`$yards_to_endzone
#> [1] "70"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`63`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`63`$yards
#> [1] "-3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`63`$text
#> [1] "[ncaaf.p.469436] passed to [ncaaf.p.404392] to the right for 3 yard loss"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`63`$play_time
#> [1] "1758400929"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`64`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`64`$play_id
#> [1] "64"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`64`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`64`$clock
#> [1] "6:55"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`64`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`64`$distance
#> [1] "19"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`64`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`64`$yardline
#> [1] "MICH 27"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`64`$yards_to_endzone
#> [1] "73"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`64`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`64`$yards
#> [1] "7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`64`$text
#> [1] "[ncaaf.p.404392] rushed to the left for 7 yard gain, tackled by [ncaaf.p.299700]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`64`$play_time
#> [1] "1758400962"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`65`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`65`$play_id
#> [1] "65"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`65`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`65`$clock
#> [1] "6:16"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`65`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`65`$distance
#> [1] "12"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`65`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`65`$yardline
#> [1] "MICH 34"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`65`$yards_to_endzone
#> [1] "66"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`65`$type
#> [1] "7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`65`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`65`$text
#> [1] "[ncaaf.p.338368] punted for 49 yards. [ncaaf.p.457834] returned punt for 20 yards"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`65`$play_time
#> [1] "1758401014"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`66`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`66`$play_id
#> [1] "66"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`66`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`66`$clock
#> [1] "5:58"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`66`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`66`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`66`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`66`$yardline
#> [1] "NEB 37"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`66`$yards_to_endzone
#> [1] "63"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`66`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`66`$yards
#> [1] "5"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`66`$text
#> [1] "[ncaaf.p.333433] rushed to the right for 5 yard gain, tackled by [ncaaf.p.451303]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`66`$play_time
#> [1] "1758401209"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`67`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`67`$play_id
#> [1] "67"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`67`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`67`$clock
#> [1] "5:29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`67`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`67`$distance
#> [1] "5"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`67`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`67`$yardline
#> [1] "NEB 42"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`67`$yards_to_endzone
#> [1] "58"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`67`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`67`$yards
#> [1] "11"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`67`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.457834] to the left for 11 yard gain, tackled by [ncaaf.p.333312]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`67`$play_time
#> [1] "1758401244"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`68`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`68`$play_id
#> [1] "68"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`68`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`68`$clock
#> [1] "4:52"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`68`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`68`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`68`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`68`$yardline
#> [1] "MICH 47"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`68`$yards_to_endzone
#> [1] "47"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`68`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`68`$yards
#> [1] "7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`68`$text
#> [1] "[ncaaf.p.333433] rushed to the right for 7 yard gain, tackled by [ncaaf.p.405652]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`68`$play_time
#> [1] "1758401274"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`69`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`69`$play_id
#> [1] "69"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`69`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`69`$clock
#> [1] "4:09"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`69`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`69`$distance
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`69`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`69`$yardline
#> [1] "MICH 40"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`69`$yards_to_endzone
#> [1] "40"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`69`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`69`$yards
#> [1] "12"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`69`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.333434] to the right for 12 yard gain, tackled by [ncaaf.p.457597]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`69`$play_time
#> [1] "1758401323"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`70`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`70`$play_id
#> [1] "70"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`70`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`70`$clock
#> [1] "3:35"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`70`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`70`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`70`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`70`$yardline
#> [1] "MICH 28"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`70`$yards_to_endzone
#> [1] "28"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`70`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`70`$yards
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`70`$text
#> [1] "[ncaaf.p.333433] rushed to the left for 1 yard gain, tackled by [ncaaf.p.333324]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`70`$play_time
#> [1] "1758401360"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`71`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`71`$play_id
#> [1] "71"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`71`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`71`$clock
#> [1] "2:52"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`71`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`71`$distance
#> [1] "9"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`71`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`71`$yardline
#> [1] "MICH 27"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`71`$yards_to_endzone
#> [1] "27"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`71`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`71`$yards
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`71`$text
#> [1] "[ncaaf.p.333433] rushed to the right for 1 yard gain, tackled by [ncaaf.p.457602]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`71`$play_time
#> [1] "1758401399"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`72`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`72`$play_id
#> [1] "72"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`72`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`72`$clock
#> [1] "2:07"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`72`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`72`$distance
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`72`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`72`$yardline
#> [1] "MICH 26"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`72`$yards_to_endzone
#> [1] "26"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`72`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`72`$yards
#> [1] "26"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`72`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.457834] down the middle for 26 yard touchdown"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`72`$play_time
#> [1] "1758401479"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`73`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`73`$play_id
#> [1] "73"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`73`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`73`$clock
#> [1] "2:01"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`73`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`73`$distance
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`73`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`73`$yardline
#> [1] "MICH 1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`73`$yards_to_endzone
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`73`$type
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`73`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`73`$text
#> [1] "[ncaaf.p.451229] made PAT"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`73`$play_time
#> [1] "1758401491"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`74`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`74`$play_id
#> [1] "74"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`74`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`74`$clock
#> [1] "2:01"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`74`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`74`$distance
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`74`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`74`$yardline
#> [1] "MICH 1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`74`$yards_to_endzone
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`74`$type
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`74`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`74`$text
#> [1] "Nebraska kicked off, touchback"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`74`$play_time
#> [1] "1758401590"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`75`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`75`$play_id
#> [1] "75"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`75`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`75`$clock
#> [1] "2:01"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`75`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`75`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`75`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`75`$yardline
#> [1] "MICH 25"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`75`$yards_to_endzone
#> [1] "75"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`75`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`75`$yards
#> [1] "75"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`75`$text
#> [1] "[ncaaf.p.404392] rushed to the left for 75 yard touchdown"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`75`$play_time
#> [1] "1758401683"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`76`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`76`$play_id
#> [1] "76"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`76`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`76`$clock
#> [1] "1:51"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`76`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`76`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`76`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`76`$yardline
#> [1] "NEB 1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`76`$yards_to_endzone
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`76`$type
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`76`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`76`$text
#> [1] "[ncaaf.p.333922] made PAT"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`76`$play_time
#> [1] "1758401691"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`77`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`77`$play_id
#> [1] "77"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`77`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`77`$clock
#> [1] "1:51"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`77`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`77`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`77`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`77`$yardline
#> [1] "NEB 1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`77`$yards_to_endzone
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`77`$type
#> [1] "24"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`77`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`77`$text
#> [1] "Two-minute warning"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`77`$play_time
#> [1] "1758401706"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`78`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`78`$play_id
#> [1] "78"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`78`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`78`$clock
#> [1] "1:51"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`78`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`78`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`78`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`78`$yardline
#> [1] "NEB 1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`78`$yards_to_endzone
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`78`$type
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`78`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`78`$text
#> [1] "Michigan kicked off, touchback"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`78`$play_time
#> [1] "1758401893"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`79`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`79`$play_id
#> [1] "79"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`79`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`79`$clock
#> [1] "1:51"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`79`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`79`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`79`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`79`$yardline
#> [1] "NEB 25"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`79`$yards_to_endzone
#> [1] "75"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`79`$type
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`79`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`79`$text
#> [1] "[ncaaf.p.457863] incomplete pass to the left intended for [ncaaf.p.404124]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`79`$play_time
#> [1] "1758401943"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`80`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`80`$play_id
#> [1] "80"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`80`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`80`$clock
#> [1] "1:46"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`80`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`80`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`80`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`80`$yardline
#> [1] "NEB 25"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`80`$yards_to_endzone
#> [1] "75"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`80`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`80`$yards
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`80`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.333286] to the right for 10 yard gain"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`80`$play_time
#> [1] "1758401991"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`81`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`81`$play_id
#> [1] "81"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`81`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`81`$clock
#> [1] "1:29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`81`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`81`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`81`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`81`$yardline
#> [1] "NEB 35"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`81`$yards_to_endzone
#> [1] "65"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`81`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`81`$yards
#> [1] "14"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`81`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.457875] to the left for 14 yard gain, tackled by [ncaaf.p.403634]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`81`$play_time
#> [1] "1758402022"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`82`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`82`$play_id
#> [1] "82"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`82`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`82`$clock
#> [1] "1:10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`82`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`82`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`82`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`82`$yardline
#> [1] "NEB 49"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`82`$yards_to_endzone
#> [1] "51"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`82`$type
#> [1] "21"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`82`$yards
#> [1] "-9"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`82`$text
#> [1] "[ncaaf.p.457863] sacked by [ncaaf.p.340505] for 9 yard loss"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`82`$play_time
#> [1] "1758402049"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`83`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`83`$play_id
#> [1] "83"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`83`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`83`$clock
#> [1] "1:00"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`83`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`83`$distance
#> [1] "19"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`83`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`83`$yardline
#> [1] "NEB 40"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`83`$yards_to_endzone
#> [1] "60"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`83`$type
#> [1] "24"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`83`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`83`$text
#> [1] "Nebraska timeout"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`83`$play_time
#> [1] "1758402063"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`84`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`84`$play_id
#> [1] "84"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`84`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`84`$clock
#> [1] "1:00"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`84`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`84`$distance
#> [1] "19"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`84`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`84`$yardline
#> [1] "NEB 40"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`84`$yards_to_endzone
#> [1] "60"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`84`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`84`$yards
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`84`$text
#> [1] "[ncaaf.p.333433] rushed up the middle for 3 yard gain, tackled by [ncaaf.p.327412]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`84`$play_time
#> [1] "1758402127"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`85`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`85`$play_id
#> [1] "85"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`85`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`85`$clock
#> [1] "0:23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`85`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`85`$distance
#> [1] "16"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`85`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`85`$yardline
#> [1] "NEB 43"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`85`$yards_to_endzone
#> [1] "57"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`85`$type
#> [1] "24"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`85`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`85`$text
#> [1] "Nebraska timeout"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`85`$play_time
#> [1] "1758402165"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`86`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`86`$play_id
#> [1] "86"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`86`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`86`$clock
#> [1] "0:23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`86`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`86`$distance
#> [1] "16"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`86`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`86`$yardline
#> [1] "NEB 43"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`86`$yards_to_endzone
#> [1] "57"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`86`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`86`$yards
#> [1] "5"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`86`$text
#> [1] "[ncaaf.p.333433] rushed to the left for 5 yard gain, tackled by [ncaaf.p.333423]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`86`$play_time
#> [1] "1758402237"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`87`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`87`$play_id
#> [1] "87"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`87`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`87`$clock
#> [1] "0:01"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`87`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`87`$distance
#> [1] "11"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`87`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`87`$yardline
#> [1] "NEB 48"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`87`$yards_to_endzone
#> [1] "52"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`87`$type
#> [1] "24"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`87`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`87`$text
#> [1] "Nebraska timeout"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`87`$play_time
#> [1] "1758402248"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`88`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`88`$play_id
#> [1] "88"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`88`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`88`$clock
#> [1] "0:01"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`88`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`88`$distance
#> [1] "11"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`88`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`88`$yardline
#> [1] "NEB 48"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`88`$yards_to_endzone
#> [1] "52"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`88`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`88`$yards
#> [1] "52"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`88`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.457834] to the right for 52 yard touchdown"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`88`$play_time
#> [1] "1758402384"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`89`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`89`$play_id
#> [1] "89"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`89`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`89`$clock
#> [1] "0:00"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`89`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`89`$distance
#> [1] "11"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`89`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`89`$yardline
#> [1] "MICH 1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`89`$yards_to_endzone
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`89`$type
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`89`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`89`$text
#> [1] "[ncaaf.p.451229] made PAT"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`89`$play_time
#> [1] "1758402392"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`90`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`90`$play_id
#> [1] "90"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`90`$period
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`90`$clock
#> [1] "0:00"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`90`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`90`$distance
#> [1] "11"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`90`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`90`$yardline
#> [1] "MICH 1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`90`$yards_to_endzone
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`90`$type
#> [1] "25"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`90`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`90`$text
#> [1] "End of Half"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`90`$play_time
#> [1] "1758402399"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`92`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`92`$play_id
#> [1] "92"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`92`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`92`$clock
#> [1] "15:00"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`92`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`92`$distance
#> [1] "11"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`92`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`92`$yardline
#> [1] "MICH 1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`92`$yards_to_endzone
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`92`$type
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`92`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`92`$text
#> [1] "Nebraska kicked off for 63 yards, [ncaaf.p.327425] returned kickoff for no gain"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`92`$play_time
#> [1] "1758403713"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`93`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`93`$play_id
#> [1] "93"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`93`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`93`$clock
#> [1] "15:00"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`93`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`93`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`93`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`93`$yardline
#> [1] "MICH 25"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`93`$yards_to_endzone
#> [1] "75"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`93`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`93`$yards
#> [1] "16"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`93`$text
#> [1] "[ncaaf.p.469436] passed to [ncaaf.p.323602] to the left for 16 yard gain, tackled by [ncaaf.p.457880]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`93`$play_time
#> [1] "1758403778"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`94`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`94`$play_id
#> [1] "94"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`94`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`94`$clock
#> [1] "14:31"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`94`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`94`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`94`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`94`$yardline
#> [1] "MICH 41"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`94`$yards_to_endzone
#> [1] "59"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`94`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`94`$yards
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`94`$text
#> [1] "[ncaaf.p.404392] rushed to the left for 2 yard gain, tackled by [ncaaf.p.315007]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`94`$play_time
#> [1] "1758403810"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`95`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`95`$play_id
#> [1] "95"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`95`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`95`$clock
#> [1] "13:55"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`95`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`95`$distance
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`95`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`95`$yardline
#> [1] "MICH 43"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`95`$yards_to_endzone
#> [1] "57"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`95`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`95`$yards
#> [1] "5"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`95`$text
#> [1] "[ncaaf.p.469436] passed to [ncaaf.p.340496] to the left for 5 yard gain, tackled by [ncaaf.p.457853]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`95`$play_time
#> [1] "1758403851"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`96`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`96`$play_id
#> [1] "96"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`96`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`96`$clock
#> [1] "13:25"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`96`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`96`$distance
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`96`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`96`$yardline
#> [1] "MICH 48"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`96`$yards_to_endzone
#> [1] "52"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`96`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`96`$yards
#> [1] "-1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`96`$text
#> [1] "[ncaaf.p.469436] passed to [ncaaf.p.404392] to the right for 1 yard loss, tackled by [ncaaf.p.457838]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`96`$play_time
#> [1] "1758403925"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`97`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`97`$play_id
#> [1] "97"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`97`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`97`$clock
#> [1] "12:46"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`97`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`97`$distance
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`97`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`97`$yardline
#> [1] "MICH 47"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`97`$yards_to_endzone
#> [1] "53"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`97`$type
#> [1] "7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`97`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`97`$text
#> [1] "[ncaaf.p.338368] punted for 49 yards. [ncaaf.p.457834] returned punt for 1 yard loss"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`97`$play_time
#> [1] "1758403925"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`98`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`98`$play_id
#> [1] "98"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`98`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`98`$clock
#> [1] "12:34"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`98`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`98`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`98`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`98`$yardline
#> [1] "NEB 3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`98`$yards_to_endzone
#> [1] "97"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`98`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`98`$yards
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`98`$text
#> [1] "[ncaaf.p.333433] rushed to the left for 3 yard gain, tackled by [ncaaf.p.451303]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`98`$play_time
#> [1] "1758404121"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`99`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`99`$play_id
#> [1] "99"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`99`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`99`$clock
#> [1] "12:01"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`99`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`99`$distance
#> [1] "7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`99`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`99`$yardline
#> [1] "NEB 6"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`99`$yards_to_endzone
#> [1] "94"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`99`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`99`$yards
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`99`$text
#> [1] "[ncaaf.p.333433] rushed to the left for 1 yard gain, tackled by [ncaaf.p.451303]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`99`$play_time
#> [1] "1758404157"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`100`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`100`$play_id
#> [1] "100"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`100`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`100`$clock
#> [1] "11:16"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`100`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`100`$distance
#> [1] "6"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`100`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`100`$yardline
#> [1] "NEB 7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`100`$yards_to_endzone
#> [1] "93"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`100`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`100`$yards
#> [1] "5"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`100`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.333286] to the right for 5 yard gain, tackled by [ncaaf.p.474366]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`100`$play_time
#> [1] "1758404207"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`101`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`101`$play_id
#> [1] "101"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`101`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`101`$clock
#> [1] "10:25"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`101`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`101`$distance
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`101`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`101`$yardline
#> [1] "NEB 12"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`101`$yards_to_endzone
#> [1] "88"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`101`$type
#> [1] "20"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`101`$yards
#> [1] "-4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`101`$text
#> [1] "Nebraska committed 4 yard penalty (Delay of Game)"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`101`$play_time
#> [1] "1758404294"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`102`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`102`$play_id
#> [1] "102"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`102`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`102`$clock
#> [1] "10:23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`102`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`102`$distance
#> [1] "6"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`102`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`102`$yardline
#> [1] "NEB 8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`102`$yards_to_endzone
#> [1] "92"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`102`$type
#> [1] "7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`102`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`102`$text
#> [1] "[ncaaf.p.471801] punted for 52 yards, no return"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`102`$play_time
#> [1] "1758404300"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`103`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`103`$play_id
#> [1] "103"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`103`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`103`$clock
#> [1] "10:15"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`103`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`103`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`103`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`103`$yardline
#> [1] "MICH 40"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`103`$yards_to_endzone
#> [1] "60"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`103`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`103`$yards
#> [1] "7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`103`$text
#> [1] "[ncaaf.p.404392] rushed up the middle for 7 yard gain, tackled by [ncaaf.p.299700]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`103`$play_time
#> [1] "1758404486"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`104`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`104`$play_id
#> [1] "104"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`104`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`104`$clock
#> [1] "9:31"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`104`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`104`$distance
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`104`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`104`$yardline
#> [1] "MICH 47"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`104`$yards_to_endzone
#> [1] "53"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`104`$type
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`104`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`104`$text
#> [1] "[ncaaf.p.469436] incomplete pass to the left intended for [ncaaf.p.403962]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`104`$play_time
#> [1] "1758404565"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`105`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`105`$play_id
#> [1] "105"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`105`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`105`$clock
#> [1] "9:27"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`105`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`105`$distance
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`105`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`105`$yardline
#> [1] "MICH 47"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`105`$yards_to_endzone
#> [1] "53"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`105`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`105`$yards
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`105`$text
#> [1] "[ncaaf.p.404392] rushed up the middle for 3 yard gain, tackled by [ncaaf.p.457838]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`105`$play_time
#> [1] "1758404565"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`106`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`106`$play_id
#> [1] "106"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`106`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`106`$clock
#> [1] "8:56"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`106`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`106`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`106`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`106`$yardline
#> [1] "50"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`106`$yards_to_endzone
#> [1] "50"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`106`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`106`$yards
#> [1] "16"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`106`$text
#> [1] "[ncaaf.p.469436] passed to [ncaaf.p.340496] to the right for 16 yard gain, tackled by [ncaaf.p.457853]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`106`$play_time
#> [1] "1758404603"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`107`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`107`$play_id
#> [1] "107"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`107`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`107`$clock
#> [1] "8:13"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`107`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`107`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`107`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`107`$yardline
#> [1] "NEB 34"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`107`$yards_to_endzone
#> [1] "34"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`107`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`107`$yards
#> [1] "-4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`107`$text
#> [1] "[ncaaf.p.404392] rushed up the middle for 4 yard loss, tackled by [ncaaf.p.333347]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`107`$play_time
#> [1] "1758404636"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`108`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`108`$play_id
#> [1] "108"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`108`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`108`$clock
#> [1] "7:55"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`108`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`108`$distance
#> [1] "14"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`108`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`108`$yardline
#> [1] "NEB 38"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`108`$yards_to_endzone
#> [1] "38"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`108`$type
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`108`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`108`$text
#> [1] "[ncaaf.p.469436] incomplete pass to the right intended for [ncaaf.p.323602]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`108`$play_time
#> [1] "1758404692"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`109`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`109`$play_id
#> [1] "109"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`109`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`109`$clock
#> [1] "7:52"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`109`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`109`$distance
#> [1] "14"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`109`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`109`$yardline
#> [1] "NEB 38"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`109`$yards_to_endzone
#> [1] "38"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`109`$type
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`109`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`109`$text
#> [1] "[ncaaf.p.469436] incomplete pass to the left intended for [ncaaf.p.457613]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`109`$play_time
#> [1] "1758404858"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`110`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`110`$play_id
#> [1] "110"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`110`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`110`$clock
#> [1] "7:48"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`110`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`110`$distance
#> [1] "14"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`110`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`110`$yardline
#> [1] "NEB 38"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`110`$yards_to_endzone
#> [1] "38"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`110`$type
#> [1] "9"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`110`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`110`$text
#> [1] "[ncaaf.p.333922] kicked a 56-yard field goal"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`110`$play_time
#> [1] "1758404899"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`111`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`111`$play_id
#> [1] "111"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`111`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`111`$clock
#> [1] "7:43"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`111`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`111`$distance
#> [1] "14"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`111`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`111`$yardline
#> [1] "NEB 38"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`111`$yards_to_endzone
#> [1] "38"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`111`$type
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`111`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`111`$text
#> [1] "Michigan kicked off, touchback"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`111`$play_time
#> [1] "1758405090"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`112`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`112`$play_id
#> [1] "112"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`112`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`112`$clock
#> [1] "7:43"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`112`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`112`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`112`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`112`$yardline
#> [1] "NEB 25"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`112`$yards_to_endzone
#> [1] "75"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`112`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`112`$yards
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`112`$text
#> [1] "[ncaaf.p.333433] rushed to the left for 1 yard gain, tackled by [ncaaf.p.404304]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`112`$play_time
#> [1] "1758405140"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`113`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`113`$play_id
#> [1] "113"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`113`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`113`$clock
#> [1] "7:12"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`113`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`113`$distance
#> [1] "9"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`113`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`113`$yardline
#> [1] "NEB 26"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`113`$yards_to_endzone
#> [1] "74"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`113`$type
#> [1] "21"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`113`$yards
#> [1] "-7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`113`$text
#> [1] "[ncaaf.p.457863] sacked by [ncaaf.p.333423] for 7 yard loss"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`113`$play_time
#> [1] "1758405179"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`114`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`114`$play_id
#> [1] "114"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`114`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`114`$clock
#> [1] "6:28"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`114`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`114`$distance
#> [1] "16"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`114`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`114`$yardline
#> [1] "NEB 19"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`114`$yards_to_endzone
#> [1] "81"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`114`$type
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`114`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`114`$text
#> [1] "[ncaaf.p.457863] incomplete pass to the left intended for [ncaaf.p.333433]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`114`$play_time
#> [1] "1758405221"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`115`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`115`$play_id
#> [1] "115"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`115`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`115`$clock
#> [1] "6:21"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`115`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`115`$distance
#> [1] "16"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`115`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`115`$yardline
#> [1] "NEB 19"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`115`$yards_to_endzone
#> [1] "81"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`115`$type
#> [1] "7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`115`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`115`$text
#> [1] "[ncaaf.p.471801] punted for 42 yards. [ncaaf.p.403962] returned punt for 1 yard loss"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`115`$play_time
#> [1] "1758405263"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`116`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`116`$play_id
#> [1] "116"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`116`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`116`$clock
#> [1] "6:12"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`116`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`116`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`116`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`116`$yardline
#> [1] "MICH 38"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`116`$yards_to_endzone
#> [1] "62"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`116`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`116`$yards
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`116`$text
#> [1] "[ncaaf.p.457591] rushed to the right for 8 yard gain, tackled by [ncaaf.p.457838]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`116`$play_time
#> [1] "1758405457"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`117`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`117`$play_id
#> [1] "117"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`117`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`117`$clock
#> [1] "5:47"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`117`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`117`$distance
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`117`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`117`$yardline
#> [1] "MICH 46"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`117`$yards_to_endzone
#> [1] "54"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`117`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`117`$yards
#> [1] "54"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`117`$text
#> [1] "[ncaaf.p.457591] rushed to the right for 54 yard touchdown"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`117`$play_time
#> [1] "1758405528"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`118`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`118`$play_id
#> [1] "118"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`118`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`118`$clock
#> [1] "5:40"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`118`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`118`$distance
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`118`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`118`$yardline
#> [1] "NEB 1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`118`$yards_to_endzone
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`118`$type
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`118`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`118`$text
#> [1] "[ncaaf.p.333922] made PAT"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`118`$play_time
#> [1] "1758405535"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`119`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`119`$play_id
#> [1] "119"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`119`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`119`$clock
#> [1] "5:40"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`119`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`119`$distance
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`119`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`119`$yardline
#> [1] "NEB 1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`119`$yards_to_endzone
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`119`$type
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`119`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`119`$text
#> [1] "Michigan kicked off, touchback"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`119`$play_time
#> [1] "1758405615"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`120`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`120`$play_id
#> [1] "120"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`120`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`120`$clock
#> [1] "5:40"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`120`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`120`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`120`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`120`$yardline
#> [1] "NEB 25"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`120`$yards_to_endzone
#> [1] "75"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`120`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`120`$yards
#> [1] "-4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`120`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.461405] to the left for 4 yard loss"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`120`$play_time
#> [1] "1758405666"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`121`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`121`$play_id
#> [1] "121"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`121`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`121`$clock
#> [1] "5:05"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`121`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`121`$distance
#> [1] "14"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`121`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`121`$yardline
#> [1] "NEB 21"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`121`$yards_to_endzone
#> [1] "79"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`121`$type
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`121`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`121`$text
#> [1] "[ncaaf.p.457863] incomplete pass to the right intended for [ncaaf.p.333434]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`121`$play_time
#> [1] "1758405695"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`122`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`122`$play_id
#> [1] "122"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`122`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`122`$clock
#> [1] "4:48"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`122`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`122`$distance
#> [1] "14"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`122`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`122`$yardline
#> [1] "NEB 21"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`122`$yards_to_endzone
#> [1] "79"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`122`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`122`$yards
#> [1] "12"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`122`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.333434] to the left for 3 yard loss, tackled by [ncaaf.p.457602]. Michigan committed 15 yard penalty (Unsportsmanlike Conduct)"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`122`$play_time
#> [1] "1758405765"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`123`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`123`$play_id
#> [1] "123"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`123`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`123`$clock
#> [1] "4:48"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`123`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`123`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`123`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`123`$yardline
#> [1] "NEB 33"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`123`$yards_to_endzone
#> [1] "67"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`123`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`123`$yards
#> [1] "6"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`123`$text
#> [1] "[ncaaf.p.461405] rushed up the middle for 6 yard gain, tackled by [ncaaf.p.474366]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`123`$play_time
#> [1] "1758405839"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`124`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`124`$play_id
#> [1] "124"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`124`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`124`$clock
#> [1] "4:28"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`124`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`124`$distance
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`124`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`124`$yardline
#> [1] "NEB 39"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`124`$yards_to_endzone
#> [1] "61"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`124`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`124`$yards
#> [1] "18"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`124`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.333434] to the left for 18 yard gain, tackled by [ncaaf.p.474366]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`124`$play_time
#> [1] "1758405862"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`125`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`125`$play_id
#> [1] "125"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`125`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`125`$clock
#> [1] "3:33"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`125`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`125`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`125`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`125`$yardline
#> [1] "MICH 43"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`125`$yards_to_endzone
#> [1] "43"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`125`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`125`$yards
#> [1] "9"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`125`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.322801] down the middle for 9 yard gain, tackled by [ncaaf.p.405652]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`125`$play_time
#> [1] "1758405908"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`126`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`126`$play_id
#> [1] "126"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`126`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`126`$clock
#> [1] "3:00"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`126`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`126`$distance
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`126`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`126`$yardline
#> [1] "MICH 34"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`126`$yards_to_endzone
#> [1] "34"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`126`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`126`$yards
#> [1] "5"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`126`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.333433] to the right for 5 yard gain, tackled by [ncaaf.p.405415]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`126`$play_time
#> [1] "1758405941"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`127`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`127`$play_id
#> [1] "127"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`127`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`127`$clock
#> [1] "2:23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`127`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`127`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`127`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`127`$yardline
#> [1] "MICH 29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`127`$yards_to_endzone
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`127`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`127`$yards
#> [1] "5"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`127`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.333434] to the right for 5 yard gain, tackled by [ncaaf.p.405652]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`127`$play_time
#> [1] "1758405977"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`128`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`128`$play_id
#> [1] "128"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`128`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`128`$clock
#> [1] "1:48"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`128`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`128`$distance
#> [1] "5"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`128`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`128`$yardline
#> [1] "MICH 24"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`128`$yards_to_endzone
#> [1] "24"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`128`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`128`$yards
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`128`$text
#> [1] "[ncaaf.p.333433] rushed to the right for 8 yard gain, tackled by [ncaaf.p.403634]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`128`$play_time
#> [1] "1758406040"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`129`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`129`$play_id
#> [1] "129"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`129`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`129`$clock
#> [1] "1:26"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`129`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`129`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`129`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`129`$yardline
#> [1] "MICH 16"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`129`$yards_to_endzone
#> [1] "16"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`129`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`129`$yards
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`129`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.457834] to the left for 3 yard gain, tackled by [ncaaf.p.474366]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`129`$play_time
#> [1] "1758406082"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`130`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`130`$play_id
#> [1] "130"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`130`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`130`$clock
#> [1] "0:48"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`130`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`130`$distance
#> [1] "7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`130`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`130`$yardline
#> [1] "MICH 13"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`130`$yards_to_endzone
#> [1] "13"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`130`$type
#> [1] "21"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`130`$yards
#> [1] "-7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`130`$text
#> [1] "[ncaaf.p.457863] sacked by [ncaaf.p.333312] for 7 yard loss"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`130`$play_time
#> [1] "1758406122"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`131`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`131`$play_id
#> [1] "131"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`131`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`131`$clock
#> [1] "0:00"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`131`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`131`$distance
#> [1] "14"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`131`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`131`$yardline
#> [1] "MICH 20"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`131`$yards_to_endzone
#> [1] "20"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`131`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`131`$yards
#> [1] "20"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`131`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.404124] for 20 yard gain. Nebraska penalty (Illegal Touch)"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`131`$play_time
#> [1] "1758406204"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`132`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`132`$play_id
#> [1] "132"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`132`$period
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`132`$clock
#> [1] "0:00"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`132`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`132`$distance
#> [1] "14"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`132`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`132`$yardline
#> [1] "MICH 20"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`132`$yards_to_endzone
#> [1] "20"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`132`$type
#> [1] "25"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`132`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`132`$text
#> [1] "End of 3rd Quarter"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`132`$play_time
#> [1] "1758406240"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`134`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`134`$play_id
#> [1] "134"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`134`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`134`$clock
#> [1] "15:00"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`134`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`134`$distance
#> [1] "14"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`134`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`134`$yardline
#> [1] "MICH 20"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`134`$yards_to_endzone
#> [1] "20"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`134`$type
#> [1] "9"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`134`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`134`$text
#> [1] "[ncaaf.p.451229] kicked a 38-yard field goal"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`134`$play_time
#> [1] "1758406463"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`135`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`135`$play_id
#> [1] "135"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`135`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`135`$clock
#> [1] "14:56"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`135`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`135`$distance
#> [1] "14"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`135`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`135`$yardline
#> [1] "MICH 20"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`135`$yards_to_endzone
#> [1] "20"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`135`$type
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`135`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`135`$text
#> [1] "Nebraska kicked off for 64 yards, [ncaaf.p.327425] returned kickoff for no gain"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`135`$play_time
#> [1] "1758406544"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`136`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`136`$play_id
#> [1] "136"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`136`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`136`$clock
#> [1] "14:56"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`136`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`136`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`136`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`136`$yardline
#> [1] "MICH 25"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`136`$yards_to_endzone
#> [1] "75"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`136`$type
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`136`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`136`$text
#> [1] "[ncaaf.p.469436] incomplete pass to the right intended for [ncaaf.p.403962]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`136`$play_time
#> [1] "1758406585"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`137`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`137`$play_id
#> [1] "137"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`137`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`137`$clock
#> [1] "14:52"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`137`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`137`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`137`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`137`$yardline
#> [1] "MICH 25"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`137`$yards_to_endzone
#> [1] "75"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`137`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`137`$yards
#> [1] "6"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`137`$text
#> [1] "[ncaaf.p.469436] passed to [ncaaf.p.403924] to the left for 6 yard gain, tackled by [ncaaf.p.457853]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`137`$play_time
#> [1] "1758406631"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`138`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`138`$play_id
#> [1] "138"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`138`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`138`$clock
#> [1] "14:17"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`138`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`138`$distance
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`138`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`138`$yardline
#> [1] "MICH 31"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`138`$yards_to_endzone
#> [1] "69"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`138`$type
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`138`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`138`$text
#> [1] "[ncaaf.p.469436] incomplete pass to the right intended for [ncaaf.p.457613]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`138`$play_time
#> [1] "1758406661"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`139`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`139`$play_id
#> [1] "139"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`139`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`139`$clock
#> [1] "14:14"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`139`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`139`$distance
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`139`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`139`$yardline
#> [1] "MICH 31"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`139`$yards_to_endzone
#> [1] "69"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`139`$type
#> [1] "7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`139`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`139`$text
#> [1] "[ncaaf.p.338368] punted for 42 yards. [ncaaf.p.457834] returned punt for 2 yards"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`139`$play_time
#> [1] "1758406714"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`140`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`140`$play_id
#> [1] "140"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`140`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`140`$clock
#> [1] "14:05"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`140`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`140`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`140`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`140`$yardline
#> [1] "NEB 29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`140`$yards_to_endzone
#> [1] "71"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`140`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`140`$yards
#> [1] "-2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`140`$text
#> [1] "[ncaaf.p.333433] rushed for 2 yard loss, tackled by [ncaaf.p.333324]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`140`$play_time
#> [1] "1758406934"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`141`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`141`$play_id
#> [1] "141"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`141`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`141`$clock
#> [1] "13:38"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`141`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`141`$distance
#> [1] "12"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`141`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`141`$yardline
#> [1] "NEB 27"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`141`$yards_to_endzone
#> [1] "73"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`141`$type
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`141`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`141`$text
#> [1] "[ncaaf.p.457863] incomplete pass to the right intended for [ncaaf.p.404124]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`141`$play_time
#> [1] "1758406934"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`142`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`142`$play_id
#> [1] "142"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`142`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`142`$clock
#> [1] "13:32"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`142`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`142`$distance
#> [1] "12"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`142`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`142`$yardline
#> [1] "NEB 27"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`142`$yards_to_endzone
#> [1] "73"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`142`$type
#> [1] "21"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`142`$yards
#> [1] "-3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`142`$text
#> [1] "[ncaaf.p.457863] sacked by [ncaaf.p.333312] and [ncaaf.p.403958] for 3 yard loss"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`142`$play_time
#> [1] "1758406983"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`143`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`143`$play_id
#> [1] "143"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`143`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`143`$clock
#> [1] "12:51"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`143`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`143`$distance
#> [1] "15"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`143`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`143`$yardline
#> [1] "NEB 24"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`143`$yards_to_endzone
#> [1] "76"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`143`$type
#> [1] "7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`143`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`143`$text
#> [1] "[ncaaf.p.471801] punted for 56 yards, no return"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`143`$play_time
#> [1] "1758407026"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`144`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`144`$play_id
#> [1] "144"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`144`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`144`$clock
#> [1] "12:40"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`144`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`144`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`144`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`144`$yardline
#> [1] "MICH 20"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`144`$yards_to_endzone
#> [1] "80"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`144`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`144`$yards
#> [1] "13"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`144`$text
#> [1] "[ncaaf.p.404392] rushed up the middle for 13 yard gain, tackled by [ncaaf.p.299700]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`144`$play_time
#> [1] "1758407219"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`145`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`145`$play_id
#> [1] "145"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`145`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`145`$clock
#> [1] "12:02"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`145`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`145`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`145`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`145`$yardline
#> [1] "MICH 33"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`145`$yards_to_endzone
#> [1] "67"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`145`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`145`$yards
#> [1] "5"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`145`$text
#> [1] "[ncaaf.p.404392] rushed up the middle for 5 yard gain, tackled by [ncaaf.p.322308]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`145`$play_time
#> [1] "1758407252"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`146`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`146`$play_id
#> [1] "146"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`146`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`146`$clock
#> [1] "11:27"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`146`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`146`$distance
#> [1] "5"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`146`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`146`$yardline
#> [1] "MICH 38"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`146`$yards_to_endzone
#> [1] "62"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`146`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`146`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`146`$text
#> [1] "[ncaaf.p.404392] rushed to the left for no gain, tackled by [ncaaf.p.457838]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`146`$play_time
#> [1] "1758407284"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`147`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`147`$play_id
#> [1] "147"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`147`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`147`$clock
#> [1] "10:44"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`147`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`147`$distance
#> [1] "5"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`147`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`147`$yardline
#> [1] "MICH 38"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`147`$yards_to_endzone
#> [1] "62"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`147`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`147`$yards
#> [1] "6"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`147`$text
#> [1] "[ncaaf.p.469436] passed to [ncaaf.p.403962] for 6 yard gain, tackled by [ncaaf.p.299700]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`147`$play_time
#> [1] "1758407337"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`148`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`148`$play_id
#> [1] "148"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`148`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`148`$clock
#> [1] "10:07"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`148`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`148`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`148`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`148`$yardline
#> [1] "MICH 44"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`148`$yards_to_endzone
#> [1] "56"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`148`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`148`$yards
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`148`$text
#> [1] "[ncaaf.p.404392] rushed up the middle for 1 yard gain, tackled by [ncaaf.p.457838]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`148`$play_time
#> [1] "1758407371"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`149`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`149`$play_id
#> [1] "149"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`149`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`149`$clock
#> [1] "9:32"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`149`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`149`$distance
#> [1] "9"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`149`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`149`$yardline
#> [1] "MICH 45"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`149`$yards_to_endzone
#> [1] "55"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`149`$type
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`149`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`149`$text
#> [1] "[ncaaf.p.469436] incomplete pass to the left intended for [ncaaf.p.323602]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`149`$play_time
#> [1] "1758407423"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`150`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`150`$play_id
#> [1] "150"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`150`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`150`$clock
#> [1] "9:22"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`150`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`150`$distance
#> [1] "9"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`150`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`150`$yardline
#> [1] "MICH 45"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`150`$yards_to_endzone
#> [1] "55"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`150`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`150`$yards
#> [1] "16"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`150`$text
#> [1] "[ncaaf.p.469436] passed to [ncaaf.p.404392] to the right for 16 yard gain, tackled by [ncaaf.p.457880]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`150`$play_time
#> [1] "1758407463"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`151`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`151`$play_id
#> [1] "151"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`151`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`151`$clock
#> [1] "8:44"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`151`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`151`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`151`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`151`$yardline
#> [1] "NEB 39"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`151`$yards_to_endzone
#> [1] "39"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`151`$type
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`151`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`151`$text
#> [1] "[ncaaf.p.469436] incomplete pass intended for [ncaaf.p.328039]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`151`$play_time
#> [1] "1758407491"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`152`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`152`$play_id
#> [1] "152"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`152`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`152`$clock
#> [1] "8:41"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`152`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`152`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`152`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`152`$yardline
#> [1] "NEB 39"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`152`$yards_to_endzone
#> [1] "39"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`152`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`152`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`152`$text
#> [1] "[ncaaf.p.457591] rushed to the right for no gain, tackled by [ncaaf.p.315007]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`152`$play_time
#> [1] "1758407528"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`153`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`153`$play_id
#> [1] "153"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`153`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`153`$clock
#> [1] "7:59"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`153`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`153`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`153`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`153`$yardline
#> [1] "NEB 39"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`153`$yards_to_endzone
#> [1] "39"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`153`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`153`$yards
#> [1] "19"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`153`$text
#> [1] "[ncaaf.p.404392] rushed to the left for 19 yard gain, tackled by [ncaaf.p.406379]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`153`$play_time
#> [1] "1758407578"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`154`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`154`$play_id
#> [1] "154"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`154`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`154`$clock
#> [1] "7:22"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`154`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`154`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`154`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`154`$yardline
#> [1] "NEB 20"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`154`$yards_to_endzone
#> [1] "20"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`154`$type
#> [1] "24"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`154`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`154`$text
#> [1] "Nebraska timeout"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`154`$play_time
#> [1] "1758407620"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`155`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`155`$play_id
#> [1] "155"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`155`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`155`$clock
#> [1] "7:22"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`155`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`155`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`155`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`155`$yardline
#> [1] "NEB 20"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`155`$yards_to_endzone
#> [1] "20"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`155`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`155`$yards
#> [1] "-1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`155`$text
#> [1] "[ncaaf.p.469436] rushed to the left for 1 yard loss, tackled by [ncaaf.p.461399]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`155`$play_time
#> [1] "1758407701"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`156`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`156`$play_id
#> [1] "156"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`156`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`156`$clock
#> [1] "6:42"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`156`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`156`$distance
#> [1] "11"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`156`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`156`$yardline
#> [1] "NEB 21"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`156`$yards_to_endzone
#> [1] "21"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`156`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`156`$yards
#> [1] "12"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`156`$text
#> [1] "[ncaaf.p.469436] rushed to the left for 12 yard gain, tackled by [ncaaf.p.457853]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`156`$play_time
#> [1] "1758407737"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`157`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`157`$play_id
#> [1] "157"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`157`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`157`$clock
#> [1] "6:02"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`157`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`157`$distance
#> [1] "9"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`157`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`157`$yardline
#> [1] "NEB 9"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`157`$yards_to_endzone
#> [1] "9"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`157`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`157`$yards
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`157`$text
#> [1] "[ncaaf.p.404392] rushed up the middle for 1 yard gain, tackled by [ncaaf.p.457838]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`157`$play_time
#> [1] "1758407777"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`158`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`158`$play_id
#> [1] "158"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`158`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`158`$clock
#> [1] "5:22"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`158`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`158`$distance
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`158`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`158`$yardline
#> [1] "NEB 8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`158`$yards_to_endzone
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`158`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`158`$yards
#> [1] "6"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`158`$text
#> [1] "[ncaaf.p.469436] rushed to the right for 6 yard gain, tackled by [ncaaf.p.457838]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`158`$play_time
#> [1] "1758407868"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`159`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`159`$play_id
#> [1] "159"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`159`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`159`$clock
#> [1] "4:40"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`159`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`159`$distance
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`159`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`159`$yardline
#> [1] "NEB 2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`159`$yards_to_endzone
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`159`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`159`$yards
#> [1] "-1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`159`$text
#> [1] "[ncaaf.p.469436] rushed for 1 yard loss, tackled by [ncaaf.p.299700]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`159`$play_time
#> [1] "1758407868"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`160`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`160`$play_id
#> [1] "160"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`160`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`160`$clock
#> [1] "3:57"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`160`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`160`$distance
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`160`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`160`$yardline
#> [1] "NEB 3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`160`$yards_to_endzone
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`160`$type
#> [1] "9"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`160`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`160`$text
#> [1] "[ncaaf.p.333922] kicked a 21-yard field goal"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`160`$play_time
#> [1] "1758407901"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`161`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`161`$play_id
#> [1] "161"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`161`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`161`$clock
#> [1] "3:54"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`161`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`161`$distance
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`161`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`161`$yardline
#> [1] "NEB 3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`161`$yards_to_endzone
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`161`$type
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`161`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`161`$text
#> [1] "Michigan kicked off, touchback"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`161`$play_time
#> [1] "1758408141"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`162`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`162`$play_id
#> [1] "162"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`162`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`162`$clock
#> [1] "3:54"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`162`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`162`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`162`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`162`$yardline
#> [1] "NEB 25"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`162`$yards_to_endzone
#> [1] "75"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`162`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`162`$yards
#> [1] "6"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`162`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.333433] to the right for 6 yard gain, tackled by [ncaaf.p.340505]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`162`$play_time
#> [1] "1758408141"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`163`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`163`$play_id
#> [1] "163"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`163`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`163`$clock
#> [1] "3:34"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`163`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`163`$distance
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`163`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`163`$yardline
#> [1] "NEB 31"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`163`$yards_to_endzone
#> [1] "69"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`163`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`163`$yards
#> [1] "5"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`163`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.333433] to the right for 5 yard gain"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`163`$play_time
#> [1] "1758408163"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`164`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`164`$play_id
#> [1] "164"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`164`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`164`$clock
#> [1] "3:07"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`164`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`164`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`164`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`164`$yardline
#> [1] "NEB 36"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`164`$yards_to_endzone
#> [1] "64"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`164`$type
#> [1] "24"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`164`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`164`$text
#> [1] "Michigan timeout"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`164`$play_time
#> [1] "1758408245"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`165`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`165`$play_id
#> [1] "165"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`165`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`165`$clock
#> [1] "3:07"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`165`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`165`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`165`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`165`$yardline
#> [1] "NEB 36"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`165`$yards_to_endzone
#> [1] "64"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`165`$type
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`165`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`165`$text
#> [1] "[ncaaf.p.457863] incomplete pass down the middle intended for [ncaaf.p.333286]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`165`$play_time
#> [1] "1758408246"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`166`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`166`$play_id
#> [1] "166"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`166`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`166`$clock
#> [1] "2:59"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`166`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`166`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`166`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`166`$yardline
#> [1] "NEB 36"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`166`$yards_to_endzone
#> [1] "64"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`166`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`166`$yards
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`166`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.469559] to the right for 10 yard gain, tackled by [ncaaf.p.474366]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`166`$play_time
#> [1] "1758408290"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`167`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`167`$play_id
#> [1] "167"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`167`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`167`$clock
#> [1] "2:35"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`167`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`167`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`167`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`167`$yardline
#> [1] "NEB 46"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`167`$yards_to_endzone
#> [1] "54"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`167`$type
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`167`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`167`$text
#> [1] "[ncaaf.p.457863] incomplete pass down the middle intended for [ncaaf.p.404124]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`167`$play_time
#> [1] "1758408369"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`168`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`168`$play_id
#> [1] "168"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`168`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`168`$clock
#> [1] "2:31"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`168`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`168`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`168`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`168`$yardline
#> [1] "NEB 46"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`168`$yards_to_endzone
#> [1] "54"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`168`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`168`$yards
#> [1] "-12"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`168`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.322827] down the middle for 12 yard loss, tackled by [ncaaf.p.457606]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`168`$play_time
#> [1] "1758408440"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`169`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`169`$play_id
#> [1] "169"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`169`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`169`$clock
#> [1] "2:11"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`169`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`169`$distance
#> [1] "22"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`169`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`169`$yardline
#> [1] "NEB 34"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`169`$yards_to_endzone
#> [1] "66"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`169`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`169`$yards
#> [1] "21"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`169`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.404124] down the middle for 21 yard gain, tackled by [ncaaf.p.474363]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`169`$play_time
#> [1] "1758408440"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`170`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`170`$play_id
#> [1] "170"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`170`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`170`$clock
#> [1] "2:00"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`170`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`170`$distance
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`170`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`170`$yardline
#> [1] "MICH 45"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`170`$yards_to_endzone
#> [1] "45"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`170`$type
#> [1] "24"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`170`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`170`$text
#> [1] "Two-minute warning"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`170`$play_time
#> [1] "1758408448"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`171`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`171`$play_id
#> [1] "171"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`171`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`171`$clock
#> [1] "2:00"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`171`$down
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`171`$distance
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`171`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`171`$yardline
#> [1] "MICH 45"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`171`$yards_to_endzone
#> [1] "45"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`171`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`171`$yards
#> [1] "6"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`171`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.322801] to the right for 6 yard gain, tackled by [ncaaf.p.405415]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`171`$play_time
#> [1] "1758408631"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`172`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`172`$play_id
#> [1] "172"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`172`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`172`$clock
#> [1] "1:50"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`172`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`172`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`172`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`172`$yardline
#> [1] "MICH 39"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`172`$yards_to_endzone
#> [1] "39"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`172`$type
#> [1] "20"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`172`$yards
#> [1] "15"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`172`$text
#> [1] "Michigan committed 15 yard penalty (Pass Interference)"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`172`$play_time
#> [1] "1758408730"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`173`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`173`$play_id
#> [1] "173"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`173`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`173`$clock
#> [1] "1:44"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`173`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`173`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`173`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`173`$yardline
#> [1] "MICH 24"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`173`$yards_to_endzone
#> [1] "24"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`173`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`173`$yards
#> [1] "21"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`173`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.457834] to the right for 21 yard gain, tackled by [ncaaf.p.403634]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`173`$play_time
#> [1] "1758408881"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`174`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`174`$play_id
#> [1] "174"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`174`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`174`$clock
#> [1] "1:38"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`174`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`174`$distance
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`174`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`174`$yardline
#> [1] "MICH 3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`174`$yards_to_endzone
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`174`$type
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`174`$yards
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`174`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.322801] for 3 yard touchdown"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`174`$play_time
#> [1] "1758408957"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`175`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`175`$play_id
#> [1] "175"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`175`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`175`$clock
#> [1] "1:34"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`175`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`175`$distance
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`175`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`175`$yardline
#> [1] "MICH 1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`175`$yards_to_endzone
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`175`$type
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`175`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`175`$text
#> [1] "[ncaaf.p.451229] made PAT"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`175`$play_time
#> [1] "1758408973"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`176`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`176`$play_id
#> [1] "176"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`176`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`176`$clock
#> [1] "1:34"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`176`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`176`$distance
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`176`$team
#> [1] "23"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`176`$yardline
#> [1] "MICH 1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`176`$yards_to_endzone
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`176`$type
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`176`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`176`$text
#> [1] "Nebraska kicked off for 11 yards, [ncaaf.p.404008] returned kickoff for 1 yard"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`176`$play_time
#> [1] "1758409112"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`177`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`177`$play_id
#> [1] "177"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`177`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`177`$clock
#> [1] "1:33"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`177`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`177`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`177`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`177`$yardline
#> [1] "NEB 45"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`177`$yards_to_endzone
#> [1] "45"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`177`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`177`$yards
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`177`$text
#> [1] "[ncaaf.p.457591] rushed up the middle for 3 yard gain, tackled by [ncaaf.p.404052]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`177`$play_time
#> [1] "1758409119"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`178`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`178`$play_id
#> [1] "178"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`178`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`178`$clock
#> [1] "1:29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`178`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`178`$distance
#> [1] "7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`178`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`178`$yardline
#> [1] "NEB 42"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`178`$yards_to_endzone
#> [1] "42"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`178`$type
#> [1] "24"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`178`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`178`$text
#> [1] "Nebraska timeout"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`178`$play_time
#> [1] "1758409119"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`179`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`179`$play_id
#> [1] "179"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`179`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`179`$clock
#> [1] "1:29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`179`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`179`$distance
#> [1] "7"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`179`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`179`$yardline
#> [1] "NEB 42"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`179`$yards_to_endzone
#> [1] "42"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`179`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`179`$yards
#> [1] "8"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`179`$text
#> [1] "[ncaaf.p.457591] rushed for 8 yard gain, tackled by [ncaaf.p.457880]"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`179`$play_time
#> [1] "1758409190"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`180`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`180`$play_id
#> [1] "180"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`180`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`180`$clock
#> [1] "1:24"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`180`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`180`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`180`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`180`$yardline
#> [1] "NEB 34"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`180`$yards_to_endzone
#> [1] "34"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`180`$type
#> [1] "24"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`180`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`180`$text
#> [1] "Nebraska timeout"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`180`$play_time
#> [1] "1758409274"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`181`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`181`$play_id
#> [1] "181"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`181`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`181`$clock
#> [1] "1:24"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`181`$down
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`181`$distance
#> [1] "10"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`181`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`181`$yardline
#> [1] "NEB 34"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`181`$yards_to_endzone
#> [1] "34"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`181`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`181`$yards
#> [1] "-2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`181`$text
#> [1] "[ncaaf.p.469436] rushed for 2 yard loss"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`181`$play_time
#> [1] "1758409274"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`182`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`182`$play_id
#> [1] "182"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`182`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`182`$clock
#> [1] "0:46"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`182`$down
#> [1] "2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`182`$distance
#> [1] "12"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`182`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`182`$yardline
#> [1] "NEB 36"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`182`$yards_to_endzone
#> [1] "36"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`182`$type
#> [1] "1"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`182`$yards
#> [1] "-2"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`182`$text
#> [1] "[ncaaf.p.469436] rushed for 2 yard loss"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`182`$play_time
#> [1] "1758409301"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`183`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`183`$play_id
#> [1] "183"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`183`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`183`$clock
#> [1] "0:00"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`183`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`183`$distance
#> [1] "14"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`183`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`183`$yardline
#> [1] "NEB 38"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`183`$yards_to_endzone
#> [1] "38"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`183`$type
#> [1] "25"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`183`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`183`$text
#> [1] "End of Regulation"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`183`$play_time
#> [1] "1758409349"
#> 
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`184`
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`184`$play_id
#> [1] "184"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`184`$period
#> [1] "4"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`184`$clock
#> [1] "0:00"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`184`$down
#> [1] "3"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`184`$distance
#> [1] "14"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`184`$team
#> [1] "29"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`184`$yardline
#> [1] "NEB 38"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`184`$yards_to_endzone
#> [1] "38"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`184`$type
#> [1] "25"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`184`$yards
#> [1] "0"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`184`$text
#> [1] "End of Game"
#> 
#> $service$boxscore$gameplay_by_play$ncaaf.g.202509200023$`184`$play_time
#> [1] "1758409349"
#> 
#> 
#> 
#> 
#> $service$boxscore$gamepitches
#> $service$boxscore$gamepitches$ncaaf.g.202509200023
#> list()
#> 
#> 
#> $service$boxscore$gameat_bat
#> $service$boxscore$gameat_bat$ncaaf.g.202509200023
#> NULL
#> 
#> 
#> $service$boxscore$gamescoring_summary
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`34`
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`34`$play_id
#> [1] "34"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`34`$period
#> [1] "1"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`34`$clock
#> [1] "1:42"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`34`$away_score
#> [1] "3"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`34`$home_score
#> [1] "0"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`34`$team
#> [1] "29"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`34`$score_type
#> [1] "FG"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`34`$xp_type
#> [1] "0"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`34`$PLAYERS
#> [1] "ncaaf.p.333922"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`34`$text
#> [1] "[ncaaf.p.333922] kicked a 46-yard field goal"
#> 
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`39`
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`39`$play_id
#> [1] "39"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`39`$period
#> [1] "1"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`39`$clock
#> [1] "0:17"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`39`$away_score
#> [1] "10"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`39`$home_score
#> [1] "0"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`39`$team
#> [1] "29"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`39`$score_type
#> [1] "TD"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`39`$xp_type
#> [1] "EP"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`39`$PLAYERS
#> [1] "ncaaf.p.469436,ncaaf.p.333922"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`39`$text
#> [1] "[ncaaf.p.469436] rushed up the middle for 37 yard touchdown ([ncaaf.p.333922] made PAT)"
#> 
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`59`
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`59`$play_id
#> [1] "59"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`59`$period
#> [1] "2"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`59`$clock
#> [1] "9:05"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`59`$away_score
#> [1] "10"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`59`$home_score
#> [1] "3"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`59`$team
#> [1] "23"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`59`$score_type
#> [1] "FG"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`59`$xp_type
#> [1] "0"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`59`$PLAYERS
#> [1] "ncaaf.p.451229"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`59`$text
#> [1] "[ncaaf.p.451229] kicked a 39-yard field goal"
#> 
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`72`
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`72`$play_id
#> [1] "72"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`72`$period
#> [1] "2"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`72`$clock
#> [1] "2:07"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`72`$away_score
#> [1] "10"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`72`$home_score
#> [1] "10"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`72`$team
#> [1] "23"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`72`$score_type
#> [1] "TD"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`72`$xp_type
#> [1] "EP"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`72`$PLAYERS
#> [1] "ncaaf.p.457863,ncaaf.p.457834,ncaaf.p.451229"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`72`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.457834] down the middle for 26 yard touchdown ([ncaaf.p.451229] made PAT)"
#> 
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`75`
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`75`$play_id
#> [1] "75"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`75`$period
#> [1] "2"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`75`$clock
#> [1] "2:01"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`75`$away_score
#> [1] "17"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`75`$home_score
#> [1] "10"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`75`$team
#> [1] "29"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`75`$score_type
#> [1] "TD"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`75`$xp_type
#> [1] "EP"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`75`$PLAYERS
#> [1] "ncaaf.p.404392,ncaaf.p.333922"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`75`$text
#> [1] "[ncaaf.p.404392] rushed to the left for 75 yard touchdown ([ncaaf.p.333922] made PAT)"
#> 
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`88`
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`88`$play_id
#> [1] "88"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`88`$period
#> [1] "2"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`88`$clock
#> [1] "0:01"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`88`$away_score
#> [1] "17"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`88`$home_score
#> [1] "17"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`88`$team
#> [1] "23"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`88`$score_type
#> [1] "TD"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`88`$xp_type
#> [1] "EP"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`88`$PLAYERS
#> [1] "ncaaf.p.457863,ncaaf.p.457834,ncaaf.p.451229"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`88`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.457834] to the right for 52 yard touchdown ([ncaaf.p.451229] made PAT)"
#> 
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`110`
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`110`$play_id
#> [1] "110"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`110`$period
#> [1] "3"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`110`$clock
#> [1] "7:48"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`110`$away_score
#> [1] "20"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`110`$home_score
#> [1] "17"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`110`$team
#> [1] "29"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`110`$score_type
#> [1] "FG"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`110`$xp_type
#> [1] "0"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`110`$PLAYERS
#> [1] "ncaaf.p.333922"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`110`$text
#> [1] "[ncaaf.p.333922] kicked a 56-yard field goal"
#> 
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`117`
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`117`$play_id
#> [1] "117"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`117`$period
#> [1] "3"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`117`$clock
#> [1] "5:47"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`117`$away_score
#> [1] "27"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`117`$home_score
#> [1] "17"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`117`$team
#> [1] "29"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`117`$score_type
#> [1] "TD"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`117`$xp_type
#> [1] "EP"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`117`$PLAYERS
#> [1] "ncaaf.p.457591,ncaaf.p.333922"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`117`$text
#> [1] "[ncaaf.p.457591] rushed to the right for 54 yard touchdown ([ncaaf.p.333922] made PAT)"
#> 
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`134`
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`134`$play_id
#> [1] "134"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`134`$period
#> [1] "4"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`134`$clock
#> [1] "15:00"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`134`$away_score
#> [1] "27"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`134`$home_score
#> [1] "20"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`134`$team
#> [1] "23"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`134`$score_type
#> [1] "FG"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`134`$xp_type
#> [1] "0"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`134`$PLAYERS
#> [1] "ncaaf.p.451229"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`134`$text
#> [1] "[ncaaf.p.451229] kicked a 38-yard field goal"
#> 
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`160`
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`160`$play_id
#> [1] "160"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`160`$period
#> [1] "4"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`160`$clock
#> [1] "3:57"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`160`$away_score
#> [1] "30"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`160`$home_score
#> [1] "20"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`160`$team
#> [1] "29"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`160`$score_type
#> [1] "FG"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`160`$xp_type
#> [1] "0"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`160`$PLAYERS
#> [1] "ncaaf.p.333922"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`160`$text
#> [1] "[ncaaf.p.333922] kicked a 21-yard field goal"
#> 
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`174`
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`174`$play_id
#> [1] "174"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`174`$period
#> [1] "4"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`174`$clock
#> [1] "1:38"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`174`$away_score
#> [1] "30"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`174`$home_score
#> [1] "27"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`174`$team
#> [1] "23"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`174`$score_type
#> [1] "TD"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`174`$xp_type
#> [1] "EP"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`174`$PLAYERS
#> [1] "ncaaf.p.457863,ncaaf.p.322801,ncaaf.p.451229"
#> 
#> $service$boxscore$gamescoring_summary$ncaaf.g.202509200023$`174`$text
#> [1] "[ncaaf.p.457863] passed to [ncaaf.p.322801] for 3 yard touchdown ([ncaaf.p.451229] made PAT)"
#> 
#> 
#> 
#> 
#> $service$boxscore$gamemedia_stream
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[1]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[1]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[1]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[1]]$sequence_id
#> [1] 1.758409e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[1]]$external_id
#> [1] "184"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[1]]$timestamp
#> [1] "1758409349"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[1]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[2]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[2]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[2]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[2]]$sequence_id
#> [1] 1.758409e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[2]]$external_id
#> [1] "183"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[2]]$timestamp
#> [1] "1758409349"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[2]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[3]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[3]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[3]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[3]]$sequence_id
#> [1] 1.758409e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[3]]$external_id
#> [1] "182"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[3]]$timestamp
#> [1] "1758409301"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[3]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[4]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[4]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[4]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[4]]$sequence_id
#> [1] 1.758409e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[4]]$external_id
#> [1] "181"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[4]]$timestamp
#> [1] "1758409274"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[4]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[5]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[5]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[5]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[5]]$sequence_id
#> [1] 1.758409e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[5]]$external_id
#> [1] "180"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[5]]$timestamp
#> [1] "1758409274"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[5]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[6]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[6]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[6]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[6]]$sequence_id
#> [1] 1.758409e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[6]]$external_id
#> [1] "179"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[6]]$timestamp
#> [1] "1758409190"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[6]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[7]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[7]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[7]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[7]]$sequence_id
#> [1] 1.758409e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[7]]$external_id
#> [1] "178"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[7]]$timestamp
#> [1] "1758409119"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[7]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[8]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[8]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[8]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[8]]$sequence_id
#> [1] 1.758409e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[8]]$external_id
#> [1] "177"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[8]]$timestamp
#> [1] "1758409119"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[8]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[9]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[9]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[9]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[9]]$sequence_id
#> [1] 1.758409e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[9]]$external_id
#> [1] "176"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[9]]$timestamp
#> [1] "1758409112"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[9]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[10]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[10]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[10]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[10]]$sequence_id
#> [1] 1.758409e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[10]]$external_id
#> [1] "175"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[10]]$timestamp
#> [1] "1758408973"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[10]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[11]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[11]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[11]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[11]]$sequence_id
#> [1] 1.758409e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[11]]$external_id
#> [1] "174"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[11]]$timestamp
#> [1] "1758408957"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[11]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[12]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[12]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[12]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[12]]$sequence_id
#> [1] 1.758409e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[12]]$external_id
#> [1] "173"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[12]]$timestamp
#> [1] "1758408881"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[12]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[13]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[13]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[13]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[13]]$sequence_id
#> [1] 1.758409e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[13]]$external_id
#> [1] "172"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[13]]$timestamp
#> [1] "1758408730"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[13]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[14]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[14]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[14]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[14]]$sequence_id
#> [1] 1.758409e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[14]]$external_id
#> [1] "171"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[14]]$timestamp
#> [1] "1758408631"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[14]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[15]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[15]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[15]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[15]]$sequence_id
#> [1] 1.758408e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[15]]$external_id
#> [1] "170"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[15]]$timestamp
#> [1] "1758408448"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[15]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[16]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[16]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[16]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[16]]$sequence_id
#> [1] 1.758408e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[16]]$external_id
#> [1] "169"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[16]]$timestamp
#> [1] "1758408440"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[16]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[17]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[17]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[17]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[17]]$sequence_id
#> [1] 1.758408e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[17]]$external_id
#> [1] "168"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[17]]$timestamp
#> [1] "1758408440"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[17]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[18]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[18]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[18]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[18]]$sequence_id
#> [1] 1.758408e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[18]]$external_id
#> [1] "167"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[18]]$timestamp
#> [1] "1758408369"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[18]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[19]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[19]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[19]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[19]]$sequence_id
#> [1] 1.758408e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[19]]$external_id
#> [1] "166"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[19]]$timestamp
#> [1] "1758408290"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[19]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[20]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[20]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[20]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[20]]$sequence_id
#> [1] 1.758408e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[20]]$external_id
#> [1] "165"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[20]]$timestamp
#> [1] "1758408246"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[20]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[21]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[21]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[21]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[21]]$sequence_id
#> [1] 1.758408e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[21]]$external_id
#> [1] "164"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[21]]$timestamp
#> [1] "1758408245"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[21]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[22]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[22]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[22]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[22]]$sequence_id
#> [1] 1.758408e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[22]]$external_id
#> [1] "163"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[22]]$timestamp
#> [1] "1758408163"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[22]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[23]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[23]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[23]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[23]]$sequence_id
#> [1] 1.758408e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[23]]$external_id
#> [1] "162"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[23]]$timestamp
#> [1] "1758408141"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[23]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[24]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[24]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[24]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[24]]$sequence_id
#> [1] 1.758408e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[24]]$external_id
#> [1] "161"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[24]]$timestamp
#> [1] "1758408141"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[24]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[25]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[25]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[25]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[25]]$sequence_id
#> [1] 1.758408e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[25]]$external_id
#> [1] "160"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[25]]$timestamp
#> [1] "1758407901"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[25]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[26]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[26]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[26]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[26]]$sequence_id
#> [1] 1.758408e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[26]]$external_id
#> [1] "159"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[26]]$timestamp
#> [1] "1758407868"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[26]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[27]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[27]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[27]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[27]]$sequence_id
#> [1] 1.758408e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[27]]$external_id
#> [1] "158"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[27]]$timestamp
#> [1] "1758407868"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[27]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[28]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[28]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[28]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[28]]$sequence_id
#> [1] 1.758408e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[28]]$external_id
#> [1] "157"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[28]]$timestamp
#> [1] "1758407777"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[28]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[29]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[29]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[29]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[29]]$sequence_id
#> [1] 1.758408e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[29]]$external_id
#> [1] "156"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[29]]$timestamp
#> [1] "1758407737"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[29]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[30]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[30]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[30]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[30]]$sequence_id
#> [1] 1.758408e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[30]]$external_id
#> [1] "155"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[30]]$timestamp
#> [1] "1758407701"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[30]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[31]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[31]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[31]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[31]]$sequence_id
#> [1] 1.758408e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[31]]$external_id
#> [1] "154"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[31]]$timestamp
#> [1] "1758407620"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[31]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[32]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[32]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[32]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[32]]$sequence_id
#> [1] 1.758408e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[32]]$external_id
#> [1] "153"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[32]]$timestamp
#> [1] "1758407578"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[32]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[33]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[33]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[33]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[33]]$sequence_id
#> [1] 1.758408e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[33]]$external_id
#> [1] "152"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[33]]$timestamp
#> [1] "1758407528"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[33]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[34]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[34]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[34]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[34]]$sequence_id
#> [1] 1.758407e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[34]]$external_id
#> [1] "151"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[34]]$timestamp
#> [1] "1758407491"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[34]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[35]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[35]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[35]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[35]]$sequence_id
#> [1] 1.758407e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[35]]$external_id
#> [1] "150"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[35]]$timestamp
#> [1] "1758407463"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[35]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[36]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[36]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[36]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[36]]$sequence_id
#> [1] 1.758407e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[36]]$external_id
#> [1] "149"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[36]]$timestamp
#> [1] "1758407423"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[36]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[37]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[37]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[37]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[37]]$sequence_id
#> [1] 1.758407e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[37]]$external_id
#> [1] "148"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[37]]$timestamp
#> [1] "1758407371"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[37]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[38]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[38]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[38]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[38]]$sequence_id
#> [1] 1.758407e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[38]]$external_id
#> [1] "147"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[38]]$timestamp
#> [1] "1758407337"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[38]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[39]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[39]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[39]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[39]]$sequence_id
#> [1] 1.758407e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[39]]$external_id
#> [1] "146"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[39]]$timestamp
#> [1] "1758407284"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[39]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[40]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[40]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[40]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[40]]$sequence_id
#> [1] 1.758407e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[40]]$external_id
#> [1] "145"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[40]]$timestamp
#> [1] "1758407252"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[40]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[41]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[41]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[41]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[41]]$sequence_id
#> [1] 1.758407e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[41]]$external_id
#> [1] "144"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[41]]$timestamp
#> [1] "1758407219"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[41]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[42]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[42]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[42]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[42]]$sequence_id
#> [1] 1.758407e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[42]]$external_id
#> [1] "143"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[42]]$timestamp
#> [1] "1758407026"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[42]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[43]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[43]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[43]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[43]]$sequence_id
#> [1] 1.758407e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[43]]$external_id
#> [1] "142"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[43]]$timestamp
#> [1] "1758406983"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[43]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[44]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[44]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[44]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[44]]$sequence_id
#> [1] 1.758407e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[44]]$external_id
#> [1] "141"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[44]]$timestamp
#> [1] "1758406934"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[44]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[45]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[45]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[45]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[45]]$sequence_id
#> [1] 1.758407e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[45]]$external_id
#> [1] "140"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[45]]$timestamp
#> [1] "1758406934"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[45]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[46]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[46]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[46]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[46]]$sequence_id
#> [1] 1.758407e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[46]]$external_id
#> [1] "139"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[46]]$timestamp
#> [1] "1758406714"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[46]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[47]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[47]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[47]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[47]]$sequence_id
#> [1] 1.758407e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[47]]$external_id
#> [1] "138"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[47]]$timestamp
#> [1] "1758406661"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[47]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[48]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[48]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[48]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[48]]$sequence_id
#> [1] 1.758407e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[48]]$external_id
#> [1] "137"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[48]]$timestamp
#> [1] "1758406631"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[48]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[49]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[49]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[49]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[49]]$sequence_id
#> [1] 1.758407e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[49]]$external_id
#> [1] "136"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[49]]$timestamp
#> [1] "1758406585"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[49]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[50]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[50]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[50]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[50]]$sequence_id
#> [1] 1.758407e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[50]]$external_id
#> [1] "135"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[50]]$timestamp
#> [1] "1758406544"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[50]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[51]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[51]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[51]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[51]]$sequence_id
#> [1] 1.758406e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[51]]$external_id
#> [1] "134"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[51]]$timestamp
#> [1] "1758406463"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[51]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[52]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[52]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[52]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[52]]$sequence_id
#> [1] 1.758406e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[52]]$external_id
#> [1] "132"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[52]]$timestamp
#> [1] "1758406240"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[52]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[53]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[53]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[53]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[53]]$sequence_id
#> [1] 1.758406e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[53]]$external_id
#> [1] "131"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[53]]$timestamp
#> [1] "1758406204"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[53]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[54]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[54]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[54]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[54]]$sequence_id
#> [1] 1.758406e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[54]]$external_id
#> [1] "130"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[54]]$timestamp
#> [1] "1758406122"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[54]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[55]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[55]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[55]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[55]]$sequence_id
#> [1] 1.758406e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[55]]$external_id
#> [1] "129"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[55]]$timestamp
#> [1] "1758406082"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[55]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[56]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[56]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[56]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[56]]$sequence_id
#> [1] 1.758406e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[56]]$external_id
#> [1] "128"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[56]]$timestamp
#> [1] "1758406040"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[56]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[57]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[57]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[57]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[57]]$sequence_id
#> [1] 1.758406e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[57]]$external_id
#> [1] "127"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[57]]$timestamp
#> [1] "1758405977"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[57]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[58]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[58]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[58]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[58]]$sequence_id
#> [1] 1.758406e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[58]]$external_id
#> [1] "126"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[58]]$timestamp
#> [1] "1758405941"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[58]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[59]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[59]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[59]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[59]]$sequence_id
#> [1] 1.758406e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[59]]$external_id
#> [1] "125"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[59]]$timestamp
#> [1] "1758405908"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[59]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[60]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[60]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[60]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[60]]$sequence_id
#> [1] 1.758406e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[60]]$external_id
#> [1] "124"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[60]]$timestamp
#> [1] "1758405862"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[60]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[61]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[61]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[61]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[61]]$sequence_id
#> [1] 1.758406e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[61]]$external_id
#> [1] "123"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[61]]$timestamp
#> [1] "1758405839"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[61]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[62]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[62]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[62]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[62]]$sequence_id
#> [1] 1.758406e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[62]]$external_id
#> [1] "122"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[62]]$timestamp
#> [1] "1758405765"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[62]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[63]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[63]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[63]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[63]]$sequence_id
#> [1] 1.758406e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[63]]$external_id
#> [1] "121"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[63]]$timestamp
#> [1] "1758405695"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[63]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[64]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[64]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[64]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[64]]$sequence_id
#> [1] 1.758406e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[64]]$external_id
#> [1] "120"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[64]]$timestamp
#> [1] "1758405666"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[64]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[65]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[65]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[65]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[65]]$sequence_id
#> [1] 1.758406e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[65]]$external_id
#> [1] "119"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[65]]$timestamp
#> [1] "1758405615"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[65]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[66]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[66]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[66]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[66]]$sequence_id
#> [1] 1.758406e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[66]]$external_id
#> [1] "118"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[66]]$timestamp
#> [1] "1758405535"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[66]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[67]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[67]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[67]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[67]]$sequence_id
#> [1] 1.758406e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[67]]$external_id
#> [1] "117"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[67]]$timestamp
#> [1] "1758405528"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[67]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[68]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[68]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[68]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[68]]$sequence_id
#> [1] 1.758405e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[68]]$external_id
#> [1] "116"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[68]]$timestamp
#> [1] "1758405457"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[68]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[69]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[69]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[69]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[69]]$sequence_id
#> [1] 1.758405e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[69]]$external_id
#> [1] "115"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[69]]$timestamp
#> [1] "1758405263"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[69]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[70]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[70]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[70]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[70]]$sequence_id
#> [1] 1.758405e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[70]]$external_id
#> [1] "114"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[70]]$timestamp
#> [1] "1758405221"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[70]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[71]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[71]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[71]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[71]]$sequence_id
#> [1] 1.758405e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[71]]$external_id
#> [1] "113"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[71]]$timestamp
#> [1] "1758405179"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[71]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[72]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[72]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[72]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[72]]$sequence_id
#> [1] 1.758405e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[72]]$external_id
#> [1] "112"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[72]]$timestamp
#> [1] "1758405140"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[72]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[73]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[73]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[73]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[73]]$sequence_id
#> [1] 1.758405e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[73]]$external_id
#> [1] "111"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[73]]$timestamp
#> [1] "1758405090"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[73]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[74]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[74]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[74]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[74]]$sequence_id
#> [1] 1.758405e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[74]]$external_id
#> [1] "110"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[74]]$timestamp
#> [1] "1758404899"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[74]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[75]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[75]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[75]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[75]]$sequence_id
#> [1] 1.758405e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[75]]$external_id
#> [1] "109"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[75]]$timestamp
#> [1] "1758404858"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[75]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[76]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[76]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[76]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[76]]$sequence_id
#> [1] 1.758405e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[76]]$external_id
#> [1] "108"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[76]]$timestamp
#> [1] "1758404692"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[76]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[77]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[77]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[77]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[77]]$sequence_id
#> [1] 1.758405e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[77]]$external_id
#> [1] "107"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[77]]$timestamp
#> [1] "1758404636"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[77]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[78]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[78]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[78]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[78]]$sequence_id
#> [1] 1.758405e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[78]]$external_id
#> [1] "106"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[78]]$timestamp
#> [1] "1758404603"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[78]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[79]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[79]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[79]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[79]]$sequence_id
#> [1] 1.758405e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[79]]$external_id
#> [1] "105"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[79]]$timestamp
#> [1] "1758404565"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[79]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[80]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[80]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[80]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[80]]$sequence_id
#> [1] 1.758405e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[80]]$external_id
#> [1] "104"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[80]]$timestamp
#> [1] "1758404565"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[80]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[81]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[81]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[81]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[81]]$sequence_id
#> [1] 1.758404e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[81]]$external_id
#> [1] "103"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[81]]$timestamp
#> [1] "1758404486"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[81]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[82]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[82]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[82]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[82]]$sequence_id
#> [1] 1.758404e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[82]]$external_id
#> [1] "102"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[82]]$timestamp
#> [1] "1758404300"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[82]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[83]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[83]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[83]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[83]]$sequence_id
#> [1] 1.758404e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[83]]$external_id
#> [1] "101"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[83]]$timestamp
#> [1] "1758404294"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[83]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[84]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[84]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[84]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[84]]$sequence_id
#> [1] 1.758404e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[84]]$external_id
#> [1] "100"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[84]]$timestamp
#> [1] "1758404207"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[84]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[85]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[85]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[85]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[85]]$sequence_id
#> [1] 1.758404e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[85]]$external_id
#> [1] "99"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[85]]$timestamp
#> [1] "1758404157"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[85]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[86]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[86]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[86]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[86]]$sequence_id
#> [1] 1.758404e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[86]]$external_id
#> [1] "98"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[86]]$timestamp
#> [1] "1758404121"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[86]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[87]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[87]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[87]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[87]]$sequence_id
#> [1] 1.758404e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[87]]$external_id
#> [1] "97"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[87]]$timestamp
#> [1] "1758403925"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[87]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[88]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[88]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[88]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[88]]$sequence_id
#> [1] 1.758404e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[88]]$external_id
#> [1] "96"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[88]]$timestamp
#> [1] "1758403925"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[88]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[89]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[89]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[89]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[89]]$sequence_id
#> [1] 1.758404e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[89]]$external_id
#> [1] "95"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[89]]$timestamp
#> [1] "1758403851"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[89]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[90]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[90]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[90]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[90]]$sequence_id
#> [1] 1.758404e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[90]]$external_id
#> [1] "94"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[90]]$timestamp
#> [1] "1758403810"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[90]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[91]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[91]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[91]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[91]]$sequence_id
#> [1] 1.758404e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[91]]$external_id
#> [1] "93"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[91]]$timestamp
#> [1] "1758403778"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[91]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[92]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[92]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[92]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[92]]$sequence_id
#> [1] 1.758404e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[92]]$external_id
#> [1] "92"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[92]]$timestamp
#> [1] "1758403713"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[92]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[93]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[93]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[93]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[93]]$sequence_id
#> [1] 1.758402e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[93]]$external_id
#> [1] "90"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[93]]$timestamp
#> [1] "1758402399"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[93]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[94]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[94]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[94]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[94]]$sequence_id
#> [1] 1.758402e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[94]]$external_id
#> [1] "89"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[94]]$timestamp
#> [1] "1758402392"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[94]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[95]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[95]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[95]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[95]]$sequence_id
#> [1] 1.758402e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[95]]$external_id
#> [1] "88"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[95]]$timestamp
#> [1] "1758402384"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[95]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[96]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[96]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[96]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[96]]$sequence_id
#> [1] 1.758402e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[96]]$external_id
#> [1] "87"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[96]]$timestamp
#> [1] "1758402248"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[96]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[97]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[97]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[97]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[97]]$sequence_id
#> [1] 1.758402e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[97]]$external_id
#> [1] "86"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[97]]$timestamp
#> [1] "1758402237"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[97]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[98]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[98]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[98]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[98]]$sequence_id
#> [1] 1.758402e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[98]]$external_id
#> [1] "85"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[98]]$timestamp
#> [1] "1758402165"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[98]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[99]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[99]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[99]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[99]]$sequence_id
#> [1] 1.758402e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[99]]$external_id
#> [1] "84"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[99]]$timestamp
#> [1] "1758402127"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[99]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[100]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[100]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[100]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[100]]$sequence_id
#> [1] 1.758402e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[100]]$external_id
#> [1] "83"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[100]]$timestamp
#> [1] "1758402063"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[100]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[101]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[101]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[101]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[101]]$sequence_id
#> [1] 1.758402e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[101]]$external_id
#> [1] "82"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[101]]$timestamp
#> [1] "1758402049"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[101]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[102]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[102]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[102]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[102]]$sequence_id
#> [1] 1.758402e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[102]]$external_id
#> [1] "81"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[102]]$timestamp
#> [1] "1758402022"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[102]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[103]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[103]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[103]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[103]]$sequence_id
#> [1] 1.758402e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[103]]$external_id
#> [1] "80"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[103]]$timestamp
#> [1] "1758401991"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[103]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[104]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[104]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[104]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[104]]$sequence_id
#> [1] 1.758402e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[104]]$external_id
#> [1] "79"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[104]]$timestamp
#> [1] "1758401943"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[104]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[105]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[105]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[105]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[105]]$sequence_id
#> [1] 1.758402e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[105]]$external_id
#> [1] "78"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[105]]$timestamp
#> [1] "1758401893"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[105]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[106]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[106]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[106]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[106]]$sequence_id
#> [1] 1.758402e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[106]]$external_id
#> [1] "77"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[106]]$timestamp
#> [1] "1758401706"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[106]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[107]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[107]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[107]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[107]]$sequence_id
#> [1] 1.758402e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[107]]$external_id
#> [1] "76"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[107]]$timestamp
#> [1] "1758401691"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[107]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[108]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[108]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[108]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[108]]$sequence_id
#> [1] 1.758402e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[108]]$external_id
#> [1] "75"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[108]]$timestamp
#> [1] "1758401683"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[108]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[109]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[109]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[109]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[109]]$sequence_id
#> [1] 1.758402e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[109]]$external_id
#> [1] "74"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[109]]$timestamp
#> [1] "1758401590"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[109]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[110]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[110]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[110]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[110]]$sequence_id
#> [1] 1.758401e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[110]]$external_id
#> [1] "73"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[110]]$timestamp
#> [1] "1758401491"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[110]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[111]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[111]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[111]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[111]]$sequence_id
#> [1] 1.758401e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[111]]$external_id
#> [1] "72"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[111]]$timestamp
#> [1] "1758401479"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[111]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[112]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[112]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[112]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[112]]$sequence_id
#> [1] 1.758401e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[112]]$external_id
#> [1] "71"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[112]]$timestamp
#> [1] "1758401399"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[112]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[113]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[113]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[113]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[113]]$sequence_id
#> [1] 1.758401e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[113]]$external_id
#> [1] "70"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[113]]$timestamp
#> [1] "1758401360"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[113]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[114]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[114]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[114]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[114]]$sequence_id
#> [1] 1.758401e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[114]]$external_id
#> [1] "69"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[114]]$timestamp
#> [1] "1758401323"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[114]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[115]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[115]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[115]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[115]]$sequence_id
#> [1] 1.758401e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[115]]$external_id
#> [1] "68"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[115]]$timestamp
#> [1] "1758401274"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[115]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[116]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[116]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[116]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[116]]$sequence_id
#> [1] 1.758401e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[116]]$external_id
#> [1] "67"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[116]]$timestamp
#> [1] "1758401244"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[116]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[117]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[117]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[117]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[117]]$sequence_id
#> [1] 1.758401e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[117]]$external_id
#> [1] "66"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[117]]$timestamp
#> [1] "1758401209"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[117]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[118]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[118]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[118]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[118]]$sequence_id
#> [1] 1.758401e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[118]]$external_id
#> [1] "65"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[118]]$timestamp
#> [1] "1758401014"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[118]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[119]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[119]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[119]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[119]]$sequence_id
#> [1] 1.758401e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[119]]$external_id
#> [1] "64"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[119]]$timestamp
#> [1] "1758400962"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[119]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[120]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[120]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[120]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[120]]$sequence_id
#> [1] 1.758401e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[120]]$external_id
#> [1] "63"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[120]]$timestamp
#> [1] "1758400929"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[120]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[121]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[121]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[121]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[121]]$sequence_id
#> [1] 1.758401e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[121]]$external_id
#> [1] "62"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[121]]$timestamp
#> [1] "1758400873"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[121]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[122]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[122]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[122]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[122]]$sequence_id
#> [1] 1.758401e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[122]]$external_id
#> [1] "61"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[122]]$timestamp
#> [1] "1758400838"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[122]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[123]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[123]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[123]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[123]]$sequence_id
#> [1] 1.758401e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[123]]$external_id
#> [1] "60"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[123]]$timestamp
#> [1] "1758400786"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[123]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[124]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[124]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[124]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[124]]$sequence_id
#> [1] 1.758401e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[124]]$external_id
#> [1] "59"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[124]]$timestamp
#> [1] "1758400591"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[124]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[125]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[125]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[125]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[125]]$sequence_id
#> [1] 1.758401e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[125]]$external_id
#> [1] "58"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[125]]$timestamp
#> [1] "1758400552"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[125]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[126]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[126]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[126]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[126]]$sequence_id
#> [1] 1.758401e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[126]]$external_id
#> [1] "57"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[126]]$timestamp
#> [1] "1758400513"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[126]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[127]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[127]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[127]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[127]]$sequence_id
#> [1] 1.7584e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[127]]$external_id
#> [1] "56"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[127]]$timestamp
#> [1] "1758400468"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[127]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[128]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[128]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[128]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[128]]$sequence_id
#> [1] 1.7584e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[128]]$external_id
#> [1] "55"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[128]]$timestamp
#> [1] "1758400434"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[128]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[129]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[129]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[129]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[129]]$sequence_id
#> [1] 1.7584e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[129]]$external_id
#> [1] "54"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[129]]$timestamp
#> [1] "1758400396"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[129]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[130]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[130]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[130]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[130]]$sequence_id
#> [1] 1.7584e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[130]]$external_id
#> [1] "53"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[130]]$timestamp
#> [1] "1758400366"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[130]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[131]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[131]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[131]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[131]]$sequence_id
#> [1] 1.7584e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[131]]$external_id
#> [1] "52"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[131]]$timestamp
#> [1] "1758400312"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[131]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[132]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[132]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[132]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[132]]$sequence_id
#> [1] 1.7584e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[132]]$external_id
#> [1] "51"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[132]]$timestamp
#> [1] "1758400256"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[132]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[133]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[133]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[133]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[133]]$sequence_id
#> [1] 1.7584e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[133]]$external_id
#> [1] "50"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[133]]$timestamp
#> [1] "1758400186"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[133]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[134]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[134]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[134]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[134]]$sequence_id
#> [1] 1.7584e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[134]]$external_id
#> [1] "49"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[134]]$timestamp
#> [1] "1758400147"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[134]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[135]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[135]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[135]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[135]]$sequence_id
#> [1] 1.7584e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[135]]$external_id
#> [1] "48"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[135]]$timestamp
#> [1] "1758399956"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[135]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[136]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[136]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[136]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[136]]$sequence_id
#> [1] 1.7584e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[136]]$external_id
#> [1] "47"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[136]]$timestamp
#> [1] "1758399906"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[136]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[137]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[137]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[137]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[137]]$sequence_id
#> [1] 1.7584e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[137]]$external_id
#> [1] "46"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[137]]$timestamp
#> [1] "1758399862"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[137]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[138]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[138]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[138]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[138]]$sequence_id
#> [1] 1.7584e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[138]]$external_id
#> [1] "44"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[138]]$timestamp
#> [1] "1758399593"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[138]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[139]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[139]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[139]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[139]]$sequence_id
#> [1] 1.7584e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[139]]$external_id
#> [1] "43"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[139]]$timestamp
#> [1] "1758399593"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[139]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[140]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[140]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[140]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[140]]$sequence_id
#> [1] 1.7584e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[140]]$external_id
#> [1] "42"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[140]]$timestamp
#> [1] "1758399542"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[140]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[141]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[141]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[141]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[141]]$sequence_id
#> [1] 1.7584e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[141]]$external_id
#> [1] "41"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[141]]$timestamp
#> [1] "1758399500"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[141]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[142]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[142]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[142]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[142]]$sequence_id
#> [1] 1.758399e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[142]]$external_id
#> [1] "40"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[142]]$timestamp
#> [1] "1758399451"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[142]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[143]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[143]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[143]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[143]]$sequence_id
#> [1] 1.758399e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[143]]$external_id
#> [1] "39"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[143]]$timestamp
#> [1] "1758399429"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[143]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[144]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[144]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[144]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[144]]$sequence_id
#> [1] 1.758399e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[144]]$external_id
#> [1] "38"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[144]]$timestamp
#> [1] "1758399346"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[144]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[145]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[145]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[145]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[145]]$sequence_id
#> [1] 1.758399e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[145]]$external_id
#> [1] "37"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[145]]$timestamp
#> [1] "1758399285"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[145]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[146]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[146]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[146]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[146]]$sequence_id
#> [1] 1.758399e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[146]]$external_id
#> [1] "36"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[146]]$timestamp
#> [1] "1758399252"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[146]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[147]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[147]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[147]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[147]]$sequence_id
#> [1] 1.758399e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[147]]$external_id
#> [1] "35"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[147]]$timestamp
#> [1] "1758399208"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[147]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[148]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[148]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[148]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[148]]$sequence_id
#> [1] 1.758399e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[148]]$external_id
#> [1] "34"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[148]]$timestamp
#> [1] "1758399001"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[148]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[149]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[149]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[149]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[149]]$sequence_id
#> [1] 1.758399e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[149]]$external_id
#> [1] "33"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[149]]$timestamp
#> [1] "1758398960"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[149]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[150]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[150]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[150]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[150]]$sequence_id
#> [1] 1.758399e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[150]]$external_id
#> [1] "32"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[150]]$timestamp
#> [1] "1758398921"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[150]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[151]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[151]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[151]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[151]]$sequence_id
#> [1] 1.758399e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[151]]$external_id
#> [1] "31"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[151]]$timestamp
#> [1] "1758398881"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[151]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[152]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[152]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[152]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[152]]$sequence_id
#> [1] 1.758399e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[152]]$external_id
#> [1] "30"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[152]]$timestamp
#> [1] "1758398818"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[152]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[153]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[153]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[153]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[153]]$sequence_id
#> [1] 1.758399e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[153]]$external_id
#> [1] "29"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[153]]$timestamp
#> [1] "1758398766"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[153]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[154]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[154]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[154]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[154]]$sequence_id
#> [1] 1.758399e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[154]]$external_id
#> [1] "28"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[154]]$timestamp
#> [1] "1758398735"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[154]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[155]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[155]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[155]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[155]]$sequence_id
#> [1] 1.758399e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[155]]$external_id
#> [1] "27"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[155]]$timestamp
#> [1] "1758398699"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[155]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[156]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[156]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[156]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[156]]$sequence_id
#> [1] 1.758399e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[156]]$external_id
#> [1] "26"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[156]]$timestamp
#> [1] "1758398680"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[156]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[157]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[157]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[157]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[157]]$sequence_id
#> [1] 1.758399e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[157]]$external_id
#> [1] "25"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[157]]$timestamp
#> [1] "1758398642"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[157]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[158]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[158]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[158]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[158]]$sequence_id
#> [1] 1.758398e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[158]]$external_id
#> [1] "24"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[158]]$timestamp
#> [1] "1758398444"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[158]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[159]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[159]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[159]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[159]]$sequence_id
#> [1] 1.758398e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[159]]$external_id
#> [1] "23"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[159]]$timestamp
#> [1] "1758398405"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[159]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[160]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[160]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[160]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[160]]$sequence_id
#> [1] 1.758398e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[160]]$external_id
#> [1] "22"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[160]]$timestamp
#> [1] "1758398360"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[160]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[161]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[161]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[161]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[161]]$sequence_id
#> [1] 1.758398e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[161]]$external_id
#> [1] "21"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[161]]$timestamp
#> [1] "1758398329"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[161]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[162]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[162]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[162]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[162]]$sequence_id
#> [1] 1.758398e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[162]]$external_id
#> [1] "20"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[162]]$timestamp
#> [1] "1758398290"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[162]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[163]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[163]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[163]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[163]]$sequence_id
#> [1] 1.758398e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[163]]$external_id
#> [1] "19"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[163]]$timestamp
#> [1] "1758398252"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[163]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[164]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[164]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[164]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[164]]$sequence_id
#> [1] 1.758398e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[164]]$external_id
#> [1] "18"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[164]]$timestamp
#> [1] "1758398218"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[164]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[165]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[165]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[165]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[165]]$sequence_id
#> [1] 1.758398e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[165]]$external_id
#> [1] "17"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[165]]$timestamp
#> [1] "1758398024"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[165]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[166]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[166]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[166]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[166]]$sequence_id
#> [1] 1.758398e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[166]]$external_id
#> [1] "16"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[166]]$timestamp
#> [1] "1758397981"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[166]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[167]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[167]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[167]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[167]]$sequence_id
#> [1] 1.758398e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[167]]$external_id
#> [1] "15"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[167]]$timestamp
#> [1] "1758397940"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[167]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[168]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[168]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[168]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[168]]$sequence_id
#> [1] 1.758398e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[168]]$external_id
#> [1] "14"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[168]]$timestamp
#> [1] "1758397893"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[168]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[169]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[169]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[169]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[169]]$sequence_id
#> [1] 1.758398e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[169]]$external_id
#> [1] "13"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[169]]$timestamp
#> [1] "1758397857"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[169]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[170]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[170]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[170]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[170]]$sequence_id
#> [1] 1.758398e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[170]]$external_id
#> [1] "12"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[170]]$timestamp
#> [1] "1758397635"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[170]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[171]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[171]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[171]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[171]]$sequence_id
#> [1] 1.758398e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[171]]$external_id
#> [1] "11"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[171]]$timestamp
#> [1] "1758397601"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[171]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[172]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[172]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[172]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[172]]$sequence_id
#> [1] 1.758398e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[172]]$external_id
#> [1] "10"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[172]]$timestamp
#> [1] "1758397555"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[172]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[173]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[173]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[173]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[173]]$sequence_id
#> [1] 1.758398e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[173]]$external_id
#> [1] "9"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[173]]$timestamp
#> [1] "1758397529"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[173]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[174]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[174]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[174]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[174]]$sequence_id
#> [1] 1.758397e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[174]]$external_id
#> [1] "8"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[174]]$timestamp
#> [1] "1758397491"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[174]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[175]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[175]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[175]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[175]]$sequence_id
#> [1] 1.758397e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[175]]$external_id
#> [1] "7"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[175]]$timestamp
#> [1] "1758397456"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[175]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[176]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[176]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[176]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[176]]$sequence_id
#> [1] 1.758397e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[176]]$external_id
#> [1] "6"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[176]]$timestamp
#> [1] "1758397430"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[176]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[177]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[177]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[177]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[177]]$sequence_id
#> [1] 1.758397e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[177]]$external_id
#> [1] "5"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[177]]$timestamp
#> [1] "1758397391"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[177]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[178]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[178]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[178]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[178]]$sequence_id
#> [1] 1.758397e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[178]]$external_id
#> [1] "4"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[178]]$timestamp
#> [1] "1758397343"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[178]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[179]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[179]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[179]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[179]]$sequence_id
#> [1] 1.758397e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[179]]$external_id
#> [1] "3"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[179]]$timestamp
#> [1] "1758397318"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[179]]$official
#> [1] TRUE
#> 
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[180]]
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[180]]$media_type
#> [1] "play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[180]]$media_source
#> [1] "play_by_play"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[180]]$sequence_id
#> [1] 1.758397e+13
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[180]]$external_id
#> [1] "2"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[180]]$timestamp
#> [1] "1758397266"
#> 
#> $service$boxscore$gamemedia_stream$ncaaf.g.202509200023[[180]]$official
#> [1] TRUE
#> 
#> 
#> 
#> 
#> $service$boxscore$gamedrives
#> $service$boxscore$gamedrives$ncaaf.g.202509200023
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[1]]
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[1]]$id
#> [1] "1"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[1]]$team
#> [1] "23"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[1]]$time
#> [1] "3:50"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[1]]$num_plays
#> [1] "10"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[1]]$yards_covered
#> [1] "70"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[1]]$start_yardline
#> [1] "75"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[1]]$yardline_text
#> [1] "NEB 25"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[1]]$plays
#> [1] "2,3,4,5,6,7,8,9,10,11,12"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[1]]$result
#> [1] "Downs"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[1]]$start_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[1]]$start_time$clock
#> [1] "15:00"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[1]]$start_time$period
#> [1] "1"
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[1]]$end_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[1]]$end_time$clock
#> [1] "11:10"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[1]]$end_time$period
#> [1] 1
#> 
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[2]]
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[2]]$id
#> [1] "2"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[2]]$team
#> [1] "29"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[2]]$time
#> [1] "2:26"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[2]]$num_plays
#> [1] "3"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[2]]$yards_covered
#> [1] "8"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[2]]$start_yardline
#> [1] "95"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[2]]$yardline_text
#> [1] "MICH 5"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[2]]$plays
#> [1] "13,14,15,16,17"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[2]]$result
#> [1] "Punt"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[2]]$start_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[2]]$start_time$clock
#> [1] "11:10"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[2]]$start_time$period
#> [1] "1"
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[2]]$end_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[2]]$end_time$clock
#> [1] "8:44"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[2]]$end_time$period
#> [1] 1
#> 
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[3]]
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[3]]$id
#> [1] "3"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[3]]$team
#> [1] "23"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[3]]$time
#> [1] "3:44"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[3]]$num_plays
#> [1] "7"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[3]]$yards_covered
#> [1] "11"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[3]]$start_yardline
#> [1] "37"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[3]]$yardline_text
#> [1] "MICH 37"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[3]]$plays
#> [1] "18,19,20,21,22,23,24"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[3]]$result
#> [1] "FG Miss"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[3]]$start_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[3]]$start_time$clock
#> [1] "8:44"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[3]]$start_time$period
#> [1] "1"
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[3]]$end_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[3]]$end_time$clock
#> [1] "5:00"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[3]]$end_time$period
#> [1] 1
#> 
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[4]]
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[4]]$id
#> [1] "4"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[4]]$team
#> [1] "29"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[4]]$time
#> [1] "3:27"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[4]]$num_plays
#> [1] "10"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[4]]$yards_covered
#> [1] "46"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[4]]$start_yardline
#> [1] "74"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[4]]$yardline_text
#> [1] "MICH 26"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[4]]$plays
#> [1] "25,26,27,28,29,30,31,32,33,34"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[4]]$result
#> [1] "FG"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[4]]$start_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[4]]$start_time$clock
#> [1] "5:00"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[4]]$start_time$period
#> [1] "1"
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[4]]$end_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[4]]$end_time$clock
#> [1] "1:33"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[4]]$end_time$period
#> [1] 1
#> 
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[5]]
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[5]]$id
#> [1] "5"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[5]]$team
#> [1] "23"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[5]]$time
#> [1] "1:16"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[5]]$num_plays
#> [1] "3"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[5]]$yards_covered
#> [1] "11"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[5]]$start_yardline
#> [1] "77"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[5]]$yardline_text
#> [1] "NEB 23"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[5]]$plays
#> [1] "35,36,37,38"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[5]]$result
#> [1] "Int"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[5]]$start_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[5]]$start_time$clock
#> [1] "1:33"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[5]]$start_time$period
#> [1] "1"
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[5]]$end_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[5]]$end_time$clock
#> [1] "0:17"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[5]]$end_time$period
#> [1] 1
#> 
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[6]]
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[6]]$id
#> [1] "6"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[6]]$team
#> [1] "29"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[6]]$time
#> [1] "0:06"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[6]]$num_plays
#> [1] "1"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[6]]$yards_covered
#> [1] "37"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[6]]$start_yardline
#> [1] "37"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[6]]$yardline_text
#> [1] "NEB 37"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[6]]$plays
#> [1] "39,40"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[6]]$result
#> [1] "TD"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[6]]$start_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[6]]$start_time$clock
#> [1] "0:17"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[6]]$start_time$period
#> [1] "1"
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[6]]$end_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[6]]$end_time$clock
#> [1] "0:11"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[6]]$end_time$period
#> [1] 1
#> 
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[7]]
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[7]]$id
#> [1] "7"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[7]]$team
#> [1] "23"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[7]]$time
#> [1] "1:05"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[7]]$num_plays
#> [1] "3"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[7]]$yards_covered
#> [1] "-9"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[7]]$start_yardline
#> [1] "75"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[7]]$yardline_text
#> [1] "NEB 25"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[7]]$plays
#> [1] "41,42,43,44,46,47,48"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[7]]$result
#> [1] "Punt"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[7]]$start_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[7]]$start_time$clock
#> [1] "0:11"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[7]]$start_time$period
#> [1] "1"
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[7]]$end_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[7]]$end_time$clock
#> [1] "14:06"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[7]]$end_time$period
#> [1] 2
#> 
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[8]]
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[8]]$id
#> [1] "8"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[8]]$team
#> [1] "29"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[8]]$time
#> [1] "0:58"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[8]]$num_plays
#> [1] "3"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[8]]$yards_covered
#> [1] "15"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[8]]$start_yardline
#> [1] "63"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[8]]$yardline_text
#> [1] "MICH 37"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[8]]$plays
#> [1] "49,50,51"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[8]]$result
#> [1] "Fumble"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[8]]$start_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[8]]$start_time$clock
#> [1] "14:06"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[8]]$start_time$period
#> [1] "2"
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[8]]$end_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[8]]$end_time$clock
#> [1] "13:08"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[8]]$end_time$period
#> [1] 2
#> 
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[9]]
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[9]]$id
#> [1] "9"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[9]]$team
#> [1] "23"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[9]]$time
#> [1] "4:10"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[9]]$num_plays
#> [1] "7"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[9]]$yards_covered
#> [1] "31"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[9]]$start_yardline
#> [1] "52"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[9]]$yardline_text
#> [1] "NEB 48"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[9]]$plays
#> [1] "52,53,54,55,56,57,58,59"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[9]]$result
#> [1] "FG"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[9]]$start_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[9]]$start_time$clock
#> [1] "13:08"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[9]]$start_time$period
#> [1] "2"
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[9]]$end_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[9]]$end_time$clock
#> [1] "8:58"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[9]]$end_time$period
#> [1] 2
#> 
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[10]]
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[10]]$id
#> [1] "10"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[10]]$team
#> [1] "29"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[10]]$time
#> [1] "3:00"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[10]]$num_plays
#> [1] "4"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[10]]$yards_covered
#> [1] "9"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[10]]$start_yardline
#> [1] "75"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[10]]$yardline_text
#> [1] "MICH 25"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[10]]$plays
#> [1] "60,61,62,63,64,65"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[10]]$result
#> [1] "Punt"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[10]]$start_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[10]]$start_time$clock
#> [1] "8:58"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[10]]$start_time$period
#> [1] "2"
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[10]]$end_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[10]]$end_time$clock
#> [1] "5:58"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[10]]$end_time$period
#> [1] 2
#> 
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[11]]
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[11]]$id
#> [1] "11"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[11]]$team
#> [1] "23"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[11]]$time
#> [1] "3:57"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[11]]$num_plays
#> [1] "7"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[11]]$yards_covered
#> [1] "63"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[11]]$start_yardline
#> [1] "63"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[11]]$yardline_text
#> [1] "NEB 37"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[11]]$plays
#> [1] "66,67,68,69,70,71,72,73"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[11]]$result
#> [1] "TD"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[11]]$start_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[11]]$start_time$clock
#> [1] "5:58"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[11]]$start_time$period
#> [1] "2"
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[11]]$end_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[11]]$end_time$clock
#> [1] "2:01"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[11]]$end_time$period
#> [1] 2
#> 
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[12]]
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[12]]$id
#> [1] "12"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[12]]$team
#> [1] "29"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[12]]$time
#> [1] "0:10"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[12]]$num_plays
#> [1] "1"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[12]]$yards_covered
#> [1] "75"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[12]]$start_yardline
#> [1] "75"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[12]]$yardline_text
#> [1] "MICH 25"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[12]]$plays
#> [1] "74,75,76,77"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[12]]$result
#> [1] "TD"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[12]]$start_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[12]]$start_time$clock
#> [1] "2:01"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[12]]$start_time$period
#> [1] "2"
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[12]]$end_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[12]]$end_time$clock
#> [1] "1:51"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[12]]$end_time$period
#> [1] 2
#> 
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[13]]
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[13]]$id
#> [1] "13"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[13]]$team
#> [1] "23"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[13]]$time
#> [1] "1:51"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[13]]$num_plays
#> [1] "7"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[13]]$yards_covered
#> [1] "75"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[13]]$start_yardline
#> [1] "75"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[13]]$yardline_text
#> [1] "NEB 25"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[13]]$plays
#> [1] "78,79,80,81,82,83,84,85,86,87,88,89,90"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[13]]$result
#> [1] "End Half"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[13]]$start_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[13]]$start_time$clock
#> [1] "1:51"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[13]]$start_time$period
#> [1] "2"
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[13]]$end_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[13]]$end_time$clock
#> [1] "0:00"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[13]]$end_time$period
#> [1] 2
#> 
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[14]]
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[14]]$id
#> [1] "14"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[14]]$team
#> [1] "29"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[14]]$time
#> [1] "2:26"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[14]]$num_plays
#> [1] "4"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[14]]$yards_covered
#> [1] "22"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[14]]$start_yardline
#> [1] "75"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[14]]$yardline_text
#> [1] "MICH 25"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[14]]$plays
#> [1] "92,93,94,95,96,97"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[14]]$result
#> [1] "Punt"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[14]]$start_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[14]]$start_time$clock
#> [1] "15:00"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[14]]$start_time$period
#> [1] "3"
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[14]]$end_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[14]]$end_time$clock
#> [1] "12:34"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[14]]$end_time$period
#> [1] 3
#> 
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[15]]
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[15]]$id
#> [1] "15"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[15]]$team
#> [1] "23"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[15]]$time
#> [1] "2:19"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[15]]$num_plays
#> [1] "3"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[15]]$yards_covered
#> [1] "5"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[15]]$start_yardline
#> [1] "97"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[15]]$yardline_text
#> [1] "NEB 3"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[15]]$plays
#> [1] "98,99,100,101,102"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[15]]$result
#> [1] "Punt"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[15]]$start_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[15]]$start_time$clock
#> [1] "12:34"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[15]]$start_time$period
#> [1] "3"
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[15]]$end_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[15]]$end_time$clock
#> [1] "10:15"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[15]]$end_time$period
#> [1] 3
#> 
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[16]]
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[16]]$id
#> [1] "16"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[16]]$team
#> [1] "29"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[16]]$time
#> [1] "2:32"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[16]]$num_plays
#> [1] "8"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[16]]$yards_covered
#> [1] "22"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[16]]$start_yardline
#> [1] "60"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[16]]$yardline_text
#> [1] "MICH 40"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[16]]$plays
#> [1] "103,104,105,106,107,108,109,110"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[16]]$result
#> [1] "FG"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[16]]$start_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[16]]$start_time$clock
#> [1] "10:15"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[16]]$start_time$period
#> [1] "3"
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[16]]$end_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[16]]$end_time$clock
#> [1] "7:43"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[16]]$end_time$period
#> [1] 3
#> 
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[17]]
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[17]]$id
#> [1] "17"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[17]]$team
#> [1] "23"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[17]]$time
#> [1] "1:31"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[17]]$num_plays
#> [1] "3"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[17]]$yards_covered
#> [1] "-6"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[17]]$start_yardline
#> [1] "75"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[17]]$yardline_text
#> [1] "NEB 25"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[17]]$plays
#> [1] "111,112,113,114,115"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[17]]$result
#> [1] "Punt"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[17]]$start_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[17]]$start_time$clock
#> [1] "7:43"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[17]]$start_time$period
#> [1] "3"
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[17]]$end_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[17]]$end_time$clock
#> [1] "6:12"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[17]]$end_time$period
#> [1] 3
#> 
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[18]]
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[18]]$id
#> [1] "18"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[18]]$team
#> [1] "29"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[18]]$time
#> [1] "0:32"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[18]]$num_plays
#> [1] "2"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[18]]$yards_covered
#> [1] "62"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[18]]$start_yardline
#> [1] "62"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[18]]$yardline_text
#> [1] "MICH 38"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[18]]$plays
#> [1] "116,117,118"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[18]]$result
#> [1] "TD"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[18]]$start_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[18]]$start_time$clock
#> [1] "6:12"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[18]]$start_time$period
#> [1] "3"
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[18]]$end_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[18]]$end_time$clock
#> [1] "5:40"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[18]]$end_time$period
#> [1] 3
#> 
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[19]]
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[19]]$id
#> [1] "19"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[19]]$team
#> [1] "23"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[19]]$time
#> [1] "5:44"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[19]]$num_plays
#> [1] "13"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[19]]$yards_covered
#> [1] "75"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[19]]$start_yardline
#> [1] "75"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[19]]$yardline_text
#> [1] "NEB 25"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[19]]$plays
#> [1] "119,120,121,122,123,124,125,126,127,128,129,130,131,132,134"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[19]]$result
#> [1] "FG"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[19]]$start_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[19]]$start_time$clock
#> [1] "5:40"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[19]]$start_time$period
#> [1] "3"
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[19]]$end_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[19]]$end_time$clock
#> [1] "14:56"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[19]]$end_time$period
#> [1] 4
#> 
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[20]]
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[20]]$id
#> [1] "20"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[20]]$team
#> [1] "29"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[20]]$time
#> [1] "0:51"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[20]]$num_plays
#> [1] "3"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[20]]$yards_covered
#> [1] "6"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[20]]$start_yardline
#> [1] "75"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[20]]$yardline_text
#> [1] "MICH 25"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[20]]$plays
#> [1] "135,136,137,138,139"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[20]]$result
#> [1] "Punt"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[20]]$start_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[20]]$start_time$clock
#> [1] "14:56"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[20]]$start_time$period
#> [1] "4"
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[20]]$end_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[20]]$end_time$clock
#> [1] "14:05"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[20]]$end_time$period
#> [1] 4
#> 
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[21]]
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[21]]$id
#> [1] "21"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[21]]$team
#> [1] "23"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[21]]$time
#> [1] "1:25"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[21]]$num_plays
#> [1] "3"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[21]]$yards_covered
#> [1] "-5"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[21]]$start_yardline
#> [1] "71"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[21]]$yardline_text
#> [1] "NEB 29"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[21]]$plays
#> [1] "140,141,142,143"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[21]]$result
#> [1] "Punt"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[21]]$start_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[21]]$start_time$clock
#> [1] "14:05"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[21]]$start_time$period
#> [1] "4"
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[21]]$end_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[21]]$end_time$clock
#> [1] "12:40"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[21]]$end_time$period
#> [1] 4
#> 
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[22]]
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[22]]$id
#> [1] "22"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[22]]$team
#> [1] "29"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[22]]$time
#> [1] "8:46"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[22]]$num_plays
#> [1] "16"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[22]]$yards_covered
#> [1] "77"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[22]]$start_yardline
#> [1] "80"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[22]]$yardline_text
#> [1] "MICH 20"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[22]]$plays
#> [1] "144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[22]]$result
#> [1] "FG"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[22]]$start_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[22]]$start_time$clock
#> [1] "12:40"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[22]]$start_time$period
#> [1] "4"
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[22]]$end_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[22]]$end_time$clock
#> [1] "3:54"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[22]]$end_time$period
#> [1] 4
#> 
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[23]]
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[23]]$id
#> [1] "23"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[23]]$team
#> [1] "23"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[23]]$time
#> [1] "2:21"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[23]]$num_plays
#> [1] "10"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[23]]$yards_covered
#> [1] "75"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[23]]$start_yardline
#> [1] "75"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[23]]$yardline_text
#> [1] "NEB 25"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[23]]$plays
#> [1] "161,162,163,164,165,166,167,168,169,170,171,172,173,174,175"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[23]]$result
#> [1] "TD"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[23]]$start_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[23]]$start_time$clock
#> [1] "3:54"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[23]]$start_time$period
#> [1] "4"
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[23]]$end_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[23]]$end_time$clock
#> [1] "1:33"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[23]]$end_time$period
#> [1] 4
#> 
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[24]]
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[24]]$id
#> [1] "24"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[24]]$team
#> [1] "29"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[24]]$time
#> [1] "1:33"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[24]]$num_plays
#> [1] "4"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[24]]$yards_covered
#> [1] "7"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[24]]$start_yardline
#> [1] "45"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[24]]$yardline_text
#> [1] "NEB 45"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[24]]$plays
#> [1] "176,177,178,179,180,181,182,183,184"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[24]]$result
#> [1] "End Reg"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[24]]$start_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[24]]$start_time$clock
#> [1] "1:33"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[24]]$start_time$period
#> [1] "4"
#> 
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[24]]$end_time
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[24]]$end_time$clock
#> [1] "0:00"
#> 
#> $service$boxscore$gamedrives$ncaaf.g.202509200023[[24]]$end_time$period
#> [1] 4
#> 
#> 
#> 
#> 
#> 
#> $service$boxscore$gamelineups
#> $service$boxscore$gamelineups$ncaaf.g.202509200023
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.457863
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.457863$player_id
#> [1] "ncaaf.p.457863"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.333433
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.333433$player_id
#> [1] "ncaaf.p.333433"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.461405
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.461405$player_id
#> [1] "ncaaf.p.461405"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.457834
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.457834$player_id
#> [1] "ncaaf.p.457834"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.469568
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.469568$player_id
#> [1] "ncaaf.p.469568"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.333434
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.333434$player_id
#> [1] "ncaaf.p.333434"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.333286
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.333286$player_id
#> [1] "ncaaf.p.333286"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.404124
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.404124$player_id
#> [1] "ncaaf.p.404124"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.322801
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.322801$player_id
#> [1] "ncaaf.p.322801"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.457875
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.457875$player_id
#> [1] "ncaaf.p.457875"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.469559
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.469559$player_id
#> [1] "ncaaf.p.469559"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.322827
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.322827$player_id
#> [1] "ncaaf.p.322827"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.451229
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.451229$player_id
#> [1] "ncaaf.p.451229"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.471801
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.471801$player_id
#> [1] "ncaaf.p.471801"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.299700
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.299700$player_id
#> [1] "ncaaf.p.299700"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.322308
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.322308$player_id
#> [1] "ncaaf.p.322308"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.322802
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.322802$player_id
#> [1] "ncaaf.p.322802"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.333347
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.333347$player_id
#> [1] "ncaaf.p.333347"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.334637
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.334637$player_id
#> [1] "ncaaf.p.334637"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.404052
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.404052$player_id
#> [1] "ncaaf.p.404052"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.406379
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.406379$player_id
#> [1] "ncaaf.p.406379"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.457838
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.457838$player_id
#> [1] "ncaaf.p.457838"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.457853
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.457853$player_id
#> [1] "ncaaf.p.457853"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.457880
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.457880$player_id
#> [1] "ncaaf.p.457880"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.461399
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup$all$ncaaf.p.461399$player_id
#> [1] "ncaaf.p.461399"
#> 
#> 
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$home_lineup_order
#> list()
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.469436
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.469436$player_id
#> [1] "ncaaf.p.469436"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.403962
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.403962$player_id
#> [1] "ncaaf.p.403962"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.404392
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.404392$player_id
#> [1] "ncaaf.p.404392"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.457591
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.457591$player_id
#> [1] "ncaaf.p.457591"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.323602
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.323602$player_id
#> [1] "ncaaf.p.323602"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.340496
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.340496$player_id
#> [1] "ncaaf.p.340496"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.403924
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.403924$player_id
#> [1] "ncaaf.p.403924"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.457613
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.457613$player_id
#> [1] "ncaaf.p.457613"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.333922
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.333922$player_id
#> [1] "ncaaf.p.333922"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.404008
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.404008$player_id
#> [1] "ncaaf.p.404008"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.338368
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.338368$player_id
#> [1] "ncaaf.p.338368"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.457602
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.457602$player_id
#> [1] "ncaaf.p.457602"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.327406
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.327406$player_id
#> [1] "ncaaf.p.327406"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.327412
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.327412$player_id
#> [1] "ncaaf.p.327412"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.327421
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.327421$player_id
#> [1] "ncaaf.p.327421"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.333312
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.333312$player_id
#> [1] "ncaaf.p.333312"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.333324
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.333324$player_id
#> [1] "ncaaf.p.333324"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.333423
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.333423$player_id
#> [1] "ncaaf.p.333423"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.340505
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.340505$player_id
#> [1] "ncaaf.p.340505"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.403634
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.403634$player_id
#> [1] "ncaaf.p.403634"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.403958
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.403958$player_id
#> [1] "ncaaf.p.403958"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.404304
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.404304$player_id
#> [1] "ncaaf.p.404304"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.405415
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.405415$player_id
#> [1] "ncaaf.p.405415"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.405652
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.405652$player_id
#> [1] "ncaaf.p.405652"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.451303
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.451303$player_id
#> [1] "ncaaf.p.451303"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.457606
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.457606$player_id
#> [1] "ncaaf.p.457606"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.474363
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.474363$player_id
#> [1] "ncaaf.p.474363"
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.474366
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup$all$ncaaf.p.474366$player_id
#> [1] "ncaaf.p.474366"
#> 
#> 
#> 
#> 
#> $service$boxscore$gamelineups$ncaaf.g.202509200023$away_lineup_order
#> list()
#> 
#> 
#> 
#> $service$boxscore$gamegame_details
#> $service$boxscore$gamegame_details$ncaaf.g.202509200023
#> list()
#> 
#> 
#> $service$boxscore$gamesection_notes
#> $service$boxscore$gamesection_notes$ncaaf.g.202509200023
#> list()
#> 
#> 
#> 
#> 
# }
```
