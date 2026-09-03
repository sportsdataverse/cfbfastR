# Articles

### The Expected Points Model

How expected points and EPA work in college football, how the cfbfastR
model is built, where the idea came from, and how to reproduce it from
the published cfb_model_artifacts bundle.

- [Expected Points in College Football: How the Model Works (Part
  I)](https://cfbfastR.sportsdataverse.org/articles/college-football-expected-points-model-fundamentals-part-i.md):

  What expected points (EP) means in college football, the seven
  next-score outcomes the cfbfastR model predicts, and how to reproduce
  its field-position curve from the published model bundle.

- [How the Expected Points Model Is Built (Part
  II)](https://cfbfastR.sportsdataverse.org/articles/college-football-expected-points-model-fundamentals-part-ii.md):

  Why expected points is a multiclass problem, why linear and binary
  logistic regression fail at it, and how the cfbfastR EP model went
  from 96 hand-built regression variables to eight gradient-boosted
  features.

- [A History of Expected Points Models in Football (Part
  III)](https://cfbfastR.sportsdataverse.org/articles/college-football-expected-points-model-fundamentals-part-iii.md):

  How expected points models evolved in football: Virgil Carter’s 1970
  paper, The Hidden Game of Football, Brian Burke’s LOESS models, the
  Carnegie Mellon nflscrapR work, and the line that runs to the cfbfastR
  model shipping today.

- [What Is EPA in College Football? Expected Points Added Explained
  (Part
  IV)](https://cfbfastR.sportsdataverse.org/articles/college-football-expected-points-model-fundamentals-part-iv.md):

  EPA (expected points added) is the change in expected points across a
  single play. How it is calculated, what a good EPA per play looks
  like, the sign conventions that trip people up, and how to compute it
  yourself with cfbfastR.

- [Win Probability in College Football: wp, WPA and vegas_wp (Part
  V)](https://cfbfastR.sportsdataverse.org/articles/college-football-expected-points-model-fundamentals-part-v.md):

  How the cfbfastR win probability model works, why it takes expected
  points as an input, what WPA measures that EPA cannot, and how the
  spread-aware vegas_wp differs from the naive wp.

- [CPOE, xpass, Field Goals and Fourth Downs: The Derived Models (Part
  VI)](https://cfbfastR.sportsdataverse.org/articles/college-football-expected-points-model-fundamentals-part-vi.md):

  The six models cfbfastR builds on top of expected points and win
  probability: completion probability and CPOE, expected pass rate,
  field goals, two-point conversions, fourth-down decisions and QBR —
  with their real outputs and their limits.

### Cookbooks & Guides

End-to-end recipes and reference guides.

- [Making Animated Win Probability Charts with
  cfbfastR](https://cfbfastR.sportsdataverse.org/articles/animated-wp-plotting.md):

  Step-by-step walk-through of the process of adapting [Lee
  Sharpe’s](https://twitter.com/LeeSharpeNFL) win probability charts to
  college football using data from
  [CollegeFootballData.com](https://www.collegefootballdata.com)
  collected using the `cfbfastR` package for R.

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

- [ESPN College Football
  Cookbook](https://cfbfastR.sportsdataverse.org/articles/cfbfastR-espn-cookbook.md):

  A recipe-driven tour of the `espn_cfb_*()` family in `cfbfastR` –
  teams, games, play-by-play, modeled EPA/WPA, and ratings.

- [Creating Fourth Down Tendency Plots Using
  cfbfastR](https://cfbfastR.sportsdataverse.org/articles/fourth-down-plot-tutorial.md):

  A rundown of the Big XII returning coaches fourth down tendencies

- [Introduction to
  cfbfastR](https://cfbfastR.sportsdataverse.org/articles/intro.md):

  Getting started with using `cfbfastR` and college football analytics.

- [Intro to Visualizing Recruiting
  Geography](https://cfbfastR.sportsdataverse.org/articles/map-tutorial.md):

  Mapping where the blue-chip talent actually comes from, joining
  [`cfbd_recruiting_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_player.md)
  to state geometry to see which parts of the country each program
  recruits.

- [Visualizing Team Talent from Player Recruiting
  Rankings](https://cfbfastR.sportsdataverse.org/articles/nth-rated-recruit.md):

  A quick way to visually approximate how much talent each school
  recruited using `cfbfastR` and `ggplot2`.

- [Rolling EPA
  Graph](https://cfbfastR.sportsdataverse.org/articles/rolling-epa-graph.md):

  **IT’S GRAPHIN’ TIME**  
  ^*To be said in an extremely Power Rangers voice*^**
