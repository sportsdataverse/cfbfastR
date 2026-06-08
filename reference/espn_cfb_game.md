# **ESPN College Football Game Endpoint Overview**

- [`espn_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp.md):
  Get ESPN college football PBP data (legacy site-v2).

- [`espn_cfb_pbp_v2()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp_v2.md):
  Get ESPN College Football Play-by-Play (core-v2) – core-v2-sourced
  successor to
  [`espn_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp.md)
  with optional EPA/WPA modeling.

- [`espn_cfb_unnest_plays()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_unnest_plays.md):
  Turn an
  [`espn_cfb_game_drives()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_drives.md)
  result with a `plays` list-column into a flat one-row-per-play table.

- [`espn_cfb_game_broadcasts()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_broadcasts.md):
  Get the broadcast / streaming outlets carrying a single college
  football game.

- [`espn_cfb_game_drive_plays()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_drive_plays.md):
  Get the play-by-play for a single drive of a college football game –
  one row per play, scoped to one drive.

- [`espn_cfb_game_drives()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_drives.md):
  Get the per-game drive log for a single college football game – one
  row per drive.

- [`espn_cfb_game_leaders()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_leaders.md):
  Get the per-game statistical leaders for a single college football
  game – one row per leader within each statistical category.

- [`espn_cfb_game_odds()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_odds.md):
  Get the sportsbook betting lines (spread, over/under, moneyline) for a
  single college football game – one row per provider.

- [`espn_cfb_game_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_pbp.md):
  Get the full core-v2 play-by-play feed for a single college football
  game – one row per play.

- [`espn_cfb_game_play()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_play.md):
  Get the full detail object for a single play of a college football
  game.

- [`espn_cfb_game_player_box()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_player_box.md):
  Get the full per-player box score for both teams in a single college
  football game, in long format.

- [`espn_cfb_game_player_statistics()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_player_statistics.md):
  Get one athlete's box-score line for a single college football game –
  one row per stat, in long format.

- [`espn_cfb_game_powerindex()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_powerindex.md):
  Get ESPN's Football Power Index (FPI) matchup projections for both
  teams in a single college football game.

- [`espn_cfb_game_predictor()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_predictor.md):
  Get ESPN's pre-game matchup predictor (FPI game projection) for a
  single college football game.

- [`espn_cfb_game_probabilities()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_probabilities.md):
  Get ESPN's play-by-play win-probability series for a single college
  football game.

- [`espn_cfb_game_situation()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_situation.md):
  Get the current (or final) game situation for a single college
  football game – down, distance, yard line, red-zone flag, timeouts.

- [`espn_cfb_game_status()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_status.md):
  Get the competition status for a single college football game – clock,
  period, and the status type/state.

- [`espn_cfb_game_team_leaders()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_leaders.md):
  Get each team's statistical leaders (passing, rushing, receiving, ...)
  for a single college football game.

- [`espn_cfb_game_team_linescores()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_linescores.md):
  Get the quarter-by-quarter linescores for both teams in a single
  college football game.

- [`espn_cfb_game_team_records()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_records.md):
  Get each team's win-loss records (overall, home, road, conference) as
  they stood at the time of a single college football game.

- [`espn_cfb_game_team_roster()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_roster.md):
  Get the game-day roster for both teams in a single college football
  game.

- [`espn_cfb_game_team_statistics()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_statistics.md):
  Get the full team box-score statistics for both teams in a single
  college football game, in long format.

- [`espn_cfb_game_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_teams.md):
  Get the two teams (home and away) for a single college football game.

## Details

### **Get ESPN college football PBP data (legacy)**

    espn_cfb_pbp(game_id = 401282614, epa_wpa = TRUE)

### **Get ESPN College Football Play-by-Play (core-v2)**

    espn_cfb_pbp_v2(game_id = 401628339, epa_wpa = TRUE)

### **Unnest ESPN CFB drive plays into a flat play-by-play table**

    espn_cfb_unnest_plays(espn_cfb_game_drives(401628339, plays = "list"))

### **ESPN College Football Game Broadcasts**

    espn_cfb_game_broadcasts(game_id = 401628339)

### **ESPN College Football Game Drive Plays**

    espn_cfb_game_drive_plays(game_id = 401628339, drive_id = 4016283391)

### **ESPN College Football Game Drives**

    espn_cfb_game_drives(game_id = 401628339)
    espn_cfb_game_drives(game_id = 401628339, plays = "expand")

### **ESPN College Football Game Leaders**

    espn_cfb_game_leaders(game_id = 401628339)

### **ESPN College Football Game Odds**

    espn_cfb_game_odds(game_id = 401628339)
    espn_cfb_game_odds(game_id = 401628339, line_history = TRUE)

### **ESPN College Football Game Plays (Core-v2 Play-by-Play)**

    espn_cfb_game_pbp(game_id = 401628339)
    espn_cfb_game_pbp(game_id = 401628339, participants = "wide")

### **ESPN College Football Game Play (Single Play Detail)**

    espn_cfb_game_play(game_id = 401628339, play_id = "401628339101927401")

### **ESPN College Football Game Player Box Score**

    espn_cfb_game_player_box(game_id = 401628339)

### **ESPN College Football Game Player Statistics (Single Athlete)**

    espn_cfb_game_player_statistics(game_id = 401628339, athlete_id = 4429105)

### **ESPN College Football Game Power Index (Matchup FPI)**

    espn_cfb_game_powerindex(game_id = 401628339)

### **ESPN College Football Game Predictor (BPI Matchup Predictor)**

    espn_cfb_game_predictor(game_id = 401628339)

### **ESPN College Football Game Win Probabilities**

    espn_cfb_game_probabilities(game_id = 401628339)

### **ESPN College Football Game Situation**

    espn_cfb_game_situation(game_id = 401628339)

### **ESPN College Football Game Status**

    espn_cfb_game_status(game_id = 401628339)

### **ESPN College Football Game Team Leaders**

    espn_cfb_game_team_leaders(game_id = 401628339)

### **ESPN College Football Game Team Linescores**

    espn_cfb_game_team_linescores(game_id = 401628339)

### **ESPN College Football Game Team Records**

    espn_cfb_game_team_records(game_id = 401628339)
    espn_cfb_game_team_records(game_id = 401628339, detail = TRUE)

### **ESPN College Football Game Team Roster**

    espn_cfb_game_team_roster(game_id = 401628339)

### **ESPN College Football Game Team Statistics**

    espn_cfb_game_team_statistics(game_id = 401628339)

### **ESPN College Football Game Teams**

    espn_cfb_game_teams(game_id = 401628339)
    espn_cfb_game_teams(game_id = 401628339, format = "wide")
