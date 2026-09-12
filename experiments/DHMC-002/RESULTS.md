# DHMC-002 — Results

## Dataset
- N = 10,000,000
- primes = 664,579
- gaps = 664,578
- four equal chronological non-overlapping windows
- per window: first 50% train pool, second 50% untouched test
- train pool internally split 80/20 for hyperparameter selection

## Final held-out results

| Window | m | alpha | tau | n_test_used | wheel gain | residual gain over wheel | residual SE |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | 6 | 0.25 | 100 | 83,050 | 0.157653 | 0.021178 | 0.000747 |
| 1 | 30 | 0.25 | 200 | 83,050 | 0.386932 | 0.028090 | 0.000874 |
| 2 | 6 | 0.25 | 50 | 83,064 | 0.154485 | 0.023439 | 0.000768 |
| 2 | 30 | 0.25 | 200 | 83,064 | 0.378093 | 0.030806 | 0.000860 |
| 3 | 6 | 0.25 | 50 | 83,058 | 0.152658 | 0.025388 | 0.000777 |
| 3 | 30 | 0.25 | 200 | 83,058 | 0.375951 | 0.033213 | 0.000871 |
| 4 | 6 | 0.25 | 20 | 83,065 | 0.153775 | 0.024252 | 0.000790 |
| 4 | 30 | 0.25 | 200 | 83,065 | 0.376253 | 0.031005 | 0.000861 |

No observed test transition was impossible under the corresponding wheel baseline.

## Across-window summary

### m = 6
- mean wheel gain: 0.154643 nats/transition
- SD across windows: 0.002143
- mean residual gain beyond wheel: 0.023564 nats/transition
- SD across windows: 0.001780
- positive residual windows: 4/4

### m = 30
- mean wheel gain: 0.379307 nats/transition
- SD across windows: 0.005170
- mean residual gain beyond wheel: 0.030778 nats/transition
- SD across windows: 0.002098
- positive residual windows: 4/4

## Interpretation
The dominant contribution is finite-wheel admissibility. However, after forcing the learned model to respect the exact same admissible support and shrinking it toward the wheel baseline, a small but reproducible held-out gain remains in all four chronological windows for both m=6 and m=30.

This is qualitatively stronger than comparing a raw residue model against a gap-only model, because the residual model is required to improve on arithmetic admissibility rather than rediscover it.

The result supports the narrow statement:

> At N <= 10^7, in an exact-gap first-order model, residue-conditioned transition frequencies contain reproducible held-out predictive information beyond finite-wheel admissibility for m=6 and m=30.

It does NOT show that this residual is asymptotic, geometrical, curvature-like, independent of other sieve effects, or unexplained by a richer finite arithmetic model.

## Next checks before promoting the claim
1. Replace the per-transition naive SE by a dependence-aware uncertainty estimate (block bootstrap or long-run variance).
2. Test nested moduli 2, 6, 30, 210 with identical protocol, while watching sparsity.
3. Compare against a richer deterministic finite-sieve baseline, not only one-step admissibility.
4. Repeat at multiple N to determine whether the residual shrinks, stabilizes, or grows.
5. Decompose the residual by (g_t, r_t) context to see whether it is diffuse or concentrated in a small set of transitions.

## Epistemic status
EMPIRICAL — reproducible finite-N held-out result. Not a theorem and not yet a new prime law.
