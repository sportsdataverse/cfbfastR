# Parity oracles

`fixture_games.json` — the 60-game offline corpus most oracles here are drawn from: 5 games from each
of 2004, 2006, 2008, 2010, 2013, 2014, 2017, 2019, 2020, 2021, 2023 and 2025, spread across each
season including the postseason (`game_id`, `week`, `season_type`, `has_participants`). The list
straddles 2014 on purpose: before it ESPN ships no structured `participants[]`, so the early games
exercise the text-only parsing path. Committed 2026-08-19 with cfbfastR #129 (`28d61b99`).

`sdvpy_golden.parquet`, `attribution_oracle.parquet`, `direction_oracle.parquet`,
`participants_oracle.parquet`, `boxparity_pbp.parquet`, `boxparity_box.parquet`,
`game_rosters.parquet`, `game_boxscores.parquet`, `play_participants.parquet` — committed 2026-08-19
with cfbfastR #129 (`28d61b99`), generated offline from the ESPN summary payloads banked in
cfbfastR-cfb-raw (`cfb/json/raw/`, plus its `cfb/game_rosters/` and `cfb/play_participants/`) for the
`fixture_games.json` games, with zero API calls. **Provenance gap:** the sportsdataverse-py commit
they were captured from and the generator script were not recorded, so unlike the oracles below they
cannot be re-captured as-is; a re-capture needs a new `data-raw/` generator (and should record the
sdv-py commit here). Until then, do not hand-edit them. What each holds (`fixture_game_id` keys the
game; play `id` is the ESPN play id):

- `sdvpy_golden.parquet` — 9,549 plays of the 60 games as sdv-py's `CFBPlayProcess` emitted them
  (114 columns: penalty detection and enforcement, attribution and turnover flags, player names and
  `*_player_id`, air yards, pass / rush direction). Read by `test-parity_penalty_enforcement.R`,
  `test-parity_player_ids.R` and `test-pbp_regex_case.R`.
- `attribution_oracle.parquet` — 9,545 rows (56 game ids): every column sdv-py's
  `__add_attribution_cols` reads, and every column it writes suffixed `__out`.
  `test-parity_attribution.R`.
- `direction_oracle.parquet` — the same rows: the inputs and `__out` outputs of the depth / direction
  block of `__add_player_cols`. `test-parity_air_yards.R`.
- `participants_oracle.parquet` — the same rows: the eleven `*_player_name` columns immediately before
  (`__before`) and after (`__after`) sdv-py's `__join_participants`. `test-parity_join_participants.R`.
- `play_participants.parquet` — 5,384 rows (34 games): ESPN `participants[]` names per play, the
  stage's other input. `test-parity_join_participants.R`.
- `game_rosters.parquet` (8,829 rows, 56 games) and `game_boxscores.parquet` (2,018 rows, 57 games) —
  the roster and box-score athlete records (`athlete_id`, display name, `team_id`) sdv-py's
  `__attach_player_ids` resolves against. `test-parity_player_ids.R`.
- `boxparity_pbp.parquet` (9,549 plays) and `boxparity_box.parquet` (120 team-games) — sdv-py's
  per-play flags and yardage, and ESPN's official team box, for the pbp-to-box-score gate ported
  from sdv-py `tools/validation/checks/boxscore_parity`. `test-pbp_boxscore_parity.R`.

`airyards_oracle.parquet` — captured 2026-09-01 from sportsdataverse-py `9efee9f1`
(`CFBPlayProcess.run_processing_pipeline()` run offline on the ESPN summary payloads banked in
cfbfastR-cfb-raw `cfb/json/raw/`, `join_participants = False`). One row per play; every column
`__add_air_yards_cols` reads is an input, every column it writes is suffixed `__out`;
`fixture_game_id` groups rows per game (the R helper learns each game's text abbreviations from
its own end spots, so it must be replayed per game).

Games: the 56 offline fixture games in `fixture_games.json` (2004-2025) plus five 2025/2026 games
whose vendor text abbreviation differs from ESPN's (`TA&M-SC` 401752772, `UNLV-HAW` 401760418,
`CCU-GAST` 401761645, `LIB-DEL` 401757293, `NDSU-JVST` 401864577) — the case sdv-py #418 fixed.

Re-capture: `python data-raw/parity_airyards_oracle.py` (env `SDV_PY_ROOT`, `CFB_RAW_JSON` override the
default droplet paths); do not hand-edit the parquet.

`amp0_oracle.csv` — captured 2026-09-30 from sportsdataverse-py `71a8f0863` (#636, #638, #639), same offline
pipeline as above, for eight games (401752671, 400559176, 400548315, 400787459, 400869264,
400763571, 400548134, 400547673). One row per ESPN play whose raw `start.distance` is 0 with a
"& 0 at" down-and-distance text (no "Goal") that sdv-py's processing gives a non-zero distance:
`game_id`, `id_play`, `start_down_distance_text`, `sdvpy_distance`. Re-capture: `python data-raw/parity_amp0_oracle.py` (env `SDV_PY_ROOT`, `CFB_RAW_JSON`); do not
hand-edit the csv. (It writes only the csv.)

`play_order_oracle.csv.gz` — captured 2026-09-30 from sportsdataverse-py `71a8f0863` by replaying
the final `_sort_plays_ot_aware()` call (id sort, `_reorder_late_inserts`, `_reunite_drive_rows`,
`_place_tries_filed_after_the_kickoff`, overtime order) on each game's raw ESPN plays, offline, for
45 games picked so that each repair and guard decides at least one game (late inserts, drive
reunite, the 323080276 try carry, the five tries-after-kickoff games, overtime by sequence and by id
with a backstep tie, duplicate/variable-length ids, one untouched 2004 game). One row per raw play:
the inputs `.espn_play_order()` reads (`row` = feed position, 0-based) and `sdvpy_rank`, the row's
0-based position in sdv-py's order. `type` is the raw feed value; the rank comes from sdv-py's final
sort (`__add_downs_data`), which sees a typeless play as "Unknown". The `(id, clock)` tiebreak of
the id sort changes no game in the 20,719-game raw corpus, so no fixture game exercises it. sdv-py
also retypes a few untyped try rows before that final sort (401525903's "two-point conversion
rushing attempt failed" becomes Two-Point Conversion Missed, the only such row 2004-26); the game is
left out here: its order depends on that relabel, which `.espn_retype_plays()` ports
(`retype_oracle.csv.gz`). Re-captured 2026-10-19 from sportsdataverse-py `5a36d43fb5`
(`devel-cfb`, after #908) on cfbfastR-cfb-raw `19865a79e3`, adding the 17 games where
`_place_out_of_scheme_plays` fires: a play filed under a 10-digit `<game_id>0` id among 18-digit
ids, every such game in the 23,024-game 2004-26 raw corpus (`test-pbp_play_order_out_of_scheme.R`).
The first 45 games' rows are byte-identical to the 2026-09-30 capture. Re-capture:
`python data-raw/parity_play_order_oracle.py` (env `SDV_PY_ROOT`, `CFB_RAW_JSON`); do not
hand-edit the file.

`retype_oracle.csv.gz` — captured 2026-10-01 from sportsdataverse-py `88acd48d2` (#642, #643): every
play of 22 games as it leaves `__helper_cfb_pbp_features()` (same offline pipeline, in that stage's
order), with the inputs `.espn_retype_plays()` reads, the type before the relabel block at its end
(`orig_play_type`), after it (`sdvpy_type`, `sdvpy_start_ytg`) and after the later pre-2014 label
normalization in `__add_new_play_types()` (`sdvpy_type_normalized`, recorded for the rows carrying
the three labels it acts on); `start_ytg` is the feed's start spot. For the start state it also
records the feed's start down, distance, yard line and team, the end state the stage holds (what
sdv-py's previous-play lookup reads), sdv-py's resulting start down and distance
(`sdvpy_start_down`, `sdvpy_start_distance`: a 2007-13 touchdown filed as its own kick takes the
snap's down, sportsdataverse-py #643), and the home team (`.espn_fill_spots()`: the 2004 feed's 0
start spots). Games: 2004 kicks typed only by `scoringType` (243250238, 243582132) and an untyped
defensive try (243392572); 2007-13 touchdown + kick rows (292832449, 303102638 from goal to go past
the 10, 312462638, 332782638, 302602440) and two a single team started and ended (273000264,
322660194); defensive try returns (312530264, 272650152); kick-typed misfiles (303100030,
303170158); the untyped two-point try 401525903 and the overtime copies that stay "Unknown"
(401426542); a failed bare "2pt Conversion" (292542649) and an onside "Kickoff Return (Defense)"
(242480152); two games with nothing to relabel; and blocked field goals sdv-py mistyped until #642
(400547866, 400547865), now ESPN's type on both sides. Five conditions change no row in the
20,719-game raw corpus and so decide no fixture row: the untyped try's period <= 4 and same-clock
checks, the return touchdown's no-play check, and the normalization's untyped "field goal / extra
point is good" rules (`scoringType` already types those rows). Re-capture: `python
data-raw/parity_retype_oracle.py` (env `SDV_PY_ROOT`, `CFB_RAW_JSON`); do not hand-edit the file.

`copies_oracle.csv.gz` — re-captured 2026-10-01 from sportsdataverse-py `1f7ad730b` (#651, first
captured 2026-09-30 at `71a8f0863`): the frame sdv-py
hands `_drop_espn_play_copies()` (after its first play sort, in that order; `row` is the position)
for 20 games, with the inputs `.espn_play_copies()` reads, whether sdv-py drops the row there or in
the adjacent-copy rule after it (`sdvpy_drop`), the type a stub echo leaves on the play it repeats
(`sdvpy_type`), and the fields `.espn_play_order()` reads (`sequence`, `start_text`, `end_text`,
`home_score`, `away_score`) so the Core-v2 wrapper can be replayed in sdv-py's order. Games: stub
echoes, stale drive batches and copies across a marker (401752854 carries all three, and the only
stub echo in the corpus whose type differs from its play's), 272512348, 282640084, 283330145,
312810077, 313232005, 401287947, 401525890; adjacent copies and same-id live repeats (401411109,
302750249, 401645383, 401754601); guard cases found by running each mutant over 487 captured games
(a batch with one exact twin 400548311, a spotless pair 242620052, the same play across a marker at
another clock 292552084); textless echoes, before the play at the previous play's clock (401403886)
and ahead of their plays in another order (292760096), and textless FCS rushes that are real plays
(401540473); two games with nothing to drop. sdv-py drops untyped admin rows before this frame
(`_UNTYPED_ADMIN_RE`), so they are not in it; `.espn_drop_play_copies()` drops them first (see
`admin_oracle.csv.gz`). The textless rule's marker guard, its `ytg != 0` guard, and `type` / `drive`
in its key are not decided by any of these games either. No game in those 487 or in the 20,719-game
raw corpus decides four conditions: the stub rule's marker check, the twin key reading a
stub-corrected type, the no-spot exclusion from the twin and echo rules, and the adjacent rule's
same-id arm (a same-id pair always matches on text and start state too). Re-capture: `python
data-raw/parity_copies_oracle.py` (env `SDV_PY_ROOT`, `CFB_RAW_JSON`); do not hand-edit the file.

`scored_oracle.csv.gz` — captured 2026-10-01 from sportsdataverse-py `1f7ad730b` (#651): every row
`_type_espn_scored_rows()` decides (ESPN scored it and its type after sdv-py's relabels is not
already a score) in the 716 games of `data-raw/parity_scored_games.txt` -- every game of the 2004-26
finals with such a row -- and five hand-picked ones: the type, the text (`text_null` where sdv-py's is
null rather than empty), the start team's margin change sdv-py derives (`delta`), whether ESPN's
`scoringType` is a touchdown (`espn_td`), and the type it returns (`sdvpy_type`). Re-capture: `python
data-raw/parity_scored_oracle.py` (env `SDV_PY_ROOT`, `CFB_RAW_JSON`); do not hand-edit the file.

`scored_grid_oracle.csv.gz` — generated 2026-10-01 by sportsdataverse-py `1f7ad730b` (#651)'s own
`_type_espn_scored_rows()`, a pure function, on 18,496 synthetic rows: 17 types x 17 texts (null
included) x 16 margin changes x ESPN's touchdown flag x the scoring flag. The real-corpus oracle above
leaves branches no 2004-26 game decides (the frozen-board offence, punt-team and missed-field-goal
returns, the margin window's edges, the negation); the expected types still come from sdv-py, not a
re-implementation. Re-capture: `python data-raw/parity_scored_grid_oracle.py`; do not hand-edit.

`score_delta_oracle.csv.gz` — captured 2026-10-01 from sportsdataverse-py `1f7ad730b` (#651): every
row sdv-py keeps after its copy rules in 18 games, with the feed's type, team ids and scores, the type
after its relabels (for the period markers), the header's final score, and the start team's margin
change sdv-py derives (`end.pos_score_diff - start.pos_score_diff`; empty on the markers it drops) --
which `.espn_score_delta()` reproduces. Games: boards kept reversed all game (262590245, 400876038,
400876049, 401135269), score glitches (401762835, 401752684, 401301042, 401628428), a touchdown snap
filed for the other team (243110264, 322590228), scored rows (400756970, 300020151, 283130309,
282640084, 272512655), kickoffs and fumble returns (400548343, 401234617, 272650194). Re-capture:
`python data-raw/parity_score_delta_oracle.py`; do not hand-edit the file.

`admin_oracle.csv.gz` — captured 2026-10-01 from sportsdataverse-py `1f7ad730b` (#651): every feed
play of six games with sdv-py's untyped-admin filter applied (`type.text` null and the text matching
`_UNTYPED_ADMIN_RE`): 2004's untyped markers (243042579) and "Begin Drive" (242462628), an OT drive
header (262522509), empty rows (272870068), a lone kick (401752914), lone two-point tries in OT
(401426542). Re-capture: `python data-raw/parity_admin_oracle.py`; do not hand-edit the file.

`odds_oracle.csv` + `odds_pickcenter.json` — captured 2026-10-12 LIVE from sportsdataverse-py `f552e15dc`
(`CFBPlayProcess.run_processing_pipeline()`; the pre-game line comes from `__helper_cfb_pickcenter`). Eight
games: 401112080, 401121960 (2019) and 401416632, 401416633 (2022) resolve from the summary `pickcenter`;
401762862, 401762864, 401752912, 401752776 (2025) from ESPN's core odds API, `pickcenter` being empty for 2024+.
`spread` is the home line cfbfastR emits (negative = home favoured); every spread and total equals one CFBD
provider's line for the same game. `odds_pickcenter.json` holds the raw `pickcenter` arrays, so that path is
tested offline. Re-capture: `python data-raw/parity_odds_oracle.py` (env `SDV_PY_ROOT`; needs network); do not
hand-edit the files.

`epa_wp_oracle.csv.gz` — captured 2026-10-31 from sportsdataverse-py `90471fdf11`
(`CFBPlayProcess.run_processing_pipeline()` run offline on the ESPN summary payloads banked in
cfbfastR-cfb-raw `cfb/json/raw/`, `join_participants = False`). One row per play of six games with
a real pre-game line (333302459, 400547719, 401110831, 401282116, 401520401, 401752665; 2013-2025, three where the home team kicked
off first), keyed by `game_id` + `id_play` (character). Inputs: the start state sdv-py scored the
WP and EP boosters on, under cfbfastR's names (`pos_team_receives_2H_kickoff` is the TRUE published
flag; `ep_down` / `ep_end_down` are the downs EP was scored on, from sdv-py's one-hots), and the end
state. Outputs: sdv-py's published `EP_start`, `EP_end`, `EPA`, `wp_before_naive` (cfbfastR's
`wp_before`) and `wp_before` (spread model, cfbfastR's `vegas_wp`), and `wp_naive_raw` /
`wp_spread_raw`, the boosters' output on that start state through sdv-py's own scoring path
(`_as_trained_2h_flag`, then the booster) without the overtime stage (`cfb_wp_overtime.adjust_wp`),
which cfbfastR has not ported; `ep_start_raw` / `ep_end_raw`, sdv-py's EP model on the start / end
state (the published `EP_start` / `EP_end` are that value after the pipeline's possession-flip and
scoring rules). `pos_team_won` is for calibration metrics. Re-capture: `python
data-raw/parity_epa_wp_oracle.py` (env `SDV_PY_ROOT`, `CFB_RAW_JSON`); do not hand-edit the file. The `wp_*_raw` columns are the generator's own booster calls on sdv-py's states with sdv-py's `_as_trained_2h_flag`, not values read from sdv-py's pipeline, so the WP check confirms R scores those states the same way; it does not test the trained-on-`1 - is_home` premise itself. Decision-surface WP is not in the oracle; `test-decision-state.R` pins it to sdv-py's exact values. Both libraries toggle the flag only in first-half flipped states while `is_home` always toggles, so second-half flipped states reach the booster as `flag == is_home`; that is to be fixed in sdv-py first and mirrored here.


`timeouts_oracle.csv.gz` — captured 2026-11-01 from sportsdataverse-py `4b78a45a3d` (`origin/main`,
`CFBPlayProcess.run_processing_pipeline()` run offline on the ESPN summary payloads banked in
cfbfastR-cfb-raw `cfb/json/raw/`, `join_participants = False`). One row per play of 19 games, in
sdv-py's final order: the inputs `.espn_timeouts()` reads (`period`, `type`, `text`, the header's
`*_abbr` / `*_location` / `*_name` per team, and the play's `drive_id` / `drive_start_yard_line` /
`drive_start_period`, which decide the overtime window), `start_is_home`, and sdv-py's
`homeTimeoutCalled` / `awayTimeoutCalled` and start / end timeouts remaining per team (`sdvpy_*`).
Games, each picked so a
rule decides at least one Timeout row: a name part (401752665), the clock before the team (252440248),
the 2004 mascot form with its "remaining" clock tail (243250239), ties that charge both (242620002,
283332199, 322730166), initialisms (293110009 "SOUTHERN CAL", 283270254 "BRIGHAM YOUNG"), a full name
match over an initialism (401012682 "OREGON ST"), the shortened-name resolver (252532649, 282430061,
252460251), media stoppages charged to nobody (401677188), an adjacent repeat (401761657) and five
overtime games: 302540119; 401112081 and 323152633, whose feeds number every overtime 5, so the window
comes from pairing the overtime drives (sportsdataverse-py #505); 401236005, four overtimes with an
OT4 drive row filed ahead of the OT3 drive; and 401754372, below. `.espn_overtime_period()` is a
literal port of sdv-py's `_overtime_period()`; it matches sdv-py on every row of these games and of
128 overtime games replayed from the raw corpus.

**Known bug, shared by sdv-py and cfbfastR (401754372, 5 rows; pinned, not exempted).** sdv-py's
`_overtime_period()` (`cfb/cfb_pbp.py`, used by the timeout block) counts a new overtime drive
whenever `drive.id` differs from the previous row's, for any drive starting at the 25 / 75, and
pairs those drives into periods (`5 + (count - 1) // 2`). In 401754372 (California at Virginia
Tech, 2025, two overtimes) the first overtime is three rows filed under drives 40175437237,
40175437236, 40175437237, so drive 37 is counted twice. The second overtime's drives 38 and 39
become the fourth and fifth, and drive 39 opens a third overtime window that never happened.
Virginia Tech (home) called its one second-overtime timeout at "Timeout Virginia Tech, clock 00:11",
yet both libraries report `start.homeTeamTimeouts = 1` on the five rows after it (the three
incompletions, "End of 2 OT." and "Timeout California"); the truth is 0, which sdv-py gives with
`_overtime_period` replaced by `period.number`. Both Timeout rows ("Virginia Tech" and "California")
are filed under drive 40175437219, a second-quarter drive starting at yard line 17, which the rule
does not count. Counting each overtime drive once by id fixes this game but is worse overall: on 128
replayed overtime games it disagreed with sdv-py in 10, and where the right answer could be told it
was wrong more often (300062653 files Central Michigan's OT1 touchdown under regulation drive 22;
401236005 files a row of OT4 drive 40 ahead of OT3 drive 38; 323152633 files an overtime drive at
yard line 0). A fix needs a rule that survives all of those, in sdv-py first; `test-pbp_timeouts.R`
pins the five rows at sdv-py's value so a change to either side shows. Re-capture: `python
data-raw/parity_timeouts_oracle.py` (env `SDV_PY_ROOT`, `CFB_RAW_JSON`, and `SDV_PY_SHA` when the
checkout is an export); do not hand-edit the file.

Known sdv-py divergences copied on purpose (no oracle file): the 2018 fair-catch kickoff touchback
(`.pbp_clean_pbp_dat()`, `test-pbp_kickoff_touchback.R`) is sdv-py's `kickoff_tb` rule, which its own
comment limits to a fair catch between the goal line and the receiver's 25 but which reads no catch
spot, so the 152 fair catches made beyond the 25 in the 2018-2025 raw corpus are placed at the 25 as
well. Fix it in sdv-py first, then here.
