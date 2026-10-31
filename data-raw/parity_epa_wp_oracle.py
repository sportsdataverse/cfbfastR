"""Re-capture cfbfastR's EP/EPA/WP parity oracle from sdv-py (offline, raw payloads on disk).

Runs ``CFBPlayProcess.run_processing_pipeline()`` on banked ESPN summaries and writes one row per
play: the model-input state sdv-py scored (start and end), sdv-py's published EP_start / EP_end /
EPA / wp_before_naive / wp_before, and the two WP boosters' raw output on that start state scored
through sdv-py's own path (``_as_trained_2h_flag`` then the booster) without the overtime stage
(``cfb_wp_overtime.adjust_wp``), which cfbfastR has not ported. ``test-parity_epa_wp.R`` replays
cfbfastR's scoring stage on the inputs.

    python data-raw/parity_epa_wp_oracle.py            # the committed games
    python data-raw/parity_epa_wp_oracle.py --all OUT  # every fixture game, to OUT (not committed)

Env: ``SDV_PY_ROOT`` (sdv-py checkout), ``CFB_RAW_JSON`` (cfbfastR-cfb-raw ``cfb/json/raw``).
Do not hand-edit the output.
"""

import datetime, gzip, json, os, pathlib, re, subprocess, sys

SDV_PY = os.environ.get("SDV_PY_ROOT", "/mnt/sdv_repos/sportsdataverse-py")
sys.path.insert(0, SDV_PY)
import numpy as np
import polars as pl
from xgboost import DMatrix
import sportsdataverse.cfb.cfb_pbp as cp
from sportsdataverse.cfb import CFBPlayProcess

RAW = os.environ.get("CFB_RAW_JSON", "/mnt/sdv_repos/cfbfastR-cfb-raw/cfb/json/raw")
FIX = (
    pathlib.Path(__file__).resolve().parents[1]
    / "tests"
    / "testthat"
    / "fixtures"
    / "parity"
)
# Six fixture games with a real pre-game line (sdv-py invents one otherwise, cfbfastR leaves NA),
# 2013-2025, three where the home team kicked off first (333302459, 401110831, 401752665: the
# true 2H flag != 1 - is_home on every first-half row) and three where the away team did.
GAMES = [333302459, 400547719, 401110831, 401282116, 401520401, 401752665]

# published column -> oracle column
COLS = {
    "id": "id_play",
    "season": "season",
    "period": "period",
    "homeTeamId": "home_id",
    "start.pos_team.id": "pos_team_id",
    "gameSpreadAvailable": "game_spread_available",
    "start.TimeSecsRem": "TimeSecsRem",
    "start.adj_TimeSecsRem": "adj_TimeSecsRem",
    "start.down": "down",
    "start.distance": "distance",
    "start.yardsToEndzone": "yards_to_goal",
    "pos_score_diff_start": "pos_score_diff_start",
    "start.posTeamTimeouts": "pos_team_timeouts_rem_before",
    "start.defPosTeamTimeouts": "def_pos_team_timeouts_rem_before",
    "start.pos_team_receives_2H_kickoff": "pos_team_receives_2H_kickoff",
    "start.is_home": "is_home",
    "start.ExpScoreDiff_Time_Ratio": "ExpScoreDiff_Time_Ratio",
    "start.spread_time": "spread_time",
    "start.pos_team_spread": "pos_team_spread",
    "end.TimeSecsRem": "end_TimeSecsRem",
    "end.yardsToEndzone": "end_yards_to_goal",
    "end.distance": "end_distance",
    "pos_score_diff_end": "end_pos_score_diff",
    "EP_start": "EP_start",
    "EP_end": "EP_end",
    "EPA": "EPA",
    "wp_before_naive": "wp_before_naive",
    "wp_before": "wp_before",
}
ONEHOT = {
    "ep_down": ["down_1", "down_2", "down_3", "down_4"],
    "ep_end_down": ["down_1_end", "down_2_end", "down_3_end", "down_4_end"],
}


def booster_raw(df, model, src_cols, names):
    """sdv-py's _wp_predict on the published start state, minus the overtime stage."""
    x = df.select(src_cols)
    x.columns = names
    return model.predict(DMatrix(cp._as_trained_2h_flag(x))).astype(np.float64)


def ep_raw(p, df, src_cols):
    """sdv-py's EP scoring (ep_model, then its class-to-points expectation) on a published state.

    The published EP_start / EP_end are this value AFTER the pipeline's rules (possession flips,
    scores), so they are kept for reference and these are what a scoring-stage replay compares to.
    """
    x = df.select(src_cols)
    x.columns = cp.ep_final_names
    return p._CFBPlayProcess__calculate_ep_exp_val(cp.ep_model.predict(DMatrix(x))).astype(np.float64)


def game_frame(gid):
    p = CFBPlayProcess(gameId=gid, path_to_json=RAW)
    p.join_participants = False
    p.cfb_pbp_disk()
    plays = p.run_processing_pipeline()["plays"]
    if not plays:  # sdv-py leaves a feed it will not model unprocessed
        return None
    src = (
        list(COLS)
        + [c for v in ONEHOT.values() for c in v]
        + ["end.homeScore", "end.awayScore"]
    )
    full = pl.DataFrame(
        [{c: r.get(c) for c in src} for r in plays], infer_schema_length=None
    )
    naive = booster_raw(
        full, cp.wp_naive_model, cp.wp_naive_start_columns, cp.wp_naive_final_names
    )
    spread = booster_raw(full, cp.wp_model, cp.wp_start_columns, cp.wp_final_names)
    ep_start, ep_end = ep_raw(p, full, cp.ep_start_columns), ep_raw(p, full, cp.ep_end_columns)
    last = full.tail(1)
    home_won = int(last["end.homeScore"][0]) > int(last["end.awayScore"][0])
    out = (
        full.select([pl.col(k).alias(v) for k, v in COLS.items()])
        .with_columns(
            pl.lit(str(gid)).alias("game_id"),
            *[pl.col(c).cast(pl.Utf8) for c in ("id_play", "home_id", "pos_team_id")],
            # the down EP was scored on: the hot one-hot (0 = none), as sdv-py resets them apart from start.down
            *[
                sum(
                    (full[c].cast(pl.Int64).fill_null(0) * (i + 1))
                    for i, c in enumerate(cs)
                ).alias(k)
                for k, cs in ONEHOT.items()
            ],
            pl.Series("wp_naive_raw", naive),
            pl.Series("wp_spread_raw", spread),
            pl.Series("ep_start_raw", ep_start),
            pl.Series("ep_end_raw", ep_end),
        )
        .with_columns(
            ((pl.col("pos_team_id") == pl.col("home_id")) == home_won)
            .cast(pl.Int8)
            .alias("pos_team_won"),
        )
    )
    lead = ["game_id", "id_play"]
    return out.select(lead + [c for c in out.columns if c not in lead])


def main():
    if len(sys.argv) > 1 and sys.argv[1] == "--all":
        fg = json.load(open(FIX / "fixture_games.json"))
        ids, dest = (
            [g["game_id"] for s in fg.values() for g in s],
            pathlib.Path(sys.argv[2]),
        )
    else:
        ids, dest = GAMES, FIX / "epa_wp_oracle.csv.gz"
    frames, missing = [], []
    for gid in ids:
        if not pathlib.Path(f"{RAW}/{gid}.json").exists():
            missing.append(gid)
            continue
        g = game_frame(gid)
        if g is None:
            missing.append(gid)
            continue
        frames.append(g)
    oracle = pl.concat(frames, how="diagonal_relaxed")
    with gzip.GzipFile(dest, "wb", compresslevel=9, mtime=0) as fh:
        oracle.write_csv(fh, float_precision=10)
    sha = (
        subprocess.check_output(
            ["git", "-C", SDV_PY, "describe", "--always", "--dirty", "--abbrev=10"]
        )
        .decode()
        .strip()
    )
    flip = oracle.filter(
        pl.col("pos_team_receives_2H_kickoff").cast(pl.Int8)
        != (1 - pl.col("is_home").cast(pl.Int8))
    )
    print(
        "games",
        oracle["game_id"].n_unique(),
        "rows",
        oracle.height,
        "rows flag != 1-is_home",
        flip.height,
        "missing raw",
        missing,
        "sdv-py",
        sha,
        "->",
        dest,
    )
    if dest.parent != FIX:
        return
    section = f"""`epa_wp_oracle.csv.gz` — captured {datetime.date.today()} from sportsdataverse-py `{sha}`
(`CFBPlayProcess.run_processing_pipeline()` run offline on the ESPN summary payloads banked in
cfbfastR-cfb-raw `cfb/json/raw/`, `join_participants = False`). One row per play of six games with
a real pre-game line ({", ".join(map(str, GAMES))}; 2013-2025, three where the home team kicked
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
data-raw/parity_epa_wp_oracle.py` (env `SDV_PY_ROOT`, `CFB_RAW_JSON`); do not hand-edit the file."""
    readme = FIX / "README.md"
    text = readme.read_text(encoding="utf-8")
    pat = re.compile(
        r"`epa_wp_oracle\.csv\.gz` — .*?(?=\n\n`[\w.]+`(?: \+ `[\w.]+`)? — |\Z)", re.S
    )
    new = (
        pat.sub(lambda _: section, text, count=1)
        if pat.search(text)
        else text.rstrip("\n") + "\n\n" + section + "\n"
    )
    readme.write_text(new, encoding="utf-8", newline="\n")


if __name__ == "__main__":
    main()
