# Package index

## cfbfastR Data

### Full Seasons PBP Data

Functions exported by cfbfastR which load full seasons of cfbfastR data

- [`load_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_pbp.md)
  :

  **Load cleaned play-by-play from the data repo**

- [`load_cfb_rosters()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_rosters.md)
  : Load College Football Rosters

- [`load_cfb_schedules()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_schedules.md)
  : Load CFB Game/Schedule Data from data repo

- [`load_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_teams.md)
  : Load CFB team info from the data repo

### Update or Create Database

Functions exported by cfbfastR which update and create a database of
cfbfastR play-by-play data

- [`update_cfb_db()`](https://cfbfastR.sportsdataverse.org/reference/update_cfb_db.md)
  :

  **Update or create a cfbfastR play-by-play database**

### Play-by-Play Data

Functions exported by cfbfastR which return Expected Points and Win
Probability model outputs.

- [`cfbd_pbp_data()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.md)
  :

  **Get college football play by play data with cfbfastR expected
  points/win probability added**

## College Football Data API and ESPN Functions

### College Football Data API Key

Functions for using your API key.

- [`cfbd_key()`](https://cfbfastR.sportsdataverse.org/reference/register_cfbd.md)
  [`has_cfbd_key()`](https://cfbfastR.sportsdataverse.org/reference/register_cfbd.md)
  [`cfbd_api_key_info()`](https://cfbfastR.sportsdataverse.org/reference/register_cfbd.md)
  :

  **CFBD API Key Registration**

### Games Data

Functions exported by cfbfastR sourced from games endpoint of the
CollegeFootballData API

- [`cfbd_games`](https://cfbfastR.sportsdataverse.org/reference/cfbd_games.md)
  :

  **CFBD Games Endpoint Overview**

- [`cfbd_game_box_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_box_advanced.md)
  :

  **Get game advanced box score information.**

- [`cfbd_game_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.md)
  :

  **Get results information from games.**

- [`cfbd_game_media()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_media.md)
  :

  **Get game media information (TV, radio, etc).**

- [`cfbd_game_player_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_player_stats.md)
  :

  **Get player statistics by game**

- [`cfbd_game_records()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_records.md)
  :

  **Get team records by year**

- [`cfbd_game_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.md)
  :

  **Get team statistics by game**

- [`cfbd_game_weather()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_weather.md)
  :

  **Get weather from games.**

- [`cfbd_calendar()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_calendar.md)
  :

  **Get calendar of weeks by season.**

- [`cfbd_live_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_scoreboard.md)
  :

  **Get live game scoreboard information from games.**

### Drives Data

Functions exported by cfbfastR sourced from drives endpoint of the
CollegeFootballData API

- [`cfbd_drives()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_drives.md)
  :

  **CFBD Drives Endpoint**

### Plays Data

Functions exported by cfbfastR sourced from plays endpoint of the
CollegeFootballData API

- [`cfbd_play`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play.md)
  :

  **CFBD Plays Endpoint Overview**

- [`cfbd_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_plays.md)
  :

  **Get college football play-by-play data.**

- [`cfbd_live_plays()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_plays.md)
  :

  **Get live college football play-by-play data.**

- [`cfbd_play_stats_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_player.md)
  :

  **Gets player info associated by play**

- [`cfbd_play_stats_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_types.md)
  :

  **Get college football mapping for play stats types**

- [`cfbd_play_types()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_types.md)
  :

  **Get college football mapping for play types**

### Teams Data

Functions exported by cfbfastR sourced from the teams endpoint of the
CollegeFootballData API

- [`cfbd_teams`](https://cfbfastR.sportsdataverse.org/reference/cfbd_teams.md)
  :

  **CFBD Teams Endpoint Overview**

- [`cfbd_team_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_info.md)
  :

  **Team info lookup**

- [`cfbd_team_matchup()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_matchup.md)
  :

  **Get matchup history between two teams.**

- [`cfbd_team_matchup_records()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_matchup_records.md)
  :

  **Get matchup history records between two teams.**

- [`cfbd_team_roster()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_roster.md)
  :

  **Get team rosters**

- [`cfbd_team_talent()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_talent.md)
  :

  **Get composite team talent rankings for all teams in a given year**

### Players Data

Functions exported by cfbfastR sourced from the players endpoint of the
CollegeFootballData API

- [`cfbd_players`](https://cfbfastR.sportsdataverse.org/reference/cfbd_players.md)
  [`cfbd_player`](https://cfbfastR.sportsdataverse.org/reference/cfbd_players.md)
  :

  **CFBD Players Endpoint Overview**

- [`cfbd_player_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_info.md)
  :

  **Player information lookup**

- [`cfbd_player_returning()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_returning.md)
  :

  **Get player returning production**

- [`cfbd_player_usage()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_usage.md)
  :

  **Get player usage metrics**

### Stats Data

Functions exported by cfbfastR sourced from the conferences endpoint of
the CollegeFootballData API

- [`cfbd_stats`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats.md)
  :

  **CFBD Stats Endpoint Overview**

- [`cfbd_stats_categories()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_categories.md)
  :

  **Get stats categories**

- [`cfbd_stats_game_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_game_advanced.md)
  :

  **Get game advanced stats**

- [`cfbd_stats_season_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_advanced.md)
  :

  **Get season advanced statistics by team**

- [`cfbd_stats_season_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_player.md)
  :

  **Get season statistics by player**

- [`cfbd_stats_season_team()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_team.md)
  :

  **Get season statistics by team**

### Rankings and Ratings Data

Functions exported by cfbfastR sourced from the rankings and ratings
endpoints of the CollegeFootballData API and ESPN

- [`cfbd_ratings`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings.md)
  :

  **CFBD Ratings and Rankings Endpoints Overview**

- [`cfbd_ratings_elo()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_elo.md)
  :

  **Get Elo historical rating data**

- [`cfbd_ratings_fpi()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_fpi.md)
  :

  **Get Football Power Index (FPI) historical rating data**

- [`cfbd_ratings_sp()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_sp.md)
  :

  **Get SP historical rating data**

- [`cfbd_ratings_sp_conference()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_sp_conference.md)
  :

  **Get conference level SP historical rating data**

- [`cfbd_ratings_srs()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_srs.md)
  :

  **Get SRS historical rating data**

- [`cfbd_rankings()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rankings.md)
  :

  **Get historical Coaches and AP poll data**

- [`espn_ratings_fpi()`](https://cfbfastR.sportsdataverse.org/reference/espn_ratings_fpi.md)
  :

  **ESPN FPI Ratings**

### NFL Draft Data

Functions exported by cfbfastR sourced from the draft endpoints of the
CollegeFootballData API

- [`cfbd_draft`](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft.md)
  [`draft`](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft.md)
  [`nfl`](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft.md)
  [`nfl_draft`](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft.md)
  [`nfl_teams`](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft.md)
  :

  **CFBD NFL Draft Endpoint Overview**

- [`cfbd_draft_picks()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft_picks.md)
  :

  **Get list of NFL draft picks**

- [`cfbd_draft_positions()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft_positions.md)
  :

  **Get list of NFL positions**

- [`cfbd_draft_teams()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft_teams.md)
  :

  **Get list of NFL teams**

### Betting Data

Functions exported by cfbfastR sourced from lines endpoint of the
CollegeFootballData API

- [`cfbd_betting_lines()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_betting_lines.md)
  :

  **CFBD Betting Lines Endpoint Overview**

### Metrics Data

Functions exported by cfbfastR sourced from the Predicted Points Added
(PPA) endpoints of the CollegeFootballData API and ESPN

- [`cfbd_metrics`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics.md)
  :

  **CFBD Metrics Endpoint Overview**

- [`cfbd_metrics_fg_ep()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_fg_ep.md)
  :

  **Get FG expected points from CFBD API**

- [`cfbd_metrics_ppa_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_games.md)
  :

  **Get team game averages for predicted points added (PPA)**

- [`cfbd_metrics_ppa_players_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_games.md)
  :

  **Get player game averages for predicted points added (PPA)**

- [`cfbd_metrics_ppa_players_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_season.md)
  :

  **Get player season averages for predicted points added (PPA)**

- [`cfbd_metrics_ppa_predicted()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_predicted.md)
  :

  **Calculate predicted points using down and distance**

- [`cfbd_metrics_ppa_teams()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_teams.md)
  :

  **Get team averages for predicted points added (PPA)**

- [`cfbd_metrics_wepa_players_kicking()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_kicking.md)
  :

  **Get Points Added Above Replacement (PAAR) ratings for kickers**

- [`cfbd_metrics_wepa_players_passing()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_passing.md)
  :

  **Get opponent-adjusted player passing statistics for predicted points
  added (PPA)**

- [`cfbd_metrics_wepa_players_rushing()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_rushing.md)
  :

  **Get opponent-adjusted player rushing statistics for predicted points
  added (PPA)**

- [`cfbd_metrics_wepa_team_season()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_team_season.md)
  :

  **Get opponent-adjusted team season statistics for predicted points
  added (PPA)**

- [`cfbd_metrics_wp()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp.md)
  :

  **Get win probability chart data from API**

- [`cfbd_metrics_wp_pregame()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp_pregame.md)
  :

  **Get pre-game win probability data from API**

### Recruiting Data

Functions exported by cfbfastR sourced from the rankings and ratings
endpoints of the CollegeFootballData API

- [`cfbd_recruiting`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting.md)
  [`recruiting`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting.md)
  :

  **CFB Recruiting Endpoint Overview**

- [`cfbd_recruiting_player()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_player.md)
  :

  **Get player recruiting rankings**

- [`cfbd_recruiting_position()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_position.md)
  :

  **Get college football position group recruiting information.**

- [`cfbd_recruiting_team()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_team.md)
  :

  **Get college football recruiting team rankings information.**

- [`cfbd_recruiting_transfer_portal()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_transfer_portal.md)
  :

  **Get Transfer Portal Data**

### Schools Data

Functions exported by cfbfastR sourced from venues, conferences, and
coaches endpoints of the CollegeFootballData API

- [`cfbd_venues()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_venues.md)
  :

  **CFBD Venues Endpoint Overview**

- [`cfbd_conferences()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_conferences.md)
  :

  **CFBD Conferences Endpoint Overview**

- [`cfbd_coaches()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches.md)
  :

  **CFBD Coaches Endpoint Overview**

## ESPN Data

### Functions with ESPN connections

Functions exported by cfbfastR which allow access to ESPN data

- [`espn_cfb_calendar()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_calendar.md)
  : ESPN Calendar

- [`espn_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp.md)
  : Get ESPN college football PBP data

- [`espn_cfb_player_stats()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_stats.md)
  :

  **Get ESPN college football player stats data**

- [`espn_cfb_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_scoreboard.md)
  [`espn_cfb_schedule()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_scoreboard.md)
  :

  **ESPN Scoreboard**

- [`espn_cfb_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_stats.md)
  :

  **Get ESPN college football team stats data**

- [`espn_metrics_wp()`](https://cfbfastR.sportsdataverse.org/reference/espn_metrics.md)
  :

  **ESPN Metrics**

- [`espn_ratings_fpi()`](https://cfbfastR.sportsdataverse.org/reference/espn_ratings_fpi.md)
  :

  **ESPN FPI Ratings**

## Helper Functions and Data

### Included data

Data included within the package

- [`cfbd_play_type_df`](https://cfbfastR.sportsdataverse.org/reference/data.md)
  [`cfbd_conf_types_df`](https://cfbfastR.sportsdataverse.org/reference/data.md)
  :

  **Data in the package for reference**

### Model functions and PBP helpers

Model functions and play-by-play helpers

- [`create_epa()`](https://cfbfastR.sportsdataverse.org/reference/create_epa.md)
  [`epa_fg_probs()`](https://cfbfastR.sportsdataverse.org/reference/create_epa.md)
  :

  **Create EPA**

- [`create_wpa_naive()`](https://cfbfastR.sportsdataverse.org/reference/create_wpa.md)
  [`wpa_calcs_naive()`](https://cfbfastR.sportsdataverse.org/reference/create_wpa.md)
  :

  **Create WPA**

- [`add_play_counts()`](https://cfbfastR.sportsdataverse.org/reference/helpers_pbp.md)
  [`clean_drive_dat()`](https://cfbfastR.sportsdataverse.org/reference/helpers_pbp.md)
  [`prep_epa_df_after()`](https://cfbfastR.sportsdataverse.org/reference/helpers_pbp.md)
  [`clean_drive_info()`](https://cfbfastR.sportsdataverse.org/reference/helpers_pbp.md)
  [`clean_play_text()`](https://cfbfastR.sportsdataverse.org/reference/helpers_pbp.md)
  [`add_player_cols()`](https://cfbfastR.sportsdataverse.org/reference/helpers_pbp.md)
  [`add_yardage()`](https://cfbfastR.sportsdataverse.org/reference/helpers_pbp.md)
  [`clean_pbp_dat()`](https://cfbfastR.sportsdataverse.org/reference/helpers_pbp.md)
  [`penalty_detection()`](https://cfbfastR.sportsdataverse.org/reference/helpers_pbp.md)
  :

  **Series of functions to help clean the play-by-play data for
  analysis**

### cfbfastR Helper Functions

Internal functions used by cfbfastR

- [`csv_from_url()`](https://cfbfastR.sportsdataverse.org/reference/csv_from_url.md)
  :

  **Load .csv / .csv.gz file from a remote connection**

- [`rds_from_url()`](https://cfbfastR.sportsdataverse.org/reference/rds_from_url.md)
  : Load .rds file from a remote connection
