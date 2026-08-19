# Package index

## Function family overviews

One-page summaries of the cfbd\_\* and espn_cfb\_\* function families.

- [`cfbd_api_key`](https://cfbfastR.sportsdataverse.org/reference/cfbd_api_key.md)
  [`api_key`](https://cfbfastR.sportsdataverse.org/reference/cfbd_api_key.md)
  :

  **CFBD API Key Endpoint Overview**

- [`cfbd_betting`](https://cfbfastR.sportsdataverse.org/reference/cfbd_betting.md)
  [`betting`](https://cfbfastR.sportsdataverse.org/reference/cfbd_betting.md)
  [`lines`](https://cfbfastR.sportsdataverse.org/reference/cfbd_betting.md)
  [`spreads`](https://cfbfastR.sportsdataverse.org/reference/cfbd_betting.md)
  :

  **CFBD Betting Endpoint Overview**

- [`cfbd_coaches()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches.md)
  :

  **CFBD Coaches Endpoint Overview**

- [`cfbd_conferences()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_conferences.md)
  :

  **CFBD Conferences Endpoint Overview**

- [`cfbd_drives()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_drives.md)
  :

  **CFBD Drives Endpoint Overview**

- [`cfbd_pbp`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp.md)
  [`play_by_play`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp.md)
  :

  **CFBD Play-by-Play Endpoint Overview**

- [`cfbd_pbp_v2`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_v2.md)
  [`pbp_v2`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_v2.md)
  [`modular_epa`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_v2.md)
  [`modular_wpa`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_v2.md)
  :

  **CFBD Play-by-Play (v2 Modular EPA/WPA Pipeline) Overview**

- [`cfbd_venues()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_venues.md)
  :

  **CFBD Venues Endpoint Overview**

- [`espn_cfb_catalog`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_catalog.md)
  [`catalog`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_catalog.md)
  [`awards`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_catalog.md)
  [`franchises`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_catalog.md)
  [`positions`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_catalog.md)
  [`clear_cache`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_catalog.md)
  :

  **ESPN College Football Catalog Endpoint Overview**

- [`espn_cfb_game`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game.md)
  [`game`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game.md)
  [`plays`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game.md)
  [`leaders`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game.md)
  :

  **ESPN College Football Game Endpoint Overview**

- [`espn_cfb_player()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player.md)
  :

  **ESPN College Football Player Endpoint Overview**

- [`espn_cfb_season`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_season.md)
  [`season`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_season.md)
  [`seasons`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_season.md)
  [`standings`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_season.md)
  [`rankings`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_season.md)
  :

  **ESPN College Football Season Endpoint Overview**

- [`espn_cfb_team()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team.md)
  :

  **ESPN College Football Team Endpoint Overview**

## cfbfastR Data

### Full Season Loaders

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

- [`cfbd_pbp_data_v2()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data_v2.md)
  :

  **Get college football play-by-play data — modular EPA/WPA pipeline
  (v2)**

## College Football Data API

### API Key Helpers

Functions for registering and inspecting your CollegeFootballData.com
API key.

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

  **CFBD Drives Endpoint Overview**

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

- [`cfbd_teams_fbs()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_teams_fbs.md)
  :

  **Get FBS teams**

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

- [`cfbd_player_season_overview()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_season_overview.md)
  :

  **Get a player season overview**

- [`cfbd_player_usage()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_usage.md)
  :

  **Get player usage metrics**

### Stats Data

Functions exported by cfbfastR sourced from the stats endpoint of the
CollegeFootballData API

- [`cfbd_stats`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats.md)
  :

  **CFBD Stats Endpoint Overview**

- [`cfbd_stats_categories()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_categories.md)
  :

  **Get stats categories**

- [`cfbd_stats_game_advanced()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_game_advanced.md)
  :

  **Get game advanced stats**

- [`cfbd_stats_game_havoc()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_game_havoc.md)
  :

  **Get game havoc statistics**

- [`cfbd_stats_player_success()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_player_success.md)
  :

  **Get player success rates by season**

- [`cfbd_stats_player_success_game()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_player_success_game.md)
  :

  **Get player success rates by game**

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
endpoints of the CollegeFootballData API

- [`cfbd_ratings`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings.md)
  :

  **CFBD Ratings and Rankings Endpoints Overview**

- [`cfbd_ratings_core()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_core.md)
  :

  **Get core team ratings**

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

- [`cfbd_ratings_srs_expanded()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_srs_expanded.md)
  :

  **Get expanded SRS ratings**

- [`cfbd_rankings()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_rankings.md)
  :

  **Get historical Coaches and AP poll data**

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

Functions exported by cfbfastR sourced from lines and betting endpoints
of the CollegeFootballData API

- [`cfbd_betting`](https://cfbfastR.sportsdataverse.org/reference/cfbd_betting.md)
  [`betting`](https://cfbfastR.sportsdataverse.org/reference/cfbd_betting.md)
  [`lines`](https://cfbfastR.sportsdataverse.org/reference/cfbd_betting.md)
  [`spreads`](https://cfbfastR.sportsdataverse.org/reference/cfbd_betting.md)
  :

  **CFBD Betting Endpoint Overview**

- [`cfbd_betting_ats()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_betting_ats.md)
  :

  **CFBD Against-the-Spread (ATS) Records**

- [`cfbd_betting_lines()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_betting_lines.md)
  :

  **CFBD Betting Lines Endpoint Overview**

### Metrics Data

Functions exported by cfbfastR sourced from the Predicted Points Added
(PPA) endpoints of the CollegeFootballData API

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

Functions exported by cfbfastR sourced from the recruiting endpoints of
the CollegeFootballData API

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

- [`cfbd_conference_affiliations()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_conference_affiliations.md)
  :

  **Get conference affiliations by team and season**

- [`cfbd_conference_changes()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_conference_changes.md)
  :

  **Get conference realignment changes**

- [`cfbd_conferences()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_conferences.md)
  :

  **CFBD Conferences Endpoint Overview**

- [`cfbd_coaches()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches.md)
  :

  **CFBD Coaches Endpoint Overview**

- [`cfbd_coaches_profile()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches_profile.md)
  :

  **Get a coach profile**

- [`cfbd_coaches_seasons()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches_seasons.md)
  :

  **Get coaching seasons**

- [`cfbd_coaches_tenures()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches_tenures.md)
  :

  **Get coaching tenures**

### Playoffs

College Football Playoff bracket, games, and participants

- [`cfbd_playoffs`](https://cfbfastR.sportsdataverse.org/reference/cfbd_playoffs.md)
  [`playoffs`](https://cfbfastR.sportsdataverse.org/reference/cfbd_playoffs.md)
  [`cfp`](https://cfbfastR.sportsdataverse.org/reference/cfbd_playoffs.md)
  :

  **CFBD Playoffs Endpoint Overview**

- [`cfbd_playoffs_cfp()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_playoffs_cfp.md)
  :

  **Get College Football Playoff bracket information**

- [`cfbd_playoffs_cfp_games()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_playoffs_cfp_games.md)
  :

  **Get College Football Playoff games**

- [`cfbd_playoffs_cfp_participants()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_playoffs_cfp_participants.md)
  :

  **Get College Football Playoff participants**

### API Info

CFBD API key usage and remaining quota

- [`cfbd_info`](https://cfbfastR.sportsdataverse.org/reference/cfbd_info.md)
  [`info`](https://cfbfastR.sportsdataverse.org/reference/cfbd_info.md)
  [`usage`](https://cfbfastR.sportsdataverse.org/reference/cfbd_info.md)
  :

  **CFBD Info Endpoint Overview**

- [`cfbd_info_usage()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_info_usage.md)
  :

  **Get API key usage information**

## Fox Sports Data

### Fox CFB – Read-only Bifrost wrappers

Fox Sports college-football endpoints (play-by-play, boxscore, odds,
roster, team stats, game log, standings, and statistical leaders)

- [`fox_cfb_boxscore()`](https://cfbfastR.sportsdataverse.org/reference/fox_cfb_boxscore.md)
  :

  **Get Fox Sports college football boxscore**

- [`fox_cfb_league_leaders()`](https://cfbfastR.sportsdataverse.org/reference/fox_cfb_league_leaders.md)
  :

  **Get Fox Sports college football statistical leaders**

- [`fox_cfb_odds()`](https://cfbfastR.sportsdataverse.org/reference/fox_cfb_odds.md)
  :

  **Get Fox Sports college football game odds**

- [`fox_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/fox_cfb_pbp.md)
  :

  **Get Fox Sports college football play-by-play**

- [`fox_cfb_standings()`](https://cfbfastR.sportsdataverse.org/reference/fox_cfb_standings.md)
  :

  **Get Fox Sports college football conference standings**

- [`fox_cfb_team_gamelog()`](https://cfbfastR.sportsdataverse.org/reference/fox_cfb_team_gamelog.md)
  :

  **Get Fox Sports college football team game log**

- [`fox_cfb_team_roster()`](https://cfbfastR.sportsdataverse.org/reference/fox_cfb_team_roster.md)
  :

  **Get Fox Sports college football team roster**

- [`fox_cfb_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/fox_cfb_team_stats.md)
  :

  **Get Fox Sports college football team stat leaders**

## ESPN Data

### ESPN CFB – Game data

Per-game ESPN endpoints (play-by-play, drives, plays, leaders,
predictor, situation, odds)

- [`espn_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp.md)
  : Get ESPN college football PBP data

- [`espn_cfb_pbp_v2()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp_v2.md)
  :

  **Get ESPN College Football Play-by-Play (core-v2)**

- [`espn_cfb_unnest_plays()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_unnest_plays.md)
  :

  **Unnest ESPN CFB drive plays into a flat play-by-play table**

- [`espn_cfb_game`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game.md)
  [`game`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game.md)
  [`plays`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game.md)
  [`leaders`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game.md)
  :

  **ESPN College Football Game Endpoint Overview**

- [`espn_cfb_game_broadcasts()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_broadcasts.md)
  :

  **ESPN College Football Game Broadcasts**

- [`espn_cfb_game_drive_plays()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_drive_plays.md)
  :

  **ESPN College Football Game Drive Plays**

- [`espn_cfb_game_drives()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_drives.md)
  :

  **ESPN College Football Game Drives**

- [`espn_cfb_game_leaders()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_leaders.md)
  :

  **ESPN College Football Game Leaders**

- [`espn_cfb_game_odds()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_odds.md)
  :

  **ESPN College Football Game Odds**

- [`espn_cfb_game_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_pbp.md)
  :

  **ESPN College Football Game Plays (Core-v2 Play-by-Play)**

- [`espn_cfb_game_play()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_play.md)
  :

  **ESPN College Football Game Play (Single Play Detail)**

- [`espn_cfb_game_player_box()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_player_box.md)
  :

  **ESPN College Football Game Player Box Score**

- [`espn_cfb_game_player_statistics()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_player_statistics.md)
  :

  **ESPN College Football Game Player Statistics (Single Athlete)**

- [`espn_cfb_game_powerindex()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_powerindex.md)
  :

  **ESPN College Football Game Power Index (Matchup FPI)**

- [`espn_cfb_game_predictor()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_predictor.md)
  :

  **ESPN College Football Game Predictor (BPI Matchup Predictor)**

- [`espn_cfb_game_probabilities()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_probabilities.md)
  :

  **ESPN College Football Game Win Probabilities**

- [`espn_cfb_game_situation()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_situation.md)
  :

  **ESPN College Football Game Situation**

- [`espn_cfb_game_status()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_status.md)
  :

  **ESPN College Football Game Status**

- [`espn_cfb_game_team_leaders()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_leaders.md)
  :

  **ESPN College Football Game Team Leaders**

- [`espn_cfb_game_team_linescores()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_linescores.md)
  :

  **ESPN College Football Game Team Linescores**

- [`espn_cfb_game_team_records()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_records.md)
  :

  **ESPN College Football Game Team Records**

- [`espn_cfb_game_team_roster()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_roster.md)
  :

  **ESPN College Football Game Team Roster**

- [`espn_cfb_game_team_statistics()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_statistics.md)
  :

  **ESPN College Football Game Team Statistics**

- [`espn_cfb_game_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_teams.md)
  :

  **ESPN College Football Game Teams**

### ESPN CFB – Schedule, scoreboard & calendar

Calendar, schedule, and scoreboard endpoints

- [`espn_cfb_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_scoreboard.md)
  [`espn_cfb_schedule()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_scoreboard.md)
  :

  **ESPN Scoreboard**

- [`espn_cfb_calendar()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_calendar.md)
  : ESPN Calendar

### ESPN CFB – Season metadata

Season, week, rankings, standings, and group endpoints

- [`espn_cfb_seasons()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_seasons.md)
  :

  **ESPN College Football Seasons Index**

- [`espn_cfb_season_info()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_season_info.md)
  :

  **ESPN College Football Season Detail**

- [`espn_cfb_season_types()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_season_types.md)
  :

  **ESPN College Football Season Types**

- [`espn_cfb_season_weeks()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_season_weeks.md)
  :

  **ESPN College Football Season Weeks**

- [`espn_cfb_week_rankings()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_week_rankings.md)
  :

  **ESPN College Football Weekly Rankings**

- [`espn_cfb_rankings()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_rankings.md)
  :

  **ESPN College Football Ranking Sources**

- [`espn_cfb_standings()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_standings.md)
  :

  **ESPN College Football Standings (Long Format)**

- [`espn_cfb_groups()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_groups.md)
  :

  **ESPN College Football Groups & Conferences**

### ESPN CFB – Team detail

Team-scoped catalog and detail endpoints

- [`espn_cfb_team()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team.md)
  :

  **ESPN College Football Team Endpoint Overview**

- [`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md)
  :

  **ESPN College Football Teams Index**

- [`espn_cfb_team_ats()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_ats.md)
  :

  **ESPN College Football Team Against-the-Spread Records**

- [`espn_cfb_team_awards()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_awards.md)
  :

  **ESPN College Football Team Awards**

- [`espn_cfb_team_coaches()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_coaches.md)
  :

  **ESPN College Football Team Coaches**

- [`espn_cfb_team_events()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_events.md)
  :

  **ESPN College Football Team Season Event Log**

- [`espn_cfb_team_leaders()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_leaders.md)
  :

  **ESPN College Football Team Statistical Leaders**

- [`espn_cfb_team_powerindex()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_powerindex.md)
  :

  **ESPN College Football Single-Team Power Index (Long Format)**

- [`espn_cfb_team_ranks()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_ranks.md)
  :

  **ESPN College Football Team Poll Rank History**

- [`espn_cfb_team_record()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_record.md)
  :

  **ESPN College Football Team Record (Long Format)**

- [`espn_cfb_team_roster()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_roster.md)
  :

  **ESPN College Football Team Roster (Season-Scoped)**

- [`espn_cfb_team_schedule()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_schedule.md)
  :

  **ESPN College Football Team Schedule**

- [`espn_cfb_team_stats()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_stats.md)
  :

  **Get ESPN college football team stats data**

### ESPN CFB – Athlete coverage

Player, position and recruit endpoints

- [`espn_cfb_player()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player.md)
  :

  **ESPN College Football Player Endpoint Overview**

- [`espn_cfb_players()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_players.md)
  :

  **ESPN College Football Players Index**

- [`espn_cfb_player_career_stats()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_career_stats.md)
  :

  **ESPN College Football Player Season Statistics (Long Format)**

- [`espn_cfb_player_eventlog()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_eventlog.md)
  :

  **ESPN College Football Player Event Log**

- [`espn_cfb_player_gamelog()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_gamelog.md)
  :

  **ESPN College Football Player Game Log**

- [`espn_cfb_player_overview()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_overview.md)
  :

  **ESPN College Football Player Statistics Overview**

- [`espn_cfb_player_seasons()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_seasons.md)
  :

  **ESPN College Football Player Seasons**

- [`espn_cfb_player_splits()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_splits.md)
  :

  **ESPN College Football Player Statistical Splits**

- [`espn_cfb_player_stats()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_stats.md)
  :

  **Get ESPN college football player stats data**

- [`espn_cfb_player_stats_v3()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_stats_v3.md)
  :

  **ESPN College Football Player Stats (web v3, all categories)**

- [`espn_cfb_position()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_position.md)
  :

  **ESPN College Football Position Detail**

- [`espn_cfb_positions()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_positions.md)
  :

  **ESPN College Football Positions Index**

- [`espn_cfb_recruits()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_recruits.md)
  :

  **ESPN College Football Recruits**

### ESPN CFB – Coaches & venues

Coach, coach record, and venue endpoints

- [`espn_cfb_coach()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_coach.md)
  :

  **ESPN College Football Coach Detail**

- [`espn_cfb_coaches()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_coaches.md)
  :

  **ESPN College Football Coaches Index**

- [`espn_cfb_coach_record()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_coach_record.md)
  :

  **ESPN College Football Coach Season Record**

- [`espn_cfb_venue()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_venue.md)
  :

  **ESPN College Football Venue Detail**

- [`espn_cfb_venues()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_venues.md)
  :

  **ESPN College Football Venues Index**

### ESPN CFB – Awards, futures & franchises

Award catalog, futures markets, and franchise records

- [`espn_cfb_award()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_award.md)
  :

  **ESPN College Football Award Detail**

- [`espn_cfb_awards()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_awards.md)
  :

  **ESPN College Football Awards**

- [`espn_cfb_franchise()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_franchise.md)
  :

  **ESPN College Football Franchise Detail**

- [`espn_cfb_franchises()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_franchises.md)
  :

  **ESPN College Football Franchises Index**

- [`espn_cfb_futures()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_futures.md)
  :

  **ESPN College Football Betting Futures (Long Format)**

### ESPN CFB – Metrics & ratings

Win probability, QBR, power index, and FPI ratings

- [`espn_metrics_wp()`](https://cfbfastR.sportsdataverse.org/reference/espn_metrics.md)
  :

  **ESPN Metrics**

- [`espn_ratings_fpi()`](https://cfbfastR.sportsdataverse.org/reference/espn_ratings_fpi.md)
  :

  **ESPN FPI Ratings**

- [`espn_cfb_qbr()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_qbr.md)
  :

  **ESPN College Football Total Quarterback Rating (QBR)**

- [`espn_cfb_powerindex()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_powerindex.md)
  :

  **ESPN College Football Power Index (Long Format)**

### ESPN CFB – Cache management

Catalog-cache management helpers

- [`espn_cfb_clear_cache()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_clear_cache.md)
  :

  **Clear the cfbfastR ESPN catalog cache**

## Yahoo Sports Data

### Yahoo CFB – Stats, scoreboard & boxscore

Yahoo Sports college-football endpoints (player/team season stats,
legacy per-category leaders, scoreboard, and boxscore scaffold),
wrapping Yahoo’s shangrila stats graph and editorial feed

- [`yahoo_cfb_boxscore()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_boxscore.md)
  :

  **Get Yahoo Sports college football boxscore (SCAFFOLD)**

- [`yahoo_cfb_player_season_stats()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_player_season_stats.md)
  :

  **Get Yahoo Sports college football player season stats (modern)**

- [`yahoo_cfb_player_season_stats_legacy()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_player_season_stats_legacy.md)
  :

  **Get Yahoo Sports CFB legacy per-category player leaders**

- [`yahoo_cfb_scoreboard()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_scoreboard.md)
  :

  **Get Yahoo Sports college football scoreboard**

- [`yahoo_cfb_team_season_stats()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_team_season_stats.md)
  :

  **Get Yahoo Sports college football team season stats (modern)**

- [`yahoo_cfb_team_season_stats_legacy()`](https://cfbfastR.sportsdataverse.org/reference/yahoo_cfb_team_season_stats_legacy.md)
  :

  **Get Yahoo Sports CFB legacy per-category team stats**

## Helper Functions and Data

### Included data

Data included within the package

- [`cfbd_play_type_df`](https://cfbfastR.sportsdataverse.org/reference/data.md)
  [`cfbd_conf_types_df`](https://cfbfastR.sportsdataverse.org/reference/data.md)
  :

  **Data in the package for reference**

### Model functions and PBP helpers

Expected points / win probability models and play-by-play parsing
helpers

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

Internal helpers used by cfbfastR

- [`csv_from_url()`](https://cfbfastR.sportsdataverse.org/reference/csv_from_url.md)
  :

  **Load .csv / .csv.gz file from a remote connection**

- [`rds_from_url()`](https://cfbfastR.sportsdataverse.org/reference/rds_from_url.md)
  : Load .rds file from a remote connection
