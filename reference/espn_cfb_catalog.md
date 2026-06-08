# **ESPN College Football Catalog Endpoint Overview**

- [`espn_cfb_award()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_award.md):
  Get the ESPN core-v2 detail record for a single college football award
  in a given season – name, description, history, and the athlete (and
  team) that won it.

- [`espn_cfb_awards()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_awards.md):
  Get ESPN's college football awards for a season – the Heisman,
  position and player-of-the-year honors, and the athlete (and team)
  that won each.

- [`espn_cfb_coach()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_coach.md):
  Get the ESPN core-v2 detail record for a single college football coach
  – name, the team coached in the requested season, and a count of
  career-record and coach-season entries ESPN has on file.

- [`espn_cfb_coach_record()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_coach_record.md):
  Get a college football coach's win/loss record for a single season –
  the headline summary plus every stat category ESPN publishes for that
  coach-season.

- [`espn_cfb_coaches()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_coaches.md):
  Get every head coach ESPN tracks for a college football season, with
  their name, ESPN ids, and the team they coached that year.

- [`espn_cfb_franchise()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_franchise.md):
  Get the ESPN core-v2 detail record for a single college football
  franchise – location, nickname, abbreviation, color, the associated
  venue and current team, and active status.

- [`espn_cfb_franchises()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_franchises.md):
  Get the catalog of college football franchises ESPN tracks – the
  stable program identities that underpin ESPN's team resources.

- [`espn_cfb_position()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_position.md):
  Get the ESPN core-v2 detail record for a single college football
  player position – name, display name, abbreviation, leaf flag, and the
  parent position id.

- [`espn_cfb_positions()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_positions.md):
  Get the catalog of player positions ESPN tracks for college football –
  the position names, abbreviations, and ids used throughout ESPN's
  athlete and roster resources.

- [`espn_cfb_venue()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_venue.md):
  Get the ESPN core-v2 detail record for a single college football venue
  – full name, address, playing-surface and indoor flags.

- [`espn_cfb_venues()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_venues.md):
  Get the catalog of stadiums and venues ESPN tracks for college
  football, with location, capacity-related flags, and addresses.

- [`espn_cfb_clear_cache()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_clear_cache.md):
  Clear the cfbfastR ESPN catalog cache – forget the memoised team and
  position lookups so the next call re-fetches them from ESPN.

## Details

### **ESPN College Football Award Detail**

    espn_cfb_award(award_id = 1, year = 2024)

### **ESPN College Football Awards**

    espn_cfb_awards(year = 2024)

### **ESPN College Football Coach Detail**

    espn_cfb_coach(coach_id = 5120149, year = 2024)

### **ESPN College Football Coach Season Record**

    espn_cfb_coach_record(coach_id = 5120149, year = 2024)

### **ESPN College Football Coaches Index**

    espn_cfb_coaches(year = 2024)

### **ESPN College Football Franchise Detail**

    espn_cfb_franchise(franchise_id = 2)

### **ESPN College Football Franchises Index**

    espn_cfb_franchises()

### **ESPN College Football Position Detail**

    espn_cfb_position(position_id = 8)

### **ESPN College Football Positions Index**

    espn_cfb_positions()

### **ESPN College Football Venue Detail**

    espn_cfb_venue(venue_id = 3785)

### **ESPN College Football Venues Index**

    espn_cfb_venues(max_results = 50)

### **Clear the cfbfastR ESPN catalog cache**

    espn_cfb_clear_cache()
