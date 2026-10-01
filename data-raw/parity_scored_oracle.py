"""Re-capture cfbfastR's ESPN scored-row parity oracle from sdv-py (offline, raw payloads on disk).

Records every row `_type_espn_scored_rows` decides -- ESPN scored it (`scoringPlay`) and its type
after sdv-py's relabels is not already a score -- in the 716 games of `parity_scored_games.txt`
(every game of the 2004-26 finals with such a row) and a few hand-picked ones: the type, the text
(`text_null` when sdv-py's is null rather than empty), the start team's margin change on the row,
whether ESPN's `scoringType` is a touchdown, and the type sdv-py returns (`sdvpy_type`).
The margin itself is checked by score_delta_oracle.csv.gz.
"""

import csv, gzip, io, logging, multiprocessing as mp, os, pathlib, subprocess, sys

SDV_PY = os.environ.get("SDV_PY_ROOT", "/mnt/sdv_repos/sportsdataverse-py")  # sdv-py checkout
RAW = pathlib.Path(os.environ.get("CFB_RAW_JSON", "/mnt/sdv_repos/cfbfastR-cfb-raw/cfb/json/raw"))
HERE = pathlib.Path(__file__).resolve().parent
OUT = HERE.parent / "tests" / "testthat" / "fixtures" / "parity"
PICKED = [
    # Miami's game-ending return at Duke; a blocked field goal returned on a frozen board; left
    # alone: ESPN's start team is the returner, a frozen-board rush fumble, "fumbled in the endzone"
    400756970, 332640098, 272512655, 292970254, 302890062,
]
COLS = ["game_id", "id", "type", "text", "text_null", "scoring_play", "delta", "espn_td", "sdvpy_type"]


_REC = []


def _install():
    # once per worker: re-patching per game would wrap the previous game's hook, and that hook
    # would keep recording (under its own game id) into a list the pool has not sent back yet
    sys.path.insert(0, SDV_PY)
    logging.disable(logging.CRITICAL)
    import polars as pl
    import sportsdataverse.cfb.cfb_pbp as M

    known = {*M.scores_vec, *M.offense_score_vec, *M.defense_score_vec, *M._TRY_TYPES, "Kickoff Return Touchdown"}
    orig = M._type_espn_scored_rows

    def hook(df):
        out = orig(df)
        td = (df["scoringType.name"].cast(pl.Utf8).fill_null("") == "touchdown") if "scoringType.name" in df.columns \
            else pl.Series([False] * df.height)
        for r, t, new in zip(df.iter_rows(named=True), td, out["type.text"]):
            if r["scoringPlay"] is True and (r["type.text"] or "") not in known:
                d = None if r["end.pos_score_diff"] is None or r["start.pos_score_diff"] is None \
                    else r["end.pos_score_diff"] - r["start.pos_score_diff"]
                _REC.append([r["id"], r["type.text"], r["text"], r["text"] is None, True, d, t, new])
        return out

    M._type_espn_scored_rows = hook


def run(gid):
    import sportsdataverse.cfb.cfb_pbp as M

    _REC.clear()
    try:
        p = M.CFBPlayProcess(gameId=gid, path_to_json=str(RAW))
        p.join_participants = False
        p.cfb_pbp_disk()
        p.run_processing_pipeline()
    except Exception:
        return []
    return [[gid, *r] for r in _REC]


if __name__ == "__main__":
    listed = [int(x) for x in (HERE / "parity_scored_games.txt").read_text().split() if x.isdigit()]
    games = list(dict.fromkeys(PICKED + listed))
    with mp.get_context("spawn").Pool(6, initializer=_install) as pool:
        rows = [r for rs in pool.map(run, games) for r in rs]
    sha = subprocess.check_output(["git", "-C", SDV_PY, "rev-parse", "--short", "HEAD"]).decode().strip()
    with open(OUT / "scored_oracle.csv.gz", "wb") as fh_raw, gzip.GzipFile(fileobj=fh_raw, mode="wb", mtime=0) as gz:
        fh = io.TextIOWrapper(gz, encoding="utf-8", newline="")
        w = csv.writer(fh, lineterminator="\n")
        w.writerow(COLS)
        w.writerows(rows)
        fh.flush()
        fh.detach()
    print("games", len(games), "rows", len(rows), "retyped", sum(r[2] != r[8] for r in rows), "sdv-py", sha)
