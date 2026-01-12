# **CFBD Games Endpoint Overview**

Get results, statistics and information for games

- [`cfbd_game_box_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_box_advanced.md)::

  Get game advanced box score information.

- [`cfbd_game_player_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_player_stats.md)::

  Get results information from games.

- [`cfbd_game_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.md)::

  Get team statistics by game.

- [`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md)::

  Get results information from games.

- [`cfbd_live_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_scoreboard.md)::

  Get live scoreboard information.

- [`cfbd_game_weather()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_weather.md)::

  Get weather from games.

- [`cfbd_game_records()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_records.md)::

  Get team records by year.

- [`cfbd_calendar()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_calendar.md)::

  Get calendar of weeks by season.

- [`cfbd_game_media()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_media.md)::

  Get game media information (TV, radio, etc).

## Details

### **Get game advanced box score information.**

    cfbd_game_box_advanced(game_id = 401114233)

### **Get player statistics by game**

    cfbd_game_player_stats(2018, week = 15, conference = "Ind")

    cfbd_game_player_stats(2013, week = 1, team = "Florida State", category = "passing")

### **Get team records by year**

    cfbd_game_records(2018, team = "Notre Dame")

    cfbd_game_records(2013, team = "Florida State")

### **Get team statistics by game**

    cfbd_game_team_stats(2019, team = "LSU")

    cfbd_game_team_stats(2013, team = "Florida State")

### **Get results information from games.**

    cfbd_game_info(2018, week = 1)

    cfbd_game_info(2018, week = 7, conference = "Ind")

    # 7 OTs LSU @ TAMU
    cfbd_game_info(2018, week = 13, team = "Texas A&M", quarter_scores = TRUE)

### **Get weather from games.**

    cfbd_game_weather(2018, week = 1)

    cfbd_game_info(2018, week = 7, conference = "Ind")

### **Get calendar of weeks by season.**

    cfbd_calendar(2019)

### **Get game media information (TV, radio, etc).**

    cfbd_game_media(2019, week = 4, conference = "ACC")
