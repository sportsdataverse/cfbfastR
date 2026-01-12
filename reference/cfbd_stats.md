# **CFBD Stats Endpoint Overview**

- [`cfbd_stats_categories()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_categories.md)::

  Get college football mapping for stats categories.

- [`cfbd_stats_season_team()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_team.md)::

  Get season statistics by team.

- [`cfbd_stats_season_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_advanced.md)::

  Get season advanced statistics by team.

- [`cfbd_stats_game_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_game_advanced.md)::

  Get game advanced stats.

- [`cfbd_stats_season_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_player.md)::

  Get season statistics by player.

## Details

### **Get game advanced stats**

    cfbd_stats_game_advanced(year = 2018, week = 12, team = "Texas A&M")

    cfbd_stats_game_advanced(2019, team = "LSU")

    cfbd_stats_game_advanced(2013, team = "Florida State")

### **Get season advanced statistics by team**

    cfbd_stats_season_advanced(2019, team = "LSU")

### **Get season statistics by player**

    cfbd_stats_season_player(year = 2018, conference = "B12", start_week = 1, end_week = 7)

    cfbd_stats_season_player(2019, team = "LSU", category = "passing")

    cfbd_stats_season_player(2013, team = "Florida State", category = "passing")

### **Get season statistics by team**

    cfbd_stats_season_team(year = 2018, conference = "B12", start_week = 1, end_week = 8)

    cfbd_stats_season_team(2019, team = "LSU")

    cfbd_stats_season_team(2013, team = "Florida State")

### **Get stats categories**

This function identifies all Stats Categories identified in the regular
stats endpoint.

    cfbd_stats_categories()
