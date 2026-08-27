# **Load ESPN college football play participants from the SportsDataverse data repo**

Loads season-level per-play participants – one row per play- participant
with role type and ESPN athlete id, the join partner for play-level
attribution. Published to the `espn_cfb_play_participants` release tag
on the sportsdataverse- data repo.

## Usage

``` r
load_espn_cfb_play_participants(
  seasons = most_recent_cfb_season(),
  ...,
  dbConnection = NULL,
  tablename = NULL
)
```

## Arguments

- seasons:

  A vector of 4-digit years associated with given college football
  seasons. Published coverage runs 2014 through the most recent season.
  Pass `seasons = TRUE` for every published season. (Min: 2014)

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
| game_id | integer |  |
| play_id | integer |  |
| kicker_player_name | character | Display name of the kicker – the FIRST participant in that role on the play. |
| tackler_player_name | character | Display name of a defender credited with the tackle – the FIRST participant in that role on the play. |
| returner_player_name | character | Display name of the player returning the kick or punt – the FIRST participant in that role on the play. |
| rusher_player_name | character | Display name of the ball carrier on a rush – the FIRST participant in that role on the play. |
| passer_player_name | character | Display name of the passer – the FIRST participant in that role on the play. |
| receiver_player_name | character | Display name of the targeted receiver – the FIRST participant in that role on the play. |
| punter_player_name | character | Display name of the punter – the FIRST participant in that role on the play. |
| assisted_by_player_name | character | Display name of a defender credited with an assisted tackle – the FIRST participant in that role on the play. |
| penalized_player_name | character | Display name of the penalized player – the FIRST participant in that role on the play. |
| scorer_player_name | character | Display name of the player credited with the score – the FIRST participant in that role on the play. |
| pat_scorer_player_name | character | Display name of the player credited with the point-after score – the FIRST participant in that role on the play. |
| sacked_by_player_name | character | Display name of a defender credited with the sack – the FIRST participant in that role on the play. |
| kicker_player_id | character | ESPN athlete id of the kicker – the FIRST participant in that role on the play. |
| tackler_player_id | character | ESPN athlete id of a defender credited with the tackle – the FIRST participant in that role on the play. |
| returner_player_id | character | ESPN athlete id of the player returning the kick or punt – the FIRST participant in that role on the play. |
| rusher_player_id | character | ESPN athlete id of the ball carrier on a rush – the FIRST participant in that role on the play. |
| passer_player_id | character | ESPN athlete id of the passer – the FIRST participant in that role on the play. |
| receiver_player_id | character | ESPN athlete id of the targeted receiver – the FIRST participant in that role on the play. |
| punter_player_id | character | ESPN athlete id of the punter – the FIRST participant in that role on the play. |
| assisted_by_player_id | character | ESPN athlete id of a defender credited with an assisted tackle – the FIRST participant in that role on the play. |
| penalized_player_id | character | ESPN athlete id of the penalized player – the FIRST participant in that role on the play. |
| scorer_player_id | character | ESPN athlete id of the player credited with the score – the FIRST participant in that role on the play. |
| pat_scorer_player_id | character | ESPN athlete id of the player credited with the point-after score – the FIRST participant in that role on the play. |
| sacked_by_player_id | character | ESPN athlete id of a defender credited with the sack – the FIRST participant in that role on the play. |
| kicker_player_names | character | List of the display names of EVERY participant credited as the kicker on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| tackler_player_names | character | List of the display names of EVERY participant credited as a defender credited with the tackle on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| returner_player_names | character | List of the display names of EVERY participant credited as the player returning the kick or punt on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| rusher_player_names | character | List of the display names of EVERY participant credited as the ball carrier on a rush on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| passer_player_names | character | List of the display names of EVERY participant credited as the passer on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| receiver_player_names | character | List of the display names of EVERY participant credited as the targeted receiver on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| punter_player_names | character | List of the display names of EVERY participant credited as the punter on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| assisted_by_player_names | character | List of the display names of EVERY participant credited as a defender credited with an assisted tackle on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| penalized_player_names | character | List of the display names of EVERY participant credited as the penalized player on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| scorer_player_names | character | List of the display names of EVERY participant credited as the player credited with the score on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| pat_scorer_player_names | character | List of the display names of EVERY participant credited as the player credited with the point-after score on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| sacked_by_player_names | character | List of the display names of EVERY participant credited as a defender credited with the sack on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| kicker_player_ids | character | List of the athlete ids of EVERY participant credited as the kicker on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| tackler_player_ids | character | List of the athlete ids of EVERY participant credited as a defender credited with the tackle on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| returner_player_ids | character | List of the athlete ids of EVERY participant credited as the player returning the kick or punt on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| rusher_player_ids | character | List of the athlete ids of EVERY participant credited as the ball carrier on a rush on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| passer_player_ids | character | List of the athlete ids of EVERY participant credited as the passer on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| receiver_player_ids | character | List of the athlete ids of EVERY participant credited as the targeted receiver on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| punter_player_ids | character | List of the athlete ids of EVERY participant credited as the punter on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| assisted_by_player_ids | character | List of the athlete ids of EVERY participant credited as a defender credited with an assisted tackle on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| penalized_player_ids | character | List of the athlete ids of EVERY participant credited as the penalized player on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| scorer_player_ids | character | List of the athlete ids of EVERY participant credited as the player credited with the score on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| pat_scorer_player_ids | character | List of the athlete ids of EVERY participant credited as the player credited with the point-after score on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| sacked_by_player_ids | character | List of the athlete ids of EVERY participant credited as a defender credited with the sack on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| season | integer |  |
| week | integer |  |
| pass_defender_player_name | character | Display name of the defender credited with defending the pass – the FIRST participant in that role on the play. |
| pass_defender_player_id | character | ESPN athlete id of the defender credited with defending the pass – the FIRST participant in that role on the play. |
| pass_defender_player_names | character | List of the display names of EVERY participant credited as the defender credited with defending the pass on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| pass_defender_player_ids | character | List of the athlete ids of EVERY participant credited as the defender credited with defending the pass on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| recoverer_player_name | character | Display name of the player who recovered the fumble – the FIRST participant in that role on the play. |
| fumbler_player_name | character |  |
| recoverer_player_id | character | ESPN athlete id of the player who recovered the fumble – the FIRST participant in that role on the play. |
| fumbler_player_id | character |  |
| recoverer_player_names | character | List of the display names of EVERY participant credited as the player who recovered the fumble on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| fumbler_player_names | character |  |
| recoverer_player_ids | character | List of the athlete ids of EVERY participant credited as the player who recovered the fumble on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| fumbler_player_ids | character |  |
| forced_by_player_name | character | Display name of the defender who forced the fumble – the FIRST participant in that role on the play. |
| forced_by_player_id | character | ESPN athlete id of the defender who forced the fumble – the FIRST participant in that role on the play. |
| forced_by_player_names | character | List of the display names of EVERY participant credited as the defender who forced the fumble on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| forced_by_player_ids | character | List of the athlete ids of EVERY participant credited as the defender who forced the fumble on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| pat_passer_player_name | character | Display name of the passer on the point-after attempt – the FIRST participant in that role on the play. |
| pat_passer_player_id | character | ESPN athlete id of the passer on the point-after attempt – the FIRST participant in that role on the play. |
| pat_passer_player_names | character | List of the display names of EVERY participant credited as the passer on the point-after attempt on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |
| pat_passer_player_ids | character | List of the athlete ids of EVERY participant credited as the passer on the point-after attempt on the play, so multi-entry roles such as split sacks or gang tackles are not collapsed to one. |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_espn_cfb_play_participants(2014))
#> Warning: cannot open URL 'https://github.com/sportsdataverse/sportsdataverse-data/releases/download/espn_cfb_play_participants/play_participants_2014.rds': HTTP status was '404 Not Found'
#> Warning: Failed to readRDS from
#> <https://github.com/sportsdataverse/sportsdataverse-data/releases/download/espn_cfb_play_participants/play_participants_2014.rds>
#> ── ESPN college football play participants from the SportsDataverse data repo ──
#> ℹ Data updated: 2026-08-27 04:22:52 UTC
#> # A tibble: 0 × 0
# }
```
