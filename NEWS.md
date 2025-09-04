# **cfbfastR v2.0.0**
* Added all new `cfbd_*()` functions accommodated by the new College Football Data API v2. This includes the following functions:

  - Added [```cfbd_metrics_fg_ep()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_fg_ep.html) function to access the new field goal expected points added metric from the API.
  - Added [```cfbd_metrics_wepa_team_season()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_team_season.html) function to access the new opponent adjusted team season predicted points added metric from the API.
  - Added [```cfbd_metrics_wepa_players_passing()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_passing.html) function to access the new opponent adjusted players passing predicted points added metric from the API.
  - Added [```cfbd_metrics_wepa_players_rushing()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_rushing.html) function to access the new opponent adjusted players rushing predicted points added metric from the API.
  - Added [```cfbd_metrics_wepa_players_kicking()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wepa_players_kicking.html) function to access the new  Points Added Above Replacement (PAAR) ratings for kickers from the API.
  - Added [```cfbd_ratings_fpi()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_fpi.html) function to access the new FPI ratings from the API.
  - Added [```cfbd_live_scoreboard()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_scoreboard.html) function to access live scoreboard data from the API.
  - Added [```cfbd_live_plays()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_live_plays.html) function to access live play-by-play data from the API.
  - Added [```cfbd_api_key_info()```](https://cfbfastR.sportsdataverse.org/reference/register_cfbd.html) function to get information about your API key, including your Patreon level and usage limits.

* Minor changes to the existing `cfbd_*()` functions under the hood to accommodate the new API v2 structure. Please see below for a list of all updated functions:

  - Updated [```cfbd_betting_lines()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_betting_lines.html) function
  - Updated [```cfbd_coaches()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_coaches.html) function
  - Updated [```cfbd_conferences()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_conferences.html) function
  - Updated [```cfbd_drives()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_drives.html) function
  - Updated [```cfbd_calendar()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_calendar.html) function
  - Updated [```cfbd_game_box_advanced()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_box_advanced.html) function
  - Updated [```cfbd_game_info()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.html) function
  - Updated [```cfbd_game_media()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_media.html) function
  - Updated [```cfbd_game_player_stats()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_player_stats.html) function
  - Updated [```cfbd_game_records()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_records.html) function
  - Updated [```cfbd_game_team_stats()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.html) function
  - Updated [```cfbd_metrics_ppa_games()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_games.html) function
  - Updated [```cfbd_metrics_ppa_players_games()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_games.html) function
  - Updated [```cfbd_metrics_ppa_players_season()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_season.html) function
  - Updated [```cfbd_metrics_ppa_predicted()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_predicted.html) function
  - Updated [```cfbd_metrics_ppa_teams()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_teams.html) function
  - Updated [```cfbd_metrics_wp()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp.html) function
  - Updated [```cfbd_metrics_wp_pregame()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_wp_pregame.html) function
  - Updated [```cfbd_pbp_data()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.html) function
  - Updated [```cfbd_play_stats_player()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_player.html) function
  - Updated [```cfbd_play_stats_types()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_types.html) function
  - Updated [```cfbd_play_types()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_types.html) function
  - Updated [```cfbd_plays()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_plays.html) function
  - Updated [```cfbd_player_info()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_info.html) function
  - Updated [```cfbd_player_returning()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_returning.html) function
  - Updated [```cfbd_player_usage()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_usage.html) function
  - Updated [```cfbd_rankings()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_rankings.html) function
  - Updated [```cfbd_ratings_sp()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_sp.html) function
  - Updated [```cfbd_ratings_sp_conference()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_sp_conference.html) function
  - Updated [```cfbd_ratings_srs()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_srs.html) function
  - Updated [```cfbd_recruiting_player()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_player.html) function
  - Updated [```cfbd_recruiting_position()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_position.html) function
  - Updated [```cfbd_recruiting_team()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_team.html) function
  - Updated [```cfbd_stats_categories()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_categories.html) function
  - Updated [```cfbd_stats_game_advanced()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_game_advanced.html) function
  - Updated [```cfbd_stats_season_advanced()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_advanced.html) function
  - Updated [```cfbd_stats_season_player()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_player.html) function
  - Updated [```cfbd_stats_season_team()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_team.html) function
  - Updated [```cfbd_team_info()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_info.html) function
  - Updated [```cfbd_team_matchup()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_matchup.html) function
  - Updated [```cfbd_team_matchup_records()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_matchup_records.html) function
  - Updated [```cfbd_team_roster()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_roster.html) function
  - Updated [```cfbd_team_talent()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_talent.html) function
  - Updated [```cfbd_venues()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_venues.html) function

* All `load_cfb_*()` functions now use [```sportsdataverse-data``` releases](https://github.com/sportsdataverse/sportsdataverse-data/releases/tag/cfbfastR_cfb_pbp) or the [CollegeFootballData.com API](https://api.collegefootballdata.com/) as their underlying data source to remain in compliance with CFBD API terms and conditions.

* Fixed the following functions and/or documentation:
  - Documentation [```cfbd_team_info()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_info.html) addressing #97
  - Ensuring [```cfbd_stats_game_advanced()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_game_advanced.html) returns an empty data frame when there are no results
  - Documentation [```cfbd_game_team_stats()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.html) updated to reflect all parameter requirement scenarios.
  - Fixed `athlete_id` parameter [```cfbd_player_usage()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_player_usage.html) so that it works as users would expect. There was an API query-parameter mismatch
  - Fixed `athlete_id` parameter for [```cfbd_play_stats_player()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_play_stats_player.html) function and added more thorough documentation.
  - Fixed returned `position` to correct value (instead of NA) from [```cfbd_stats_season_player()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_stats_season_player.html)
  - Added more thorough `season_type` parameter documentation across many functions
  - Changed behavior of [```cfbd_pbp_data()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.html) to substitute 3 timeouts per half when the data is missing from the API.
  

# **cfbfastR v1.9.5**
* fixed breaking bug related to `stringi` v1.8 update in [```cfbd_play_pbp_data()```](https://cfbfastr.sportsdataverse.org/reference/cfbd_pbp_data.html) EPA and WPA processing
* Minor documentation and test updates

# **cfbfastR v1.9.4**
* Improve date parsing for [```espn_cfb_scoreboard()```](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_scoreboard.html) and [```espn_cfb_schedule()```](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_schedule.html) functions while adding `lubridate` dependency
* Made a minor tweak to the returns of the [```espn_ratings_fpi()```](https://cfbfastR.sportsdataverse.org/reference/espn_ratings_fpi.html) function


# **cfbfastR v1.9.3**

* Add division parameter to the following functions: 
  - [```cfbd_game_info()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_info.html)
  - [```cfbd_plays()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_plays.html)
  - [```cfbd_drives()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_drives.html)
  - [```cfbd_game_media()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_media.html)
  - [```cfbd_game_team_stats()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_team_stats.html)

# **cfbfastR v1.9.2**

* [```espn_cfb_player_stats()```](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_stats.html) function added.

# **cfbfastR v1.9.1**

* Improved drive_pts logic in play-by-play data.
* Fixed an issue that occasionally made the `cfbd_game_team_stats()` function return data in a long format
* Minor documentation and test updates

# **cfbfastR v1.9.0**

#### Added functions to access ESPN API:

* [```espn_cfb_calendar()```](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_calendar.html)
* [```espn_cfb_schedule()```](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_scoreboard.html)
* Added EPA and WPA processing to [```espn_cfb_pbp()```](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp.html)
* [```espn_cfb_team_stats()```](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_stats.html)

#### Added functions to pull data from the data repo:

* [```load_cfb_rosters()```](https://cfbfastR.sportsdataverse.org/reference/load_cfb_rosters.html)
* [```load_cfb_schedules()```](https://cfbfastR.sportsdataverse.org/reference/load_cfb_schedules.html)
* [```load_cfb_teams()```](https://cfbfastR.sportsdataverse.org/reference/load_cfb_teams.html)

- Removes `furrr`, `future` dependencies, adds `Rcpp`, `RcppParallel`, and `purrr` dependencies


# **cfbfastR v1.8.0**

* All functions now default to return tibbles.
* Added S3 method to print outputs with data info and retrieval timestamps. Thank you to Tan Ho ([\@tanho36](https://github.com/tanho63)) for the idea.


# **cfbfastR v1.7.1**

* Added [```espn_ratings_fpi()```](https://cfbfastR.sportsdataverse.org/reference/espn_ratings_fpi.html) to exports.

# **cfbfastR v1.7.0**

* Added [```cfbd_recruiting_transfer_portal()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_transfer_portal.html).

# **cfbfastR v1.6.7**

* Fixed bug in `cfbd_game_team_stats()` with _allowed columns duplicating team stats instead of showing opponent stats.
* Updated tests and documentation for `cfbd_game_team_stats()`.

# **cfbfastR v1.6.6**

* Updated function `cfbd_pbp_data()` to account for additional timeout cases (namely, kickoffs/extra point attempts).

# **cfbfastR v1.6.5**

* Updated tests and documentation for `cfbd_betting_lines()`
* API call in `espn_ratings_fpi()` now requires headers in httr request

# **cfbfastR v1.6.4**

* Changed options to revert to old options on exit of function. 
* Removed check_github functions. 

# **cfbfastR v1.6.3**

* Switched package urls in DESCRIPTION again.

# **cfbfastR v1.6.2**

* Switched package urls in README and DESCRIPTION files to https://

# **cfbfastR v1.6.1**

* Removed source urls from many package documentation entries.
* Updated a test to skip on CRAN

# **cfbfastR v1.6.0**

* Added [```cfbd_ratings_elo()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_ratings_elo.html) function
* Fixed a bug in `update_cfb_db()` where the function failed when trying to load recent games from the data repo. (#35)
* Added the option `cfbfastR.dbdirectory` that allows to set the database directory in `update_cfb_db()` globally.

# **cfbfastR v1.5.2**

* Remove verbose parameter

# **cfbfastR v1.5.1**

##### **Minor release**
* Removed calculated columns from `cfbd_stats_season_team()` that were not behaving correctly
* Fixed bug where `only_fbs` input in `cfbd_team_info()` was ignored. It is now possible to get the team info for all the colleges in the API instead of only FBS schools.
* Removed default year from `cfbd_metrics_ppa_teams`. `cfbd_metrics_ppa_teams` and `cfbd_metrics_ppa_players_season` now require one of `team` or `year` to be specified

# **cfbfastR v1.5.0**

### Added [```espn_cfb_scoreboard()```](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_scoreboard.html)

### Added [```espn_cfb_pbp()```](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp.html)

# **cfbfastR v1.4.0**

### Added [```cfbd_game_weather()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_weather.html)

# **cfbfastR v1.3.3**

### Hotfix [```cfbd_game_player_stats()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_player_stats.html)

# **cfbfastR v1.3.2**

### Added ID linking to [```cfbd_recruiting_players()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_recruiting_player.html)

# **cfbfastR v1.3.0-1**

### Added three [NFL draft](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft.html) functions:
  - [```cfbd_draft_teams()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft_teams.html) - **Get list of NFL teams**
  - [```cfbd_draft_positions()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft_positions.html) - **Get list of NFL positions for mapping to collegiate**
  - [```cfbd_draft_picks()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft_picks.html) - **Get list of NFL Draft picks**

# **cfbfastR v1.2.1**

##### **Minor release**

* Added headshot_url to outputs of [```cfbd_team_roster()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_roster.html)

* Renamed returns in [```cfbd_game_box_advanced()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_game_box_advanced.html):
  - `rushing_line_yd_avg` to plural `rushing_line_yds_avg`
  - `rushing_second_lvl_yd_avg` to plural `rushing_second_lvl_yds_avg`
  - `rushing_open_field_yd_avg` to plural `rushing_open_field_yds_avg`

* Completed documentation for all returns except ```cfbd_pbp_data()```

* Continued work on intro vignette

# **cfbfastR v1.2.0-1**

#### **Add significant documentation to the package**

* Added mini-vignettes pertaining to CFB Data functionality:   
  - [```cfbd_betting```](https://cfbfastR.sportsdataverse.org/articles/cfbd_betting.html),
  - [```cfbd_games```](https://cfbfastR.sportsdataverse.org/articles/cfbd_games.html),
  - [```cfbd_plays```](https://cfbfastR.sportsdataverse.org/articles/cfbd_plays.html),    
  - [```cfbd_recruiting```](https://cfbfastR.sportsdataverse.org/articles/cfbd_recruiting.html),    
  - [```cfbd_stats```](https://cfbfastR.sportsdataverse.org/articles/cfbd_stats.html), 
  - [```cfbd_teams```](https://cfbfastR.sportsdataverse.org/articles/cfbd_teams.html)
  
* [Introductory vignette stub](https://cfbfastR.sportsdataverse.org/articles/intro.html) added

#### **ESPN/CFBD metrics function variable return standardization**

* Change `id` variable to `team_id` in [```espn_ratings_fpi()```](https://cfbfastR.sportsdataverse.org/reference/espn_ratings_fpi.html)
* Changed `espn_game_id` variable to `game_id` in [```espn_metrics_wp()```](https://cfbfastR.sportsdataverse.org/reference/espn_metrics.html), corrected the `away_win_percentage` calculation and added `tie_percentage` to the returns.
* Change `id` variable to `athlete_id` in [```cfbd_metrics_ppa_players_season()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_metrics_ppa_players_season.html)

# **cfbfastR v1.1.0**

#### **Add loading from Data Repository functionality**

* Added [```load_cfb_pbp()```](https://cfbfastR.sportsdataverse.org/reference/load_cfb_pbp.html) and [```update_cfb_db()```](https://cfbfastR.sportsdataverse.org/reference/update_cfb_db.html) functions. Pretty much cherry-picking the `nflfastR` methodology of loading data from the [`cfbfastR-data`](https://github.com/sportsdataverse/cfbfastR-data) repository. 

#### **Add support for parallel processing and progress updates**

* Added [```furrr```](https://furrr.futureverse.org/index.html), [```future```](https://future.futureverse.org/), and [```progressr```](https://progressr.futureverse.org/) dependencies to the package to allow for parallel processing of the play-by-play data with progress updates if desired. 

# **cfbfastR v1.0.0**

#### **Function Naming Convention Change**

* All functions sourced from the College Football Data API will start with `cfbd_` as opposed to `cfb_` (as in cfbscrapR). One additional `cfbd_` function has been added that corresponds to the result when [```cfbd_pbp_data()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.html) has the parameter `epa_wpa=FALSE`. It has now been separated into its own function for clarity [```cfbd_plays()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_play.html). The parameter and functionality still exists in [```cfbd_pbp_data()```](https://cfbfastR.sportsdataverse.org/reference/cfbd_pbp_data.html) but we expect this function will still exist but made obsolete in favor of a function more closely matching `nflfastR`'s naming conventions.

* Similarly, data and metrics sourced from ESPN will begin with `espn_` as opposed to `cfb_`. In particular, the two functions are now [```espn_ratings_fpi()```](https://cfbfastR.sportsdataverse.org/reference/espn_ratings_fpi.html) and [```espn_metrics_wp()```](https://cfbfastR.sportsdataverse.org/reference/espn_metrics.html)

* Data generated from any of the ```cfbfastR``` methods will use `cfb_`

#### **College Football Data API Keys**

The [CollegeFootballData API](https://collegefootballdata.com/) now requires an API key, here's a quick run-down:

* To get an API key, follow the directions here: [College Football Data Key Registration.](https://collegefootballdata.com/key) 

* Using the key: You can save the key for consistent usage by adding `CFBD_API_KEY=XXXX-YOUR-API-KEY-HERE-XXXXX` to your .Renviron file (easily accessed via [**`usethis::edit_r_environ()`**](https://usethis.r-lib.org/reference/edit.html)). Run [**`usethis::edit_r_environ()`**](https://usethis.r-lib.org/reference/edit.html), a new script will pop open named `.Renviron`, **THEN** paste the following in the new script that pops up (with**out** quotations)
```r
CFBD_API_KEY = XXXX-YOUR-API-KEY-HERE-XXXXX
```
Save the script and restart your RStudio session, by clicking `Session` (in between `Plots` and `Build`) and click `Restart R` (n.b. there also exists the shortcut `Ctrl + Shift + F10` to restart your session). If set correctly, from then on you should be able to use any of the `cfbd_` functions without any other changes.

* For less consistent usage: At the beginning of every session or within an R environment, save your API key as the environment variable `CFBD_API_KEY` (with quotations) using a command like the following.

```{r}
Sys.setenv(CFBD_API_KEY = "XXXX-YOUR-API-KEY-HERE-XXXXX")
```

* Added [API Key methods](https://cfbfastR.sportsdataverse.org/reference/register_cfbd.html). If you forget to set your environment variable, functions will give you a warning and ask for one. 
