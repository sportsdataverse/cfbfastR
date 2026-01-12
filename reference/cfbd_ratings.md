# **CFBD Ratings and Rankings Endpoints Overview**

- [`cfbd_rankings()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rankings.md)::

  Gets Historical CFB poll rankings at a specific week.

- [`cfbd_ratings_sp()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_sp.md)::

  Get SP historical rating data.

- [`cfbd_ratings_sp_conference()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_sp_conference.md)::

  Get SP conference-level historical rating data.

- [`cfbd_ratings_srs()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_srs.md)::

  Get SRS historical rating data.

- [`cfbd_ratings_elo()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_elo.md)::

  Get Elo historical rating data.

- [`cfbd_ratings_fpi()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_fpi.md)::

  Get FPI historical rating data.

### **Get historical Coaches and AP poll data**

    cfbd_rankings(year = 2019, week = 12)

    cfbd_rankings(year = 2018, week = 14)

    cfbd_rankings(year = 2013, season_type = "postseason")

### **Get SP historical rating data**

At least one of **year** or **team** must be specified for the function
to run

    cfbd_ratings_sp(year = 2018)

    cfbd_ratings_sp(team = "Texas A&M")

    cfbd_ratings_sp(year = 2019, team = "Texas")

### **Get conference level SP historical rating data**

    cfbd_ratings_sp_conference(year = 2019)

    cfbd_ratings_sp_conference(year = 2012, conference = "SEC")

    cfbd_ratings_sp_conference(year = 2016, conference = "ACC")

### **Get SRS historical rating data**

At least one of **year** or **team** must be specified for the function
to run

    cfbd_ratings_srs(year = 2019, team = "Texas")

    cfbd_ratings_srs(year = 2018, conference = "SEC")

### **Get Elo historical rating data**

Acquire the CFBD calculated elo ratings data by **team**, **year**,
**week**, and **conference**

    cfbd_ratings_elo(year = 2019, team = "Texas")

    cfbd_ratings_elo(year = 2018, conference = "SEC")

### **Get FPI historical rating data**

Acquire the ESPN FPI ratings data by **team**, **year**, and
**conference**

    cfbd_ratings_fpi(year = 2019, team = "Texas")

    cfbd_ratings_fpi(year = 2018, conference = "SEC")
