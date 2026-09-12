# DHMC-001 — First Deterministic Measurement (N = 1,000,000)

Date: 2026-09-12

## Dataset
- primes <= 1,000,000: 78,498
- gaps: 78,497
- chronological split: 50/50
- training transitions: 39,247
- held-out transitions used: 39,241

## A. Exact-gap first-order model vs residue-aware first-order model

Model 1: P(g_{t+1} | g_t)

Model 2: P(g_{t+1} | g_t, p_{t+1} mod m)

Additive smoothing alpha = 0.5. Unseen residue contexts back off to Model 1.

| m | LL gap | LL gap+residue | gain (nats/transition) | SE | fallback rate |
|---:|---:|---:|---:|---:|---:|
| 2 | -2.566833 | -2.566833 | 0.000000 | 0.000000 | 0.000178 |
| 6 | -2.566833 | -2.396204 | 0.170629 | 0.001535 | 0.000357 |
| 30 | -2.566833 | -2.196480 | 0.370354 | 0.002053 | 0.001019 |

Sanity check: m=2 gives no gain because, after the exceptional prime 2, odd-prime parity contributes no varying residue state.

## B. Deterministic wheel-admissibility baseline

Wheel model:

P_W(g' | g,r) proportional to P_1(g'|g) * 1[g' sends residue r to a residue coprime to m].

This uses no learned residue-specific transition frequencies beyond the first-order gap model; it only renormalizes over wheel-admissible next gaps.

| m | wheel gain | learned residue gain | learned - wheel |
|---:|---:|---:|---:|
| 6 | 0.162855 | 0.170629 | +0.007774 |
| 30 | 0.396206 | 0.370354 | -0.025853 |

Standard errors:
- m=6: wheel gain SE 0.000913; residual SE 0.001171
- m=30: wheel gain SE 0.001040; residual SE 0.001776

## Interpretation

1. The large predictive gain from residue state is mostly arithmetic admissibility, not evidence of a new dynamical law.
2. For m=6, learned residue-specific frequencies improve slightly beyond pure wheel filtering on this split.
3. For m=30, pure wheel filtering outperforms the learned residue-conditioned model. This is consistent with sparsity/overfitting in larger residue state spaces and with previous calibration concerns.
4. This is a useful deterministic replacement for one class of Monte-Carlo comparisons: before generating synthetic paths, compare the observed model directly with the exact finite-wheel admissibility baseline.
5. The next benchmark should scale this exact comparison to N=10^7, four chronological windows, and preselected m=6,30; then compare against the synthetic M2(m) null only where sampling is still needed.

## Important caveat on the historical binned Delta L reproduction

A quick binned second-order implementation produced effective bin counts smaller than the requested 8/16/32 because prime gaps are discrete and quantile edges collapse. Its numerical Delta L therefore does not reproduce the historical pipeline exactly and should not be compared directly until the original binning convention is reconstructed from the canonical code/config.
