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
rushing attempt failed" becomes Two-Point Conversion Missed, the only such row 2004-26); cfbfastR
does not port that relabel, so the game is left out. Re-capture: `python
data-raw/parity_play_order_oracle.py` (env `SDV_PY_ROOT`, `CFB_RAW_JSON`); do not hand-edit the
file.

`copies_oracle.csv.gz` — captured 2026-09-30 from sportsdataverse-py `71a8f0863`: the frame sdv-py
hands `_drop_espn_play_copies()` (after its first play sort, in that order; `row` is the position)
for 17 games, with the inputs `.espn_play_copies()` reads, whether sdv-py drops the row there or in
the adjacent-copy rule after it (`sdvpy_drop`), and the type a stub echo leaves on the play it
repeats (`sdvpy_type`). Games: stub echoes, stale drive batches and copies across a marker
(401752854 carries all three, and the only stub echo in the corpus whose type differs from its
play's), 272512348, 282640084, 283330145, 312810077, 313232005, 401287947, 401525890; adjacent
copies and same-id live repeats (401411109, 302750249, 401645383, 401754601); guard cases found by
running each mutant over 487 captured games (a batch with one exact twin 400548311, a spotless pair
242620052, the same play across a marker at another clock 292552084); two games with nothing to
drop. No game in those 487 or in the 20,719-game raw corpus decides four conditions: the stub rule's
marker check, the twin key reading a stub-corrected type, the no-spot exclusion from the twin and
echo rules, and the adjacent rule's same-id arm (a same-id pair always matches on text and start
state too). Re-capture: `python data-raw/parity_copies_oracle.py` (env `SDV_PY_ROOT`,
`CFB_RAW_JSON`); do not hand-edit the file.
