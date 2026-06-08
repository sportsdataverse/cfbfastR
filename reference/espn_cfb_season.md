# **ESPN College Football Season Endpoint Overview**

- [`espn_cfb_groups()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_groups.md):
  Get the full ESPN group hierarchy for a college football season –
  division roll-ups and conferences flattened into one catalog table.

- [`espn_cfb_rankings()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_rankings.md):
  Get the index of poll / ranking sources ESPN publishes for a college
  football season.

- [`espn_cfb_season_info()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_season_info.md):
  Get the ESPN core-v2 detail record for a single college football
  season.

- [`espn_cfb_season_types()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_season_types.md):
  Get the set of season types (preseason, regular season, postseason,
  off-season) ESPN tracks for a college football season.

- [`espn_cfb_season_weeks()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_season_weeks.md):
  Get the calendar of weeks ESPN tracks for a college football season
  type.

- [`espn_cfb_seasons()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_seasons.md):
  Get the index of every college football season ESPN tracks in its
  core-v2 API.

- [`espn_cfb_standings()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_standings.md):
  Get ESPN's standings for a college football group – full record splits
  and standings statistics for every team.

- [`espn_cfb_week_rankings()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_week_rankings.md):
  Get the ranked teams from every poll ESPN published in a single week
  of a college football season.

## Details

### **Get ESPN College Football Groups & Conferences**

    espn_cfb_groups(year = 2024)

### **Get ESPN College Football Ranking Sources**

    espn_cfb_rankings(year = 2024)

### **Get ESPN College Football Season Detail**

    espn_cfb_season_info(year = 2024)

### **Get ESPN College Football Season Types**

    espn_cfb_season_types(year = 2024)

### **Get ESPN College Football Season Weeks**

    espn_cfb_season_weeks(year = 2024)

### **Get ESPN College Football Seasons Index**

    espn_cfb_seasons()

### **Get ESPN College Football Standings (Long Format)**

    espn_cfb_standings(year = 2024)

    espn_cfb_standings(year = 2024, team_detail = FALSE)

### **Get ESPN College Football Weekly Rankings**

    espn_cfb_week_rankings(year = 2024, week = 8)

    espn_cfb_week_rankings(year = 2024, week = 8, team_detail = FALSE)
