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
#> ── Roster data from Fox Sports (Bifrost) ───────────────────── cfbfastR 2.3.0 ──
#> ℹ Data updated: 2026-06-13 02:51:57 UTC
#> # A tibble: 115 × 8
#>    team_id position_group player             pos   cls   ht     wt    athlete_id
#>    <chr>   <chr>          <chr>              <chr> <chr> <chr>  <chr> <chr>     
#>  1 11      OFFENSE        Seuseu Alofaituli  OL    FR    "6'2\… 290 … 233452    
#>  2 11      OFFENSE        Judd Anderson      QB    FR    "6'6\… 230 … 220945    
#>  3 11      OFFENSE        Alex Bauman        TE    SR    "6'5\… 250 … 195876    
#>  4 11      OFFENSE        Carson Beck        QB    SR    "6'4\… 225 … 179027    
#>  5 11      OFFENSE        Markel Bell        OL    SR    "6'9\… 345 … 220928    
#>  6 11      OFFENSE        Joe Borchers       QB    SO    "6'3\… 230 … 219990    
#>  7 11      OFFENSE        James Brockermeyer OL    SR    "6'3\… 295 … 187439    
#>  8 11      OFFENSE        CharMar Brown      RB    SO    "5'11… 220 … 213306    
#>  9 11      OFFENSE        Max Buchanan       OL    FR    "6'4\… 310 … 233455    
#> 10 11      OFFENSE        Brennan Burton     WR    FR    "6'0\… 205 … 227766    
#> # ℹ 105 more rows
# }
```
