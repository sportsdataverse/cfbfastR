"""Re-capture cfbfastR's ESPN "& 0 at" distance parity oracle from sdv-py (offline, raw payloads on disk).

Records, per game, the ESPN rows whose start.distance is 0 with a "& 0 at" down-and-distance
text (no "Goal") and the distance sdv-py's processing gives them (`_repair_amp0_distance`,
sportsdataverse-py #636). Only changed rows are kept.
"""
import csv, os, pathlib, re, subprocess, sys
SDV_PY = os.environ.get('SDV_PY_ROOT', '/mnt/sdv_repos/sportsdataverse-py')  # sdv-py checkout
sys.path.insert(0, SDV_PY)
from sportsdataverse.cfb import CFBPlayProcess
RAW = os.environ.get('CFB_RAW_JSON', '/mnt/sdv_repos/cfbfastR-cfb-raw/cfb/json/raw')
OUT = pathlib.Path(__file__).resolve().parents[1] / 'tests' / 'testthat' / 'fixtures' / 'parity'
# goal-to-go, lost distance, a 4th-down FG row, overtime, and games where the rule changes nothing
GAMES = [401752671, 400559176, 400548315, 400787459, 400869264, 400763571, 400548134, 400547673]
rows = []
for gid in GAMES:
    p = CFBPlayProcess(gameId=gid, path_to_json=RAW)
    p.join_participants = False
    p.cfb_pbp_disk()
    for r in p.run_processing_pipeline()['plays']:
        t = r.get('start.downDistanceText') or ''
        if re.search(r'& 0 at', t) and not re.search(r'(?i)goal', t) and r.get('start.distance') not in (0, None):
            rows.append({'game_id': gid, 'id_play': str(r['id']), 'start_down_distance_text': t,
                         'sdvpy_distance': int(r['start.distance'])})
sha = subprocess.check_output(['git', '-C', SDV_PY, 'rev-parse', '--short', 'HEAD']).decode().strip()
with open(OUT / 'amp0_oracle.csv', 'w', newline='') as fh:
    w = csv.DictWriter(fh, fieldnames=['game_id', 'id_play', 'start_down_distance_text', 'sdvpy_distance'], lineterminator='\n')
    w.writeheader(); w.writerows(rows)
print('games', len(GAMES), 'changed rows', len(rows), 'sdv-py', sha)
