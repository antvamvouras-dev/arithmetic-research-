# PRIME TOPOLOGY → GEOMETRY → PREDICTIVE-LAW TEST v1
Date: 2026-09-14
Status: REPRODUCIBLE EXPLORATORY / VERIFY

## Question
After subtracting the strongest currently implemented arithmetic null (Q=2310 wheel + pair singular-series weight + triple-informed prime-free-interval survival, beta=6, gamma calibrated as in v3), does the remaining prime residual support:

1. persistent residual topology,
2. a reproducible residual metric geometry,
3. a geometry-based held-out predictive law?

## Important strengthening relative to v3
The reconstructed null uses the actual local log(p) for each transition rather than one representative log(p) for an entire range.

No topology or geometry is inferred from the raw prime process. It is inferred only from residuals after the arithmetic null has been removed.

## Protocol A — residue residual geometry
For each Q=2310 residue context:
- observed held-out/train binned gap counts were compared with the v3 null expectation;
- a shrinkage log residual vector was formed;
- pairwise Euclidean residual distances define a candidate metric;
- H0 persistence is summarized by MST edge statistics;
- geometry reproducibility is measured by correlation of distance matrices built from two independent train halves;
- null calibration uses synthetic next-gap outcomes drawn from the same arithmetic null;
- a kNN-smoothed residual-geometry correction is evaluated on chronological held-out data.

## Protocol B — history-context geometry
Because the only residual that survived v3 at 1e9 was previous-gap history, a second test used contexts:
    (p mod 210, previous-gap bin)
while the predictive baseline remained the full Q=2310 higher-order arithmetic null.

The same topology, geometry-stability, null-calibration, and held-out prediction tests were applied.

## Protocol C — direct history consistency check
To verify that the reconstructed arithmetic null still reproduces the old v3 phenomenon, a simple previous-gap multiplicative correction was fitted on training data and evaluated held-out.

## Headline results

| range     |   residue_geom_rho_z |   residue_topology_z |   residue_geom_gain |   history_ctx_geom_rho_z |   history_ctx_topology_z |   history_ctx_geom_gain |   direct_history_gain |   direct_history_lo |   direct_history_hi |
|:----------|---------------------:|---------------------:|--------------------:|-------------------------:|-------------------------:|------------------------:|----------------------:|--------------------:|--------------------:|
| 1m-2m     |             0.627920 |            -0.601645 |           -0.005747 |                -2.989092 |                -0.321917 |               -0.002942 |              0.000236 |           -0.000148 |            0.000644 |
| 10m-11m   |            -0.240490 |            -0.566689 |           -0.004727 |                 2.294350 |                -0.804889 |               -0.003424 |              0.000190 |           -0.000330 |            0.000662 |
| 1b-1.001b |             0.489155 |            -1.004254 |           -0.003152 |                -0.824605 |                -0.247146 |               -0.004526 |              0.001441 |            0.000737 |            0.002221 |

## Direct-history consistency result
The reconstructed null reproduces the previous v3 qualitative result:

- 1m–2m: history gain is compatible with zero.
- 10m–11m: history gain is compatible with zero.
- 1b–1.001b: a small positive history gain survives.

At 1b–1.001b:
    G_history ≈ +0.001441 nats/transition
    95% block-bootstrap CI ≈ [+0.000737, +0.002221]

Thus the negative geometry result is NOT caused by accidentally erasing the previously observed 1e9 history residual.

## Main result
Across all three ranges:

- no significant excess H0 residual topology was found relative to arithmetic-null surrogates;
- no robust reproducible residual geometry was found;
- geometry-smoothed residual models LOST held-out log likelihood relative to the arithmetic null;
- direct previous-gap correction still improves prediction at 1e9.

Therefore, under this protocol:

    predictive residual at 1e9: YES
    residual topology: NO EVIDENCE
    residual geometry: NO EVIDENCE
    geometry-based predictive law: REJECTED

for the tested residual representations.

## Critical interpretation
This result separates three claims that had previously been easy to conflate:

1. "There is residual predictive information."
2. "The residual has stable topology/geometry."
3. "That geometry explains/predicts the residual."

The current data support (1) at 1e9 against the v3 null, but do not support (2) or (3).

This is an important negative result.

It means a small history residual does not automatically justify manifold, curvature, fluid, or geometric language.

## What remains possible
The negative result is representation-specific, not a theorem of impossibility.

Possible reasons a true residual geometry could remain hidden:
- the context representation (residue class + binned history) may be too coarse;
- Euclidean distance on residual log-ratio vectors may be the wrong metric;
- H0/MST persistence may miss H1 or higher-order structure;
- the v3 null is approximate, not exact full k-tuple inclusion-exclusion;
- geometry may live in sequence/path space rather than state space;
- a nonlocal or spectral geometry could exist without local cluster topology.

Any stronger geometry claim must beat this negative baseline.

## Revised emergence ladder for the prime project

Arithmetic constraints
  -> strongest classical null
  -> residual predictive information
  -> [TEST] persistent residual topology
  -> [TEST] reproducible metric geometry
  -> [TEST] geometry-based held-out prediction
  -> invariant/scaling theorem
  -> only then curvature/law language

Current status:
- strongest approximate classical null: ACTIVE / IMPROVE
- 1e9 residual predictive information: ACTIVE / VERIFY
- residual topology: NOT DETECTED in v1
- residual geometry: NOT DETECTED in v1
- geometry-based law: REJECTED in v1
- curvature: NOT PROMOTED

## Next decisive tests
1. Replace H0-only topology with persistent H1/H2 using a proper TDA implementation.
2. Test information-geometric metrics (Jensen-Shannon, Hellinger, Fisher-Rao approximations) instead of Euclidean residual-vector distance.
3. Test path-space geometry on sequences of 2–4 gaps, not only state/context geometry.
4. Strengthen the arithmetic null toward full k-tuple / controlled inclusion-exclusion and extend the wheel.
5. Evaluate fresh disjoint prime ranges.
6. If residual survives stronger nulls, test scale-transfer without refitting.

The burden of proof has now shifted:
a future "prime geometry" must explain held-out data better than the arithmetic null and better than this failed residual-geometry baseline.
