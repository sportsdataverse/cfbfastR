# Articles

### Introductory

- [Introduction to
  cfbfastR](https://cfbfastR.sportsdataverse.org/articles/intro.md):

  Getting started with using `cfbfastR` and college football analytics.

- [Making Animated Win Probability Charts with
  cfbfastR](https://cfbfastR.sportsdataverse.org/articles/animated-wp-plotting.md):

  Step-by-step walk-through of the process of adapting [Lee
  Sharpe’s](https://twitter.com/LeeSharpeNFL) win probability charts to
  college football using data from
  [CollegeFootballData.com](https://www.collegefootballdata.com)
  collected using the `cfbfastR` package for R.

- [Creating Fourth Down Tendency Plots Using
  cfbfastR](https://cfbfastR.sportsdataverse.org/articles/fourth-down-plot-tutorial.md):

  A rundown of the Big XII returning coaches fourth down tendencies

- [Rolling EPA
  Graph](https://cfbfastR.sportsdataverse.org/articles/rolling-epa-graph.md):

  **IT’S GRAPHIN’ TIME**  
  ^*To be said in an extremely Power Rangers voice*^**

- [Visualizing Team Talent from Player Recruiting
  Rankings](https://cfbfastR.sportsdataverse.org/articles/nth-rated-recruit.md):

  A quick way to visually approximate how much talent each school
  recruited using `cfbfastR` and `ggplot2`.

- [Intro to Visualizing Recruiting
  Geography](https://cfbfastR.sportsdataverse.org/articles/map-tutorial.md):

### Expected Points Model Fundamentals

- [College Football Expected Points Model Fundamentals - Part
  I](https://cfbfastR.sportsdataverse.org/articles/college-football-expected-points-model-fundamentals-part-i.md):

  Expected points model definition - a model explainer

- [College Football Expected Points Model Fundamentals - Part
  II](https://cfbfastR.sportsdataverse.org/articles/college-football-expected-points-model-fundamentals-part-ii.md):

  Motivating the regression - I do bad regression to show that a
  multinomial logistic regression model is necessary

- [College Football Expected Points Model Fundamentals - Part
  III](https://cfbfastR.sportsdataverse.org/articles/college-football-expected-points-model-fundamentals-part-iii.md):

  A brief history of expected points models. Learn about Virgil Carter’s
  1970 paper and the origins of the nflscrapR expected points model
  (which the cfbscrapR package used). The cfbfastR package includes
  support for this model as well.

### CFBD Tutorials

- [CFB Data Betting Lines
  Examples](https://cfbfastR.sportsdataverse.org/articles/cfbd_betting.md):

  Get betting lines information for games using
  [`cfbd_betting_lines()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_betting_lines.md)

- [CFB Data Games
  Examples](https://cfbfastR.sportsdataverse.org/articles/cfbd_games.md):

  Provides access to **game-level** team
  ([`cfbd_game_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.md))
  and player
  ([`cfbd_game_player_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_player_stats.md))
  standard **box scores**, as well as team-level advanced box scores
  ([`cfbd_game_box_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_box_advanced.md)).
  Also useful for looking up game information
  ([`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md)),
  broadcast details
  ([`cfbd_game_media()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_media.md)),
  and team records/results information
  ([`cfbd_game_records()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_records.md)).

- [CFB Data Plays
  Examples](https://cfbfastR.sportsdataverse.org/articles/cfbd_plays.md):

  Using the CFB Data Plays Endpoint to pull down the 2020 season by week
  using
  [`cfbd_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_plays.md)

- [CFB Data Recruiting
  Examples](https://cfbfastR.sportsdataverse.org/articles/cfbd_recruiting.md):

  Accessing 247Sports composite recruiting data through the CFBD API
  using
  [`cfbd_recruiting_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_player.md)
  for Player Rankings,
  [`cfbd_recruiting_team()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_team.md)
  for Team Rankings and
  [`cfbd_recruiting_position()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_position.md)
  for Position Group metrics

- [CFB Data Stats
  Examples](https://cfbfastR.sportsdataverse.org/articles/cfbd_stats.md):

  Settling **2019 LSU** and **2013 Florida State** offense debates using
  Team and Player Stats from the CFBD API

- [CFB Data Teams
  Examples](https://cfbfastR.sportsdataverse.org/articles/cfbd_teams.md):

  Get team rosters (`cfbd_team_rosters()`), talent
  ([`cfbd_team_talent()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_talent.md))
  and team matchup history (`cfbd_team_matchup_history()`) and records
  ([`cfbd_team_matchup_records()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_matchup_records.md))
  from the CFBD API
