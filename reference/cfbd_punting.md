# **CFBD Punting Endpoint Overview**

- [`cfbd_punting_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting_players_season.md):
  Get player season punting and punt return production.

- [`cfbd_punting_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting_players_games.md):
  Get player game punting and punt return production.

- [`cfbd_punting_teams_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting_teams_season.md):
  Get team season punting production, kicking and receiving.

- [`cfbd_punting_teams_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting_teams_games.md):
  Get team game punting production, kicking and receiving.

- [`cfbd_punting_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_punting_plays.md):
  Get individual punt plays with yardage, field position and outcome.

## Details

### **Get player season punting production**

      cfbd_punting_players_season(year = 2025, team = "Texas")

### **Get player game punting production**

      cfbd_punting_players_games(year = 2025, week = 5)

### **Get team season punting production**

      cfbd_punting_teams_season(year = 2025, team = "Texas")

### **Get team game punting production**

      cfbd_punting_teams_games(year = 2025, week = 5)

### **Get individual punt plays**

      cfbd_punting_plays(year = 2025, week = 1, team = "Texas")

## The player punting and return blocks

The two player endpoints carry a 15-column punting block, prefixed
`punting_` (e.g. `punting_net_yards_per_punt`), and a 10-column punt
return block, prefixed `returning_`. A player who only punted has `NA`
return columns, and the reverse.

The punting block:

|  |  |  |
|----|----|----|
| col_name | type | description |
| punts | integer | Punts. |
| punt_yards_available | integer | Punts with known gross yards (the denominator for `yards_per_punt`). |
| punt_yards | integer | Gross punt yards over those punts. |
| yards_per_punt | double | Gross yards per punt. |
| longest_punt | integer | Longest punt, in gross yards. |
| punts50plus | integer | Punts of 50 or more gross yards. |
| net_punt_yards_available | integer | Punts with known net yards (the denominator for `net_yards_per_punt`). |
| net_punt_yards | integer | Net punt yards over those punts: gross yards minus return yards, less 20 for a touchback. |
| net_yards_per_punt | double | Net yards per punt. |
| touchbacks | integer | Punts that ended in a touchback. |
| fair_catches | integer | Punts fair caught. |
| out_of_bounds | integer | Punts that went out of bounds. |
| downed | integer | Punts downed by the kicking team. |
| inside20 | integer | Punts after which the receiving team took possession inside its own 20, excluding touchbacks. |
| blocked | integer | Punts blocked. |

The return block:

|  |  |  |
|----|----|----|
| col_name | type | description |
| returns | integer | Punt returns. |
| return_yards_available | integer | Returns with known yards (the denominator for `yards_per_return`). |
| return_yards | integer | Return yards over those returns. |
| yards_per_return | double | Yards per return. |
| longest_return | integer | Longest return, in yards. |
| returns20plus | integer | Returns of 20 or more yards. |
| return_touchdowns | integer | Returns for a touchdown. |
| fair_catches | integer | Fair catches made. |
| muffs | integer | Muffed punts. |
| blocks | integer | Punts blocked by the player. |

## The team punting block

The two team endpoints carry one 24-column block twice: `punting_*`
covers the team's own punts (so `punting_return_yards` is what opponents
returned against it) and `returning_*` covers the punts it received (so
`returning_punts` counts opponent punts and `returning_return_yards` is
the team's own return yardage). In a game frame, one side's `punting_*`
row matches its opponent's `returning_*` row.

The block is the first 15 columns of the player punting block above,
then:

|  |  |  |
|----|----|----|
| col_name | type | description |
| returns | integer | Punt returns. |
| return_yards_available | integer | Returns with known yards (the denominator for `yards_per_return`). |
| return_yards | integer | Return yards over those returns. |
| yards_per_return | double | Yards per return. |
| longest_return | integer | Longest return, in yards. |
| returns20plus | integer | Returns of 20 or more yards. |
| return_touchdowns | integer | Returns for a touchdown. |
| muffs | integer | Muffed punts. |
| receiving_team_turnovers | integer | Punts on which the receiving team lost possession, such as on a muff or fumble. |

The `*_available` counts are denominators, not statistics. CFBD parses
these fields out of play text, so a punt can be counted while its
yardage stays unknown. Dividing by `punts` or `returns` instead of the
matching `*_available` column understates every mean.

## Season coverage

Unlike the passing and rushing families, these endpoints reach back to
**2015**. Earlier seasons answer HTTP 200 with an empty array rather
than an error, so a request for 2014 returns an empty data frame, not a
failure.
