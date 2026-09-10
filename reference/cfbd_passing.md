# **CFBD Passing Endpoint Overview**

- [`cfbd_passing_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_players_season.md):
  Get player season passing production, split by pass location.

- [`cfbd_passing_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_players_games.md):
  Get player game passing production, split by pass location.

- [`cfbd_passing_teams_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_teams_season.md):
  Get team season passing production for and against, split by pass
  location.

- [`cfbd_passing_teams_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_teams_games.md):
  Get team game passing production for and against, split by pass
  location.

- [`cfbd_passing_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_passing_plays.md):
  Get individual passing plays with air yards, YAC and location detail.

## Details

### **Get player season passing production**

      cfbd_passing_players_season(year = 2025, team = "Texas")

### **Get player game passing production**

      cfbd_passing_players_games(year = 2025, week = 5)

### **Get team season passing production**

      cfbd_passing_teams_season(year = 2025, team = "Texas")

### **Get team game passing production**

      cfbd_passing_teams_games(year = 2025, week = 5)

### **Get individual passing plays**

      cfbd_passing_plays(year = 2025, week = 5, team = "Texas")

## The passing production block

Every passing endpoint below shares one 23-column production block. It
is documented once here rather than repeated in each returns table,
because the team endpoints carry it sixteen times over (see *Location
splits*).

|  |  |  |
|----|----|----|
| col_name | types | description |
| attempts | integer | Pass attempts. |
| completions | integer | Completed passes. |
| incompletions | integer | Incomplete passes. |
| interceptions | integer | Passes intercepted. |
| completion_rate | numeric | Completions divided by attempts (proportion 0-1). |
| air_yards_attempts_available | integer | Attempts for which air yards were parsed (the denominator for air-yard means). |
| total_air_yards | integer | Sum of air yards over `air_yards_attempts_available` attempts. |
| average_depth_of_target | numeric | Mean air yards per attempt (aDOT). |
| total_yards_attempts_available | integer | Attempts for which total yards were parsed. |
| total_yards | integer | Sum of passing yards over those attempts. |
| yards_after_catch_attempts_available | integer | Attempts for which yards after catch were parsed. |
| total_yards_after_catch | integer | Sum of yards after catch over those attempts. |
| average_yards_after_catch | numeric | Mean yards after catch per completion. |
| success_rate | numeric | Successful attempts divided by `success_attempts_available` (proportion 0-1). |
| ppa | numeric | Predicted points added per attempt. |
| total_ppa | numeric | Sum of predicted points added. |
| explosiveness | numeric | Mean PPA on successful attempts. |
| ppa_attempts_available | integer | Attempts carrying a PPA value (the denominator for `ppa`). |
| success_attempts_available | integer | Attempts eligible for the success calculation. |
| successful_attempts | integer | Attempts meeting the success threshold. |
| successful_ppa_attempts_available | integer | Successful attempts carrying a PPA value (the denominator for `explosiveness`). |
| location_eligible_attempts | integer | Attempts eligible for a location split. |
| location_available_attempts | integer | Attempts for which a location was actually parsed. |

The `*_available` counts are denominators, not statistics. CFBD parses
these fields out of play text, so an attempt can be counted while its
air yards, YAC or location stay unknown. Dividing by `attempts` instead
of the matching `*_available` column understates every mean.

## Location splits

The same block repeats for each of seven pass locations, prefixed
`locations_<bucket>_`:

- `short_left`, `short_middle`, `short_right`

- `deep_left`, `deep_middle`, `deep_right`

- `unknown` – location could not be parsed from the play text

All seven buckets are always present, including empty ones. So a player
frame is 5 identity columns + 23 production + 7 x 23 location = **189
columns**, and a team frame doubles the production and location blocks
across `offense_` and `defense_` for **371**.

## Season coverage

These endpoints are **2025 onward**. Earlier seasons answer HTTP 200
with an empty array rather than an error, so a request for 2024 returns
an empty data frame, not a failure.
