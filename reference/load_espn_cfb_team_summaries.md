# **Load college football team season summaries from the SportsDataverse data repo**

Loads season-level team summaries – one row per team with the full
offense/defense/special-teams EPA and success-rate profile. Published to
the `espn_cfb_team_summaries` release tag on the sportsdataverse-data
repo.

## Usage

``` r
load_espn_cfb_team_summaries(
  seasons = most_recent_cfb_season(),
  ...,
  dbConnection = NULL,
  tablename = NULL
)
```

## Arguments

- seasons:

  A vector of 4-digit years associated with given college football
  seasons. Published coverage runs 2004 through the most recent season.
  Pass `seasons = TRUE` for every published season. (Min: 2004)

- ...:

  Additional arguments passed to an underlying function that writes the
  season data into a database.

- dbConnection:

  A `DBIConnection` object, as returned by
  [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html)

- tablename:

  The name of the data table within the database

## Value

Returns a `cfbfastR_data` tibble.

|  |  |  |
|----|----|----|
| col_name | types | description |
| team_id | integer |  |
| pos_team | character |  |
| division | character |  |
| conference | character |  |
| season | integer |  |
| plays_off | integer | Plays run, with the team on offense. |
| passrate_off | double | Share of plays that were pass plays, with the team on offense. |
| rushrate_off | double | Share of plays that were rush plays, with the team on offense. |
| havoc_off | double | Havoc rate – the share of plays carrying the defensive-disruption flag, with the team on offense. |
| explosive_off | double | Explosive-play rate – the share of plays carrying the explosive flag, with the team on offense. |
| TEPA_off | double | Total EPA summed over every play, with the team on offense. |
| EPAplay_off | double | EPA per play, with the team on offense. |
| yards_off | integer | Total yards gained, with the team on offense. |
| yardsplay_off | double | Yards gained per play, with the team on offense. |
| play_stuffed_off | double | Stuffed-play rate – the share of plays carrying the stuffed flag, with the team on offense. |
| success_off | double | Success rate – the share of plays flagged as successful by EPA, with the team on offense. |
| red_zone_success_off | double | Success rate on red-zone plays, with the team on offense. |
| third_down_success_off | double | Success rate on third-down plays, with the team on offense. |
| third_down_distance_off | double | Average yards to go on third down, with the team on offense. |
| late_down_success_off | double | Success rate on late-down plays, with the team on offense. |
| early_down_EPA_off | double | EPA per early-down play, with the team on offense. |
| start_position_off | double | Average drive start position, measured in yards from the opponent goal line, with the team on offense. |
| nonExplosiveEpaPerPlay_off | double | EPA per play with explosive plays excluded, with the team on offense. |
| line_yards_off | double | Average line yards credited to the offensive line on rushes, with the team on offense. |
| opportunity_rate_off | double | Opportunity rate – the share of rushes carrying the opportunity flag, with the team on offense. |
| playsgame_off | double | Plays run per game, with the team on offense. |
| EPAdrive_off | double | EPA per drive (total EPA divided by drives), with the team on offense. |
| EPAgame_off | double | EPA per game (total EPA divided by games), with the team on offense. |
| yardsgame_off | double | Yards gained per game, with the team on offense. |
| drives_off | integer | Offensive drives, with the team on offense. |
| drivesgame_off | double | Drives per game, with the team on offense. |
| yardsdrive_off | double | Yards gained per drive, with the team on offense. |
| playsdrive_off | double | Plays run per drive, with the team on offense. |
| playsgame_off_rank | double | National rank of the team's plays run per game with the team on offense, where 1 is best. |
| TEPA_off_rank | double | National rank of the team's total EPA summed over every play with the team on offense, where 1 is best. |
| EPAgame_off_rank | double | National rank of the team's EPA per game (total EPA divided by games) with the team on offense, where 1 is best. |
| EPAplay_off_rank | double | National rank of the team's EPA per play with the team on offense, where 1 is best. |
| EPAdrive_off_rank | double | National rank of the team's EPA per drive (total EPA divided by drives) with the team on offense, where 1 is best. |
| early_down_EPA_off_rank | double | National rank of the team's EPA per early-down play with the team on offense, where 1 is best. |
| success_off_rank | double | National rank of the team's success rate – the share of plays flagged as successful by EPA with the team on offense, where 1 is best. |
| yards_off_rank | double | National rank of the team's total yards gained with the team on offense, where 1 is best. |
| yardsplay_off_rank | double | National rank of the team's yards gained per play with the team on offense, where 1 is best. |
| yardsgame_off_rank | double | National rank of the team's yards gained per game with the team on offense, where 1 is best. |
| drivesgame_off_rank | double | National rank of the team's drives per game with the team on offense, where 1 is best. |
| yardsdrive_off_rank | double | National rank of the team's yards gained per drive with the team on offense, where 1 is best. |
| playsdrive_off_rank | double | National rank of the team's plays run per drive with the team on offense, where 1 is best. |
| play_stuffed_off_rank | double | National rank of the team's stuffed-play rate – the share of plays carrying the stuffed flag with the team on offense, where 1 is best. |
| red_zone_success_off_rank | double | National rank of the team's success rate on red-zone plays with the team on offense, where 1 is best. |
| third_down_success_off_rank | double | National rank of the team's success rate on third-down plays with the team on offense, where 1 is best. |
| late_down_success_off_rank | double | National rank of the team's success rate on late-down plays with the team on offense, where 1 is best. |
| third_down_distance_off_rank | double | National rank of the team's average yards to go on third down with the team on offense, where 1 is best. |
| start_position_off_rank | double | National rank of the team's average drive start position, measured in yards from the opponent goal line with the team on offense, where 1 is best. |
| havoc_off_rank | double | National rank of the team's havoc rate – the share of plays carrying the defensive-disruption flag with the team on offense, where 1 is best. |
| explosive_off_rank | double | National rank of the team's explosive-play rate – the share of plays carrying the explosive flag with the team on offense, where 1 is best. |
| passrate_off_rank | double | National rank of the team's share of plays that were pass plays with the team on offense, where 1 is best. |
| rushrate_off_rank | double | National rank of the team's share of plays that were rush plays with the team on offense, where 1 is best. |
| nonExplosiveEpaPerPlay_off_rank | double | National rank of the team's EPA per play with explosive plays excluded with the team on offense, where 1 is best. |
| line_yards_off_rank | double | National rank of the team's average line yards credited to the offensive line on rushes with the team on offense, where 1 is best. |
| opportunity_rate_off_rank | double | National rank of the team's opportunity rate – the share of rushes carrying the opportunity flag with the team on offense, where 1 is best. |
| plays_def | integer | Plays run, with the team on defense (i.e. allowed to opponents). |
| passrate_def | double | Share of plays that were pass plays, with the team on defense (i.e. allowed to opponents). |
| rushrate_def | double | Share of plays that were rush plays, with the team on defense (i.e. allowed to opponents). |
| havoc_def | double | Havoc rate – the share of plays carrying the defensive-disruption flag, with the team on defense (i.e. allowed to opponents). |
| explosive_def | double | Explosive-play rate – the share of plays carrying the explosive flag, with the team on defense (i.e. allowed to opponents). |
| TEPA_def | double | Total EPA summed over every play, with the team on defense (i.e. allowed to opponents). |
| EPAplay_def | double | EPA per play, with the team on defense (i.e. allowed to opponents). |
| yards_def | integer | Total yards gained, with the team on defense (i.e. allowed to opponents). |
| yardsplay_def | double | Yards gained per play, with the team on defense (i.e. allowed to opponents). |
| play_stuffed_def | double | Stuffed-play rate – the share of plays carrying the stuffed flag, with the team on defense (i.e. allowed to opponents). |
| success_def | double | Success rate – the share of plays flagged as successful by EPA, with the team on defense (i.e. allowed to opponents). |
| red_zone_success_def | double | Success rate on red-zone plays, with the team on defense (i.e. allowed to opponents). |
| third_down_success_def | double | Success rate on third-down plays, with the team on defense (i.e. allowed to opponents). |
| third_down_distance_def | double | Average yards to go on third down, with the team on defense (i.e. allowed to opponents). |
| late_down_success_def | double | Success rate on late-down plays, with the team on defense (i.e. allowed to opponents). |
| early_down_EPA_def | double | EPA per early-down play, with the team on defense (i.e. allowed to opponents). |
| start_position_def | double | Average drive start position, measured in yards from the opponent goal line, with the team on defense (i.e. allowed to opponents). |
| nonExplosiveEpaPerPlay_def | double | EPA per play with explosive plays excluded, with the team on defense (i.e. allowed to opponents). |
| line_yards_def | double | Average line yards credited to the offensive line on rushes, with the team on defense (i.e. allowed to opponents). |
| opportunity_rate_def | double | Opportunity rate – the share of rushes carrying the opportunity flag, with the team on defense (i.e. allowed to opponents). |
| playsgame_def | double | Plays run per game, with the team on defense (i.e. allowed to opponents). |
| EPAdrive_def | double | EPA per drive (total EPA divided by drives), with the team on defense (i.e. allowed to opponents). |
| EPAgame_def | double | EPA per game (total EPA divided by games), with the team on defense (i.e. allowed to opponents). |
| yardsgame_def | double | Yards gained per game, with the team on defense (i.e. allowed to opponents). |
| drives_def | integer | Offensive drives, with the team on defense (i.e. allowed to opponents). |
| drivesgame_def | double | Drives per game, with the team on defense (i.e. allowed to opponents). |
| yardsdrive_def | double | Yards gained per drive, with the team on defense (i.e. allowed to opponents). |
| playsdrive_def | double | Plays run per drive, with the team on defense (i.e. allowed to opponents). |
| playsgame_def_rank | double | National rank of the team's plays run per game with the team on defense (i.e. allowed to opponents), where 1 is best. |
| TEPA_def_rank | double | National rank of the team's total EPA summed over every play with the team on defense (i.e. allowed to opponents), where 1 is best. |
| EPAgame_def_rank | double | National rank of the team's EPA per game (total EPA divided by games) with the team on defense (i.e. allowed to opponents), where 1 is best. |
| EPAplay_def_rank | double | National rank of the team's EPA per play with the team on defense (i.e. allowed to opponents), where 1 is best. |
| EPAdrive_def_rank | double | National rank of the team's EPA per drive (total EPA divided by drives) with the team on defense (i.e. allowed to opponents), where 1 is best. |
| early_down_EPA_def_rank | double | National rank of the team's EPA per early-down play with the team on defense (i.e. allowed to opponents), where 1 is best. |
| success_def_rank | double | National rank of the team's success rate – the share of plays flagged as successful by EPA with the team on defense (i.e. allowed to opponents), where 1 is best. |
| yards_def_rank | double | National rank of the team's total yards gained with the team on defense (i.e. allowed to opponents), where 1 is best. |
| yardsplay_def_rank | double | National rank of the team's yards gained per play with the team on defense (i.e. allowed to opponents), where 1 is best. |
| yardsgame_def_rank | double | National rank of the team's yards gained per game with the team on defense (i.e. allowed to opponents), where 1 is best. |
| drivesgame_def_rank | double | National rank of the team's drives per game with the team on defense (i.e. allowed to opponents), where 1 is best. |
| yardsdrive_def_rank | double | National rank of the team's yards gained per drive with the team on defense (i.e. allowed to opponents), where 1 is best. |
| playsdrive_def_rank | double | National rank of the team's plays run per drive with the team on defense (i.e. allowed to opponents), where 1 is best. |
| play_stuffed_def_rank | double | National rank of the team's stuffed-play rate – the share of plays carrying the stuffed flag with the team on defense (i.e. allowed to opponents), where 1 is best. |
| red_zone_success_def_rank | double | National rank of the team's success rate on red-zone plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| third_down_success_def_rank | double | National rank of the team's success rate on third-down plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| late_down_success_def_rank | double | National rank of the team's success rate on late-down plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| third_down_distance_def_rank | double | National rank of the team's average yards to go on third down with the team on defense (i.e. allowed to opponents), where 1 is best. |
| start_position_def_rank | double | National rank of the team's average drive start position, measured in yards from the opponent goal line with the team on defense (i.e. allowed to opponents), where 1 is best. |
| havoc_def_rank | double | National rank of the team's havoc rate – the share of plays carrying the defensive-disruption flag with the team on defense (i.e. allowed to opponents), where 1 is best. |
| explosive_def_rank | double | National rank of the team's explosive-play rate – the share of plays carrying the explosive flag with the team on defense (i.e. allowed to opponents), where 1 is best. |
| passrate_def_rank | double | National rank of the team's share of plays that were pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| rushrate_def_rank | double | National rank of the team's share of plays that were rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| nonExplosiveEpaPerPlay_def_rank | double | National rank of the team's EPA per play with explosive plays excluded with the team on defense (i.e. allowed to opponents), where 1 is best. |
| line_yards_def_rank | double | National rank of the team's average line yards credited to the offensive line on rushes with the team on defense (i.e. allowed to opponents), where 1 is best. |
| opportunity_rate_def_rank | double | National rank of the team's opportunity rate – the share of rushes carrying the opportunity flag with the team on defense (i.e. allowed to opponents), where 1 is best. |
| TEPA_margin | double | Margin in total EPA summed over every play: the team's offensive value minus the value it allowed on defense. |
| EPAplay_margin | double | Margin in EPA per play: the team's offensive value minus the value it allowed on defense. |
| EPAdrive_margin | double | Margin in EPA per drive (total EPA divided by drives): the team's offensive value minus the value it allowed on defense. |
| EPAgame_margin | double | Margin in EPA per game (total EPA divided by games): the team's offensive value minus the value it allowed on defense. |
| success_margin | double | Margin in success rate – the share of plays flagged as successful by EPA: the team's offensive value minus the value it allowed on defense. |
| yardsplay_margin | double | Margin in yards gained per play: the team's offensive value minus the value it allowed on defense. |
| TEPA_margin_rank | double | Margin in total EPA summed over every play: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
| EPAplay_margin_rank | double | Margin in EPA per play: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
| EPAdrive_margin_rank | double | Margin in EPA per drive (total EPA divided by drives): the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
| EPAgame_margin_rank | double | Margin in EPA per game (total EPA divided by games): the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
| success_margin_rank | double | Margin in success rate – the share of plays flagged as successful by EPA: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
| yardsplay_margin_rank | double | Margin in yards gained per play: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
| start_position_margin | double | Field-position margin: the team's own average starting field position minus the average starting field position it allowed, both measured as yards gained from their own goal line. Positive means the team started closer to scoring than its opponents. |
| start_position_margin_rank | double | Field-position margin: the team's own average starting field position minus the average starting field position it allowed, both measured as yards gained from their own goal line. Positive means the team started closer to scoring than its opponents. National rank of that margin, 1 = largest. |
| total_available_yards_off | double | Available yards are the yards a drive could theoretically gain, summed from each drive's starting distance to the opponent goal line. Total available yards on the team's own drives. |
| total_gained_yards_off | integer | Total yards the team actually gained across its own drives. |
| available_yards_pct_off | double | Share of available yards the team's offense actually gained (total_gained_yards_off divided by total_available_yards_off). Higher is better. |
| available_yards_pct_off_rank | double | National rank of the team's offensive available-yards share, where 1 is best. |
| total_available_yards_def | double | Available yards are the yards a drive could theoretically gain, summed from each drive's starting distance to the opponent goal line. Total available yards on drives the team defended. |
| total_gained_yards_def | integer | Total yards the team allowed across the drives it defended. |
| available_yards_pct_def | double | Share of available yards the team's defense allowed opponents to gain. Lower is better. |
| available_yards_pct_def_rank | double | National rank of the team's defensive available-yards share, where 1 is best. |
| total_available_yards_margin | double | Available yards on the team's own drives minus available yards on drives it defended. |
| total_gained_yards_margin | integer | Yards the team gained minus yards it allowed. |
| available_yards_pct_margin | double | Available-yards share gained by the offense minus the share allowed by the defense. Higher is better. |
| total_available_yards_margin_rank | double | National rank of total_available_yards_margin, 1 = largest margin. |
| total_gained_yards_margin_rank | double | National rank of total_gained_yards_margin, 1 = largest margin. |
| available_yards_pct_margin_rank | double | National rank of available_yards_pct_margin, 1 = largest margin. |
| plays_off_pass | integer | Plays run on pass plays, with the team on offense. |
| passrate_off_pass | double | Share of plays that were pass plays on pass plays, with the team on offense. |
| rushrate_off_pass | double | Share of plays that were rush plays on pass plays, with the team on offense. |
| havoc_off_pass | double | Havoc rate – the share of plays carrying the defensive-disruption flag on pass plays, with the team on offense. |
| explosive_off_pass | double | Explosive-play rate – the share of plays carrying the explosive flag on pass plays, with the team on offense. |
| TEPA_off_pass | double | Total EPA summed over every play on pass plays, with the team on offense. |
| EPAplay_off_pass | double | EPA per play on pass plays, with the team on offense. |
| yards_off_pass | integer | Total yards gained on pass plays, with the team on offense. |
| yardsplay_off_pass | double | Yards gained per play on pass plays, with the team on offense. |
| play_stuffed_off_pass | double | Stuffed-play rate – the share of plays carrying the stuffed flag on pass plays, with the team on offense. |
| success_off_pass | double | Success rate – the share of plays flagged as successful by EPA on pass plays, with the team on offense. |
| red_zone_success_off_pass | double | Success rate on red-zone plays on pass plays, with the team on offense. |
| third_down_success_off_pass | double | Success rate on third-down plays on pass plays, with the team on offense. |
| third_down_distance_off_pass | double | Average yards to go on third down on pass plays, with the team on offense. |
| late_down_success_off_pass | double | Success rate on late-down plays on pass plays, with the team on offense. |
| early_down_EPA_off_pass | double | EPA per early-down play on pass plays, with the team on offense. |
| nonExplosiveEpaPerPlay_off_pass | double | EPA per play with explosive plays excluded on pass plays, with the team on offense. |
| line_yards_off_pass | double | Average line yards credited to the offensive line on rushes on pass plays, with the team on offense. |
| opportunity_rate_off_pass | double | Opportunity rate – the share of rushes carrying the opportunity flag on pass plays, with the team on offense. |
| playsgame_off_pass | double | Plays run per game on pass plays, with the team on offense. |
| EPAdrive_off_pass | double | EPA per drive (total EPA divided by drives) on pass plays, with the team on offense. |
| EPAgame_off_pass | double | EPA per game (total EPA divided by games) on pass plays, with the team on offense. |
| yardsgame_off_pass | double | Yards gained per game on pass plays, with the team on offense. |
| drives_off_pass | integer | Offensive drives on pass plays, with the team on offense. |
| drivesgame_off_pass | double | Drives per game on pass plays, with the team on offense. |
| yardsdrive_off_pass | double | Yards gained per drive on pass plays, with the team on offense. |
| playsdrive_off_pass | double | Plays run per drive on pass plays, with the team on offense. |
| playsgame_off_pass_rank | double | National rank of the team's plays run per game on pass plays with the team on offense, where 1 is best. |
| TEPA_off_pass_rank | double | National rank of the team's total EPA summed over every play on pass plays with the team on offense, where 1 is best. |
| EPAgame_off_pass_rank | double | National rank of the team's EPA per game (total EPA divided by games) on pass plays with the team on offense, where 1 is best. |
| EPAplay_off_pass_rank | double | National rank of the team's EPA per play on pass plays with the team on offense, where 1 is best. |
| EPAdrive_off_pass_rank | double | National rank of the team's EPA per drive (total EPA divided by drives) on pass plays with the team on offense, where 1 is best. |
| early_down_EPA_off_pass_rank | double | National rank of the team's EPA per early-down play on pass plays with the team on offense, where 1 is best. |
| success_off_pass_rank | double | National rank of the team's success rate – the share of plays flagged as successful by EPA on pass plays with the team on offense, where 1 is best. |
| yards_off_pass_rank | double | National rank of the team's total yards gained on pass plays with the team on offense, where 1 is best. |
| yardsplay_off_pass_rank | double | National rank of the team's yards gained per play on pass plays with the team on offense, where 1 is best. |
| yardsgame_off_pass_rank | double | National rank of the team's yards gained per game on pass plays with the team on offense, where 1 is best. |
| drivesgame_off_pass_rank | double | National rank of the team's drives per game on pass plays with the team on offense, where 1 is best. |
| yardsdrive_off_pass_rank | double | National rank of the team's yards gained per drive on pass plays with the team on offense, where 1 is best. |
| playsdrive_off_pass_rank | double | National rank of the team's plays run per drive on pass plays with the team on offense, where 1 is best. |
| play_stuffed_off_pass_rank | double | National rank of the team's stuffed-play rate – the share of plays carrying the stuffed flag on pass plays with the team on offense, where 1 is best. |
| red_zone_success_off_pass_rank | double | National rank of the team's success rate on red-zone plays on pass plays with the team on offense, where 1 is best. |
| third_down_success_off_pass_rank | double | National rank of the team's success rate on third-down plays on pass plays with the team on offense, where 1 is best. |
| late_down_success_off_pass_rank | double | National rank of the team's success rate on late-down plays on pass plays with the team on offense, where 1 is best. |
| third_down_distance_off_pass_rank | double | National rank of the team's average yards to go on third down on pass plays with the team on offense, where 1 is best. |
| havoc_off_pass_rank | double | National rank of the team's havoc rate – the share of plays carrying the defensive-disruption flag on pass plays with the team on offense, where 1 is best. |
| explosive_off_pass_rank | double | National rank of the team's explosive-play rate – the share of plays carrying the explosive flag on pass plays with the team on offense, where 1 is best. |
| passrate_off_pass_rank | double | National rank of the team's share of plays that were pass plays on pass plays with the team on offense, where 1 is best. |
| rushrate_off_pass_rank | double | National rank of the team's share of plays that were rush plays on pass plays with the team on offense, where 1 is best. |
| nonExplosiveEpaPerPlay_off_pass_rank | double | National rank of the team's EPA per play with explosive plays excluded on pass plays with the team on offense, where 1 is best. |
| line_yards_off_pass_rank | double | National rank of the team's average line yards credited to the offensive line on rushes on pass plays with the team on offense, where 1 is best. |
| opportunity_rate_off_pass_rank | double | National rank of the team's opportunity rate – the share of rushes carrying the opportunity flag on pass plays with the team on offense, where 1 is best. |
| plays_def_pass | integer | Plays run on pass plays, with the team on defense (i.e. allowed to opponents). |
| passrate_def_pass | double | Share of plays that were pass plays on pass plays, with the team on defense (i.e. allowed to opponents). |
| rushrate_def_pass | double | Share of plays that were rush plays on pass plays, with the team on defense (i.e. allowed to opponents). |
| havoc_def_pass | double | Havoc rate – the share of plays carrying the defensive-disruption flag on pass plays, with the team on defense (i.e. allowed to opponents). |
| explosive_def_pass | double | Explosive-play rate – the share of plays carrying the explosive flag on pass plays, with the team on defense (i.e. allowed to opponents). |
| TEPA_def_pass | double | Total EPA summed over every play on pass plays, with the team on defense (i.e. allowed to opponents). |
| EPAplay_def_pass | double | EPA per play on pass plays, with the team on defense (i.e. allowed to opponents). |
| yards_def_pass | integer | Total yards gained on pass plays, with the team on defense (i.e. allowed to opponents). |
| yardsplay_def_pass | double | Yards gained per play on pass plays, with the team on defense (i.e. allowed to opponents). |
| play_stuffed_def_pass | double | Stuffed-play rate – the share of plays carrying the stuffed flag on pass plays, with the team on defense (i.e. allowed to opponents). |
| success_def_pass | double | Success rate – the share of plays flagged as successful by EPA on pass plays, with the team on defense (i.e. allowed to opponents). |
| red_zone_success_def_pass | double | Success rate on red-zone plays on pass plays, with the team on defense (i.e. allowed to opponents). |
| third_down_success_def_pass | double | Success rate on third-down plays on pass plays, with the team on defense (i.e. allowed to opponents). |
| third_down_distance_def_pass | double | Average yards to go on third down on pass plays, with the team on defense (i.e. allowed to opponents). |
| late_down_success_def_pass | double | Success rate on late-down plays on pass plays, with the team on defense (i.e. allowed to opponents). |
| early_down_EPA_def_pass | double | EPA per early-down play on pass plays, with the team on defense (i.e. allowed to opponents). |
| nonExplosiveEpaPerPlay_def_pass | double | EPA per play with explosive plays excluded on pass plays, with the team on defense (i.e. allowed to opponents). |
| line_yards_def_pass | double | Average line yards credited to the offensive line on rushes on pass plays, with the team on defense (i.e. allowed to opponents). |
| opportunity_rate_def_pass | double | Opportunity rate – the share of rushes carrying the opportunity flag on pass plays, with the team on defense (i.e. allowed to opponents). |
| playsgame_def_pass | double | Plays run per game on pass plays, with the team on defense (i.e. allowed to opponents). |
| EPAdrive_def_pass | double | EPA per drive (total EPA divided by drives) on pass plays, with the team on defense (i.e. allowed to opponents). |
| EPAgame_def_pass | double | EPA per game (total EPA divided by games) on pass plays, with the team on defense (i.e. allowed to opponents). |
| yardsgame_def_pass | double | Yards gained per game on pass plays, with the team on defense (i.e. allowed to opponents). |
| drives_def_pass | integer | Offensive drives on pass plays, with the team on defense (i.e. allowed to opponents). |
| drivesgame_def_pass | double | Drives per game on pass plays, with the team on defense (i.e. allowed to opponents). |
| yardsdrive_def_pass | double | Yards gained per drive on pass plays, with the team on defense (i.e. allowed to opponents). |
| playsdrive_def_pass | double | Plays run per drive on pass plays, with the team on defense (i.e. allowed to opponents). |
| playsgame_def_pass_rank | double | National rank of the team's plays run per game on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| TEPA_def_pass_rank | double | National rank of the team's total EPA summed over every play on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| EPAgame_def_pass_rank | double | National rank of the team's EPA per game (total EPA divided by games) on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| EPAplay_def_pass_rank | double | National rank of the team's EPA per play on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| EPAdrive_def_pass_rank | double | National rank of the team's EPA per drive (total EPA divided by drives) on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| early_down_EPA_def_pass_rank | double | National rank of the team's EPA per early-down play on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| success_def_pass_rank | double | National rank of the team's success rate – the share of plays flagged as successful by EPA on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| yards_def_pass_rank | double | National rank of the team's total yards gained on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| yardsplay_def_pass_rank | double | National rank of the team's yards gained per play on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| yardsgame_def_pass_rank | double | National rank of the team's yards gained per game on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| drivesgame_def_pass_rank | double | National rank of the team's drives per game on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| yardsdrive_def_pass_rank | double | National rank of the team's yards gained per drive on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| playsdrive_def_pass_rank | double | National rank of the team's plays run per drive on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| play_stuffed_def_pass_rank | double | National rank of the team's stuffed-play rate – the share of plays carrying the stuffed flag on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| red_zone_success_def_pass_rank | double | National rank of the team's success rate on red-zone plays on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| third_down_success_def_pass_rank | double | National rank of the team's success rate on third-down plays on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| late_down_success_def_pass_rank | double | National rank of the team's success rate on late-down plays on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| third_down_distance_def_pass_rank | double | National rank of the team's average yards to go on third down on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| havoc_def_pass_rank | double | National rank of the team's havoc rate – the share of plays carrying the defensive-disruption flag on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| explosive_def_pass_rank | double | National rank of the team's explosive-play rate – the share of plays carrying the explosive flag on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| passrate_def_pass_rank | double | National rank of the team's share of plays that were pass plays on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| rushrate_def_pass_rank | double | National rank of the team's share of plays that were rush plays on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| nonExplosiveEpaPerPlay_def_pass_rank | double | National rank of the team's EPA per play with explosive plays excluded on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| line_yards_def_pass_rank | double | National rank of the team's average line yards credited to the offensive line on rushes on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| opportunity_rate_def_pass_rank | double | National rank of the team's opportunity rate – the share of rushes carrying the opportunity flag on pass plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| TEPA_margin_pass | double | Margin in total EPA summed over every play on pass plays: the team's offensive value minus the value it allowed on defense. |
| EPAplay_margin_pass | double | Margin in EPA per play on pass plays: the team's offensive value minus the value it allowed on defense. |
| EPAdrive_margin_pass | double | Margin in EPA per drive (total EPA divided by drives) on pass plays: the team's offensive value minus the value it allowed on defense. |
| EPAgame_margin_pass | double | Margin in EPA per game (total EPA divided by games) on pass plays: the team's offensive value minus the value it allowed on defense. |
| success_margin_pass | double | Margin in success rate – the share of plays flagged as successful by EPA on pass plays: the team's offensive value minus the value it allowed on defense. |
| yardsplay_margin_pass | double | Margin in yards gained per play on pass plays: the team's offensive value minus the value it allowed on defense. |
| TEPA_margin_pass_rank | double | Margin in total EPA summed over every play on pass plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
| EPAplay_margin_pass_rank | double | Margin in EPA per play on pass plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
| EPAdrive_margin_pass_rank | double | Margin in EPA per drive (total EPA divided by drives) on pass plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
| EPAgame_margin_pass_rank | double | Margin in EPA per game (total EPA divided by games) on pass plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
| success_margin_pass_rank | double | Margin in success rate – the share of plays flagged as successful by EPA on pass plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
| yardsplay_margin_pass_rank | double | Margin in yards gained per play on pass plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
| plays_off_rush | integer | Plays run on rush plays, with the team on offense. |
| passrate_off_rush | double | Share of plays that were pass plays on rush plays, with the team on offense. |
| rushrate_off_rush | double | Share of plays that were rush plays on rush plays, with the team on offense. |
| havoc_off_rush | double | Havoc rate – the share of plays carrying the defensive-disruption flag on rush plays, with the team on offense. |
| explosive_off_rush | double | Explosive-play rate – the share of plays carrying the explosive flag on rush plays, with the team on offense. |
| TEPA_off_rush | double | Total EPA summed over every play on rush plays, with the team on offense. |
| EPAplay_off_rush | double | EPA per play on rush plays, with the team on offense. |
| yards_off_rush | integer | Total yards gained on rush plays, with the team on offense. |
| yardsplay_off_rush | double | Yards gained per play on rush plays, with the team on offense. |
| play_stuffed_off_rush | double | Stuffed-play rate – the share of plays carrying the stuffed flag on rush plays, with the team on offense. |
| success_off_rush | double | Success rate – the share of plays flagged as successful by EPA on rush plays, with the team on offense. |
| red_zone_success_off_rush | double | Success rate on red-zone plays on rush plays, with the team on offense. |
| third_down_success_off_rush | double | Success rate on third-down plays on rush plays, with the team on offense. |
| third_down_distance_off_rush | double | Average yards to go on third down on rush plays, with the team on offense. |
| late_down_success_off_rush | double | Success rate on late-down plays on rush plays, with the team on offense. |
| early_down_EPA_off_rush | double | EPA per early-down play on rush plays, with the team on offense. |
| nonExplosiveEpaPerPlay_off_rush | double | EPA per play with explosive plays excluded on rush plays, with the team on offense. |
| line_yards_off_rush | double | Average line yards credited to the offensive line on rushes on rush plays, with the team on offense. |
| opportunity_rate_off_rush | double | Opportunity rate – the share of rushes carrying the opportunity flag on rush plays, with the team on offense. |
| playsgame_off_rush | double | Plays run per game on rush plays, with the team on offense. |
| EPAdrive_off_rush | double | EPA per drive (total EPA divided by drives) on rush plays, with the team on offense. |
| EPAgame_off_rush | double | EPA per game (total EPA divided by games) on rush plays, with the team on offense. |
| yardsgame_off_rush | double | Yards gained per game on rush plays, with the team on offense. |
| drives_off_rush | integer | Offensive drives on rush plays, with the team on offense. |
| drivesgame_off_rush | double | Drives per game on rush plays, with the team on offense. |
| yardsdrive_off_rush | double | Yards gained per drive on rush plays, with the team on offense. |
| playsdrive_off_rush | double | Plays run per drive on rush plays, with the team on offense. |
| playsgame_off_rush_rank | double | National rank of the team's plays run per game on rush plays with the team on offense, where 1 is best. |
| TEPA_off_rush_rank | double | National rank of the team's total EPA summed over every play on rush plays with the team on offense, where 1 is best. |
| EPAgame_off_rush_rank | double | National rank of the team's EPA per game (total EPA divided by games) on rush plays with the team on offense, where 1 is best. |
| EPAplay_off_rush_rank | double | National rank of the team's EPA per play on rush plays with the team on offense, where 1 is best. |
| EPAdrive_off_rush_rank | double | National rank of the team's EPA per drive (total EPA divided by drives) on rush plays with the team on offense, where 1 is best. |
| early_down_EPA_off_rush_rank | double | National rank of the team's EPA per early-down play on rush plays with the team on offense, where 1 is best. |
| success_off_rush_rank | double | National rank of the team's success rate – the share of plays flagged as successful by EPA on rush plays with the team on offense, where 1 is best. |
| yards_off_rush_rank | double | National rank of the team's total yards gained on rush plays with the team on offense, where 1 is best. |
| yardsplay_off_rush_rank | double | National rank of the team's yards gained per play on rush plays with the team on offense, where 1 is best. |
| yardsgame_off_rush_rank | double | National rank of the team's yards gained per game on rush plays with the team on offense, where 1 is best. |
| drivesgame_off_rush_rank | double | National rank of the team's drives per game on rush plays with the team on offense, where 1 is best. |
| yardsdrive_off_rush_rank | double | National rank of the team's yards gained per drive on rush plays with the team on offense, where 1 is best. |
| playsdrive_off_rush_rank | double | National rank of the team's plays run per drive on rush plays with the team on offense, where 1 is best. |
| play_stuffed_off_rush_rank | double | National rank of the team's stuffed-play rate – the share of plays carrying the stuffed flag on rush plays with the team on offense, where 1 is best. |
| red_zone_success_off_rush_rank | double | National rank of the team's success rate on red-zone plays on rush plays with the team on offense, where 1 is best. |
| third_down_success_off_rush_rank | double | National rank of the team's success rate on third-down plays on rush plays with the team on offense, where 1 is best. |
| late_down_success_off_rush_rank | double | National rank of the team's success rate on late-down plays on rush plays with the team on offense, where 1 is best. |
| third_down_distance_off_rush_rank | double | National rank of the team's average yards to go on third down on rush plays with the team on offense, where 1 is best. |
| havoc_off_rush_rank | double | National rank of the team's havoc rate – the share of plays carrying the defensive-disruption flag on rush plays with the team on offense, where 1 is best. |
| explosive_off_rush_rank | double | National rank of the team's explosive-play rate – the share of plays carrying the explosive flag on rush plays with the team on offense, where 1 is best. |
| passrate_off_rush_rank | double | National rank of the team's share of plays that were pass plays on rush plays with the team on offense, where 1 is best. |
| rushrate_off_rush_rank | double | National rank of the team's share of plays that were rush plays on rush plays with the team on offense, where 1 is best. |
| nonExplosiveEpaPerPlay_off_rush_rank | double | National rank of the team's EPA per play with explosive plays excluded on rush plays with the team on offense, where 1 is best. |
| line_yards_off_rush_rank | double | National rank of the team's average line yards credited to the offensive line on rushes on rush plays with the team on offense, where 1 is best. |
| opportunity_rate_off_rush_rank | double | National rank of the team's opportunity rate – the share of rushes carrying the opportunity flag on rush plays with the team on offense, where 1 is best. |
| plays_def_rush | integer | Plays run on rush plays, with the team on defense (i.e. allowed to opponents). |
| passrate_def_rush | double | Share of plays that were pass plays on rush plays, with the team on defense (i.e. allowed to opponents). |
| rushrate_def_rush | double | Share of plays that were rush plays on rush plays, with the team on defense (i.e. allowed to opponents). |
| havoc_def_rush | double | Havoc rate – the share of plays carrying the defensive-disruption flag on rush plays, with the team on defense (i.e. allowed to opponents). |
| explosive_def_rush | double | Explosive-play rate – the share of plays carrying the explosive flag on rush plays, with the team on defense (i.e. allowed to opponents). |
| TEPA_def_rush | double | Total EPA summed over every play on rush plays, with the team on defense (i.e. allowed to opponents). |
| EPAplay_def_rush | double | EPA per play on rush plays, with the team on defense (i.e. allowed to opponents). |
| yards_def_rush | integer | Total yards gained on rush plays, with the team on defense (i.e. allowed to opponents). |
| yardsplay_def_rush | double | Yards gained per play on rush plays, with the team on defense (i.e. allowed to opponents). |
| play_stuffed_def_rush | double | Stuffed-play rate – the share of plays carrying the stuffed flag on rush plays, with the team on defense (i.e. allowed to opponents). |
| success_def_rush | double | Success rate – the share of plays flagged as successful by EPA on rush plays, with the team on defense (i.e. allowed to opponents). |
| red_zone_success_def_rush | double | Success rate on red-zone plays on rush plays, with the team on defense (i.e. allowed to opponents). |
| third_down_success_def_rush | double | Success rate on third-down plays on rush plays, with the team on defense (i.e. allowed to opponents). |
| third_down_distance_def_rush | double | Average yards to go on third down on rush plays, with the team on defense (i.e. allowed to opponents). |
| late_down_success_def_rush | double | Success rate on late-down plays on rush plays, with the team on defense (i.e. allowed to opponents). |
| early_down_EPA_def_rush | double | EPA per early-down play on rush plays, with the team on defense (i.e. allowed to opponents). |
| nonExplosiveEpaPerPlay_def_rush | double | EPA per play with explosive plays excluded on rush plays, with the team on defense (i.e. allowed to opponents). |
| line_yards_def_rush | double | Average line yards credited to the offensive line on rushes on rush plays, with the team on defense (i.e. allowed to opponents). |
| opportunity_rate_def_rush | double | Opportunity rate – the share of rushes carrying the opportunity flag on rush plays, with the team on defense (i.e. allowed to opponents). |
| playsgame_def_rush | double | Plays run per game on rush plays, with the team on defense (i.e. allowed to opponents). |
| EPAdrive_def_rush | double | EPA per drive (total EPA divided by drives) on rush plays, with the team on defense (i.e. allowed to opponents). |
| EPAgame_def_rush | double | EPA per game (total EPA divided by games) on rush plays, with the team on defense (i.e. allowed to opponents). |
| yardsgame_def_rush | double | Yards gained per game on rush plays, with the team on defense (i.e. allowed to opponents). |
| drives_def_rush | integer | Offensive drives on rush plays, with the team on defense (i.e. allowed to opponents). |
| drivesgame_def_rush | double | Drives per game on rush plays, with the team on defense (i.e. allowed to opponents). |
| yardsdrive_def_rush | double | Yards gained per drive on rush plays, with the team on defense (i.e. allowed to opponents). |
| playsdrive_def_rush | double | Plays run per drive on rush plays, with the team on defense (i.e. allowed to opponents). |
| playsgame_def_rush_rank | double | National rank of the team's plays run per game on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| TEPA_def_rush_rank | double | National rank of the team's total EPA summed over every play on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| EPAgame_def_rush_rank | double | National rank of the team's EPA per game (total EPA divided by games) on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| EPAplay_def_rush_rank | double | National rank of the team's EPA per play on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| EPAdrive_def_rush_rank | double | National rank of the team's EPA per drive (total EPA divided by drives) on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| early_down_EPA_def_rush_rank | double | National rank of the team's EPA per early-down play on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| success_def_rush_rank | double | National rank of the team's success rate – the share of plays flagged as successful by EPA on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| yards_def_rush_rank | double | National rank of the team's total yards gained on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| yardsplay_def_rush_rank | double | National rank of the team's yards gained per play on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| yardsgame_def_rush_rank | double | National rank of the team's yards gained per game on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| drivesgame_def_rush_rank | double | National rank of the team's drives per game on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| yardsdrive_def_rush_rank | double | National rank of the team's yards gained per drive on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| playsdrive_def_rush_rank | double | National rank of the team's plays run per drive on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| play_stuffed_def_rush_rank | double | National rank of the team's stuffed-play rate – the share of plays carrying the stuffed flag on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| red_zone_success_def_rush_rank | double | National rank of the team's success rate on red-zone plays on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| third_down_success_def_rush_rank | double | National rank of the team's success rate on third-down plays on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| late_down_success_def_rush_rank | double | National rank of the team's success rate on late-down plays on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| third_down_distance_def_rush_rank | double | National rank of the team's average yards to go on third down on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| havoc_def_rush_rank | double | National rank of the team's havoc rate – the share of plays carrying the defensive-disruption flag on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| explosive_def_rush_rank | double | National rank of the team's explosive-play rate – the share of plays carrying the explosive flag on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| passrate_def_rush_rank | double | National rank of the team's share of plays that were pass plays on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| rushrate_def_rush_rank | double | National rank of the team's share of plays that were rush plays on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| nonExplosiveEpaPerPlay_def_rush_rank | double | National rank of the team's EPA per play with explosive plays excluded on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| line_yards_def_rush_rank | double | National rank of the team's average line yards credited to the offensive line on rushes on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| opportunity_rate_def_rush_rank | double | National rank of the team's opportunity rate – the share of rushes carrying the opportunity flag on rush plays with the team on defense (i.e. allowed to opponents), where 1 is best. |
| TEPA_margin_rush | double | Margin in total EPA summed over every play on rush plays: the team's offensive value minus the value it allowed on defense. |
| EPAplay_margin_rush | double | Margin in EPA per play on rush plays: the team's offensive value minus the value it allowed on defense. |
| EPAdrive_margin_rush | double | Margin in EPA per drive (total EPA divided by drives) on rush plays: the team's offensive value minus the value it allowed on defense. |
| EPAgame_margin_rush | double | Margin in EPA per game (total EPA divided by games) on rush plays: the team's offensive value minus the value it allowed on defense. |
| success_margin_rush | double | Margin in success rate – the share of plays flagged as successful by EPA on rush plays: the team's offensive value minus the value it allowed on defense. |
| yardsplay_margin_rush | double | Margin in yards gained per play on rush plays: the team's offensive value minus the value it allowed on defense. |
| TEPA_margin_rush_rank | double | Margin in total EPA summed over every play on rush plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
| EPAplay_margin_rush_rank | double | Margin in EPA per play on rush plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
| EPAdrive_margin_rush_rank | double | Margin in EPA per drive (total EPA divided by drives) on rush plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
| EPAgame_margin_rush_rank | double | Margin in EPA per game (total EPA divided by games) on rush plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
| success_margin_rush_rank | double | Margin in success rate – the share of plays flagged as successful by EPA on rush plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
| yardsplay_margin_rush_rank | double | Margin in yards gained per play on rush plays: the team's offensive value minus the value it allowed on defense. National rank of that margin, 1 = largest. |
| fbs_class | character | Power/Group classification for the season: P4 or G6 from 2024 on, P5 or G5 through 2023, derived from conference membership (Notre Dame is classified with the power group). Null for teams outside FBS. |
| valid_games | integer | Number of the team's games that produced both an offensive and a defensive adjusted-EPA value; teams below two valid games are dropped from the adjusted ratings. |
| adj_off_epa | double | Offensive opponent-adjusted EPA per play from the ridge (RAPM-style) regression on offense/defense team indicators plus home field – cfbfastR's adjust_epa adjustment, fit in-sample across the season, so the value is descriptive of that window rather than predictive. |
| adj_def_epa | double | Defensive opponent-adjusted EPA per play from the ridge (RAPM-style) regression on offense/defense team indicators plus home field – cfbfastR's adjust_epa adjustment, fit in-sample across the season, so the value is descriptive of that window rather than predictive. Lower is better – it is EPA allowed. |
| off_strength_faced | double | Average opponent-defense strength the team's offense faced, taken as the mean of the ridge's defensive coefficients across its opponents. Higher means a tougher slate. |
| def_strength_faced | double | Average opponent-offense strength the team's defense faced, taken as the mean of the ridge's offensive coefficients across its opponents. Higher means a tougher slate. |
| net_adj_epa | double | Net opponent-adjusted EPA per play: adj_off_epa minus adj_def_epa. Higher is better. |
| adj_off_epa_rank | double | National rank of the team's adj_off_epa, where 1 is best. |
| adj_def_epa_rank | double | National rank of the team's adj_def_epa, where 1 is best (fewest EPA allowed). |
| net_adj_epa_rank | double | National rank of the team's net_adj_epa, 1 = largest net adjusted EPA. |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_espn_cfb_team_summaries(2004))
#> ── college football team season summaries from the SportsDataverse data repo ───
#> ℹ Data updated: 2026-08-24 14:50:21 UTC
#> # A tibble: 118 × 383
#>    team_id pos_team       division conference     season plays_off passrate_off
#>    <chr>   <chr>          <chr>    <chr>           <int>     <int>        <dbl>
#>  1 103     Boston College fbs      Big East         2004       652        0.514
#>  2 12      Arizona        fbs      Pac-10           2004       580        0.460
#>  3 120     Maryland       fbs      ACC              2004       680        0.432
#>  4 127     Michigan State fbs      Big Ten          2004       800        0.429
#>  5 130     Michigan       fbs      Big Ten          2004       757        0.483
#>  6 135     Minnesota      fbs      Big Ten          2004       637        0.334
#>  7 142     Missouri       fbs      Big 12           2004       785        0.448
#>  8 145     Ole Miss       fbs      SEC              2004       718        0.453
#>  9 150     Duke           fbs      ACC              2004       529        0.484
#> 10 151     East Carolina  fbs      Conference USA   2004       259        0.537
#> # ℹ 108 more rows
#> # ℹ 376 more variables: rushrate_off <dbl>, havoc_off <dbl>,
#> #   explosive_off <dbl>, TEPA_off <dbl>, EPAplay_off <dbl>, yards_off <int>,
#> #   yardsplay_off <dbl>, play_stuffed_off <dbl>, success_off <dbl>,
#> #   red_zone_success_off <dbl>, third_down_success_off <dbl>,
#> #   third_down_distance_off <dbl>, late_down_success_off <dbl>,
#> #   early_down_EPA_off <dbl>, start_position_off <dbl>, …
# }
```
