# **CFBD Teams Endpoint Overview**

- [`cfbd_team_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_info.md)::

  Team Info Lookup.

- [`cfbd_team_roster()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_roster.md)::

  Get a team's full roster by year.

- [`cfbd_team_talent()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_talent.md)::

  Get composite team talent rankings for all teams in a given year.

- [`cfbd_team_matchup_records()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_matchup_records.md)::

  Get matchup history records between two teams.

- [`cfbd_team_matchup()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_matchup.md)::

  Get matchup history between two teams.

### **Team info lookup**

Lists all teams in conference or all D-I teams if conference is left
NULL Currently, support is only provided for D-I

    cfbd_team_info(conference = "SEC")

    cfbd_team_info(conference = "Ind")

    cfbd_team_info(year = 2019)

### **Get team rosters**

#### **It is now possible to access yearly rosters**

    cfbd_team_roster(year = 2020)

#### Get a teams full roster by year. If team is not selected, API returns rosters for every team from the selected year.

    cfbd_team_roster(year = 2013, team = "Florida State")

#### Get composite team talent rankings

Extracts team talent composite for all teams in a given year as sourced
from 247 rankings

    cfbd_team_talent()

    cfbd_team_talent(year = 2018)

#### **Get matchup history between two teams.**

    cfbd_team_matchup("Texas A&M", "TCU")

    cfbd_team_matchup("Texas A&M", "TCU", min_year = 1975)

    cfbd_team_matchup("Florida State", "Florida", min_year = 1975)

#### **Get matchup history records between two teams.**

    cfbd_team_matchup_records("Texas", "Oklahoma")

    cfbd_team_matchup_records("Texas A&M", "TCU", min_year = 1975)
