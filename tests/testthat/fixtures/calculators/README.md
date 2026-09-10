# Cross-language calculator parity fixture

`inputs.csv` is a four-row frame spanning all four rule eras (2005, 2013, 2018,
2024) and carrying every column the calculators need. `python_outputs.csv` holds
what `sportsdataverse-py` produces for it.

**Generated from sportsdataverse-py `e60c6df79`** (branch
`fix/cfb-fourth-down-output`). Regenerate only from that commit or later, and
record the new SHA here: a fixture without provenance cannot be reproduced or
trusted.

Both languages read the SAME published model cards from the `cfb_model_artifacts`
bundle, so a divergence here means one of them derives features differently.
That is exactly the class of bug that let cfbfastR-cfb-data#70 sit unnoticed
across two consumers: both kept a private copy of the era cuts and both drifted
to a boundary the trainer never used.

Covers seven calculators and 20 output columns: field goal, xpass, two-point,
completion probability, fourth down, QBR, and expected points (its seven class
probabilities plus `ep`), along with the derived era columns.

The EP class columns are written under R's `.EP_LEV` names (`TD`, `Opp_TD`,
`FG`, ...). Python names them `td_prob`, `opp_td_prob`, `fg_prob`, ...; the
generator renames them so the fixture is directly comparable and the parity test
needs no translation table. The two languages genuinely order the classes
differently and each applies the bundle's own permutation, which is why the
values agree despite the naming.

To regenerate, see the block in
`sportsdataverse-py/docs/superpowers/plans/2026-09-09-cfb-model-calculators-r.md`.
