# ESPN College Football Cookbook

This is a *cookbook*. Instead of marching through every function in the
`espn_cfb_*()` family one at a time, we are going to answer a handful of
real questions – the kind you actually ask when you sit down with
college football data – and pick up the functions, and the *shape* of
the function names, as we go.

``` r

library(cfbfastR)
library(dplyr)
```

### A note on the function names

Before the first recipe, one idea worth planting early, because it pays
off in every recipe after it. The ESPN layer of `cfbfastR` is named on a
strict, predictable pattern:

    espn_cfb_<entity>_<detail>

`<entity>` is the *thing* you are asking about – a `team`, a `game`, a
`player`. `<detail>` is the *slice* of that thing you want – a
`schedule`, a `record`, a `roster`. The plural form
([`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md))
is the catalog of every entity; the singular form
([`espn_cfb_team()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team.md))
is one entity in depth.

The practical upshot: **once you know one function, you can guess its
siblings.** If
[`espn_cfb_game_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_teams.md)
gives you the two teams in a game, then
[`espn_cfb_game_team_roster()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_roster.md)
almost certainly gives you a roster for a team in that game – and it
does. You rarely need to look anything up. You just need to know what
you want and spell it the way the package spells it.

We will use four anchor IDs throughout: game `401628339`, team `61`
(Georgia Tech), athlete `4427191`, and season `2024`.

------------------------------------------------------------------------

## Recipe 1 – A team’s season at a glance

**The question:** I want a quick scouting snapshot of one program – who
they are, and how their season went.

Start at the catalog.
[`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md)
(plural – the catalog) is the lookup table for the whole sport: one row
per team, with the all-important `team_id` you feed everything else.

``` r

teams <- espn_cfb_teams()
teams |>
  filter(team_id == "61") |>
  select(team_id, display_name, abbreviation, location, color)
```

Now zoom in.
[`espn_cfb_team()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team.md)
(singular – one entity, in depth) takes that `team_id` and a season and
returns the team’s detail record, including its home venue.

``` r

gt_team <- espn_cfb_team(team_id = 61, year = 2024)
gt_team |>
  select(team_id, display_name, venue_name, venue_city, venue_state)
```

We have the *entity*. Now we want a *detail* of it – the schedule. The
name writes itself:
[`espn_cfb_team_schedule()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_schedule.md).

``` r

gt_sched <- espn_cfb_team_schedule(team_id = 61, year = 2024)
gt_sched |>
  select(any_of(c("game_id", "week", "game_date",
                  "home_team", "away_team"))) |>
  head(6)
```

And the won/lost summary of that schedule – another detail of the same
entity, so another `espn_cfb_team_*()` function:
[`espn_cfb_team_record()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team_record.md).

``` r

espn_cfb_team_record(team_id = 61, year = 2024) |>
  select(any_of(c("team_id", "type", "summary", "wins", "losses")))
```

Notice the rhythm of this recipe. We never left the `espn_cfb_team*`
shelf: catalog (`teams`), then entity (`team`), then two details of that
entity (`team_schedule`, `team_record`). That shelf has more on it –
[`team_roster()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_team.md),
`team_stats()`, `team_coaches()`, `team_leaders()`, `team_events()` –
and you can now reach for any of them without checking the docs first.

------------------------------------------------------------------------

## Recipe 2 – Building a game box score

**The question:** Give me the box score for a single game – the team
totals and the individual player lines.

We are switching entities, from `team` to `game`, so the prefix switches
with us: `espn_cfb_team_*()` becomes `espn_cfb_game_*()`. Same grammar,
new shelf.

First, who played, and what was the score?
[`espn_cfb_game_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_teams.md)
is the two-team summary of a game. It takes a `format` argument –
`"long"` gives one row per team (tidy for plotting), `"wide"` gives one
row for the whole game with `home_*` / `away_*` columns (handy for a
box-score header).

``` r

game_hdr <- espn_cfb_game_teams(game_id = 401628339, format = "wide")
game_hdr |>
  select(any_of(c("game_id", "home_team", "home_team_score",
                  "away_team", "away_team_score")))
```

Now the team statistical totals. We want a *detail* (`statistics`) of a
*team* within a *game* – read that right to left and the name falls out:
[`espn_cfb_game_team_statistics()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_statistics.md).

``` r

team_stats <- espn_cfb_game_team_statistics(game_id = 401628339)
team_stats |>
  select(any_of(c("team_id", "team", "stat_name",
                  "display_value"))) |>
  head(10)
```

Finally the individual lines – the player box score. The `<entity>` is
still `game`, the `<detail>` is the `player_box`:

``` r

player_box <- espn_cfb_game_player_box(game_id = 401628339)
player_box |>
  select(any_of(c("team", "athlete_display_name", "category",
                  "stat_name", "stat_value"))) |>
  head(10)
```

Three functions, one game, one consistent prefix. If you later want the
per-team leaders, you already know it is
[`espn_cfb_game_team_leaders()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_leaders.md);
if you want each team’s roster *as it appeared in this game*, it is
[`espn_cfb_game_team_roster()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_team_roster.md).
You are guessing the names correctly now because the names are not
really being guessed – they are being *spelled*.

------------------------------------------------------------------------

## Recipe 3 – Play-by-play and who was on the field

**The question:** Walk me through the game play by play – and tell me
which players were involved in each play.

[`espn_cfb_game_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_pbp.md)
is the play-by-play detail of a game: one tidy row per play. On its own
that is a clean play log. The interesting part is the `participants`
argument, which decides whether the *people* involved in each play come
along for the ride.

- `participants = "none"` (default) – just the plays.
- `participants = "wide"` – the involved athletes spread into columns on
  the play row (`participant_1_*`, `participant_2_*`, …). Best when you
  want one flat table.
- `participants = "long"` – one extra row per athlete per play.

``` r

pbp <- espn_cfb_game_pbp(game_id = 401628339, participants = "wide")
pbp |>
  select(any_of(c("play_id", "period_number", "type_text",
                  "text"))) |>
  head(8)
```

``` r

# The participant_* columns ride alongside each play in "wide" mode.
pbp |>
  select(any_of(grep("participant", names(pbp), value = TRUE))) |>
  head(5)
```

By default these wrappers also enrich every team-id column with readable
team detail – that is the `team_detail = TRUE` argument you will see on
most `espn_cfb_game_*()` functions. It is what turns a bare `team_id`
into a `team`, `team_abbreviation`, and team colors without a manual
join. If you ever want the raw, un-joined frame – for a smaller object,
or to do the join yourself – pass `team_detail = FALSE`.

``` r

# team_detail = TRUE is the default; this just makes it explicit.
pbp_plain <- espn_cfb_game_pbp(game_id = 401628339, team_detail = FALSE)
ncol(pbp) - ncol(pbp_plain)  # the team-detail columns that the join adds
```

------------------------------------------------------------------------

## Recipe 4 – From drives to plays

**The question:** I do not want a flat play log – I want the game
organized into *drives*, and then I want to drill from a drive down to
its plays.

[`espn_cfb_game_drives()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_drives.md)
is the drive-level detail of a game: one row per possession, with the
result, yardage, and clock for each. Its `plays` argument controls how
much detail rides along:

- `plays = "none"` (default) – just the drive summaries.
- `plays = "list"` – a `plays` list-column, one nested play table per
  drive.
- `plays = "expand"` – the drives unnested all the way down to one row
  per play, drive context carried along on every play row (`drive_*`
  columns).

``` r

drives <- espn_cfb_game_drives(game_id = 401628339)
drives |>
  select(any_of(c("drive_id", "team", "drive_result",
                  "yards", "offensive_plays"))) |>
  head(6)
```

When you want plays *and* their drive context in one flat table,
`plays = "expand"` does it in a single call:

``` r

drive_plays <- espn_cfb_game_drives(game_id = 401628339, plays = "expand")
drive_plays |>
  select(any_of(c("drive_id", "drive_result", "play_id",
                  "type_text"))) |>
  head(8)
```

There is also a two-step route, and it is worth knowing because it shows
the package’s split between *fetching* and *transforming*. Pull the
drives once with `plays = "list"`, then flatten with
[`espn_cfb_unnest_plays()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_unnest_plays.md)
– a pure transform, no second web request:

``` r

drives_listed <- espn_cfb_game_drives(game_id = 401628339, plays = "list")
unnested <- espn_cfb_unnest_plays(drives_listed)
identical(
  sort(names(unnested)),
  sort(names(drive_plays))
)
```

Same flat table, two roads to it: the `plays = "expand"` shortcut, or
`plays = "list"` plus
[`espn_cfb_unnest_plays()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_unnest_plays.md).
Reach for the second when you already have a `"list"`-shaped drives
object in hand and do not want to pay for the request again.

------------------------------------------------------------------------

## Recipe 5 – Modeled play-by-play with EPA and WPA

**The question:** The play log is fine, but I want the *valuation* –
Expected Points Added and Win Probability Added on every play.

This is where `cfbfastR` stops being a thin API client and starts being
an analytics package.
[`espn_cfb_pbp_v2()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp_v2.md)
is the modern, core-v2-sourced play-by-play function. With its default
`epa_wpa = FALSE` it returns the assembled play-by-play frame –
structurally the same idea as Recipe 3, just sourced from the more
robust core-v2 drives endpoint.

The payoff is `epa_wpa = TRUE`. Flip that switch and the same EPA/WPA
modeling stack the package has always run – the `mgcv` GAMs, the
expected-points model, the field-goal and win-probability models – gets
applied to the play frame.

``` r

pbp_v2 <- espn_cfb_pbp_v2(game_id = 401628339, epa_wpa = TRUE)
pbp_v2 |>
  select(any_of(c("play_id", "down", "distance", "yards_gained",
                  "ep_before", "ep_after", "EPA",
                  "wp_before", "wp_after", "wpa"))) |>
  head(10)
```

`ep_before` / `ep_after` and `EPA` are the expected-points columns;
`wp_before` / `wp_after` and `wpa` are the win-probability ones. From
here a team’s offensive EPA per play for the game is a one-liner:

``` r

pbp_v2 |>
  filter(!is.na(EPA), !is.na(pos_team)) |>
  group_by(pos_team) |>
  summarise(plays = dplyr::n(),
            epa_per_play = round(mean(EPA), 3),
            .groups = "drop")
```

The `_v2` suffix is the one place the naming pattern carries a *version*
rather than an entity/detail – it marks the modern successor to the
legacy
[`espn_cfb_pbp()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp.md).
For new work, prefer
[`espn_cfb_pbp_v2()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_pbp_v2.md).

------------------------------------------------------------------------

## Recipe 6 – QBR, power ratings, and recruiting

**The question:** Step back from a single game – I want season-level
context. How good is each team, who are the best quarterbacks, and who
is signing the best classes?

These three live on the *ratings* and *catalog* shelves, and they are
all keyed by `year` rather than `game_id` – a tell that they describe a
whole season.

ESPN’s quarterback rating, season-wide, is
[`espn_cfb_qbr()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_qbr.md):

``` r

qbr <- espn_cfb_qbr(year = 2024)
qbr |>
  select(any_of(c("athlete_display_name", "team_short_name",
                  "qbr_total", "qb_plays"))) |>
  head(8)
```

ESPN’s Football Power Index – their team strength rating – is
[`espn_cfb_powerindex()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_powerindex.md):

``` r

fpi <- espn_cfb_powerindex(year = 2024)
fpi |>
  filter(stat_name == "fpi") |>
  select(any_of(c("team_id", "display_name", "value"))) |>
  arrange(desc(value)) |>
  head(8)
```

And the recruiting class – the incoming talent – is
[`espn_cfb_recruits()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_recruits.md):

``` r

recruits <- espn_cfb_recruits(year = 2024, max_results = 25)
recruits |>
  select(any_of(c("rank", "name", "position", "grade",
                  "school_name"))) |>
  head(10)
```

Three different questions – quarterback quality, team strength,
recruiting – three functions, and every one of them asked for by `year`.
When a function takes a `year` and no `game_id`, you are looking at a
season-level summary; when it takes a `game_id`, you are inside a single
game. That single signature cue tells you the *grain* of the data before
you have read a word of the help page.

------------------------------------------------------------------------

## A note on caching

Several `espn_cfb_*()` wrappers enrich their output with two
slow-changing catalogs – the full team list
([`espn_cfb_teams()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_teams.md))
and the position list
([`espn_cfb_positions()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_positions.md)).
Re-fetching those on every call would be wasteful, so `cfbfastR`
memoises them.

You control the cache backend with the `cfbfastR.cache` option, set
**before** loading the package:

- `"memory"` (default) – in-memory cache, gone when the R session ends.
- `"filesystem"` – persistent on-disk cache, survives between sessions.
- `"off"` – no memoisation; every catalog lookup hits ESPN.

``` r

# Set this before library(cfbfastR) to persist the catalog cache to disk.
options(cfbfastR.cache = "filesystem")
```

When you want to force a fresh pull of the catalogs – after a
long-running session, or while debugging – clear the memoised lookups
with
[`espn_cfb_clear_cache()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_clear_cache.md):

``` r

espn_cfb_clear_cache()
```

It returns invisibly and is a safe no-op when caching is `"off"`.

------------------------------------------------------------------------

## A note on proxies

If you’re working from a network that routes outbound HTTP through a
corporate proxy, you don’t need to thread a `proxy = ...` argument
through every `cfbd_*()` call. `cfbfastR`’s internal HTTP helper
(`get_req()`) resolves a proxy in this order:

1.  An explicit `proxy` argument passed to the wrapper (highest
    precedence).
2.  `getOption("cfbfastR.proxy")` – a session-level fallback.
3.  The standard `http_proxy` / `https_proxy` / `no_proxy` environment
    variables, which libcurl reads automatically.

The recommended pattern is to set the option once at the top of your
script and let every subsequent call pick it up:

``` r

options(cfbfastR.proxy = "http://proxy.host.example:8080")

# Every cfbd_*() and espn_cfb_*() call now routes through the proxy.
teams <- espn_cfb_teams()
plays <- cfbd_pbp_data(year = 2024, week = 1, team = "Georgia")
```

For an authenticated proxy, pass a named list with `url` / `port` /
`username` / `password` / `auth` – the list is spread directly into
[`httr2::req_proxy()`](https://httr2.r-lib.org/reference/req_proxy.html):

``` r

options(cfbfastR.proxy = list(
  url      = "http://proxy.host.example",
  port     = 8080,
  username = "me",
  password = "pw",
  auth     = "basic"
))
```

If you prefer the environment-variable path – handy in CI containers and
Docker images where the proxy is already exported – nothing extra is
needed in R, but you can also set them from the session:

``` r

Sys.setenv(https_proxy = "http://proxy.host.example:8080")
```

The ESPN wrappers (`espn_cfb_*()`, `espn_metrics_*()`,
`espn_ratings_*()`) don’t expose a per-call `proxy =` argument, but they
go through the same `httr2` stack and honour the same env-var-based
proxy handling, so a single
[`options()`](https://rdrr.io/r/base/options.html) or env-var setup
covers the whole package.

------------------------------------------------------------------------

## Where to go next

We covered seven recipes and touched maybe fifteen functions – but the
`espn_cfb_*()` family has roughly sixty. The point of this cookbook was
never to enumerate them. It was to make the *next* one predictable.

You now know the grammar: `espn_cfb_<entity>_<detail>`, plural for the
catalog and singular for one entity in depth; `team_*` for programs and
`game_*` for single games; a `year` argument means season-level and a
`game_id` argument means inside-a-game. Want each game’s win-probability
chart inputs? Reach for
[`espn_cfb_game_probabilities()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_game_probabilities.md).
Want a player’s game-by-game log? That is
[`espn_cfb_player_gamelog()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_player_gamelog.md).
Want the season’s weekly rankings? Try
[`espn_cfb_week_rankings()`](https://cfbfastR.sportsdataverse.org/reference/espn_cfb_week_rankings.md).

You will be right more often than not – because in this package,
guessing the name and knowing the name are very nearly the same thing.
