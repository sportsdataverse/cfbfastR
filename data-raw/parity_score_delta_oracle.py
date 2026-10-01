"""Re-capture cfbfastR's ESPN score-margin parity oracle from sdv-py (offline, raw payloads on disk).

For every row sdv-py keeps after `_drop_espn_play_copies` (in that order): the feed's type, team ids
and scores, its type after the relabels (`type`, for the period markers), the header's final
score, and the start team's margin change sdv-py derives (`end.pos_score_diff -
start.pos_score_diff`, empty on the markers it drops) -- what `.espn_score_delta()` must reproduce.
"""

import csv, gzip, io, logging, os, pathlib, subprocess, sys

SDV_PY = os.environ.get("SDV_PY_ROOT", "/mnt/sdv_repos/sportsdataverse-py")  # sdv-py checkout
sys.path.insert(0, SDV_PY)
logging.disable(logging.CRITICAL)
import sportsdataverse.cfb.cfb_pbp as M

RAW = pathlib.Path(os.environ.get("CFB_RAW_JSON", "/mnt/sdv_repos/cfbfastR-cfb-raw/cfb/json/raw"))
OUT = pathlib.Path(__file__).resolve().parents[1] / "tests" / "testthat" / "fixtures" / "parity"
GAMES = [
    # boards kept reversed all game (the last row is the header's final, reversed)
    262590245, 400876038, 400876049, 401135269,
    # score glitches: a dip walked onto a touchdown (401762835), points booked again on a free kick
    # (401752684), the final carried only by the end-of-game marker (401301042, 401628428)
    401762835, 401752684, 401301042, 401628428,
    # a scored rush / pass touchdown whose snap names the other team (243110264, 322590228)
    243110264, 322590228,
    # scored rows the margin types: Miami's return at Duke (a Timeout row reads a glitched 19-24),
    # pick-sixes (300020151, 283130309, 282640084), a returner start team left alone (272512655)
    400756970, 300020151, 283130309, 282640084, 272512655,
    # kickoffs (the start team is the receiver), fumble returns closed by the kick
    400548343, 401234617, 272650194,
]
COLS = ["game_id", "id", "feed_type", "type", "text", "start_team", "end_team", "home", "away",
        "home_score", "away_score", "scoring_play", "home_final", "away_final", "sdvpy_delta"]
rec = {}
orig_copies = M._drop_espn_play_copies


def copies(df):
    out = orig_copies(df)
    rec["rows"] = out.select("id", "type.text", "text", "start.team.id", "end.team.id", "homeScore", "awayScore",
                             "scoringPlay").rows()
    return out


orig_typed = M._type_espn_scored_rows


def typed(df):
    rec["delta"] = dict(zip(df["id"].to_list(), (df["end.pos_score_diff"] - df["start.pos_score_diff"]).to_list()))
    return orig_typed(df)


M._drop_espn_play_copies = copies
M._type_espn_scored_rows = typed
C = M.CFBPlayProcess
orig_downs = C._CFBPlayProcess__add_downs_data


def downs(self, play_df):
    rec["type"] = dict(zip(play_df["id"].to_list(), play_df["type.text"].to_list()))
    rec["meta"] = play_df.select("homeTeamId", "awayTeamId", "homeFinalScore", "awayFinalScore").row(0)
    return orig_downs(self, play_df)


C._CFBPlayProcess__add_downs_data = downs
rows = []
for gid in GAMES:
    rec.clear()
    p = C(gameId=gid, path_to_json=str(RAW))
    p.join_participants = False
    p.cfb_pbp_disk()
    p.run_processing_pipeline()
    home, away, hf, af = rec["meta"]
    for i, ft, tx, st, et, hs, as_, sp in rec["rows"]:
        rows.append([gid, i, ft, rec["type"].get(i, ft), tx, st, et, home, away, hs, as_, sp, hf, af,
                     rec["delta"].get(i)])
sha = subprocess.check_output(["git", "-C", SDV_PY, "rev-parse", "--short", "HEAD"]).decode().strip()
with open(OUT / "score_delta_oracle.csv.gz", "wb") as fh_raw, gzip.GzipFile(fileobj=fh_raw, mode="wb", mtime=0) as gz:
    fh = io.TextIOWrapper(gz, encoding="utf-8", newline="")
    w = csv.writer(fh, lineterminator="\n")
    w.writerow(COLS)
    w.writerows(rows)
    fh.flush()
    fh.detach()
print("games", len(GAMES), "rows", len(rows), "with delta", sum(r[-1] is not None for r in rows), "sdv-py", sha)
