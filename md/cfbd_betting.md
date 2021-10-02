---
title: cfbd_betting
description: list("Get betting lines information for games") list(list("html"), list(list("<div class=\"r\">"))) list(" cfbd_betting_lines(year = 2018, week = 12, team = \"Florida State\")\n", "\n", " # 7 OTs LSU at TAMU\n", " cfbd_betting_lines(year = 2018, week = 13, team = \"Texas A&M\", conference = \"SEC\")\n") list(list("html"), list(list("</div>")))
featured: true
topics: Betting
recommended: null
---
# `cfbd_betting`

CFBD Betting Lines Endpoint Overview


## Description

list("Get betting lines information for games") list(list("html"), list(list("<div class=\"r\">"))) list(" cfbd_betting_lines(year = 2018, week = 12, team = \"Florida State\")\n", "\n", " # 7 OTs LSU at TAMU\n", " cfbd_betting_lines(year = 2018, week = 13, team = \"Texas A&M\", conference = \"SEC\")\n") list(list("html"), list(list("</div>")))


## Usage

```r
cfbd_betting_lines(
  game_id = NULL,
  year = NULL,
  week = NULL,
  season_type = "regular",
  team = NULL,
  home_team = NULL,
  away_team = NULL,
  conference = NULL,
  line_provider = NULL,
  verbose = FALSE
)
```


## Arguments

Argument      |Description
------------- |----------------
`game_id`     |     ( Integer optional): Game ID filter for querying a single game Can be found using the [`cfbd_game_info()`](#cfbdgameinfo()) function
`year`     |     ( Integer required): Year, 4 digit format( YYYY )
`week`     |     ( Integer optional): Week - values from 1-15, 1-14 for seasons pre-playoff (i.e. 2013 or earlier)
`season_type`     |     ( String default regular): Select Season Type: regular or postseason
`team`     |     ( String optional): D-I Team
`home_team`     |     ( String optional): Home D-I Team
`away_team`     |     ( String optional): Away D-I Team
`conference`     |     ( list("String") optional): Conference abbreviation - Select a valid FBS conference list()  Conference abbreviations P5: ACC, B12, B1G, SEC, PAC list()  Conference abbreviations G5 and FBS Independents: CUSA, MAC, MWC, Ind, SBC, AAC
`line_provider`     |     ( String optional): Select Line Provider - Caesars, consensus, numberfire, or teamrankings
`verbose`     |     Logical parameter (TRUE/FALSE, default: FALSE) to return warnings and messages from function


## Value

Column      |Description
------------- |----------------
``     |     


## Examples

```r
cfbd_betting_lines(year = 2018, week = 12, team = "Florida State")

# 7 OTs LSU at TAMU
cfbd_betting_lines(year = 2018, week = 13, team = "Texas A&M", conference = "SEC")
```


