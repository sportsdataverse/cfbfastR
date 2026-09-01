"""Re-capture cfbfastR's air-yards parity oracle from sdv-py (offline, raw payloads on disk)."""
import datetime, json, os, pathlib, subprocess, sys
import polars as pl
SDV_PY = os.environ.get('SDV_PY_ROOT', '/mnt/sdv_repos/sportsdataverse-py')  # sdv-py checkout (or leave importable)
sys.path.insert(0, SDV_PY)
from sportsdataverse.cfb import CFBPlayProcess
RAW = os.environ.get('CFB_RAW_JSON', '/mnt/sdv_repos/cfbfastR-cfb-raw/cfb/json/raw')  # banked ESPN summaries
OUT = pathlib.Path(__file__).resolve().parents[1] / 'tests' / 'testthat' / 'fixtures' / 'parity'
fg = json.load(open(OUT / 'fixture_games.json'))
ids = [g['game_id'] for season in fg.values() for g in season]
extra = [401752772, 401760418, 401761645, 401757293, 401864577]  # 2025 TA&M-SC, UNLV-HAW, CCU-GAST, LIB-DEL; 2026 NDSU-JVST
ids = ids + [g for g in extra if g not in ids]
IN = ['id','text','start.yardsToEndzone','end.yardsToEndzone','pos_team','def_pos_team','homeTeamId','awayTeamId','homeTeamAbbrev','awayTeamAbbrev','statYardage','completion','pass']
OUTC = ['air_yardsToEndzone','air_yards','yards_after_catch']
frames = []; missing = []
for gid in ids:
    if not pathlib.Path(f'{RAW}/{gid}.json').exists(): missing.append(gid); continue
    p = CFBPlayProcess(gameId=gid, path_to_json=RAW); p.join_participants = False; p.cfb_pbp_disk()
    plays = p.run_processing_pipeline()['plays']
    if not plays: missing.append(gid); continue
    df = pl.DataFrame([{**{c: r.get(c) for c in IN}, **{f'{c}__out': r.get(c) for c in OUTC}} for r in plays], infer_schema_length=None)
    df = df.with_columns(pl.lit(gid, dtype=pl.Int64).alias('fixture_game_id'),
                         *[pl.col(c).cast(pl.Utf8) for c in ('id','pos_team','def_pos_team','homeTeamId','awayTeamId')],
                         *[pl.col(c).cast(pl.Int64) for c in ('start.yardsToEndzone','end.yardsToEndzone','statYardage','air_yardsToEndzone__out','air_yards__out','yards_after_catch__out')])
    frames.append(df)
oracle = pl.concat(frames, how='diagonal_relaxed')
oracle.write_parquet(OUT / 'airyards_oracle.parquet')
sha = subprocess.check_output(['git','-C',SDV_PY,'rev-parse','--short','HEAD']).decode().strip()
spot = oracle.filter(pl.col('text').str.contains(r'(?i)caught at|thrown to'))
print('games', oracle['fixture_game_id'].n_unique(), 'rows', oracle.height, 'spot-phrase rows', spot.height, 'resolved', spot['air_yards__out'].is_not_null().sum(), 'missing raw', missing, 'sdv-py', sha)
(OUT / 'README.md').write_text(f"""# Parity oracles

`airyards_oracle.parquet` — captured {datetime.date.today()} from sportsdataverse-py `{sha}`
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
""")
