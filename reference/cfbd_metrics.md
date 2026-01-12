# **CFBD Metrics Endpoint Overview**

- [`cfbd_metrics_fg_ep()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_fg_ep.md)::

  Get field goal expected points values.

- [`cfbd_metrics_wepa_team_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_team_season.md)::

  Get opponent-adjusted team season statistics for predicted points
  added (PPA).

- [`cfbd_metrics_wepa_players_passing()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_passing.md)::

  Get opponent-adjusted player passing statistics for predicted points
  added (PPA).

- [`cfbd_metrics_wepa_players_rushing()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_rushing.md)::

  Get opponent-adjusted player rushing statistics for predicted points
  added (PPA).

- [`cfbd_metrics_wepa_players_kicking()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_kicking.md)::

  Get Points Added Above Replacement (PAAR) ratings for kickers.

- [`cfbd_metrics_ppa_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_games.md)::

  Get team game averages for predicted points added (PPA).

- [`cfbd_metrics_ppa_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_games.md)::

  Get player game averages for predicted points added (PPA).

- [`cfbd_metrics_ppa_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_season.md)::

  Get player season averages for predicted points added (PPA).

- [`cfbd_metrics_ppa_predicted()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_predicted.md)::

  Calculate predicted points using Down and Distance.

- [`cfbd_metrics_ppa_teams()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_teams.md)::

  Get team averages for predicted points added (PPA).

- [`cfbd_metrics_wp_pregame()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp_pregame.md)::

  Get pre-game win probability data from CFBD API.

- [`cfbd_metrics_wp()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp.md)::

  Get win probability chart data from CFBD API.

## Details

### **Get expected points for field goals by yards to goal and distance**

      cfbd_metrics_fg_ep()

### **Get opponent-adjusted team season statistics for predicted points added (PPA)**

     cfbd_metrics_wepa_team_season(year = 2019, team = "TCU")

### **Get opponent-adjusted player passing statistics for predicted points added (PPA)**

    cfbd_metrics_wepa_players_passing(year = 2019, team = "TCU")

### **Get opponent-adjusted player rushing statistics for predicted points added (PPA)**

    cfbd_metrics_wepa_players_rushing(year = 2019, team = "TCU")

### **Get Points Added Above Replacement (PAAR) ratings for kickers**

    cfbd_metrics_wepa_players_kicking(year = 2019, team = "TCU")

### **Get team game averages for predicted points added (PPA)**

      cfbd_metrics_ppa_games(year = 2019, team = "TCU")

### **Get player game averages for predicted points added (PPA)**

      cfbd_metrics_ppa_players_games(year = 2019, week = 3, team = "TCU")

### **Get player season averages for predicted points added (PPA)**

      cfbd_metrics_ppa_players_season(year = 2019, team = "TCU")

### **Get team averages for predicted points added (PPA)**

      cfbd_metrics_ppa_teams(year = 2019, team = "TCU")

### **Get pre-game and post-game win probability data from CFBD API**

      cfbd_metrics_wp_pregame(year = 2019, week = 9, team = "Texas A&M")
      cfbd_metrics_wp(game_id = 401012356)

### **Calculate predicted points using down and distance**

    cfbd_metrics_ppa_predicted(down = 1, distance = 10)
