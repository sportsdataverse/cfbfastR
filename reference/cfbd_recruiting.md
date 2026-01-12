# **CFB Recruiting Endpoint Overview**

- [`cfbd_recruiting_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_player.md)::

  Get college football player recruiting information for a single year
  with filters available for team, recruit type, state and position.

- [`cfbd_recruiting_position()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_position.md)::

  Get college football position group recruiting information .

- [`cfbd_recruiting_team()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_team.md)::

  Get college football recruiting team rankings information.

### **Get player recruiting rankings**

Get college football player recruiting information for a single year
with filters available for team, recruit type, state and position.

    cfbd_recruiting_player(2018, team = "Texas")

    cfbd_recruiting_player(2016, recruit_type = "JUCO")

    cfbd_recruiting_player(2020, recruit_type = "HighSchool", position = "OT", state = "FL")

### **Get college football position group recruiting information.**

    cfbd_recruiting_position(2018, team = "Texas")

    cfbd_recruiting_position(2016, 2020, team = "Virginia")

    cfbd_recruiting_position(2015, 2020, conference = "SEC")

### **Get college football recruiting team rankings information.**

    cfbd_recruiting_team(2018, team = "Texas")

    cfbd_recruiting_team(2016, team = "Virginia")

    cfbd_recruiting_team(2016, team = "Texas A&M")

    cfbd_recruiting_team(2011)

## Details

Gets CFB team recruiting ranks with filters available for year and team.
At least one of **year** or **team** must be specified for the function
to run

If you would like CFB recruiting information for players, please see the
[`cfbd_recruiting_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_player.md)
function

If you would like to get CFB recruiting information based on position
groups during a time period for all FBS teams, please see the
[`cfbd_recruiting_position()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_position.md)
function.

[`cfbd_recruiting_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_player.md) -
At least one of **year** or **team** must be specified for the function
to run

[`cfbd_recruiting_position()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_position.md) -
If only start_year is provided, function will get CFB recruiting
information based on position groups during that year for all FBS teams.
