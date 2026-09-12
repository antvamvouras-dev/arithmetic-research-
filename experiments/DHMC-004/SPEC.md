# DHMC-004 — Survival beyond richer wheel baselines

## Question
Do the residual contexts identified after the mod-30 wheel correction survive richer deterministic arithmetic baselines?

## Data
- Primes up to `N = 10^7`.
- Four equal chronological non-overlapping windows over the gap sequence.
- Per window: first 50% train pool, second 50% untouched test.
- Train pool split 80/20 into fit/validation.

## Models
For modulus `m in {210,2310}`:

- Base model: `P0(g_next | g_current)` with additive smoothing.
- Deterministic wheel baseline: restrict `P0` to gaps satisfying `gcd((r+g_next) mod m,m)=1`, then renormalize.
- Residue-aware correction: empirical `P(g_next | g_current, r mod m)` on the same admissible support, shrunk toward the deterministic wheel with `lambda=n/(n+tau)`.

Hyperparameters `alpha` and `tau` are chosen only on validation. Final test is untouched until evaluation.

## Primary statistics
1. Held-out wheel gain over base.
2. Held-out residual gain `K_m = log(P_residue/P_wheel)`.
3. Positive-window count across four windows.
4. Survival of the 12 dominant `(g,r mod 30)` contexts from DHMC-003 after projecting the richer-model residual back to mod-30 context space.
5. Concentration of residual contributions after the richer baselines.

## Interpretation rule
A positive residual after mod 210 or 2310 means only that the learned residue-conditioned frequencies improve prediction beyond that finite wheel baseline. It is not evidence of curvature, geometry, a new prime law, or asymptotic structure by itself.

## Important limitation
The `m=2310` learned state space is sparse. Validation-tuned shrinkage and exact fallback to the deterministic wheel are therefore mandatory. Sparse-state behavior must be reported rather than hidden.
