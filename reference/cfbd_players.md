# **CFBD Players Endpoint Overview**

- [`cfbd_player_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_info.md)::

  Player information search.

- [`cfbd_player_returning()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_returning.md)::

  Player returning production.

- [`cfbd_player_usage()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_usage.md)::

  Player usage.

## Details

### **Player information lookup**

     cfbd_player_info(search_term = "James", position = "DB", team = "Florida State", year = 2017)

     cfbd_player_info(search_term = "Lawrence", team = "Clemson")

### **Get player returning production**

     cfbd_player_returning(year = 2019, team = "Florida State")

### **Get player usage metrics**

     cfbd_player_usage(year = 2019, position = "WR", team = "Florida State")
