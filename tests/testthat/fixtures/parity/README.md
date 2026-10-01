# Parity oracles

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
(`retype_oracle.csv.gz`). Re-capture: `python data-raw/parity_play_order_oracle.py` (env
`SDV_PY_ROOT`, `CFB_RAW_JSON`); do not hand-edit the file.

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
(`_UNTYPED_ADMIN_RE`), so they are not in it; `.espn_drop_play_copies()` drops them first. No game in those 487 or in the 20,719-game
raw corpus decides four conditions: the stub rule's marker check, the twin key reading a
stub-corrected type, the no-spot exclusion from the twin and echo rules, and the adjacent rule's
same-id arm (a same-id pair always matches on text and start state too). Re-capture: `python
data-raw/parity_copies_oracle.py` (env `SDV_PY_ROOT`, `CFB_RAW_JSON`); do not hand-edit the file.

`scored_oracle.csv.gz` — captured 2026-10-01 from sportsdataverse-py `1f7ad730b` (#651): every
ESPN-scored row (`scoringPlay`) of 20 games as sdv-py hands `_type_espn_scored_rows()` its type (after
its relabels), text, the start team's margin change on the row (`delta`) and whether ESPN's
`scoringType` is a touchdown (`espn_td`), with the type it returns (`sdvpy_type`). Games: frozen-board
pick-sixes (282640084, 262922117, 292970166), 2004-07 fumble returns with no touchdown word
(272650194), 2014+ fumble returns closed by the kick (401234617, 400547643), strip-sacks at the 0
(253090038), a kickoff team's recovery (282780036), kick and punt returns typed Kickoff / Punt
(400548343, 400548079, 401309833), field goals typed as a snap (292832633, 283340228, 312912032,
303310150), Miami's game-ending kickoff return at Duke (400756970), a blocked field goal returned on
a frozen board (332640098), and rows left alone: ESPN's start team is the returner (272512655), a
frozen-board rush fumble (292970254), "fumbled in the endzone" with no touchdown (302890062).
Re-capture: `python data-raw/parity_scored_oracle.py` (env `SDV_PY_ROOT`, `CFB_RAW_JSON`); do not
hand-edit the file.
