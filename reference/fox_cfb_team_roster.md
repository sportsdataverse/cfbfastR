# **Get Fox Sports college football team roster**

Flattens the Bifrost `team/{id}/roster` position-group tables into one
tidy player-level tibble.

## Usage

``` r
fox_cfb_team_roster(team_id)
```

## Arguments

- team_id:

  (character/numeric, required): Fox Bifrost team id (e.g. `"11"` for
  Miami (FL)). Discover ids via the league team directory
  (`league/teamnav`).

## Value

A `cfbfastR`-tagged tibble with one row per player:

- `team_id`: character.: Fox team id echoed back.

- `position_group`: character.: Roster group ("OFFENSE", "DEFENSE",
  "SPECIAL TEAMS").

- `player`: character.: Player name.

- `pos`: character.: Position abbreviation.

- `cls`: character.: Class (FR/SO/JR/SR).

- `ht`: character.: Listed height.

- `wt`: character.: Listed weight.

- `athlete_id`: character.: Fox athlete id (from the player's
  contentUri).

## Examples

``` r
# \donttest{
  try(fox_cfb_team_roster(team_id = "11"))
#> ── Roster data from Fox Sports (Bifrost) ───────────────────── cfbfastR 3.0.0 ──
#> ℹ Data updated: 2026-08-27 16:44:08 UTC
#> # A tibble: 118 × 8
#>    team_id position_group player             pos   cls   ht     wt    athlete_id
#>    <chr>   <chr>          <chr>              <chr> <chr> <chr>  <chr> <chr>     
#>  1 11      OFFENSE        Seuseu Alofaituli  OL    SO    "6'2\… 298 … 233452    
#>  2 11      OFFENSE        Judd Anderson      QB    SO    "6'7\… 235 … 220945    
#>  3 11      OFFENSE        Cooper Barkate     WR    SR    "6'1\… 195 … 203004    
#>  4 11      OFFENSE        Joe Borchers       QB    JR    "6'3\… 230 … 219990    
#>  5 11      OFFENSE        Israel Briggs      TE    FR    "6'4\… 205 … 249402    
#>  6 11      OFFENSE        CharMar Brown      RB    JR    "5'11… 220 … 213306    
#>  7 11      OFFENSE        Max Buchanan       OL    SO    "6'4\… 310 … 233455    
#>  8 11      OFFENSE        Brennan Burton     WR    SO    "6'0\… 205 … 227766    
#>  9 11      OFFENSE        Demetrius Campbell OL    FR    "6'6\… 330 … 233461    
#> 10 11      OFFENSE        Jackson Cantwell   OL    FR    "6'8\… 330 … 249398    
#> # ℹ 108 more rows
# }
```
