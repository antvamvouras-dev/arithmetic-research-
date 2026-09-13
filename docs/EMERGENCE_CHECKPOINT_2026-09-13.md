# Emergence Threshold Research — Checkpoint 2026-09-13

## EMERG-001: Potential Neighborhood -> topology sanity benchmark

Synthetic weighted potential neighborhoods were thresholded into Erdos-Renyi graphs.

- n = 500
- replicates = 200
- theoretical giant-component threshold p_c ≈ 1/n = 0.002000
- empirical 10% giant onset mean = 0.002054
- SD = 0.000190

Interpretation: the PN formalism detects a known topological phase transition at the expected scale.

## EMERG-002: Null-calibrated prime strain

Headline correction: non-zero E[K^2] is not by itself evidence of residual geometry.
Conditional permutations preserve the current-gap state while breaking previous-gap history.

| Range | E real | E null mean | ratio | excess |
|---|---:|---:|---:|---:|
| 1m-2m | 0.010260 | 0.010432 | 0.984 | -0.000172 |
| 10m-11m | 0.007303 | 0.007398 | 0.987 | -0.000096 |
| 1b-1.001b | 0.007659 | 0.007700 | 0.995 | -0.000041 |

All three real E values are at or below the permutation-null expectation.
Therefore the previous interpretation "stable non-zero strain implies real residual geometry" is rejected for this estimator.

## Promotion rule

Only excess strain, E_excess = E_real - E_null, or a divergence against a calibrated null may be treated as an empirical emergence observable.

## Next experiments

1. Repeat PN benchmark on SBM/percolation/Ising-like systems.
2. Define persistent-homology observables across PN threshold.
3. Build arithmetic PN from the strongest classical null and compare topology real vs calibrated surrogates.
4. Test operator-basis necessity by ablation across synthetic symbolic systems.
