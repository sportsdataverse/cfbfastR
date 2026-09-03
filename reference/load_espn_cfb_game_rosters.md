# **Load ESPN college football game rosters from the SportsDataverse data repo**

Loads season-level game rosters – one row per player-game with team,
position, and status, keyed by ESPN athlete id. Published to the
`espn_cfb_game_rosters` release tag on the sportsdataverse-data repo.

## Usage

``` r
load_espn_cfb_game_rosters(
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
| athlete_id | integer |  |
| athlete_uid | character |  |
| athlete_guid | character |  |
| athlete_type | character |  |
| first_name | character |  |
| last_name | character |  |
| full_name | character |  |
| athlete_display_name | character |  |
| short_name | character |  |
| weight | double |  |
| display_weight | character |  |
| height | double |  |
| display_height | character |  |
| slug | character |  |
| jersey | character |  |
| linked | logical |  |
| active | logical |  |
| alternate_ids_sdr | character |  |
| birth_place_city | character |  |
| birth_place_state | character |  |
| birth_place_country | character |  |
| birth_country_alternate_id | character | ESPN's internal alternate identifier for the athlete's birth country, paired with birth_place_country and the flag fields. |
| birth_country_abbreviation | character |  |
| headshot_href | character |  |
| headshot_alt | character |  |
| hand_type | character |  |
| hand_abbreviation | character |  |
| hand_display_value | character |  |
| flag_href | character | URL of the birth-country flag image hosted on ESPN's CDN under teamlogos/countries. |
| flag_alt | character | Alt text ESPN attaches to the birth-country flag image, which is the country's name spelled out. |
| flag_rel | character | Stringified relationship list ESPN ships with the flag image; the only non-null value observed is a single country-flag entry. |
| experience_years | double |  |
| experience_display_value | character |  |
| experience_abbreviation | character |  |
| status_id | character |  |
| status_name | character |  |
| status_type | character |  |
| status_abbreviation | character |  |
| middle_name | character |  |
| starter | logical |  |
| jersey_right | character |  |
| valid | logical |  |
| did_not_play | logical |  |
| display_name | character |  |
| athlete_href | character | ESPN Core v2 API reference URL for the athlete's season record, ending in the athlete id. |
| position_href | character | ESPN Core v2 API reference URL for the position resource ESPN lists the athlete at. |
| statistics_href | character | ESPN Core v2 API reference URL for this athlete's stat line in this game, null for the roughly 71 percent of listed players who recorded no stats. |
| team_id | integer |  |
| order | integer |  |
| home_away | character |  |
| winner | logical |  |
| team_guid | character |  |
| team_uid | character |  |
| team_slug | character |  |
| team_location | character |  |
| team_name | character |  |
| team_nickname | character |  |
| team_abbreviation | character |  |
| team_display_name | character |  |
| team_short_display_name | character |  |
| team_color | character |  |
| team_alternate_color | character |  |
| is_active | logical |  |
| is_all_star | logical |  |
| team_alternate_ids_sdr | character | The team's Sportradar alternate identifier, which maps one-to-one with team_id. |
| logo_href | character |  |
| logo_dark_href | character |  |
| game_id | integer |  |
| season | integer |  |
| week | integer |  |
| age | double |  |
| date_of_birth | character |  |
| citizenship | character |  |
| draft_display_text | character |  |
| draft_round | double |  |
| draft_year | double |  |
| draft_selection | double |  |
| draft_team_href | character | API link to the team that drafted the player. Sparse: absent entirely from the 2023 and 2024 assets and populated on only a small share of 2025 rows. |

## Author

Saiem Gilani

## Examples

``` r
# \donttest{
  try(load_espn_cfb_game_rosters(2004))
#> ── ESPN college football game rosters from the SportsDataverse data repo ───────
#> ℹ Data updated: 2026-09-03 22:41:17 UTC
#> # A tibble: 43,010 × 72
#>    athlete_id athlete_uid        athlete_guid  athlete_type first_name last_name
#>         <int> <chr>              <chr>         <chr>        <chr>      <chr>    
#>  1     101304 s:20~l:23~a:101304 8eca16e2-da8… football     Kevin      Lewis    
#>  2     116150 s:20~l:23~a:116150 f60e5508-361… football     Eric       Green    
#>  3     116152 s:20~l:23~a:116152 bb556416-79c… football     Vincent    Fuller   
#>  4     116153 s:20~l:23~a:116153 bd2359a6-9d8… football     Richard    Johnson  
#>  5     116157 s:20~l:23~a:116157 3f16ca2f-315… football     Vinnie     Burns    
#>  6     116161 s:20~l:23~a:116161 e93576eb-b89… football     Brandon    Manning  
#>  7     116164 s:20~l:23~a:116164 332f1091-b1e… football     Travis     Conway   
#>  8     116168 s:20~l:23~a:116168 aaa00691-98d… football     Jared      Mazzetta 
#>  9     116171 s:20~l:23~a:116171 f65bc797-f03… football     Jim        Davis    
#> 10     116172 s:20~l:23~a:116172 32948407-a0b… football     James      Anderson 
#> # ℹ 43,000 more rows
#> # ℹ 66 more variables: full_name <chr>, athlete_display_name <chr>,
#> #   short_name <chr>, weight <dbl>, display_weight <chr>, height <dbl>,
#> #   display_height <chr>, age <dbl>, date_of_birth <chr>, slug <chr>,
#> #   jersey <chr>, linked <lgl>, active <lgl>, alternate_ids_sdr <chr>,
#> #   birth_place_city <chr>, birth_place_state <chr>, experience_years <dbl>,
#> #   experience_display_value <chr>, experience_abbreviation <chr>, …
# }
```
