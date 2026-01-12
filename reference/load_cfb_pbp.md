# **Load cleaned play-by-play from the data repo**

helper that loads multiple seasons from the data repo either into memory
or writes it into a db using some forwarded arguments in the dots

## Usage

``` r
load_cfb_pbp(
  seasons = most_recent_cfb_season(),
  ...,
  dbConnection = NULL,
  tablename = NULL
)
```

## Source

CFB Play-by-Play Data releases can be found here:
<https://github.com/sportsdataverse/sportsdataverse-data/releases/tag/cfbfastR_cfb_pbp>

## Arguments

- seasons:

  A vector of 4-digit years associated with given College Football
  seasons.

- ...:

  Additional arguments passed to an underlying function that writes the
  season data into a database (used by
  [`update_cfb_db()`](https://cfbfastR.sportsdataverse.org/reference/update_cfb_db.md))

- dbConnection:

  A `DBIConnection` object, as returned by
  [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html)

- tablename:

  The name of the play by play data table within the database

## Value

Returns a tibble with play-by-play data

## See also

Issues with this data should be filed here:
<https://github.com/sportsdataverse/cfbfastR-data>

[`update_cfb_db()`](https://cfbfastR.sportsdataverse.org/reference/update_cfb_db.md)

Other loaders:
[`load_cfb_rosters()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_rosters.md),
[`load_cfb_schedules()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_schedules.md),
[`load_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/load_cfb_teams.md),
[`update_cfb_db()`](https://cfbfastR.sportsdataverse.org/reference/update_cfb_db.md)
