# CoCalc ↔ ChatGPT Handoff — 2026-09-14

Branch: `cocalc-replication-v2`
Base: `emergence-threshold-v2`

## What has already been measured

The current research target is a small previous-gap predictive residual in consecutive prime gaps after conditioning on a strong explicit arithmetic null.

Current null family:
- exact local congruence admissibility through primes 2,3,5,7,11,13,17,19,23,29,31,37,41,43;
- endpoint and intermediate prime-free admissibility up to gap 180;
- unresolved primes 47..97 enter via pair/triple singular-series factors;
- beta=6, six frozen gap bins, actual local log(p);
- global marginal calibration before history;
- hierarchical history shrinkage tau=2000.

Headline results measured in ChatGPT execution environment:

1. Internal chronological 1b–1.001b test
   - history increment: +0.000741813543 nats/transition
   - 95% block-bootstrap CI: [+0.000356153482, +0.001137213549]

2. Internal chronological 100m–101m test
   - history increment: +0.000828020619
   - 95% CI: [+0.000404445877, +0.001190613101]

3. Locked cross-scale transfer 1b -> 100m, with history learned at 1b and no history refit on 100m
   - history increment: +0.001849329239
   - 95% CI: [+0.001602166041, +0.002074442285]

Earlier negative controls:
- raw nonzero strain E[K^2] failed null calibration;
- residual state-space topology not detected;
- path-space geometry with Euclidean, Jensen-Shannon, Hellinger and Fisher-Rao metrics did not beat shuffled-geometry controls;
- therefore NO geometry/curvature claim is currently accepted.

## What CoCalc should do now

Run an independent reproduction. Do NOT tune parameters after seeing reference values.

Inputs required:
- `1b-1,001b_data.xlsx`
- `100-101_data.xlsx`

Use the frozen replication script supplied with the project:
- `cocalc_strong_local_sieve_history_v2.py`

Command:

```bash
python cocalc_strong_local_sieve_history_v2.py \
  --dev "1b-1,001b_data.xlsx" \
  --fresh "100-101_data.xlsx" \
  --out cocalc_replication_v2.json
```

## What CoCalc must report

Create `results/COCALC_REPLICATION_v2.json` containing:
- Python version;
- numpy version;
- pandas version;
- platform / OS;
- SHA256 of both XLSX inputs;
- SHA256 of the exact script executed;
- all three headline history increments;
- all three 95% bootstrap intervals;
- explicit PASS/FAIL for each test;
- any warning, exception, dependency change, or numerical mismatch.

PASS rule is preregistered:
- each history increment > 0;
- each 95% lower bound > 0.

Reference numbers are verification targets only, not tuning targets.

## Next experiment after replication

If replication passes, freeze the protocol before opening any new dataset and test at least one additional untouched range. The scientific question is:

`I(g_{t-1}; g_t | strongest explicit classical arithmetic state) > 0 ?`

Then strengthen the classical null further with larger exact local sieve and more controlled higher-order inclusion-exclusion. Any surviving residual remains a conditional predictive residual; do not call it a new law or geometry unless separate tests justify that.

## Git workflow

Repository: `antvamvouras-dev/arithmetic-research-`
Branch for CoCalc: `cocalc-replication-v2`

In CoCalc:

```bash
git clone https://github.com/antvamvouras-dev/arithmetic-research-.git
cd arithmetic-research-
git checkout cocalc-replication-v2
```

If already cloned:

```bash
git fetch origin
git checkout cocalc-replication-v2
git pull origin cocalc-replication-v2
```

After independent execution, save results under `results/` and commit only code/results/protocol metadata; do not commit huge raw XLSX files unless explicitly intended.

Suggested commit:

```bash
git add results/COCALC_REPLICATION_v2.json
git commit -m "Independent CoCalc replication of strong local sieve history test"
git push origin cocalc-replication-v2
```

Once pushed, ChatGPT can read that result from GitHub and compare it with the archived reference without manual copy-paste.
