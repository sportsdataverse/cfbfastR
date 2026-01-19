# **Get list of NFL draft picks**

**Get list of NFL draft picks**

## Usage

``` r
cfbd_draft_picks(
  year = NULL,
  nfl_team = NULL,
  college = NULL,
  conference = NULL,
  position = NULL
)
```

## Arguments

- year:

  (*Integer* required): NFL draft class, 4 digit format (*YYYY*)

- nfl_team:

  (*String*): NFL drafting team, see
  [`cfbd_draft_teams()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft_teams.md)
  for valid selections.

- college:

  (*String*): NFL draftee college team, see
  [`cfbd_team_info()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_team_info.md)
  for valid selections.

- conference:

  (*String*): NFL draftee college team conference, see
  [`cfbd_conferences()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_conferences.md)
  for valid selections.

- position:

  (*String*): NFL position abbreviation, see
  [`cfbd_draft_positions()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft_positions.md)
  for valid selections.

## Value

`cfbd_draft_picks()` - A data frame with 23 variables:

- `college_athlete_id`: integer.:

  College athlete referencing id.

- `nfl_athlete_id`: integer:

  NFL athlete referencing id.

- `college_id`: integer:

  College team referencing id.

- `college_team`: character:

  College team name.

- `college_conference`: character:

  Conference of college team.

- `nfl_team_id`: integer.:

  NFL team ID.

- `nfl_team`: character:

  NFL team name of drafted player.

- `year`: integer.:

  NFL draft class year.

- `overall`: integer.:

  Overall draft pick number.

- `round`: integer.:

  Round of NFL draft the draftee was picked in.

- `pick`: integer.:

  Pick number of the NFL draftee within the round they were picked in.

- `name`: character.:

  NFL draftee name.

- `position`: character.:

  NFL draftee position.

- `height`: double.:

  NFL draftee height.

- `weight`: integer.:

  NFL draftee weight.

- `pre_draft_ranking`: integer:

  Pre-draft ranking (ESPN).

- `pre_draft_position_ranking`: integer.:

  Pre-draft position ranking (ESPN).

- `pre_draft_grade`: double.:

  Pre-draft scouts grade (ESPN).

- `hometown_info_city`: character.:

  Hometown of the NFL draftee.

- `hometown_info_state_province`: character.:

  Hometown state of the NFL draftee.

- `hometown_info_country`: character.:

  Hometown country of the NFL draftee.

- `hometown_info_latitude`: character.:

  Hometown latitude of the NFL draftee.

- `hometown_info_longitude`: character.:

  Hometown longitude of the NFL draftee.

- `hometown_info_county_fips`: character.:

  Hometown FIPS code of the NFL draftee.

## See also

Other CFBD Draft:
[`cfbd_draft_positions()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft_positions.md),
[`cfbd_draft_teams()`](https://cfbfastR.sportsdataverse.org/reference/cfbd_draft_teams.md)

## Examples

``` r
# \donttest{
  try(cfbd_draft_picks(year = 2020))
#> ── NFL draft data from CollegeFootballData.com ─────────────── cfbfastR 2.2.1 ──
#> ℹ Data updated: 2026-01-19 16:21:48 UTC
#> # A tibble: 255 × 24
#>    college_athlete_id nfl_athlete_id college_id college_team college_conference
#>                 <int>          <int>      <int> <chr>        <chr>             
#>  1            3915511         104204         99 LSU          SEC               
#>  2            4241986         104097        194 Ohio State   Big Ten           
#>  3            4241984         104096        194 Ohio State   Big Ten           
#>  4            4259566         104112         61 Georgia      SEC               
#>  5            4241479         104093        333 Alabama      SEC               
#>  6            4038941         104099       2483 Oregon       Pac-12            
#>  7            4035495         104098          2 Auburn       SEC               
#>  8            4035462         104106        228 Clemson      ACC               
#>  9            4240596         104104         57 Florida      SEC               
#> 10            4241482         104425        333 Alabama      SEC               
#> # ℹ 245 more rows
#> # ℹ 19 more variables: nfl_team_id <int>, nfl_team <chr>, year <int>,
#> #   overall <int>, round <int>, pick <int>, name <chr>, position <chr>,
#> #   height <int>, weight <int>, pre_draft_ranking <int>,
#> #   pre_draft_position_ranking <int>, pre_draft_grade <int>,
#> #   hometown_info_city <chr>, hometown_info_state <chr>,
#> #   hometown_info_country <chr>, hometown_info_latitude <chr>, …

  try(cfbd_draft_picks(year = 2016, position = "PK"))
#> ── NFL draft data from CollegeFootballData.com ─────────────── cfbfastR 2.2.1 ──
#> ℹ Data updated: 2026-01-19 16:21:48 UTC
#> # A tibble: 1 × 24
#>   college_athlete_id nfl_athlete_id college_id college_team  college_conference
#>                <int>          <int>      <int> <chr>         <chr>             
#> 1             535422          50410         52 Florida State ACC               
#> # ℹ 19 more variables: nfl_team_id <int>, nfl_team <chr>, year <int>,
#> #   overall <int>, round <int>, pick <int>, name <chr>, position <chr>,
#> #   height <int>, weight <int>, pre_draft_ranking <int>,
#> #   pre_draft_position_ranking <int>, pre_draft_grade <int>,
#> #   hometown_info_city <chr>, hometown_info_state <chr>,
#> #   hometown_info_country <chr>, hometown_info_latitude <chr>,
#> #   hometown_info_longitude <chr>, hometown_info_county_fips <chr>
# }
```
