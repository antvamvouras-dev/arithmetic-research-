# DHMC-001 — Deterministic vs Monte Carlo for Residue-Augmented Prime-Gap Nulls

**Status:** preregistration / implementation pending  
**Primary goal:** determine exactly which quantities in the finite-state arithmetic null benchmark can be computed deterministically, and quantify the remaining need for Monte Carlo.

## 1. Scientific question
Given a fitted first-order finite-state process with state

X_t = (B_t, R_t mod m),

where B_t is a prime-gap bin and the residue updates consistently with the sampled/represented gap, can matrix/DP calculations reproduce the moments and distributions currently estimated by synthetic trajectories?

This experiment does **not** test RH, curvature, or a manifold hypothesis.

## 2. Frozen initial scope
- Prime upper scale: N = 10^7.
- Four chronological windows, matching the established benchmark when code/data are reconstructed.
- Gap-bin resolutions: 16 and 32.
- Residue moduli: m = 6 and m = 30.
- Chronological train/test split: 50/50 unless the reconstructed canonical benchmark proves a different frozen split was used.
- Larger m (210, 2310) are excluded from the primary benchmark because prior calibration showed sparse augmented-state failure.

## 3. Models
M1: gap-bin first-order model P(B_{t+1}|B_t).

M2(m): residue-augmented first-order model P(B_{t+1}|B_t,R_t mod m), with deterministic residue update whenever the exact gap representation permits it.

The implementation must document whether binning loses information needed for exact residue updates. If so, the state must be augmented with exact gap information or the approximation must be explicitly labelled.

## 4. Deterministic route
Construct the finite transition operator T on reachable states. Compute where mathematically valid:
- propagated state occupancy p_t = p_0 T^t;
- expected state and transition counts;
- stationary distribution when appropriate and diagnosed;
- expectations of additive functionals;
- variance/covariance of additive functionals using finite-state Markov methods;
- exact or DP-derived finite-horizon distributions for selected low-dimensional statistics when tractable.

No stationarity assumption may replace the chronological finite-horizon calculation without a documented mixing/convergence check.

## 5. Monte Carlo route
Generate independent synthetic trajectories from exactly the same fitted model and initial-state convention. Planned comparison levels: 100, 1,000, and 10,000 trajectories, subject to compute budget. Fixed seed manifests are required.

## 6. Primary comparison quantities
For each window × bins × modulus:
- state occupancy;
- transition counts;
- selected additive log-score mean;
- score variance;
- runtime;
- peak memory;
- Monte Carlo standard error;
- deterministic-vs-MC discrepancy normalized by MC uncertainty.

Where the full cross-fitted ΔL requires refitting on each synthetic sample, decompose:

ΔL variability = trajectory variability + estimator/refit variability + interaction.

The first task is to identify which component can be eliminated analytically rather than assuming the full statistic is exactly tractable.

## 7. Validation gates
A deterministic result is accepted only after:
1. row-stochasticity / probability-mass checks;
2. reachable-state audit;
3. residue-update consistency test;
4. agreement with small-state brute-force enumeration;
5. agreement with high-replica Monte Carlo within predeclared uncertainty tolerance.

## 8. Success criteria
**Strong success:** deterministic/DP computation replaces MC for the target statistic or its dominant uncertainty component with controlled numerical error and substantial runtime reduction.

**Partial success:** exact computation replaces only expectations/occupancies while MC remains necessary for refitting/tails.

**Negative result:** deterministic state expansion becomes intractable or does not reproduce the intended null. This is still informative and must be reported.

## 9. Outputs
- `config.json`
- `manifest.json`
- compact result table (`csv`)
- validation report
- runtime benchmark
- one script/notebook reproducing the comparison

## 10. Claim boundary
No speedup factor is claimed before benchmark execution. No comparison to GEANT4/Pythia/MadGraph is licensed by this experiment; HEP is a later benchmark ladder only after the method is established on controlled finite-state systems.
